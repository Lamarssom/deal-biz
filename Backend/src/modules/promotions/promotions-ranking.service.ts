import { Injectable } from '@nestjs/common';
import { Promotion } from '../../entities/promotion.entity';
import { LocationService } from '../location/location.service';

@Injectable()
export class PromotionsRankingService {
  constructor(private locationService: LocationService) {}

  /**
   * Core ranking: distance + popularity + urgency
   * 1. Distance (closest first)
   * 2. Popularity (views + redemptions)
   * 3. Urgency (soonest expiry)
   */
  rankPromotions(userLat: number, userLng: number, promotions: Promotion[]): Promotion[] {
    return promotions
      .map((promo) => {

        if (!promo.merchant?.latitude || !promo.merchant?.longitude) {
          return null;
        }

        const distanceKm = this.locationService.calculateDistance(
          userLat,
          userLng,
          promo.merchant.latitude!,
          promo.merchant.longitude!,
        );

        const urgencyScore = (new Date(promo.expiry).getTime() - Date.now()) / (1000 * 60 * 60 * 24); // days left
        const popularityScore = promo.popularityScore || 0;

        // Composite score (lower = better rank)
        const score = distanceKm * 0.5 + popularityScore * -0.3 + urgencyScore * 0.2;

        return { promo, distanceKm, score };
      })
      
      .filter(Boolean)
      .sort((a, b) => a!.score - b!.score)
      .map((item) => item!.promo);
  }
}