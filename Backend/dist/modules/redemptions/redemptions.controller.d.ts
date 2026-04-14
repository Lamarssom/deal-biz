import express from 'express';
import { RedemptionsService } from './redemptions.service';
import { GenerateQrDto } from './dto/generate-qr.dto';
import { RedeemDto } from './dto/redeem.dto';
export declare class RedemptionsController {
    private redemptionsService;
    constructor(redemptionsService: RedemptionsService);
    generateQR(req: express.Request, dto: GenerateQrDto): Promise<{
        redemptionId: string;
        qrCode: string;
        qrImage: string;
        message: string;
    }>;
    redeem(req: express.Request, dto: RedeemDto): Promise<{
        message: string;
        promotionTitle: string;
        businessName: string;
        successFeeCharged: number;
    }>;
}
