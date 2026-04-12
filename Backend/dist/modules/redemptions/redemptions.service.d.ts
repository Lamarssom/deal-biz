import { Repository } from 'typeorm';
import { Redemption } from '../../entities/redemption.entity';
import { Promotion } from '../../entities/promotion.entity';
import { User } from '../../entities/user.entity';
import { GenerateQrDto } from './dto/generate-qr.dto';
export declare class RedemptionsService {
    private redemptionRepo;
    private promotionRepo;
    private userRepo;
    constructor(redemptionRepo: Repository<Redemption>, promotionRepo: Repository<Promotion>, userRepo: Repository<User>);
    generateQR(customerId: string, dto: GenerateQrDto): Promise<{
        redemptionId: string;
        qrCode: string;
        qrImage: string;
        message: string;
    }>;
    redeem(qrCode: string, merchantId: string): Promise<{
        message: string;
        promotionTitle: string;
        businessName: string;
    }>;
}
