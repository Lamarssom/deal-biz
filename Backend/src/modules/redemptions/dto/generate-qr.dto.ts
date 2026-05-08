//src\modules\redemptions\dto\generate-qr.dto.ts
import { IsNotEmpty, IsUUID, IsInt, Min } from 'class-validator';

export class GenerateQrDto {
  @IsNotEmpty()
  @IsUUID()
  promotionId!: string;

  @IsNotEmpty()
  @IsInt()
  @Min(1)
  quantity: number = 1;
}