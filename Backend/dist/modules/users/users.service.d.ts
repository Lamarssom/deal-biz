import { Repository } from 'typeorm';
import { User } from '../../entities/user.entity';
export declare class UsersService {
    private repo;
    constructor(repo: Repository<User>);
    findById(id: string): Promise<User | null>;
    findByEmail(email: string): Promise<User | null>;
    create(data: Partial<User>): User;
    save(user: User): Promise<User>;
    update(criteria: any, data: Partial<User>): Promise<import("typeorm").UpdateResult>;
    findOne(options: any): Promise<User | null>;
}
