---
name: prep
description: >-
  Execute Phase 0 Automated Mise en Place (docs/dishes/00-prep/courses.md):
  scaffold the base project, configure design tokens from taste-system.md,
  set up quota-friendly GitHub Actions CI, and install the 0-token Mechanical
  Architecture Linter ("The Codebase Does the Reviewing"). Use when initializing
  a repo after /menu or when the user invokes /prep.
---

# 🔪 Skill: Automated *Mise en Place* & Mechanical Guardrails (`/prep`)

**Purpose:** Before cooking any Signature Dish, the kitchen stations must be spotless. `/prep` automates all repetitive project setup (*mise en place*) and installs the **0-token Mechanical Architecture Linter** so future dishes cannot violate architectural boundaries.

---

## Step 1 — Read Foundation & `docs/dishes/00-prep/`

1. Read `AGENTS.md`, `docs/foundation/architecture.md`, and `docs/foundation/taste-system.md`.
2. Check `docs/planning/service-board.md` and mark `00-prep` as active (`[>]`).

---

## Step 2 — Scaffold Base Application & Golden Plumbing

1. Scaffold the base application according to the project stack (`nextjs-supabase`, `python-fastapi`, `wp-hexagonal`).
2. Copy canonical starter templates from `.agents/skills/cook/examples/` (e.g., `supabase-server.ts.template`, `rls-policies.sql.template`, `hexagonal-module.php.template`, `hexagonal-rest-provider.php.template`).
3. Apply the exact color, typography, and spacing tokens from `docs/foundation/taste-system.md` into the global theme/CSS config.

---

## Step 3 — Install the 0-Token Mechanical Architecture Linter ("Food Safety Inspector")

So AI agents never drift or ignore `.agents/rules/stack-rules.md`, copy the stack's **Mechanical Architecture Linter** from `.agents/skills/cook/examples/` directly into the project's test suite:

- **Next.js / TypeScript (`nextjs-supabase`):**
  Copy `architecture.test.ts.template` → `src/shared/__tests__/architecture.test.ts`
- **Python / FastAPI (`python-fastapi`):**
  Copy `test_architecture.py.template` → `tests/test_architecture.py`
- **WordPress Hexagonal (`wp-hexagonal`):**
  Copy `HexagonalArchitectureTest.php.template` → `tests/Architecture/HexagonalArchitectureTest.php`

This test runs automatically in `< 50ms` on every test run and mechanically blocks:
1. Cross-feature / cross-module internal imports
2. Server secret leaks (`SUPABASE_SERVICE_ROLE_KEY` without `import 'server-only'`) or missing `ABSPATH` guards
3. Files exceeding the `300`-line Anti-Slop modularity cap
4. Compiler/linter escape hatches (`@ts-ignore`, `eslint-disable`, `any`, `# type: ignore`, `phpcs:ignore`)
5. Unfinished `TODO:` / `FIXME:` / `HACK:` placeholder comments in shipped code

---

## Step 4 — Automatic GitHub Actions CI & Food Safety Verification

1. If `.github/workflows/ci.yml` does not exist yet (and stealth `.git/info/exclude` is not active), copy `.agents/skills/cook/examples/github-ci.yml.template` → `.github/workflows/ci.yml`.
2. Run full terminal verification:
   - **Next.js / TypeScript:** `pnpm tsc --noEmit && pnpm test --run && pnpm build`
   - **Python / FastAPI:** `uv run ruff check . && uv run pytest`
   - **WordPress / PHP:** `php -l` on all PHP files + `vendor/bin/phpunit`
3. Mark `00-prep` complete (`[x]`) in `docs/dishes/00-prep/courses.md` and `docs/planning/service-board.md`, create a clean commit (`chore(00-prep): complete mise en place and mechanical architecture guardrails`), and prompt the Chef to run **`/taste <01-first-dish>`**.
