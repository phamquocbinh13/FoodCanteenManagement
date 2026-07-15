# ROMS API Contract Specification

> **Base URL:** `/api/v1`  
> **Format:** JSON (`application/json`)  
> **Versioning:** URI prefix `/api/v1` (breaking changes → `/api/v2`)  
> **Idempotency:** `Idempotency-Key` header required on all mutating customer/staff money & kitchen confirm endpoints  
> **Goal:** Backend APIs that map to existing domain **repository interfaces**. Flutter application-layer cleanup (Phase A5) is required before a true drop-in remote implementation — see §0 and the implementation roadmap.

Auth headers:

| Actor | Header |
|-------|--------|
| Staff | `Authorization: Bearer <accessJwt>` |
| Customer | `Authorization: Bearer <sessionToken>` or `X-Session-Token: <sessionToken>` |

Common error body:

```json
{ "error": { "code": "STRING", "message": "STRING", "details": {} } }
```

Money JSON (matches Flutter `Money`):

```json
{ "amountMinor": 1200, "currencyCode": "USD" }
```

---

## 0. Flutter integration honesty

| Layer | Backend-ready today? |
|-------|----------------------|
| Domain entities / enums / services | Yes |
| Domain **repository interfaces** | Yes — remote impls can match method shapes |
| Application **UseCases** | **Not yet** — several import `OrderingStore` / `SessionEngineDataSource` directly |
| Session token / display-number generation | Today: **client-side** in `CreateSessionUseCase`; target: **server-authoritative** |

**Phase A5 (Dependency Purification)** must complete before claiming drop-in remote datasources. Repository interfaces do not need redesign; UseCase constructors and a small amount of session-create orchestration do.

Stable table QR (`POST /join/{joinToken}` create-or-join) is product-correct but has **no Flutter UseCase today** — it requires a new application flow after A5, not a repository signature break.

---

## 1. Auth (`AuthRepository`)

### 1.1 Login — `LoginUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/auth/login` |
| **Auth** | None |
| **Body** | `{ "username": "string", "password": "string" }` |
| **Response 200** | `{ "user": AuthenticatedUser, "accessToken": "...", "refreshToken": "...", "expiresAt": "ISO-8601" }` |
| **Validation** | username/password non-empty; max 255 |
| **Rules** | Match `staff_user.email` or username alias; inactive → reject |
| **Errors** | `401 INVALID_CREDENTIALS`, `403 USER_INACTIVE` |
| **Idempotency** | Not required |

### 1.2 Refresh — `RefreshTokenUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/auth/refresh` |
| **Auth** | Body refresh token |
| **Body** | `{ "refreshToken": "string" }` |
| **Response 200** | Same as login |
| **Errors** | `401 INVALID_REFRESH`, `401 REFRESH_EXPIRED` |
| **Rules** | Rotate refresh token; revoke old hash |

### 1.3 Logout — `LogoutUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/auth/logout` |
| **Auth** | Staff |
| **Body** | `{ "refreshToken": "string?" }` |
| **Response** | `204` |
| **Rules** | Revoke refresh token if provided |

### 1.4 Current user — `GetCurrentUserUseCase` / `CheckAuthenticationUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/auth/me` |
| **Auth** | Staff |
| **Response 200** | `AuthenticatedUser` |
| **Errors** | `401` |

---

## 2. Restaurant & tables

### 2.1 Get restaurant — `RestaurantRepository.findById`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}` |
| **Auth** | Staff |
| **Response** | `Restaurant` + nested `settings` optional via `?include=settings` |

### 2.2 List tables — `TableRepository.listByRestaurant`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}/tables` |
| **Auth** | Staff (`manageTables` or cashier+) |
| **Query** | `status?`, `includeInactive=false` |
| **Sort** | `sort_order ASC` |
| **Response** | `{ "items": RestaurantTable[] }` |

### 2.3 Update table — `TableRepository.update`

| | |
|--|--|
| **Endpoint** | `PATCH /api/v1/restaurants/{restaurantId}/tables/{tableId}` |
| **Auth** | Staff admin/manager |
| **Body** | `{ "label?", "capacity?", "status?", "sortOrder?", "isActive?" }` |
| **Rules** | Status transitions via `TableDomainService`; cannot force `available` while active session |
| **Errors** | `409 TABLE_OCCUPIED`, `422 INVALID_TRANSITION` |

