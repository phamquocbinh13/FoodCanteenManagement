# ROMS Backend — Risk Analysis

> Architecture Sprint 0 — Design only

---

## 1. Risk register

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | Dual session repos (`SessionEngine` vs `SessionRepository`) confuse backend teams | Medium | High | Single backend session module; document Flutter dual-interface as temporary |
| R2 | MySQL lacks partial unique indexes → active-session race | Medium | High | `active_table_guard` + transaction + `SELECT … FOR UPDATE` on table row |
| R3 | Cart multi-device lost updates | High | Medium | Require `expectedCartVersion`; return `409 CART_VERSION_CONFLICT` |
| R4 | Confirm-batch double-submit creates two batches | High | High | Mandatory `Idempotency-Key`; unique constraint on idempotency table |
| R5 | Kitchen sees payment data via careless joins | Medium | Critical (trust) | Enforce `v_kitchen_batch_queue` / dedicated DTOs in code review + tests |
| R6 | Session token leakage via logs/QR screenshots | Medium | High | Hash at rest; short TTL; rotate on security event; never log plaintext tokens |
| R7 | Join token brute force | Low | High | Long entropy tokens (≥128-bit); rate limit `/join` |
| R8 | In-memory Flutter demo diverges from MySQL behavior | High | Medium | Contract tests: same golden-path fixtures against API |
| R9 | Soft-lock not enforced server-side | Medium | High | Port `SessionDomainService` rules to Nest use-cases; never trust client |
| R10 | Outbox relay lag → stale kitchen | Medium | Medium | Polling fallback on KDS; alert on outbox backlog |
| R11 | Password seed placeholders left in prod | Medium | Critical | Deploy checklist; fail boot if hash starts with `$REPLACE_` |
| R12 | Money DECIMAL vs minor-units mismatch | Medium | High | Schema uses BIGINT minor units (Flutter-native); document conversion for reporting only |
| R13 | Premature microservices | Low | High | Modular monolith until multi-region need |
| R14 | Takeaway/delivery schema unused → drift | Medium | Low | Keep tables; implement APIs only when Flutter use cases exist |
| R15 | WebSocket auth on shared tablets | Medium | Medium | Short-lived WS tickets; role-filtered channels |
| R16 | Force-close without audit | Low | High | DB transaction must write `audit_log` + payment row together |
| R17 | Restaurant timezone vs UTC counters | Medium | Medium | `date_key` computed in restaurant timezone; store all timestamps UTC |
| R18 | Flutter UseCases import `OrderingStore` / `SessionEngineDataSource` | Certain | High (blocks drop-in remote) | **Phase A5** dependency purification before B5 |
| R19 | Client-generated session tokens accepted forever | Medium | High | Stage A bridge only; Stage B server-authoritative after A5 |
| R20 | Assuming “no Flutter changes” for remote cutover | Medium | High | Docs now require A5 + explicit Stage B / QR UseCase work |

---

## 2. Business-rule loss checklist

| Rule | Backend enforcement |
|------|---------------------|
| One active session per table | `active_table_guard` UNIQUE + txn |
| Session ends only on payment/force-close | Payment endpoint owns close; no anonymous close |
| Batch immutable | No UPDATE on `kitchen_batch` except `completed_at` |
| Batch parent XOR | CHECK constraint |
| Kitchen never sees bill | View + DTO policy tests |
| QR does not expose table id | Opaque join token only |
| Customer session token ≠ QR token | Two tables |
| No split bill | UNIQUE session_payment |
| Structured customization | JSON + normalized batch customizations |
| Out of stock hides from customer | Query filter + menu version |
| Duplicate payment request blocked | App rule + optional partial unique later |
| Shipper exclusive claim | Row lock + status |

---

## 3. Migration risks (Flutter → API)

| Gap in Flutter today | Backend must still provide |
|----------------------|----------------------------|
| No SessionPayment write | Full payment close API |
| Table QR unused | Join-by-table-token API |
| Single demo table | Seed 10 tables |
| NoOp events | Outbox + WS |
| Mock auth | Real argon2 + refresh table |

---

## 4. Security risks

- Staff JWT must embed `restaurantId`; every query filters by it (IDOR prevention).  
- Customer tokens must not access other sessions (`session_id` from token hash lookup only).  
- Admin force-close requires reason enum + audit.  
- Rate-limit login and join.  
- TLS everywhere in deployment.

---

## 5. Residual unknowns (need human sign-off)

1. Tax inclusive vs exclusive (DATA_MODEL assumes exclusive).  
2. Who marks `served` by default (kitchen vs cashier).  
3. Whether customer bill view shows tax breakdown.  
4. Hosting preference (single VPS vs managed cloud) for first paying venue.

---

*Document version: 1.0*
