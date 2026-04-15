import { PaymentsService } from './payments.service';
import { MerchantsService } from '../merchants/merchants.service';
import { EventEmitter2 } from '@nestjs/event-emitter';
export declare class PaymentsController {
    private paymentsService;
    private merchantsService;
    private eventEmitter;
    constructor(paymentsService: PaymentsService, merchantsService: MerchantsService, eventEmitter: EventEmitter2);
    paystackWebhook(body: any): Promise<{
        status: string;
    }>;
}
