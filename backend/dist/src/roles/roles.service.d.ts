import { PrismaService } from '../prisma/prisma.service';
export declare class RolesService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<{
        id: string;
        key: string;
        name: string;
        created_at: Date;
    }[]>;
    assignRoles(restaurantId: string, userId: string, roleIds: string[]): Promise<{
        success: boolean;
    }>;
}
