import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { PromotionsService } from '../promotions/promotions.service';

@Injectable()
export class PaymentsListener {
  constructor(private promotionsService: PromotionsService) {}

  @OnEvent('payment.success')
  async handlePaymentSuccess(payload: { promotionId: string }) {
    await this.promotionsService.activatePromotion(payload.promotionId);

    console.log('✅ Promotion activated after payment');
  }
}