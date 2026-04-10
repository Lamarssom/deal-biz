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
    getNearby(lat: string, lng: string, radius?: string): Promise<{
        id: string;
        title: string;
        description: string;
        type: import("../../entities/promotion.entity").PromotionType;
        price: number;
        originalPrice: number;
        radiusKm: number;
        expiry: Date;
        merchant: {
            id: string;
            businessName: string;
            category: string;
            businessLGA: string;
            latitude: number;
            longitude: number;
        };
        stats: {
            views: number;
            redeemedCount: number;
        };
    }[]>;
    paystackWebhook(body: any): Promise<{
        status: string;
    }>;
}
