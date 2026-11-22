---
name: cook
description: >-
  Execute the 3-Course Cooking Loop for a dish in docs/dishes/<NN-dish-slug>/courses.md
  (Course 1: Domain & Unit Tests -> Course 2: Core Interactive Experience -> Course 3:
  Micro-Interactions & Edge-Case Seasoning) using golden stack templates and atomic
  checkpoint commits. Use when implementing a feature/dish or when the user invokes /cook.
---

# 🍳 Skill: 3-Course Station Craft Builder (`/cook`)

**Purpose:** Never dump an entire feature as one giant unverified block of code. `/cook` executes a dish from `docs/dishes/<NN-dish-slug>/courses.md` across **3 structured Courses**, running deterministic Food Safety checks (`tsc`, unit tests, and the 0-token Mechanical Architecture Linter) after every course.

---

## Step 1 — Prep Station & Auto-Branch Guard

1. Read `docs/planning/service-board.md`, `AGENTS.md`, `docs/foundation/taste-system.md`, and `.agents/rules/stack-rules.md`.
2. **If `00-prep` is not yet `[x]`:** Run **`/prep`** (`../prep/SKILL.md`) first.
3. **If `docs/dishes/<NN-dish-slug>/recipe.md` or `design-reference/preview.html` does not exist yet:** Run **`/taste <NN-dish-slug>`** (`../taste/SKILL.md`) first so the Chef can sample the Tasting Spoon before cooking starts.
4. **Automatic Feature Branch Guard:**
   - Check `git branch --show-current`. If on `main`, `master`, or `develop`, automatically create and switch to `feat/<NN-dish-slug>` before touching any code.
   - Mark the dish `[>]` on `docs/planning/service-board.md`.

---

## Step 2 — Cook Course 1: Domain Engine, Data & Unit Tests (`[BE]`)

1. Mark Course 1 tasks (`1.1`..`1.4`) active (`[>]`) in `docs/dishes/<NN-dish-slug>/recipe.md` (Section 3).
2. Adapt golden templates from `.agents/skills/cook/examples/` (`route-handler.ts.template`, `feature.test.ts.template`, `hexagonal-unit-test.php.template`, etc.).
3. Implement schemas, domain validation, and server handlers strictly inside the dish's assigned `Station (Touches)` paths.
4. Write and run mandatory unit/invariant tests covering `Property 1` (happy path) and `Property 2` (invalid/unauthorized rejection), **plus the 0-Token Mechanical Architecture Linter** (`pnpm tsc --noEmit && pnpm test --run` / `uv run pytest` / `vendor/bin/phpunit`).
5. Mark Course 1 `[x]` in `recipe.md` and create an atomic checkpoint commit:
   ```bash
   git add <course-1-touched-files>
   git commit -m "feat(<dish-slug>): cook course 1 domain engine and unit tests"
   ```

---

## Step 3 — Cook Course 2: Core Interactive Experience (`[FE]`)

1. Mark Course 2 tasks (`2.1`..`2.3`) active (`[>]`) in `docs/dishes/<NN-dish-slug>/recipe.md` (Section 3).
2. Read `docs/dishes/<NN-dish-slug>/design-reference/preview.html` (and any `.png` references) plus `docs/foundation/taste-system.md`.
3. Build the modular UI components (`<= 250` lines per file) and wire real data flow.
4. Verify build & types (`pnpm tsc --noEmit && pnpm build` / `php -l`) and create the Course 2 checkpoint commit:
   ```bash
   git add <course-2-touched-files>
   git commit -m "feat(<dish-slug>): cook course 2 core interactive experience"
   ```
5. **Mid-Cook Chef Taste Option (For `👨‍🍳 SIGNATURE DISH` when `--pause-mid-cook` is requested):**
   If the Chef asked to taste mid-cook, share the localhost URL after Course 2 before applying Course 3 seasoning; otherwise proceed seamlessly into Course 3!

---

## Step 4 — Cook Course 3: Micro-Interactions, Keyboard Flow & Edge-Case Seasoning (`[CRAFT]`)

This course is what separates a **Michelin Kitchen** from a generic Software Factory:
1. Mark Course 3 tasks (`3.1`..`3.3`) active (`[>]`) in `docs/dishes/<NN-dish-slug>/courses.md`.
2. **Apply the 4 Michelin Seasonings:**
   - **Micro-States & Zero CLS:** Add instant hover/active/disabled states, loading spinners on in-flight buttons (preventing double-submit), and dimensions-matched loading skeletons so layout shift is `0`.
   - **Empathetic Empty & Error States:** Ensure empty states guide the user with a warm message and primary action button; ensure error banners preserve user input and explain how to recover.
   - **Keyboard Ergonomics:** Wire `Enter` to submit, `Escape` to close modals/popovers, sensible initial focus, and visible `focus-visible` rings.
   - **Golden-Path E2E Spec (For Signature Dishes):** Write or update `e2e/<dish-slug>.spec.ts` using accessible selectors (`getByRole`, `getByLabel`).
3. Run full verification (`pnpm tsc --noEmit && pnpm test --run && pnpm build`), mark Course 3 `[x]`, create the Course 3 checkpoint commit, and immediately hand off to **`/plate`** (`../plate/SKILL.md`).
