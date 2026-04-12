// src/modules/redemptions/redemptions.controller.ts
import express from 'express';
import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { RedemptionsService } from './redemptions.service';
import { GenerateQrDto } from './dto/generate-qr.dto';
import { RedeemDto } from './dto/redeem.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Roles } from '../../common/decorators/roles.decorator';

@Controller('redemptions')
export class RedemptionsController {
  constructor(private redemptionsService: RedemptionsService) {}

  @UseGuards(JwtAuthGuard)
  @Post('generate')
  generateQR(@Req() req: express.Request, @Body() dto: GenerateQrDto) {
    const user = req.user as { id: string }; // from JwtAuthGuard
    return this.redemptionsService.generateQR(user.id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Roles('MERCHANT') // only merchants can redeem
  @Post('redeem')
  redeem(@Req() req: express.Request, @Body() dto: RedeemDto) {
    const user = req.user as { id: string };
    return this.redemptionsService.redeem(dto.qrCode, user.id);
  }
}
