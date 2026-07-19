const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const sessions = await prisma.dine_in_session.findMany({
    select: {
      id: true,
      restaurant_id: true,
      payment_status: true,
      payment_total_minor: true
    }
  });
  console.log(sessions);
}

main().catch(console.error).finally(() => prisma.$disconnect());
