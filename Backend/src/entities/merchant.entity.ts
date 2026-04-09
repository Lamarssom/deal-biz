import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';
import type { Role } from './user.entity';

@Entity('merchants')
@Index(['latitude', 'longitude'])
export class Merchant {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ select: false })
  password: string;

  @Column({ type: 'enum', enum: ['MERCHANT'], default: 'MERCHANT' })
  role: Role;

  @Column()
  businessName: string;

  @Column()
  category: string; // e.g. "Food", "Haircut", "Groceries"

  @Column({ type: 'varchar', nullable: true })
  businessLGA: string;

  @Column('decimal', { precision: 10, scale: 6, nullable: true })
  latitude: number | null;

  @Column('decimal', { precision: 10, scale: 6, nullable: true })
  longitude: number | null;

  @Column({ default: false })
  isVerified: boolean;

  @Column({ type: 'varchar', nullable: true })
  verificationCode: string | null;

  @Column({ type: 'timestamp', nullable: true })
  verificationExpiresAt: Date | null;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

}