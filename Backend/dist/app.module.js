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
const auth_module_1 = require("./modules/auth/auth.module");
const users_module_1 = require("./modules/users/users.module");
const merchants_module_1 = require("./modules/merchants/merchants.module");
const promotions_module_1 = require("./modules/promotions/promotions.module");
const redemptions_module_1 = require("./modules/redemptions/redemptions.module");
const payments_module_1 = require("./modules/payments/payments.module");
const analytics_module_1 = require("./modules/analytics/analytics.module");
const location_module_1 = require("./modules/location/location.module");
const database_module_1 = require("./database/database.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({ isGlobal: true }),
            database_module_1.DatabaseModule,
            schedule_1.ScheduleModule.forRoot(),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            merchants_module_1.MerchantsModule,
            promotions_module_1.PromotionsModule,
            redemptions_module_1.RedemptionsModule,
            payments_module_1.PaymentsModule,
            analytics_module_1.AnalyticsModule,
            location_module_1.LocationModule,
        ],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map