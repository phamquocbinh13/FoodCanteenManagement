/**
 * Seeds argon2 password hashes for demo staff users.
 *
 * Usage: npm run seed:passwords
 */
import { config as loadEnv } from 'dotenv';
import { resolve } from 'path';
import * as argon2 from 'argon2';
import { PrismaClient } from '@prisma/client';

loadEnv({ path: resolve(__dirname, '../.env') });

const DEMO_PASSWORDS: Array<{ email: string; password: string }> = [
  { email: 'admin@demo.local', password: 'admin123' },
  { email: 'manager@demo.local', password: 'manager123' },
  { email: 'cashier@demo.local', password: 'cashier123' },
  { email: 'kitchen@demo.local', password: 'kitchen123' },
  { email: 'shipper@demo.local', password: 'shipper123' },
];

async function main(): Promise<void> {
  const prisma = new PrismaClient();
  try {
    for (const row of DEMO_PASSWORDS) {
      const hash = await argon2.hash(row.password, { type: argon2.argon2id });
      const result = await prisma.staffUser.updateMany({
        where: { email: row.email },
        data: { passwordHash: hash },
      });
      // eslint-disable-next-line no-console
      console.log(
        result.count > 0
          ? `Updated ${row.email}`
          : `SKIP (not found): ${row.email}`,
      );
    }
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((err) => {
  // eslint-disable-next-line no-console
  console.error(err);
  process.exit(1);
});
