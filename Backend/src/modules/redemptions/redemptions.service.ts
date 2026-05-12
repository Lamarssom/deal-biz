import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';           // ← added In if needed later
import * as QRCode from 'qrcode';
import { Redemption } from '../../entities/redemption.entity';
import { Promotion } from '../../entities/promotion.entity';
import { User } from '../../entities/user.entity';
import { Merchant } from '../../entities/merchant.entity';   // ← already there
import { GenerateQrDto } from './dto/generate-qr.dto';
import { RedeemDto } from './dto/redeem.dto';
import * as crypto from 'crypto';
import { OnEvent } from '@nestjs/event-emitter';
import { EVENTS } from '../events/event.types';
import { EventEmitter2 } from '@nestjs/event-emitter';

@Injectable()
export class RedemptionsService {
  constructor(
    @InjectRepository(Redemption)
    private redemptionRepo: Repository<Redemption>,

    @InjectRepository(Promotion)
    private promotionRepo: Repository<Promotion>,

    @InjectRepository(User)
    private userRepo: Repository<User>,

    @InjectRepository(Merchant)                    // ← FIXED: now properly injected
    private merchantRepo: Repository<Merchant>,

    private eventEmitter: EventEmitter2,
  ) {}

  async generateQR(userId: string, dto: GenerateQrDto) {
    // ... (your existing generateQR code stays exactly the same)
    const promotion = await this.promotionRepo.findOne({
      where: { id: dto.promotionId, isActive: true },
      relations: ['merchant'],
    });

    if (!promotion) throw new NotFoundException('Promotion not found or inactive');

    if (promotion.expiry < new Date()) {
      throw new BadRequestException('Promotion has expired');
    }

    if (promotion.merchantId === userId) {
      throw new BadRequestException('You cannot generate QR code for your own promotion');
    }

    const userExists = await this.userRepo.findOne({ where: { id: userId } }) ||
                      await this.merchantRepo.findOne({ where: { id: userId } });

    if (!userExists) throw new NotFoundException('User not found');

    const existing = await this.redemptionRepo.findOne({
      where: { promotionId: dto.promotionId, customerId: userId },
    });

    if (existing) {
      throw new BadRequestException('You have already generated a QR for this promotion');
    }

    const qrCode = crypto.randomBytes(16).toString('hex');

    const redemption = this.redemptionRepo.create({
      promotion,
      promotionId: dto.promotionId,
      customer: userExists,
      customerId: userId,
      qrCode,
      isRedeemed: false,
      quantity: dto.quantity,
    });

    const saved = await this.redemptionRepo.save(redemption);

    const qrDataUrl = await QRCode.toDataURL(qrCode, { width: 300 });

    return {
      redemptionId: saved.id,
      qrImage: qrDataUrl,
      message: 'Show this QR code to the merchant to redeem',
      promotionTitle: promotion.title,
      quantity: dto.quantity,
    };
  }

  async redeem(qrCode: string, merchantId: string) {
    const result = await this.promotionRepo.manager.transaction(async (manager) => {
      const redemption = await manager.findOne(Redemption, {
        where: { qrCode, isRedeemed: false },
        relations: ['promotion', 'promotion.merchant'],
      });

      if (!redemption || redemption.isRedeemed) {
        throw new BadRequestException('Invalid or already redeemed QR code');
      }

      if (redemption.promotion.merchantId !== merchantId) {
        throw new BadRequestException('Unauthorized redemption attempt');
      }

      const promotion = redemption.promotion;
      const merchant = promotion.merchant;
      const quantity = redemption.quantity || 1;

      if (promotion.quantityLimit > 0 && promotion.redeemedCount + quantity > promotion.quantityLimit) {
        throw new BadRequestException('Promotion quantity limit reached');
      }

      const successFee = Math.round(promotion.price * 0.03 * quantity * 100) / 100;

      // Debug log so you can see exactly what is being charged
      console.log(`[Redemption] Adding success fee ₦${successFee} to merchant ${merchant.id} (price: ${promotion.price}, qty: ${quantity})`);

      // Update redeemedCount with safe query
      const updateResult = await manager
        .createQueryBuilder()
        .update(Promotion)
        .set({ redeemedCount: () => `"redeemedCount" + ${quantity}` })
        .where('id = :id', { id: promotion.id })
        .andWhere('(quantityLimit = 0 OR "redeemedCount" + :qty <= "quantityLimit")', { qty: quantity })
        .execute();

      if (updateResult.affected === 0) {
        throw new BadRequestException('Promotion quantity limit reached');
      }

      await manager.update(Redemption, redemption.id, {
        isRedeemed: true,
        redeemedAt: new Date(),
      });

      // ←←← FIXED: Clean atomic balance increment (this was the broken part)
      await manager.increment(
        Merchant,
        { id: merchant.id },
        'outstandingBalance',
        successFee,
      );

      return {
        promotionId: promotion.id,
        merchantId: merchant.id,
        customerId: redemption.customerId,
        promotionTitle: promotion.title,
        businessName: merchant.businessName,
        successFee,
        quantity,
      };
    });

    this.eventEmitter.emit(EVENTS.PROMOTION_REDEEMED, {
      promotionId: result.promotionId,
      merchantId: result.merchantId,
      customerId: result.customerId,
      amount: result.successFee,
    });

    return {
      message: 'Redemption successful!',
      promotionTitle: result.promotionTitle,
      businessName: result.businessName,
      successFeeCharged: result.successFee,
      quantity: result.quantity,
    };
  }

  async getMyRedemptions(userId: string) {
    return await this.redemptionRepo.find({
      where: { customerId: userId },
      relations: ['promotion', 'promotion.merchant'],
      order: {
        isRedeemed: 'ASC',
        createdAt: 'DESC',
      },
    });
  }
}