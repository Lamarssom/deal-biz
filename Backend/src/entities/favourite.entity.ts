import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, Unique } from 'typeorm';
import { User } from './user.entity';
import { Promotion } from './promotion.entity';

@Entity('favourites')
@Unique(['userId', 'promotionId'])
export class Favourite {
  @PrimaryGeneratedColumn('uuid')
    id!: string;

  @Column()
    userId!: string;

  @Column()
    promotionId!: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
    user!: User;

  @ManyToOne(() => Promotion, { onDelete: 'CASCADE' })
    promotion!: Promotion;

  @CreateDateColumn()
    createdAt!: Date;
}