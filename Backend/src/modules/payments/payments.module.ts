//src\modules\payments\payments.module.ts
import { Module } from '@nestjs/common';
import { PaymentsController } from './payments.controller';
import { PaymentsService } from './payments.service';
import { MerchantsModule } from '../merchants/merchants.module';
import { PaymentsListener } from './payments.listener';
import { PromotionsModule } from '../promotions/promotions.module';

@Module({
  imports: [MerchantsModule, PromotionsModule],
  controllers: [PaymentsController],
  providers: [PaymentsService, PaymentsListener],
  exports: [PaymentsService],
})
export class PaymentsModule {}
