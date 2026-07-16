"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.VnpayService = void 0;
const common_1 = require("@nestjs/common");
const crypto = __importStar(require("crypto"));
let VnpayService = class VnpayService {
    config = {
        tmnCode: process.env.VNP_TMN_CODE || 'QGJD615N',
        hashSecret: process.env.VNP_HASH_SECRET || 'ZXYUKIVMFRWYHIKIVJXYBXXBOSWPRDKE',
        url: process.env.VNP_URL || 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
        returnUrl: process.env.VNP_RETURN_URL || 'http://localhost/vnpay-return',
    };
    createPaymentUrl(ipAddr, amountMinor, txnRef, orderInfo) {
        const date = new Date();
        const createDate = this.formatDate(date);
        const vnp_Params = {
            vnp_Version: '2.1.0',
            vnp_Command: 'pay',
            vnp_TmnCode: this.config.tmnCode,
            vnp_Locale: 'vn',
            vnp_CurrCode: 'VND',
            vnp_TxnRef: txnRef,
            vnp_OrderInfo: orderInfo,
            vnp_OrderType: 'other',
            vnp_Amount: Number(amountMinor) * 100,
            vnp_ReturnUrl: this.config.returnUrl,
            vnp_IpAddr: ipAddr,
            vnp_CreateDate: createDate,
        };
        const sortedParams = this.sortObject(vnp_Params);
        const signData = new URLSearchParams(sortedParams).toString();
        const hmac = crypto.createHmac('sha512', this.config.hashSecret);
        const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex');
        sortedParams['vnp_SecureHash'] = signed;
        const finalParams = new URLSearchParams(sortedParams).toString();
        return `${this.config.url}?${finalParams}`;
    }
    verifyIpn(query) {
        let vnp_Params = { ...query };
        const secureHash = vnp_Params['vnp_SecureHash'];
        delete vnp_Params['vnp_SecureHash'];
        delete vnp_Params['vnp_SecureHashType'];
        vnp_Params = this.sortObject(vnp_Params);
        const signData = new URLSearchParams(vnp_Params).toString();
        const hmac = crypto.createHmac('sha512', this.config.hashSecret);
        const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex');
        const isValid = secureHash === signed;
        const isSuccess = vnp_Params['vnp_ResponseCode'] === '00';
        const txnRef = vnp_Params['vnp_TxnRef'];
        const amountMinor = BigInt(Math.floor(Number(vnp_Params['vnp_Amount']) / 100));
        return { isValid, isSuccess, txnRef, amountMinor };
    }
    sortObject(obj) {
        const sorted = {};
        const keys = Object.keys(obj).sort();
        for (const key of keys) {
            if (obj[key] !== '' && obj[key] !== undefined && obj[key] !== null) {
                sorted[key] = String(obj[key]);
            }
        }
        return sorted;
    }
    formatDate(date) {
        const pad = (n) => (n < 10 ? `0${n}` : n);
        return `${date.getFullYear()}${pad(date.getMonth() + 1)}${pad(date.getDate())}${pad(date.getHours())}${pad(date.getMinutes())}${pad(date.getSeconds())}`;
    }
};
exports.VnpayService = VnpayService;
exports.VnpayService = VnpayService = __decorate([
    (0, common_1.Injectable)()
], VnpayService);
//# sourceMappingURL=vnpay.service.js.map