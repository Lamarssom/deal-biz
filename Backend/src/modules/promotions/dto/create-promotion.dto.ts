//src\modules\promotions\dto\create-promotion.dto.ts
import { IsEnum, IsNotEmpty, IsString, IsNumber, IsOptional, IsDateString, Min, MaxLength } from 'class-validator';
import { PromotionType } from '../../../entities/promotion.entity';

export class CreatePromotionDto {
  @IsEnum(PromotionType)
  type: PromotionType;

  @IsNotEmpty()
  @IsString()
  @MaxLength(100)
  title: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  description?: string;

  @IsNumber()
  @Min(0)
  price: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  originalPrice?: number;

  @IsOptional()
  @IsString()
  photoUrl?: string; // only for STANDARD

  @IsDateString()
  expiry: string;

  @IsNumber()
  @Min(0)
  quantityLimit: number = 0;

  @IsOptional()
  @IsString()
  idempotencyKey?: string;
}