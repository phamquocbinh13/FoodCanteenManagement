# ROMS UI Roadmap

> Ordered redesign iterations for the Product Evolution Loop.  
> Backend: **maintenance mode** — bugfixes only unless a product feature requires API expansion.  
> Scope lock: **Phase 1 = dine-in** (Customer, Cashier, Kitchen, Request Queue).  
> Out of scope until dine-in commercial score ≥ 9: Takeaway, Delivery, Shipper, Admin depth, Reporting.

---

## 0. Preconditions (this document set)

| Doc | Role |
|-----|------|
| `PRODUCT_VISION.md` | Brand, users, principles |
| `DESIGN_SYSTEM.md` | Tokens, type, motion, breakpoints |
| `UX_GUIDELINES.md` | Patterns, a11y, feedback |
| `COMPONENT_LIBRARY.md` | What to reuse / add |
| `UI_ROADMAP.md` | What order to ship |

**Do not start screen redesign until Iteration 0 tokens are applied** (or explicitly paired in the same PR as the first journey).

---

## Scoring gate

After each iteration, score 1–10:

Visual · UX · Consistency · Accessibility · Performance · Scalability · Restaurant readiness · Commercial readiness · Maintainability · **Overall**

If **Overall < 9**, continue.  
Stop for human approval when: business rules, architecture, or brand direction must change.

---

## Iteration 0 — Design System bootstrap

**Goal:** One visual language in code.

- Remap `AppColors` / dark / typography / theme components to Atelier
- Register fonts
- Extend core buttons, chips, empty/error/loading
- Add skeleton + money text primitives

**Exit:** New screen can be built without raw hex; dark parity for staff scaffolds.

**Depends on:** Approval of `DESIGN_SYSTEM.md` tokens (or proceed with v1.0 as written).

---

## Iteration 1 — Customer journey (highest guest impact)

**Workflow:** Land → Join (scan/code) → Session hub → Menu → Customize → Cart → Confirm → Progress → Call staff

**Improve:** Hierarchy, cart CTA, confirm confidence, empty/error, remove demo chrome from happy path.

**UX targets:** Fewer taps to confirm; clearer session trust; premium first viewport.

**Screens:** `customer_landing_page`, `qr_scan_page`, `customer_join_page`, `customer_dashboard_page`, `session_menu_page`, `session_request_page`, cart/customize sheets.

---

## Iteration 2 — Kitchen KDS (highest rush impact)

**Workflow:** Open queue → read ticket → complete item → (optional) inventory toggle

**Improve:** Glanceable tickets, 1-tap complete, aging emphasis, segmented control, landscape/KDS layout, reduce rebuild churn.

**Screens:** `kitchen_page` + kitchen widgets.

---

## Iteration 3 — Cashier + payment close

**Workflow:** Restore/open session → share QR → triage requests → bill → tender → close → table free

**Improve:** Master–detail on tablet/POS, bill clarity, payment confirmation ritual, request interrupt, status honesty.

**Screens:** `cashier_page`, `session_qr_display`, payment close UI (may be sheet/dialog on existing page).

---

## Iteration 4 — Staff request queue

**Workflow:** See pending → identify table/type/age → handle

**Improve:** Triage density, consistency with cashier preview tile, empty/loading.

**Screens:** staff `RequestPage`, `staff_request_tile`.

---

## Iteration 5 — Auth + app chrome

**Workflow:** Splash → login → role home

**Improve:** Staff login premium calm; splash; remove prod demo badges; consistent `StaffScaffold` headers.

**Screens:** `splash_page`, `login_page`, shared scaffolds.

---

## Iteration 6 — Cross-role consistency pass

**Goal:** Same chips, money, dialogs, sheets, error maps everywhere dine-in touches.

- Replace remaining raw `Card`/`ListTile`/`SnackBar` one-offs
- EN/VI tone pass on dine-in paths
- Accessibility sweep (targets, contrast, labels)

---

## Iteration 7 — Responsive & device lab

**Verify:** small phone, large phone, tablet, POS landscape, KDS, rotate.

Fix overflow, stretch, thumb-zone CTAs, split views.

---

## Iteration 8 — Performance & QA hardening (UI)

- Queue/menu list virtualization checks
- Timer isolate audit
- Double-submit guards on confirm/pay
- Long catalog / long names / empty/error chaos testing
- Reduced-motion sanity

---

## Iteration 9 — Restaurant simulation polish

Mental + manual: breakfast, lunch rush, dinner, kitchen overload, cashier queue.

Remove last friction; score commercial readiness.

---

## Deferred (explicitly later)

| Track | When |
|-------|------|
| Takeaway UI | After Phase 1 overall ≥ 9 + product decision |
| Delivery + Shipper UI | Same |
| Admin / menu CMS / reporting | Same |
| White-label themes | After Atelier stable |
| Realtime kitchen push UX | When backend event channel exists |

Placeholder routes may keep `PlaceholderPage` until those tracks start.

---

## Suggested cadence

| Step | Cadence |
|------|---------|
| One iteration | Design audit → implement → self-review → MEMORY append |
| Do not | Redesign all roles in one unstructured PR |
| Do | Ship vertical slices (journey) that staff can feel |

---

## MEMORY.md contract

After every iteration append:

- Screens improved  
- Components added / removed  
- UX / performance / a11y / responsive / workflow improvements  
- Technical debt remaining  
- Product quality score  
- Next highest-impact iteration  

Then continue with the next iteration in this roadmap unless blocked.

---

## Immediate next action

1. Human skim/approve docs v1.0 (especially color + type in `DESIGN_SYSTEM.md`).  
2. Start **Iteration 0** (token bootstrap).  
3. Proceed **Iteration 1** (Customer journey).

*Document version: 1.0 — Design Foundation*
