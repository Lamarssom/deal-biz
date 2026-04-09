import { Repository } from 'typeorm';
import { Merchant } from '../../entities/merchant.entity';
export declare class LocationService {
    private merchantRepo;
    constructor(merchantRepo: Repository<Merchant>);
    findMerchantsInRadius(userLat: number, userLng: number, radiusKm?: number, limit?: number): Promise<Merchant[]>;
    calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number;
}
