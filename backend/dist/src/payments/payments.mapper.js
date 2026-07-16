"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapSessionPayment = mapSessionPayment;
exports.mapSessionBillLine = mapSessionBillLine;
exports.applyBps = applyBps;
exports.computeBillMinors = computeBillMinors;
exports.toNum = toNum;
const customization_pricing_1 = require("../common/menu/customization-pricing");
const big_int_1 = require("../common/utils/big-int");
function mapSessionPayment(row) {
    const currency = row.currency_code;
    return {
        id: row.id,
        sessionId: row.session_id,
        paymentMethod: row.payment_method,
        closeType: row.close_type,
        forceCloseReason: row.force_close_reason,
        forceCloseNote: row.force_close_note,
        subtotal: (0, customization_pricing_1.mapMoney)(row.subtotal_minor, currency),
        taxAmount: (0, customization_pricing_1.mapMoney)(row.tax_amount_minor, currency),
        serviceChargeAmount: (0, customization_pricing_1.mapMoney)(row.service_charge_minor, currency),
        totalAmount: (0, customization_pricing_1.mapMoney)(row.total_amount_minor, currency),
        closedByUserId: row.closed_by_user_id,
        paidAt: row.paid_at.toISOString(),
        createdAt: row.created_at.toISOString(),
        paymentStatus: row.payment_status,
        paymentProvider: row.payment_provider,
        providerTransactionId: row.provider_transaction_id,
    };
}
function mapSessionBillLine(row) {
    const currency = row.currency_code;
    return {
        id: row.id,
        sessionPaymentId: row.session_payment_id,
        batchItemId: row.batch_item_id,
        description: row.description,
        quantity: row.quantity,
        unitPrice: (0, customization_pricing_1.mapMoney)(row.unit_price_minor, currency),
        lineTotal: (0, customization_pricing_1.mapMoney)(row.line_total_minor, currency),
        createdAt: row.created_at.toISOString(),
    };
}
function applyBps(amountMinor, bps) {
    if (bps <= 0 || amountMinor === 0n)
        return 0n;
    const product = amountMinor * BigInt(bps);
    const half = 5000n;
    return (product + half) / 10000n;
}
function computeBillMinors(params) {
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
function toNum(v) {
    return (0, big_int_1.toNumber)(v);
}
//# sourceMappingURL=payments.mapper.js.map