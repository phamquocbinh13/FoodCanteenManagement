import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { AuthTokensResponse, AuthenticatedUserDto } from './auth.types';
export declare class AuthService {
    private readonly prisma;
    private readonly jwt;
    private readonly config;
    private readonly accessTtlMs;
    private readonly refreshTtlMs;
    constructor(prisma: PrismaService, jwt: JwtService, config: ConfigService);
    login(username: string, password: string): Promise<AuthTokensResponse>;
    refresh(refreshToken: string): Promise<AuthTokensResponse>;
    logout(refreshToken?: string): Promise<void>;
    me(userId: string): Promise<AuthenticatedUserDto>;
    private issueTokens;
    private toUserDto;
    private findStaffByEmail;
    private findStaffById;
    private verifyPassword;
}
