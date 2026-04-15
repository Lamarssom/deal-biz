// modules/merchants/merchants.service.ts
import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { getBoundingBox } from '../../common/utils/bounding-box';
import { calculateHaversineDistance } from '../../common/utils/haversine';
import { LGA } from '../../entities/lga.entity';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class MerchantsService {
  constructor(
    @InjectRepository(Merchant)
    private readonly merchantRepo: Repository<Merchant>,

    @InjectRepository(LGA)
    private readonly lgaRepo: Repository<LGA>,
    private httpService: HttpService,
    private configService: ConfigService,
  ) {}

  async create(data: Partial<Merchant>) {
    if (!data.businessLGA) {
      throw new Error('Business LGA is required');
    }

    const lga = await this.lgaRepo.findOne({
      where: { lga: data.businessLGA },
    });

    if (!lga) {
      throw new Error('Invalid LGA');
    }

    const merchant = this.merchantRepo.create({
      ...data,
      latitude: lga.latitude,
      longitude: lga.longitude,
    });

    return merchant;
  }

  save(merchant: Merchant) {
    return this.merchantRepo.save(merchant);
  }

  async findOne(email: string) {
    return this.merchantRepo.findOne({
      where: { email },
      select: [
        'id',
        'email',
        'password',
        'role',
        'isVerified',
        'verificationCode',
        'verificationExpiresAt',
      ],
    });
  }

  findById(id: string) {
    return this.merchantRepo.findOne({ where: { id } });
  }

  update(criteria: any, data: Partial<Merchant>) {
    return this.merchantRepo.update(criteria, data);
  }

  async findNearby(lat: number, lng: number, radius = 10) {
    const { minLat, maxLat, minLng, maxLng } = getBoundingBox(lat, lng, radius);

    const merchants = await this.merchantRepo.query(
      `
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
    `,
      [lat, lng, minLat, maxLat, minLng, maxLng, radius],
    );

    return merchants;
  }

  async updateBalance(merchantId: string, amount: number) {
    return this.merchantRepo.update(merchantId, {
      outstandingBalance: () => `"outstandingBalance" - ${amount}`,
    });
  }

  async settleBalance(merchantId: string, amount: number) {
    const merchant = await this.merchantRepo.findOne({
      where: { id: merchantId },
    });
    if (!merchant) throw new NotFoundException('Merchant not found');

    if (amount > merchant.outstandingBalance) {
      throw new BadRequestException('Amount exceeds outstanding balance');
    }

    // Paystack payment for balance
    const paystackUrl = 'https://api.paystack.co/transaction/initialize';
    const payload = {
      amount: Math.round(amount * 100),
      email: merchant.email,
      reference: `settle-${merchantId}-${Date.now()}`,
      metadata: { merchantId, type: 'balance_settlement' },
      callback_url: 'http://localhost:3000/payments/callback',
    };

    const response = await firstValueFrom(
      this.httpService.post(paystackUrl, payload, {
        headers: {
          Authorization: `Bearer ${this.configService.get('PAYSTACK_SECRET_KEY')}`,
          'Content-Type': 'application/json',
        },
      }),
    );

    return {
      authorizationUrl: response.data.data.authorization_url,
      reference: response.data.data.reference,
      amount,
      remainingBalance: merchant.outstandingBalance - amount,
    };
  }
}
