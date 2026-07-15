import { AuthService } from './auth.service';
import { LoginDto, LogoutDto, RefreshDto } from './dto/auth.dto';
import type { JwtPayload } from './auth.types';
export declare class AuthController {
    private readonly auth;
    constructor(auth: AuthService);
    login(dto: LoginDto): Promise<import("./auth.types").AuthTokensResponse>;
    refresh(dto: RefreshDto): Promise<import("./auth.types").AuthTokensResponse>;
    logout(dto: LogoutDto): Promise<void>;
    me(user: JwtPayload): Promise<import("./auth.types").AuthenticatedUserDto>;
}
