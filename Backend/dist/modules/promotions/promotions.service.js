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
exports.PromotionsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const axios_1 = require("@nestjs/axios");
const rxjs_1 = require("rxjs");
const config_1 = require("@nestjs/config");
const promotion_entity_1 = require("../../entities/promotion.entity");
const merchant_entity_1 = require("../../entities/merchant.entity");
const location_service_1 = require("../location/location.service");
const uuid_1 = require("uuid");
let PromotionsService = class PromotionsService {
    promotionRepo;
    merchantRepo;
    locationService;
    httpService;
    configService;
    constructor(promotionRepo, merchantRepo, locationService, httpService, configService) {
        this.promotionRepo = promotionRepo;
        this.merchantRepo = merchantRepo;
        this.locationService = locationService;
        this.httpService = httpService;
        this.configService = configService;
    }
    async createPromotion(merchantId, dto) {
        const merchant = await this.merchantRepo.findOne({ where: { id: merchantId, isVerified: true, isActive: true } });
        if (!merchant)
            throw new common_1.NotFoundException('Merchant not found or not verified');
        const fee = dto.type === 'STANDARD' ? 100 : 50;
        const radiusKm = dto.type === 'STANDARD' ? 3 : 1;
        const idempotencyKey = dto.idempotencyKey || `promo-${merchantId}-${(0, uuid_1.v4)()}`;
        const existing = await this.promotionRepo.findOne({ where: { idempotencyKey, merchantId } });
        if (existing)
            return { message: 'Promotion already processed', promotionId: existing.id };
        const promotion = this.promotionRepo.create({
            merchant,
            merchantId,
            type: dto.type,
            fee,
            price: dto.price,
            originalPrice: dto.originalPrice,
            title: dto.title,
            description: dto.description,
            photoUrl: dto.photoUrl,
            radiusKm,
            expiry: new Date(dto.expiry),
            quantityLimit: dto.quantityLimit,
            idempotencyKey,
            isActive: false,
        });
        const savedPromo = await this.promotionRepo.save(promotion);
        const paystackUrl = 'https://api.paystack.co/transaction/initialize';
        const payload = {
            amount: fee * 100,
            email: merchant.email,
            reference: idempotencyKey,
            metadata: {
                promotionId: savedPromo.id,
                merchantId,
                type: dto.type,
            },
            callback_url: 'http://localhost:3000/payments/callback',
        };
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(paystackUrl, payload, {
            headers: {
                Authorization: `Bearer ${this.configService.get('PAYSTACK_SECRET_KEY')}`,
                'Content-Type': 'application/json',
            },
        }));
        const { data } = response.data;
        return {
            message: 'Promotion created – complete payment to go live',
            promotionId: savedPromo.id,
            paystackReference: data.reference,
            authorizationUrl: data.authorization_url,
            fee,
            type: dto.type,
        };
    }
};
exports.PromotionsService = PromotionsService;
exports.PromotionsService = PromotionsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(promotion_entity_1.Promotion)),
    __param(1, (0, typeorm_1.InjectRepository)(merchant_entity_1.Merchant)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        location_service_1.LocationService,
        axios_1.HttpService,
        config_1.ConfigService])
], PromotionsService);
//# sourceMappingURL=promotions.service.js.map