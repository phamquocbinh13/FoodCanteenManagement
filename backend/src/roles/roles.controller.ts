import { Controller, Get, Put, Param, Body, Headers, UnauthorizedException } from '@nestjs/common';
import { RolesService } from './roles.service';

@Controller('roles')
export class RolesController {
  constructor(private readonly rolesService: RolesService) {}

  @Get()
  findAll() {
    return this.rolesService.findAll();
  }

  @Put('staff/:userId')
  assignRoles(
    @Headers('x-restaurant-id') restaurantId: string, 
    @Param('userId') userId: string, 
    @Body() data: { roleIds: string[] }
  ) {
    if (!restaurantId) throw new UnauthorizedException();
    return this.rolesService.assignRoles(restaurantId, userId, data.roleIds);
  }
}
