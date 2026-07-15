import { dine_in_session, session_auth_token } from '@prisma/client';
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
export declare function mapSessionSnapshot(params: {
    session: dine_in_session;
    activeToken: session_auth_token | null;
    tableLabel: string;
    batchIds?: string[];
    requestIds?: string[];
}): SessionSnapshot;
