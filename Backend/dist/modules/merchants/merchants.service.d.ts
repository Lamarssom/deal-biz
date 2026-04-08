import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
export declare class MerchantsService {
    private repo;
    constructor(repo: Repository<Merchant>);
    findById(id: string): Promise<Merchant | null>;
    findByEmail(email: string): Promise<Merchant | null>;
    create(data: Partial<Merchant>): Merchant;
    save(merchant: Merchant): Promise<Merchant>;
    update(criteria: any, data: Partial<Merchant>): Promise<import("typeorm").UpdateResult>;
    findOne(options: any): Promise<Merchant | null>;
}
