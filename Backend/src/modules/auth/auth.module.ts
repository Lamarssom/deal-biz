import { TypeOrmModule } from '@nestjs/typeorm';
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtStrategy } from '../../common/strategies/jwt.strategy';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { UsersModule } from '../users/users.module';
import { MerchantsModule } from '../merchants/merchants.module';
import { EmailModule } from '../email/email.module';
import { LgaService } from '../lga/lga.service';
import { LGA } from '../../entities/lga.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([LGA]),
    UsersModule,
    MerchantsModule,
    EmailModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET') ?? 'default_secret',
        signOptions: { expiresIn: parseInt(config.get<string>('JWT_EXPIRES_IN') || '86400') },
      }),
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, LgaService, JwtStrategy, JwtAuthGuard, RolesGuard],
  exports: [AuthService, JwtAuthGuard, RolesGuard],
})
export class AuthModule {}