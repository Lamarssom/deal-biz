//\src\dtos\register.dto.ts
import { IsEmail, IsNotEmpty, IsEnum, MinLength, IsOptional, IsString, IsPhoneNumber } from 'class-validator';
import type { Role } from '../entities/user.entity';

export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @IsOptional()
  @IsString()
  @IsPhoneNumber()
  phoneNumber?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsNotEmpty()
  @MinLength(6)
  password!: string;

  @IsEnum(['CUSTOMER', 'MERCHANT'])
  role!: Role;

  @IsOptional()
  @IsString()
  name?: string;

  // Merchant-only fields
  @IsOptional()
  @IsString()
  businessName?: string;

  @IsOptional()
  @IsString()
  category?: string;
  
  @IsOptional()
  @IsString()
  businessLGA?: string;
}