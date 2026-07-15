import {
  IsBoolean,
  IsIn,
  IsISO8601,
  IsInt,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateSessionDto {
  @IsString()
  @IsNotEmpty()
  tableId!: string;

  @IsString()
  @IsIn(['qr_scan', 'cashier_manual'])
  openedVia!: 'qr_scan' | 'cashier_manual';

  @IsOptional()
  @IsString()
  @MaxLength(32)
  displayNumber?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  sessionSequence?: number;

  @IsOptional()
  @IsString()
  sessionToken?: string;

  @IsOptional()
  @IsISO8601()
  tokenExpiresAt?: string;
}

export class JoinSessionDto {
  @IsString()
  @IsNotEmpty()
  sessionToken!: string;

  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;
}

export class CloseSessionDto {
  @IsOptional()
  @IsString()
  closedByUserId?: string;
}

export class TransferSessionDto {
  @IsString()
  @IsNotEmpty()
  targetTableId!: string;
}

export class PaymentSummaryDto {
  @IsOptional()
  @IsInt()
  @Min(0)
  subtotalMinor?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  discountMinor?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  taxMinor?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  serviceChargeMinor?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  totalMinor?: number;
}

export class UpdateSessionDto {
  @IsOptional()
  @IsString()
  status?: string;

  @IsOptional()
  @IsString()
  paymentStatus?: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  currentBatchNumber?: number;

  @IsOptional()
  @IsBoolean()
  paymentSoftLock?: boolean;

  @IsOptional()
  @ValidateNested()
  @Type(() => PaymentSummaryDto)
  paymentSummary?: PaymentSummaryDto;
}

export class AppendTimelineDto {
  @IsOptional()
  @IsString()
  id?: string;

  @IsString()
  @IsNotEmpty()
  eventType!: string;

  @IsOptional()
  @IsObject()
  payloadJson?: Record<string, unknown>;

  @IsOptional()
  @IsString()
  actorType?: string;

  @IsOptional()
  @IsString()
  actorId?: string;

  @IsOptional()
  @IsISO8601()
  occurredAt?: string;
}
