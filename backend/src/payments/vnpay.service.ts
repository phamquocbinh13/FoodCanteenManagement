import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

export type VnpayConfig = {
  tmnCode: string;
  hashSecret: string;
  url: string;
  returnUrl: string;
};

@Injectable()
export class VnpayService {
  private config: VnpayConfig = {
    tmnCode: process.env.VNP_TMN_CODE || 'QGJD615N', 
    hashSecret: process.env.VNP_HASH_SECRET || 'ZXYUKIVMFRWYHIKIVJXYBXXBOSWPRDKE',
    url: process.env.VNP_URL || 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    returnUrl: process.env.VNP_RETURN_URL || 'http://localhost/vnpay-return',
  };

  createPaymentUrl(
    ipAddr: string,
    amountMinor: bigint,
    txnRef: string,
    orderInfo: string,
  ): string {
    const date = new Date();
    const createDate = this.formatDate(date);

    const vnp_Params: Record<string, string | number> = {
      vnp_Version: '2.1.0',
      vnp_Command: 'pay',
      vnp_TmnCode: this.config.tmnCode,
      vnp_Locale: 'vn',
      vnp_CurrCode: 'VND',
      vnp_TxnRef: txnRef,
      vnp_OrderInfo: orderInfo,
      vnp_OrderType: 'other',
      vnp_Amount: Number(amountMinor) * 100, // VNPAY amount is multiplied by 100
      vnp_ReturnUrl: this.config.returnUrl,
      vnp_IpAddr: ipAddr,
      vnp_CreateDate: createDate,
    };

    const sortedParams = this.sortObject(vnp_Params);
    const signData = new URLSearchParams(sortedParams as any).toString();
    const hmac = crypto.createHmac('sha512', this.config.hashSecret);
    const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex');

    sortedParams['vnp_SecureHash'] = signed;
    const finalParams = new URLSearchParams(sortedParams as any).toString();

    return `${this.config.url}?${finalParams}`;
  }

  verifyIpn(query: Record<string, any>): { isValid: boolean; isSuccess: boolean; txnRef: string; amountMinor: bigint } {
    let vnp_Params = { ...query };
    const secureHash = vnp_Params['vnp_SecureHash'];

    delete vnp_Params['vnp_SecureHash'];
    delete vnp_Params['vnp_SecureHashType'];

    vnp_Params = this.sortObject(vnp_Params);
    const signData = new URLSearchParams(vnp_Params as any).toString();
    const hmac = crypto.createHmac('sha512', this.config.hashSecret);
    const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex');

    const isValid = secureHash === signed;
    const isSuccess = vnp_Params['vnp_ResponseCode'] === '00';
    const txnRef = vnp_Params['vnp_TxnRef'];
    const amountMinor = BigInt(Math.floor(Number(vnp_Params['vnp_Amount']) / 100));

    return { isValid, isSuccess, txnRef, amountMinor };
  }

  private sortObject(obj: Record<string, any>): Record<string, string> {
    const sorted: Record<string, string> = {};
    const keys = Object.keys(obj).sort();
    for (const key of keys) {
      if (obj[key] !== '' && obj[key] !== undefined && obj[key] !== null) {
        sorted[key] = String(obj[key]);
      }
    }
    return sorted;
  }

  private formatDate(date: Date): string {
    const pad = (n: number) => (n < 10 ? `0${n}` : n);
    return `${date.getFullYear()}${pad(date.getMonth() + 1)}${pad(date.getDate())}${pad(date.getHours())}${pad(date.getMinutes())}${pad(date.getSeconds())}`;
  }
}
