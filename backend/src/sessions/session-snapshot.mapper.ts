import { dine_in_session, session_auth_token } from '@prisma/client';
import { toNumber } from '../common/utils/big-int';

export type SessionSnapshot = {
  session: {
    id: string;
    restaurantId: string;
    tableId: string;
    sessionNumber: number;
    displayNumber: string;
    status: string;
    openedVia: string;
    openedByUserId: string | null;
    closedByUserId: string | null;
    paymentSoftLock: boolean;
    currentBatchNumber: number;
    paymentStatus: string;
    paymentSummary: {
      subtotalMinor: number;
      discountMinor: number;
      taxMinor: number;
      serviceChargeMinor: number;
      totalMinor: number;
    };
    openedAt: string;
    closedAt: string | null;
    createdAt: string;
    updatedAt: string;
  };
  activeToken: {
    id: string;
    sessionId: string;
    tokenHash: string;
    expiresAt: string;
    revokedAt: string | null;
    createdAt: string;
  } | null;
  tableLabel: string;
  batchIds: string[];
  requestIds: string[];
};

export function mapSessionSnapshot(params: {
  session: dine_in_session;
  activeToken: session_auth_token | null;
  tableLabel: string;
  batchIds?: string[];
  requestIds?: string[];
}): SessionSnapshot {
  const { session, activeToken, tableLabel } = params;
  return {
    session: {
      id: session.id,
      restaurantId: session.restaurant_id,
      tableId: session.table_id,
      sessionNumber: toNumber(session.session_number),
      displayNumber: session.display_number,
      status: session.status,
      openedVia: session.opened_via,
      openedByUserId: session.opened_by_user_id,
      closedByUserId: session.closed_by_user_id,
      paymentSoftLock: session.payment_soft_lock,
      currentBatchNumber: session.current_batch_number,
      paymentStatus: session.payment_status,
      paymentSummary: {
        subtotalMinor: toNumber(session.payment_subtotal_minor),
        discountMinor: toNumber(session.payment_discount_minor),
        taxMinor: toNumber(session.payment_tax_minor),
        serviceChargeMinor: toNumber(session.payment_service_charge_minor),
        totalMinor: toNumber(session.payment_total_minor),
      },
      openedAt: session.opened_at.toISOString(),
      closedAt: session.closed_at?.toISOString() ?? null,
      createdAt: session.created_at.toISOString(),
      updatedAt: session.updated_at.toISOString(),
    },
    activeToken: activeToken
      ? {
          id: activeToken.id,
          sessionId: activeToken.session_id,
          tokenHash: activeToken.token_hash,
          expiresAt: activeToken.expires_at.toISOString(),
          revokedAt: activeToken.revoked_at?.toISOString() ?? null,
          createdAt: activeToken.created_at.toISOString(),
        }
      : null,
    tableLabel,
    batchIds: params.batchIds ?? [],
    requestIds: params.requestIds ?? [],
  };
}
