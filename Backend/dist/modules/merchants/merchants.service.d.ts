import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
import { LGA } from '../../entities/lga.entity';
export declare class MerchantsService {
    private readonly repo;
    private readonly lgaRepo;
    constructor(repo: Repository<Merchant>, lgaRepo: Repository<LGA>);
    create(data: Partial<Merchant>): Promise<Merchant>;
    save(merchant: Merchant): Promise<Merchant>;
    findOne(email: string): Promise<Merchant | null>;
    findById(id: string): Promise<Merchant | null>;
    update(criteria: any, data: Partial<Merchant>): Promise<import("typeorm").UpdateResult>;
    findNearby(lat: number, lng: number, radius?: number): Promise<any>;
}
