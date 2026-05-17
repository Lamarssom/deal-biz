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

  async getMyFavourites(ownerId: string, role: 'CUSTOMER' | 'MERCHANT') {
    const where = role === 'MERCHANT' 
      ? { merchantId: ownerId } 
      : { userId: ownerId };

    return this.favouriteRepo.find({
      where,
      relations: ['promotion', 'promotion.merchant'],
      order: { createdAt: 'DESC' },
    });
  }

  async addFavourite(ownerId: string, role: 'CUSTOMER' | 'MERCHANT', promotionId: string) {
    const existing = await this.favouriteRepo.findOne({
      where: role === 'MERCHANT' 
        ? { merchantId: ownerId, promotionId } 
        : { userId: ownerId, promotionId }
    });

    if (existing) return { message: 'Already in favourites' };

    const favourite = this.favouriteRepo.create(
      role === 'MERCHANT' 
        ? { merchantId: ownerId, promotionId } 
        : { userId: ownerId, promotionId }
    );

    await this.favouriteRepo.save(favourite);
    return { message: 'Added to favourites' };
  }

  async removeFavourite(ownerId: string, role: 'CUSTOMER' | 'MERCHANT', promotionId: string) {
    const result = await this.favouriteRepo.delete(
      role === 'MERCHANT' 
        ? { merchantId: ownerId, promotionId } 
        : { userId: ownerId, promotionId }
    );

    if (result.affected === 0) throw new NotFoundException('Favourite not found');
    return { message: 'Removed from favourites' };
  }
}