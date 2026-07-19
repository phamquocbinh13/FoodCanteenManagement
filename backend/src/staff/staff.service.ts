import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as argon2 from 'argon2';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class StaffService {
  constructor(private prisma: PrismaService) {}

  private _mapToSnakeCase(user: any) {
    if (!user) return null;
    return {
      id: user.id,
      restaurant_id: user.restaurantId,
      email: user.email,
      display_name: user.displayName,
      password_hash: user.passwordHash,
      is_active: user.isActive,
      created_at: user.createdAt,
      updated_at: user.updatedAt,
      roles: user.user_role?.map((ur: any) => ({
        id: ur.role.id,
        key: ur.role.roleKey,
        name: ur.role.name,
        created_at: ur.role.createdAt
      })) || []
    };
  }

  async findAll(restaurantId: string) {
    const users = await this.prisma.staffUser.findMany({
      where: { restaurantId },
      include: { user_role: { include: { role: true } } },
      orderBy: { displayName: 'asc' },
    });
    return users.map(u => this._mapToSnakeCase(u));
  }

  async findOne(restaurantId: string, id: string) {
    const user = await this.prisma.staffUser.findFirst({
      where: { id, restaurantId },
      include: { user_role: { include: { role: true } } },
    });
    if (!user) throw new NotFoundException('Staff not found');
    return this._mapToSnakeCase(user);
  }

  async create(restaurantId: string, data: any) {
    const passwordHash = await argon2.hash(data.password || data.password_hash || 'changeme123');
    
    const user = await this.prisma.staffUser.create({
      data: {
        id: uuidv4(),
        restaurantId,
        email: data.email,
        displayName: data.displayName || data.display_name,
        passwordHash,
        isActive: data.isActive ?? data.is_active ?? true,
      },
      include: { user_role: { include: { role: true } } },
    });
    return this._mapToSnakeCase(user);
  }

  async update(restaurantId: string, id: string, data: any) {
    await this.findOne(restaurantId, id); // Ensure it exists
    
    const updateData: any = {
      email: data.email,
      displayName: data.displayName || data.display_name,
      isActive: data.isActive ?? data.is_active,
    };
    
    if (data.password || data.password_hash) {
      updateData.passwordHash = await argon2.hash(data.password || data.password_hash);
    }

    const user = await this.prisma.staffUser.update({
      where: { id },
      data: updateData,
      include: { user_role: { include: { role: true } } },
    });
    return this._mapToSnakeCase(user);
  }

  async remove(restaurantId: string, id: string) {
    await this.findOne(restaurantId, id);
    // Soft delete by deactivating
    const user = await this.prisma.staffUser.update({
      where: { id },
      data: { isActive: false },
    });
    return this._mapToSnakeCase(user);
  }
}
