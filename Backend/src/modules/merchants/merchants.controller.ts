import { Controller, Get, Query } from '@nestjs/common'
import { MerchantsService } from './merchants.service'

@Controller('merchants')
export class MerchantsController {
  constructor(private readonly merchantService: MerchantsService) {}

  @Get('nearby')
  findNearby(
    @Query('lat') lat: number,
    @Query('lng') lng: number
  ) {
    return this.merchantService.findNearby(Number(lat), Number(lng))
  }
}