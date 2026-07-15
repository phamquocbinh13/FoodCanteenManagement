# ROMS Component Library

> Catalog of reusable UI.  
> **Rule:** Prefer extending this library over inventing feature-local lookalikes.  
> Target home: `lib/core/widgets/` (today) → evolve toward `roms_ui/` per `ARCHITECTURE.md` without breaking imports overnight.

---

## 1. Status legend

| Status | Meaning |
|--------|---------|
| **Exists** | In repo; may need Atelier restyle |
| **Extend** | Exists but missing states/variants |
| **Add** | Must build before or during redesign iterations |
| **Feature** | Role-specific; OK to keep under `features/*/widgets` if not duplicated |

---

## 2. Foundations (non-widget)

| Token module | Path | Status |
|--------------|------|--------|
| Colors | `lib/core/theme/app_colors.dart` | Extend → Atelier map |
| Typography | `lib/core/theme/app_typography.dart` | Extend → new families |
| Spacing | `lib/core/theme/app_spacing.dart` | Exists |
| Radius | `lib/core/theme/app_radius.dart` | Exists |
| Shadows | `lib/core/theme/app_shadows.dart` | Exists |
| ThemeData | `lib/core/theme/app_theme.dart` | Extend (dark parity) |
| Money format | `lib/shared/formatters/money_formatter.dart` | Exists |

---

## 3. Core primitives

### 3.1 Buttons

| Component | Path | Status | Use when |
|-----------|------|--------|----------|
| `PrimaryButton` | `lib/core/widgets/buttons/` | Extend | One primary action |
| `SecondaryButton` | same | Extend | Secondary / cancel |
| `RomsTextButton` | — | **Add** | Tertiary inline |
| `RomsIconButton` | — | **Add** | Toolbar actions; require tooltip |
| `RomsDangerButton` | — | **Add** | Destructive confirm |

**States:** enabled, pressed, loading, disabled. Min height 48.

### 3.2 Inputs

| Component | Path | Status | Use when |
|-----------|------|--------|----------|
| `SearchField` | `lib/core/widgets/inputs/` | Extend | Menu search |
| `RomsTextField` | — | **Add** | Login, notes, codes |
| `RomsQtyStepper` | — | **Add** | Cart quantity |
| `RomsSegmentedControl` | — | **Add** | Kitchen Orders/Inventory (replace ad-hoc) |

### 3.3 Surfaces

| Component | Path | Status | Use when |
|-----------|------|--------|----------|
| `AppCard` | `lib/core/widgets/cards/` | Extend | Interactive grouped content only |
| `AppScaffold` | `lib/core/widgets/layout/` | Extend | Standard page chrome |
| `StaffScaffold` | `lib/shared/presentation/staff_scaffold.dart` | Extend | Staff role pages + logout |
| `RomsPageHeader` | — | **Add** | Title + subtitle + actions |
| `RomsSplitView` | — | **Add** | Cashier master–detail ≥ tablet |

### 3.4 Feedback

| Component | Path | Status | Use when |
|-----------|------|--------|----------|
| `EmptyState` | `lib/core/widgets/feedback/` | Extend | Empty lists/queues |
| `ErrorState` | same | Extend | Recoverable failures + retry |
| `LoadingIndicator` | same | Extend | Inline / blocking variants |
| `StatusChip` | same | Extend | Table/session/item status |
| `RomsSkeleton` | — | **Add** | Catalog / queue first load |
| `RomsSnackbar` | — | **Add** (theme wrapper) | Transient feedback |

### 3.5 Display

| Component | Path | Status | Use when |
|-----------|------|--------|----------|
| `AppAvatar` | `lib/core/widgets/display/` | Exists | Staff avatar (rare) |
| `RomsMoneyText` | — | **Add** | Consistent money + tabular figures |
| `RomsSessionBadge` | — | **Add** | Display # + phase |
| `RomsTableLabel` | — | **Add** | Table name/status pair |

---

## 4. Overlays

| Component | Status | Use when |
|-----------|--------|----------|
| `RomsBottomSheet` | **Add** | Cart, customize, filters |
| `RomsDialog` | **Add** | Payment confirm, force close |
| `RomsActionSheet` | **Add** | Mobile secondary actions |

Feature sheets today (`cart_bottom_sheet`, `customize_sheet`) should **consume** these shells after extraction.

---

## 5. Feature components (keep local, don’t duplicate)

### Kitchen — `lib/features/kitchen/presentation/widgets/`

| Widget | Status | Notes |
|--------|--------|-------|
| `KitchenBatchCard` | Feature → restyle | Ticket card pattern |
| `KitchenItemTile` | Feature → restyle | Large complete target |
| `KitchenOrdersTab` | Feature | |
| `KitchenInventoryTab` / `Tile` | Feature | |
| `KitchenSegmentedTabs` | Feature → migrate to `RomsSegmentedControl` | |
| `ElapsedTimeText` | Feature / promote | Isolate timer rebuilds — promote to core if reused |

### Customer

| Widget | Status | Notes |
|--------|--------|-------|
| `CartBottomSheet` | Feature → shell extract | |
| `CustomizeSheet` | Feature → shell extract | |
| `CartOrderingMessages` | Feature | Copy constants |
| `CustomerDemoExitButton` | Feature | **Remove from prod** or debug-gate |

### Cashier

| Widget | Status | Notes |
|--------|--------|-------|
| `SessionQrDisplay` | Feature → restyle | Large QR, calm chrome |

### Requests

| Widget | Status | Notes |
|--------|--------|-------|
| `StaffRequestTile` | Feature → restyle | Shared cashier preview |

### Shared stubs

| Widget | Path | Status |
|--------|------|--------|
| `PlaceholderPage` | `lib/shared/presentation/placeholder_page.dart` | Keep for non-Phase-1 routes only |

---

## 6. Intended use matrix

| Need | Use | Don’t use |
|------|-----|-----------|
| Primary action | `PrimaryButton` | Raw `ElevatedButton` with custom colors |
| Status | `StatusChip` | Colored `Text` only |
| Empty queue | `EmptyState` | Centered “No data” |
| Page with logout | `StaffScaffold` | One-off AppBars |
| Money | `RomsMoneyText` / formatter | Ad-hoc string concat |
| Destructive | `RomsDangerButton` + dialog | Red primary everywhere |

---

## 7. Contribution rules

1. New visual pattern used twice → extract to core.
2. New component ships with: docs row here + theme tokens + loading/disabled/error if interactive.
3. No feature may define private color constants.
4. Prefer composition (`RomsBottomSheet` + body) over inheritance.
5. Golden/widget tests for core primitives when behavior is non-trivial (loading, disabled).

---

## 8. Build order (components)

Aligned with `UI_ROADMAP.md`:

1. Theme token remap + typography  
2. Button / field / chip / skeleton parity  
3. Sheet + dialog shells  
4. Money + session/table badges  
5. Split view (cashier)  
6. Migrate kitchen/customer feature widgets onto shells  

*Document version: 1.0 — Design Foundation*
