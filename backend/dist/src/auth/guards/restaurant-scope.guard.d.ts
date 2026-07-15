import { CanActivate, ExecutionContext } from '@nestjs/common';
export declare class RestaurantScopeGuard implements CanActivate {
    canActivate(context: ExecutionContext): boolean;
}