### 2.4 Resolve QR join token — `SessionRepository.resolveJoinToken`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/join/{joinToken}` *(probe)* or used internally by join |
| **Auth** | None |
| **Response** | `{ "restaurantId", "tableId", "tableLabel", "hasActiveSession": bool }` |
| **Errors** | `404 JOIN_TOKEN_INVALID` |

---

## 3. Sessions (`SessionEngineRepository`)

### 3.0 Session creation — client → server authority transition

Today Flutter `CreateSessionUseCase` generates **before** calling `SessionEngineRepository.create`:

- `displayNumber` (`SessionDisplayNumberGenerator`)
- `sessionSequence` (daily counter)
- `sessionTokenValue` (`SessionTokenGenerator`)
- `tokenExpiresAt`

That matches the current in-memory engine but is **not** acceptable as the long-term production model (multi-device races, non-authoritative tokens).

| Stage | Who generates token / display # / sequence | Flutter impact | API body |
|-------|--------------------------------------------|----------------|----------|
| **A — Compatibility bridge** | Client (current UseCase) | **None** on create path; remote `SessionEngineRepository` forwards client fields | Accept optional client metadata (below) |
| **B — Server-authoritative (target)** | Server only | **Required** Flutter change: UseCase stops generating token/sequence/displayNumber; repository/API return server values | Thin body: `tableId` + `openedVia` only |

**Rule for Stage B:** Server ignores any client-supplied token/sequence if sent; response `sessionToken` / snapshot is authoritative. Stage A exists only to avoid a hard cutover before Phase A5 + create-flow refactor.

Documented endpoint below supports **both** stages via optional fields.

### 3.1 Create session — `CreateSessionUseCase` / `SessionEngineRepository.create`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/sessions` |
| **Auth** | Staff cashier+ |
| **Idempotency** | Required |
| **Body (Stage A — bridge)** | `{ "tableId": "...", "openedVia": "cashier_manual", "displayNumber?": "S-…", "sessionSequence?": 1, "sessionToken?": "…", "tokenExpiresAt?": "ISO-8601" }` |
| **Body (Stage B — target)** | `{ "tableId": "...", "openedVia": "cashier_manual" }` |
| **Response 201** | `{ "snapshot": SessionEngineSnapshot, "sessionToken": "plaintext-once" }` |
| **Rules** | One active session/table; occupy table; persist hashed token; timeline `session_opened`; set `active_table_guard`; initialize payment summary minors to 0 |
| **Stage A rules** | If `sessionToken` provided: persist that token (hash); if omitted: server generates. Sequence/displayNumber same pattern. |
| **Stage B rules** | Server always generates token, sequence, displayNumber; reject or ignore client token fields |
| **Errors** | `404 TABLE_NOT_FOUND`, `409 ACTIVE_SESSION_EXISTS`, `422 TABLE_RESERVED` |
| **Status** | `201` created |
| **Flutter note** | Moving A→B is an intentional UseCase change — **not** “zero Flutter impact.” Schedule after Phase A5. |

### 3.2 Join / create-or-join via QR — customer entry

| | |
|--|--|
| **Endpoint** | `POST /api/v1/join/{joinToken}` |
| **Auth** | None (returns session token) |
| **Idempotency** | Recommended (`deviceId` based) |
| **Body** | `{ "deviceId": "string" }` |
| **Response 200/201** | `{ "snapshot", "sessionToken" }` |
| **Rules** | If active session → join; else create with `openedVia=qr_scan` (**server-authoritative** token/sequence); reject reserved unless settings allow; register `session_device` |
| **Errors** | `404 JOIN_TOKEN_INVALID`, `422 TABLE_RESERVED`, `422 TABLE_INACTIVE` |
| **Flutter note** | **No matching UseCase today.** Requires a new application flow (table QR resolve → create-or-join). Does not change existing repository interfaces. |

### 3.3 Join by session token — `JoinSessionUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/sessions/join` |
| **Auth** | None (token in body) or Customer |
| **Body** | `{ "sessionToken": "...", "deviceId?": "..." }` |
| **Response** | `SessionEngineSnapshot` |
| **Errors** | `401 INVALID_SESSION_TOKEN`, `401 SESSION_TOKEN_EXPIRED`, `422 SESSION_CLOSED` |

