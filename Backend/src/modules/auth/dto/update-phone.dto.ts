import { IsString, IsNotEmpty, IsPhoneNumber } from 'class-validator';

export class UpdatePhoneDto {
  @IsString()
    @IsNotEmpty()
    @IsPhoneNumber('NG')
    phoneNumber!: string;
}