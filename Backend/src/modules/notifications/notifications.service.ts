import { Injectable } from '@nestjs/common';
import { EmailService } from '../email/email.service';

@Injectable()
export class NotificationsService {
  constructor(private emailService: EmailService) {}

  async sendRedemptionConfirmation(
    customerEmail: string,
    promotionTitle: string,
    businessName: string,
  ) {
    await this.emailService.sendEmail({
      to: customerEmail,
      subject: `Redemption Successful - ${promotionTitle}`,
      html: `<h2>Thank you!</h2><p>You successfully redeemed <strong>${promotionTitle}</strong> at <strong>${businessName}</strong>.</p><p>Enjoy your deal!</p>`,
    });
  }

  async sendPromotionLive(merchantEmail: string, promotionTitle: string) {
    await this.emailService.sendEmail({
      to: merchantEmail,
      subject: `Your Promotion is LIVE!`,
      html: `<h2>Congratulations!</h2><p>Your promotion <strong>${promotionTitle}</strong> is now visible to customers nearby.</p>`,
    });
  }
}
