# ROMS Production Cleanup Report

**Phase:** Production Cleanup & Remote-Only Architecture  
**Date:** 2026-07-16  
**Verdict:** Production DI is remote-only. NestJS + MySQL is the single source of truth for persistence.

---

## Architecture Before vs After

### Before (dual-mode)

```
Flutter → UseCases → Repository interfaces
                         ├─ Local *RepositoryImpl → OrderingStore (in-memory)
                         └─ Remote*Repository → ApiClient → NestJS → MySQL
DI selected by USE_REMOTE_BACKEND / OrderingModule
```

### After (production remote)

```
Flutter
  → Application (UseCases / Policies / Validators)
    → Repository interfaces
      → Remote*Repository / ServerConfirmBatch / CloseSessionWithPayment
        → ApiClient (HttpApiClient)
          → NestJS REST
            → MySQL
```

**Auth:** `RemoteAuthRemoteDataSource` + `AuthLocalDataSource` (JWT/session token cache only — not domain persistence).  
**Customer session token:** `CustomerSessionLocalDataSource` (device credential cache only).

---

## Dependency Graph (production DI)

| Module | Interface | Implementation |
|--------|-----------|----------------|
| Auth | `AuthRepository` | `AuthRepositoryImpl` → `RemoteAuthRemoteDataSource` + local session storage |
| Menu | `MenuRepository` | `RemoteMenuRepository` |
| Session | `SessionEngineRepository` | `RemoteSessionEngineRepository` |
| Tables | `TableRepository` | `RemoteTableRepository` |
| Cart | `SessionCartRepository` | `RemoteSessionCartRepository` |
| Batch | `BatchRepository` | `RemoteBatchRepository` |
| Confirm | `UseCase<KitchenBatchTicket, ConfirmBatchParams>` | `ServerConfirmBatchUseCase` |
| Requests | `RequestRepository` | `RemoteRequestRepository` |
| Payment | (use case) | `CloseSessionWithPaymentUseCase` → ApiClient |

`OrderingModule` removed. Hybrid `useRemoteBackend ? remote : local` branches removed from DI modules.

---

## Phase 1 — Classification (summary)

### KEEP (production)

Domain entities/services, repository interfaces, use cases, validators, policies, design system, remote repositories, `AuthRepositoryImpl` (orchestrates remote + token cache), `CustomerSessionLocalDataSource` (session token only).

### KEEP (tests only — not registered in prod DI)

| Class | Why kept | Risk if deleted |
|-------|----------|-----------------|
| `OrderingStore` | Unit/widget tests seed in-memory world | High — many tests break |
| `InMemorySessionEngineDataSource` | Session engine tests | High |
| `*RepositoryImpl` (menu/batch/cart/table/request/session_engine) | Manual construction in tests | High |
| `MockAuthRemoteDataSource` | Auth unit tests | Medium |
| `ConfirmBatchUseCase` (local) | Menu/batch unit tests | High |
| `DemoMenuSeed` | Test seeding | Medium |

### DELETED (proven unused in prod + no remaining lib refs)

| File | Why it existed | Replaced by |
|------|----------------|-------------|
| `ordering_module.dart` | Registered OrderingStore + demo seed | Remote modules |
| `app_assets.dart` | Empty asset path constants | Unused |
| `menu_datasource.dart` | Legacy stub interface | `RemoteMenuRepository` |
| `user_datasource.dart` / `user_repository_impl.dart` | Unused user stubs | Auth remote |
| `payment_datasource.dart` / `payment_repository_impl.dart` | Stub payment | `CloseSessionWithPaymentUseCase` |
| `session_datasource.dart` / `session_repository_impl.dart` | Legacy session stub | `RemoteSessionEngineRepository` |

### REFACTOR (done)

- DI always wires remotes
- `USE_REMOTE_BACKEND` defaults `true`; DI no longer branches on it
- Customer bill/progress avoid staff-only APIs
- Kitchen page tests seed auth without Nest login

---

## Phase 2 — Remote readiness

| Check | Result |
|-------|--------|
| UseCases import OrderingStore / InMemory / Mock | **None** (`lib/application` clean) |
| Features import OrderingStore / Mock | **None** |
| Prod DI registers OrderingStore | **No** |
| Prod DI registers local *RepositoryImpl | **No** |
| Prod DI registers MockAuth | **No** |

---

## Phase 3 — Dead code findings (kept when uncertain)

| Finding | Action |
|---------|--------|
| Local `*RepositoryImpl` + OrderingStore | **KEEP** — test harness |
| `useRemoteBackend` flag | **KEEP** — launch/logging; DI ignores `false` |
| Hardcoded `demo-restaurant` | **KEEP** — product constant until multi-tenant |
| Domain shells (`OrderRepository` etc. if unused) | **KEEP** — domain contracts |
| Empty asset folder entries in pubspec | **Removed** |
| `cupertino_icons` | **Removed** (unused package) |

---

## Phase 4–5 — Cleanup performed

