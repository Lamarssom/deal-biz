import { Controller, Get } from '@nestjs/common';

@Controller('metrics')
export class MetricsController {
  @Get()
  getMetrics() {
    return {
      status: 'ok',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    };
  }
}
