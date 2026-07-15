import { IsOptional, IsString } from 'class-validator';

export class ToggleAvailabilityDto {
  @IsOptional()
  @IsString()
  changedByUserId?: string;
}
