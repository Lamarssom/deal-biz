import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
export declare class MerchantsService {
    private readonly repo;
    constructor(repo: Repository<Merchant>);
    create(data: Partial<Merchant>): Merchant;
    save(merchant: Merchant): Promise<Merchant>;
    findOne(email: string): Promise<Merchant | null>;
    findById(id: string): Promise<Merchant | null>;
    update(criteria: any, data: Partial<Merchant>): Promise<import("typeorm").UpdateResult>;
}
