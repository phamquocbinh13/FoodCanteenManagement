# ROMS Backend Implementation Roadmap

> Begin **only after human approval** of Architecture Sprint 0 deliverables.  
> Domain repository interfaces are backend-ready. Application UseCases are **not** — Phase A5 is mandatory before drop-in remote wiring.

---

## Phase ordering (overview)

```
A5 (Flutter purification) ──┬──► B0…B4 (API + MySQL)
                            └──► B5 (Flutter remote wiring)  [requires A5]
```

A5 may run **in parallel with** early backend bootstrap (B0–B1), but **must complete before B5**.

---

## Phase A5 — Dependency Purification (Flutter)

**Sole objective:** Remove direct `OrderingStore` and `SessionEngineDataSource` dependencies from UseCases so every UseCase depends only on repository interfaces (plus Clock / IdGenerator / domain services / policies as today).

**Estimate:** 3–7 days depending on how aggressively bill projection / timeline are moved behind repos.

### In scope

- [ ] Inventory every UseCase that imports `OrderingStore` or `SessionEngineDataSource`
- [ ] Introduce or extend repository methods where UseCases currently poke the store/datasource (e.g. append timeline, get session by id for request enrichment, bill projection inputs, menu version bump)
- [ ] Refactor UseCases to call repositories only
- [ ] Keep domain entities, domain services, and **existing repository interface names** stable where possible; extend interfaces only when a UseCase needs a missing capability
- [ ] Move `SessionCartRepository` into `lib/domain/repositories/` if still living under `data/` (optional cleanup; same contract)
- [ ] Update unit tests to mock repositories, not stores
- [ ] Prove: `grep`/analyzer finds **zero** UseCase imports of `OrderingStore` or `SessionEngineDataSource`

### Out of scope for A5

- Remote HTTP clients  
- Stable table QR UI  
- Server-authoritative session token UseCase change (Stage B — after A5, can be A5.1 or part of B5)  
- Payment close UI  
- Backend NestJS code  

### Exit criteria

1. Every UseCase depends only on repository interfaces (+ allowed pure helpers).  
2. In-memory `OrderingStore` remains **behind** repository/datasource implementations only.  
3. Existing widget/golden tests still pass against in-memory repos.  
4. Ready for remote repository adapters without UseCase surgery.

---

## Phase B0 — Bootstrap (3–5 days)

**Goal:** Runnable NestJS modular monolith + MySQL + migrations.

- [x] Create `backend/` folder (NestJS + Prisma 5)
- [x] Apply `04_schema_mysql8.sql` as initial migration *(via Workbench; copy in `backend/prisma/sql/`)*
- [x] Config modules: config, health (`/api/v1/health`)
- [x] OpenAPI / Swagger (`/docs`)
- [x] Docker Compose stub (optional Redis / MySQL profiles)
- [ ] Seed script: hash demo passwords with argon2id (replace placeholders) — B1
- [ ] Confirm `GET /health` green on developer machine (set `.env` `DATABASE_URL` password)

**Exit:** `GET /health` green against MySQL.  
**Code location:** `backend/` (see `backend/README.md`).

---

## Phase B1 — Auth + Tenant (3–5 days)

**Goal:** Staff login matches Flutter `AuthRepository`.

- [ ] `POST /auth/login|refresh|logout`, `GET /auth/me`
- [ ] JWT access + refresh table
- [ ] Role/permission guards mirroring `AppPermission`
- [ ] Restaurant scoping middleware
- [ ] Document `username` ↔ `staff_user.email` mapping

**Exit:** Cashier/kitchen/admin can authenticate; forbidden cross-tenant.

---

## Phase B2 — Tables + Stable QR Join (5–7 days)

**Goal:** Unblock Phase 1 café (10 tables).

- [ ] Table CRUD/list
- [ ] `table_qr_token` resolve
- [ ] `POST /join/{joinToken}` create-or-join (server-authoritative)
- [ ] Session create Stage A bridge fields (optional client metadata) + Stage B server generation
- [ ] Session token issue/validate/revoke
- [ ] `active_table_guard` transactions
- [ ] Persist session `payment_*_minor` summary columns
- [ ] Daily session counter

**Exit:** Physical QR API works; Flutter table-QR UseCase can be added after A5.

---

## Phase B3 — Cart + Batch + Kitchen (7–10 days)

**Goal:** Replace OrderingStore core loop on the server.

- [ ] Cart CRUD + version conflicts
- [ ] Confirm batch (idempotent) + customizations snapshots + update session payment summary
- [ ] Kitchen queue + complete item + history
- [ ] Menu catalog + toggle availability + version/ETag
- [ ] Domain outbox + Redis pub + WS skeleton

**Exit:** Multi-device API: customer + kitchen + cashier against one backend.

---

## Phase B4 — Requests + Payment Close (5–7 days)

**Goal:** Production money path.

- [ ] Staff request create/list/handle
- [ ] Payment request → waiting payment
- [ ] Bill projection
- [ ] Atomic payment close + bill lines + session close + audit
- [ ] Force-close path (`force_close_reason` constraints enforced)

**Exit:** Full dine-in day without in-memory store on the server.

---

## Phase B5 — Flutter remote wiring (**requires A5 complete**)

**Goal:** Wire purified UseCases to API via repository adapters. No domain redesign.

- [ ] Implement remote repository adapters (or datasource-behind-repository) for prod flavor
- [ ] Flavor: `demo` (memory) vs `prod` (API)
- [ ] Contract tests: golden path Flutter ↔ API
- [ ] Optional A5.1: switch `CreateSessionUseCase` to Stage B (server-authoritative tokens)
- [ ] New UseCase/controller for table QR create-or-join when product prioritizes stable QR
- [ ] Remove prod reliance on process-local OrderingStore

**Constraint:** Prefer not to change UseCase *business* APIs; dependency injection targets are repositories only (A5). Session Stage B and QR join are explicit, scheduled Flutter changes — not silent.

---

## Phase B6 — Orders / Delivery (when Roadmap Phase 5)

- [ ] Order draft/submit → batch
- [ ] Delivery claim/reassign
- [ ] Order payment

---

## Phase B7 — Hardening (ongoing)

- [ ] Load test kitchen WS (50 tablets)
- [ ] Backup/restore drills
- [ ] Partition audit/outbox if needed
- [ ] Observability dashboards
- [ ] Penetration test on join/auth

---

## Suggested sequencing vs Flutter product milestones

| Flutter Phase 1 need | Phase |
|----------------------|-------|
| UseCase → repository only | **A5** |
| Stable QR + multi-table | B2 + Flutter QR UseCase |
| Real kitchen multi-device | B3 + B5 |
| Request staff | B4 (partial) + B5 |
| Real payment | B4 + B5 |
| Persistence / recovery | B3–B5 |
| Delivery | B6 |

---

## Team recommendation

| Role | Focus |
|------|-------|
| Flutter lead | **A5 first**, then B5 adapters |
| Backend lead | B0–B4 schema + APIs |
| QA | Contract tests after A5+B5 |
| Ops | Compose → managed MySQL when first paid customer |

---

## Definition of done for “backend foundation”

1. Schema applied from `04_schema_mysql8.sql` without manual edits (incl. payment summary + force-close checks)  
2. Phase **A5** complete (no UseCase → store/datasource imports)  
3. Auth + join + session + cart + batch + kitchen + request + payment close live  
4. Kitchen DTOs proven payment-free  
5. Flutter prod flavor runs golden path against API  
6. Restart API/MySQL → sessions restore (incl. `paymentSummary` minors)  

---

*Document version: 1.1 — includes Phase A5 Dependency Purification*
