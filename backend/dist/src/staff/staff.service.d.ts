import { PrismaService } from '../prisma/prisma.service';
export declare class StaffService {
    private prisma;
    constructor(prisma: PrismaService);
    private _mapToSnakeCase;
    findAll(restaurantId: string): Promise<({
        id: any;
        restaurant_id: any;
        email: any;
        display_name: any;
        password_hash: any;
        is_active: any;
        created_at: any;
        updated_at: any;
        roles: any;
    } | null)[]>;
    findOne(restaurantId: string, id: string): Promise<{
        id: any;
        restaurant_id: any;
        email: any;
        display_name: any;
        password_hash: any;
        is_active: any;
        created_at: any;
        updated_at: any;
        roles: any;
    } | null>;
    create(restaurantId: string, data: any): Promise<{
        id: any;
        restaurant_id: any;
        email: any;
        display_name: any;
        password_hash: any;
        is_active: any;
        created_at: any;
        updated_at: any;
        roles: any;
    } | null>;
    update(restaurantId: string, id: string, data: any): Promise<{
        id: any;
        restaurant_id: any;
        email: any;
        display_name: any;
        password_hash: any;
        is_active: any;
        created_at: any;
        updated_at: any;
        roles: any;
    } | null>;
    remove(restaurantId: string, id: string): Promise<{
        id: any;
        restaurant_id: any;
        email: any;
        display_name: any;
        password_hash: any;
        is_active: any;
        created_at: any;
        updated_at: any;
        roles: any;
    } | null>;
}
