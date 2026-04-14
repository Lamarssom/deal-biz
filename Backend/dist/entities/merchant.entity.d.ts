export declare class Merchant {
    id: string;
    email: string;
    password: string;
    role: 'MERCHANT';
    businessName: string;
    category: string;
    latitude: number | null;
    longitude: number | null;
    businessLGA: string;
    isVerified: boolean;
    verificationCode: string | null;
    verificationExpiresAt: Date | null;
    isActive: boolean;
    outstandingBalance: number;
    lastInvoicedAt: Date | null;
    createdAt: Date;
    updatedAt: Date;
}
