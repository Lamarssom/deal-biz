// modules/merchants/merchants.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { getBoundingBox } from '../../common/utils/bounding-box'
import { haversine } from '../../common/utils/haversine'

@Injectable()
export class MerchantsService {
  constructor(
    @InjectRepository(Merchant)
    private readonly repo: Repository<Merchant>,
  ) {}

  create(data: Partial<Merchant>) {
    return this.repo.create(data);
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