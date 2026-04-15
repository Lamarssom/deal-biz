import { Repository } from 'typeorm';
import { Promotion } from '../../entities/promotion.entity';
import { Redemption } from '../../entities/redemption.entity';
import { Merchant } from '../../entities/merchant.entity';
export declare class AnalyticsService {
    private promotionRepo;
    private redemptionRepo;
    private merchantRepo;
    constructor(promotionRepo: Repository<Promotion>, redemptionRepo: Repository<Redemption>, merchantRepo: Repository<Merchant>);
    getMerchantAnalytics(merchantId: string): Promise<{
        totalPromotions: number;
        totalRedemptions: number;
        activePromotions: number;
        expiredPromotions: number;
        outstandingBalance: number;
        creditLimit: number;
        estimatedFootTraffic: number;
        promotions: {
            id: string;
            title: string;
            type: import("../../entities/promotion.entity").PromotionType;
            redeemedCount: number;
            views: number;
            conversionRate: number;
            expiry: Date;
        }[];
    }>;
}
