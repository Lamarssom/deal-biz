import { Injectable } from '@nestjs/common';
import { Merchant } from '../../entities/merchant.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class LocationService {
  constructor(
    @InjectRepository(Merchant)
    private merchantRepo: Repository<Merchant>,
  ) {}

  // Pure Haversine formula (used in dev + for ranking)
  calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number,
  ): number {
    const R = 6371; // Earth radius in km
    const dLat = this.toRad(lat2 - lat1);
    const dLon = this.toRad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRad(lat1)) *
        Math.cos(this.toRad(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c; // distance in km
  }

  private toRad(value: number): number {
    return (value * Math.PI) / 180;
  }

  // Find all merchants/deals within radius (km) of a point
  async findMerchantsInRadius(
    lat: number,
    lng: number,
    radiusKm: number = 3,
  ): Promise<Merchant[]> {
    // For now we use Haversine (fast for MVP)
    // Later we will switch to PostGIS ST_DWithin for production scale
    const merchants = await this.merchantRepo.find({
      where: { isVerified: true, isActive: true },
    });

    return merchants
      .filter((m) => {
        if (!m.latitude || !m.longitude) return false;
        const distance = this.calculateDistance(lat, lng, m.latitude, m.longitude);
        return distance <= radiusKm;
      })
      .sort((a, b) => {
        const distA = this.calculateDistance(lat, lng, a.latitude!, a.longitude!);
        const distB = this.calculateDistance(lat, lng, b.latitude!, b.longitude!);
        return distA - distB;
      });
  }

  // Future PostGIS version (uncomment PostGIS extension is enabled)
  /*
  async findMerchantsInRadiusPostGIS(
    lat: number,
    lng: number,
    radiusMeters: number = 3000,
  ) {
    return this.merchantRepo.query(`
      SELECT * FROM merchants 
      WHERE is_verified = true 
        AND is_active = true
        AND ST_DWithin(
          location::geography, 
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography, 
          $3
        )
      ORDER BY ST_Distance(
        location::geography, 
        ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography
      )
    `, [lng, lat, radiusMeters]);
  }
  */
}