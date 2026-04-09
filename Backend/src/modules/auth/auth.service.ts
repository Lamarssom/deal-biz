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
import { LgaService } from '../lga/lga.service';


@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private merchantsService: MerchantsService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private emailService: EmailService,
    private lgaService: LgaService,
  ) {}

  private generateVerificationCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  async register(dto: RegisterDto) {
    const existingUser = await this.usersService.findOne(dto.email);
    let existingMerchant = await this.merchantsService.findOne(dto.email);

    // If user exists, block registration
    if (existingUser) throw new BadRequestException('Email already registered');

    const hashed = await bcrypt.hash(dto.password, 10);

    if (dto.role === 'CUSTOMER') {
      const user = this.usersService.create({ email: dto.email, password: hashed, role: 'CUSTOMER' });
      await this.usersService.save(user);
      return this.login({ email: dto.email, password: dto.password });
    }

    // MERCHANT registration
    const code = this.generateVerificationCode();

    if (existingMerchant) {
      if (existingMerchant.isVerified) {
        throw new BadRequestException('Email already registered');
      }
      // Resend verification for unverified merchant
      existingMerchant.verificationCode = code;
      existingMerchant.verificationExpiresAt = new Date(Date.now() + 15 * 60 * 1000);
      existingMerchant.password = hashed; // optional: update password
      await this.merchantsService.save(existingMerchant);

      if (this.configService.get('NODE_ENV') !== 'production') {
        console.log('Resent merchant verification code:', code);
      }

      setImmediate(() => {
        this.emailService.sendVerificationEmail(dto.email, code);
      });

      return { message: 'Verification code resent. Check email.' };
    }

    const merchant = await this.merchantsService.create({
      email: dto.email,
      password: hashed,
      role: 'MERCHANT',
      businessName: dto.businessName,
      category: dto.category,
      businessLGA: dto.businessLGA,
      verificationCode: code,
      verificationExpiresAt: new Date(Date.now() + 15 * 60 * 1000),
    });
    await this.merchantsService.save(merchant);

    if (this.configService.get('NODE_ENV') !== 'production') {
      console.log('Merchant verification code:', code);
    }

    setImmediate(() => {
      this.emailService.sendVerificationEmail(dto.email, code);
    });

    return { message: 'Merchant registered. Check email for verification code.' };
  }

  async login(dto: LoginDto) {
    let entity: any = await this.usersService.findOne(dto.email );
    if (!entity) entity = await this.merchantsService.findOne(dto.email);

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
    const merchant = await this.merchantsService.findOne(dto.email);
    if (!merchant) throw new BadRequestException('Email not found');

    if (merchant.isVerified) {
      return { message: 'Merchant email already verified' }; // idempotent response
    }

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
    const user = (await this.usersService.findOne(dto.email)) ||
                (await this.merchantsService.findOne(dto.email));

    if (!user) throw new BadRequestException('Email not found');

    const token = this.jwtService.sign(
      { sub: user.id, email: dto.email },
      { secret: this.configService.get('JWT_SECRET'), expiresIn: '15m' }
    );

    if (this.configService.get('NODE_ENV') !== 'production') {
      console.log('Password reset token:', token);
    }

    // Async email
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