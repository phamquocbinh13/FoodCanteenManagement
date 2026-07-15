export declare class CreateSessionDto {
    tableId: string;
    openedVia: 'qr_scan' | 'cashier_manual';
    displayNumber?: string;
    sessionSequence?: number;
    sessionToken?: string;
    tokenExpiresAt?: string;
}
export declare class JoinSessionDto {
    sessionToken: string;
    deviceId?: string;
}
export declare class CloseSessionDto {
    closedByUserId?: string;
}
export declare class TransferSessionDto {
    targetTableId: string;
}
export declare class PaymentSummaryDto {
    subtotalMinor?: number;
    discountMinor?: number;
    taxMinor?: number;
    serviceChargeMinor?: number;
    totalMinor?: number;
}
export declare class UpdateSessionDto {
    status?: string;
    paymentStatus?: string;
    currentBatchNumber?: number;
    paymentSoftLock?: boolean;
    paymentSummary?: PaymentSummaryDto;
}
export declare class AppendTimelineDto {
    id?: string;
    eventType: string;
    payloadJson?: Record<string, unknown>;
    actorType?: string;
    actorId?: string;
    occurredAt?: string;
}
