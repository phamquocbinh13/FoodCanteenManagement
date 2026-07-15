# ROMS Backend Architecture Report

> **Sprint:** Architecture Sprint 0 — Design Only  
> **Status:** Design specification — **no backend code written**  
> **Source of truth:** `PROJECT_CONTEXT.md`, `ARCHITECTURE.md`, `DATA_MODEL.md`, Flutter `lib/domain/`  
> **Guiding principle:** Backend is a natural extension of the existing Flutter Clean Architecture.  
> **Honest readiness:** Domain **repository interfaces** are already backend-ready. The **application layer is not** — several UseCases still depend on `OrderingStore` / `SessionEngineDataSource` directly and must be purified (Phase A5) before a true drop-in remote implementation is possible.

---

## 1. Executive summary

The Flutter app already encodes the business model correctly at the **domain** layer.

**Target call stack (after Phase A5):**

```
UI → Provider/Controller → UseCase → Repository (interface) → RemoteDatasource (HTTP/WS)
                                                              ↓
                                                      NestJS API
                                                              ↓
                                                      MySQL 8.0 + Redis + Outbox
```

**Current call stack (today — blockers for drop-in remote):**

```
UI → UseCase → Repository          → In-memory impl / OrderingStore
            ↘ SessionEngineDataSource  (direct)
            ↘ OrderingStore            (direct)
```

| Layer | Backend-ready? | Notes |
|-------|----------------|-------|
| Domain entities, enums, services | **Yes** | Map 1:1 to tables / DTOs |
| Domain repository **interfaces** | **Yes** | Method shapes stable; remote impls can match |
| Application UseCases | **No — needs A5** | Must depend only on repository interfaces |
| Session create metadata | **Transitional** | Client-generated today → server-authoritative target (API §3.0) |

Repository interfaces do **not** need redesign. Application-layer dependency cleanup **does**.

---

## 2. Current Flutter architecture (audit findings)

### 2.1 What is real today

| Layer | Reality |
|-------|---------|
| Domain entities | Complete for Phase 1–5 model (31-entity family) |
| Domain services / policies | Encoded and tested for session, batch, kitchen, menu, request, payment calc |
| Use cases | Dine-in golden path + kitchen + request queue |
| Repositories (interfaces) | Stable contracts |
| Datasources | `OrderingStore` + mock auth — **process-local, volatile** |
| Domain events | Published to `NoOpDomainEventPublisher` |

### 2.2 Dual session contracts (must not redesign casually)

| Contract | Role | Backend mapping |
|----------|------|-----------------|
| `SessionEngineRepository` | **Live** dine-in engine used by UI | Primary session API surface |
| `SessionRepository` | Broader aggregate shell (mostly `UnimplementedError`) | Fold into same session/cart/QR modules; do not expose two conflicting APIs |

**Decision:** One session aggregate API on the backend. Flutter keeps both interfaces temporarily; remote datasources implement both against the same endpoints until the shell interface is retired in a later Flutter cleanup (out of scope for this sprint).

### 2.3 Auth duality (non-negotiable)

| Actor | Auth | Scope |
|-------|------|--------|
| Staff | Login → access + refresh tokens | Restaurant-scoped RBAC |
| Customer | Opaque **session bearer token** after QR join | Session-scoped only |

Never mix staff JWT into customer routes. Never put `tableId` in QR URLs.

---

## 3. Recommended backend stack

| Concern | Choice | Why |
|---------|--------|-----|
| Runtime | **Node.js 22 LTS** | Fast iteration; strong JSON/DTO fit with Flutter Freezed |
| Framework | **NestJS 10+** | Module boundaries mirror Flutter features; DI; guards; OpenAPI |
| Language | **TypeScript (strict)** | Same entity shapes as Dart Freezed JSON |
| ORM | **Prisma** (or TypeORM) | MySQL 8 first-class; migrations; type-safe queries |
| Primary DB | **MySQL 8.0 CE** | Per product requirement |
| Cache / pub-sub | **Redis 7** | Session soft-lock hints, menu version, WS fan-out |
| Realtime | **WebSocket (Socket.IO or Nest WS)** + **SSE optional** for kitchen | Kitchen/cashier need push; SSE simpler for one-way KDS |
| Auth staff | **JWT access (15m) + opaque refresh (7d) in DB** | Matches `AuthSession` |
| Auth customer | **Opaque session token** (hashed at rest) | Matches `SessionAuthToken` |
| API docs | **OpenAPI 3.1** generated from Nest | Contract-first for Flutter remote datasources |
| Validation | **Zod or class-validator** | Mirror application validators |
| Jobs | Nest Schedule / BullMQ | Idempotency cleanup, token expiry, day sequences |
| Observability | Structured JSON logs + OpenTelemetry | Production ops |
| Hosting | Container (Docker) on single VPS → later ECS/Cloud Run | Café MVP → multi-tenant |

**Alternatives considered (rejected for now):**

