---
name: taste
description: >-
  Generate an interactive "Tasting Spoon" UI prototype (docs/dishes/<NN-dish-slug>/design-reference/preview.html
  + inline <agent-embed>) showing Happy, Empty, Loading, and Error states BEFORE locking
  the unified dish recipe (docs/dishes/<NN-dish-slug>/recipe.md), or run rapid post-taste
  delta adjustments. Use before cooking any dish or when the user invokes /taste.
---

# 🥄 Skill: The Tasting Spoon & Unified Recipe Designer (`/taste`)

**Purpose:** Cillian Myles' core law of software craft is that **you cannot know if a software design tastes right until you feel and interact with it**. Instead of writing 4 fragmented spec files and 1,500 lines of code blindly, `/taste` builds an interactive **Tasting Spoon (`preview.html` + `<agent-embed>`)** first, lets the Head Chef adjust the flavor, and locks **1 unified, zero-drift `docs/dishes/<NN-dish-slug>/recipe.md` file** (`~80` lines).

---

## Step 1 — Identify Tasting Mode

Check the user's request and `docs/planning/service-board.md`:

- **Mode A (First Taste of a Dish):** Create or expand `docs/dishes/<NN-dish-slug>/` with its interactive `design-reference/preview.html` Tasting Spoon and unified `recipe.md`.
- **Mode B (Seasoning Adjustment / Re-Taste Delta):** The Chef tasted either `preview.html` or the live cooked feature and wants to **adjust the UX flow, add an interaction, or simplify a screen**:
  1. Update the active truth in `recipe.md` (Sections 1–2) and `design-reference/preview.html` in-place.
  2. Append a new delta section `### Re-Seasoning Wave N (<summary>)` in `recipe.md` (Section 3: `- [ ] S1.1 ...`) without erasing completed `[x]` courses.
  3. Mark the dish `[>]` on `docs/planning/service-board.md` ready for `/cook`.

---

## Step 2 — Read Foundation & Taste System

1. Read `AGENTS.md`, `docs/foundation/architecture.md`, and `docs/foundation/taste-system.md` (especially the **Anti-Slop Manifesto** and color/typography tokens).
2. Inspect `docs/dishes/<NN-dish-slug>/design-reference/` if the Chef already dropped Figma/reference screenshots (`*.png` / `*.jpg`).

---

## Step 3 — Serve the Interactive Tasting Spoon (`design-reference/preview.html` + `<agent-embed>`)

For any dish with UI, interactive controls, or user-facing output:
1. Generate `docs/dishes/<NN-dish-slug>/design-reference/preview.html` from [`./resources/preview.html.template`](./resources/preview.html.template) using the exact tokens from `docs/foundation/taste-system.md`.
2. **Mandatory 4-State Tasting Switcher in `preview.html`:**
   Every Tasting Spoon prototype MUST include a small top bar allowing the Chef to click between **4 live states**:
   - **`✨ Happy State`** (Realistic domain data — zero `"Lorem ipsum"` or `"Item 1"`)
   - **`🌱 Empty State`** (Empathetic onboarding guidance with a clear primary CTA)
   - **`⏳ Loading / Optimistic State`** (Smooth shimmer skeleton / optimistic feedback — zero jarring layout shift)
   - **`🛟 Error Recovery State`** (Warm, actionable human recovery message)
3. **Embed Inline in Antigravity Chat (`<agent-embed>`):**
   When running inside Google Antigravity, also write the HTML preview to `<Artifact Directory Path>/taste-<NN-dish-slug>-preview.html` (`UserFacing: true, RequestFeedback: false`) and embed it inline:
   ```html
   <agent-embed src="file:///<Artifact Directory Path>/taste-<NN-dish-slug>-preview.html"></agent-embed>
   ```

---

## Step 4 — Lock the Single Unified Dish Recipe (`docs/dishes/<NN-dish-slug>/recipe.md`)

Using [`./resources/recipe.md.template`](./resources/recipe.md.template), create **one** cohesive `docs/dishes/<NN-dish-slug>/recipe.md` (`~80–110` lines) containing all 4 sections:
1. **Section 1 — Dish Concept & EARS Recipe Criteria:** Dish Category (`👨‍🍳 SIGNATURE DISH` or `🔪 HOUSE STAPLE`), Assumptions (`A1`), numbered EARS criteria (`Req 1.1..N`), and unit-test invariants (`Property 1`, `Property 2`).
2. **Section 2 — Station Architecture & File Placement:** Mermaid `flowchart TD` data flow and exact `[NEW]` / `[MODIFY]` file table within the station's isolation zone.
3. **Section 3 — The 3-Course Cooking Plan (`/cook`):** Course 1 (Domain & Unit Tests) → Course 2 (Core Interactive UX) → Course 3 (Micro-Interactions & Edge-Case Seasoning).
4. **Section 4 — Michelin Plating Evidence & 4-Star Craft Audit (`/plate`):** Evidence proof table (`test:line` + `./evidence/*.png`) and the 4-Star Craft checklist.

---

## Step 5 — Present the Chef Tasting Card

End `/taste` with this concise card and the embedded Tasting Spoon:

```markdown
## 🥄 Tasting Spoon Ready: `<NN-dish-slug>` — [Dish Title]

| Dimension | Dish Specification |
| :--- | :--- |
| **Dish Category** | `[👨‍🍳 SIGNATURE DISH (Full 3-Course Craft + Chef Pass) OR 🔪 HOUSE STAPLE (Fast Prep)]` |
| **Station (Touches)** | `[e.g., src/features/editor/, e2e/editor.spec.ts]` |
| **4 States Included** | `✨ Happy · 🌱 Empathetic Empty · ⏳ Zero-CLS Skeleton · 🛟 Human Error Recovery` |
| **3-Course Plan** | `Course 1 (Domain + Tests) → Course 2 (Interactive UI) → Course 3 (Micro-Craft & Seasoning)` |

<agent-embed src="file:///<Artifact Directory Path>/taste-<NN-dish-slug>-preview.html"></agent-embed>

> 👨‍🍳 **Chef's Call:** Click through the 4 states in the Tasting Spoon above! Reply with any flavor/UX adjustments to re-taste in 30 seconds, or run **`/cook <NN-dish-slug>`** to fire Course 1!
```
