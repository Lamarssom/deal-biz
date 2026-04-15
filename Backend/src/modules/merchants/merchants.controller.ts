import { Controller, Get, Query, Post, Body, Req, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { MerchantsService } from './merchants.service'
import { SettleBalanceDto } from '../payments/dto/settle-balance.dto'

@Controller('merchants')
@UseGuards(JwtAuthGuard, RolesGuard)
export class MerchantsController {
  constructor(private readonly merchantsService: MerchantsService) {}

  @Get('nearby')
  findNearby(
    @Query('lat') lat: number,
    @Query('lng') lng: number
  ) {
    return this.merchantsService.findNearby(Number(lat), Number(lng))
  }

  @Post('settle-balance')
  @Roles('MERCHANT')
  settleBalance(@Req() req: any, @Body() dto: SettleBalanceDto) {
    return this.merchantsService.settleBalance(req.user.id, dto.amount);
  }
}