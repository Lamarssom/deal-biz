//src\modules\promotions\promotions.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PromotionsController } from './promotions.controller';
import { PromotionsService } from './promotions.service';
import { Promotion } from '../../entities/promotion.entity';
import { Merchant } from '../../entities/merchant.entity';
import { LocationModule } from '../location/location.module';
import { PaymentsModule } from '../payments/payments.module';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [
    TypeOrmModule.forFeature([Promotion, Merchant]),
    LocationModule,
    PaymentsModule,
    HttpModule,
  ],
  controllers: [PromotionsController],
  providers: [PromotionsService],
  exports: [PromotionsService],
})
export class PromotionsModule {}