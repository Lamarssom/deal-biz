import { EventEmitter2 } from '@nestjs/event-emitter';
export declare class PaymentsService {
    private eventEmitter;
    constructor(eventEmitter: EventEmitter2);
    handleSuccessfulPayment(promotionId: string): void;
}
