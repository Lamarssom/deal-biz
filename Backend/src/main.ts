// src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';
import express from 'express';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

  const configService = app.get(ConfigService);
  const isProduction = configService.get<string>('NODE_ENV') === 'production';

  // === Security Headers ===
  app.use(
    helmet({
      contentSecurityPolicy: false,
    }),
  );

  // === Gzip compression ===
  app.use(compression());

  // === CORS - Tightened for Production ===
  const allowedOrigins = isProduction
    ? [
        'https://your-frontend-domain.com',     // ← change to your actual deployed frontend URL
        'https://deal-biz-web.vercel.app',      // example if you deploy to Vercel
        // Add any other production domains here
      ]
    : ['*']; // development = allow everything

  app.enableCors({
    origin: allowedOrigins,
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type, Accept, Authorization, x-paystack-signature',
    credentials: true,
  });

  console.log(`CORS configured for: ${isProduction ? 'PRODUCTION' : 'DEVELOPMENT'}`);

  // === Global Validation Pipe ===
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  // === Raw body for Paystack webhook (must stay before JSON parser) ===
  app.use(
    express.json({
      verify: (req: any, res: any, buf: Buffer) => {
        if (req.originalUrl === '/payments/webhook') {
          req.rawBody = buf;
        }
      },
    }),
  );

  // === Swagger (disable in production or protect it) ===
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