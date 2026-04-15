"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MerchantsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const merchant_entity_1 = require("../../entities/merchant.entity");
const bounding_box_1 = require("../../common/utils/bounding-box");
const lga_entity_1 = require("../../entities/lga.entity");
const axios_1 = require("@nestjs/axios");
const config_1 = require("@nestjs/config");
const rxjs_1 = require("rxjs");
let MerchantsService = class MerchantsService {
    merchantRepo;
    lgaRepo;
    httpService;
    configService;
    constructor(merchantRepo, lgaRepo, httpService, configService) {
        this.merchantRepo = merchantRepo;
        this.lgaRepo = lgaRepo;
        this.httpService = httpService;
        this.configService = configService;
    }
    async create(data) {
        if (!data.businessLGA) {
            throw new Error('Business LGA is required');
        }
        const lga = await this.lgaRepo.findOne({
            where: { lga: data.businessLGA },
        });
        if (!lga) {
            throw new Error('Invalid LGA');
        }
        const merchant = this.merchantRepo.create({
            ...data,
            latitude: lga.latitude,
            longitude: lga.longitude,
        });
        return merchant;
    }
    save(merchant) {
        return this.merchantRepo.save(merchant);
    }
    async findOne(email) {
        return this.merchantRepo.findOne({
            where: { email },
            select: [
                'id',
                'email',
                'password',
                'role',
                'isVerified',
                'verificationCode',
                'verificationExpiresAt',
            ],
        });
    }
    findById(id) {
        return this.merchantRepo.findOne({ where: { id } });
    }
    update(criteria, data) {
        return this.merchantRepo.update(criteria, data);
    }
    async findNearby(lat, lng, radius = 10) {
        const { minLat, maxLat, minLng, maxLng } = (0, bounding_box_1.getBoundingBox)(lat, lng, radius);
        const merchants = await this.merchantRepo.query(`
        SELECT *,
        (
        6371 * acos(
            cos(radians($1)) *
            cos(radians(latitude)) *
            cos(radians(longitude) - radians($2)) +
            sin(radians($1)) *
            sin(radians(latitude))
        )
        ) AS distance
        FROM merchants
        WHERE latitude BETWEEN $3 AND $4
        AND longitude BETWEEN $5 AND $6
        AND latitude IS NOT NULL
        AND longitude IS NOT NULL
        HAVING distance <= $7
        ORDER BY distance
        LIMIT 20
    `, [lat, lng, minLat, maxLat, minLng, maxLng, radius]);
        return merchants;
    }
    async updateBalance(merchantId, amount) {
        return this.merchantRepo.update(merchantId, {
            outstandingBalance: () => `"outstandingBalance" - ${amount}`,
        });
    }
    async settleBalance(merchantId, amount) {
        const merchant = await this.merchantRepo.findOne({
            where: { id: merchantId },
        });
        if (!merchant)
            throw new common_1.NotFoundException('Merchant not found');
        if (amount > merchant.outstandingBalance) {
            throw new common_1.BadRequestException('Amount exceeds outstanding balance');
        }
        const paystackUrl = 'https://api.paystack.co/transaction/initialize';
        const payload = {
            amount: Math.round(amount * 100),
            email: merchant.email,
            reference: `settle-${merchantId}-${Date.now()}`,
            metadata: { merchantId, type: 'balance_settlement' },
            callback_url: 'http://localhost:3000/payments/callback',
        };
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(paystackUrl, payload, {
            headers: {
                Authorization: `Bearer ${this.configService.get('PAYSTACK_SECRET_KEY')}`,
                'Content-Type': 'application/json',
            },
        }));
        return {
            authorizationUrl: response.data.data.authorization_url,
            reference: response.data.data.reference,
            amount,
            remainingBalance: merchant.outstandingBalance - amount,
        };
    }
};
exports.MerchantsService = MerchantsService;
exports.MerchantsService = MerchantsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(merchant_entity_1.Merchant)),
    __param(1, (0, typeorm_1.InjectRepository)(lga_entity_1.LGA)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        axios_1.HttpService,
        config_1.ConfigService])
], MerchantsService);
//# sourceMappingURL=merchants.service.js.map