---
trigger: always_on
description: Universal Michelin Kitchen Protocol — 5-Stage Culinary Brigade (/menu -> /prep -> /taste -> /cook -> /plate), Tasting Spoon First, 3-Course Station Craft, 4-Star Culinary Audit, and Mechanical Food-Safety Guardrails
---

# 👨‍🍳 Rule: Michelin Kitchen Execution Protocol (`kitchen-protocol.md`)

**Purpose:** High-craft, taste-driven software engineering. Automate the repetitive *mise en place* (`/prep`) and enforce 0-token mechanical food-safety checks so the human **Executive Chef** can focus on **interactive prototyping (`/taste`), course-by-course craft (`/cook`), and 4-star plating (`/plate`)**.

---

## 1. The Kitchen Brain (`docs/`) & Brigade Engine (`.agents/`)

Every project managed by `shikamaru-kitchen` separates **Culinary Foundation**, **Service Board**, **Dish Recipes**, and the **`.agents/` Brigade Engine**:

1. **Culinary Foundation (`docs/foundation/`):**
   - `menu-vision.md` — Product thesis, target diners (users), and **Signature Dishes vs. House Staples**.
   - `architecture.md` — Station boundaries, folder layout, and dependency rules.
   - `taste-system.md` — Typography, color tokens, motion rules, copy voice, and the **Anti-Slop Manifesto** (explicitly banned generic AI UI/code patterns).
   - `decisions.md` — Architectural Decision Records (ADRs).
2. **Service Board (`docs/planning/`):**
   - `service-board.md` — The master menu roadmap classifying every dish as **`👨‍🍳 SIGNATURE DISH`** (core differentiating UX) or **`🔪 HOUSE STAPLE`** (infrastructure/CRUD plumbing), along with `Wave`, `Depends On`, and `Station (Touches)` paths.
   - `issues.md` — Kitchen retrospective & self-healing incident log.
3. **Dish Folders (`docs/dishes/<NN-dish-slug>/`):**
   - `design-reference/preview.html` — **The Tasting Spoon:** Playable HTML/Tailwind prototype (`<agent-embed>`) showing Happy, Empty, Loading, and Error states *before* production code is cooked.
   - `recipe.md` — Assumptions (`A1`), Glossary, User Stories, and numbered EARS Acceptance Criteria (`Req 1.1`, `Req 1.2`).
   - `design.md` — Mermaid data-flow diagram, exact `[NEW]` / `[MODIFY]` files, Data Models, and Error Handling Matrix.
   - `courses.md` — 3-Course implementation plan (**Course 1: Domain & Unit Tests**, **Course 2: Core Interactive UX**, **Course 3: Micro-Interactions & Edge-Case Seasoning**).
   - `plating.md` — Food Safety verification + **4-Star Culinary Craft Audit** + `evidence/*.png` browser proof.
4. **Brigade Engine (`.agents/`):**
   - `.agents/rules/` — Always-on guardrails (`kitchen-protocol.md` + `stack-rules.md`)
   - `.agents/skills/` — 5 Culinary Lifecycle Skills:
     - [`menu/SKILL.md`](../skills/menu/SKILL.md) (`/menu`) — Executive Chef Menu & Taste System Designer
     - [`prep/SKILL.md`](../skills/prep/SKILL.md) (`/prep`) — Automated *Mise en Place* & Mechanical Linter Setup
     - [`taste/SKILL.md`](../skills/taste/SKILL.md) (`/taste`) — Interactive Tasting Spoon Prototyper & Recipe Locker
     - [`cook/SKILL.md`](../skills/cook/SKILL.md) (`/cook`) — 3-Course Guided Implementation Engine
     - [`plate/SKILL.md`](../skills/plate/SKILL.md) (`/plate`) — Food Safety + 4-Star Culinary Craft Audit & Serve

---

## 2. Signature Dishes (`👨‍🍳 SIGNATURE`) vs. House Staples (`🔪 STAPLE`)

Not every feature deserves the same ceremony. Triage every item on `docs/planning/service-board.md`:

| Dish Category | Examples | `/taste` & `/cook` Behavior | `/plate` Behavior |
| :--- | :--- | :--- | :--- |
| **`🔪 HOUSE STAPLE`** *(Prep Cook Automation)* | `00-prep` scaffold, DB migrations, auth middleware, standard CRUD endpoints, webhooks, background jobs. | **Fast Prep Execution:** AI Prep Cooks execute all courses back-to-back using golden templates from `.agents/skills/cook/examples/`. | **Auto-Plate on Green Food Safety:** Once types, unit tests, and the Mechanical Architecture Linter pass, commit atomically and mark `[x]` on `service-board.md`. |
| **`👨‍🍳 SIGNATURE DISH`** *(Executive Chef Craft)* | Core Product Value Loop, differentiating UI/UX, interactive editors/canvases, novel domain algorithms. | **Mandatory Tasting Spoon First:** Must generate `design-reference/preview.html` (`<agent-embed>`) during `/taste` and pause after **Course 2** during `/cook` for a live localhost taste check. | **4-Star Craft Audit + Chef Pass Gate:** Runs the full **4-Star Culinary Craft Audit**, captures `evidence/*.png`, and pauses at **`👨‍🍳 READY FOR CHEF PASS`** for human tasting before marking `[x]`. |