### 3.4 Validate token — `ValidateSessionUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/sessions/me` |
| **Auth** | Customer |
| **Response** | `SessionEngineSnapshot` |

### 3.5 Restore active sessions — `RestoreSessionUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}/sessions/active` |
| **Auth** | Staff |
| **Response** | `{ "items": SessionEngineSnapshot[] }` |
| **Filter** | status ∈ open, payment_pending |
| **Sort** | `opened_at ASC` |

### 3.6 Find active by table

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}/tables/{tableId}/session` |
| **Auth** | Staff |
| **Response** | `SessionEngineSnapshot | null` → `404` if none optional; prefer `200` with `null` body `{ "session": null }` |

### 3.7 Mark waiting payment — `MarkWaitingPaymentUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/sessions/{sessionId}/waiting-payment` |
| **Auth** | Staff or triggered by payment request |
| **Idempotency** | Required |
| **Rules** | `SessionPolicy.canRequestPayment`; set soft lock if settings enabled |
| **Errors** | `422 SESSION_CLOSED`, `409 ALREADY_WAITING_PAYMENT` |
| **Response** | `SessionEngineSnapshot` |

### 3.8 Close session — `CloseSessionUseCase` *(engine close; payment may be separate)*

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/sessions/{sessionId}/close` |
| **Auth** | Staff `closeSession` |
| **Idempotency** | Required |
| **Body** | `{ "closedByUserId?" }` *(from JWT if omitted)* |
| **Rules** | Prefer payment-close endpoint for paid close; this releases table + revokes tokens |
| **Errors** | `422 SESSION_CLOSED` |
| **Side effects** | `active_table_guard=NULL`, table `available`, revoke tokens |

### 3.9 Transfer — `TransferSessionUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/sessions/{sessionId}/transfer` |
| **Auth** | Staff |
| **Response** | `501` `{ "error": { "code": "SESSION_TRANSFER_UNSUPPORTED" } }` until Phase 2 |

---

## 4. Cart

Cart repository methods map as:

### 4.1 Get cart — `GetSessionCartUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/sessions/me/cart` |
| **Auth** | Customer |
| **Response** | `CartView` (`cart`, `items`, menu projections) |

### 4.2 Add item — `AddToCartUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/sessions/me/cart/items` |
| **Auth** | Customer |
| **Idempotency** | Required |
| **Body** | `{ "menuItemId", "quantity", "selectionsJson": {} }` |
| **Rules** | Session open; not soft-locked; item available; customization validation |
| **Errors** | `422 SESSION_SOFT_LOCKED`, `422 MENU_OUT_OF_STOCK`, `400 CUSTOMIZATION_INVALID` |
| **Concurrency** | Increment `session_cart.version` |

### 4.3 Update quantity — `UpdateCartItemQuantityUseCase`

| | |
|--|--|
| **Endpoint** | `PATCH /api/v1/sessions/me/cart/items/{cartItemId}` |
| **Body** | `{ "delta": number }` or `{ "quantity": number }` |
| **Auth** | Customer |

### 4.4 Edit selections — `EditCartItemUseCase`

| | |
|--|--|
| **Endpoint** | `PUT /api/v1/sessions/me/cart/items/{cartItemId}` |
| **Body** | `{ "selectionsJson": {}, "expectedCartVersion?": number }` |
| **Errors** | `409 CART_VERSION_CONFLICT` |

### 4.5 Remove / clear

| Method | Endpoint |
|--------|----------|
| DELETE item | `DELETE /api/v1/sessions/me/cart/items/{cartItemId}` |
| Clear | `DELETE /api/v1/sessions/me/cart` |

Staff may use `/api/v1/restaurants/{rid}/sessions/{sid}/cart/...` mirrors.

---

## 5. Batches & kitchen

### 5.1 Confirm batch — `ConfirmBatchUseCase` / `AddBatchUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/sessions/me/batches` |
| **Auth** | Customer (or staff proxy) |
| **Idempotency** | **Required** |
| **Body** | `{ }` (cart is source of truth) |
| **Response 201** | `KitchenBatchTicket` (batch + items + rendered notes) |
| **Rules** | Non-empty cart; session open; soft-lock blocks; create immutable batch; clear cart; bump `current_batch_number`; outbox `BatchCreated` |
| **Errors** | `422 EMPTY_CART`, `422 SESSION_SOFT_LOCKED`, `422 SESSION_CLOSED` |

