import { session_bill_line, session_payment } from '@prisma/client';
import { mapMoney, type MoneyDto } from '../common/menu/customization-pricing';
import { toNumber } from '../common/utils/big-int';

/** CamelCase API shape; Flutter converts via camelCaseKeysToSnake → SessionPayment. */
export type SessionPaymentDto = {
  id: string;
  sessionId: string;
  paymentMethod: string;
  closeType: string;
  forceCloseReason: string | null;
  forceCloseNote: string | null;
  subtotal: MoneyDto;
  taxAmount: MoneyDto;
  serviceChargeAmount: MoneyDto;
  totalAmount: MoneyDto;
  closedByUserId: string;
  paidAt: string;
  createdAt: string;
};

/** CamelCase API shape; Flutter converts via camelCaseKeysToSnake → SessionBillLine. */
export type SessionBillLineDto = {
  id: string;
  sessionPaymentId: string;
  batchItemId: string;
  description: string;
  quantity: number;
  unitPrice: MoneyDto;
  lineTotal: MoneyDto;
  createdAt: string;
};

export function mapSessionPayment(row: session_payment): SessionPaymentDto {
  const currency = row.currency_code;
  return {
    id: row.id,
    sessionId: row.session_id,
    paymentMethod: row.payment_method,
    closeType: row.close_type,
    forceCloseReason: row.force_close_reason,
    forceCloseNote: row.force_close_note,
    subtotal: mapMoney(row.subtotal_minor, currency),
    taxAmount: mapMoney(row.tax_amount_minor, currency),
    serviceChargeAmount: mapMoney(row.service_charge_minor, currency),
    totalAmount: mapMoney(row.total_amount_minor, currency),
    closedByUserId: row.closed_by_user_id,
    paidAt: row.paid_at.toISOString(),
    createdAt: row.created_at.toISOString(),
  };
}

export function mapSessionBillLine(row: session_bill_line): SessionBillLineDto {
  const currency = row.currency_code;
  return {
    id: row.id,
    sessionPaymentId: row.session_payment_id,
    batchItemId: row.batch_item_id,
    description: row.description,
    quantity: row.quantity,
    unitPrice: mapMoney(row.unit_price_minor, currency),
    lineTotal: mapMoney(row.line_total_minor, currency),
    createdAt: row.created_at.toISOString(),
  };
}

/** Apply bps to amount (Flutter Percentage.applyTo — round half up). */
export function applyBps(amountMinor: bigint, bps: number): bigint {
  if (bps <= 0 || amountMinor === 0n) return 0n;
  const product = amountMinor * BigInt(bps);
  const half = 5000n;
  return (product + half) / 10000n;
}

export function computeBillMinors(params: {
  lineTotals: bigint[];
  taxRateBps: number;
  serviceChargeBps: number;
}): {
  subtotalMinor: bigint;
  taxAmountMinor: bigint;
  serviceChargeMinor: bigint;
  totalAmountMinor: bigint;
} {
  let subtotalMinor = 0n;
  for (const line of params.lineTotals) {
    subtotalMinor += line;
  }
  const taxAmountMinor = applyBps(subtotalMinor, params.taxRateBps);
  const serviceChargeMinor = applyBps(subtotalMinor, params.serviceChargeBps);
  return {
    subtotalMinor,
    taxAmountMinor,
    serviceChargeMinor,
    totalAmountMinor: subtotalMinor + taxAmountMinor + serviceChargeMinor,
  };
}

export function toNum(v: bigint | number): number {
  return toNumber(v);
}
