//src\modules\promotions\promotions.service.ts
import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In, MoreThan } from 'typeorm';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { ConfigService } from '@nestjs/config';
import { Promotion, PromotionType } from '../../entities/promotion.entity';
import { Merchant } from '../../entities/merchant.entity';
import { CreatePromotionDto } from './dto/create-promotion.dto';
import { LocationService } from '../location/location.service';
import { PromotionsRankingService } from './promotions-ranking.service';
import { v4 as uuidv4 } from 'uuid';
import { OnEvent } from '@nestjs/event-emitter';
import { EVENTS } from '../events/event.types';
import { EventEmitter2 } from '@nestjs/event-emitter';

@Injectable()
export class PromotionsService {
  constructor(
    @InjectRepository(Promotion)
    private promotionRepo: Repository<Promotion>,
    @InjectRepository(Merchant)
    private merchantRepo: Repository<Merchant>,
    private locationService: LocationService,
    private httpService: HttpService,
    private configService: ConfigService,
    private promotionsRankingService: PromotionsRankingService,
    private eventEmitter: EventEmitter2,
  ) {}

  async createPromotion(merchantId: string, dto: CreatePromotionDto) {
    const merchant = await this.merchantRepo.findOne({
      where: { id: merchantId, isVerified: true, isActive: true },
    });
    
    if (!merchant) throw new NotFoundException('Merchant not found or not verified');

    if (Number(merchant?.outstandingBalance) >= 5000) {
      throw new BadRequestException(
        'Outstanding balance limit reached. Please settle your invoice.',
      );
    }
    // === HYBRID: Flat ₦25 creation fee ===
    const creationFee = 25;

    // Validate Expiry Date
    const expiryDate = new Date(dto.expiry);
    if (expiryDate <= new Date()) {
      throw new BadRequestException('Expiry must be in the future');
    }

    const maxDays = 7;
    const diffMs = expiryDate.getTime() - Date.now();
    const diffDays = diffMs / (1000 * 60 * 60 * 24);

    if (diffDays > maxDays) {
      throw new BadRequestException('Promotion cannot exceed 7 days');
    }

    // Price slashing validation
    if (dto.originalPrice && dto.price >= dto.originalPrice) {
      throw new BadRequestException(
        'Discounted price must be lower than original price',
      );
    }

    // Radius & visibility still respect type (Standard vs Micro)
    const radiusKm = dto.type === PromotionType.STANDARD ? 3 : 1;

    // Idempotency (reuse your existing pattern)
    const idempotencyKey =
      dto.idempotencyKey || `promo-${merchantId}-${uuidv4()}`;

    const existing = await this.promotionRepo.findOne({
      where: { idempotencyKey, merchantId },
    });
    if (existing)
      return {
        message: 'Promotion already processed',
        promotionId: existing.id,
      };

    const promotion = this.promotionRepo.create({
      merchant,
      merchantId,
      type: dto.type,
      fee: creationFee, // now always 25
      price: Number(dto.price),
      originalPrice: Number(dto.originalPrice),
      title: dto.title,
      description: dto.description,
      photoUrl: dto.photoUrl,
      radiusKm,
      expiry: new Date(dto.expiry),
      quantityLimit: dto.quantityLimit,
      idempotencyKey,
      isActive: false, // pending payment
    });

    const savedPromo = await this.promotionRepo.save(promotion);

    this.eventEmitter.emit(EVENTS.PROMOTION_CREATED, {
      promotionId: savedPromo.id,
      merchantId,
    });

    // Paystack – now for flat ₦25
    const paystackUrl = 'https://api.paystack.co/transaction/initialize';
    const payload = {
      amount: creationFee * 100, // kobo
      email: merchant.email,
      reference: idempotencyKey,
      metadata: {
        promotionId: savedPromo.id,
        merchantId,
        type: 'creation_fee',
      },
      callback_url: 'http://localhost:3000/payments/callback',
    };

    const response = await firstValueFrom(
      this.httpService.post(paystackUrl, payload, {
        headers: {
          Authorization: `Bearer ${this.configService.get('PAYSTACK_SECRET_KEY')}`,
          'Content-Type': 'application/json',
        },
      }),
    );

    type PaystackInitResponse = {
      data: {
        reference: string;
        authorization_url: string;
      };
    };

    const paystackResponse = response.data as PaystackInitResponse;

    const reference = paystackResponse.data.reference;
    const authorizationUrl = paystackResponse.data.authorization_url;

    return {
      message: 'Promotion created – pay ₦25 to go live',
      promotionId: savedPromo.id,
      paystackReference: reference,
      authorizationUrl,
      fee: creationFee,
      type: dto.type,
    };
  }

  async getNearbyPromotions(
    userLat: number,
    userLng: number,
    radiusKm: number = 5,
    limit: number = 20,
  ) {
    // 1. Get verified merchants in radius (SQL query from Phase 3)
    const merchants = await this.locationService.findMerchantsInRadius(
      userLat,
      userLng,
      radiusKm,
      100,
    ); // get more to rank

    if (merchants.length === 0) return [];

    const merchantIds: string[] = merchants.map((m) => m.id);

    // 2. Get active promotions for these merchants
    const promotions = await this.promotionRepo.find({
      where: {
        merchantId: In(merchantIds),
        isActive: true,
        expiry: MoreThan(new Date()),
      },
      relations: ['merchant'],
      take: 100,
    });

    // 3. Rank them (distance + popularity + urgency)
    return this.promotionsRankingService
      .rankPromotions(userLat, userLng, promotions)
      .slice(0, limit)
      .map((promo) => ({
        id: promo.id,
        title: promo.title,
        description: promo.description,
        type: promo.type,

        price: Number(promo.price),
        originalPrice: promo.originalPrice,

        radiusKm: Number(promo.radiusKm),
        expiry: promo.expiry,

        merchant: {
          id: promo.merchant.id,
          businessName: promo.merchant.businessName,
          category: promo.merchant.category,
          businessLGA: promo.merchant.businessLGA,
          latitude: Number(promo.merchant.latitude),
          longitude: Number(promo.merchant.longitude),
        },

        stats: {
          views: promo.views,
          redeemedCount: promo.redeemedCount,
        },
      }));
  }

  async activatePromotion(promotionId: string) {
    await this.promotionRepo.update(promotionId, { isActive: true });
    // TODO: send FCM/email notification later
    console.log(`✅ Promotion ${promotionId} is now LIVE!`);
  }

  @OnEvent(EVENTS.PAYMENT_SUCCESS)
  async handlePaymentSuccess(payload: { promotionId: string }) {
    await this.activatePromotion(payload.promotionId);
  }

}
