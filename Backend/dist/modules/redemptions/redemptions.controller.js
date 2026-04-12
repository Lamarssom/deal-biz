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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RedemptionsController = void 0;
const express_1 = __importDefault(require("express"));
const common_1 = require("@nestjs/common");
const redemptions_service_1 = require("./redemptions.service");
const generate_qr_dto_1 = require("./dto/generate-qr.dto");
const redeem_dto_1 = require("./dto/redeem.dto");
const jwt_auth_guard_1 = require("../../common/guards/jwt-auth.guard");
const roles_decorator_1 = require("../../common/decorators/roles.decorator");
let RedemptionsController = class RedemptionsController {
    redemptionsService;
    constructor(redemptionsService) {
        this.redemptionsService = redemptionsService;
    }
    generateQR(req, dto) {
        const user = req.user;
        return this.redemptionsService.generateQR(user.id, dto);
    }
    redeem(req, dto) {
        const user = req.user;
        return this.redemptionsService.redeem(dto.qrCode, user.id);
    }
};
exports.RedemptionsController = RedemptionsController;
__decorate([
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, common_1.Post)('generate'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, generate_qr_dto_1.GenerateQrDto]),
    __metadata("design:returntype", void 0)
], RedemptionsController.prototype, "generateQR", null);
__decorate([
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, roles_decorator_1.Roles)('MERCHANT'),
    (0, common_1.Post)('redeem'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, redeem_dto_1.RedeemDto]),
    __metadata("design:returntype", void 0)
], RedemptionsController.prototype, "redeem", null);
exports.RedemptionsController = RedemptionsController = __decorate([
    (0, common_1.Controller)('redemptions'),
    __metadata("design:paramtypes", [redemptions_service_1.RedemptionsService])
], RedemptionsController);
//# sourceMappingURL=redemptions.controller.js.map