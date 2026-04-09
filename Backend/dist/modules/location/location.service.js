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
const merchant_entity_1 = require("../../entities/merchant.entity");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
let LocationService = class LocationService {
    merchantRepo;
    constructor(merchantRepo) {
        this.merchantRepo = merchantRepo;
    }
    calculateDistance(lat1, lon1, lat2, lon2) {
        const R = 6371;
        const dLat = this.toRad(lat2 - lat1);
        const dLon = this.toRad(lon2 - lon1);
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(this.toRad(lat1)) *
                Math.cos(this.toRad(lat2)) *
                Math.sin(dLon / 2) *
                Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
    toRad(value) {
        return (value * Math.PI) / 180;
    }
    async findMerchantsInRadius(lat, lng, radiusKm = 3) {
        const merchants = await this.merchantRepo.find({
            where: { isVerified: true, isActive: true },
        });
        return merchants
            .filter((m) => {
            if (!m.latitude || !m.longitude)
                return false;
            const distance = this.calculateDistance(lat, lng, m.latitude, m.longitude);
            return distance <= radiusKm;
        })
            .sort((a, b) => {
            const distA = this.calculateDistance(lat, lng, a.latitude, a.longitude);
            const distB = this.calculateDistance(lat, lng, b.latitude, b.longitude);
            return distA - distB;
        });
    }
};
exports.LocationService = LocationService;
exports.LocationService = LocationService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(merchant_entity_1.Merchant)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], LocationService);
//# sourceMappingURL=location.service.js.map