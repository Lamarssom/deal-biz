import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { LocationService } from './location.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@ApiTags('Location')
@Controller('location')
export class LocationController {
  constructor(private locationService: LocationService) {}

  @UseGuards(JwtAuthGuard)
  @Get('nearby-merchants')
  @ApiQuery({ name: 'lat', required: true, type: Number })
  @ApiQuery({ name: 'lng', required: true, type: Number })
  @ApiQuery({ name: 'radius', required: false, type: Number })
  async getNearbyMerchants(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius?: string,
  ) {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lng);
    const radiusKm = radius ? parseFloat(radius) : 3;

    return this.locationService.findMerchantsInRadius(latitude, longitude, radiusKm);
  }
}