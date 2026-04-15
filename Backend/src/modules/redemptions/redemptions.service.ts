import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as QRCode from 'qrcode';
import { Redemption } from '../../entities/redemption.entity';
import { Promotion } from '../../entities/promotion.entity';
import { User } from '../../entities/user.entity';
import { GenerateQrDto } from './dto/generate-qr.dto';
import * as crypto from 'crypto';
import { Merchant } from '../../entities/merchant.entity';
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
    private eventEmitter: EventEmitter2,
  ) {}

  async generateQR(customerId: string, dto: GenerateQrDto) {
    const promotion = await this.promotionRepo.findOne({
      where: { id: dto.promotionId, isActive: true },
    });
    if (!promotion)
      throw new NotFoundException('Promotion not found or inactive');

    //expiry check
    if (promotion.expiry < new Date()) {
      throw new BadRequestException('Promotion expired');
    }

    const customer = await this.userRepo.findOne({ where: { id: customerId } });
    if (!customer) throw new NotFoundException('Customer not found');

    //prevent duplicate QR
    const existing = await this.redemptionRepo.findOne({
      where: {
        promotionId: dto.promotionId,
        customerId,
      },
    });

    if (existing) {
      throw new BadRequestException('QR already generated for this promotion');
    }

    // Create unique redemption record (QR token)
    const qrCode = crypto.randomBytes(16).toString('hex'); // 32 chars, very low collision chance

    const redemption = this.redemptionRepo.create({
      promotion,
      promotionId: dto.promotionId,
      customer,
      customerId,
      qrCode,
      isRedeemed: false,
    });

    const saved = await this.redemptionRepo.save(redemption);

    // Generate QR image as base64
    const qrDataUrl = await QRCode.toDataURL(qrCode, { width: 300 });

    return {
      redemptionId: saved.id,
      qrCode, // for debug
      qrImage: qrDataUrl, // send this to frontend (img src)
      message: 'Show this QR to merchant',
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

      if (
        promotion.quantityLimit > 0 &&
        promotion.redeemedCount >= promotion.quantityLimit
      ) {
        throw new BadRequestException('Promotion quantity limit reached');
      }

      const successFee = Math.round(promotion.price * 0.03 * 100) / 100;

      const updateResult = await manager
        .createQueryBuilder()
        .update(Promotion)
        .set({ redeemedCount: () => '"redeemedCount" + 1' })
        .where('id = :id', { id: promotion.id })
        .andWhere('(quantityLimit = 0 OR "redeemedCount" < "quantityLimit")')
        .execute();

      if (updateResult.affected === 0) {
        throw new BadRequestException('Promotion quantity limit reached');
      }

      await manager.update(Redemption, redemption.id, {
        isRedeemed: true,
        redeemedAt: new Date(),
      });

      await manager
        .createQueryBuilder()
        .update(Merchant)
        .set({
          outstandingBalance: () => `"outstandingBalance" + ${successFee}`,
        })
        .where("id = :id", { id: merchant.id })
        .execute();

      return {
        promotionId: promotion.id,
        merchantId: merchant.id,
        customerId: redemption.customerId,
        promotionTitle: promotion.title,
        businessName: merchant.businessName,
        successFee,
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
    };
  }
}
