import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { EmailService } from '../email/email.service';
import { ConfigService } from '@nestjs/config';
import { User } from '../../entities/user.entity';
import { Merchant } from '../../entities/merchant.entity';
import { RegisterDto } from '../../dtos/register.dto';
import { LoginDto } from '../../dtos/login.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { UsersService } from '../users/users.service';
import { MerchantsService } from '../merchants/merchants.service';
import { ChangePasswordDto } from './dto/change-password.dto';
import { UpdatePhoneDto } from './dto/update-phone.dto';
import { AppleLoginDto } from './dto/apple-login.dto';
import { GoogleLoginDto } from './dto/google-login.dto';

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

  private normalizeEmail(email: string): string {
    return email.trim().toLowerCase();
  }

  async register(dto: RegisterDto) {
    const email = this.normalizeEmail(dto.email);

    const existingUser = await this.usersService.findOne(email);
    const existingMerchant = await this.merchantsService.findOne(email);

    if (existingUser || existingMerchant) {
      throw new BadRequestException('Email already registered');
    }

    const hashed = await bcrypt.hash(dto.password, 10);
    const code = this.generateVerificationCode();
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

    if (dto.role === 'CUSTOMER') {
      const user = this.usersService.create({
        email,
        password: hashed,
        role: 'CUSTOMER',
        phoneNumber: dto.phoneNumber,
        isVerified: false,
        verificationCode: code,
        verificationExpiresAt: expiresAt,
      });

      const savedUser = await this.usersService.save(user);
      console.log(`[REGISTRATION] Customer saved → ID: ${savedUser.id}, Email: ${email}, Code: ${code}`);

      setImmediate(() => {
        this.emailService.sendVerificationEmail(email, code);
      });

      return { message: 'Customer registered. Check email for verification code.' };
    }

    // MERCHANT
    const merchant = await this.merchantsService.create({
      email,
      password: hashed,
      role: 'MERCHANT',
      businessName: dto.businessName,
      category: dto.category,
      businessLGA: dto.businessLGA,
      phoneNumber: dto.phoneNumber,
      address: dto.address,
      latitude: dto.latitude,
      longitude: dto.longitude,
      isVerified: false,
      verificationCode: code,
      verificationExpiresAt: expiresAt,
    });

    await this.merchantsService.save(merchant);

    setImmediate(() => {
      this.emailService.sendVerificationEmail(email, code);
    });

    return { message: 'Merchant registered. Check email for verification code.' };
  }

  async login(dto: LoginDto) {
    const email = this.normalizeEmail(dto.email);

    let entity: User | Merchant | null = await this.usersService.findOne(email);
    if (!entity) entity = await this.merchantsService.findOne(email);

    if (!entity || !(await bcrypt.compare(dto.password, entity.password))) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (!entity.isVerified) {
      throw new BadRequestException('Please verify your account first');
    }

    const payload = { sub: entity.id, email: entity.email, role: entity.role };

    return {
      accessToken: this.jwtService.sign(payload, {
        secret: this.configService.get('JWT_SECRET'),
        expiresIn: this.configService.get('JWT_EXPIRES_IN'),
      }),
      user: {
        id: entity.id,
        email: entity.email,
        role: entity.role,
        name: entity instanceof User ? entity.name : entity.businessName,
        phoneNumber: entity.phoneNumber,
      },
    };
  }

  // Robust verifyOtp with explicit field selection
  async verifyOtp(dto: VerifyOtpDto) {
    const email = this.normalizeEmail(dto.email);

    console.log(`[VERIFY] Looking for account: ${email}`);

    // Try User first
    let entity: User | Merchant | null = await this.usersService.findOne(email);
    if (!entity) {
      entity = await this.merchantsService.findOne(email);
    }

    if (!entity) {
      console.log(`[VERIFY] Account not found for email: ${email}`);
      throw new BadRequestException('Account not found');
    }

    console.log(`[VERIFY] Found entity (type: ${entity instanceof User ? 'User' : 'Merchant'}) - Verified: ${entity.isVerified}, Code in DB: ${entity.verificationCode}`);

    if (entity.isVerified) {
      return { message: 'Account already verified' };
    }

    if (entity.verificationCode !== dto.code) {
      console.log(`[VERIFY] Code mismatch - Entered: ${dto.code}, DB: ${entity.verificationCode}`);
      throw new BadRequestException('Invalid or expired code');
    }

    if (entity.verificationExpiresAt && entity.verificationExpiresAt < new Date()) {
      console.log(`[VERIFY] Code expired`);
      throw new BadRequestException('Invalid or expired code');
    }

    // Mark as verified
    entity.isVerified = true;
    entity.verificationCode = null;
    entity.verificationExpiresAt = null;

    if (entity instanceof User) {
      await this.usersService.save(entity);
    } else {
      await this.merchantsService.save(entity);
    }

    console.log(`[VERIFY] SUCCESS - Account verified: ${email}`);
    return { message: 'Account verified successfully' };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const email = this.normalizeEmail(dto.email);
    const user = (await this.usersService.findOne(email)) ||
                (await this.merchantsService.findOne(email));

    if (!user) throw new BadRequestException('Email not found');

    const token = this.jwtService.sign(
      { sub: user.id, email },
      { secret: this.configService.get('JWT_SECRET'), expiresIn: '15m' }
    );

    setImmediate(() => {
      this.emailService.sendPasswordReset(email, token);
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

    await this.usersService.update({ id: payload.sub }, { password: hashed }).catch(() => {});
    await this.merchantsService.update({ id: payload.sub }, { password: hashed }).catch(() => {});

    return { message: 'Password reset successfully' };
  }

  async changePassword(userId: string, dto: ChangePasswordDto) {
    const email = await this.getUserEmail(userId); 
    let entity: User | Merchant | null = await this.usersService.findOne(email);
    if (!entity) entity = await this.merchantsService.findOne(email);

    if (!entity || !(await bcrypt.compare(dto.oldPassword, entity.password))) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    const hashed = await bcrypt.hash(dto.newPassword, 10);

    if (entity instanceof User) {
      await this.usersService.update({ id: userId }, { password: hashed });
    } else {
      await this.merchantsService.update({ id: userId }, { password: hashed });
    }

    return { message: 'Password changed successfully' };
  }

  async updatePhoneNumber(userId: string, dto: UpdatePhoneDto) {
    let entity: User | Merchant | null = await this.usersService.findById(userId);
    if (!entity) entity = await this.merchantsService.findById(userId);

    if (!entity) throw new BadRequestException('User not found');

    if (entity instanceof User) {
      await this.usersService.update({ id: userId }, { phoneNumber: dto.phoneNumber });
    } else {
      await this.merchantsService.update({ id: userId }, { phoneNumber: dto.phoneNumber });
    }

    return { message: 'Phone number updated successfully' };
  }

  // Small helper
  private async getUserEmail(userId: string): Promise<string> {
    const user = await this.usersService.findById(userId);
    if (user) return user.email;
    const merchant = await this.merchantsService.findById(userId);
    if (merchant) return merchant.email;
    throw new BadRequestException('User not found');
  }

  async googleLogin(dto: GoogleLoginDto) {
    // TODO: Verify Google token (you'll need google-auth-library)
    // For now, we'll simulate and improve later
    const payload = this.jwtService.decode(dto.idToken) as any;

    if (!payload?.email) {
      throw new BadRequestException('Invalid Google token');
    }

    return this.handleSocialLogin(payload.email, payload.name || payload.given_name, 'GOOGLE');
  }

  async appleLogin(dto: AppleLoginDto) {
    const payload = this.jwtService.decode(dto.identityToken) as any;

    if (!payload?.email) {
      throw new BadRequestException('Invalid Apple token');
    }

    const name = dto.fullName || payload.email.split('@')[0] || 'Apple User';

    return this.handleSocialLogin(payload.email, name, 'APPLE');
  }

  private async handleSocialLogin(email: string, name: string, provider: string) {
    const normalizedEmail = this.normalizeEmail(email);

    let entity = await this.usersService.findOne(normalizedEmail) ||
                 await this.merchantsService.findOne(normalizedEmail);

    if (!entity) {
      // Create minimal user - do NOT auto-assign full customer role experience
      const hashed = await bcrypt.hash(Math.random().toString(36), 10);

      const user = this.usersService.create({
        email: normalizedEmail,
        password: hashed,
        role: 'CUSTOMER',
        name: name || '',
        isVerified: true,
        isProfileComplete: false,     // ← Important flag
      });

      entity = await this.usersService.save(user);
      console.log(`[SOCIAL] New user created via ${provider}: ${normalizedEmail} (profile incomplete)`);
    }

    const token = this.jwtService.sign(
      { 
        sub: entity.id, 
        email: entity.email, 
        role: entity.role,
        isProfileComplete: entity instanceof User ? (entity as any).isProfileComplete : true
      },
      { secret: this.configService.get('JWT_SECRET'), expiresIn: '7d' }
    );

    return {
      accessToken: token,
      user: {
        id: entity.id,
        email: entity.email,
        role: entity.role,
        name: entity instanceof User ? (entity as any).name : (entity as Merchant).businessName,
        isProfileComplete: entity instanceof User ? (entity as any).isProfileComplete : true,
      },
      provider,
    };
  }
}