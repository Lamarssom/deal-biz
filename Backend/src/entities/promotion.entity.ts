//src\entities\promotion.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Merchant } from './merchant.entity';

export enum PromotionType {
    STANDARD = 'STANDARD',
    MICRO = 'MICRO'
}

@Entity('promotions')
export class Promotion {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Merchant, { nullable: false, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'merchantId' })
  merchant: Merchant;

  @Column({ nullable: false })
  merchantId: string;

  @Column({ type: 'enum', enum: ['STANDARD', 'MICRO'] })
  type: PromotionType;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  fee: number; // ₦100 or ₦50

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  price: number; // deal price

  @Column({ nullable: true })
  originalPrice: number; // for discount visibility

  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ nullable: true })
  photoUrl: string; // only for STANDARD

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  radiusKm: number; // 3km for Standard, 1km for Micro

  @Column({ type: 'timestamp' })
  expiry: Date;

  @Column({ default: 0 })
  quantityLimit: number; // 0 = unlimited

  @Column({ default: 0 })
  redeemedCount: number;

  @Column({ default: 0 })
  views: number;

  @Column({ default: 0 })
  popularityScore: number; // for ranking (redemptions + views)

  @Column({ default: true })
  isActive: boolean;

  @Column({ nullable: true })
  idempotencyKey: string; // for payment safety

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}