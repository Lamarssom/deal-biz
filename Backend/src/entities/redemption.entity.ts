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
import { User } from './user.entity'; 

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
  qrCode!: string;

  @Column({ default: false })
  isRedeemed!: boolean;

  @Column({ type: 'timestamp', nullable: true })
  redeemedAt!: Date;

  @CreateDateColumn()
  createdAt!: Date;

  @Column({ type: 'int', default: 1 })
  quantity: number = 1;
}
