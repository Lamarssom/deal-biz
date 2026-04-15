//src\modules\promotions\promotions.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PromotionsController } from './promotions.controller';
import { PromotionsService } from './promotions.service';
import { Promotion } from '../../entities/promotion.entity';
import { Merchant } from '../../entities/merchant.entity';
import { LocationModule } from '../location/location.module';
import { PromotionsRankingService } from './promotions-ranking.service';
import { HttpModule } from '@nestjs/axios';

@Module({
  imports: [
    TypeOrmModule.forFeature([Promotion, Merchant]),
    LocationModule,
    HttpModule,
  ],
  controllers: [PromotionsController],
  providers: [PromotionsService, PromotionsRankingService],
  exports: [PromotionsService],
})
export class PromotionsModule {}