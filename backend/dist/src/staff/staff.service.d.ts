import { PrismaService } from '../prisma/prisma.service';
export declare class StaffService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(restaurantId: string): Promise<({
        user_role: ({
            role: {
                id: string;
                name: string;
                createdAt: Date;
                roleKey: string;
            };
        } & {
            id: string;
            created_at: Date;
            role_id: string;
            user_id: string;
        })[];
    } & {
        id: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        email: string;
        displayName: string;
        passwordHash: string;
        lastLoginAt: Date | null;
    })[]>;
    findOne(restaurantId: string, id: string): Promise<{
        user_role: ({
            role: {
                id: string;
                name: string;
                createdAt: Date;
                roleKey: string;
            };
        } & {
            id: string;
            created_at: Date;
            role_id: string;
            user_id: string;
        })[];
    } & {
        id: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        email: string;
        displayName: string;
        passwordHash: string;
        lastLoginAt: Date | null;
    }>;
    create(restaurantId: string, data: any): Promise<{
        user_role: ({
            role: {
                id: string;
                name: string;
                createdAt: Date;
                roleKey: string;
            };
        } & {
            id: string;
            created_at: Date;
            role_id: string;
            user_id: string;
        })[];
    } & {
        id: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        email: string;
        displayName: string;
        passwordHash: string;
        lastLoginAt: Date | null;
    }>;
    update(restaurantId: string, id: string, data: any): Promise<{
        user_role: ({
            role: {
                id: string;
                name: string;
                createdAt: Date;
                roleKey: string;
            };
        } & {
            id: string;
            created_at: Date;
            role_id: string;
            user_id: string;
        })[];
    } & {
        id: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        email: string;
        displayName: string;
        passwordHash: string;
        lastLoginAt: Date | null;
    }>;
    remove(restaurantId: string, id: string): Promise<{
        id: string;
        isActive: boolean;
        createdAt: Date;
        updatedAt: Date;
        restaurantId: string;
        email: string;
        displayName: string;
        passwordHash: string;
        lastLoginAt: Date | null;
    }>;
}
