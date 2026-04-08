import { ConfigService } from '@nestjs/config';
export declare class EmailService {
    private configService;
    private resend;
    private logger;
    constructor(configService: ConfigService);
    sendVerificationEmail(email: string, code: string): Promise<void>;
    sendPasswordReset(email: string, token: string): Promise<void>;
}
