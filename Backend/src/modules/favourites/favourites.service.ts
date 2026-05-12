import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Favourite } from '../../entities/favourite.entity';
import { Promotion } from '../../entities/promotion.entity';

@Injectable()
export class FavouritesService {
  constructor(
    @InjectRepository(Favourite)
    private favouriteRepo: Repository<Favourite>,

    @InjectRepository(Promotion)
    private promotionRepo: Repository<Promotion>,
  ) {}

  async getMyFavourites(userId: string) {
    return this.favouriteRepo.find({
      where: { userId },
      relations: ['promotion', 'promotion.merchant'],
      order: { createdAt: 'DESC' },
    });
  }

  async addFavourite(userId: string, promotionId: string) {
    // Check if already favourited
    const existing = await this.favouriteRepo.findOne({ where: { userId, promotionId } });
    if (existing) return { message: 'Already in favourites' };

    const favourite = this.favouriteRepo.create({ userId, promotionId });
    await this.favouriteRepo.save(favourite);

    return { message: 'Added to favourites' };
  }

  async removeFavourite(userId: string, promotionId: string) {
    const result = await this.favouriteRepo.delete({ userId, promotionId });
    if (result.affected === 0) throw new NotFoundException('Favourite not found');
    return { message: 'Removed from favourites' };
  }
}