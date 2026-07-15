"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.toNumber = toNumber;
function toNumber(value) {
    if (value == null)
        return 0;
    if (typeof value === 'bigint')
        return Number(value);
    return value;
}
//# sourceMappingURL=big-int.js.map