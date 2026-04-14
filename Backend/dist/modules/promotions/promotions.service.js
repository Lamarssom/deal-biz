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
const promotions_ranking_service_1 = require("./promotions-ranking.service");
const uuid_1 = require("uuid");
let PromotionsService = class PromotionsService {
    promotionRepo;
    merchantRepo;
    locationService;
    httpService;
    configService;
    promotionsRankingService;
    constructor(promotionRepo, merchantRepo, locationService, httpService, configService, promotionsRankingService) {
        this.promotionRepo = promotionRepo;
        this.merchantRepo = merchantRepo;
        this.locationService = locationService;
        this.httpService = httpService;
        this.configService = configService;
        this.promotionsRankingService = promotionsRankingService;
    }
    async createPromotion(merchantId, dto) {
        const merchant = await this.merchantRepo.findOne({
            where: { id: merchantId, isVerified: true, isActive: true },
        });
        if (Number(merchant?.outstandingBalance) >= 5000) {
            throw new common_1.BadRequestException('Outstanding balance limit reached. Please settle your invoice.');
        }
        if (!merchant)
            throw new common_1.NotFoundException('Merchant not found or not verified');
        const creationFee = 25;
        const expiryDate = new Date(dto.expiry);
        if (expiryDate <= new Date()) {
            throw new common_1.BadRequestException('Expiry must be in the future');
        }
        const maxDays = 7;
        const diffMs = expiryDate.getTime() - Date.now();
        const diffDays = diffMs / (1000 * 60 * 60 * 24);
        if (diffDays > maxDays) {
            throw new common_1.BadRequestException('Promotion cannot exceed 7 days');
        }
        if (dto.originalPrice && dto.price >= dto.originalPrice) {
            throw new common_1.BadRequestException('Discounted price must be lower than original price');
        }
        const radiusKm = dto.type === promotion_entity_1.PromotionType.STANDARD ? 3 : 1;
        const idempotencyKey = dto.idempotencyKey || `promo-${merchantId}-${(0, uuid_1.v4)()}`;
        const existing = await this.promotionRepo.findOne({
            where: { idempotencyKey, merchantId },
        });
        if (existing)
            return {
                message: 'Promotion already processed',
                promotionId: existing.id,
            };
        const promotion = this.promotionRepo.create({
            merchant,
            merchantId,
            type: dto.type,
            fee: creationFee,
            price: Number(dto.price),
            originalPrice: Number(dto.originalPrice),
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
            amount: creationFee * 100,
            email: merchant.email,
            reference: idempotencyKey,
            metadata: {
                promotionId: savedPromo.id,
                merchantId,
                type: 'creation_fee',
            },
            callback_url: 'http://localhost:3000/payments/callback',
        };
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(paystackUrl, payload, {
            headers: {
                Authorization: `Bearer ${this.configService.get('PAYSTACK_SECRET_KEY')}`,
                'Content-Type': 'application/json',
            },
        }));
        const paystackResponse = response.data;
        const reference = paystackResponse.data.reference;
        const authorizationUrl = paystackResponse.data.authorization_url;
        return {
            message: 'Promotion created – pay ₦25 to go live',
            promotionId: savedPromo.id,
            paystackReference: reference,
            authorizationUrl,
            fee: creationFee,
            type: dto.type,
        };
    }
    async getNearbyPromotions(userLat, userLng, radiusKm = 5, limit = 20) {
        const merchants = await this.locationService.findMerchantsInRadius(userLat, userLng, radiusKm, 100);
        if (merchants.length === 0)
            return [];
        const merchantIds = merchants.map((m) => m.id);
        const promotions = await this.promotionRepo.find({
            where: {
                merchantId: (0, typeorm_2.In)(merchantIds),
                isActive: true,
                expiry: (0, typeorm_2.MoreThan)(new Date()),
            },
            relations: ['merchant'],
            take: 100,
        });
        return this.promotionsRankingService
            .rankPromotions(userLat, userLng, promotions)
            .slice(0, limit)
            .map((promo) => ({
            id: promo.id,
            title: promo.title,
            description: promo.description,
            type: promo.type,
            price: Number(promo.price),
            originalPrice: promo.originalPrice,
            radiusKm: Number(promo.radiusKm),
            expiry: promo.expiry,
            merchant: {
                id: promo.merchant.id,
                businessName: promo.merchant.businessName,
                category: promo.merchant.category,
                businessLGA: promo.merchant.businessLGA,
                latitude: Number(promo.merchant.latitude),
                longitude: Number(promo.merchant.longitude),
            },
            stats: {
                views: promo.views,
                redeemedCount: promo.redeemedCount,
            },
        }));
    }
    async activatePromotion(promotionId) {
        await this.promotionRepo.update(promotionId, { isActive: true });
        console.log(`✅ Promotion ${promotionId} is now LIVE!`);
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
        config_1.ConfigService,
        promotions_ranking_service_1.PromotionsRankingService])
], PromotionsService);
//# sourceMappingURL=promotions.service.js.map