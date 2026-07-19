import { RolesService } from './roles.service';
export declare class RolesController {
    private readonly rolesService;
    constructor(rolesService: RolesService);
    findAll(): Promise<{
        id: string;
        name: string;
        createdAt: Date;
        roleKey: string;
    }[]>;
    assignRoles(restaurantId: string, userId: string, data: {
        roleIds: string[];
    }): Promise<{
        success: boolean;
    }>;
}
