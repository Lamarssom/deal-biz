import { Module } from '@nestjs/common';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { EmailModule } from '../email/email.module';

@Module({
  controllers: [NotificationsController],
  providers: [NotificationsService],
  imports: [EmailModule],
})
export class NotificationsModule {}
