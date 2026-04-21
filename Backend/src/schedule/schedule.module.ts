import { Module } from '@nestjs/common';
import { ScheduleModule as NestScheduleModule } from '@nestjs/schedule';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Merchant } from '../entities/merchant.entity';
import { PaymentsModule } from '../modules/payments/payments.module';
import { InvoicingCron } from './invoicing.cron';

@Module({
  imports: [
    NestScheduleModule.forRoot(),
    TypeOrmModule.forFeature([Merchant]),
    PaymentsModule,
  ],
  providers: [InvoicingCron],
})
export class ScheduleModule {}
