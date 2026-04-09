import { Merchant } from '../../entities/merchant.entity';
import { Repository } from 'typeorm';
export declare class LocationService {
    private merchantRepo;
    constructor(merchantRepo: Repository<Merchant>);
    calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number;
    private toRad;
    findMerchantsInRadius(lat: number, lng: number, radiusKm?: number): Promise<Merchant[]>;
}
