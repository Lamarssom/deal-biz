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
exports.LocationService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const merchant_entity_1 = require("../../entities/merchant.entity");
const haversine_1 = require("../../common/utils/haversine");
const bounding_box_1 = require("../../common/utils/bounding-box");
let LocationService = class LocationService {
    merchantRepo;
    constructor(merchantRepo) {
        this.merchantRepo = merchantRepo;
    }
    async findMerchantsInRadius(userLat, userLng, radiusKm = 3, limit = 20) {
        const { minLat, maxLat, minLng, maxLng } = (0, bounding_box_1.getBoundingBox)(userLat, userLng, radiusKm);
        const queryBuilder = this.merchantRepo
            .createQueryBuilder('merchant')
            .addSelect(`(${haversine_1.calculateHaversineDistance.sql})`, 'distance_km')
            .where('merchant.isVerified = :isVerified', { isVerified: true })
            .andWhere('merchant.isActive = :isActive', { isActive: true })
            .andWhere('merchant.latitude BETWEEN :minLat AND :maxLat', { minLat, maxLat })
            .andWhere('merchant.longitude BETWEEN :minLng AND :maxLng', { minLng, maxLng })
            .andWhere(`(${haversine_1.calculateHaversineDistance.sql}) <= :radiusKm`)
            .setParameters({
            userLat,
            userLng,
            radiusKm,
        })
            .orderBy('distance_km', 'ASC')
            .limit(limit);
        const merchants = await queryBuilder.getRawMany();
        return merchants.map((m) => ({
            id: m.merchant_id,
            businessName: m.merchant_businessName,
            category: m.merchant_category,
            businessLGA: m.merchant_businessLGA,
            latitude: Number(m.merchant_latitude),
            longitude: Number(m.merchant_longitude),
            distanceKm: Number(m.distance_km.toFixed(2)),
        }));
    }
    calculateDistance(lat1, lon1, lat2, lon2) {
        return haversine_1.calculateHaversineDistance.js(lat1, lon1, lat2, lon2);
    }
};
exports.LocationService = LocationService;
exports.LocationService = LocationService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(merchant_entity_1.Merchant)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], LocationService);
//# sourceMappingURL=location.service.js.map