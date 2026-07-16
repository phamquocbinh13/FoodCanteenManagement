```markdown
# ROMS DESIGN SYSTEM BIBLE v1.0
### Code: "Rainforest Sanctuary" • Systemic Visual Identity Specification

This document is the absolute source of truth for all visual, cryptographic, layout, and component styling transformations across the ROMS platform ecosystem. Every component, view, and theme file must strictly derive its properties from this specification.

---

## 1. Brand Essence & Vision Matrix

ROMS must never present itself as a transactional utility dashboard. It is an ambient digital extension of an elite hospitality space. 

| Metric | Legacy ERP / Standard POS | ROMS Paradigm |
| :--- | :--- | :--- |
| **Mood** | High Contrast, Cold, Intrusive | Calm, Soft Warmth, Cinematic |
| **Theme** | Glare-heavy White / Generic Dark Mode | Deep Rainforest Charcoal, Damp Cedar, Muted Gold |
| **Structure** | Cards, Box Borders, Dense Gridlines | Whitespace Pacing, Asymmetric Groupings |
| **Typography**| System Sans (Monolithic Weight) | Editorial Sizing, Monospaced Data Layouts |

---

## 2. Core Archetype Token Matrix

### Color System
All color configurations must map directly to these exact hex values. Do not introduce unauthorized mid-tones, gradients, or custom semantic hues.

```markdown
• Canvas (App Background Root) : #0A0F0D (Ultra-deep organic charcoal green)
• Surface (Primary Panel Base)  : #121815 (Soft muted moss stone)
• Surface Raised (Interactive) : #1A221E (Elevated layer catching ambient light)
• Ink Primary (High Focus Text) : #E6EBE7 (Warm alabaster white)
• Ink Muted (Low Focus Caption) : #829289 (Mist grey with green undertone)
• Brand (Primary Accent/Monogram): #C5A880 (Desaturated champagne gold)
• Accent (Secondary Flash/State): #BD6B42 (Damp earth terracotta)

```

### Semantic Status Handling

Do not use bright neon greens or glaring fire-engine reds. Semantic updates must remain quiet:

* **Success / Fulfilled:** Muted Sage Green (`#3F5E4D`)
* **Warning / Pending:** Soft Amber Sand (`#A88B5E`)
* **Alert / Critical:** Ochre Rust (`#9E473A`)

### Spacing & Layout Rhythm

Enforce spatial breathing. Avoid structural divider elements; use layout gaps exclusively.

* **xxs / xs :** `2.0px` / `4.0px` (Micro alignments, text to icon relationships)
* **sm / md  :** `8.0px` / `12.0px` (Inline item stacking padding)
* **lg / xl  :** `16.0px` / `24.0px` (Standard view inset boundaries, component grouping gutters)
* **xxl / xxxl:** `32.0px` / `48.0px` (Major structural canvas separations)

### Radii & Geometry

* **Elements (Inputs, Buttons):** `8.0px` constant curvature (`Radius.sm`)
* **Panels (Bottom Sheets, Master Containers):** `16.0px` smooth top curvature (`Radius.lg`)
* **Circular Elements:** `999.0px` (`Radius.full`)

---

## 3. Typography & Numerical Layout Architecture

Text styling must explicitly separate prose narrative from analytical operational numbers.

### Font Hierarchy

* **Display Text (Titles, Headers):** Clean, tracking-extended styling (`letterSpacing: 0.5`).
* **Body Copy:** Highly readable, natural line heights (`height: 1.45` to `1.5`).
* **Numerical Metrics:** **Must explicitly call tabular formatting features** (`fontFeatures: [FontFeature.tabularFigures()]`). This prevents interface layout jittering when financial numbers or balance variables mutate in real time.

---

## 4. Global Strategy for Token-Efficient Engineering

To drastically limit token use during implementation, coding agents **must not** perform line-by-line widget adjustments. Instead, all modifications must be cleanly injected directly into Flutter's central `ThemeData` architecture located inside `lib/core/theme/`.

### 1. The Global Decoration Strategy

* Set `scaffoldBackgroundColor` explicitly to the **Canvas Token** (`#0A0F0D`).
* Configure the global `CardTheme` and `DrawerTheme` color fields to use the **Surface Token** (`#121815`), ensuring all panel popups automatically adjust without explicit widget overrides.

### 2. The Input Field Strategy

* Define a centralized `InputDecorationTheme`.
* Completely eliminate `OutlineInputBorder` wrappers.
* Implement a clean `UnderlineInputBorder` layout utilizing `Ink Muted` as its baseline color, transitioning smoothly to `Brand Gold` exclusively during active text field focus events.

---

## 5. Asset Specifications & AI Engine Prompts

### Asset Matrix

```markdown
1. System Master Monogram Logo
   - Target Path: assets/images/common/logo_gold.webp
   - Aspect Ratio: 1:1
   - Constraints: Transparent backing layer, vector precision line-art execution.

2. Authentication Atmospheric Ambient Background
   - Target Path: assets/images/login/bg_ambience_forest.webp
   - Aspect Ratio: Native screen scale (vertical layout priority)
   - Configuration: Applied at 0.08 opacity within a Stack directly beneath the Canvas layout container.

```

### AI Creative Engine Prompt Architecture

#### Logo Prompt (`logo_gold.webp`)

> **Prompt:** A hyper-minimalist graphic design logo vector monogram of the letters "ROMS". Continuous thin line architecture seamlessly forming an abstract geometric leaf motif silhouette. Luxury brand styling, flat desaturated champagne gold color (#C5A880), solid dark background for extraction, no shadows, no gradients, clean premium Scandinavian line work style, 8k resolution.

#### Login Background Prompt (`bg_ambience_forest.webp`)

> **Prompt:** An atmospheric, cinematic shot inside a premium luxury restaurant hidden inside a damp rainforest at dusk. Warm moody lighting accentuating dark wood furniture, wet slate textures, soft candle glow reflecting on polished stone surfaces, rain mist drifting through large glass windows, minimalist organic design, out-of-focus background elements. Moody, expensive, quiet, timeless hospitality aesthetic, editorial architectural photography.

---

## 6. Global Acceptance Criteria

1. **Zero Structural Box Lines:** No card outlines, no explicitly colored borders between vertical list sections, and no grid separators. Spatial segregation must be achieved exclusively using clear spacing tokens.
2. **No Interface Glare:** The app must not render white screens, generic gray blocks, or high-saturation semantic alerts.
3. **Monospaced Balance Presentation:** Financial outputs must align cleanly by decimal positions across all checkout and session data modules.
4. **Preservation of Systems Logic:** All Riverpod state management workflows, user access levels, immutable batch processing loops, and database layers must remain untouched. The changes are strictly cosmetic overrides.

---

