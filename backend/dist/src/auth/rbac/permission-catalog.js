"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ROLE_PERMISSION_GRANTS = exports.PERMISSION_LABELS = exports.PERMISSION_KEYS = void 0;
exports.PERMISSION_KEYS = [
    'viewKitchenQueue',
    'manageMenu',
    'closeSession',
    'forceCloseSession',
    'handleRequests',
    'manageTables',
    'claimDelivery',
    'reassignDelivery',
    'viewAuditLog',
    'manageStaff',
];
exports.PERMISSION_LABELS = {
    viewKitchenQueue: 'View kitchen queue',
    manageMenu: 'Manage menu availability',
    closeSession: 'Close session with payment',
    forceCloseSession: 'Force-close session',
    handleRequests: 'Handle staff requests',
    manageTables: 'Manage floor tables',
    claimDelivery: 'Claim delivery orders',
    reassignDelivery: 'Reassign delivery orders',
    viewAuditLog: 'View audit log',
    manageStaff: 'Manage staff',
};
exports.ROLE_PERMISSION_GRANTS = {
    admin: exports.PERMISSION_KEYS,
    manager: [
        'viewKitchenQueue',
        'manageMenu',
        'closeSession',
        'handleRequests',
        'manageTables',
        'claimDelivery',
        'reassignDelivery',
        'viewAuditLog',
    ],
    cashier: [
        'closeSession',
        'forceCloseSession',
        'handleRequests',
        'manageTables',
        'reassignDelivery',
    ],
    kitchen: ['viewKitchenQueue', 'manageMenu'],
    shipper: ['claimDelivery'],
};
//# sourceMappingURL=permission-catalog.js.map