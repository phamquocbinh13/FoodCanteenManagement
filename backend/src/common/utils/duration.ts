/**
 * Parse simple TTL strings like `15m`, `7d`, `3600s` into milliseconds.
 * Falls back to defaultMs when the value is missing or invalid.
 */
export function parseDurationMs(
  value: string | undefined,
  defaultMs: number,
): number {
  if (!value) return defaultMs;
  const match = /^(\d+)(ms|s|m|h|d)$/i.exec(value.trim());
  if (!match) return defaultMs;
  const amount = Number(match[1]);
  const unit = match[2].toLowerCase();
  switch (unit) {
    case 'ms':
      return amount;
    case 's':
      return amount * 1000;
    case 'm':
      return amount * 60_000;
    case 'h':
      return amount * 3_600_000;
    case 'd':
      return amount * 86_400_000;
    default:
      return defaultMs;
  }
}