### 5.2 Kitchen queue — `GetKitchenQueueUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}/kitchen/queue` |
| **Auth** | Kitchen+ (`viewKitchenQueue`) |
| **Query** | `showCompleted=false`, `since?` (ISO), `limit=100`, `cursor?` |
| **Sort** | `confirmed_at ASC` (FIFO) |
| **Response** | `KitchenQueueView` — **no payment fields** |
| **Source** | `v_kitchen_batch_queue` + items |

### 5.3 Complete batch item — `CompleteBatchItemUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/kitchen/items/{batchItemId}/complete` |
| **Auth** | Kitchen |
| **Idempotency** | Required |
| **Rules** | preparing→completed; history row; if all done → `kitchen_batch.completed_at`; events |
| **Errors** | `422 INVALID_STATUS_TRANSITION`, `404` |

### 5.4 Mark served (future-ready)

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/kitchen/items/{batchItemId}/serve` |
| **Auth** | Kitchen or cashier (venue setting) |
| **Rules** | completed→served |

### 5.5 Session batch progress — customer / cashier

| Use case | Endpoint |
|----------|----------|
| `GetSessionBatchProgressUseCase` | `GET /api/v1/sessions/me/batches/progress` |
| `GetCashierBatchSummariesUseCase` | `GET /api/v1/restaurants/{rid}/sessions/{sid}/batches` |

---

## 6. Menu

### 6.1 Catalog — `GetMenuCatalogUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}/menu` |
| **Auth** | Customer session **or** public with join context; staff always |
| **Query** | Customer sees `availability=available` only |
| **Headers** | `If-None-Match: {menuVersion}` → `304` |
| **Response** | `MenuCatalogView` + `ETag: menuVersion` |

### 6.2 Item detail — `GetMenuItemDetailUseCase`

`GET /api/v1/restaurants/{restaurantId}/menu/items/{menuItemId}`

### 6.3 Kitchen panel — `GetKitchenMenuPanelUseCase`

`GET /api/v1/restaurants/{restaurantId}/kitchen/menu`

### 6.4 Toggle availability — `ToggleMenuAvailabilityUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/menu/items/{menuItemId}/toggle-availability` |
| **Auth** | Kitchen `manageMenu` |
| **Idempotency** | Required |
| **Rules** | Toggle available ↔ out_of_stock; write history; bump menu version; outbox |
| **Response** | `MenuItem` |

### 6.5 Lock OOS — `LockMenuItemUseCase`

`POST .../menu/items/{menuItemId}/out-of-stock`

---

## 7. Staff requests

### 7.1 Create — `CreateStaffRequestUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/sessions/me/requests` |
| **Auth** | Customer |
| **Idempotency** | Required |
| **Body** | `{ "requestType": "extra_water\|...\|payment", "note?": "..." }` |
| **Rules** | Not closed; no duplicate pending payment; payment → waiting-payment if not already |
| **Errors** | `422 SESSION_CLOSED`, `409 PAYMENT_REQUEST_PENDING` |
| **Response 201** | `StaffRequest` |

### 7.2 List pending — `ListPendingStaffRequestsUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{restaurantId}/requests/pending` |
| **Auth** | Cashier+ `handleRequests` |
| **Sort** | `requested_at ASC` |
| **Response** | `StaffRequestQueueItemView[]` (includes tableLabel, sessionDisplayNumber) |

### 7.3 List by session — `ListSessionStaffRequestsUseCase`

`GET /api/v1/sessions/me/requests` (customer)  
`GET /api/v1/restaurants/{rid}/sessions/{sid}/requests` (staff)

### 7.4 Handle — `HandleStaffRequestUseCase`

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{restaurantId}/requests/{requestId}/handle` |
| **Auth** | Cashier+ |
| **Idempotency** | Required |
| **Rules** | pending→handled only |
| **Errors** | `422 REQUEST_NOT_PENDING` |

---

## 8. Payment

