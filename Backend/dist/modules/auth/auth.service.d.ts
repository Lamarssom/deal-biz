import { JwtService } from '@nestjs/jwt';
import { EmailService } from '../email/email.service';
import { ConfigService } from '@nestjs/config';
import { RegisterDto } from '../../dtos/register.dto';
import { LoginDto } from '../../dtos/login.dto';
import { VerifyEmailDto } from './dto/verify-email.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { UsersService } from '../users/users.service';
import { MerchantsService } from '../merchants/merchants.service';
import { LgaService } from '../lga/lga.service';
export declare class AuthService {
    private usersService;
    private merchantsService;
    private jwtService;
    private configService;
    private emailService;
    private lgaService;
    constructor(usersService: UsersService, merchantsService: MerchantsService, jwtService: JwtService, configService: ConfigService, emailService: EmailService, lgaService: LgaService);
    private generateVerificationCode;
    register(dto: RegisterDto): Promise<{
        accessToken: string;
        user: {
            id: any;
            email: any;
            role: any;
        };
    } | {
        message: string;
    }>;
    login(dto: LoginDto): Promise<{
        accessToken: string;
        user: {
            id: any;
            email: any;
            role: any;
        };
    }>;
    verifyEmail(dto: VerifyEmailDto): Promise<{
        message: string;
    }>;
    forgotPassword(dto: ForgotPasswordDto): Promise<{
        message: string;
    }>;
    resetPassword(dto: ResetPasswordDto): Promise<{
        message: string;
    }>;
}
