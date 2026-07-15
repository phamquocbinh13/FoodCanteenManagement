import { CanActivate, ExecutionContext } from '@nestjs/common';
import { Request } from 'express';
import { PrismaService } from '../../prisma/prisma.service';
export type CustomerSessionContext = {
    sessionId: string;
    restaurantId: string;
    plaintextToken: string;
};
export declare class SessionTokenGuard implements CanActivate {
    private readonly prisma;
    constructor(prisma: PrismaService);
    canActivate(context: ExecutionContext): Promise<boolean>;
}
export declare function extractSessionToken(req: Request): string | null;
