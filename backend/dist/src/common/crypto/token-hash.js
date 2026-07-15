"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sha256Hex = sha256Hex;
exports.generateOpaqueToken = generateOpaqueToken;
const crypto_1 = require("crypto");
function sha256Hex(value) {
    return (0, crypto_1.createHash)('sha256').update(value, 'utf8').digest('hex');
}
function generateOpaqueToken(bytes = 32) {
    return (0, crypto_1.randomBytes)(bytes).toString('hex');
}
//# sourceMappingURL=token-hash.js.map