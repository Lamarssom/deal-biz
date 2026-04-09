import { Repository } from 'typeorm';
import { LGA } from '../../entities/lga.entity';
export declare class LgaService {
    private readonly repo;
    constructor(repo: Repository<LGA>);
    findByName(lga: string): Promise<LGA | null>;
    findByLgaAndWard(lga: string, ward: string): Promise<LGA | null>;
    findAll(): Promise<LGA[]>;
}
