import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as argon2 from 'argon2';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class StaffService {
  constructor(private prisma: PrismaService) {}

  async findAll(restaurantId: string) {
    return this.prisma.staffUser.findMany({
      where: { restaurantId },
      include: { user_role: { include: { role: true } } },
      orderBy: { displayName: 'asc' },
    });
  }

  async findOne(restaurantId: string, id: string) {
    const user = await this.prisma.staffUser.findFirst({
      where: { id, restaurantId },
      include: { user_role: { include: { role: true } } },
    });
    if (!user) throw new NotFoundException('Staff not found');
    return user;
  }

  async create(restaurantId: string, data: any) {
    const passwordHash = await argon2.hash(data.password || 'changeme123');
    
    return this.prisma.staffUser.create({
      data: {
        id: uuidv4(),
        restaurantId,
        email: data.email,
        displayName: data.displayName,
        passwordHash,
        isActive: data.isActive ?? true,
      },
      include: { user_role: { include: { role: true } } },
    });
  }

  async update(restaurantId: string, id: string, data: any) {
    await this.findOne(restaurantId, id); // Ensure it exists
    
    const updateData: any = {
      email: data.email,
      displayName: data.displayName,
      isActive: data.isActive,
    };
    
    if (data.password) {
      updateData.passwordHash = await argon2.hash(data.password);
    }

    return this.prisma.staffUser.update({
      where: { id },
      data: updateData,
      include: { user_role: { include: { role: true } } },
    });
  }

  async remove(restaurantId: string, id: string) {
    await this.findOne(restaurantId, id);
    // Soft delete by deactivating
    return this.prisma.staffUser.update({
      where: { id },
      data: { isActive: false },
    });
  }
}
