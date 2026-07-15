import { IsIn, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';

const REQUEST_TYPES = [
  'payment',
  'staff_assistance',
  'extra_water',
  'extra_bowl',
  'extra_spoon',
] as const;

export class CreateStaffRequestDto {
  @IsString()
  @IsNotEmpty()
  @IsIn([...REQUEST_TYPES])
  requestType!: (typeof REQUEST_TYPES)[number];

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string;
}

export class HandleStaffRequestDto {
  @IsOptional()
  @IsString()
  handledByUserId?: string;
}
