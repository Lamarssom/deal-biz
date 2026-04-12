//src\modules\redemptions\dto\redeem.dto.ts
import { IsNotEmpty, IsString } from 'class-validator';

export class RedeemDto {
  @IsString()
  @IsNotEmpty()
  qrCode!: string; // scanned from customer QR
}
