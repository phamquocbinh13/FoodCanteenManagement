# ROMS UX Guidelines

> Interaction patterns for every role.  
> Complements `PRODUCT_VISION.md` (why) and `DESIGN_SYSTEM.md` (look).  
> Preserve business rules in `PROJECT_CONTEXT.md`.

---

## 1. UX north star

**Technology disappears. Operations become effortless.**

Every flow is judged by:

| Metric | Goal |
|--------|------|
| Tap count | Minimum to outcome |
| Decision count | One clear choice at a time |
| Attention switches | Avoid split focus |
| Error probability | Confirm only when irreversible |
| Memory load | System remembers session/table/cart |
| Stress under rush | Larger targets, fewer words |

---

## 2. Navigation

### Principles

- Role homes are **destinations**, not dashboards of everything.
- Deep links (`/join/:token`, `/s/:sessionToken`) restore context without re-asking.
- Back always returns to a safe, obvious parent.
- No bottom-nav chrome for Phase 1 unless a role truly has ≥3 peer roots.

### Role maps (Phase 1)

```
Guest:     Landing → (Scan|Code) → Session hub → Menu | Request | Progress
Cashier:   Floor/Session → Requests (push) → Payment close
Kitchen:   Orders | Inventory (in-page segments)
Staff req: Queue list → Handle
```

### Forbidden

- Customer routes that imply payment close
- Kitchen surfaces that show bill/payment
- Cross-feature imports of another feature’s presentation layer

---

## 3. Hierarchy & composition

### First viewport rules

- **One composition**, not a widget dashboard.
- Brand / role context as a clear signal (especially customer landing).
- One headline intent, one short support line, one primary CTA group.
- No stats strips, promo chips, or floating badges on hero media.

### Cards

- Default: **no card** unless it groups an interaction or ticket.
- Kitchen tickets and bill summary are legitimate cards.
- If removing border/shadow/radius doesn’t hurt understanding, remove the card.

### Lists

- Virtualize long menus (100+ items) and tables (100+).
- Sticky section headers for menu categories.
- Swipe actions only if discoverable and not the sole path.

---

## 4. Forms & inputs

| Pattern | Rule |
|---------|------|
| Labels | Always visible (not placeholder-only) |
| Errors | Inline under field + non-color cue |
| Keyboards | Correct type (number for qty, etc.) |
| Submit | Disable while in-flight; keep label (“Đang xử lý…”) |
| Defaults | Sensible (qty 1, cash tender) — never surprising destructive defaults |

Staff login: username/password, clear auth errors from API `error.message`.

---

## 5. Feedback

### Loading

| Context | Pattern |
|---------|---------|
| First paint of a screen | Skeleton matching final layout |
| Button action | Button loading state (no full-screen block if avoidable) |
| Kitchen refresh | Subtle top indicator; keep tickets interactive |
| Payment | Blocking overlay only for the tender moment |

Never blank white with a lone spinner as the only design.

### Empty

Use `EmptyState`: short title, one sentence, optional single action.  
No “Sprint 12” or construction jokes on production paths.

### Success

Prefer inline confirmation or short snackbar. Payment close: clear “Session closed · Table free”.

### Errors

| Source | UX |
|--------|-----|
| Validation | Inline |
| 401/403 | Re-auth or “not allowed” with next step |
| 404 | “Not found” + back |
| 409 | Explain conflict (e.g. already paid) |
| 422 | Business message from API |
| 500 / network | Retry + offline |

Map API `{ error: { code, message } }` to human copy; never show raw JSON.

---

## 6. Dialogs, sheets, snackbars

| Pattern | When |
|---------|------|
| **Bottom sheet** | Customer cart, customize, mobile filters |
| **Dialog** | Irreversible staff actions (force close, destructive) |
| **Snackbar** | Transient success / soft failure |
| **Full page** | Multi-step that needs focus (QR scan) |

Rules:

- One primary + one dismissive action max in dialogs.
- Sheets drag-dismissible unless payment in flight.
- Never stack modal on modal.