- Spring Boot — excellent, heavier for current team velocity  
- Go — great perf, slower domain iteration  
- Supabase-as-backend — fights Clean Architecture / repository boundaries  
- Firebase — poor fit for session/batch immutability and kitchen isolation  

---

## 4. Overall architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Clients                                      │
│  Customer PWA/App │ Cashier │ Kitchen KDS │ Admin Web │ Shipper │
└───────────┬───────────────┬───────────┬───────────┬─────────────┘
            │ REST          │ REST      │ REST+WS   │ REST
            ▼               ▼           ▼           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     API Gateway / NestJS                         │
│  AuthGuard │ SessionGuard │ RoleGuard │ Idempotency │ RateLimit │
└───────────┬─────────────────────────────────────────────────────┘
            │
┌───────────┴─────────────────────────────────────────────────────┐
│                     Application modules (mirror Flutter)         │
│  auth │ tables │ sessions │ cart │ batches │ menu │ kitchen      │
│  requests │ payment │ orders │ delivery │ shipper │ admin │ audit│
└───────────┬─────────────────────────────────────────────────────┘
            │
     ┌──────┴──────┬──────────────┐
     ▼             ▼              ▼
┌─────────┐  ┌──────────┐  ┌────────────┐
│ MySQL 8 │  │  Redis   │  │ Outbox → WS│
└─────────┘  └──────────┘  └────────────┘
```

### Module dependency rule (same as Flutter)

```
presentation/controllers → application/use-cases → domain ← infrastructure
```

Backend domain services should port rules from:

- `SessionDomainService`, `BatchDomainService`, `KitchenDomainService`
- `MenuDomainService`, `PaymentDomainService`, `RequestDomainService`
- `OrderDomainService`, `DeliveryDomainService`, `TableDomainService`

**Server is authoritative.** Flutter domain services remain for optimistic UX / offline-later; never as sole enforcement.

---

## 5. API style

| Traffic | Style | Examples |
|---------|-------|----------|
| Commands & queries | **REST JSON** `/api/v1/...` | Create session, confirm batch, pay, toggle menu |
| Kitchen / cashier / request board | **WebSocket** channel `restaurant:{id}` | Batch created, item completed, request created, menu version bump |
| Optional KDS one-way | **SSE** `/api/v1/kitchen/stream` | Environments that block WS |
| File uploads (menu images) | REST multipart → object storage URL | Future |

**Not recommended for MVP:** GraphQL (extra client complexity), gRPC (overkill for Flutter mobile/web first).

---

## 6. Authentication strategy

### 6.1 Staff

1. `POST /api/v1/auth/login` → `{ accessToken, refreshToken, expiresAt, user }`  
2. Access JWT claims: `sub` (userId), `rid` (restaurantId), `roles[]`, `permissions[]`  
3. Refresh: rotate opaque refresh token stored hashed in `staff_refresh_token`  
4. Logout: revoke refresh token row  

Password: **argon2id** (or bcrypt cost ≥ 12). Never store plaintext.

### 6.2 Customer (session)

1. `POST /api/v1/join/{joinToken}` → find/create session → return **sessionToken** (plaintext once) + snapshot  
2. Subsequent calls: `Authorization: Bearer <sessionToken>` or `X-Session-Token`  
3. Store **SHA-256 hash** of token in `session_auth_token.token_hash`  
4. Revoke on session close  

### 6.3 QR join token

- Physical QR encodes `/join/<opaqueJoinToken>` only  
- Server maps `token_hash` → `table_id` via `table_qr_token`  
- Join token ≠ session token (ARCHITECTURE §4.1)

---

## 7. Authorization strategy

Map Flutter `RoleKey` + `AppPermission`:

| Role | Permissions (from Flutter) |
|------|----------------------------|
| admin | all |
| manager | kitchen, menu, close, requests, tables, delivery reassign, audit |
| cashier | closeSession, handleRequests, manageTables, reassignDelivery |
| kitchen | viewKitchenQueue, manageMenu |
| shipper | claimDelivery |

Enforce with Nest guards:

- `@Roles('cashier','admin')`  
- `@Permissions('closeSession')`  
- Kitchen projections **must never** join payment tables (SQL view or dedicated DTO)

Customer guard: session open + token valid + not revoked + not expired.

---

## 8. Session management

Align with Flutter `SessionEngineRepository`:

| Operation | Behavior |
|-----------|----------|
| Create | Occupy table; issue session token; timeline `session_opened` |
| Join | Validate token; upsert `session_device`; timeline `device_joined` |
| Mark waiting payment | `payment_pending` + `payment_soft_lock` if settings enabled |
| Close | Require payment or force-close path; revoke tokens; free table |
| Restore | List non-closed sessions for restaurant |
| Transfer | Return `501` / `SESSION_TRANSFER_UNSUPPORTED` until Phase 2 |

**One active session per table:** enforced with `sessions.active_table_guard` unique column (MySQL partial-index substitute).

**Daily display numbers:** `restaurant_daily_counter` table keyed by `(restaurant_id, date_key, counter_type)`.

---

## 9. Data synchronization strategy

| Concern | Strategy |
|---------|----------|
| Multi-device staff | Server truth; clients refetch or WS invalidate |
| Multi-customer cart | Optimistic concurrency via `session_cart.version` (Flutter already has version) |
| Menu availability | `menu_version` per restaurant in Redis + DB; clients compare `If-None-Match` / WS `menu.updated` |
| Kitchen queue | Query by `(restaurant_id, confirmed_at)`; WS `batch.created` / `batch_item.updated` |
| Idempotency | `Idempotency-Key` header → `idempotency_record` (Flutter entity exists) |
| Offline | Deferred (Roadmap Phase 6); design outbox now so offline sync can attach later |

---

## 10. Realtime strategy

### Domain events → Outbox → Redis pub/sub → WebSocket

Flutter already defines events (`BatchCreated`, `StaffRequestCreated`, …). Backend:

1. Business transaction writes aggregate + `domain_outbox` row  
2. Relay publishes to Redis channel `restaurant:{restaurantId}`  
3. WS gateway fans out to subscribed staff sockets filtered by role  

Customer sockets optional later (order progress); MVP can poll customer progress.

**Channels (examples):**

- `batch.created`, `batch_item.status_changed`, `batch.completed`  
- `staff_request.created`, `staff_request.handled`  
- `menu.availability_changed`  
- `session.waiting_payment`, `session.closed`  
- `table.status_changed`  

---

## 11. Error handling

Mirror Flutter `Failure` codes in JSON:

```json
{
  "error": {
    "code": "ACTIVE_SESSION_EXISTS",
    "message": "Table already has an active session",
    "details": {}
  }
}
```

| HTTP | When |
|------|------|
| 400 | Validation |
| 401 | Missing/invalid auth |
| 403 | Role/permission denied |
| 404 | Entity not found |
| 409 | Concurrency / business conflict (cart version, duplicate payment request) |
| 422 | Domain rule violation |
| 429 | Rate limit |
| 500 | Unexpected |

Never leak stack traces to clients.

---

## 12. Logging & audit

| Stream | Content |
|--------|---------|
| App logs | requestId, restaurantId, actor, route, latency, error code |
| `audit_log` table | Mutations: session close, payment, force-close, menu availability, claim, reassign |
| Timeline | Session-scoped operational log (`session_timeline_event`) — keep separate from global audit |

Audit is append-only. No updates/deletes.

---

## 13. Deployment recommendation

### Phase A — Single venue MVP

```
Docker Compose:
  - api (NestJS)
  - mysql:8.0
  - redis:7
  - caddy/nginx TLS
