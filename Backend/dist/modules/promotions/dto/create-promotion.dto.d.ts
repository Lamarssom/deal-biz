import type { PromotionType } from '../../../entities/promotion.entity';
export declare class CreatePromotionDto {
    type: PromotionType;
    title: string;
    description?: string;
    price: number;
    originalPrice?: number;
    photoUrl?: string;
    expiry: string;
    quantityLimit: number;
    radiusKm?: number;
}