---

## 7. Confirmation policy

| Action | Confirm? |
|--------|----------|
| Add to cart / qty change | No |
| Confirm batch | No (but clear primary CTA + disabled when empty) |
| Complete kitchen item | No (one tap — undo not required by business rules) |
| Handle staff request | No |
| Close with payment | Yes — show bill summary + tender |
| Force close | Yes — reason required |
| Clear cart | Soft confirm if non-empty |

---

## 8. Role-specific UX

### 8.1 Customer

- Guest language: short Vietnamese-first UI (keep EN for staff tools if mixed today — converge per screen intentionally).
- Cart always reachable; confirm is the hero action when cart non-empty.
- Progress is batch-level, not kitchen gossip.
- Call staff: ≤5 intents, large tiles, done in 2 taps.

**Target:** Scan → first item in cart ≤ 60s for returning guests; confirm ≤ 3 taps from cart open.

### 8.2 Cashier

- Always show **table + session display # + lifecycle phase**.
- Payment path: Bill → method → confirm → closed.
- Request interrupt: badge/count without stealing the whole screen.
- QR share: large, high contrast, copy/share secondary.

**Target:** Occupied → paid close ≤ 5 taps when bill ready.

### 8.3 Kitchen (KDS)

- Distance readability: table + batch # largest.
- Item row min height ≥ 56dp; complete target ≥ 48×48.
- Notes always visible (no hover).
- Aging: subtle time emphasis after threshold (e.g. 10/15 min) via `accent`/`warning`, not flashing.

**Target:** Complete item = **1 tap**, zero dialog.

### 8.4 Request queue

- Sort by oldest first.
- Type icon + label + table + age.
- Handle = one tap with optional note later (not blocking).

---

## 9. Accessibility

| Rule | Standard |
|------|----------|
| Touch targets | ≥ 48×48 dp primary; ≥ 44×44 secondary |
| Contrast | Text/icon vs background WCAG AA |
| Status | Color **and** text/icon |
| Focus | Logical order on keyboard/desktop |
| Screen readers | Labels on icon buttons |
| One-handed | Primary CTA in thumb zone on phones |
| Motion | Respect reduced motion |

Kitchen: high contrast mode preferred; avoid relying on fine gray text.

---

## 10. Responsive behavior

| Device | Expectation |
|--------|-------------|
| Small phone | Single column; bottom CTA; no horizontal overflow |
| Tablet customer | Wider menu grid optional; same flow |
| POS landscape | Master–detail cashier |
| KDS landscape | Multi-ticket columns |
| Rotate | State preserved; layout reflows |

---

## 11. Performance perception

- Prefer skeletons over spinners for catalogs.
- Keep kitchen list scroll at 60fps; avoid rebuilding entire queue per tick.
- Elapsed timers: isolate rebuilds (`ElapsedTimeText` pattern).
- Images (if any): sized caches; menus can be text-first in Phase 1.

---

## 12. Content & tone

| Voice | Example |
|-------|---------|
| Calm | “Không thể xác nhận đơn. Thử lại.” |
| Specific | “Giỏ hàng trống” not “Error” |
| Staff-direct | “Hoàn tất món” not “Submit entity” |

Remove demo copy (“Demo exit”, role badges) from production builds or gate behind debug.

---

## 13. QA interaction checks

Before shipping a flow:

- [ ] Double-tap primary CTA does not double-charge / double-batch
- [ ] Slow network: loading visible; no stuck buttons
- [ ] Backend 409/422: readable
- [ ] Long names / 200 menu items / 100 tables: usable
- [ ] Empty cart / empty queue / no session: guided empty state

---

## 14. Anti-patterns

- Dashboard-of-everything home
- Multiple equally weighted CTAs
- Confirm dialogs on every kitchen tap
- Decorative animation on KDS
- Inconsistent EN/VI mid-flow without reason
- Re-implementing buttons/chips per feature

*Document version: 1.0 — Design Foundation*
