//src\modules\promotions\promotions.controller.ts
import {
  Controller,
  Post,
  Body,
  UseGuards,
  Req,
  Get,
  Query,
} from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiResponse, ApiQuery } from '@nestjs/swagger';
import { PromotionsService } from './promotions.service';
import { CreatePromotionDto } from './dto/create-promotion.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';

@ApiTags('Promotions')
@ApiBearerAuth()
@Controller('promotions')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PromotionsController {
  constructor(private promotionsService: PromotionsService) {}

  @Post()
  @Roles('MERCHANT')
  @ApiResponse({
    status: 201,
    description: 'Promotion created – Paystack payment required',
  })
  create(@Req() req: any, @Body() dto: CreatePromotionDto) {
    const merchantId = req.user.id; // from JWT
    return this.promotionsService.createPromotion(merchantId, dto);
    console.log('BODY RECEIVED:', Body);
  }

  // New: Deals near you (public or protected)
  @Get('nearby')
  @ApiQuery({ name: 'lat', required: true })
  @ApiQuery({ name: 'lng', required: true })
  @ApiQuery({ name: 'radius', required: false, example: 5 })
  async getNearby(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius = '5',
  ) {
    return this.promotionsService.getNearbyPromotions(
      parseFloat(lat),
      parseFloat(lng),
      parseFloat(radius),
    );
  }
}
