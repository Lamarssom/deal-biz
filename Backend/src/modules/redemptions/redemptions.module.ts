//src\modules\redemptions\redemptions.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RedemptionsController } from './redemptions.controller';
import { RedemptionsService } from './redemptions.service';
import { Redemption } from '../../entities/redemption.entity';
import { Promotion } from '../../entities/promotion.entity';
import { User } from '../../entities/user.entity';
import { Merchant } from '../../entities/merchant.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Redemption, Promotion, User, Merchant])],
  controllers: [RedemptionsController],
  providers: [RedemptionsService],
  exports: [RedemptionsService],
})
export class RedemptionsModule {}
