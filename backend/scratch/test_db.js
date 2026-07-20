const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const sessions = await prisma.dine_in_session.findMany({
    where: { payment_status: 'paid' }
  });

  let sessionTotal = 0n;
  for (const session of sessions) {
    sessionTotal += BigInt(session.payment_total_minor);
  }

  const payments = await prisma.session_payment.findMany({
    where: { payment_status: 'paid' }
  });

  let paymentTotal = 0n;
  for (const payment of payments) {
    paymentTotal += BigInt(payment.total_amount_minor);
  }

  console.log('Session Total:', sessionTotal.toString());
  console.log('Payment Total:', paymentTotal.toString());

  console.log('--- MISSING PAYMENTS ---');
  for (const session of sessions) {
    const sessionPayments = payments.filter(p => p.session_id === session.id);
    const sum = sessionPayments.reduce((acc, p) => acc + BigInt(p.total_amount_minor), 0n);
    if (sum !== BigInt(session.payment_total_minor)) {
      console.log(`Mismatch in session ${session.id}: Session has ${session.payment_total_minor}, but payments sum to ${sum}`);
    }
  }
}

main().then(() => prisma.$disconnect());
