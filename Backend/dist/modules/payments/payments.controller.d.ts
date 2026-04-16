import { PaymentsService } from './payments.service';
import { MerchantsService } from '../merchants/merchants.service';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ConfigService } from '@nestjs/config';
import type { Request } from 'express';
export declare class PaymentsController {
    private paymentsService;
    private merchantsService;
    private eventEmitter;
    private configService;
    constructor(paymentsService: PaymentsService, merchantsService: MerchantsService, eventEmitter: EventEmitter2, configService: ConfigService);
    paystackWebhook(req: Request, body: any, signature: string): Promise<{
        status: string;
    }>;
    paystackCallback(query: any): Promise<{
        status: string;
        message: string;
        reference: any;
    }>;
}
