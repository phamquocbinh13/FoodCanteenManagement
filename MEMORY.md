# ROMS Iteration Memory

## Iteration: 2026-07-15 — Request Staff Queue E2E

### What changed

- Wired **Call Staff / Request Queue** end-to-end through Clean Architecture.
- Domain: hardened `RequestDomainService` (clock-injected timestamps, duplicate payment guard).
- Data: `OrderingStore.staffRequests`, `RequestRepositoryImpl`, session snapshot `requestIds`.
- Application use cases: create / list pending / list by session / handle.
- Customer UI: real `SessionRequestPage` (assistance, water, bowl, spoon, payment).
- Cashier UI: live queue on Cashier page + full `/request` queue page.
- Payment request now creates a `StaffRequest` **and** transitions session to `paymentPending`.
- Tests updated; new `request_domain_service_test.dart`.

### Why

Call Staff and Request Queue were visible **Sprint 9 placeholders**. A café cannot operate if customers cannot call staff and cashiers cannot see those requests. Highest Phase-1 ops value after the existing single-table demo slice.

### Remaining blockers (production)

1. **In-memory only** — restart loses sessions, batches, requests.
2. **Stable physical table QR** — still session-token QR, not fixed table join tokens.
3. **Single demo table** — no 10-table floor board.
4. **Real payment close** — close session still skips `SessionPayment` / receipt.
5. **Restaurant open/close day** — missing.
6. **Realtime** — cashier/kitchen must pull-to-refresh.

### Lessons learned

- Prefer finishing a visible broken workflow over polishing a working one.
- Payment request must be a queue entry first; soft-lock is a side effect, not a substitute.
- DI order matters when Customer controllers depend on Request use cases (lazy OK; register Request before Customer for clarity).

### Suggested next iteration

**Multi-table floor + stable table QR join** (seed ~10 tables, `/join/<tableToken>` create-or-join, cashier table board). Highest remaining business value for “10-table café can operate.”

Alternate if persistence is preferred: local durable store behind existing datasource interfaces.
