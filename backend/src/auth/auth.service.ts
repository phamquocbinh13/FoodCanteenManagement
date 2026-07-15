import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import { v4 as uuidv4 } from 'uuid';
import {
  forbidden,
  unauthorized,
} from '../common/errors/api-exception';
import {
  generateOpaqueToken,
  sha256Hex,
} from '../common/crypto/token-hash';
import { parseDurationMs } from '../common/utils/duration';
import { PrismaService } from '../prisma/prisma.service';
import {
  AuthTokensResponse,
  AuthenticatedUserDto,
  JwtPayload,
  resolveLoginEmail,
  usernameFromEmail,
} from './auth.types';

type StaffWithRoles = {
  id: string;
  email: string;
  displayName: string;
  passwordHash: string;
  isActive: boolean;
  restaurantId: string;
  createdAt: Date;
  user_role: Array<{ role: { id: string; roleKey: string } }>;
};

@Injectable()
export class AuthService {
  private readonly accessTtlMs: number;
  private readonly refreshTtlMs: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
  ) {
    this.accessTtlMs = parseDurationMs(
      this.config.get<string>('JWT_ACCESS_TTL'),
      15 * 60_000,
    );
    this.refreshTtlMs = parseDurationMs(
      this.config.get<string>('JWT_REFRESH_TTL'),
      7 * 86_400_000,
    );
  }

  async login(username: string, password: string): Promise<AuthTokensResponse> {
    const email = resolveLoginEmail(username);
    const user = await this.findStaffByEmail(email);
    if (!user) {
      throw unauthorized('INVALID_CREDENTIALS', 'Invalid username or password');
    }
    if (!user.isActive) {
      throw forbidden('USER_INACTIVE', 'User account is inactive');
    }

    const ok = await this.verifyPassword(user.passwordHash, password);
    if (!ok) {
      throw unauthorized('INVALID_CREDENTIALS', 'Invalid username or password');
    }

    await this.prisma.staffUser.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date() },
    });

    return this.issueTokens(user);
  }

  async refresh(refreshToken: string): Promise<AuthTokensResponse> {
    const tokenHash = sha256Hex(refreshToken);
    const stored = await this.prisma.staff_refresh_token.findUnique({
      where: { token_hash: tokenHash },
    });
    if (!stored || stored.revoked_at) {
      throw unauthorized('INVALID_REFRESH', 'Invalid refresh token');
    }
    if (stored.expires_at.getTime() <= Date.now()) {
      throw unauthorized('REFRESH_EXPIRED', 'Refresh token expired');
    }

    const user = await this.findStaffById(stored.user_id);
    if (!user || !user.isActive) {
      throw unauthorized('INVALID_REFRESH', 'Invalid refresh token');
    }

    await this.prisma.staff_refresh_token.update({
      where: { id: stored.id },
      data: { revoked_at: new Date() },
    });

    return this.issueTokens(user);
  }

  async logout(refreshToken?: string): Promise<void> {
    if (!refreshToken) return;
    const tokenHash = sha256Hex(refreshToken);
    await this.prisma.staff_refresh_token.updateMany({
      where: { token_hash: tokenHash, revoked_at: null },
      data: { revoked_at: new Date() },
    });
  }

  async me(userId: string): Promise<AuthenticatedUserDto> {
    const user = await this.findStaffById(userId);
    if (!user) {
      throw unauthorized('UNAUTHORIZED', 'Not authenticated');
    }
    return this.toUserDto(user);
  }

  private async issueTokens(user: StaffWithRoles): Promise<AuthTokensResponse> {
    const role = user.user_role[0]?.role.roleKey ?? 'cashier';
    const permissions = await this.permissionsForRoles(
      user.user_role.map((ur) => ur.role.id),
    );
    const payload: JwtPayload = {
      sub: user.id,
      email: user.email,
      role,
      rid: user.restaurantId,
    };

    const expiresAt = new Date(Date.now() + this.accessTtlMs);
    const accessToken = await this.jwt.signAsync(payload, {
      expiresIn: Math.floor(this.accessTtlMs / 1000),
      algorithm: 'HS256',
    });

    const refreshToken = generateOpaqueToken(48);
    const refreshExpires = new Date(Date.now() + this.refreshTtlMs);
    await this.prisma.staff_refresh_token.create({
      data: {
        id: uuidv4(),
        user_id: user.id,
        restaurant_id: user.restaurantId,
        token_hash: sha256Hex(refreshToken),
        expires_at: refreshExpires,
      },
    });

    return {
      user: await this.toUserDto(user, permissions),
      accessToken,
      refreshToken,
      expiresAt: expiresAt.toISOString(),
    };
  }

  private async toUserDto(
    user: StaffWithRoles,
    permissions?: string[],
  ): Promise<AuthenticatedUserDto> {
    const resolved =
      permissions ??
      (await this.permissionsForRoles(user.user_role.map((ur) => ur.role.id)));
    return {
      id: user.id,
      username: usernameFromEmail(user.email),
      fullName: user.displayName,
      role: user.user_role[0]?.role.roleKey ?? 'cashier',
      permissions: resolved,
      active: user.isActive,
      createdAt: user.createdAt.toISOString(),
    };
  }

  /** Loads permission_key values granted to the given role ids (union). */
  private async permissionsForRoles(roleIds: string[]): Promise<string[]> {
    if (roleIds.length === 0) return [];
    const rows = await this.prisma.role_permission.findMany({
      where: { role_id: { in: roleIds } },
      include: { permission: true },
    });
    const keys = rows.map((r) => r.permission.permissionKey);
    return [...new Set(keys)].sort();
  }

  private async findStaffByEmail(email: string): Promise<StaffWithRoles | null> {
    return this.prisma.staffUser.findFirst({
      where: { email },
      include: { user_role: { include: { role: true } } },
    });
  }

  private async findStaffById(id: string): Promise<StaffWithRoles | null> {
    return this.prisma.staffUser.findUnique({
      where: { id },
      include: { user_role: { include: { role: true } } },
    });
  }

  private async verifyPassword(
    passwordHash: string,
    password: string,
  ): Promise<boolean> {
    if (passwordHash.startsWith('$REPLACE_WITH_ARGON2_')) {
      return false;
    }
    try {
      return await argon2.verify(passwordHash, password);
    } catch {
      return false;
    }
  }
}
