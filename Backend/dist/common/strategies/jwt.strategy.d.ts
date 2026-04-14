import { Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { UsersService } from '../../modules/users/users.service';
import { MerchantsService } from '../../modules/merchants/merchants.service';
declare const JwtStrategy_base: new (...args: [opt: import("passport-jwt").StrategyOptions] | [opt: import("passport-jwt").StrategyOptions]) => Strategy & {
    validate(...args: any[]): unknown;
};
export declare class JwtStrategy extends JwtStrategy_base {
    private configService;
    private usersService;
    private merchantsService;
    constructor(configService: ConfigService, usersService: UsersService, merchantsService: MerchantsService);
    validate(payload: any): Promise<import("../../entities/merchant.entity").Merchant | import("../../entities/user.entity").User | null>;
}
export {};
