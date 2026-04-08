export type Role = 'CUSTOMER' | 'MERCHANT';
export declare class User {
    id: string;
    email: string;
    password: string;
    role: Role;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
}
