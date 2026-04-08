"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const bcrypt = __importStar(require("bcryptjs"));
const nodemailer = __importStar(require("nodemailer"));
const config_1 = require("@nestjs/config");
const users_service_1 = require("../users/users.service");
const merchants_service_1 = require("../merchants/merchants.service");
let AuthService = class AuthService {
    usersService;
    merchantsService;
    jwtService;
    configService;
    transporter;
    constructor(usersService, merchantsService, jwtService, configService) {
        this.usersService = usersService;
        this.merchantsService = merchantsService;
        this.jwtService = jwtService;
        this.configService = configService;
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
    generateVerificationCode() {
        return Math.floor(100000 + Math.random() * 900000).toString();
    }
    async register(dto) {
        const hashed = await bcrypt.hash(dto.password, 10);
        if (dto.role === 'CUSTOMER') {
            const user = this.usersService.create({ email: dto.email, password: hashed, role: 'CUSTOMER' });
            await this.usersService.save(user);
            return this.login({ email: dto.email, password: dto.password });
        }
        let merchant = await this.merchantsService.findOne({ where: { email: dto.email } });
        if (merchant)
            throw new common_1.BadRequestException('Email already registered');
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
        await this.transporter.sendMail({
            from: this.configService.get('EMAIL_FROM'),
            to: dto.email,
            subject: 'Verify your Deal-Biz Merchant Account',
            html: `<p>Your verification code is: <strong>${code}</strong></p><p>Valid for 15 minutes.</p>`,
        });
        return { message: 'Merchant registered. Check email for verification code.' };
    }
    async login(dto) {
        let entity = await this.usersService.findOne({ where: { email: dto.email } });
        if (!entity)
            entity = await this.merchantsService.findOne({ where: { email: dto.email } });
        if (!entity || !(await bcrypt.compare(dto.password, entity.password))) {
            throw new common_1.UnauthorizedException('Invalid credentials');
        }
        if (entity.role === 'MERCHANT' && !entity.isVerified) {
            throw new common_1.BadRequestException('Please verify your email first');
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
    async verifyEmail(dto) {
        const merchant = await this.merchantsService.findOne({ where: { email: dto.email } });
        if (!merchant || merchant.verificationCode !== dto.code || (merchant.verificationExpiresAt && merchant.verificationExpiresAt < new Date())) {
            throw new common_1.BadRequestException('Invalid or expired code');
        }
        merchant.isVerified = true;
        merchant.verificationCode = null;
        merchant.verificationExpiresAt = null;
        await this.merchantsService.
            save(merchant);
        return { message: 'Merchant email verified successfully' };
    }
    async forgotPassword(dto) {
        const user = await this.usersService.findOne({ where: { email: dto.email } }) ||
            await this.merchantsService.findOne({ where: { email: dto.email } });
        if (!user)
            throw new common_1.BadRequestException('Email not found');
        const token = this.jwtService.sign({ sub: user.id, email: dto.email }, { secret: this.configService.get('JWT_SECRET'), expiresIn: '15m' });
        await this.transporter.sendMail({
            from: this.configService.get('EMAIL_FROM'),
            to: dto.email,
            subject: 'Deal-Biz Password Reset',
            html: `<p>Reset your password here: <a href="http://localhost:3000/reset?token=${token}">Reset Password</a></p>`,
        });
        return { message: 'Password reset link sent to email' };
    }
    async resetPassword(dto) {
        let payload;
        try {
            payload = this.jwtService.verify(dto.token, { secret: this.configService.get('JWT_SECRET') });
        }
        catch {
            throw new common_1.BadRequestException('Invalid or expired token');
        }
        const hashed = await bcrypt.hash(dto.newPassword, 10);
        await this.usersService.update({ id: payload.sub }, { password: hashed }).catch(() => { });
        await this.merchantsService.update({ id: payload.sub }, { password: hashed }).catch(() => { });
        return { message: 'Password reset successfully' };
    }
};
exports.AuthService = AuthService;
exports.AuthService = AuthService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [users_service_1.UsersService,
        merchants_service_1.MerchantsService,
        jwt_1.JwtService,
        config_1.ConfigService])
], AuthService);
//# sourceMappingURL=auth.service.js.map