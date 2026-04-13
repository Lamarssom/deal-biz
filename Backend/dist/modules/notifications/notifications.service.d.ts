import { EmailService } from '../email/email.service';
export declare class NotificationsService {
    private emailService;
    constructor(emailService: EmailService);
    sendRedemptionConfirmation(customerEmail: string, promotionTitle: string, businessName: string): Promise<void>;
    sendPromotionLive(merchantEmail: string, promotionTitle: string): Promise<void>;
}