- Removed OrderingModule and stub datasources/repos listed above
- Simplified auth/core/menu/session/kitchen/request/payment modules to remote-only
- Removed obsolete stub providers from `app_providers.dart`
- Packages: dropped `cupertino_icons`
- Assets: removed empty `assets/images|icons|animations|fonts` directory declarations (fonts still via `fonts:` block)

---

## Phase 6 — Performance (audit only; low-risk only)

| Issue | Recommendation | Implemented? |
|-------|----------------|--------------|
| Customer post-confirm staff batch N+1 | Customer progress API + bill trust `paymentSummary` | Yes (prior fix) |
| Kitchen queue per-batch item fetches | Batch list API already server-side; further coalesce later | No (risk) |
| Broad Riverpod watches on controllers | Prefer select() on hot paths | Deferred |
| Startup always builds HttpApiClient | Required for prod | N/A |

No aggressive rebuild refactors in this loop (correctness > aggressiveness).

---

## Phase 7 — Size reduction

| Metric | Before → After (this cleanup delta) |
|--------|-------------------------------------|
| Net LOC (git diff vs HEAD) | **~625 deleted / ~453 added** (net −172 lines in tracked cleanup) |
| Files deleted | 9 (`ordering_module`, `app_assets`, 4 datasources, 3 stub repos) |
| Packages removed | `cupertino_icons` |
| DI hybrid branches | Removed from modules |
| Prod repository impls | Remote-only registrations |

Compile/startup times: not re-benchmarked instrumentally; expected modest improvement from thinner DI graph (no OrderingStore/demo seed at boot).

---

## Phase 8 — Verification

| Check | Result |
|-------|--------|
| `flutter analyze lib` | **No issues found** |
| `flutter test` | **84 passed** |
| `npm run build` (backend) | **OK** |
| `npm test` (backend) | **4 passed** |
| API health | **OK** (MySQL up) |
| API login `cashier` | **OK** + permissions from RBAC |
| Live app (Pixel Tablet) | Remote menu/cart traffic observed |

Manual full UX flows (customer → kitchen → cashier → payment → force-close → floor) should be re-checked on device after hot restart; architecture does not alter contracts.

---

## Phase 9 — Regression vs MEMORY.md

| Concern | Status |
|---------|--------|
| Features lost | **No** — remotes cover same use cases |
| Business rules changed | **No** — domain/use cases retained |
| API / schema changed (this cleanup) | **No** — cleanup is Flutter DI/dead code (RBAC was prior iteration) |
| UX | Progress labels English (`Preparing`/`Ready`); leave-session always visible — intentional prior fixes |
| Architecture | Improved — remote-only prod path |

---

## Deleted inventory

### Files
- `lib/app/di/modules/ordering_module.dart`
- `lib/core/assets/app_assets.dart`
- `lib/data/datasources/menu/menu_datasource.dart`
- `lib/data/datasources/user/user_datasource.dart`
- `lib/data/datasources/payment/payment_datasource.dart`
- `lib/data/datasources/session/session_datasource.dart`
- `lib/data/repositories/user/user_repository_impl.dart`
- `lib/data/repositories/payment/payment_repository_impl.dart`
- `lib/data/repositories/session/session_repository_impl.dart`

### Packages
- `cupertino_icons`

### Providers / DI
- OrderingStore registration
- Local repository hybrid selection
- Stub Session/Payment repository + Connectivity/AppLifecycle stubs (prior)

---

## Remaining technical debt

1. **Application stub mappers** (`SessionMapper`, etc.) still throw `UnimplementedError` — remotes use `RemoteJson` instead; stubs kept as optional future DTO scaffolding.
2. **In-memory caches inside remote repos** (batch id alias / items) — response caches, not alternate persistence; OK for now.
3. **`SessionEngineConstants.demoRestaurantId`** remains for seed/test parity; production features use `RestaurantContext`.
4. **tools/verify_session_vertical_slice.dart** — dangling doc comment info outside `lib`.

### Structural debt (2026-07-16 follow-up) — DONE
- Test doubles moved to `test/fakes/`
- `USE_REMOTE_BACKEND` removed
- `RestaurantContext` + `RESTAURANT_ID` dart-define
- `RemoteJson` consolidation across remotes

---

## Production readiness score

**9.4 / 10** (architecture)

- Prod path is remote-only; test doubles are out of `lib/`; tenant id is injectable.
- Remaining −0.6: unused stub application mappers; remote response caches.

---

## Stop conditions

| Condition | Met? |
|-----------|------|
| No prod feature uses OrderingStore | ✓ |
| No prod feature uses local DataSource as persistence | ✓ (token caches only) |
| No prod Mock repositories | ✓ |
| No demo OrderingStore persistence in DI | ✓ |
| No obsolete hybrid DI selection | ✓ |
| flutter analyze clean (`lib`) | ✓ |
| tests pass | ✓ |
| backend tests pass | ✓ |
| API smoke | ✓ |
| NestJS + MySQL single source of truth | ✓ |
