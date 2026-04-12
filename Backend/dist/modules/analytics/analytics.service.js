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
exports.AnalyticsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const promotion_entity_1 = require("../../entities/promotion.entity");
const redemption_entity_1 = require("../../entities/redemption.entity");
let AnalyticsService = class AnalyticsService {
    promotionRepo;
    redemptionRepo;
    constructor(promotionRepo, redemptionRepo) {
        this.promotionRepo = promotionRepo;
        this.redemptionRepo = redemptionRepo;
    }
    async getMerchantAnalytics(merchantId) {
        const promotions = await this.promotionRepo.find({
            where: { merchantId },
        });
        const totalPromotions = promotions.length;
        const totalRedemptions = promotions.reduce((sum, p) => sum + (p.redeemedCount || 0), 0);
        const activePromotions = promotions.filter((p) => p.isActive && new Date(p.expiry) > new Date()).length;
        return {
            totalPromotions,
            totalRedemptions,
            activePromotions,
            estimatedFootTraffic: Math.round(totalRedemptions * 1.5),
            promotions: promotions.map((p) => ({
                id: p.id,
                title: p.title,
                type: p.type,
                redeemedCount: p.redeemedCount,
                views: p.views || 0,
                expiry: p.expiry,
            })),
        };
    }
};
exports.AnalyticsService = AnalyticsService;
exports.AnalyticsService = AnalyticsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(promotion_entity_1.Promotion)),
    __param(1, (0, typeorm_1.InjectRepository)(redemption_entity_1.Redemption)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], AnalyticsService);
//# sourceMappingURL=analytics.service.js.map