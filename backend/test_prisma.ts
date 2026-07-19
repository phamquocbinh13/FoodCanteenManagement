import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const users = await prisma.staffUser.findMany();
  console.log(`Found ${users.length} users in total.`);
  for (const u of users) {
    console.log(`User: ${u.email} - Restaurant: ${u.restaurantId}`);
  }
}

main().finally(() => prisma.$disconnect());
