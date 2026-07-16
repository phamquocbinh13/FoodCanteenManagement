const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function run() {
  await prisma.$executeRawUnsafe('ALTER TABLE session_payment DROP FOREIGN KEY fk_session_payment_session');
  console.log('Dropped FK');
}

run().catch(console.error).finally(() => prisma.$disconnect());
