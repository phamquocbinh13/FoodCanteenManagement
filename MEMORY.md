# ROMS Iteration Memory

## Production Hardening Report — 2026-07-15

### Backend Architecture Score — **9 / 10**

Dine-in production path is NestJS + MySQL end-to-end. ConfirmBatch and Payment Close are server-owned transactions. Flutter remotes no longer orchestrate multi-step batch/payment writes. OrderingStore remains demo/test-only.

### Security Score — **8.5 / 10**

- JWT staff auth + session-token customer auth
- `RestaurantScopeGuard` enforces JWT `rid` == `:restaurantId` on staff restaurant routes
- Session ownership via hashed session tokens
- Customers cannot hit staff payment/kitchen write routes without JWT
- Staff cannot cross-restaurant with a valid token for another `rid`

Remaining: fine-grained role permissions (cashier vs kitchen) are coarse (any authenticated staff of the restaurant).

### Performance Score — **8 / 10**

- Kitchen queue returns ticket + items + table/session labels in one payload (removed Flutter N+1)
- ConfirmBatch preloads menu items + customization groups before the write transaction
- Indexes already cover kitchen queue, session status, cart, payments

Avoided premature caching layers.

### Transaction Safety Score — **9 / 10**

| Operation | Atomicity |
|-----------|-----------|
| ConfirmBatch | Prisma `$transaction`: batch + items + mods + cart clear + session bill + timeline |
| Payment close | Prisma `$transaction`: payment + bill lines + session close + table free + token revoke + timeline; unique `session_id` + optimistic `updateMany` status guard |

Partial client failure after commit is safe (idempotent 409 on re-pay).

### API Consistency Score — **8.5 / 10**

- Envelope errors `{ error: { code, message } }` via `ApiExceptionFilter`
- Status mapping: 400 validation, 401/403 authz, 404, 409 conflict, 422 business, 500 internal
- Success shapes unchanged for existing modules; payment returns `{ payment, billLines, snapshot }`

### Technical Debt Remaining

1. `PaymentRepository` / stub datasource still present (unused in production close path — cashier uses `CloseSessionWithPaymentUseCase`)
2. Role-based permission matrix (cashier-only payment, kitchen-only complete) not enforced beyond restaurant scope
3. Admin / Reporting / Delivery modules still out of dine-in scope
4. Some staff batch CRUD endpoints remain for legacy/debug; production customer path uses `POST /sessions/me/batches`
5. `ServerConfirmBatchUseCase` / `CloseSessionWithPaymentUseCase` call `ApiClient` directly (acceptable hardening shortcut; could later move behind repository ports)

### Known Limitations

- No split bill / multiple payments per session (by design: UNIQUE session payment)
- Tax/service from restaurant settings; demo defaults may be 0 bps
- Multi-tenant beyond single demo restaurant not productized
- Real-time kitchen push not implemented (polling remains)
- Flutter UI payment method picker not redesigned (controller accepts params; default cash)

### Production Readiness Score — **9 / 10**

Dine-in backend is stable for UI/UX-focused work. Further backend changes should be bugfixes or feature-driven expansions only.

### Files Changed (this iteration)

**Backend**
- `backend/src/payments/**` — atomic payment module
- `backend/src/kitchen/kitchen.service.ts` — enriched queue
- `backend/src/batches/batches.service.ts` — confirm preload
- `backend/src/auth/guards/restaurant-scope.guard.ts` — restaurant isolation
- Staff controllers — `RestaurantScopeGuard`
- `backend/src/common/errors/api-exception.filter.ts` — status code labels + logging

**Flutter**
- `lib/application/usecases/batch/server_confirm_batch_use_case.dart`
- `lib/application/usecases/payment/close_session_with_payment_use_case.dart`
- `lib/app/di/modules/kitchen_module.dart` / `payment_module.dart` / `request_module.dart`
- `lib/features/cashier/.../cashier_session_controller.dart` + provider
- `lib/features/customer/.../customer_ordering_controller.dart` + provider
- `lib/data/repositories/batch/remote_batch_repository.dart`
- `lib/application/usecases/kitchen/get_kitchen_queue_use_case.dart`
- `lib/application/usecases/request/create_staff_request_use_case.dart` (`serverOwnsSideEffects`)

### Endpoints Added or Updated

