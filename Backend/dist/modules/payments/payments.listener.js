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
exports.PaymentsListener = void 0;
const common_1 = require("@nestjs/common");
const event_emitter_1 = require("@nestjs/event-emitter");
const promotions_service_1 = require("../promotions/promotions.service");
let PaymentsListener = class PaymentsListener {
    promotionsService;
    constructor(promotionsService) {
        this.promotionsService = promotionsService;
    }
    async handlePaymentSuccess(payload) {
        await this.promotionsService.activatePromotion(payload.promotionId);
        console.log('✅ Promotion activated after payment');
    }
};
exports.PaymentsListener = PaymentsListener;
__decorate([
    (0, event_emitter_1.OnEvent)('payment.success'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], PaymentsListener.prototype, "handlePaymentSuccess", null);
exports.PaymentsListener = PaymentsListener = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [promotions_service_1.PromotionsService])
], PaymentsListener);
//# sourceMappingURL=payments.listener.js.map