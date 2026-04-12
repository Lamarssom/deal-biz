//src\modules\analytics\analytics.controller.ts
import { Controller, Get, UseGuards, Req } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { AnalyticsService } from './analytics.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import type { AuthRequest } from '../../common/interfaces/auth-request.interface';

@ApiTags('Analytics')
@ApiBearerAuth()
@Controller('analytics')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AnalyticsController {
  constructor(private analyticsService: AnalyticsService) {}

  @Get('merchant')
  @Roles('MERCHANT')
  merchantAnalytics(@Req() req: AuthRequest) {
    const merchantId = req.user.id;
    return this.analyticsService.getMerchantAnalytics(merchantId);
  }
}
