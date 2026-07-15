import { session_bill_line, session_payment } from '@prisma/client';
import { type MoneyDto } from '../common/menu/customization-pricing';
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
export declare function mapSessionPayment(row: session_payment): SessionPaymentDto;
export declare function mapSessionBillLine(row: session_bill_line): SessionBillLineDto;
export declare function applyBps(amountMinor: bigint, bps: number): bigint;
export declare function computeBillMinors(params: {
    lineTotals: bigint[];
    taxRateBps: number;
    serviceChargeBps: number;
}): {
    subtotalMinor: bigint;
    taxAmountMinor: bigint;
    serviceChargeMinor: bigint;
    totalAmountMinor: bigint;
};
export declare function toNum(v: bigint | number): number;
