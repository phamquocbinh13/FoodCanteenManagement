import { createHash, randomBytes } from 'crypto';

/** SHA-256 hex digest for session / refresh tokens (never store plaintext). */
export function sha256Hex(value: string): string {
  return createHash('sha256').update(value, 'utf8').digest('hex');
}

/** Cryptographically random URL-safe token (default 32 bytes → 64 hex chars). */
export function generateOpaqueToken(bytes = 32): string {
  return randomBytes(bytes).toString('hex');
}
