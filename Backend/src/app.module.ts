//C:\Users\Godwin\Desktop\deal-biz\Backend\src\app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
// eslint-disable-next-line @typescript-eslint/no-unused-vars
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from './schedule/schedule.module';
import { ThrottlerModule } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { TerminusModule } from '@nestjs/terminus';
import { WinstonModule } from 'nest-winston';
import { createWinstonConfig } from './common/logger/winston.config';

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
import { HealthController } from './health/health.controller';
import { ThrottlerGuard } from '@nestjs/throttler';
import { InvoicingCron } from './schedule/invoicing.cron';
import { MetricsController } from './metrics/metrics.controller';
import { APP_FILTER } from '@nestjs/core';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validate: (config: Record<string, any>) => {
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

    TerminusModule,
    DatabaseModule,
    EventEmitterModule.forRoot(),
    WinstonModule.forRootAsync({
      inject: [ConfigService],
      useFactory: createWinstonConfig,
    }),

    //Rate Limiting Configuration
    ThrottlerModule.forRoot({
      throttlers: [
        {
          ttl: 60000, // 60 seconds
          limit: 100, // 100 requests per minute per IP (global default)
          skipIf: (context) => {
            const request = context.switchToHttp().getRequest();
            const url = request.url || '';
            return url.includes('/health') || url.includes('/payments/webhook');
          },
        },
      ],
    }),

    // Feature modules
    AuthModule,
    UsersModule,
    MerchantsModule,
    PromotionsModule,
    RedemptionsModule,
    PaymentsModule,
    AnalyticsModule,
    LocationModule,
    NotificationsModule,
    ScheduleModule,
  ],
  controllers: [HealthController, MetricsController],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_FILTER,
      useClass: HttpExceptionFilter,
    },
  ],
})
export class AppModule {}
