//src\modules\analytics\analytics.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnalyticsController } from './analytics.controller';
import { AnalyticsService } from './analytics.service';
import { Promotion } from '../../entities/promotion.entity';
import { Redemption } from '../../entities/redemption.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Promotion, Redemption])],
  controllers: [AnalyticsController],
  providers: [AnalyticsService],
})
export class AnalyticsModule {}
