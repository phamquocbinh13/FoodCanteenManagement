import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class RolesService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    const roles = await this.prisma.role.findMany({
      orderBy: { name: 'asc' },
    });
    return roles.map(r => ({
      id: r.id,
      key: r.roleKey,
      name: r.name,
      created_at: r.createdAt
    }));
  }

  async assignRoles(restaurantId: string, userId: string, roleIds: string[]) {
    // Verify user exists and belongs to restaurant
    const user = await this.prisma.staffUser.findFirst({
      where: { id: userId, restaurantId }
    });
    if (!user) throw new NotFoundException('User not found');

    // Delete existing roles
    await this.prisma.user_role.deleteMany({
      where: { user_id: userId }
    });

    // Assign new roles
    if (roleIds.length > 0) {
      const inserts = roleIds.map(roleId => ({
        id: uuidv4(),
        user_id: userId,
        role_id: roleId,
      }));
      await this.prisma.user_role.createMany({
        data: inserts
      });
    }

    return { success: true };
  }
}
