export type JwtPayload = {
    sub: string;
    email: string;
    role: string;
    rid: string;
};
export type AuthenticatedUserDto = {
    id: string;
    username: string;
    fullName: string;
    role: string;
    permissions: string[];
    active: boolean;
    createdAt: string;
};
export type AuthTokensResponse = {
    user: AuthenticatedUserDto;
    accessToken: string;
    refreshToken: string;
    expiresAt: string;
};
export declare function usernameFromEmail(email: string): string;
export declare function resolveLoginEmail(username: string): string;
