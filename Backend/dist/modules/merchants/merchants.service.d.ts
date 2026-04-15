import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { LGA } from '../../entities/lga.entity';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
export declare class MerchantsService {
    private readonly merchantRepo;
    private readonly lgaRepo;
    private httpService;
    private configService;
    constructor(merchantRepo: Repository<Merchant>, lgaRepo: Repository<LGA>, httpService: HttpService, configService: ConfigService);
    create(data: Partial<Merchant>): Promise<Merchant>;
    save(merchant: Merchant): Promise<Merchant>;
    findOne(email: string): Promise<Merchant | null>;
    findById(id: string): Promise<Merchant | null>;
    update(criteria: any, data: Partial<Merchant>): Promise<import("typeorm").UpdateResult>;
    findNearby(lat: number, lng: number, radius?: number): Promise<any>;
    updateBalance(merchantId: string, amount: number): Promise<import("typeorm").UpdateResult>;
    settleBalance(merchantId: string, amount: number): Promise<{
        authorizationUrl: any;
        reference: any;
        amount: number;
        remainingBalance: number;
    }>;
}
