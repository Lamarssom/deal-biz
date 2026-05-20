// src/main.ts - FINAL FIXED VERSION (using NestJS built-in CORS)
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';
import express from 'express';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });

  const configService = app.get(ConfigService);
  const isProduction = configService.get<string>('NODE_ENV') === 'production';

  console.log(`🚀 Starting in ${isProduction ? 'PRODUCTION' : 'DEVELOPMENT'} mode`);

  // === NESTJS BUILT-IN CORS - SIMPLIFIED FOR DEVELOPMENT ===
  app.enableCors({
    origin: true,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'ngrok-skip-browser-warning'],
    exposedHeaders: ['Authorization'],
  });

  console.log('CORS enabled with origin: true (perfect for localhost:8081 + Expo web)');

  // === Other middleware ===
  app.use(helmet({ contentSecurityPolicy: false }));
  app.use(compression());

  // === Global pipes & body parser ===
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  app.use(
    express.json({
      verify: (req: any, res: any, buf: Buffer) => {
        if (req.originalUrl === '/payments/webhook') {
          req.rawBody = buf;
        }
      },
    }),
  );

  // === Swagger (dev only) ===
  if (!isProduction) {
    const config = new DocumentBuilder()
      .setTitle('Deal-Biz API')
      .setDescription('Hyperlocal Promotion Platform Backend')
      .setVersion('1.0')
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('api', app, document);
  }

  const port = configService.get<number>('PORT') || 3000;
  await app.listen(port);
  console.log(`🚀 Deal-Biz backend running on http://localhost:${port}`);
}

void bootstrap();