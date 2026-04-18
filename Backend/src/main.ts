//src\main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { HttpExceptionFilter } from './common/filters/http-exeception.filter';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import compression from 'compression';
import express from 'express';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  //Security Headers
  app.use(
    helmet({
      contentSecurityPolicy: false,
    }),
  );

  //Gzip compression
  app.use(compression());

  //CORS (tighten origin in production – '*' is ok for now with Flutter)
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type, Accept, Authorization, x-paystack-signature',
    credentials: true,
  });

  //Global Validation Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );

  //Global Exception Filter
  app.useGlobalFilters(new HttpExceptionFilter());

  // Enable raw body ONLY for webhook (must come before global json parser if needed)
  app.use(
    express.json({
      verify: (req: any, res: any, buf: Buffer) => {
        if (req.originalUrl === '/payments/webhook') {
          req.rawBody = buf;
        }
      },
    }),
  );

  // Swagger
  const config = new DocumentBuilder()
    .setTitle('Deal-Biz API')
    .setDescription('Hyperlocal Promotion Platform Backend')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const configService = app.get(ConfigService);
  const port = configService.get<number>('PORT') || 3000;

  await app.listen(port);
  console.log(`🚀 Deal-Biz backend running on http://localhost:${port}`);
}

void bootstrap();
