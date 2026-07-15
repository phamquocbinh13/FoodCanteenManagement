# ROMS Iteration Memory

## Backend Migration Report — 2026-07-15

### Completed Modules

| Module | Flutter remote | Nest API | MySQL | Notes |
|--------|----------------|----------|-------|-------|
| Auth | RemoteAuthRemoteDataSource | B1 `/auth/*` | staff_user, refresh | Alias login `cashier`/`cashier123` |
| Session | RemoteSessionEngineRepository | B2 sessions | dine_in_session, tokens, timeline | Stage A |
| Menu | RemoteMenuRepository | `/restaurants/:rid/menu*` | menu_* + customizations | Demo seed aligned to Flutter rice menu |
| Cart | RemoteSessionCartRepository | `/sessions/me/cart*` | session_cart(_item) | Session-token auth |
| Batch | RemoteBatchRepository | batches + confirm | kitchen_batch, batch_item | Chatty CRUD + confirm endpoint |
| Kitchen | via BatchRepository | `/kitchen/queue`, complete | same + history | Queue FIFO |
| Staff Request | RemoteRequestRepository | `/requests*` | staff_request | |
| Bill read | via Session + GetSessionBill | `GET .../bill` | payment_*_minor columns | Projection |

### Intentionally deferred (no production Flutter workflow yet)

| Module | Why |
|--------|-----|
| **Payment write** | `PaymentRepository` still stub; cashier close uses engine close (B2). Atomic payment-close UC not wired in UI. |
| **Admin** | No backend-critical admin CRUD in active dine-in path |
| **Reporting** | Not implemented in Flutter product path |
| **Delivery / Orders** | Roadmap Phase 5; out of current dine-in scope |

### Remaining Local Implementations

Kept **only** for `USE_REMOTE_BACKEND=false` (demo/tests):

- `MenuRepositoryImpl`, `SessionCartRepositoryImpl`, `BatchRepositoryImpl`, `RequestRepositoryImpl`, `SessionEngineRepositoryImpl`, `MockAuthRemoteDataSource`, `OrderingStore`

When `USE_REMOTE_BACKEND=true`, **OrderingStore is not registered**.

### Remaining OrderingStore References

- Local repository implementations + tests only
- **Production mode (`USE_REMOTE_BACKEND=true`): OrderingStore is not required and not registered**

### Remaining SessionEngineDataSource References

- Registered only when `useRemoteBackend=false`
- **Zero UseCase imports** (application layer purified)

### Backend Endpoint Coverage (dine-in)

Auth, restaurants/tables, sessions, menu, cart, batches, kitchen queue/complete, staff requests, session bill.

### Database Coverage

Demo restaurant + 10 tables + Flutter-aligned menu (9 items) + session/cart/batch/request/payment summary columns.

### Test Results

- `flutter test test/session test/menu_batch test/kitchen test/customer` → **61 passed**
- API smoke: menu → cart → confirm batch → kitchen queue → staff request → close → **OK**
- Session restart survival previously verified

### Build / Analyzer

- `npm run build` (backend) → pass
- `flutter analyze` on application/repositories/di → infos only (no errors)

### Production Readiness Score

| Area | Score |
|------|------:|
| Architecture | 8 |
| Backend dine-in coverage | 8 |
| Repository purity | 9 |
| Persistence | 9 |
| Multi-client | 8 |
| Payment close path | 4 (engine close only) |
| Overall dine-in prod | **7.5** |

### Technical Debt

1. ConfirmBatch still client-orchestrated remote CRUD (prefer `POST /sessions/me/batches` single call)
2. CreateStaffRequest may double-write timeline/payment when remote API already does so
3. PaymentRepository unimplemented — force-close / paid close incomplete
4. Chatty kitchen queue (N+1 batch detail fetches)

### How to run production-backed app

```bash
cd backend
npm run seed:passwords
npm run seed:demo-menu
npm run start:dev

flutter run --dart-define=USE_REMOTE_BACKEND=true --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

### Recommended Next Phase

**UI/UX and product refinement** may begin for dine-in flows that are backend-backed.

**Before paid café launch:** implement Payment close UseCase + `POST .../payments` (atomic bill + session close), then harden ConfirmBatch to atomic server confirm.

---

## Prior iterations

See git history for Session vertical-slice and B0 bootstrap notes.
