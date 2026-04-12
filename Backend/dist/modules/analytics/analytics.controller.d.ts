import { AnalyticsService } from './analytics.service';
import type { AuthRequest } from '../../common/interfaces/auth-request.interface';
export declare class AnalyticsController {
    private analyticsService;
    constructor(analyticsService: AnalyticsService);
    merchantAnalytics(req: AuthRequest): Promise<{
        totalPromotions: number;
        totalRedemptions: number;
        activePromotions: number;
        estimatedFootTraffic: number;
        promotions: {
            id: string;
            title: string;
            type: import("../../entities/promotion.entity").PromotionType;
            redeemedCount: number;
            views: number;
            expiry: Date;
        }[];
    }>;
}
