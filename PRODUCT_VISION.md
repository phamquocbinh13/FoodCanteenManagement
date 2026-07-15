# ROMS Product Vision

> Design equivalent of `PROJECT_CONTEXT.md` for product intent.  
> Backend is in **maintenance mode**. Product evolution is UI/UX and workflow craft.  
> Business rules in `PROJECT_CONTEXT.md` are non-negotiable.

---

## 1. What we are building

**ROMS (FoodCanteenManagement)** is a Restaurant Operating Management System — not a traditional POS and not a generic admin dashboard.

It is the operating layer of a modern restaurant:

| Layer | Reality |
|-------|---------|
| Customer | Scans QR, joins a Session, orders in Batches, calls staff |
| Cashier | Opens/closes Sessions, handles requests, takes payment |
| Kitchen | Completes Batches fast; never sees money |
| Manager / Admin | Oversight (later phases) |
| Takeaway / Delivery / Shipper | Separate Order paths (later phases) |

**Phase 1 product (now):** Production-grade **dine-in** for a café/restaurant with ~10–40 tables.  
**Later:** Takeaway, delivery, shipper, admin, reporting — only after dine-in feels commercially deployable.

---

## 2. Brand personality

ROMS should feel like **quiet operational luxury**.

| Attribute | Means | Does not mean |
|-----------|-------|---------------|
| Luxury | Materials, spacing, type, restraint | Decoration, gold gradients, gimmicks |
| Precision | Exact status, exact totals, exact next action | Dense spreadsheets |
| Trust | Clear ownership of Session/Batch/Payment | Hidden state, surprise closes |
| Calm | Soft surfaces, measured motion | Alert spam, neon urgency everywhere |
| Professionalism | Staff tools that respect expertise | Toy UI, emoji decoration, demo badges in prod |
| Speed | Large targets, short paths, instant feedback | Animations that delay work |
| Confidence | One primary action per moment | Competing CTAs |

**Reference craft (principles, not clones):** Apple (restraint), Linear (density with clarity), Stripe (trust + hierarchy), Notion (calm structure), Toast / Square (restaurant realism and speed).

**Never feel like:** student project, Flutter demo, Material template, generic SaaS admin.

---

## 3. Target users

### 3.1 Primary (Phase 1)

| Persona | Context | Success looks like |
|---------|---------|-------------------|
| **Guest** | Hungry, phone in hand, noisy room, short attention | Order in under 90s without help |
| **Cashier** | Standing, interruptions, queue forming | Open session / pay / close without hunting |
| **Cook / expo** | Greasy hands, glanceable distance, rush | See table + items + notes; one tap complete |

### 3.2 Secondary (later)

| Persona | Context |
|---------|---------|
| Manager | Floor overview, exceptions, force-close |
| Admin | Menu, staff, settings, audit |
| Shipper | Delivery claim/fulfill |

Design for **stress and gloves**, not for desk-bound reading.

---

## 4. Product goals (2026)

1. A premium restaurant would **pay for and deploy** the dine-in slice without apology.
2. Technology **disappears**; staff notice the floor, not the software.
3. Every workflow is **faster and clearer** than the current functional UI.
4. One coherent design language across Customer, Cashier, Kitchen, Request Queue.
5. Accessibility and responsiveness are first-class (phones → kitchen displays → POS tablets).

### Non-goals (for now)

- Full ROMS parity (delivery, takeaway, admin depth)
- Backend redesign or new business rules
- Split bill
- Offline-first (document as future; do not fake it in UX)

---

## 5. Design principles

1. **Session is the unit of truth** — UI always answers: which table, which session, which status?
2. **One job per surface** — Kitchen never shows money; Customer never closes payment.
3. **Reduce cognitive load** — Prefer progressive disclosure over dashboard sprawl.
4. **Large, honest controls** — 48dp+ primary actions; status over decoration.
5. **Immutable history, soft present** — Past batches are read-only; only cart/request are editable.
6. **Feedback before anxiety** — Loading, empty, error, and success are designed states, not afterthoughts.
7. **Consistency over novelty** — New UI must use the Design System; no one-off styles.
8. **Restaurant realism over demo cleverness** — Remove demo badges, fake polish, and “Sprint N” stubs from production paths.

---

## 6. Experience pillars by role

### Customer

Calm menu, clear cart, confident confirm, visible batch progress, simple call-staff. No login theater.

### Cashier

Floor awareness → session detail → bill → tender → close. Request queue is interrupt-friendly. Payment is the ritual that frees the table.

### Kitchen

Glanceable tickets: table, batch #, items, notes. One-tap complete. Inventory toggle is secondary, never competing with the queue.

### Staff request

Customer: few clear intents. Cashier: triage list with type, table, age, one handle action.

---

## 7. Emotional journey

| Moment | Feeling we design for |
|--------|------------------------|
| QR join | “I’m in — safe.” |
| First menu | “I know what to do.” |
| Confirm batch | “Order sent — kitchen has it.” |
| Rush kitchen | “I can keep up.” |
| Payment close | “Done. Table is free.” |
| Error | “I know what happened and what to try.” |

---

## 8. Success metrics (product, not vanity)

| Metric | Target direction |
|--------|------------------|
| Guest taps to first confirm | Decrease |
| Cashier taps to close paid session | Decrease |
| Kitchen time-to-complete item | Decrease |
| Confusion events (wrong screen, backtracks) | Decrease |
| Accessibility contrast / target failures | Zero on critical paths |
| Staff preference vs current UI | Qualitative win in simulation |

---

## 9. Relationship to other docs

| Document | Owns |
|----------|------|
| `PROJECT_CONTEXT.md` | Business rules |
| `ARCHITECTURE.md` | Technical structure |
| `DATA_MODEL.md` | Domain persistence |
| **`PRODUCT_VISION.md`** | Why + who + feel |
| **`DESIGN_SYSTEM.md`** | Visual language |
| **`UX_GUIDELINES.md`** | Interaction patterns |
| **`COMPONENT_LIBRARY.md`** | Widget catalog |
| **`UI_ROADMAP.md`** | Iteration order |
| `MEMORY.md` | Iteration log |

If product vision conflicts with a visual preference, **vision wins**.  
If vision conflicts with business rules, **business rules win**.

---

## 10. North-star statement

> ROMS is the calm, precise operating system of a premium restaurant — where guests order with confidence, the kitchen moves without friction, and the cashier closes the room with trust.

*Document version: 1.0 — Design Foundation*
