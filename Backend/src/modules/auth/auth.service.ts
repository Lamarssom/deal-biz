import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { EmailService } from '../email/email.service';
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
  constructor(
    private usersService: UsersService,
    private merchantsService: MerchantsService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private emailService: EmailService,
  ) {}

  private generateVerificationCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  async register(dto: RegisterDto) {
    const existingUser = await this.usersService.findOneWithPassword(dto.email );
    const existingMerchant = await this.merchantsService.findOne({ where: { email: dto.email } });

    if (existingUser || existingMerchant) {
      throw new BadRequestException('Email already registered');
    }

    if (dto.role === 'CUSTOMER') {
      const hashed = await bcrypt.hash(dto.password, 10);
      const user = this.usersService.create({ email: dto.email, password: hashed, role: 'CUSTOMER' });
      await this.usersService.save(user);
      return this.login({ email: dto.email, password: dto.password });
    }

    // Merchant
    const hashed = await bcrypt.hash(dto.password, 10);
    const code = this.generateVerificationCode();
    const merchant = this.merchantsService.create({
      email: dto.email,
      password: hashed,
      role: 'MERCHANT',
      businessName: dto.businessName,
      category: dto.category,
      verificationCode: code,
      verificationExpiresAt: new Date(Date.now() + 15 * 60 * 1000),
    });
    await this.merchantsService.save(merchant);

    // DEV: log verification code
    if (this.configService.get('NODE_ENV') !== 'production') {
      console.log('Merchant verification code:', code);
    }

    // Send email
    setImmediate(() => {
      this.emailService.sendVerificationEmail(dto.email, code);
    });
    return { message: 'Merchant registered. Check email for verification code.' };
  }

  async login(dto: LoginDto) {
    let entity: any = await this.usersService.findOneWithPassword(dto.email );
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
    if (!merchant) throw new BadRequestException('Email not found');

    if (merchant.verificationCode !== dto.code || 
        (merchant.verificationExpiresAt && merchant.verificationExpiresAt < new Date())) {
      throw new BadRequestException('Invalid or expired code');
    }

    merchant.isVerified = true;
    merchant.verificationCode = null;
    merchant.verificationExpiresAt = null;
    await this.merchantsService.save(merchant);

    return { message: 'Merchant email verified successfully' };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const user =
      (await this.usersService.findOneWithPassword(dto.email)) ||
      (await this.merchantsService.findOne({ where: { email: dto.email } }));

    if (!user) throw new BadRequestException('Email not found');

    const token = this.jwtService.sign(
      { sub: user.id, email: dto.email },
      { secret: this.configService.get('JWT_SECRET'), expiresIn: '15m' },
    );

    if (this.configService.get('NODE_ENV') !== 'production') {
      console.log('Password reset token:', token);
    }

    setImmediate(() => {
      this.emailService.sendPasswordReset(dto.email, token);
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