//C:\Users\Godwin\Desktop\deal-biz\Backend\src\schedule\invoicing.cron.ts
import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Merchant } from '../entities/merchant.entity';
import { PaymentsService } from '../modules/payments/payments.service';

@Injectable()
export class InvoicingCron {
  private readonly logger = new Logger(InvoicingCron.name);

  constructor(
    @InjectRepository(Merchant)
    private merchantRepository: Repository<Merchant>,
    private paymentsService: PaymentsService,
  ) {}

  @Cron(CronExpression.EVERY_HOUR)
  async handleAutoInvoicing() {
    const now = new Date();
    const threshold = 2000; // ₦2,000
    const invoiceIntervalDays = 7; // every 7 days

    const cuttoffDate = new Date(
      now.getTime() - invoiceIntervalDays * 24 * 60 * 60 * 1000,
    );

    // Better: use query builder for >= 2000
    const merchantsToInvoice = await this.merchantRepository
      .createQueryBuilder('merchant')
      .where('merchant.outstandingBalance >= :threshold', { threshold })
      .orWhere('merchant.lastInvoicedAt <= :cutoff', {
        cutoff: cuttoffDate,
      })
      .getMany();

    this.logger.log(
      `Found ${merchantsToInvoice.length} merchants eligible for invoicing`,
    );

    for (const merchant of merchantsToInvoice) {
      try {
        //await this.paymentsService.handleSuccessfulPayment(merchant.id);

        await this.merchantRepository.update(merchant.id, {
          lastInvoicedAt: now,
        });
        this.logger.log(
          `Auto-invoiced merchant ${merchant.id} | Balance: ₦${merchant.outstandingBalance}`,
        );
      } catch (error) {
        this.logger.error(`Invoice failed for merchant ${merchant.id}`, error);
      }
    }
  }
}
