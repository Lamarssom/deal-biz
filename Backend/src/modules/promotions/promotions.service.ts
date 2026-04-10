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
import { Promotion } from '../../entities/promotion.entity';
import { Merchant } from '../../entities/merchant.entity';
import { CreatePromotionDto } from './dto/create-promotion.dto';
import { LocationService } from '../location/location.service';
import { PromotionsRankingService } from './promotions-ranking.service';
import { v4 as uuidv4 } from 'uuid';

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
  ) {}

  async createPromotion(merchantId: string, dto: CreatePromotionDto) {
    const merchant = await this.merchantRepo.findOne({
      where: { id: merchantId, isVerified: true, isActive: true },
    });
    if (!merchant)
      throw new NotFoundException('Merchant not found or not verified');

    // Auto-set fee & radius based on type (per PDF spec)
    const fee = dto.type === 'STANDARD' ? 100 : 50;
    const radiusKm = dto.type === 'STANDARD' ? 3 : 1;

    // Idempotency
    const idempotencyKey =
      dto.idempotencyKey || `promo-${merchantId}-${uuidv4()}`;

    // Check if this exact promotion request already exists (idempotency)
    const existing = await this.promotionRepo.findOne({
      where: { idempotencyKey, merchantId },
    });
    if (existing)
      return {
        message: 'Promotion already processed',
        promotionId: existing.id,
      };

    // Create pending promotion
    const promotion = this.promotionRepo.create({
      merchant,
      merchantId,
      type: dto.type,
      fee,
      price: dto.price,
      originalPrice: dto.originalPrice,
      title: dto.title,
      description: dto.description,
      photoUrl: dto.photoUrl,
      radiusKm,
      expiry: new Date(dto.expiry),
      quantityLimit: dto.quantityLimit,
      idempotencyKey,
      isActive: false, // stays pending until payment confirmed
    });

    const savedPromo = await this.promotionRepo.save(promotion);

    // === PAYSTACK INITIALIZE ===
    const paystackUrl = 'https://api.paystack.co/transaction/initialize';
    const payload = {
      amount: fee * 100, // kobo
      email: merchant.email,
      reference: idempotencyKey,
      metadata: {
        promotionId: savedPromo.id,
        merchantId,
        type: dto.type,
      },
      callback_url: 'http://localhost:3000/payments/callback', // frontend will handle redirect
    };

    const response = await firstValueFrom(
      this.httpService.post(paystackUrl, payload, {
        headers: {
          Authorization: `Bearer ${this.configService.get('PAYSTACK_SECRET_KEY')}`,
          'Content-Type': 'application/json',
        },
      }),
    );

    const { data } = response.data;

    return {
      message: 'Promotion created – complete payment to go live',
      promotionId: savedPromo.id,
      paystackReference: data.reference,
      authorizationUrl: data.authorization_url, // frontend redirects merchant here
      fee,
      type: dto.type,
    };
  }

  async getNearbyPromotions(userLat: number, userLng: number, radiusKm: number = 5, limit: number = 20) {
    // 1. Get verified merchants in radius (SQL query from Phase 3)
    const merchants = await this.locationService.findMerchantsInRadius(userLat, userLng, radiusKm, 100); // get more to rank

    if (merchants.length === 0) return [];

    // 2. Get active promotions for these merchants
    const promotions = await this.promotionRepo.find({
      where: {
        merchantId: In(merchants.map(m => m.id)),
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
}
