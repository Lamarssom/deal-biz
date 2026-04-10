import { Promotion } from '../../entities/promotion.entity';
import { LocationService } from '../location/location.service';
export declare class PromotionsRankingService {
    private locationService;
    constructor(locationService: LocationService);
    rankPromotions(userLat: number, userLng: number, promotions: Promotion[]): Promotion[];
}
