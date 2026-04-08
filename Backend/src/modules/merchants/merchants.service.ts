// modules/merchants/merchants.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';

@Injectable()
export class MerchantsService {
  constructor(@InjectRepository(Merchant) private repo: Repository<Merchant>) {}

  findById(id: string) {
    return this.repo.findOne({ where: { id } });
  }

  findByEmail(email: string) {
    return this.repo.findOne({ where: { email } });
  }

  create(data: Partial<Merchant>) {
    return this.repo.create(data);
  }

  save(merchant: Merchant) {
    return this.repo.save(merchant);
  }

  update(criteria: any, data: Partial<Merchant>) {
    return this.repo.update(criteria, data);
  }

  findOne(options: any) {
    return this.repo.findOne(options);
  }
}