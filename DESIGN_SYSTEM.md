# ROMS Design System

> Visual language for all Flutter UI.  
> Implementation lives in `lib/core/theme/` and (target) `lib/core/widgets/` / future `roms_ui/`.  
> **No raw color/type/spacing literals in features** — tokens only.

---

## 1. System name

**ROMS Atelier** — operational luxury: calm surfaces, precise ink, one confident accent for action/urgency.

Evolves today’s Material-green tool UI into a commercial 2026 product language without looking like a template.

### Platform vs restaurant brand

| Layer | Owns |
|-------|------|
| **ROMS Atelier** | Platform chrome, tokens, components (restaurant-agnostic) |
| **RestaurantBrand** (`lib/core/theme/restaurant_brand.dart`) | Guest-facing name/tagline only |

Demo restaurant brand: **The Forest** (`id: demo-restaurant`). Swap `RestaurantBrand.current` for multi-tenant later — do not hardcode restaurant identity into platform widgets except via this API.

---

## 2. Foundations

### 2.1 Color

#### Brand & surfaces (light — primary product mode)

| Token | Hex | Role |
|-------|-----|------|
| `ink` | `#14201A` | Primary text, strongest UI chrome |
| `inkMuted` | `#5C6B63` | Secondary text, meta |
| `inkDisabled` | `#9AA69F` | Disabled |
| `canvas` | `#F3F5F2` | App background (cool sage-stone, not cream cliché) |
| `surface` | `#FFFFFF` | Cards, sheets, elevated panels |
| `surfaceRaised` | `#E8EDE9` | Inset wells, chips bg |
| `border` | `#D5DDD7` | Hairline structure |
| `borderStrong` | `#A8B5AD` | Focused / emphasized edges |
| `brand` | `#1F6B4A` | Primary actions, key brand moments (refined from `#2E7D32`) |
| `brandPressed` | `#175338` | Pressed primary |
| `brandSoft` | `#E3F2EA` | Soft brand fill |
| `accent` | `#C45C26` | Urgency / kitchen age / secondary CTA (refined from loud orange) |
| `accentSoft` | `#F8E8DE` | Soft accent fill |

#### Semantic

| Token | Hex | Use |
|-------|-----|-----|
| `success` | `#2F6F4E` | Available, paid, completed |
| `successSoft` | `#E4F3EB` | |
| `warning` | `#B86E14` | Occupied, waiting payment, aging ticket |
| `warningSoft` | `#FFF1DC` | |
| `danger` | `#B42318` | Errors, out of stock, destructive |
| `dangerSoft` | `#FCEBEA` | |
| `info` | `#1F5C8A` | Reserved, informational |
| `infoSoft` | `#E7F1F8` | |

#### Status mapping (restaurant)

| Domain status | Token |
|---------------|-------|
| Table available | `success` |
| Table occupied | `warning` |
| Table reserved | `info` |
| Batch / item preparing | `ink` / neutral |
| Item completed | `success` |
| Out of stock | `danger` |
| Payment pending | `warning` |
| Session closed | `inkMuted` |

#### Dark mode

Kitchen and optional staff night mode:

| Token | Hex |
|-------|-----|
| `canvas` | `#0E1210` |
| `surface` | `#1A211D` |
| `surfaceRaised` | `#243029` |
| `border` | `#334038` |
| `ink` | `#F2F5F3` |
| `inkMuted` | `#A8B5AD` |
| `brand` | `#3FA87A` |
| `accent` | `#E08A4F` |

Dark must reach **parity** with light (text, inputs, buttons, chips) — current dark theme is incomplete and must be finished as part of Design System implementation.

#### Rules

- Never use purple-indigo SaaS gradients as brand identity.
- Never use warm cream `#F4F1EA` + terracotta as the default “AI aesthetic.”
- Prefer flat surfaces + one soft elevation; avoid multi-layer glow.
- Semantic color is for **status**, not decoration.

**Migration note:** Map existing `AppColors` → new tokens in one theme PR; features keep using `AppColors.*` / `Theme.of(context)` after the map.

---

### 2.2 Typography

**Avoid** Roboto / Inter / Arial / system UI as the product voice.

| Role | Family (Flutter) | Fallback | Use |
|------|------------------|----------|-----|
| Display | **Fraunces** or **Newsreader** (soft serif) | `serif` | Brand moments, customer landing hero only |
| UI / body | **Plus Jakarta Sans** | `sans-serif` | All staff + customer ops UI |
| Mono / numbers | **IBM Plex Mono** (optional) | `monospace` | Bill totals, batch #, display numbers |

#### Scale (logical px)

| Token | Size | Weight | Line height |
|-------|------|--------|-------------|
| `displayLg` | 32 | 600 | 1.2 |
| `displayMd` | 28 | 600 | 1.2 |
| `titleLg` | 22 | 600 | 1.25 |
| `titleMd` | 18 | 600 | 1.3 |
| `titleSm` | 16 | 600 | 1.3 |
| `bodyLg` | 16 | 400 | 1.5 |
| `bodyMd` | 14 | 400 | 1.45 |
| `bodySm` | 13 | 400 | 1.4 |
| `labelLg` | 14 | 600 | 1.2 |
| `labelMd` | 12 | 600 | 1.2 |
| `labelSm` | 11 | 500 | 1.2 |
| `numLg` | 28 | 600 | 1.1 | tabular for money |

