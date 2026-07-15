"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RestaurantScopeGuard = void 0;
const common_1 = require("@nestjs/common");
const api_exception_1 = require("../../common/errors/api-exception");
let RestaurantScopeGuard = class RestaurantScopeGuard {
    canActivate(context) {
        const request = context.switchToHttp().getRequest();
        const user = request.user;
        const restaurantId = request.params?.restaurantId;
        if (!user || !restaurantId) {
            return true;
        }
        if (user.rid !== restaurantId) {
            throw (0, api_exception_1.forbidden)('RESTAURANT_FORBIDDEN', 'Staff token is not authorized for this restaurant');
        }
        return true;
    }
};
exports.RestaurantScopeGuard = RestaurantScopeGuard;
exports.RestaurantScopeGuard = RestaurantScopeGuard = __decorate([
    (0, common_1.Injectable)()
], RestaurantScopeGuard);
//# sourceMappingURL=restaurant-scope.guard.js.map