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

/** Local-part of email, or the alias as-is when no `@`. */
export function usernameFromEmail(email: string): string {
  const at = email.indexOf('@');
  return at === -1 ? email : email.slice(0, at);
}

/** Map short aliases (cashier) → demo emails (cashier@demo.local). */
export function resolveLoginEmail(username: string): string {
  const trimmed = username.trim().toLowerCase();
  if (trimmed.includes('@')) return trimmed;
  const aliases: Record<string, string> = {
    admin: 'admin@demo.local',
    manager: 'manager@demo.local',
    cashier: 'cashier@demo.local',
    kitchen: 'kitchen@demo.local',
    shipper: 'shipper@demo.local',
  };
  return aliases[trimmed] ?? trimmed;
}
