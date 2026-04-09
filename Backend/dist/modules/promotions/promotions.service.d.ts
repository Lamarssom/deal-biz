import { Repository } from 'typeorm';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { Promotion } from '../../entities/promotion.entity';
import { Merchant } from '../../entities/merchant.entity';
import { CreatePromotionDto } from './dto/create-promotion.dto';
import { LocationService } from '../location/location.service';
export declare class PromotionsService {
    private promotionRepo;
    private merchantRepo;
    private locationService;
    private httpService;
    private configService;
    constructor(promotionRepo: Repository<Promotion>, merchantRepo: Repository<Merchant>, locationService: LocationService, httpService: HttpService, configService: ConfigService);
    createPromotion(merchantId: string, dto: CreatePromotionDto): Promise<{
        message: string;
        promotionId: string;
        paystackReference?: undefined;
        authorizationUrl?: undefined;
        fee?: undefined;
        type?: undefined;
    } | {
        message: string;
        promotionId: string;
        paystackReference: any;
        authorizationUrl: any;
        fee: number;
        type: import("../../entities/promotion.entity").PromotionType;
    }>;
}
