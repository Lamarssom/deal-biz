import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, Unique } from 'typeorm';
import { User } from './user.entity';
import { Merchant } from './merchant.entity';
import { Promotion } from './promotion.entity';

@Entity('favourites')
@Unique(['userId', 'merchantId', 'promotionId'])   // prevents duplicates
export class Favourite {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ nullable: true })
  userId?: string;

  @Column({ nullable: true })
  merchantId?: string;

  @Column()
  promotionId!: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE', nullable: true })
  user?: User;

  @ManyToOne(() => Merchant, { onDelete: 'CASCADE', nullable: true })
  merchant?: Merchant;

  @ManyToOne(() => Promotion, { onDelete: 'CASCADE' })
  promotion!: Promotion;

  @CreateDateColumn()
  createdAt!: Date;
}