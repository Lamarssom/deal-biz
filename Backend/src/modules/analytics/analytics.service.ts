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

    const now = new Date();

    const totalPromotions = promotions.length;

    const totalRedemptions = promotions.reduce(
      (sum, p) => sum + (p.redeemedCount || 0),
      0,
    );

    const activePromotions = promotions.filter(
      (p) => p.isActive && new Date(p.expiry) > now,
    ).length;

    const expiredPromotions = promotions.filter(
      (p) => new Date(p.expiry) <= now,
    ).length;

    return {
      totalPromotions,
      totalRedemptions,
      activePromotions,
      expiredPromotions,

      // ROI metric (safe + capped)
      estimatedFootTraffic: Math.min(Math.round(totalRedemptions * 1.5), 9999),

      promotions: promotions.map((p) => ({
        id: p.id,
        title: p.title,
        type: p.type,

        redeemedCount: p.redeemedCount,
        views: p.views || 0,

        // 🔥 NEW: conversion rate
        conversionRate:
          p.views > 0 ? Math.round((p.redeemedCount / p.views) * 100) : 0,

        expiry: p.expiry,
      })),
    };
  }
}
