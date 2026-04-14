import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('merchants')
export class Merchant {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  email!: string;

  @Column({ select: false })
  password!: string;

  @Column({ type: 'enum', enum: ['MERCHANT'], default: 'MERCHANT' })
  role!: 'MERCHANT';

  @Column()
  businessName!: string;

  @Column()
  category!: string;

  @Column('decimal', { precision: 10, scale: 6, nullable: true })
  latitude!: number | null;

  @Column('decimal', { precision: 10, scale: 6, nullable: true })
  longitude!: number | null;

  @Column()
  businessLGA!: string; // from your LGA dataset

  @Column({ default: false })
  isVerified!: boolean;

  @Column({ nullable: true })
  verificationCode!: string | null;

  @Column({ type: 'timestamp', nullable: true })
  verificationExpiresAt!: Date | null;

  @Column({ default: true })
  isActive!: boolean;

  // === NEW HYBRID FIELDS ===
  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
  outstandingBalance!: number; // accumulated 3% success fees

  @Column({ type: 'timestamp', nullable: true })
  lastInvoicedAt!: Date | null;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