**Kitchen exception:** Prefer `titleMd+` and `numLg` for ticket headers; avoid dense `bodySm` for item names on KDS.

Register fonts in `pubspec.yaml`. Until registered, Plus Jakarta may temporarily fall back — do not ship Roboto as intentional brand.

---

### 2.3 Spacing (4pt grid)

Keep and extend `AppSpacing`:

| Token | Value |
|-------|------:|
| `xxs` | 2 |
| `xs` | 4 |
| `sm` | 8 |
| `md` | 12 |
| `lg` | 16 |
| `xl` | 24 |
| `xxl` | 32 |
| `xxxl` | 48 |

Aliases: `pagePadding = lg`, `cardPadding = md`, `sectionGap = xl`, `itemGap = sm`.

**Density modes:**

| Mode | Where | Adjust |
|------|-------|--------|
| Comfortable | Customer phone | Default scale |
| Compact | Cashier POS lists | `-4` vertical rhythm where safe |
| KDS | Kitchen display | Larger type, wider gutters, fewer chrome chrome |

---

### 2.4 Radius

| Token | Value | Use |
|------:|------:|-----|
| `xs` | 4 | Chips, tiny controls |
| `sm` | 8 | Inputs, small buttons |
| `md` | 12 | Cards, list rows |
| `lg` | 16 | Sheets, dialogs |
| `xl` | 24 | Hero panels (rare) |
| `full` | 999 | Avatars only — **not** every pill button |

Prefer `md` cards; avoid “rounded-full” pill clusters.

---

### 2.5 Elevation & shadow

| Level | Use |
|-------|-----|
| 0 | Flat on canvas |
| 1 | Cards (`AppShadows.sm`) — soft, single layer |
| 2 | Sheets / menus (`md`) |
| 3 | Rare modal emphasis (`lg`) |

No neon glow. Borders often replace shadow on light theme.

---

### 2.6 Iconography

- One family: **Lucide**-style or Material Symbols Outlined — pick one and stick.
- Stroke weight consistent (1.5–2px visual).
- Kitchen: prefer filled status indicators + short labels over icon-only mystery.

---

### 2.7 Motion

| Token | Duration | Curve | Use |
|-------|----------|-------|-----|
| `fast` | 120ms | easeOut | Press feedback |
| `normal` | 200ms | easeInOut | Tab / sheet present |
| `slow` | 320ms | easeInOut | Page hero only |

Rules:

- Motion clarifies **hierarchy or continuity**, never decoration.
- Kitchen: minimize motion; never delay tap-to-complete.
- Respect `disableAnimations` / reduce-motion when available.

Ship **2–3 intentional motions** per major journey (e.g. sheet present, status chip morph, confirm success) — not ambient particle noise.

---

### 2.8 Breakpoints & layouts

| Name | Min width | Typical device |
|------|----------:|----------------|
| `phone` | 0 | Guest handset |
| `phoneLg` | 428 | Large phone |
| `tablet` | 768 | Customer tablet / small POS |
| `pos` | 1024 | Cashier landscape |
| `kds` | 1280 | Kitchen display |
| `desktop` | 1440 | Manager (later) |

**Layout recipes:**

- Customer: single column, bottom-anchored cart CTA.
- Cashier: list + detail (master–detail from `tablet` up); stacked on phone.
- Kitchen: multi-column ticket rail from `kds`; single column fallback.

Nothing may overflow; use `ListView` / wrap; test landscape.

---

### 2.9 Theming API

```
ThemeExtension tokens → AppTheme.light / AppTheme.dark
features → Theme.of(context) / AppColors / AppSpacing / AppTypography
```

Future: restaurant white-label via `ThemeExtension` (brand + accent only), not per-screen forks.

---

## 3. Component visual states

Every interactive component documents:

`enabled · hovered/focused · pressed · loading · disabled · error`

Critical for buttons, inputs, list tiles, ticket cards.

---

## 4. Do / Don’t

| Do | Don’t |
|----|-------|
| One primary CTA per viewport | Rainbow status strips |
| Status color + text label | Color-only status |
| Tabular numbers for money | Decorative gradients behind ops UI |
| Shared tokens | One-off hex in widgets |
| Calm empty states | Lorem + construction emoji in prod |

---

## 5. Implementation checklist

- [ ] Remap `AppColors` / `AppDarkColors` to Atelier tokens
- [ ] Register Plus Jakarta (+ optional display/mono) in `pubspec.yaml`
- [ ] Complete dark `ThemeData` parity
- [ ] Align `AppTheme` buttons, inputs, cards, snackbars, dialogs
- [ ] Migrate feature raw Material widgets to system components (see `COMPONENT_LIBRARY.md`)

*Document version: 1.0 — Design Foundation*
