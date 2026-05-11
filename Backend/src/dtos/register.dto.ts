import { IsEmail, IsNotEmpty, IsEnum, MinLength, IsOptional, IsString, IsNumber, IsLatitude, IsLongitude } from 'class-validator';
import type { Role } from '../entities/user.entity';

export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @IsNotEmpty()
  @MinLength(6)
  password!: string;

  @IsOptional()
  @IsString()
  name?: string;

  @IsEnum(['CUSTOMER', 'MERCHANT'])
  role!: Role;

  // Merchant-specific fields
  @IsOptional()
  @IsString()
  businessName?: string;

  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsString()
  businessLGA?: string;

  @IsOptional()
  @IsString()
  phoneNumber?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsNumber()
  @IsLatitude()
  latitude?: number;

  @IsOptional()
  @IsNumber()
  @IsLongitude()
  longitude?: number;
}