### 8.1 Bill projection — `GetSessionBillUseCase`

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{rid}/sessions/{sid}/bill` |
| **Auth** | Staff cashier+ (customer may see summary without tax breakdown if product allows) |
| **Query** | `includeOpenCart=false` |
| **Response** | `SessionPaymentSummary` |
| **Rules** | Read-only projection; no payment row |

### 8.2 Close with payment — `PaymentRepository.createSessionPayment` + close

| | |
|--|--|
| **Endpoint** | `POST /api/v1/restaurants/{rid}/sessions/{sid}/payments` |
| **Auth** | Staff `closeSession` |
| **Idempotency** | **Required** |
| **Body** | `{ "paymentMethod": "cash\|card\|bank_transfer\|other", "closeType": "payment\|force_closed", "forceCloseReason?", "forceCloseNote?" }` |
| **Rules** | `PaymentDomainService`; no split bill; force-close reason required; write bill lines; close session atomically; audit |
| **Errors** | `409 SESSION_ALREADY_PAID`, `422 FORCE_CLOSE_REASON_REQUIRED` |
| **Response 201** | `{ "payment": SessionPayment, "billLines": SessionBillLine[], "snapshot": SessionEngineSnapshot }` |
| **Events** | `PaymentCompleted`, `SessionClosedEvent` |

---

## 9. Orders / delivery / shipper (schema-ready; Flutter use cases mostly absent)

| Action | Method / path | Auth |
|--------|---------------|------|
| Create draft order | `POST /restaurants/{rid}/orders` | Cashier |
| Add line | `POST /orders/{orderId}/lines` | Cashier |
| Submit → batch | `POST /orders/{orderId}/submit` | Cashier + Idempotency |
| List delivery for shipper | `GET /restaurants/{rid}/delivery/available` | Shipper |
| Claim | `POST /delivery/{orderId}/claim` | Shipper + Idempotency |
| Reassign | `POST /delivery/{orderId}/reassign` | Cashier/Admin |
| Pay order | `POST /orders/{orderId}/payments` | Cashier |

Rules from `OrderDomainService` / `DeliveryDomainService`. Exclusive claim via row lock + `shipper_user_id`.

---

## 10. Audit

| | |
|--|--|
| **Endpoint** | `GET /api/v1/restaurants/{rid}/audit` |
| **Auth** | Admin/manager `viewAuditLog` |
| **Query** | `entityType`, `entityId`, `from`, `to`, `limit`, `cursor` |
| **Sort** | `occurred_at DESC` |

Append is internal only (not public POST).

---

## 11. Realtime (WebSocket)

**URL:** `WS /api/v1/ws?token=<staffJwt>`  
**Subscribe:** `{ "action": "subscribe", "restaurantId": "..." }`  

Events (payload mirrors Flutter domain events):

| Event type | Recipients |
|------------|------------|
| `batch.created` | kitchen, cashier |
| `batch_item.status_changed` | kitchen, customer session room |
| `staff_request.created` | cashier |
| `staff_request.handled` | cashier |
| `menu.availability_changed` | all staff + customer menu |
| `session.waiting_payment` | cashier |
| `session.closed` | cashier, kitchen |
| `table.status_changed` | cashier |

---

## 12. Pagination / filtering / sorting conventions

- Cursor pagination: `?limit=50&cursor=<opaque>`  
- Filter enums as query strings matching Flutter `@JsonValue`  
- Default sorts documented per endpoint  
- Always scope by `restaurantId` from path **and** JWT `rid` (must match)

---

## 13. Mapping: Repository → HTTP (summary)

| Repository | Primary resource prefix |
|------------|-------------------------|
| AuthRepository | `/auth` |
| RestaurantRepository | `/restaurants` |
| TableRepository | `/restaurants/{rid}/tables` |
| SessionEngineRepository | `/sessions`, `/restaurants/{rid}/sessions`, `/join` |
| BatchRepository | `/kitchen`, `/sessions/me/batches` |
| MenuRepository | `/restaurants/{rid}/menu` |
| RequestRepository | `/requests`, `/sessions/me/requests` |
| PaymentRepository | `/sessions/{sid}/payments` |
| OrderRepository | `/orders`, `/delivery` |
| AuditRepository | `/audit` (+ internal idempotency) |
| UserRepository | `/staff` (admin later) |

---

## 14. Flutter replacement note

After **Phase A5**, remote **repository** adapters call these endpoints and deserialize into existing Freezed entities. UseCase *business orchestration* stays; UseCase *constructor dependencies* change from store/datasource to repositories during A5.

`OrderingStore` remains behind in-memory repository implementations for demo/tests only.

Session create Stage A→B and table QR create-or-join are **explicit Flutter follow-ups**, not implied zero-change work.
