import {
  applyBps,
  computeBillMinors,
  mapSessionBillLine,
  mapSessionPayment,
} from './payments.mapper';
import type { session_bill_line, session_payment } from '@prisma/client';

describe('payments.mapper', () => {
  it('applyBps matches Flutter Percentage.applyTo rounding', () => {
    expect(Number(applyBps(10000n, 1000))).toBe(1000); // 10%
    expect(Number(applyBps(333n, 1000))).toBe(33); // round half up
    expect(Number(applyBps(0n, 1000))).toBe(0);
    expect(Number(applyBps(5000n, 0))).toBe(0);
  });

  it('computeBillMinors sums lines and applies tax/service bps', () => {
    const bill = computeBillMinors({
      lineTotals: [10000n, 5000n],
      taxRateBps: 1000, // 10%
      serviceChargeBps: 500, // 5%
    });
    expect(Number(bill.subtotalMinor)).toBe(15000);
    expect(Number(bill.taxAmountMinor)).toBe(1500);
    expect(Number(bill.serviceChargeMinor)).toBe(750);
    expect(Number(bill.totalAmountMinor)).toBe(17250);
  });

  it('mapSessionPayment emits camelCase Money shapes', () => {
    const now = new Date('2026-07-15T10:00:00.000Z');
    const row = {
      id: 'pay-1',
      session_id: 'sess-1',
      payment_method: 'cash',
      close_type: 'payment',
      force_close_reason: null,
      force_close_note: null,
      subtotal_minor: 10000n,
      tax_amount_minor: 1000n,
      service_charge_minor: 500n,
      total_amount_minor: 11500n,
      currency_code: 'VND',
      closed_by_user_id: 'user-1',
      paid_at: now,
      created_at: now,
    } as session_payment;

    const dto = mapSessionPayment(row);
    expect(dto.sessionId).toBe('sess-1');
    expect(dto.subtotal).toEqual({ amountMinor: 10000, currencyCode: 'VND' });
    expect(dto.taxAmount.amountMinor).toBe(1000);
    expect(dto.serviceChargeAmount.amountMinor).toBe(500);
    expect(dto.totalAmount.amountMinor).toBe(11500);
    expect(dto.paidAt).toBe(now.toISOString());
  });

  it('mapSessionBillLine emits camelCase Money shapes', () => {
    const now = new Date('2026-07-15T10:00:00.000Z');
    const row = {
      id: 'line-1',
      session_payment_id: 'pay-1',
      batch_item_id: 'bi-1',
      description: 'Cơm gà',
      quantity: 2,
      unit_price_minor: 5000n,
      line_total_minor: 10000n,
      currency_code: 'VND',
      created_at: now,
    } as session_bill_line;

    const dto = mapSessionBillLine(row);
    expect(dto.sessionPaymentId).toBe('pay-1');
    expect(dto.batchItemId).toBe('bi-1');
    expect(dto.unitPrice).toEqual({ amountMinor: 5000, currencyCode: 'VND' });
    expect(dto.lineTotal.amountMinor).toBe(10000);
  });
});
