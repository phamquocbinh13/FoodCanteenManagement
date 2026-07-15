import {
  CanActivate,
  ExecutionContext,
  Injectable,
} from '@nestjs/common';
import { Request } from 'express';
import { unauthorized } from '../../common/errors/api-exception';
import { sha256Hex } from '../../common/crypto/token-hash';
import { PrismaService } from '../../prisma/prisma.service';

export type CustomerSessionContext = {
  sessionId: string;
  restaurantId: string;
  plaintextToken: string;
};

@Injectable()
export class SessionTokenGuard implements CanActivate {
  constructor(private readonly prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<
      Request & { customerSession?: CustomerSessionContext }
    >();
    const token = extractSessionToken(req);
    if (!token) {
      throw unauthorized('INVALID_SESSION_TOKEN', 'Session token required');
    }

    const tokenHash = sha256Hex(token);
    const row = await this.prisma.session_auth_token.findUnique({
      where: { token_hash: tokenHash },
      include: { dine_in_session: true },
    });
    if (!row || row.revoked_at) {
      throw unauthorized('INVALID_SESSION_TOKEN', 'Invalid session token');
    }
    if (row.expires_at.getTime() <= Date.now()) {
      throw unauthorized('SESSION_TOKEN_EXPIRED', 'Session token expired');
    }

    req.customerSession = {
      sessionId: row.session_id,
      restaurantId: row.dine_in_session.restaurant_id,
      plaintextToken: token,
    };
    return true;
  }
}

export function extractSessionToken(req: Request): string | null {
  const header = req.header('x-session-token');
  if (header?.trim()) return header.trim();

  const auth = req.header('authorization');
  if (auth?.toLowerCase().startsWith('bearer ')) {
    return auth.slice(7).trim() || null;
  }
  return null;
}
