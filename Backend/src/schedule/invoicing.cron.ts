import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../entities/merchant.entity';
import { EmailService } from '../modules/email/email.service';

@Injectable()
export class InvoicingCron {
  private readonly logger = new Logger(InvoicingCron.name);

  constructor(
    @InjectRepository(Merchant)
    private merchantRepository: Repository<Merchant>,
    private emailService: EmailService,
  ) {}

  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async handleBalanceReminders() {
    const now = new Date();
    const threshold = 2000;
    const reminderIntervalDays = 2;

    const cutoffDate = new Date(now.getTime() - reminderIntervalDays * 24 * 60 * 60 * 1000);

    const merchantsToRemind = await this.merchantRepository
      .createQueryBuilder('merchant')
      .where('merchant.outstandingBalance >= :threshold', { threshold })
      .andWhere('merchant.isActive = true')
      .andWhere(
        '(merchant.lastRemindedAt IS NULL OR merchant.lastRemindedAt <= :cutoff)',
        { cutoff: cutoffDate }
      )
      .getMany();

    this.logger.log(
      `Found ${merchantsToRemind.length} merchants eligible for balance reminder`
    );

    for (const merchant of merchantsToRemind) {
      try {
        await this.emailService.sendBalanceReminder(
          merchant.email,
          merchant.businessName || 'Merchant',
          merchant.outstandingBalance
        );

        // Update last reminded time
        await this.merchantRepository.update(merchant.id, {
          lastRemindedAt: now,
        });

        this.logger.log(
          `Balance reminder sent to ${merchant.email} | Balance: ₦${merchant.outstandingBalance}`
        );
      } catch (error) {
        this.logger.error(`Failed to send reminder to ${merchant.email}`, error);
      }
    }
  }
}