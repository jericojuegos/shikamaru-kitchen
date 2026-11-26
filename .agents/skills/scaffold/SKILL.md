---
name: scaffold
description: >-
  Execute Phase 0 Automated Mise en Place (docs/specs/00-scaffold/spec.md):
  scaffold the base project, configure design tokens from design-system.md,
  set up quota-friendly GitHub Actions CI, and dynamically generate the 0-token
  Mechanical Architecture Linter ("The Codebase Does the Reviewing"). Use when
  initializing a repo after /design or when the user invokes /scaffold.
---

# 🏗️ Skill: Automated *Mise en Place* & Mechanical Guardrails (`/scaffold`)

**Purpose:** Before crafting any Signature Feature, the foundation must be spotless. `/scaffold` automates all repetitive project setup (*mise en place*) and dynamically generates the **0-token Mechanical Architecture Linter** so future features cannot violate architectural boundaries or introduce bloated God-files.

---

## Step 1 — Read Foundation & `docs/specs/00-scaffold/spec.md`

1. Read `AGENTS.md`, `docs/foundation/architecture.md`, `docs/foundation/design-system.md`, and `.agents/rules/stack-rules.md`.
2. Check `docs/planning/roadmap.md` and mark `00-scaffold` as active (`[>]`).

---

## Step 2 — Scaffold Base Application, Design Tokens & Zero-Config Demo/Seed Mode

1. Scaffold the base application and test runner (`vitest`, `pytest`, `phpunit`, `go test`, `cargo test`, etc.) according to `docs/foundation/architecture.md` and `.agents/rules/stack-rules.md`.
2. Apply the exact color, typography, and spacing tokens from `docs/foundation/design-system.md` into the global theme/CSS config.
3. **Zero-Config In-App Demo & Seed Mode (`?demo=1` / Seed Fixture):**
   - Provide a deterministic seed/demo fixture (and graceful mock fallback when optional third-party API keys are absent) so reviewers, employers, and automated Browser QA (`/polish`) can explore the live app with realistic sample data in 1 click without hitting an empty database or hard API-key crash.

---

## Step 3 — Dynamically Generate the 0-Token Mechanical Architecture Linter ("The Codebase Does the Reviewing")

So AI agents never drift or ignore `.agents/rules/stack-rules.md`, dynamically write a fast (`< 50ms`), 0-dependency **Mechanical Architecture Linter** file directly inside the project's native test suite (e.g., `src/shared/__tests__/architecture.test.ts`, `tests/test_architecture.py`, `tests/Architecture/ArchitectureTest.php`, or `internal/arch_test.go`) that walks the source tree and **mechanically fails the test runner** on:
1. Cross-feature / cross-module internal imports (`features/<domain-a>` importing `<domain-b>`)
2. Server secret leaks or raw SQL inside presentation views/templates
3. Source files exceeding the **`300`-line Anti-Slop modularity cap**
4. Compiler/linter escape hatches (`@ts-ignore`, `@ts-expect-error`, `eslint-disable`, `: any`, `# type: ignore`, `# noqa`, `phpcs:ignore`, `@phpstan-ignore`)
5. Unfinished `TODO:` / `FIXME:` / `HACK:` placeholder comments in shipped code
6. **Test Integrity (Zero Test Tampering):** Forbid `.skip`, `.only`, `xit`, `@pytest.mark.skip` (without an explicit issue ref), and empty/assertion-less test blocks
7. **Anti-Slopsquatting & Lockfile Guard:** Fail if dependency manifests (`package.json`, `pyproject.toml`, `composer.json`) add unapproved packages not declared in `docs/foundation/` / `spec.md`, or drift out of sync with their lockfile

---

## Step 4 — Automatic GitHub Actions CI & Verification

1. If `.github/workflows/ci.yml` does not exist yet (and stealth `.git/info/exclude` is not active), copy `.agents/skills/scaffold/examples/github-ci.yml.template` → `.github/workflows/ci.yml` tailored to the project's test runner.
2. Run full terminal verification (`typecheck` + `test` + `build`).
3. Mark `00-scaffold` complete (`[x]`) in `docs/specs/00-scaffold/spec.md` and `docs/planning/roadmap.md`, create a clean commit (`chore(00-scaffold): complete base setup and mechanical architecture linter`), and prompt the user to run **`/prototype <01-first-feature>`**.
