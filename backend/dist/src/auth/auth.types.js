"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.usernameFromEmail = usernameFromEmail;
exports.resolveLoginEmail = resolveLoginEmail;
function usernameFromEmail(email) {
    const at = email.indexOf('@');
    return at === -1 ? email : email.slice(0, at);
}
function resolveLoginEmail(username) {
    const trimmed = username.trim().toLowerCase();
    if (trimmed.includes('@'))
        return trimmed;
    const aliases = {
        admin: 'admin@demo.local',
        manager: 'manager@demo.local',
        cashier: 'cashier@demo.local',
        kitchen: 'kitchen@demo.local',
        shipper: 'shipper@demo.local',
    };
    return aliases[trimmed] ?? trimmed;
}
//# sourceMappingURL=auth.types.js.map