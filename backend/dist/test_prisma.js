"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const users = await prisma.staffUser.findMany();
    console.log(`Found ${users.length} users in total.`);
    for (const u of users) {
        console.log(`User: ${u.email} - Restaurant: ${u.restaurantId}`);
    }
}
main().finally(() => prisma.$disconnect());
//# sourceMappingURL=test_prisma.js.map