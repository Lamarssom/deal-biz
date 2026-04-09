import { LocationService } from './location.service';
export declare class LocationController {
    private locationService;
    constructor(locationService: LocationService);
    getNearbyMerchants(lat: string, lng: string, radius?: string): Promise<import("../../entities/merchant.entity").Merchant[]>;
}
