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

  async sendVerificationEmail(email: string, code: string) {
    try {
      if (this.configService.get('NODE_ENV') !== 'production') {
        this.logger.log(`Verification code for ${email}: ${code}`);
      }

      await this.resend.emails.send({
        from: this.configService.get<string>('EMAIL_FROM')!,
        to: email,
        subject: 'Verify your Deal-Biz Merchant Account',
        html: `<p>Your verification code is: <strong>${code}</strong></p>
               <p>Valid for 15 minutes.</p>`,
      });
    } catch (err) {
      this.logger.error('Email send failed', err);
    }
  }

  async sendPasswordReset(email: string, token: string) {
    try {
      if (this.configService.get('NODE_ENV') !== 'production') {
        this.logger.log(`Password reset token for ${email}: ${token}`);
      }

      await this.resend.emails.send({
        from: this.configService.get<string>('EMAIL_FROM')!,
        to: email,
        subject: 'Deal-Biz Password Reset',
        html: `<a href="http://localhost:3000/reset?token=${token}">Reset Password</a>`,
      });
    } catch (err) {
      this.logger.error('Password reset email failed', err);
    }
  }

  async sendEmail(options: { to: string; subject: string; html: string }) {
    try {
      await this.resend.emails.send({
        from: this.configService.get<string>('EMAIL_FROM')!,
        to: options.to,
        subject: options.subject,
        html: options.html,
      });
    } catch (err) {
      this.logger.error('Email send failed', err);
    }
  }
}
