// modules/merchants/merchants.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';

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
        select: ['id', 'email', 'password', 'role', 'isVerified']
    });
    }

  findById(id: string) {
    return this.repo.findOne({ where: { id } });
  }

  update(criteria: any, data: Partial<Merchant>) {
    return this.repo.update(criteria, data);
  }
}