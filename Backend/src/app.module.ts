import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
// eslint-disable-next-line @typescript-eslint/no-unused-vars
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerModule } from '@nestjs/throttler';
import { EventEmitterModule } from '@nestjs/event-emitter';

import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { MerchantsModule } from './modules/merchants/merchants.module';
import { PromotionsModule } from './modules/promotions/promotions.module';
import { RedemptionsModule } from './modules/redemptions/redemptions.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';
import { LocationModule } from './modules/location/location.module';
import { DatabaseModule } from './database/database.module';
import { NotificationsModule } from './modules/notifications/notifications.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validate: (config: Record<string, any>) => {
        // Critical keys that must exist
        if (!config.DB_HOST) throw new Error('DB_HOST is required');
        if (!config.DB_PORT) throw new Error('DB_PORT is required');
        if (!config.DB_USERNAME) throw new Error('DB_USERNAME is required');
        if (!config.DB_PASSWORD) throw new Error('DB_PASSWORD is required');
        if (!config.DB_NAME) throw new Error('DB_NAME is required');
        if (!config.JWT_SECRET) throw new Error('JWT_SECRET is required');
        if (!config.PAYSTACK_SECRET_KEY)
          throw new Error('PAYSTACK_SECRET_KEY is required');
        if (!config.PAYSTACK_PUBLIC_KEY)
          throw new Error('PAYSTACK_PUBLIC_KEY is required');

        return config;
      },
    }),
    DatabaseModule,
    EventEmitterModule.forRoot(),
    ThrottlerModule.forRoot({
      throttlers: [
        {
          ttl: 60000,
          limit: 10,
        },
      ],
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
    NotificationsModule,
  ],
})
export class AppModule {}
