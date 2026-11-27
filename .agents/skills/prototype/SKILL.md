---
name: prototype
description: >-
  Generate an interactive 4-State UI Prototype (docs/specs/<NN-feature-slug>/design-reference/preview.html
  + inline <agent-embed>) showing Happy, Empty, Loading Skeleton, and Error states BEFORE
  locking the unified feature spec (docs/specs/<NN-feature-slug>/spec.md), or run rapid
  post-review delta iterations. Use before building any feature or when the user invokes /prototype.
---

# 🧪 Skill: Interactive 4-State UI Prototyper & Unified Spec Author (`/prototype`)

**Purpose:** Cillian Myles' core law of software craft is that **you cannot know if a software design feels right until you interact with it**. Instead of writing 4 fragmented spec files and 1,500 lines of code blindly, `/prototype` builds an interactive **4-State UI Prototype (`preview.html` + `<agent-embed>`)** first, lets you tweak the UX flow in 30 seconds, and locks **1 unified, zero-drift `docs/specs/<NN-feature-slug>/spec.md` file** (`~72` lines).

---

## Step 1 — Identify Prototyping Mode

Check the user's request and `docs/planning/roadmap.md`:

- **Mode A (New Feature Prototype & Unified Spec):** Create or expand `docs/specs/<NN-feature-slug>/` with its interactive `design-reference/preview.html` prototype and unified `spec.md`.
- **Mode B (Iterative UX / Scope Refinement Delta):** You interacted with either `preview.html` or the live built feature and want to **adjust the UX flow, add an interaction, or simplify a screen**:
  1. Update the active truth in `spec.md` (Sections 1–2) and `design-reference/preview.html` in-place.
  2. Append a new delta section `### Iteration Wave N (<summary>)` in `spec.md` (Section 3: `- [ ] D1.1 ...`) without erasing completed `[x]` passes.
  3. Mark the feature `[>]` in `docs/planning/roadmap.md` ready for `/craft`.

---

## Step 2 — Read Foundation & Design System

1. Read `AGENTS.md`, `docs/foundation/architecture.md`, and `docs/foundation/design-system.md` (especially the **Anti-Slop Craft Manifesto** and color/typography tokens).
2. Inspect `docs/design-reference/`, `docs/foundation/design-reference/`, and `docs/specs/<NN-feature-slug>/design-reference/` if the user already dropped Figma/reference screenshots (`*.png` / `*.jpg`).

---

## Step 3 — Generate the Interactive 4-State UI Prototype (`design-reference/preview.html` + `<agent-embed>`)

For any feature with UI, interactive controls, or user-facing output:
1. Generate `docs/specs/<NN-feature-slug>/design-reference/preview.html` using the exact tokens from `docs/foundation/design-system.md`:
   - **Standard Web / App Screens:** Start from [`./resources/preview.html.template`](./resources/preview.html.template).
   - **WordPress `wp-admin` Plugin Screens:** Start from [`./resources/preview-wp-admin.html.template`](./resources/preview-wp-admin.html.template) — keep `#wpadminbar` and `#adminmenuwrap` strictly locked, modify only `#plugin-sidebar-slot` and `#plugin-content-slot`, and match the repo's WP UI layer (Classic `.wrap` + `.wp-list-table`, 2026 WP Design System `--wpds-*` + `@wordpress/dataviews`, or `@tangible/ui` `.tui-interface` + `--tui-*`).
2. **Mandatory 4-State Switcher in `preview.html`:**
   Every prototype MUST include a top switcher bar allowing the user to click between **4 live states**:
   - **`✨ Happy State`** (Realistic domain data — zero `"Lorem ipsum"` or `"Item 1"`)
   - **`🌱 Empty State`** (Empathetic onboarding guidance with a clear primary CTA)
   - **`⏳ Loading Skeleton State`** (Smooth shimmer skeleton / optimistic feedback — zero jarring layout shift)
   - **`🛟 Error Recovery State`** (Warm, actionable human recovery message)
3. **Embed Inline in Antigravity Chat (`<agent-embed>`):**
   When running inside Google Antigravity, also write the HTML preview to `<Artifact Directory Path>/prototype-<NN-feature-slug>-preview.html` (`UserFacing: true, RequestFeedback: false`) and embed it inline:
   ```html
   <agent-embed src="file:///<Artifact Directory Path>/prototype-<NN-feature-slug>-preview.html"></agent-embed>
   ```

---

## Step 4 — Lock the Single Unified Feature Spec (`docs/specs/<NN-feature-slug>/spec.md`)

Using [`./resources/spec.md.template`](./resources/spec.md.template), create **one** cohesive `docs/specs/<NN-feature-slug>/spec.md` (`~70–100` lines) containing all 4 sections:
1. **Section 1 — User Concept & EARS Acceptance Criteria:** Feature Tier (`✨ SIGNATURE CRAFT` or `⚙️ PLUMBING`), Assumptions (`A1`), numbered EARS criteria (`Req 1.1..N`), and unit-test invariants (`Property 1`, `Property 2`).
2. **Section 2 — Technical Design & File Placement:** Mermaid `flowchart TD` data flow and exact `[NEW]` / `[MODIFY]` file table within the feature's `Touches` isolation zone.
3. **Section 3 — The 3-Pass Implementation Plan (`/craft`):** Pass 1 (Domain & Unit Tests) → Pass 2 (Core Interactive UX) → Pass 3 (Micro-Interactions & Edge-Case Ergonomics).
4. **Section 4 — Verification Evidence & 4-Point Craft Audit (`/polish`):** Evidence proof table (`test:line` + `./evidence/*.png`) and the 4-Point Craft checklist.

---

## Step 5 — Present the Prototype Card

End `/prototype` with this concise card and the embedded interactive prototype:

```markdown
## 🧪 Interactive Prototype Ready: `<NN-feature-slug>` — [Feature Title]

| Dimension | Specification |
| :--- | :--- |
| **Feature Tier** | `[✨ SIGNATURE CRAFT (Full 3-Pass Craft + Human Sign-Off) OR ⚙️ PLUMBING (Fast Auto-Ship)]` |
| **Touches (Isolation Zone)** | `[e.g., src/features/editor/, e2e/editor.spec.ts]` |
| **4 States Included** | `✨ Happy · 🌱 Empathetic Empty · ⏳ Zero-CLS Skeleton · 🛟 Human Error Recovery` |
| **3-Pass Plan** | `Pass 1 (Domain + Tests) → Pass 2 (Interactive UI) → Pass 3 (Micro-Interactions & Ergonomics)` |

<agent-embed src="file:///<Artifact Directory Path>/prototype-<NN-feature-slug>-preview.html"></agent-embed>

> ✨ **Your Call:** Click through the 4 states in the prototype above! Reply with any UX/layout adjustments to update the prototype in 30 seconds, or run **`/craft <NN-feature-slug>`** to build Pass 1!
```
