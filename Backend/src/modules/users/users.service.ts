// modules/users/users.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../../entities/user.entity';

@Injectable()
export class UsersService {
  constructor(@InjectRepository(User) private repo: Repository<User>) {}

  findById(id: string) {
    return this.repo.findOne({ where: { id } });
  }

  findByEmail(email: string) {
    return this.repo.findOne({ where: { email } });
  }

  create(data: Partial<User>) {
    return this.repo.create(data);
  }

  save(user: User) {
    return this.repo.save(user);
  }

  update(criteria: any, data: Partial<User>) {
    return this.repo.update(criteria, data);
  }

  findOne(options: any) {
    return this.repo.findOne(options);
  }
}