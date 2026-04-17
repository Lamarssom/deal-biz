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
exports.PromotionsController = void 0;
const common_1 = require("@nestjs/common");
const throttler_1 = require("@nestjs/throttler");
const swagger_1 = require("@nestjs/swagger");
const promotions_service_1 = require("./promotions.service");
const create_promotion_dto_1 = require("./dto/create-promotion.dto");
const jwt_auth_guard_1 = require("../../common/guards/jwt-auth.guard");
const roles_guard_1 = require("../../common/guards/roles.guard");
const roles_decorator_1 = require("../../common/decorators/roles.decorator");
let PromotionsController = class PromotionsController {
    promotionsService;
    constructor(promotionsService) {
        this.promotionsService = promotionsService;
    }
    create(req, dto) {
        const merchantId = req.user.id;
        return this.promotionsService.createPromotion(merchantId, dto);
        console.log('BODY RECEIVED:', common_1.Body);
    }
    async getNearby(lat, lng, radius = '5') {
        return this.promotionsService.getNearbyPromotions(parseFloat(lat), parseFloat(lng), parseFloat(radius));
    }
};
exports.PromotionsController = PromotionsController;
__decorate([
    (0, common_1.Post)(),
    (0, throttler_1.Throttle)({ default: { ttl: 60, limit: 10 } }),
    (0, roles_decorator_1.Roles)('MERCHANT'),
    (0, swagger_1.ApiResponse)({
        status: 201,
        description: 'Promotion created – Paystack payment required',
    }),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, create_promotion_dto_1.CreatePromotionDto]),
    __metadata("design:returntype", void 0)
], PromotionsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('nearby'),
    (0, throttler_1.Throttle)({ default: { ttl: 60, limit: 40 } }),
    (0, swagger_1.ApiQuery)({ name: 'lat', required: true }),
    (0, swagger_1.ApiQuery)({ name: 'lng', required: true }),
    (0, swagger_1.ApiQuery)({ name: 'radius', required: false, example: 5 }),
    __param(0, (0, common_1.Query)('lat')),
    __param(1, (0, common_1.Query)('lng')),
    __param(2, (0, common_1.Query)('radius')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, Object]),
    __metadata("design:returntype", Promise)
], PromotionsController.prototype, "getNearby", null);
exports.PromotionsController = PromotionsController = __decorate([
    (0, swagger_1.ApiTags)('Promotions'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.Controller)('promotions'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    __metadata("design:paramtypes", [promotions_service_1.PromotionsService])
], PromotionsController);
//# sourceMappingURL=promotions.controller.js.map