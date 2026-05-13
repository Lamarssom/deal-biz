import { IsEmail, IsNotEmpty, IsEnum, MinLength, IsOptional, IsString, IsNumber, IsLatitude, IsLongitude, Matches, IsPhoneNumber } from 'class-validator';
import type { Role } from '../entities/user.entity';

export class RegisterDto {
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @IsNotEmpty()
  @MinLength(6)
  password!: string;

  @IsNotEmpty()
  @IsString()
  name!: string;

  @IsEnum(['CUSTOMER', 'MERCHANT'])
  role!: Role;

  // Phone number is now available for BOTH roles
  @IsOptional()
  @IsString()
  @IsPhoneNumber('NG')           // Validates Nigerian phone format
  phoneNumber?: string;

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