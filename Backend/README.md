# Deal-Biz Backend

Hyperlocal Promotion Platform for Small Businesses in Nigeria

Merchants create real-time deals that nearby customers instantly discover.  
“Deals near you right now” — powered by GPS + Nigerian LGA coordinates.

Updated Revenue Model (Hybrid – as per latest PDF)  
- ₦25 flat creation fee to publish a promotion (“pay to go live”)  
- 3% success fee on every redemption (charged automatically)  
- Credit limit ₦5,000 — new promotions blocked when reached  
- Auto-invoice every 7 days OR when balance ≥ ₦2,000

Tech Stack (matches your fx-trading-app and payment-webhook-reconciliation-service):
- NestJS + TypeScript + TypeORM + PostgreSQL
- Paystack payments + idempotency
- Email auth (Resend)
- Haversine + Bounding Box SQL geospatial queries
- Atomic transactions for redemptions

## Features Implemented (Phases 1-6)

Phase 1: Project setup, local Postgres, Paystack, env config, Swagger  
Phase 2: Email + Password auth, JWT, Merchant-only email verification, Password reset  
Phase 3: LGA dataset (8,798 records), merchant location, SQL-optimized Haversine (bounding box + distance), indexes  
Phase 4: Promotion entity (Standard/Micro), creation with Paystack fee, idempotency, ranking (distance + popularity + urgency), nearby deals feed  
Phase 5: Redemption entity, QR code generation, atomic redeem transaction, quantity limits  
Phase 6: Merchant analytics dashboard, email notifications (Resend), full Swagger, seeds, production-ready polish
**Phase 6.1 - ₦25 creation fee + 3% success fee + credit limit + auto-invoicing** 

## Quick Start

```bash
git clone https://github.com/Lamarssom/deal-biz.git
cd deal-biz/Backend
npm install
cp .env.example .env   # fill your keys
# Create database: deal_biz
npm run start:dev

Open Swagger: http://localhost:3000/api
Key Endpoints
Auth

POST /auth/register
POST /auth/login
POST /auth/verify-email (merchants only)
POST /auth/forgot-password
POST /auth/reset-password

Promotions

POST /promotions (merchant only – creates + Paystack payment)
GET /promotions/nearby?lat=...&lng=...&radius=... (Deals near you)

Location

GET /location/nearby-merchants?lat=...&lng=...&radius=...

Redemptions

POST /redemptions/generate (customer generates QR)
POST /redemptions/redeem (merchant scans QR)

Analytics

GET /analytics/merchant (merchant dashboard)

Payments Webhook
POST /payments/webhook (Paystack callback)
POST /payments/settle/balance (pay outstanding balance)

Database

Local PostgreSQL (deal_biz)
Run migrations or let TypeORM synchronize (dev only)
Indexes on location, QR codes, etc. already created
LGA table with 8,798 Nigerian wards + coordinates

Production Notes

Set synchronize: false + use TypeORM migrations
Enable PostGIS extension for even faster queries (optional)
Add Redis for caching/ranking at scale
Deploy on Railway/Render (free tier handles Postgres)
Rate limiting & NDPR-compliant logging already in place

Testing
All core flows tested:

Register → Login → Create Promotion → Pay → Activate via webhook → Generate QR → Redeem → Analytics