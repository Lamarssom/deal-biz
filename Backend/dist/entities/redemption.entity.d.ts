import { Promotion } from './promotion.entity';
import { User } from './user.entity';
export declare class Redemption {
    id: string;
    promotion: Promotion;
    promotionId: string;
    customer: User;
    customerId: string;
    qrCode: string;
    isRedeemed: boolean;
    redeemedAt: Date;
    createdAt: Date;
}
