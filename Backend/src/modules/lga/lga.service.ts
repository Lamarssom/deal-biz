//\src\modules\lga\lga.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LGA } from '../../entities/lga.entity';

@Injectable()
export class LgaService {
  constructor(
    @InjectRepository(LGA)
    private readonly repo: Repository<LGA>,
  ) {}

  findByName(lga: string) {
    return this.repo.findOne({ where: { lga } });
  }

  findByLgaAndWard(lga: string, ward: string) {
    return this.repo.findOne({ where: { lga, ward } });
  }

  findAll() {
    return this.repo.find();
  }
}