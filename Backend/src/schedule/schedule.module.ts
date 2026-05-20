import { Module } from '@nestjs/common';
import { ScheduleModule as NestScheduleModule } from '@nestjs/schedule';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Merchant } from '../entities/merchant.entity';
import { EmailService } from '../modules/email/email.service';
import { InvoicingCron } from './invoicing.cron';

@Module({
  imports: [
    NestScheduleModule.forRoot(),
    TypeOrmModule.forFeature([Merchant]),
  ],
  providers: [EmailService, InvoicingCron],
})
export class ScheduleModule {}