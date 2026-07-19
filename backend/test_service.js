const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function getKpis(restaurantId) {
  const sessions = await prisma.dine_in_session.aggregate({
    _count: { id: true },
    _sum: { payment_total_minor: true },
    where: { restaurant_id: restaurantId, payment_status: 'paid' }
  });

  const totalSessions = sessions._count.id || 0;
  const totalRevenue = Number(sessions._sum.payment_total_minor || 0);
  const averageOrderValueMinor = totalSessions > 0 ? Math.floor(totalRevenue / totalSessions) : 0;

  const payments = await prisma.session_payment.groupBy({
    by: ['payment_method'],
    _sum: { total_amount_minor: true },
    where: { dine_in_session: { restaurant_id: restaurantId } }
  });

  const paymentMethods = payments.map(p => ({
    method: p.payment_method,
    totalMinor: Number(p._sum.total_amount_minor || 0)
  }));

  return {
    averageOrderValueMinor,
    totalSessions,
    totalRevenueMinor: totalRevenue,
    paymentMethods
  };
}

getKpis('demo-restaurant').then(console.log).catch(console.error).finally(() => prisma.$disconnect());
