/** Convert Prisma BigInt (or number) to a JSON-safe number. */
export function toNumber(value: bigint | number | null | undefined): number {
  if (value == null) return 0;
  if (typeof value === 'bigint') return Number(value);
  return value;
}
