import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import * as nodemailer from 'nodemailer';
import { ConfigService } from '@nestjs/config';
import { User } from '../../entities/user.entity';
import { Merchant } from '../../entities/merchant.entity';
import { RegisterDto } from '../../dtos/register.dto';
import { LoginDto } from '../../dtos/login.dto';
import { VerifyEmailDto } from './dto/verify-email.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { UsersService } from '../users/users.service';
import { MerchantsService } from '../merchants/merchants.service';

@Injectable()
export class AuthService {
  private transporter: nodemailer.Transporter;

  constructor(
    private usersService: UsersService,
    private merchantsService: MerchantsService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {
    this.transporter = nodemailer.createTransport({
      host: this.configService.get('EMAIL_HOST'),
      port: this.configService.get('EMAIL_PORT'),
      secure: false,
      auth: {
        user: this.configService.get('EMAIL_USER'),
        pass: this.configService.get('EMAIL_PASS'),
      },
    });
  }

  private generateVerificationCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  async register(dto: RegisterDto) {
    const hashed = await bcrypt.hash(dto.password, 10);

    if (dto.role === 'CUSTOMER') {
      const user = this.usersService.create({ email: dto.email, password: hashed, role: 'CUSTOMER' });
      await this.usersService.save(user);
      return this.login({ email: dto.email, password: dto.password });
    }

    // Merchant
    let merchant = await this.merchantsService.findOne({ where: { email: dto.email } });
    if (merchant) throw new BadRequestException('Email already registered');

    const code = this.generateVerificationCode();
    merchant = this.merchantsService.create({
      email: dto.email,
      password: hashed,
      role: 'MERCHANT',
      businessName: dto.businessName,
      category: dto.category,
      verificationCode: code,
      verificationExpiresAt: new Date(Date.now() + 15 * 60 * 1000),
    });
    await this.merchantsService.save(merchant);

    // Send verification email
    await this.transporter.sendMail({
      from: this.configService.get('EMAIL_FROM'),
      to: dto.email,
      subject: 'Verify your Deal-Biz Merchant Account',
      html: `<p>Your verification code is: <strong>${code}</strong></p><p>Valid for 15 minutes.</p>`,
    });

    return { message: 'Merchant registered. Check email for verification code.' };
  }

  async login(dto: LoginDto) {
    let entity: any = await this.usersService.findOne({ where: { email: dto.email } });
    if (!entity) entity = await this.merchantsService.findOne({ where: { email: dto.email } });

    if (!entity || !(await bcrypt.compare(dto.password, entity.password))) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (entity.role === 'MERCHANT' && !entity.isVerified) {
      throw new BadRequestException('Please verify your email first');
    }

    const payload = { sub: entity.id, email: entity.email, role: entity.role };
    return {
      accessToken: this.jwtService.sign(payload, {
        secret: this.configService.get('JWT_SECRET'),
        expiresIn: this.configService.get('JWT_EXPIRES_IN'),
      }),
      user: { id: entity.id, email: entity.email, role: entity.role },
    };
  }

  async verifyEmail(dto: VerifyEmailDto) {
    const merchant = await this.merchantsService.findOne({ where: { email: dto.email } });
    if (!merchant || merchant.verificationCode !== dto.code || (merchant.verificationExpiresAt && merchant.verificationExpiresAt < new Date())) {
      throw new BadRequestException('Invalid or expired code');
    }

    merchant.isVerified = true;
    merchant.verificationCode = null;
    merchant.verificationExpiresAt = null;
    await this.merchantsService.
    save(merchant);

    return { message: 'Merchant email verified successfully' };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    // For simplicity we send reset token as JWT (valid 15 min)
    const user = await this.usersService.findOne({ where: { email: dto.email } }) ||
                 await this.merchantsService.findOne({ where: { email: dto.email } });
    if (!user) throw new BadRequestException('Email not found');

    const token = this.jwtService.sign(
      { sub: user.id, email: dto.email },
      { secret: this.configService.get('JWT_SECRET'), expiresIn: '15m' }
    );

    await this.transporter.sendMail({
      from: this.configService.get('EMAIL_FROM'),
      to: dto.email,
      subject: 'Deal-Biz Password Reset',
      html: `<p>Reset your password here: <a href="http://localhost:3000/reset?token=${token}">Reset Password</a></p>`,
    });

    return { message: 'Password reset link sent to email' };
  }

  async resetPassword(dto: ResetPasswordDto) {
    let payload: any;
    try {
      payload = this.jwtService.verify(dto.token, { secret: this.configService.get('JWT_SECRET') });
    } catch {
      throw new BadRequestException('Invalid or expired token');
    }

    const hashed = await bcrypt.hash(dto.newPassword, 10);

    // Update either User or Merchant
    await this.usersService.update({ id: payload.sub }, { password: hashed }).catch(() => {});
    await this.merchantsService.update({ id: payload.sub }, { password: hashed }).catch(() => {});

    return { message: 'Password reset successfully' };
  }
}