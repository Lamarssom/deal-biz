import type { Role } from './user.entity';
export declare class Merchant {
    id: string;
    email: string;
    password: string;
    role: Role;
    businessName: string;
    category: string;
    latitude: number | null;
    longitude: number | null;
    isVerified: boolean;
    verificationCode: string | null;
    verificationExpiresAt: Date | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
}
