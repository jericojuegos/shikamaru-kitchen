---
name: craft
description: >-
  Execute the 3-Pass Implementation Loop for a feature in docs/specs/<NN-feature-slug>/spec.md
  (Pass 1: Domain & Unit Tests -> Pass 2: Core Interactive Experience -> Pass 3:
  Micro-Interactions & Edge-Case Ergonomics) with 0-token Mechanical Architecture Linter
  verification and atomic checkpoint commits. Use when building a feature or when the user
  invokes /craft.
---

# 🛠️ Skill: 3-Pass Guided Implementation Builder (`/craft`)

**Purpose:** Never dump an entire feature as one giant unverified block of code. `/craft` builds a feature from `docs/specs/<NN-feature-slug>/spec.md` across **3 structured Passes**, running deterministic checks (`typecheck`, unit tests, and the 0-token Mechanical Architecture Linter) after every pass.

---

## Step 1 — Check Prerequisites & Auto-Branch Guard

1. Read `docs/planning/roadmap.md`, `AGENTS.md`, `docs/foundation/design-system.md`, and `.agents/rules/stack-rules.md`.
2. **If `00-scaffold` is not yet `[x]`:** Run **`/scaffold`** (`../scaffold/SKILL.md`) first.
3. **If `docs/specs/<NN-feature-slug>/spec.md` or `design-reference/preview.html` does not exist yet:** Run **`/prototype <NN-feature-slug>`** (`../prototype/SKILL.md`) first so the user can interact with the 4-state UI prototype before coding starts.
4. **Automatic Feature Branch Guard:**
   - Check `git branch --show-current`. If on `main`, `master`, or `develop`, automatically create and switch to `feat/<NN-feature-slug>` before touching any code.
   - Mark the feature `[>]` in `docs/planning/roadmap.md`.

---

## Step 2 — Execute Pass 1: Domain Engine, Data & Unit Tests (`[BE]`)

1. Mark Pass 1 tasks (`1.1`..`1.4`) active (`[>]`) in `docs/specs/<NN-feature-slug>/spec.md` (Section 3).
2. Implement schemas, domain validation, and server handlers strictly inside the feature's assigned `Touches (Isolation Zone)` paths.
3. Write and run mandatory unit/invariant tests covering `Property 1` (happy path) and `Property 2` (invalid/unauthorized rejection), **plus the 0-Token Mechanical Architecture Linter** (`pnpm tsc --noEmit && pnpm test --run` / `uv run pytest` / `vendor/bin/phpunit`).
4. Mark Pass 1 `[x]` in `spec.md` and create an atomic checkpoint commit:
   ```bash
   git add <pass-1-touched-files>
   git commit -m "feat(<feature-slug>): pass 1 domain engine and unit tests"
   ```

---

## Step 3 — Execute Pass 2: Core Interactive Experience (`[FE]`)

1. Mark Pass 2 tasks (`2.1`..`2.3`) active (`[>]`) in `docs/specs/<NN-feature-slug>/spec.md` (Section 3).
2. Read `docs/specs/<NN-feature-slug>/design-reference/preview.html` (and any `.png` references) plus `docs/foundation/design-system.md`.
3. Build modular UI components (`<= 250` lines per file) and wire real data flow.
4. Verify build & types (`pnpm tsc --noEmit && pnpm build` / `php -l`) and create the Pass 2 checkpoint commit:
   ```bash
   git add <pass-2-touched-files>
   git commit -m "feat(<feature-slug>): pass 2 core interactive experience"
   ```

---

## Step 4 — Execute Pass 3: Micro-Interactions, Keyboard Flow & Edge-Case Ergonomics (`[CRAFT]`)

This pass is what separates a **Michelin-Grade Software Kitchen** from a generic Software Factory:
1. Mark Pass 3 tasks (`3.1`..`3.3`) active (`[>]`) in `docs/specs/<NN-feature-slug>/spec.md` (Section 3).
2. **Apply the 4 Craft Refinements:**
   - **Micro-States & Zero CLS:** Add instant hover/active/disabled states, loading spinners on in-flight buttons (preventing double-submit), and dimensions-matched loading skeletons so layout shift is `0`.
   - **Empathetic Empty & Error States:** Ensure empty states guide the user with a clear message and primary action button; ensure error banners preserve user input and explain how to recover.
   - **Keyboard Ergonomics:** Wire `Enter` to submit, `Escape` to close modals/popovers, sensible initial focus, and visible `focus-visible` rings.
   - **Golden-Path E2E Spec (For Signature Craft Features):** Write or update `e2e/<feature-slug>.spec.ts` using accessible selectors (`getByRole`, `getByLabel`).
3. Run full verification (`typecheck` + `test` + `build`), mark Pass 3 `[x]`, create the Pass 3 checkpoint commit, and immediately hand off to **`/polish`** (`../polish/SKILL.md`).
