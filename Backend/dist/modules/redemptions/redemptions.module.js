"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RedemptionsModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const redemptions_controller_1 = require("./redemptions.controller");
const redemptions_service_1 = require("./redemptions.service");
const redemption_entity_1 = require("../../entities/redemption.entity");
const promotion_entity_1 = require("../../entities/promotion.entity");
const user_entity_1 = require("../../entities/user.entity");
const merchant_entity_1 = require("../../entities/merchant.entity");
let RedemptionsModule = class RedemptionsModule {
};
exports.RedemptionsModule = RedemptionsModule;
exports.RedemptionsModule = RedemptionsModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([redemption_entity_1.Redemption, promotion_entity_1.Promotion, user_entity_1.User, merchant_entity_1.Merchant])],
        controllers: [redemptions_controller_1.RedemptionsController],
        providers: [redemptions_service_1.RedemptionsService],
        exports: [redemptions_service_1.RedemptionsService],
    })
], RedemptionsModule);
//# sourceMappingURL=redemptions.module.js.map