import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

/** Schema CHECK + Flutter ForceCloseReason. */
export const FORCE_CLOSE_REASONS = [
  'customer_left',
  'dispute',
  'system_error',
  'other',
] as const;

export type ForceCloseReason = (typeof FORCE_CLOSE_REASONS)[number];

export class CreateSessionPaymentDto {
  @IsString()
  @IsIn(['cash', 'card', 'bank_transfer', 'other'])
  paymentMethod!: 'cash' | 'card' | 'bank_transfer' | 'other';

  @IsString()
  @IsIn(['payment', 'force_closed'])
  closeType!: 'payment' | 'force_closed';

  /** Required when closeType=force_closed (enforced in service → 422). */
  @IsOptional()
  @IsString()
  @IsIn([...FORCE_CLOSE_REASONS])
  forceCloseReason?: ForceCloseReason;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  forceCloseNote?: string;
}
