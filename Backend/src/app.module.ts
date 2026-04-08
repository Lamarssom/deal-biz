import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerModule } from '@nestjs/throttler';

import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { MerchantsModule } from './modules/merchants/merchants.module';
import { PromotionsModule } from './modules/promotions/promotions.module';
import { RedemptionsModule } from './modules/redemptions/redemptions.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { LocationModule } from './modules/location/location.module';
import { DatabaseModule } from './database/database.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DatabaseModule,
    ThrottlerModule.forRoot({
      throttlers: [
        {
          ttl: 60000,
          limit: 10,
        }
      ]
    }), // 10 req/minute/IP
    ScheduleModule.forRoot(),

    AuthModule,
    UsersModule,
    MerchantsModule,
    PromotionsModule,
    RedemptionsModule,
    PaymentsModule,
    AnalyticsModule,
    LocationModule,
  ],
})
export class AppModule {}