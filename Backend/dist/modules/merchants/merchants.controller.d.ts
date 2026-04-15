import { MerchantsService } from './merchants.service';
import { SettleBalanceDto } from '../payments/dto/settle-balance.dto';
export declare class MerchantsController {
    private readonly merchantsService;
    constructor(merchantsService: MerchantsService);
    findNearby(lat: number, lng: number): Promise<any>;
    settleBalance(req: any, dto: SettleBalanceDto): Promise<{
        authorizationUrl: any;
        reference: any;
        amount: number;
        remainingBalance: number;
    }>;
}
