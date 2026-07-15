/**
 * Ensures permission + role_permission rows match the RBAC catalog.
 *
 * Usage: npm run seed:rbac
 */
import { PrismaClient } from '@prisma/client';
import { createHash } from 'crypto';
import {
  PERMISSION_KEYS,
  PERMISSION_LABELS,
  ROLE_PERMISSION_GRANTS,
} from '../src/auth/rbac/permission-catalog';

const prisma = new PrismaClient();

function stableId(prefix: string, key: string): string {
  const hex = createHash('sha256').update(`${prefix}:${key}`).digest('hex');
  return [
    hex.slice(0, 8),
    hex.slice(8, 12),
    hex.slice(12, 16),
    hex.slice(16, 20),
    hex.slice(20, 32),
  ].join('-');
}

async function main() {
  for (const key of PERMISSION_KEYS) {
    const id = stableId('perm', key);
    await prisma.permission.upsert({
      where: { permissionKey: key },
      create: {
        id,
        permissionKey: key,
        name: PERMISSION_LABELS[key],
      },
      update: { name: PERMISSION_LABELS[key] },
    });
  }

  const permissions = await prisma.permission.findMany();
  const permissionIdByKey = new Map(
    permissions.map((p) => [p.permissionKey, p.id]),
  );

  const roles = await prisma.role.findMany();
  for (const role of roles) {
    const grants = ROLE_PERMISSION_GRANTS[role.roleKey] ?? [];
    for (const key of grants) {
      const permissionId = permissionIdByKey.get(key);
      if (!permissionId) {
        throw new Error(`Missing permission row for ${key}`);
      }
      const id = stableId('rp', `${role.roleKey}:${key}`);
      await prisma.role_permission.upsert({
        where: {
          role_id_permission_id: {
            role_id: role.id,
            permission_id: permissionId,
          },
        },
        create: {
          id,
          role_id: role.id,
          permission_id: permissionId,
        },
        update: {},
      });
    }
  }

  console.log(
    `RBAC seeded: ${permissions.length} permissions, ${roles.length} roles granted.`,
  );
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
