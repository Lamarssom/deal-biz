import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Merchant } from '../../entities/merchant.entity';

import { LocationService } from './location.service';
import { LocationController } from './location.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Merchant])],
  controllers: [LocationController],
  providers: [LocationService],
  exports: [LocationService],
})
export class LocationModule {}