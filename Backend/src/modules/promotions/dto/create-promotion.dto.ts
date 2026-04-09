//src\modules\promotions\dto\create-promotion.dto.ts
import { IsEnum, IsNotEmpty, IsString, IsNumber, IsOptional, IsDateString, Min } from 'class-validator';
import type { PromotionType } from '../../../entities/promotion.entity';

export class CreatePromotionDto {
  @IsEnum(['STANDARD', 'MICRO'])
  type: PromotionType;

  @IsNotEmpty()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNumber()
  @Min(0)
  price: number;

  @IsOptional()
  @IsNumber()
  originalPrice?: number;

  @IsOptional()
  @IsString()
  photoUrl?: string; // only STANDARD

  @IsDateString()
  expiry: string;

  @IsNumber()
  @Min(0)
  quantityLimit: number;

  @IsOptional()
  @IsNumber()
  radiusKm?: number;
}