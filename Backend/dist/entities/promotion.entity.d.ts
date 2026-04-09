import { Merchant } from './merchant.entity';
export declare enum PromotionType {
    STANDARD = "STANDARD",
    MICRO = "MICRO"
}
export declare class Promotion {
    id: string;
    merchant: Merchant;
    merchantId: string;
    type: PromotionType;
    fee: number;
    price: number;
    originalPrice: number;
    title: string;
    description: string;
    photoUrl: string;
    radiusKm: number;
    expiry: Date;
    quantityLimit: number;
    redeemedCount: number;
    views: number;
    popularityScore: number;
    isActive: boolean;
    idempotencyKey: string;
    createdAt: Date;
    updatedAt: Date;
}
