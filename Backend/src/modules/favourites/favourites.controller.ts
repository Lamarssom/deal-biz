import { Controller, Get, Post, Delete, Param, Req, UseGuards } from '@nestjs/common';
import { FavouritesService } from './favourites.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

@Controller('favourites')
@UseGuards(JwtAuthGuard)
export class FavouritesController {
  constructor(private readonly favouritesService: FavouritesService) {}

  @Get()
  getMyFavourites(@Req() req: any) {
    return this.favouritesService.getMyFavourites(req.user.id, req.user.role);
  }

  @Post(':promotionId')
  addFavourite(@Req() req: any, @Param('promotionId') promotionId: string) {
    return this.favouritesService.addFavourite(req.user.id, req.user.role, promotionId);
  }

  @Delete(':promotionId')
  removeFavourite(@Req() req: any, @Param('promotionId') promotionId: string) {
    return this.favouritesService.removeFavourite(req.user.id, req.user.role, promotionId);
  }
}