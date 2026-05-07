//src\modules\promotions\promotions.service.ts
import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In, MoreThan, MoreThanOrEqual } from 'typeorm';
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
import { calculateHaversineDistance } from '../../common/utils/haversine';

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

    if (!merchant)
      throw new NotFoundException('Merchant not found or not verified');

    // Credit Limit Check
    if (Number(merchant?.outstandingBalance) >= 5000) {
      throw new BadRequestException(
        'Outstanding balance limit reached. Please settle your invoice.',
      );
    }

    // Daily Reset Logic
    const now = new Date();
    if (
      !merchant.dailyResetAt ||
      merchant.dailyResetAt.getDate() !== now.getDate()
    ) {
      merchant.dailySpendThisDay = 0;
      merchant.dailyResetAt = now;
      await this.merchantRepo.save(merchant);
    }

    //Daily Promo Cap
    const todayStart = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
    );
    const todayPromos = await this.promotionRepo.count({
      where: {
        merchantId,
        createdAt: MoreThanOrEqual(todayStart),
      },
    });
    if (todayPromos >= merchant.dailyPromoLimit) {
      throw new BadRequestException(
        `Daily promo limit reached (${merchant.dailyPromoLimit}/day)`,
      );
    }

    // Max of 3 activve promos
    const activePromos = await this.promotionRepo.count({
      where: {
        merchantId,
        isActive: true,
        expiry: MoreThan(now),
      },
    });
    if (activePromos >= merchant.maxActivePromos) {
      throw new BadRequestException(
        'Maximum 3 active promotions allowed. Expire or delete one first.',
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
    radiusKm: number = 15,   // Increased default
    limit: number = 20,
  ): Promise<any[]> {
    try {
      console.log(`Searching promotions near: ${userLat}, ${userLng} (radius: ${radiusKm}km)`);

      // 1. Get merchants in radius
      const merchants = await this.locationService.findMerchantsInRadius(
        userLat,
        userLng,
        radiusKm,
        100,
      );

      console.log(`Found ${merchants.length} merchants in radius`);

      if (merchants.length === 0) {
        console.log('No merchants in radius. Trying wider search (30km)...');
        // Fallback: wider search
        const widerMerchants = await this.locationService.findMerchantsInRadius(
          userLat, userLng, 30, 50
        );

        if (widerMerchants.length === 0) {
          // Ultimate fallback: return all active promotions
          console.log('No merchants found even in wide radius. Returning all active promotions.');
          const allActive = await this.promotionRepo.find({
            where: { isActive: true, expiry: MoreThan(new Date()) },
            relations: ['merchant'],
            take: limit,
          });

          return allActive.map(p => this.formatPromotion(p, userLat, userLng));
        }

        // Use wider results
        const merchantIds = widerMerchants.map(m => m.id);
        const promotions = await this.promotionRepo.find({
          where: { merchantId: In(merchantIds), isActive: true, expiry: MoreThan(new Date()) },
          relations: ['merchant'],
          take: 100,
        });

        return this.formatAndRankPromotions(promotions, userLat, userLng, limit);
      }

      // Normal flow
      const merchantIds = merchants.map(m => m.id);
      const promotions = await this.promotionRepo.find({
        where: {
          merchantId: In(merchantIds),
          isActive: true,
          expiry: MoreThan(new Date()),
        },
        relations: ['merchant'],
        take: 100,
      });

      return this.formatAndRankPromotions(promotions, userLat, userLng, limit);

    } catch (error) {
      console.error('Error in getNearbyPromotions:', error);
      return [];
    }
  }

  // Helper method
  private formatPromotion(promo: Promotion, userLat: number, userLng: number) {
    return {
      id: promo.id,
      title: promo.title,
      type: promo.type,
      price: Number(promo.price),
      originalPrice: Number(promo.originalPrice),
      expiry: promo.expiry,
      quantityLimit: promo.quantityLimit,
      redeemedCount: promo.redeemedCount || 0,
      views: promo.views || 0,
      merchant: {
        id: promo.merchant.id,
        businessName: promo.merchant.businessName,
        category: promo.merchant.category,
        businessLGA: promo.merchant.businessLGA,
      },
      distanceKm: Number(
        this.locationService.calculateDistance(
          userLat, userLng,
          Number(promo.merchant.latitude),
          Number(promo.merchant.longitude)
        ).toFixed(1)
      ),
    };
  }

  private formatAndRankPromotions(promotions: Promotion[], userLat: number, userLng: number, limit: number) {
    if (promotions.length === 0) return [];

    const ranked = this.promotionsRankingService.rankPromotions(userLat, userLng, promotions);
    
    return ranked.slice(0, limit).map(p => this.formatPromotion(p, userLat, userLng));
  }

  async activatePromotion(promotionId: string) {
    try {
      const promo = await this.promotionRepo.findOne({
        where: { id: promotionId },
        relations: ['merchant']
      });

      if (!promo) {
        console.error(`Promotion ${promotionId} not found`);
        return;
      }

      if (promo.isActive) {
        console.log(`Promotion ${promotionId} is already active`);
        return;
      }

      await this.promotionRepo.update(promotionId, { 
        isActive: true,
        updatedAt: new Date()
      });

      console.log(`✅ Promotion ${promotionId} is now LIVE! Title: ${promo.title}`);
    } catch (error) {
      console.error('Failed to activate promotion:', error);
    }
  }

  @OnEvent(EVENTS.PAYMENT_SUCCESS)
  async handlePaymentSuccess(payload: { promotionId: string }) {
    await this.activatePromotion(payload.promotionId);
  }
}
