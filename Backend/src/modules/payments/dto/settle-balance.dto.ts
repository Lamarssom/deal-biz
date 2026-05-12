//src\modules\payments\dto\settle-balance.dto.ts
import { IsNumber, Min } from 'class-validator';

export class SettleBalanceDto {
  @IsNumber()
  @Min(100) 
  amount!: number; 
}