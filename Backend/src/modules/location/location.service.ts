import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { LGA } from '../../entities/lga.entity';
import { calculateHaversineDistance } from '../../common/utils/haversine';
import { getBoundingBox } from '../../common/utils/bounding-box';

@Injectable()
export class LocationService {
  constructor(
    @InjectRepository(Merchant)
    private merchantRepo: Repository<Merchant>,
    @InjectRepository(LGA)
    private lgaRepo: Repository<LGA>,
  ) {}

  async findMerchantsInRadius(
    userLat: number,
    userLng: number,
    radiusKm: number = 3,
    limit: number = 20,
  ): Promise<any[]> {
    const { minLat, maxLat, minLng, maxLng } = getBoundingBox(
      userLat,
      userLng,
      radiusKm,
    );

    const queryBuilder = this.merchantRepo
      .createQueryBuilder('merchant')
      .addSelect(`(${calculateHaversineDistance.sql})`, 'distance_km')
      .where('merchant.isVerified = :isVerified', { isVerified: true })
      .andWhere('merchant.isActive = :isActive', { isActive: true })
      .andWhere('merchant.latitude BETWEEN :minLat AND :maxLat', {
        minLat,
        maxLat,
      })
      .andWhere('merchant.longitude BETWEEN :minLng AND :maxLng', {
        minLng,
        maxLng,
      })
      .andWhere(`(${calculateHaversineDistance.sql}) <= :radiusKm`)
      .setParameters({
        userLat,
        userLng,
        radiusKm,
      })
      .orderBy('distance_km', 'ASC')
      .limit(limit);

    const merchants = await queryBuilder.getRawMany();

    return merchants.map((m) => ({
      id: m.merchant_id,
      businessName: m.merchant_businessName,
      category: m.merchant_category,
      businessLGA: m.merchant_businessLGA,
      latitude: Number(m.merchant_latitude),
      longitude: Number(m.merchant_longitude),
      distanceKm: Number(m.distance_km.toFixed(2)),
    }));
  }

  // Keep JS version for testing / small datasets
  calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number,
  ): number {
    return calculateHaversineDistance.js(lat1, lon1, lat2, lon2);
  }

  async getStates(): Promise<{ id: number; state: string }[]> {
    const states = await this.lgaRepo
      .createQueryBuilder('lga')
      .select('DISTINCT lga.state', 'state')
      .orderBy('lga.state', 'ASC')
      .getRawMany();

    return states.map((item, index) => ({
      id: index + 1,
      state: item.state,
    }));
  }

  async getLGAs(state?: string): Promise<{ id: number; lga: string; state: string }[]> {
    let query = this.lgaRepo.createQueryBuilder('lga');

    if (state) {
      query = query.where('lga.state = :state', { state });
    }

    const lgas = await query
      .select('MIN(lga.id)', 'id')
      .addSelect('lga.lga', 'lga')
      .addSelect('lga.state', 'state')
      .groupBy('lga.lga')
      .addGroupBy('lga.state')
      .orderBy('lga.lga', 'ASC')
      .getRawMany();

    return lgas.map(item => ({
      id: parseInt(item.id),
      lga: item.lga,
      state: item.state,
    }));
  }
}
