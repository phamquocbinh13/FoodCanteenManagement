"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const crypto_1 = require("crypto");
const permission_catalog_1 = require("../src/auth/rbac/permission-catalog");
const prisma = new client_1.PrismaClient();
function stableId(prefix, key) {
    const hex = (0, crypto_1.createHash)('sha256').update(`${prefix}:${key}`).digest('hex');
    return [
        hex.slice(0, 8),
        hex.slice(8, 12),
        hex.slice(12, 16),
        hex.slice(16, 20),
        hex.slice(20, 32),
    ].join('-');
}
async function main() {
    for (const key of permission_catalog_1.PERMISSION_KEYS) {
        const id = stableId('perm', key);
        await prisma.permission.upsert({
            where: { permissionKey: key },
            create: {
                id,
                permissionKey: key,
                name: permission_catalog_1.PERMISSION_LABELS[key],
            },
            update: { name: permission_catalog_1.PERMISSION_LABELS[key] },
        });
    }
    const permissions = await prisma.permission.findMany();
    const permissionIdByKey = new Map(permissions.map((p) => [p.permissionKey, p.id]));
    const roles = await prisma.role.findMany();
    for (const role of roles) {
        const grants = permission_catalog_1.ROLE_PERMISSION_GRANTS[role.roleKey] ?? [];
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
    console.log(`RBAC seeded: ${permissions.length} permissions, ${roles.length} roles granted.`);
}
main()
    .catch((e) => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=seed-rbac.js.map