```

Single VPS (4 GB RAM) sufficient for one café + ~10 tables + few tablets.

### Phase B — Multi-tenant SaaS

- Managed MySQL (RDS / Cloud SQL) with `restaurant_id` RLS-style filters in every query  
- Redis cluster  
- Horizontal API replicas behind LB  
- Object storage for menu images  
- Separate read replica for reporting  

---

## 14. Scalability considerations

| Dimension | Approach |
|-----------|----------|
| 10–100 tables / venue | Single MySQL instance |
| Many restaurants | Tenant key on every table; connection pooling (ProxySQL / RDS Proxy) |
| Kitchen load | Indexed queue query; WS diffs not full refetch |
| History growth | Partition `audit_log`, `batch`, `session_timeline_event` by month later |
| Reporting | Read replica + materialized daily sales views (future) |

---

## 15. Flutter integration path

**This design sprint:** no Flutter code changes.

**When implementation begins — required order:**

### Phase A5 — Dependency Purification (Flutter, blocking for drop-in remote)

Sole objective: remove direct `OrderingStore` and `SessionEngineDataSource` dependencies from UseCases so every UseCase depends only on **repository interfaces** (and pure domain/application helpers).

Affected examples today: `ConfirmBatchUseCase`, `AddToCartUseCase`, `GetSessionBillUseCase`, kitchen queue/complete, request use cases, menu catalog/toggle.

**Do not** redesign domain repository interfaces during A5 unless a gap is proven.

### After A5 — remote wiring

1. Implement remote repository (or datasource-behind-repository) adapters against `/api/v1`  
2. Flavor: `demo` (memory) vs `prod` (API)  
3. Keep in-memory store for widget tests / demo flavor  
4. Map JSON ↔ Freezed entities via existing `*.g.dart`  
5. Move session create from client-generated metadata → server-authoritative (API §3.0 Stage B) as a **separate, explicit** Flutter change  

Repository interfaces are already backend-ready. Application-layer cleanup is the prerequisite for a true drop-in remote implementation.

---

## 16. Explicit non-goals (this design sprint)

- No NestJS/Prisma code  
- No Flutter modifications **in this design sprint** (A5 comes after approval)  
- No rewriting domain business rules  
- No GraphQL  
- No microservices split (modular monolith first)

---

*Document version: 1.0 — Architecture Sprint 0*
