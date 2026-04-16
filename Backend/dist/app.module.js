"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const schedule_1 = require("@nestjs/schedule");
const throttler_1 = require("@nestjs/throttler");
const event_emitter_1 = require("@nestjs/event-emitter");
const auth_module_1 = require("./modules/auth/auth.module");
const users_module_1 = require("./modules/users/users.module");
const merchants_module_1 = require("./modules/merchants/merchants.module");
const promotions_module_1 = require("./modules/promotions/promotions.module");
const redemptions_module_1 = require("./modules/redemptions/redemptions.module");
const payments_module_1 = require("./modules/payments/payments.module");
const analytics_module_1 = require("./modules/analytics/analytics.module");
const location_module_1 = require("./modules/location/location.module");
const database_module_1 = require("./database/database.module");
const notifications_module_1 = require("./modules/notifications/notifications.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({
                isGlobal: true,
                validate: (config) => {
                    if (!config.DB_HOST)
                        throw new Error('DB_HOST is required');
                    if (!config.DB_PORT)
                        throw new Error('DB_PORT is required');
                    if (!config.DB_USERNAME)
                        throw new Error('DB_USERNAME is required');
                    if (!config.DB_PASSWORD)
                        throw new Error('DB_PASSWORD is required');
                    if (!config.DB_NAME)
                        throw new Error('DB_NAME is required');
                    if (!config.JWT_SECRET)
                        throw new Error('JWT_SECRET is required');
                    if (!config.PAYSTACK_SECRET_KEY)
                        throw new Error('PAYSTACK_SECRET_KEY is required');
                    if (!config.PAYSTACK_PUBLIC_KEY)
                        throw new Error('PAYSTACK_PUBLIC_KEY is required');
                    return config;
                },
            }),
            database_module_1.DatabaseModule,
            event_emitter_1.EventEmitterModule.forRoot(),
            throttler_1.ThrottlerModule.forRoot({
                throttlers: [
                    {
                        ttl: 60000,
                        limit: 10,
                    },
                ],
            }),
            schedule_1.ScheduleModule.forRoot(),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            merchants_module_1.MerchantsModule,
            promotions_module_1.PromotionsModule,
            redemptions_module_1.RedemptionsModule,
            payments_module_1.PaymentsModule,
            analytics_module_1.AnalyticsModule,
            location_module_1.LocationModule,
            notifications_module_1.NotificationsModule,
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map