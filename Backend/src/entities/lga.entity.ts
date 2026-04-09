import { Entity, PrimaryGeneratedColumn, Column, Unique } from 'typeorm';

@Entity('lgas')
@Unique(['lga', 'ward']) // enforce uniqueness on LGA + Ward
export class LGA {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  state: string;

  @Column({ length: 100 })
  lga: string;

  @Column({ length: 100, nullable: true })
  ward: string;

  @Column('decimal', { precision: 10, scale: 6 })
  latitude: number;

  @Column('decimal', { precision: 10, scale: 6 })
  longitude: number;
}