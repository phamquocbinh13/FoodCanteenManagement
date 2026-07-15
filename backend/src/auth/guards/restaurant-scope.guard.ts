import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { forbidden } from '../../common/errors/api-exception';
import type { JwtPayload } from '../auth.types';

/**
 * Ensures JWT `rid` matches `:restaurantId` path param.
 * Compose after JwtAuthGuard on staff restaurant-scoped routes.
 */
@Injectable()
export class RestaurantScopeGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<{
      user?: JwtPayload;
      params?: { restaurantId?: string };
    }>();
    const user = request.user;
    const restaurantId = request.params?.restaurantId;
    if (!user || !restaurantId) {
      return true;
    }
    if (user.rid !== restaurantId) {
      throw forbidden(
        'RESTAURANT_FORBIDDEN',
        'Staff token is not authorized for this restaurant',
      );
    }
    return true;
  }
}
