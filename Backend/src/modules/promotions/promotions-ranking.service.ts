// src/modules/promotions/promotions-ranking.service.ts
import { Injectable } from '@nestjs/common';
import { Promotion } from '../../entities/promotion.entity';
import { LocationService } from '../location/location.service';

@Injectable()
export class PromotionsRankingService {
  constructor(private locationService: LocationService) {}

  rankPromotions(
    userLat: number,
    userLng: number,
    promotions: Promotion[],
  ): Promotion[] {
    if (promotions.length === 0) return [];

    return promotions
      .map((promo) => {
        // Skip any promotion with missing merchant location
        if (
          !promo.merchant ||
          promo.merchant.latitude === null ||
          promo.merchant.latitude === undefined ||
          promo.merchant.longitude === null ||
          promo.merchant.longitude === undefined
        ) {
          return null;
        }

        const distanceKm = this.locationService.calculateDistance(
          userLat,
          userLng,
          Number(promo.merchant.latitude),
          Number(promo.merchant.longitude),
        );

        const urgencyScore =
          (new Date(promo.expiry).getTime() - Date.now()) /
          (1000 * 60 * 60 * 24); // days left

        const popularityScore = promo.popularityScore || 0;

        // Composite score (lower = better rank)
        const score = distanceKm * 0.5 + popularityScore * -0.3 + urgencyScore * 0.2;

        return { promo, distanceKm, score };
      })
      // Type guard to tell TypeScript these are not null
      .filter((item): item is { promo: Promotion; distanceKm: number; score: number } => item !== null)
      .sort((a, b) => a.score - b.score)
      .map((item) => item.promo);
  }
}