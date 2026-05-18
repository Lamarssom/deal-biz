import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

export type Role = 'CUSTOMER' | 'MERCHANT';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  email!: string;

  @Column({ nullable: true, unique: true })
  phoneNumber?: string;

  @Column({ select: false })
  password!: string;

  @Column({ type: 'enum', enum: ['CUSTOMER'], default: 'CUSTOMER' })
  role!: Role;

  @Column({ default: false })
  isVerified!: boolean;

  @Column({ nullable: true })
  verificationCode?: string;

  @Column({ nullable: true })
  verificationExpiresAt?: Date;

  @Column({ default: true })
  isActive!: boolean;

  @Column({ default: false })          
  isProfileComplete!: boolean;

  @Column({ nullable: true })
  name?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}