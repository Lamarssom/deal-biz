//src\modules\analytics\analytics.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Promotion } from '../../entities/promotion.entity';
import { Redemption } from '../../entities/redemption.entity';

@Injectable()
export class AnalyticsService {
  constructor(
    @InjectRepository(Promotion)
    private promotionRepo: Repository<Promotion>,
    @InjectRepository(Redemption)
    private redemptionRepo: Repository<Redemption>,
  ) {}

  async getMerchantAnalytics(merchantId: string) {
    const promotions = await this.promotionRepo.find({
      where: { merchantId },
    });

    const totalPromotions = promotions.length;
    const totalRedemptions = promotions.reduce(
      (sum, p) => sum + (p.redeemedCount || 0),
      0,
    );
    const activePromotions = promotions.filter(
      (p) => p.isActive && new Date(p.expiry) > new Date(),
    ).length;

    return {
      totalPromotions,
      totalRedemptions,
      activePromotions,
      estimatedFootTraffic: Math.round(totalRedemptions * 1.5),
      promotions: promotions.map((p) => ({
        id: p.id,
        title: p.title,
        type: p.type,
        redeemedCount: p.redeemedCount,
        views: p.views || 0,
        expiry: p.expiry,
      })),
    };
  }
}
