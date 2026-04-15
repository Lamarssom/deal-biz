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
exports.PaymentsController = void 0;
const common_1 = require("@nestjs/common");
const payments_service_1 = require("./payments.service");
const merchants_service_1 = require("../merchants/merchants.service");
const event_emitter_1 = require("@nestjs/event-emitter");
let PaymentsController = class PaymentsController {
    paymentsService;
    merchantsService;
    eventEmitter;
    constructor(paymentsService, merchantsService, eventEmitter) {
        this.paymentsService = paymentsService;
        this.merchantsService = merchantsService;
        this.eventEmitter = eventEmitter;
    }
    async paystackWebhook(body) {
        if (body.event !== 'charge.success') {
            return { status: 'ignored' };
        }
        const metadata = body.data.metadata;
        if (metadata.type === 'creation_fee' || metadata.promotionId) {
            const promoId = metadata.promotionId;
            this.eventEmitter.emit('payment.success', {
                promotionId: promoId,
            });
        }
        if (metadata.type === 'balance_settlement') {
            const merchantId = metadata.merchantId;
            const amount = body.data.amount / 100;
            await this.merchantsService.updateBalance(merchantId, amount);
        }
        return { status: 'success' };
    }
};
exports.PaymentsController = PaymentsController;
__decorate([
    (0, common_1.Post)('webhook'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], PaymentsController.prototype, "paystackWebhook", null);
exports.PaymentsController = PaymentsController = __decorate([
    (0, common_1.Controller)('payments'),
    __metadata("design:paramtypes", [payments_service_1.PaymentsService,
        merchants_service_1.MerchantsService,
        event_emitter_1.EventEmitter2])
], PaymentsController);
//# sourceMappingURL=payments.controller.js.map