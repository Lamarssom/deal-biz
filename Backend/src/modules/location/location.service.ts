import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { calculateHaversineDistance } from '../../common/utils/haversine';
import { getBoundingBox } from '../../common/utils/bounding-box';

@Injectable()
export class LocationService {
  constructor(
    @InjectRepository(Merchant)
    private merchantRepo: Repository<Merchant>,
  ) {}

  async findMerchantsInRadius(
    userLat: number,
    userLng: number,
    radiusKm: number = 3,
    limit: number = 20,
  ): Promise<Merchant[]> {
    const { minLat, maxLat, minLng, maxLng } = getBoundingBox(userLat, userLng, radiusKm);

    const query = `
      SELECT *,
             (${calculateHaversineDistance.sql}) AS distance_km
      FROM merchants
      WHERE is_verified = true
        AND is_active = true
        AND latitude BETWEEN $1 AND $2
        AND longitude BETWEEN $3 AND $4
        AND (${calculateHaversineDistance.sql}) <= $5
      ORDER BY distance_km ASC
      LIMIT $6
    `;

    const merchants = await this.merchantRepo.query(query, [
        minLat,        // $1
        maxLat,        // $2
        minLng,        // $3
        maxLng,        // $4
        radiusKm,      // $5
        limit,         // $6
        userLat,       // $7
        userLng        // $8
    ]);

    return merchants;
  }

  // Keep JS version for testing / small datasets
  calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    return calculateHaversineDistance.js(lat1, lon1, lat2, lon2);
  }
}