//src\modules\payments\payments.service.ts
import { Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { EVENTS } from '../events/event.types';

@Injectable()
export class PaymentsService {
  constructor(private eventEmitter: EventEmitter2) {}

  handleSuccessfulPayment(promotionId: string) {
    this.eventEmitter.emit(EVENTS.PAYMENT_SUCCESS, {
      promotionId,
    });
  }
}