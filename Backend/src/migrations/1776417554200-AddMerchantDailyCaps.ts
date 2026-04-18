import { MigrationInterface, QueryRunner } from "typeorm";

export class AddMerchantDailyCaps1776417554200 implements MigrationInterface {
    name = 'AddMerchantDailyCaps1776417554200'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "merchants" ADD "dailySpendThisDay" numeric(10,2) NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE "merchants" ADD "dailyResetAt" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "merchants" ADD "dailyPromoLimit" integer NOT NULL DEFAULT '5'`);
        await queryRunner.query(`ALTER TABLE "merchants" ADD "maxActivePromos" integer NOT NULL DEFAULT '3'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "merchants" DROP COLUMN "maxActivePromos"`);
        await queryRunner.query(`ALTER TABLE "merchants" DROP COLUMN "dailyPromoLimit"`);
        await queryRunner.query(`ALTER TABLE "merchants" DROP COLUMN "dailyResetAt"`);
        await queryRunner.query(`ALTER TABLE "merchants" DROP COLUMN "dailySpendThisDay"`);
    }

}
