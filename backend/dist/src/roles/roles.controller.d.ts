import { RolesService } from './roles.service';
export declare class RolesController {
    private readonly rolesService;
    constructor(rolesService: RolesService);
    findAll(): Promise<{
        id: string;
        key: string;
        name: string;
        created_at: Date;
    }[]>;
    assignRoles(restaurantId: string, userId: string, data: {
        roleIds: string[];
    }): Promise<{
        success: boolean;
    }>;
}
