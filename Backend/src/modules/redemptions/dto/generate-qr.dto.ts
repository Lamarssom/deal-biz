//src\modules\redemptions\dto\generate-qr.dto.ts
import { IsNotEmpty, IsUUID } from 'class-validator';

export class GenerateQrDto {
  @IsUUID()
  @IsNotEmpty()
  promotionId!: string;
}
