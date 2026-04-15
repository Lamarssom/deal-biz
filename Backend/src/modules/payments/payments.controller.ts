//src\modules\payments\payments.controller.ts
import { Controller, Post, Body } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { MerchantsService } from '../merchants/merchants.service';
import { EventEmitter2 } from '@nestjs/event-emitter';

@Controller('payments')
export class PaymentsController {
    constructor(
        private paymentsService: PaymentsService,
        private merchantsService: MerchantsService,
        private eventEmitter: EventEmitter2,
    ) {}
    // Paystack webhook (called by Paystack after payment)
  @Post('webhook')
  async paystackWebhook(@Body() body: any) {
    if (body.event !== 'charge.success') {
      return { status: 'ignored' };
    }

    const metadata = body.data.metadata;

    // CASE 1: Promotion creation
    if (metadata.type === 'creation_fee' || metadata.promotionId) {
      const promoId = metadata.promotionId;

      this.eventEmitter.emit('payment.success', { 
        promotionId: promoId,
      });
    }

    // CASE 2: Balance settlement
    if (metadata.type === 'balance_settlement') {
      const merchantId = metadata.merchantId;
      const amount = body.data.amount / 100; // convert from kobo

      await this.merchantsService.updateBalance(merchantId, amount);
    }

    return { status: 'success' };
  }
}
