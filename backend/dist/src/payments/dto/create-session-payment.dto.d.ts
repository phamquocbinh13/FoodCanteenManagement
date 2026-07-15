export declare const FORCE_CLOSE_REASONS: readonly ["customer_left", "dispute", "system_error", "other"];
export type ForceCloseReason = (typeof FORCE_CLOSE_REASONS)[number];
export declare class CreateSessionPaymentDto {
    paymentMethod: 'cash' | 'card' | 'bank_transfer' | 'other';
    closeType: 'payment' | 'force_closed';
    forceCloseReason?: ForceCloseReason;
    forceCloseNote?: string;
}
