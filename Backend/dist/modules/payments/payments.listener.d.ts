import { PromotionsService } from '../promotions/promotions.service';
export declare class PaymentsListener {
    private promotionsService;
    constructor(promotionsService: PromotionsService);
    handlePaymentSuccess(payload: {
        promotionId: string;
    }): Promise<void>;
}
