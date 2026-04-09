import { PromotionsService } from './promotions.service';
import { CreatePromotionDto } from './dto/create-promotion.dto';
export declare class PromotionsController {
    private promotionsService;
    constructor(promotionsService: PromotionsService);
    create(req: any, dto: CreatePromotionDto): Promise<{
        message: string;
        promotionId: string;
        paystackReference?: undefined;
        authorizationUrl?: undefined;
        fee?: undefined;
        type?: undefined;
    } | {
        message: string;
        promotionId: string;
        paystackReference: any;
        authorizationUrl: any;
        fee: number;
        type: import("../../entities/promotion.entity").PromotionType;
    }>;
}