---

## 3. The 3-Course Cooking Loop (`/cook`)

Never dump a 1,500-line feature in a single unverified turn. Every dish in `docs/dishes/<NN-dish-slug>/courses.md` is cooked across **3 Courses**:

1. **Course 1 — Domain Engine, Data & Unit Tests (`[BE]`):**
   - Build pure domain logic, schemas, and server handlers within the station's isolation zone.
   - Write and pass mandatory unit/invariant tests (`Property 1` happy path + `Property 2` invalid/unauthorized rejection) and the **0-Token Mechanical Architecture Linter**.
   - Create an atomic Git checkpoint commit (`feat(<dish-slug>): course 1 domain and unit tests`).
2. **Course 2 — Core Interactive Experience (`[FE]`):**
   - Implement the primary UI components matching `design-reference/preview.html` and `docs/foundation/taste-system.md`.
   - For **`👨‍🍳 SIGNATURE DISH`** features in interactive sessions: pause briefly for a **Mid-Cook Tasting Check** so the Chef can feel the core interaction before final seasoning.
3. **Course 3 — Seasoning, Micro-Interactions & Edge-Case Empathy (`[CRAFT]`):**
   - Layer in instantaneous hover/active/loading feedback, zero-CLS skeletons, keyboard ergonomics (`Enter`, `Escape`, focus rings), and human-empathetic empty/error states.
   - Run full terminal verification and hand off to **`/plate`**.

---

## 4. The Inverse Trust Pyramid & 4-Star Culinary Craft Standard

Inspired by Lauren Tan's *Inverse Trust Pyramid* and Cillian Myles' *Michelin Kitchen*:

1. **Layer 1 — Mechanical Food Safety (0-Token Deterministic Code Constraints):**
   - The test runner enforces architecture boundaries (`architecture.test.ts` / `ArchitectureTest.php` / `test_architecture.py`), blocking cross-feature imports, missing `server-only`/`ABSPATH` guards, files `> 300` lines, `@ts-ignore`/`any` escape hatches, and unfinished `TODO:`/`FIXME:` placeholders.
2. **Layer 2 — Runtime & Visual Evidence ("Test-Before-Notify"):**
   - Never use the Head Chef as a first-pass functional QA tester. Drive the real browser (via Playwright or `flash` Browser QA subagent), verify zero console/network errors, and save proof screenshots to `docs/dishes/<NN-dish-slug>/evidence/*.png`.
3. **Layer 3 — The 4-Star Culinary Craft Audit (During `/plate`):**
   - ⭐ **Star 1 (Micro-Interactions & Visual Stability):** Instant hover/active/disabled/loading states; zero jarring layout shift (CLS).
   - ⭐ **Star 2 (Copy, Empty & Error Empathy):** Empty states guide the diner to the next action; error messages explain how to recover in warm, human language.
   - ⭐ **Star 3 (Keyboard & Ergonomic Flow):** Logical `Tab` order, `Enter` to submit, `Escape` to close modals, visible focus rings.
   - ⭐ **Star 4 (Idiomatic Code Craft):** Zero bloated God-components (`<= 300` lines); clean separation of state, domain logic, and presentation.

---

## 5. Kitchen Safety: Budget Guard, 3-Strike Rule & Automatic Self-Healing

### Budget Guard (Pause & Ask the Chef)
Pause and ask for confirmation (`"⚠️ KITCHEN GUARD TRIGGERED: [reason]. Awaiting Chef approval..."`) before:
1. Touching **more than 4 files** in a single course unless defined as a coupled course in `courses.md`.
2. Deleting files, dropping database tables/columns, or modifying shared contracts (`shared/types/`) without running `/taste` (Blast-Radius Check).

### The 3-Strike Rule (Stop Burning the Dish)
If the same error persists after **3 fix attempts**:
1. **STOP** immediately — never attempt a 4th blind retry.
2. **REPORT** the exact error, the 3 approaches tried, and why each failed.
3. **CALL THE CHEF** for guidance.

### 5.1 Automatic Kitchen Self-Healing (After Any Bug Fix or Chef Correction)
Whenever you fix a bug or receive a taste/code correction from the user, automatically execute before ending your turn:
1. **Executable Regression Test & Mechanical Linter Rule:** Add a unit test reproducing the bug, and if it was a structural/slop pattern, encode it into `architecture.test.ts` / `ArchitectureTest.php` / `test_architecture.py`.
2. **Taste System / Project Guardrail:** Add a 1-line rule to `AGENTS.md` or `docs/foundation/taste-system.md` (Anti-Slop Manifesto) so future courses never repeat it.
3. **Kitchen Issue Log:** Append a 1-line entry to `docs/planning/issues.md`.
