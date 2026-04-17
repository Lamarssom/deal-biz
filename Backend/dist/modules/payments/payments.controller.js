"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PaymentsController = void 0;
const common_1 = require("@nestjs/common");
const throttler_1 = require("@nestjs/throttler");
const payments_service_1 = require("./payments.service");
const merchants_service_1 = require("../merchants/merchants.service");
const event_emitter_1 = require("@nestjs/event-emitter");
const config_1 = require("@nestjs/config");
const crypto = __importStar(require("crypto"));
let PaymentsController = class PaymentsController {
    paymentsService;
    merchantsService;
    eventEmitter;
    configService;
    constructor(paymentsService, merchantsService, eventEmitter, configService) {
        this.paymentsService = paymentsService;
        this.merchantsService = merchantsService;
        this.eventEmitter = eventEmitter;
        this.configService = configService;
    }
    async paystackWebhook(req, body, signature) {
        const secret = this.configService.get('PAYSTACK_SECRET_KEY');
        if (!secret) {
            console.error('PAYSTACK_SECRET_KEY is missing in environment');
            return { status: 'missing secret' };
        }
        if (!signature) {
            console.error('No x-paystack-signature header received');
            return { status: 'no signature' };
        }
        const payload = req.rawBody
            ? req.rawBody.toString('utf8')
            : JSON.stringify(body);
        const hash = crypto
            .createHmac('sha512', secret)
            .update(payload)
            .digest('hex');
        if (hash !== signature) {
            console.error('Invalid Paystack signature. Received:', signature);
            console.error('Expected hash:', hash);
            return { status: 'invalid signature' };
        }
        console.log('✅ Paystack webhook signature verified successfully');
        if (body.event === 'charge.success') {
            const metadata = body.data?.metadata;
            if (metadata?.promotionId && metadata?.type === 'creation_fee') {
                const promotionId = metadata.promotionId;
                console.log(`Processing successful payment for promotion: ${promotionId}`);
                this.eventEmitter.emit('payment.success', { promotionId });
            }
            else {
                console.log('Webhook received but no matching metadata for promotion creation');
            }
        }
        return { status: 'success' };
    }
    async paystackCallback(query) {
        const reference = query.reference || query.trxref;
        console.log(`Payment callback received for reference: ${reference}`);
        return {
            status: 'success',
            message: 'Payment completed. The promotion should be activated shortly via webhook.',
            reference,
        };
    }
};
exports.PaymentsController = PaymentsController;
__decorate([
    (0, common_1.Post)('webhook'),
    (0, throttler_1.SkipThrottle)(),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.Headers)('x-paystack-signature')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, String]),
    __metadata("design:returntype", Promise)
], PaymentsController.prototype, "paystackWebhook", null);
__decorate([
    (0, common_1.Get)('callback'),
    __param(0, (0, common_1.Query)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], PaymentsController.prototype, "paystackCallback", null);
exports.PaymentsController = PaymentsController = __decorate([
    (0, common_1.Controller)('payments'),
    __metadata("design:paramtypes", [payments_service_1.PaymentsService,
        merchants_service_1.MerchantsService,
        event_emitter_1.EventEmitter2,
        config_1.ConfigService])
], PaymentsController);
//# sourceMappingURL=payments.controller.js.map