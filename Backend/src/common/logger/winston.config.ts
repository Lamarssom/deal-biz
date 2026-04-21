import { utilities as nestWinstonModuleUtilities } from 'nest-winston';
import * as winston from 'winston';
import { ConfigService } from '@nestjs/config';

export const createWinstonConfig = (configService: ConfigService) => {
  const isProduction = configService.get<string>('NODE_ENV') === 'production';
  const logLevel =
    configService.get<string>('LOG_LEVEL') || (isProduction ? 'info' : 'debug');

  return {
    level: logLevel,
    format: winston.format.combine(
      winston.format.timestamp(),
      winston.format.errors({ stack: true }),
      winston.format.splat(),
      nestWinstonModuleUtilities.format.nestLike('Deal-Biz', {
        prettyPrint: !isProduction,
        colors: !isProduction,
      }),
    ),
    transports: [
      // Always log to console
      new winston.transports.Console(),

      // In production, also log to file (daily rotation recommended later)
      ...(isProduction
        ? [
            new winston.transports.File({
              filename: 'logs/error.log',
              level: 'error',
            }),
            new winston.transports.File({
              filename: 'logs/combined.log',
            }),
          ]
        : []),
    ],
  };
};