| Method | Path | Notes |
|--------|------|-------|
| **POST** | `/api/v1/restaurants/:rid/sessions/:sid/payments` | **New** — atomic pay + close |
| POST | `/api/v1/sessions/me/batches` | Production ConfirmBatch (already existed; now sole Flutter path) |
| GET | `/api/v1/restaurants/:rid/kitchen/queue` | Enriched ticket payload |

### Database Changes

None required this iteration. Uses existing `session_payment`, `session_bill_line`, kitchen/batch/cart tables and indexes.

### Risks

- Cashier demo close now requires remote payment when `USE_REMOTE_BACKEND=true`; empty-bill force-close needs `closeType=force_closed` + reason
- Orphan occupied tables possible if sessions closed outside payment path (engine-only close); prefer payment close in production
- Generic `UseCase` DI registration for ConfirmBatch — ensure app always initializes via `Injection.init`

### Verification

| Check | Result |
|-------|--------|
| `npm run build` | pass |
| `npm test` | 4 passed |
| `flutter test` session/menu_batch/kitchen/customer | **61 passed** |
| Changed-file `flutter analyze` | no issues |
| API smoke | auth → session → cart → confirm → kitchen → request → bill → payment → 409/403 | **PASS** |
| MySQL persistence | payment + closed session survive | **PASS** |
| Table freed after payment | **PASS** |

### Is the backend stable enough that future work can focus almost entirely on UI/UX and product evolution?

**Yes.** Backend development for the dine-in vertical has entered **maintenance mode**. Recommend beginning the UI/UX refinement phase. Treat further backend work as bugfixes or explicit product expansions (admin, reporting, delivery, role matrix, realtime).

---

## Prior: Backend Migration Report (superseded for payment/confirm)

See git history for Session vertical-slice and full dine-in migration notes.

### How to run production-backed app

```bash
cd backend
npm run seed:passwords
npm run seed:demo-menu
npm run start:dev

flutter run --dart-define=USE_REMOTE_BACKEND=true --dart-define=API_BASE_URL=http://localhost:3000/api/v1
```

Staff: `cashier` / `cashier123`. Restaurant: `demo-restaurant`.

---

## Design Foundation — 2026-07-15

Backend remains in maintenance mode. Product evolution foundation docs added (design equivalent of `PROJECT_CONTEXT.md` / `ARCHITECTURE.md`).

### Screens improved

None (documentation-only iteration).

### Components added

None in code. Catalogued existing + planned in `COMPONENT_LIBRARY.md`.

### Components removed

None.

### UX improvements

Defined principles, role flows, confirmation policy, feedback/error patterns in `UX_GUIDELINES.md`.

### Performance improvements

Guidelines only (skeleton loading, timer isolate, list virtualization checks in roadmap).

### Accessibility improvements

AA contrast, 48dp targets, status not color-only — specified in UX + Design System.

### Responsive improvements

Breakpoints phone → KDS defined; device lab is Iteration 7.

### Restaurant workflow improvements

Dine-in journeys prioritized (Customer → Kitchen → Cashier → Requests); takeaway/delivery deferred.

### Technical debt remaining

- Current UI still Material-green/Roboto utilitarian (tokens not yet remapped)
- Dark theme incomplete
- Feature widgets not yet on shared sheet/dialog shells
- Demo chrome still present on some customer paths
- Admin/delivery/takeaway remain stubs

### Product quality score

| Area | Score (pre-redesign) |
|------|---------------------:|
| Visual Design | 4 |
| UX | 5 |
| Consistency | 4 |
| Accessibility | 5 |
| Performance | 6 |
| Scalability (UI system) | 4 |
| Restaurant Readiness | 6 (flows work, polish weak) |
| Commercial Readiness | 4 |
| Maintainability | 7 |
| **Overall Product Quality** | **5** |

### Next highest-impact iteration

**UI Roadmap Iteration 0** — Design System bootstrap (remap tokens, fonts, core primitives), then **Iteration 1** Customer journey.

### Foundation documents

| Doc | Path |
|-----|------|
| Product Vision | `PRODUCT_VISION.md` |
| Design System | `DESIGN_SYSTEM.md` |
| UX Guidelines | `UX_GUIDELINES.md` |
| Component Library | `COMPONENT_LIBRARY.md` |
| UI Roadmap | `UI_ROADMAP.md` |

**Gate:** Human approval of Design System v1.0 (especially color + typography) before large-scale screen redesign.
