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
Object.defineProperty(exports, "__esModule", { value: true });
exports.PromotionsRankingService = void 0;
const common_1 = require("@nestjs/common");
const location_service_1 = require("../location/location.service");
let PromotionsRankingService = class PromotionsRankingService {
    locationService;
    constructor(locationService) {
        this.locationService = locationService;
    }
    rankPromotions(userLat, userLng, promotions) {
        return promotions
            .map((promo) => {
            if (!promo.merchant?.latitude || !promo.merchant?.longitude) {
                return null;
            }
            const distanceKm = this.locationService.calculateDistance(userLat, userLng, promo.merchant.latitude, promo.merchant.longitude);
            const urgencyScore = (new Date(promo.expiry).getTime() - Date.now()) / (1000 * 60 * 60 * 24);
            const popularityScore = promo.popularityScore || 0;
            const score = distanceKm * 0.5 + popularityScore * -0.3 + urgencyScore * 0.2;
            return { promo, distanceKm, score };
        })
            .filter(Boolean)
            .sort((a, b) => a.score - b.score)
            .map((item) => item.promo);
    }
};
exports.PromotionsRankingService = PromotionsRankingService;
exports.PromotionsRankingService = PromotionsRankingService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [location_service_1.LocationService])
], PromotionsRankingService);
//# sourceMappingURL=promotions-ranking.service.js.map