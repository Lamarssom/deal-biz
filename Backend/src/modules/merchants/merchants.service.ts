// modules/merchants/merchants.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { getBoundingBox } from '../../common/utils/bounding-box'
import { calculateHaversineDistance } from '../../common/utils/haversine'
import { LGA } from '../../entities/lga.entity';

@Injectable()
export class MerchantsService {
  constructor(
    @InjectRepository(Merchant)
    private readonly repo: Repository<Merchant>,

    @InjectRepository(LGA)
    private readonly lgaRepo: Repository<LGA>,
  ) {}

  async create(data: Partial<Merchant>) {

    if (!data.businessLGA) {
        throw new Error('Business LGA is required');
    }

    const lga = await this.lgaRepo.findOne({
        where: { lga: data.businessLGA }
    });

    if (!lga) {
        throw new Error('Invalid LGA');
    }

    const merchant = this.repo.create({
        ...data,
        latitude: lga.latitude,
        longitude: lga.longitude
    });

    return merchant;
    }

  save(merchant: Merchant) {
    return this.repo.save(merchant);
  }

  async findOne(email: string) {
    return this.repo.findOne({
        where: { email },
        select: ['id', 'email', 'password', 'role', 'isVerified', 'verificationCode', 'verificationExpiresAt']
    });
  }

  findById(id: string) {
    return this.repo.findOne({ where: { id } });
  }

  update(criteria: any, data: Partial<Merchant>) {
    return this.repo.update(criteria, data);
  }

  async findNearby(lat: number, lng: number, radius = 10) {

    const { minLat, maxLat, minLng, maxLng } =
        getBoundingBox(lat, lng, radius)

    const merchants = await this.repo.query(`
        SELECT *,
        (
        6371 * acos(
            cos(radians($1)) *
            cos(radians(latitude)) *
            cos(radians(longitude) - radians($2)) +
            sin(radians($1)) *
            sin(radians(latitude))
        )
        ) AS distance
        FROM merchants
        WHERE latitude BETWEEN $3 AND $4
        AND longitude BETWEEN $5 AND $6
        AND latitude IS NOT NULL
        AND longitude IS NOT NULL
        HAVING distance <= $7
        ORDER BY distance
        LIMIT 20
    `, [lat, lng, minLat, maxLat, minLng, maxLng, radius])

    return merchants
    }
}