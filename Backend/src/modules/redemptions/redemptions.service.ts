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

@Injectable()
export class RedemptionsService {
  constructor(
    @InjectRepository(Redemption)
    private redemptionRepo: Repository<Redemption>,
    @InjectRepository(Promotion)
    private promotionRepo: Repository<Promotion>,
    @InjectRepository(User)
    private userRepo: Repository<User>,
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
    // Atomic transaction (critical for quantity + redemption record)
    return this.promotionRepo.manager.transaction(async (manager) => {
      const redemption = await manager.findOne(Redemption, {
        where: { qrCode, isRedeemed: false },
        relations: ['promotion', 'promotion.merchant'],
      });

      if (!redemption || redemption.isRedeemed) {
        console.warn('Fraud attempt: Attempted to redeem invalid QR code', {
          qrCode,
        });
        throw new BadRequestException('Invalid or already redeemed QR code');
      }

      if (redemption.promotion.merchantId !== merchantId) {
        throw new BadRequestException('Unauthorized redemption attempt');
      }

      const promotion = redemption.promotion;
      const merchant = promotion.merchant;

      // Check quantity limit
      if (
        promotion.quantityLimit > 0 &&
        promotion.redeemedCount >= promotion.quantityLimit
      ) {
        console.warn('Promotion quantity limit reached', {
          promotionId: promotion.id,
          attemptedRedemptionId: redemption.id,
        });
        throw new BadRequestException('Promotion quantity limit reached');
      }

      // 3% Success fee on discounted price
      const successFee = Math.round(promotion.price * 0.03 * 100) / 100;

      // Atomic update
      const result = await manager
        .createQueryBuilder()
        .update(Promotion)
        .set({ redeemedCount: () => '"redeemedCount" + 1' })
        .where('id = :id', { id: promotion.id })
        .andWhere('(quantityLimit = 0 OR "redeemedCount" < "quantityLimit")')
        .execute();

      if (result.affected === 0) {
        throw new BadRequestException('Promotion quantity limit reached');
      }


      await manager.update(Redemption, redemption.id, {
        isRedeemed: true,
        redeemedAt: new Date(),
      });

      await manager.update(Merchant, merchant.id, {
        outstandingBalance: merchant.outstandingBalance + successFee,
      }

      return {
        message: 'Redemption successful!',
        promotionTitle: promotion.title,
        businessName: promotion.merchant?.businessName,
        successFeeCharged: successFee,
      };
    });
  }
}
