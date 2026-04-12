//\src\entities\redemption.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Promotion } from './promotion.entity';
import { User } from './user.entity'; // customer who redeems

@Entity('redemptions')
export class Redemption {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @ManyToOne(() => Promotion, { nullable: false, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'promotionId' })
  promotion!: Promotion;

  @Column()
  promotionId!: string;

  @ManyToOne(() => User, { nullable: false })
  @JoinColumn({ name: 'customerId' })
  customer!: User;

  @Column()
  customerId!: string;

  @Column({ unique: true })
  qrCode!: string; // unique redemption token (used in QR)

  @Column({ default: false })
  isRedeemed!: boolean;

  @Column({ type: 'timestamp', nullable: true })
  redeemedAt!: Date;

  @CreateDateColumn()
  createdAt!: Date;
}
