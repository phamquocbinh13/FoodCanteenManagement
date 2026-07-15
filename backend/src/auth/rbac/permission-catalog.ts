/**
 * Canonical permission keys — must match Flutter `AppPermission.name`.
 * Role grants are persisted in MySQL (`permission` + `role_permission`).
 */
export const PERMISSION_KEYS = [
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
] as const;

export type PermissionKey = (typeof PERMISSION_KEYS)[number];

export const PERMISSION_LABELS: Record<PermissionKey, string> = {
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

/** Default grants by role_key — applied by seed:rbac into role_permission. */
export const ROLE_PERMISSION_GRANTS: Record<string, readonly PermissionKey[]> = {
  admin: PERMISSION_KEYS,
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
