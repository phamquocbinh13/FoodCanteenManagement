export type VnpayConfig = {
    tmnCode: string;
    hashSecret: string;
    url: string;
    returnUrl: string;
};
export declare class VnpayService {
    private config;
    createPaymentUrl(ipAddr: string, amountMinor: bigint, txnRef: string, orderInfo: string, customReturnUrl?: string): string;
    verifyIpn(query: Record<string, any>): {
        isValid: boolean;
        isSuccess: boolean;
        txnRef: string;
        amountMinor: bigint;
    };
    private sortObject;
    private formatDate;
}
