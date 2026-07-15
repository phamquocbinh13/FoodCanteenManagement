export declare const PERMISSION_KEYS: readonly ["viewKitchenQueue", "manageMenu", "closeSession", "forceCloseSession", "handleRequests", "manageTables", "claimDelivery", "reassignDelivery", "viewAuditLog", "manageStaff"];
export type PermissionKey = (typeof PERMISSION_KEYS)[number];
export declare const PERMISSION_LABELS: Record<PermissionKey, string>;
export declare const ROLE_PERMISSION_GRANTS: Record<string, readonly PermissionKey[]>;
