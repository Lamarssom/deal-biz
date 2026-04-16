import {
  Controller,
  Post,
  Body,
  Req,
  Headers,
  Get,
  Query,
} from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { MerchantsService } from '../merchants/merchants.service';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import type { Request } from 'express';

@Controller('payments')
export class PaymentsController {
  constructor(
    private paymentsService: PaymentsService,
    private merchantsService: MerchantsService,
    private eventEmitter: EventEmitter2,
    private configService: ConfigService,
  ) {}

  @Post('webhook')
  async paystackWebhook(
    @Req() req: Request,
    @Body() body: any,
    @Headers('x-paystack-signature') signature: string,
  ) {
    const secret = this.configService.get<string>('PAYSTACK_SECRET_KEY');

    if (!secret) {
      console.error('PAYSTACK_SECRET_KEY is missing in environment');
      return { status: 'missing secret' };
    }

    if (!signature) {
      console.error('No x-paystack-signature header received');
      return { status: 'no signature' };
    }

    // Use raw body if available (better for signature), otherwise fallback to JSON.stringify
    const payload = req.rawBody
      ? req.rawBody.toString('utf8')
      : JSON.stringify(body);

    // ✅ Verify signature exactly as Paystack does
    const hash = crypto
      .createHmac('sha512', secret)
      .update(payload)
      .digest('hex');

    if (hash !== signature) {
      console.error('Invalid Paystack signature. Received:', signature);
      console.error('Expected hash:', hash);
      return { status: 'invalid signature' };
    }

    console.log('✅ Paystack webhook signature verified successfully');

    if (body.event === 'charge.success') {
      const metadata = body.data?.metadata;

      if (metadata?.promotionId && metadata?.type === 'creation_fee') {
        const promotionId = metadata.promotionId;
        console.log(
          `Processing successful payment for promotion: ${promotionId}`,
        );

        // Emit event so your PromotionsModule can activate it
        this.eventEmitter.emit('payment.success', { promotionId });

        // Optional: You can also call a service method directly here
        // await this.paymentsService.handleSuccessfulPromotionPayment(promotionId);
      } else {
        console.log(
          'Webhook received but no matching metadata for promotion creation',
        );
      }
    }

    return { status: 'success' };
  }

  @Get('callback')
  async paystackCallback(@Query() query: any) {
    const reference = query.reference || query.trxref;
    console.log(`Payment callback received for reference: ${reference}`);

    // Or redirect to frontend:
    // return { url: https://deal-biz-frontend.com/success?reference=${reference} };

    return {
      status: 'success',
      message:
        'Payment completed. The promotion should be activated shortly via webhook.',
      reference,
    };
  }
}
