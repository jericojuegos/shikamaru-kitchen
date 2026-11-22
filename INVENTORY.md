# 📦 `shikamaru-kitchen` — Master Inventory (`v1.0`)

> **Single Source of Truth** catalog of all stack packs, brigade rules, culinary lifecycle skills, and golden recipe templates in `shikamaru-kitchen`.

---

## 1. Master Kitchen Stack Packs (`stacks/`)

| Name | Folder | Stack | Architecture Pattern | Status |
|------|--------|-------|----------------------|--------|
| `nextjs-supabase` | `stacks/nextjs-supabase/` | Next.js 15+ · React 19 · TypeScript · Supabase (`@supabase/ssr`) · Vercel AI SDK v4+ | Pragmatic Feature-Driven Architecture (`src/features/[domain]/`) | ✅ Active — v1.0 |
| `python-fastapi` | `stacks/python-fastapi/` | Python 3.12+ · `uv` · FastAPI · Pydantic v2 · SQLAlchemy / Supabase · Pytest | Modular Domain Architecture (`app/modules/[domain]/`) | ✅ Active — v1.0 |
| `wp-modular-oop` | `stacks/wp-modular-oop/` | PHP 8.2+ · WordPress · REST API / AJAX · `$wpdb` · FSE Block Themes | Isolated Feature-Module OOP (`includes/modules/[feature]/`) | ✅ Active — v1.0 |

---

## 2. Brigade Rules (`core/rules/` & `stacks/*/rules/` → Synced to `.agents/rules/`)

| Component | Source Location | Project Location | Scope |
|-----------|-----------------|------------------|-------|
| **Kitchen Protocol** | `core/rules/kitchen-protocol.md` | `.agents/rules/kitchen-protocol.md` | Universal (5-stage `/menu` → `/prep` → `/taste` → `/cook` → `/plate` lifecycle, Signature Dish vs. House Staple triage, 3-Course cooking loop, 4-Star Culinary Craft Audit, 3-Strike rule) |
| **Stack Rules** | `stacks/[stack]/rules/stack-rules.md` | `.agents/rules/stack-rules.md` | Stack-specific (`<= 80` lines: strict layer boundaries, security rules, Food-Safety pre-commit checklist) |

---

## 3. Culinary Lifecycle Skills (`core/skills/` → Synced to `.agents/skills/`)

| Slash Command | Skill Folder | Bundled Resources / Templates | Purpose |
|---------------|--------------|-------------------------------|---------|
| **`/menu`** | `core/skills/menu/SKILL.md` | — | **Executive Chef Menu Designer:** 4-round interactive alignment to define Product Vision, **Signature Dishes** (high-craft differentiating UX) vs. **House Staples** (plumbing), **Taste System**, and the **Anti-Slop Manifesto** |
| **`/prep`** | `core/skills/prep/SKILL.md` | `examples/*` *(injected per stack)* | **Automated *Mise en Place*:** Scaffolds the base repository, configures design tokens & CI, and installs the **0-token Mechanical Architecture Linter** (`architecture.test.ts` / `test_architecture.py` / `ArchitectureTest.php`) |
| **`/taste`** | `core/skills/taste/SKILL.md` | `resources/{recipe,design,courses,plating}.md.template`, `resources/preview.html.template` | **The Tasting Spoon:** Generates a playable HTML/UI prototype (`design-reference/preview.html` + inline `<agent-embed>`) covering Happy, Empty, Loading, and Error states *before* locking `recipe.md`, `design.md`, and `courses.md` |
| **`/cook`** | `core/skills/cook/SKILL.md` | `examples/*` *(injected per stack)* | **Course-by-Course Station Craft:** Implements a dish in 3 structured courses (Course 1: Domain & Unit Tests → Course 2: Interactive UI + Live Chef Taste → Course 3: Micro-Interactions & Edge-Case Seasoning) |
| **`/plate`** | `core/skills/plate/SKILL.md` | — | **Michelin Plating & Chef Pass:** Runs deterministic Food Safety checks + **4-Star Culinary Craft Audit** + real browser proof screenshots (`evidence/*.png`), awaits final Chef sign-off, and serves to Git |

---

## 4. Golden Recipe & Mechanical Guardrail Templates (`stacks/*/skills/cook/examples/`)

| Stack | Template File | What It Enforces |
|-------|---------------|------------------|
| `core` (All Stacks) | `github-ci.yml.template` | Quota-friendly `.github/workflows/ci.yml` (`pull_request` + `push` on `main`/`master`) |
| `nextjs-supabase` | `architecture.test.ts.template` | **0-Token Mechanical Architecture Linter** (blocks cross-feature imports, `shared/ui` leaks, missing `server-only`, `> 300-line` God-files, `@ts-ignore`/`any`, and `TODO`/`FIXME` slop in `< 50ms`) |
| `nextjs-supabase` | `route-handler.ts.template` | Next.js 15+ Route Handler with `server-only`, `supabase.auth.getUser()`, and Zod `safeParse` |
| `nextjs-supabase` | `supabase-server.ts.template` | `@supabase/ssr` Server client (respects RLS) + Admin client (`import 'server-only'`) |
| `nextjs-supabase` | `rls-policies.sql.template` | User-scoped RLS policy, server-only table policy, signup trigger |
| `nextjs-supabase` | `feature.test.ts.template` | Vitest unit & invariant test skeleton (`src/features/[domain]/__tests__/`) |
| `python-fastapi` | `test_architecture.py.template` | **0-Token Mechanical Architecture Linter** (blocks cross-module imports, SQL in `router.py`, `> 300-line` files, `# type: ignore`/`# noqa`, and `TODO` slop) |
| `python-fastapi` | `test_ai_eval.py.template` | Pytest AI prompt & Pydantic v2 structured output eval suite (`tests/evals/`) |
| `wp-modular-oop` | `ArchitectureTest.php.template` | **0-Token Mechanical Architecture Linter** (enforces `ABSPATH` guards, zero `$wpdb` in `templates/`, `<= 350-line` cap, and zero `phpcs:ignore` or `TODO` slop) |
| `wp-modular-oop` | `plugin-main.php.template` | WordPress plugin header, constants, activation hooks, bootstrap |
| `wp-modular-oop` | `loader.php.template` | Centralized hook loader class |
| `wp-modular-oop` | `unit-test.php.template` | PHPUnit unit & invariant test skeleton (`tests/Unit/[Domain]/`) |
