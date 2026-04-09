import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MerchantsService } from './merchants.service';
import { Merchant } from '../../entities/merchant.entity';
import { LGA } from '../../entities/lga.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Merchant, LGA])],
  providers: [MerchantsService],
  exports: [MerchantsService],
})
export class MerchantsModule {}