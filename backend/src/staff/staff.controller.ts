import { Controller, Get, Post, Put, Delete, Param, Body, Headers, UnauthorizedException } from '@nestjs/common';
import { StaffService } from './staff.service';

@Controller('staff')
export class StaffController {
  constructor(private readonly staffService: StaffService) {}

  @Get()
  findAll(@Headers('x-restaurant-id') restaurantId: string) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.staffService.findAll(restaurantId);
  }

  @Get(':id')
  findOne(@Headers('x-restaurant-id') restaurantId: string, @Param('id') id: string) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.staffService.findOne(restaurantId, id);
  }

  @Post()
  create(@Headers('x-restaurant-id') restaurantId: string, @Body() data: any) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.staffService.create(restaurantId, data);
  }

  @Put(':id')
  update(@Headers('x-restaurant-id') restaurantId: string, @Param('id') id: string, @Body() data: any) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.staffService.update(restaurantId, id, data);
  }

  @Delete(':id')
  remove(@Headers('x-restaurant-id') restaurantId: string, @Param('id') id: string) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.staffService.remove(restaurantId, id);
  }
}
