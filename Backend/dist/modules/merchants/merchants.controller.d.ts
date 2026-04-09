import { MerchantsService } from './merchants.service';
export declare class MerchantsController {
    private readonly merchantService;
    constructor(merchantService: MerchantsService);
    findNearby(lat: number, lng: number): Promise<any>;
}
