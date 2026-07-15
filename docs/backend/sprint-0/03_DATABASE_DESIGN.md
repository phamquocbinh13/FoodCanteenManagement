# ROMS Database Design Report (MySQL 8.0)

> **Priority deliverable** — Architecture Sprint 0  
> **Engine:** MySQL 8.0 Community Edition  
> **Source mapping:** Flutter `lib/domain/entities/*` + `DATA_MODEL.md`  
> **Money storage:** `BIGINT` minor units + `CHAR(3)` currency (matches Flutter `Money.amountMinor`)

---

## 1. Design principles

1. **Flutter entity → table** with snake_case columns.  
2. **Server authority** for all invariants (one active session/table, batch XOR parent, no split bill).  
3. **Snapshot denormalization** on batch lines (name/price/kitchen notes) — intentional, matches DATA_MODEL.  
4. **Append-only** where required: batches (no update except item status), payments, audit, timeline, histories.  
5. **Soft delete** via `is_active` only for catalog/floor entities that must remain historically referenced.  
6. **No unused tables** — every table maps to a Flutter entity or a proven engine need (`restaurant_daily_counter`, `staff_refresh_token`, `domain_outbox`).

---

## 2. Entity → table map

| Flutter entity | Table | Notes |
|----------------|-------|-------|
| Restaurant | `restaurant` | Tenant root |
| RestaurantSettings | `restaurant_settings` | 1:1 |
| RestaurantTable | `restaurant_table` | Floor |
| TableQrTokenRecord | `table_qr_token` | Stable QR |
| DineInSession | `dine_in_session` | Heart of dine-in; includes running `paymentSummary` minor-unit columns |
| SessionPaymentSummary | *(columns on `dine_in_session`)* | `payment_*_minor` — not a separate table; matches Flutter embedded summary |
| SessionAuthToken | `session_auth_token` | Hashed bearer |
| SessionDevice | `session_device` | Multi-phone |
| SessionCart | `session_cart` | version concurrency |
| SessionCartItem | `session_cart_item` | Draft lines |
| SessionTimelineEvent | `session_timeline_event` | Append-only |
| StaffRequest | `staff_request` | Request queue |
| KitchenBatch | `kitchen_batch` | Immutable header |
| BatchItem | `batch_item` | Status mutable only |
| BatchItemCustomization | `batch_item_customization` | Immutable |
| BatchItemStatusHistory | `batch_item_status_history` | Append-only |
| MenuCategory | `menu_category` | |
| MenuItem | `menu_item` | |
| CustomizationGroup | `customization_group` | |
| CustomizationOption | `customization_option` | |
| MenuItemAvailabilityHistory | `menu_item_availability_history` | |
| RomsOrder | `roms_order` | Takeaway/delivery only |
| OrderLine | `order_line` | Draft |
| DeliveryDetail | `delivery_detail` | 1:1 delivery |
| OrderPayment | `order_payment` | |
| SessionPayment | `session_payment` | 1:1 session |
| SessionBillLine | `session_bill_line` | |
| StaffUser | `staff_user` | |
| Role | `role` | Seed catalog |
| UserRole | `user_role` | M:N |
| AuditLog | `audit_log` | |
| IdempotencyRecord | `idempotency_record` | |
| AuthSession (staff) | `staff_refresh_token` | Refresh persistence |
| *(engine)* | `restaurant_daily_counter` | session/order numbers |
| *(realtime)* | `domain_outbox` | Event relay |
| SessionEngineSnapshot | *(projection)* | API DTO only |
| AuthenticatedUser | *(projection)* | API DTO only |

---

## 3. Critical integrity rules

### 3.1 One active session per table (MySQL)

PostgreSQL partial unique index is **not** available. Use:

```text
dine_in_session.active_table_guard CHAR(36) NULL
UNIQUE(active_table_guard)
```

- When status ∈ {`open`,`payment_pending`}: `active_table_guard = table_id`  
- When `closed`: `active_table_guard = NULL` (MySQL allows many NULLs in UNIQUE)

### 3.2 Batch parent XOR

