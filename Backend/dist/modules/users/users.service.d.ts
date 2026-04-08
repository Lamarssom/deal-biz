import { Repository } from 'typeorm';
import { User } from '../../entities/user.entity';
export declare class UsersService {
    private readonly repo;
    constructor(repo: Repository<User>);
    create(data: Partial<User>): User;
    save(user: User): Promise<User>;
    findOne(options: any): Promise<User | null>;
    findById(id: string): Promise<User | null>;
    findByEmail(email: string): Promise<User | null>;
    update(criteria: any, data: Partial<User>): Promise<import("typeorm").UpdateResult>;
}
