import { TypeOrmModuleOptions } from '@nestjs/typeorm';

export const typeOrmConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'Biology1999web',
  database: process.env.DB_NAME || 'deal_biz',
  entities: [__dirname + '/../entities/*.entity{.ts,.js}'],
  synchronize: true,
};