```sql
CHECK (
  (session_id IS NOT NULL AND order_id IS NULL) OR
  (session_id IS NULL AND order_id IS NOT NULL)
)
```

### 3.3 No split bill

`UNIQUE(session_id)` on `session_payment`.

### 3.3b Running payment summary on session

Flutter `DineInSession.paymentSummary` (`SessionPaymentSummary`) is updated on batch confirm via `SessionEngineRepository.update`. Persist as minor-unit columns on `dine_in_session`:

| Column | Flutter field |
|--------|----------------|
| `payment_subtotal_minor` | `subtotalMinor` |
| `payment_discount_minor` | `discountMinor` |
| `payment_tax_minor` | `taxMinor` |
| `payment_service_charge_minor` | `serviceChargeMinor` |
| `payment_total_minor` | `totalMinor` |

Terminal immutable bill remains on `session_payment` + `session_bill_line`.

### 3.3c Force-close reason integrity

On `session_payment`:

- `force_close_reason IN ('customer_left','dispute','system_error','other')` or NULL  
- Required when `close_type = force_closed`; must be NULL when `close_type = payment`

### 3.4 Kitchen isolation

Provide view `v_kitchen_batch_queue` joining batch → items → table label, **excluding** payment tables. Kitchen API must query this view (or equivalent repository query).

### 3.5 Soft delete

| Table | Strategy |
|-------|----------|
| restaurant, restaurant_table, menu_*, staff_user, table_qr_token | `is_active` |
| sessions, batches, payments, audit | **never** hard-delete; closed/immutable |

---

## 4. Index strategy (high traffic)

| Query | Index |
|-------|-------|
| Kitchen queue | `(restaurant_id, confirmed_at)` on `kitchen_batch` |
| Pending requests | `(restaurant_id, status, requested_at)` on `staff_request` |
| Table floor | `(restaurant_id, status)` on `restaurant_table` |
| Session token lookup | `UNIQUE(token_hash)` on `session_auth_token` |
| QR join | `UNIQUE(token_hash)` on `table_qr_token` |
| Active sessions restore | `(restaurant_id, status)` on `dine_in_session` |
| Cart by session | `UNIQUE(session_id)` on `session_cart` |
| Idempotency | `UNIQUE(restaurant_id, idempotency_key)` |

---

## 5. Cascade behavior

| Parent | Child | On delete |
|--------|-------|-----------|
| restaurant | most tenant children | **RESTRICT** (never cascade-delete tenant history) |
| dine_in_session | cart, timeline, requests, tokens | RESTRICT / app-level close |
| kitchen_batch | batch_item | RESTRICT |
| batch_item | customizations, status history | CASCADE only for customization rows if batch item removed (should not remove) |
| menu_item | groups/options | RESTRICT if referenced by batch snapshots |

**Policy:** Prefer RESTRICT. Historical kitchen/payment data must survive menu edits.

---

## 6. Multi-tenant & future inventory

- Every operational table includes `restaurant_id` where listed in DATA_MODEL.  
- Future inventory attaches via nullable FKs / new tables (`inventory_item`, `recipe`) without altering batch immutability.  
- Delivery/takeaway tables included now so Order pipeline is ready without schema rewrite.

---

## 7. Seed data (demo parity)

Matches Flutter demo constants:

- Restaurant `demo-restaurant`  
- Tables T1–T10 (Phase 1 café)  
- Roles: admin, manager, cashier, kitchen, shipper  
- Demo staff users (password hashes placeholder — replace at deploy)  
- Sample menu categories/items (minimal)  
- QR tokens for each table  

---

## 8. Validation checklist

| Check | Status |
|-------|--------|
| Every major Flutter entity mapped | ✅ |
| SessionEngine + cart + batch + request persistence | ✅ |
| Session running `paymentSummary` minors | ✅ |
| Force-close reason CHECK + required-when-forced | ✅ |
| Payment / bill lines present | ✅ |
| Order/delivery ready | ✅ |
| Audit + idempotency | ✅ |
| Kitchen never requires payment join | ✅ view |
| No duplicate conceptual tables | ✅ |
| MySQL 8.0 CE compatible | ✅ |

---

*See `04_schema_mysql8.sql` for the executable script.*
