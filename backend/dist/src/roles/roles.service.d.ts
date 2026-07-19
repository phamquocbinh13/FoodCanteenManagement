import { PrismaService } from '../prisma/prisma.service';
export declare class RolesService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<{
        id: string;
        name: string;
        createdAt: Date;
        roleKey: string;
    }[]>;
    assignRoles(restaurantId: string, userId: string, roleIds: string[]): Promise<{
        success: boolean;
    }>;
}
