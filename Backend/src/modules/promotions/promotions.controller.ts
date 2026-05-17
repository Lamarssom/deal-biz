// src/modules/promotions/promotions.controller.ts
import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  Get,
  Query,
  Param,
  Patch,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { ApiTags, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { PromotionsService } from './promotions.service';
import { CreatePromotionDto } from './dto/create-promotion.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UpdateQuantityDto } from './dto/update-quantity.dto';

@ApiTags('Promotions')
@ApiBearerAuth()
@Controller('promotions')
export class PromotionsController {
  constructor(private promotionsService: PromotionsService) {}

  // === Merchant Only ===
  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('MERCHANT')
  @Throttle({ default: { ttl: 60, limit: 10 } })
  create(@Req() req: any, @Body() dto: CreatePromotionDto) {
    const merchantId = req.user.id;
    return this.promotionsService.createPromotion(merchantId, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Get('my')
  async getMyPromotions(@Req() req: any) {
    const merchantId = req.user.id;
    return this.promotionsService.getMyPromotions(merchantId);
  }

  @Get('nearby')
  @UseGuards(JwtAuthGuard)
  @Throttle({ default: { ttl: 60, limit: 50 } })
  @ApiQuery({ name: 'lat', required: true })
  @ApiQuery({ name: 'lng', required: true })
  @ApiQuery({ name: 'radius', required: false, example: 10 })
  async getNearbyPromotions(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius = '10',
  ) {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lng);
    const radiusKm = parseFloat(radius);

    return this.promotionsService.getNearbyPromotions(latitude, longitude, radiusKm);
  }

    @Patch(':id/quantity')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('MERCHANT')
  async updateQuantity(
    @Req() req: any,
    @Param('id') promotionId: string,
    @Body() dto: UpdateQuantityDto,
  ) {
    return this.promotionsService.updatePromotionQuantity(
      req.user.id,
      promotionId,
      dto.quantityLimit,
    );
  }
}