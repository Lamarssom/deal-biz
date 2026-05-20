import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Resend } from 'resend';

@Injectable()
export class EmailService {
  private resend: Resend;
  private logger = new Logger(EmailService.name);

  constructor(private configService: ConfigService) {
    this.resend = new Resend(this.configService.get('RESEND_API_KEY'));
  }

  private getFromEmail() {
    return 'Yudeel <onboarding@resend.dev>';
  }

  // Generic send email (for notifications service and future use)
  async sendEmail(options: { to: string; subject: string; html: string }) {
    try {
      await this.resend.emails.send({
        from: this.getFromEmail(),
        to: options.to,
        subject: options.subject,
        html: options.html,
      });
      this.logger.log(`Email sent successfully to ${options.to}`);
    } catch (err) {
      this.logger.error('Email send failed', err);
      throw err;
    }
  }

  async sendVerificationEmail(email: string, code: string) {
    try {
      if (this.configService.get('NODE_ENV') !== 'production') {
        this.logger.log(`Verification code for ${email}: ${code}`);
      }

      await this.sendEmail({
        to: email,
        subject: 'Verify your Yudeel Account',
        html: `
          <h2>Welcome to Yudeel</h2>
          <p>Your verification code is: <strong>${code}</strong></p>
          <p>This code expires in 15 minutes.</p>
        `,
      });
    } catch (err) {
      this.logger.error('Failed to send verification email', err);
    }
  }

  async sendPasswordReset(email: string, token: string) {
    try {
      if (this.configService.get('NODE_ENV') !== 'production') {
        this.logger.log(`Password reset token for ${email}: ${token}`);
      }

      await this.sendEmail({
        to: email,
        subject: 'Reset Your Yudeel Password',
        html: `
          <p>Click the link below to reset your password:</p>
          <a href="https://yudeel.com/reset?token=${token}">Reset Password</a>
          <p>This link expires in 15 minutes.</p>
        `,
      });
    } catch (err) {
      this.logger.error('Failed to send password reset email', err);
    }
  }

  async sendBalanceReminder(email: string, merchantName: string, balance: number) {
    try {
      const formattedBalance = balance.toFixed(2);

      await this.sendEmail({
        to: email,
        subject: `Reminder: Your Outstanding Balance of ₦${formattedBalance}`,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #1C8EDA;">Dear ${merchantName},</h2>
            
            <p>We hope this email finds you well.</p>
            
            <div style="background-color: #F8FAFC; padding: 20px; border-radius: 12px; margin: 20px 0;">
              <p style="font-size: 18px; margin: 0;">
                Your current <strong>outstanding balance</strong> is:
              </p>
              <h1 style="color: #EF4444; margin: 10px 0;">₦${formattedBalance}</h1>
            </div>

            <p><strong>Please settle this balance</strong> to continue creating and running promotions on Yudeel.</p>

            <a href="https://yudeel.com/merchants/settle" 
               style="display: inline-block; background-color: #1C8EDA; color: white; padding: 14px 28px; 
                      text-decoration: none; border-radius: 999px; font-weight: 600; margin: 20px 0;">
              Settle Balance Now
            </a>

            <p style="color: #64748B; font-size: 14px;">
              Note: This is an automated reminder. You will receive this every 2 days until your balance is cleared.
            </p>

            <hr style="margin: 30px 0; border: none; border-top: 1px solid #E2E8F0;">
            
            <p style="color: #64748B; font-size: 13px;">
              Best regards,<br>
              <strong>Yudeel Team</strong>
            </p>
          </div>
        `,
      });
    } catch (err) {
      this.logger.error(`Failed to send balance reminder to ${email}`, err);
    }
  }
}