"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.typeOrmConfig = void 0;
exports.typeOrmConfig = {
    type: 'postgres',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '5432'),
    username: process.env.DB_USERNAME || 'postgres',
    password: process.env.DB_PASSWORD || 'Biology1999web',
    database: process.env.DB_NAME || 'deal_biz',
    entities: [__dirname + '/../entities/*.entity{.ts,.js}'],
    synchronize: true,
};
//# sourceMappingURL=typeorm.config.js.map