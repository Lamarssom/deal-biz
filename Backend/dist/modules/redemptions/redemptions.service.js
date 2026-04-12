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
exports.RedemptionsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const QRCode = __importStar(require("qrcode"));
const redemption_entity_1 = require("../../entities/redemption.entity");
const promotion_entity_1 = require("../../entities/promotion.entity");
const user_entity_1 = require("../../entities/user.entity");
const crypto = __importStar(require("crypto"));
let RedemptionsService = class RedemptionsService {
    redemptionRepo;
    promotionRepo;
    userRepo;
    constructor(redemptionRepo, promotionRepo, userRepo) {
        this.redemptionRepo = redemptionRepo;
        this.promotionRepo = promotionRepo;
        this.userRepo = userRepo;
    }
    async generateQR(customerId, dto) {
        const promotion = await this.promotionRepo.findOne({
            where: { id: dto.promotionId, isActive: true },
        });
        if (!promotion)
            throw new common_1.NotFoundException('Promotion not found or inactive');
        if (promotion.expiry < new Date()) {
            throw new common_1.BadRequestException('Promotion expired');
        }
        const customer = await this.userRepo.findOne({ where: { id: customerId } });
        if (!customer)
            throw new common_1.NotFoundException('Customer not found');
        const existing = await this.redemptionRepo.findOne({
            where: {
                promotionId: dto.promotionId,
                customerId,
            },
        });
        if (existing) {
            throw new common_1.BadRequestException('QR already generated for this promotion');
        }
        const qrCode = crypto.randomBytes(16).toString('hex');
        const redemption = this.redemptionRepo.create({
            promotion,
            promotionId: dto.promotionId,
            customer,
            customerId,
            qrCode,
            isRedeemed: false,
        });
        const saved = await this.redemptionRepo.save(redemption);
        const qrDataUrl = await QRCode.toDataURL(qrCode, { width: 300 });
        return {
            redemptionId: saved.id,
            qrCode,
            qrImage: qrDataUrl,
            message: 'Show this QR to merchant',
        };
    }
    async redeem(qrCode, merchantId) {
        return this.promotionRepo.manager.transaction(async (manager) => {
            const redemption = await manager.findOne(redemption_entity_1.Redemption, {
                where: { qrCode, isRedeemed: false },
                relations: ['promotion', 'promotion.merchant'],
            });
            if (!redemption || redemption.isRedeemed) {
                console.warn('Fraud attempt: Attempted to redeem invalid QR code', {
                    qrCode,
                });
                throw new common_1.BadRequestException('Invalid or already redeemed QR code');
            }
            if (redemption.promotion.merchantId !== merchantId) {
                throw new common_1.BadRequestException('Unauthorized redemption attempt');
            }
            const promotion = redemption.promotion;
            if (promotion.quantityLimit > 0 &&
                promotion.redeemedCount >= promotion.quantityLimit) {
                console.warn('Promotion quantity limit reached', {
                    promotionId: promotion.id,
                    attemptedRedemptionId: redemption.id,
                });
                throw new common_1.BadRequestException('Promotion quantity limit reached');
            }
            const result = await manager
                .createQueryBuilder()
                .update(promotion_entity_1.Promotion)
                .set({ redeemedCount: () => '"redeemedCount" + 1' })
                .where('id = :id', { id: promotion.id })
                .andWhere('(quantityLimit = 0 OR "redeemedCount" < "quantityLimit")')
                .execute();
            if (result.affected === 0) {
                throw new common_1.BadRequestException('Promotion quantity limit reached');
            }
            await manager.update(redemption_entity_1.Redemption, redemption.id, {
                isRedeemed: true,
                redeemedAt: new Date(),
            });
            return {
                message: 'Redemption successful!',
                promotionTitle: promotion.title,
                businessName: promotion.merchant?.businessName,
            };
        });
    }
};
exports.RedemptionsService = RedemptionsService;
exports.RedemptionsService = RedemptionsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(redemption_entity_1.Redemption)),
    __param(1, (0, typeorm_1.InjectRepository)(promotion_entity_1.Promotion)),
    __param(2, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], RedemptionsService);
//# sourceMappingURL=redemptions.service.js.map