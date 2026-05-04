import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiQuery, ApiOkResponse } from '@nestjs/swagger';
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
  @ApiQuery({ name: 'radius', required: false, type: Number, example: 3 })
  @ApiQuery({ name: 'limit', required: false, type: Number, example: 20 })
  async getNearbyMerchants(
    @Query('lat') lat: string,
    @Query('lng') lng: string,
    @Query('radius') radius = '3',
    @Query('limit') limit = '20',
  ) {
    const latitude = parseFloat(lat);
    const longitude = parseFloat(lng);
    const radiusKm = parseFloat(radius);
    const maxResults = parseInt(limit);

    return this.locationService.findMerchantsInRadius(latitude, longitude, radiusKm, maxResults);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('states')
  @ApiOkResponse({ description: 'List of all available states' })
  async getStates() {
    return this.locationService.getStates();
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('lga')
  @ApiQuery({ name: 'state', required: false, type: String, description: 'Optional state filter' })
  @ApiOkResponse({ description: 'List of LGAs, optionally filtered by state' })
  async getLGAs(@Query('state') state?: string) {
    return this.locationService.getLGAs(state);
  }
}