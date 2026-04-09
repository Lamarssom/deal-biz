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
        const query = `
      SELECT *,
             (${haversine_1.calculateHaversineDistance.sql}) AS distance_km
      FROM merchants
      WHERE is_verified = true
        AND is_active = true
        AND latitude BETWEEN $1 AND $2
        AND longitude BETWEEN $3 AND $4
        AND (${haversine_1.calculateHaversineDistance.sql}) <= $5
      ORDER BY distance_km ASC
      LIMIT $6
    `;
        const merchants = await this.merchantRepo.query(query, [
            minLat,
            maxLat,
            minLng,
            maxLng,
            radiusKm,
            limit,
            userLat,
            userLng
        ]);
        return merchants;
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