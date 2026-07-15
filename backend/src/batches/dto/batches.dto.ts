import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class ConfirmBatchDto {
  @IsOptional()
  @IsString()
  actorType?: string;

  @IsOptional()
  @IsString()
  actorId?: string;
}

export class CreateBatchDto {
  @IsOptional()
  @IsInt()
  @Min(1)
  batchNumber?: number;

  @IsOptional()
  @IsString()
  confirmedByActorType?: string;

  @IsOptional()
  @IsString()
  confirmedByActorId?: string;
}

export class CreateBatchItemDto {
  @IsString()
  @IsNotEmpty()
  menuItemId!: string;

  @IsString()
  @IsNotEmpty()
  menuItemNameSnapshot!: string;

  @IsInt()
  @Min(0)
  unitPriceMinor!: number;

  @IsString()
  @IsNotEmpty()
  currencyCode!: string;

  @IsInt()
  @Min(1)
  quantity!: number;

  @IsInt()
  @Min(0)
  lineTotalMinor!: number;

  @IsOptional()
  @IsString()
  kitchenNotesRendered?: string;
}

export class BatchCustomizationDto {
  @IsString()
  @IsNotEmpty()
  groupKey!: string;

  @IsString()
  @IsNotEmpty()
  groupNameSnapshot!: string;

  @IsOptional()
  @IsString()
  optionKey?: string;

  @IsOptional()
  @IsString()
  optionNameSnapshot?: string;

  @IsOptional()
  @IsObject()
  valueJson?: Record<string, unknown>;

  @IsOptional()
  @IsInt()
  priceDeltaMinor?: number;

  @IsString()
  @IsNotEmpty()
  currencyCode!: string;

  @IsString()
  @IsNotEmpty()
  kitchenLabelRendered!: string;
}

export class BulkCustomizationsDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BatchCustomizationDto)
  customizations!: BatchCustomizationDto[];
}

export class UpdateBatchItemQuantityDto {
  @IsInt()
  delta!: number;
}
