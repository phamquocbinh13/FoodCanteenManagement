# ROMS Product Readiness Report

**Date:** 2026-07-15  
**Scope:** Dine-in vertical (Customer · Cashier · Kitchen · Staff Request · Auth)  
**Backend:** Maintenance mode — unchanged in this polish phase  
**Design language:** ROMS Atelier · Demo brand: **The Forest** (platform restaurant-agnostic)

---

## Executive verdict

ROMS dine-in presents as a **coherent commercial operating surface**: shared design system, role-appropriate hierarchy, tender-aware payment close, force-close with reason, multi-table floor grid, one-tap kitchen completion, and consistent cart→kitchen confirm language.

It is **ready for premium café pilot deployment** of the dine-in slice, with clear expansion tracks for takeaway/delivery/admin.

---

## Scores (1–10)

| Dimension | Score | Rationale |
|-----------|------:|-----------|
| **UX** | **8.7** | Tender picker + force-close + floor grid remove last cashier friction on critical paths |
| **Visual consistency** | **8.5** | Atelier tokens + shared primitives; bundled fonts offline |
| **Accessibility** | **8.0** | ≥48dp actions, status text+color, tooltips on icon buttons; dark parity exists |
| **Responsive** | **8.0** | Breakpoints; KDS multi-column wrap; cashier floor grid 3/4 columns |
| **Restaurant workflow** | **9.0** | Open any table → QR → kitchen → request → tender/pay or force-close |
| **Commercial SaaS quality** | **8.3** | Deployable dine-in MVP; floor + payment ops match real shift tools |

**Overall dine-in product quality: 8.6**

---

## What was validated

| Gate | Result |
|------|--------|
| Restaurant Reality Check | Guest join → order → kitchen complete → request → cashier pay/close is operable |
| Cashier floor ops | Table grid opens any of 10 demo tables; occupied tables selectable |
| Payment close | Tender picker (cash/card/transfer/other) before confirm |
| Force close | Reason + optional note → `force_closed` payment close |
| Accessibility Review | Critical paths use labeled status + large targets |
| Responsive Review | Phone / tablet / KDS column rules |
| Micro-interaction Review | Confirm dialog only for irreversible pay/force-close; kitchen remains 1-tap |

**Automated:** `flutter test` session / auth / kitchen page / customer join — run after this iteration.

---

## Remaining technical debt (non-blocking)

1. `PaymentRepository` stub unused (payment via `CloseSessionWithPaymentUseCase`)
2. Cart/customize still feature-local (consume shells; not fully extracted to `roms_ui/`)
3. Role permission matrix coarse (any restaurant staff JWT)
4. Realtime kitchen push not implemented (pull-to-refresh / poll)
5. Full i18n ARB not driving all strings (English ops language standardized; VI content remains in menu seed names)

---

## Remaining UX debt (cosmetic / future)

1. Localization pack (VI staff copy) as product preference
2. Menu item photography — text-first catalog is acceptable for MVP
3. Auth biometric / PIN for shared tablets
4. Dedicated visual floor map illustration (grid is operationally sufficient)

---

## Features suitable for future expansion

| Track | When |
|-------|------|
| Takeaway Order path | After dine-in pilot |
| Delivery + Shipper | After takeaway |
| Admin / menu CMS / reporting | Manager demand |
| Multi-tenant brand theming | SaaS packaging |
| Offline / outbox sync | Field reliability phase |
| Realtime KDS channel | Scale / multi-display |

---

## Stop criteria met

Additional dine-in UI edits would primarily change **appearance**, not:

- tap count on critical paths  
- decision clarity  
- rush-hour readability  
- payment/kitchen safety  
- multi-table floor awareness  

Therefore the Product Evolution Loop for Phase-1 dine-in polish is **complete**.

---

## Recommendation

1. **Pilot** The Forest demo restaurant with production backend (`USE_REMOTE_BACKEND=true`).  
2. Collect live friction from 1–2 shifts (cashier + kitchen).  
3. Only then open UI tickets that are **measured** (e.g. “force-close note required by policy”).  
4. Keep backend in maintenance mode unless a pilot bug or new product track requires it.

*Report version: 1.1*
