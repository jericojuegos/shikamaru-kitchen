---
trigger: always_on
description: Universal Michelin-Grade Software Craft Protocol — 5-Stage Lifecycle (/design -> /scaffold -> /prototype -> /craft -> /polish), Interactive Prototype First, 3-Pass Implementation, 4-Point UX & Code Craft Audit, and 0-Token Mechanical Architecture Guardrails
---

# 👨‍🍳 Rule: Michelin-Grade Software Craft Protocol (`kitchen-protocol.md`)

**Purpose:** High-craft, product-obsessed software engineering inspired by Cillian Myles (*"Build a Michelin-star kitchen, not a software factory"*). Automate the repetitive setup (*mise en place* via `/scaffold`) and enforce 0-token mechanical architecture checks so the human engineer can spend 80% of their energy on **interactive UX prototyping (`/prototype`), incremental 3-pass craft (`/craft`), and deep UX/code polish (`/polish`)**.

---

## 1. The Project Brain (`docs/`) & Craft Engine (`.agents/`)

Every project separates **System Foundation**, **Planning Roadmap**, **Unified Feature Specs**, and the **`.agents/` Craft Engine**:

1. **System Foundation (`docs/foundation/`):**
   - `prd.md` — Product thesis, user personas, and **Signature Craft Features vs. Standard Plumbing**.
   - `architecture.md` — Layer boundaries, modular folder layout, and dependency rules.
   - `design-system.md` — Typography, color tokens, motion rules, copy voice, and the **Anti-Slop Craft Manifesto** (explicitly banned generic AI UI/code patterns).
   - `decisions.md` — Architectural Decision Records (ADRs).
2. **Planning Roadmap (`docs/planning/`):**
   - `roadmap.md` — Master feature registry classifying every feature as **`✨ SIGNATURE CRAFT`** (core differentiating UX) or **`⚙️ PLUMBING`** (infrastructure/CRUD setup), along with `Wave`, `Depends On`, and `Touches (Isolation Zone)` paths.
   - `issues.md` — Retrospective & self-healing incident log.
3. **Feature Spec Folders (`docs/specs/<NN-feature-slug>/`):**
   - `design-reference/preview.html` — **Interactive 4-State UI Prototype (`<agent-embed>`):** Playable HTML/Tailwind prototype showing Happy, Empty, Loading Skeleton, and Error states *before* production code is built.
   - `spec.md` — **Single Unified Feature Spec (`~80` lines):** Combines numbered EARS Criteria (`Req 1.1..N`), Correctness Properties (`Property 1`, `Property 2`), Mermaid data-flow diagram, exact `[NEW]` / `[MODIFY]` files, the **3-Pass Implementation Plan**, and the **4-Point UX & Code Craft Audit** in **1 zero-drift file**.
   - `evidence/*.png` — Real rendered browser proof screenshots captured during `/polish`.
4. **Craft Engine (`.agents/`):**
   - `.agents/rules/` — Always-on guardrails (`kitchen-protocol.md` + `stack-rules.md`, strictly `<= 80` lines)
   - `.agents/skills/` — 5 Software Craft Lifecycle Skills:
     - [`design/SKILL.md`](../skills/design/SKILL.md) (`/design`) — Product Vision, Design System & Anti-Slop Manifesto Designer
     - [`scaffold/SKILL.md`](../skills/scaffold/SKILL.md) (`/scaffold`) — Automated *Mise en Place* & 0-Token Mechanical Architecture Linter Generator
     - [`prototype/SKILL.md`](../skills/prototype/SKILL.md) (`/prototype`) — Interactive 4-State UI Prototyper (`preview.html`) & Unified `spec.md` Author
     - [`craft/SKILL.md`](../skills/craft/SKILL.md) (`/craft`) — 3-Pass Guided Implementation Engine
     - [`polish/SKILL.md`](../skills/polish/SKILL.md) (`/polish`) — Mechanical Verification + 4-Point UX & Code Craft Audit + Ship

---

## 2. Signature Craft (`✨ SIGNATURE CRAFT`) vs. Standard Plumbing (`⚙️ PLUMBING`)

Not every feature deserves the same ceremony. Triage every feature in `docs/planning/roadmap.md`:

| Feature Tier | Examples | `/prototype` & `/craft` Behavior | `/polish` Behavior |
| :--- | :--- | :--- | :--- |
| **`⚙️ PLUMBING`** *(Automated Mise en Place)* | `00-scaffold`, DB migrations, auth middleware, standard CRUD endpoints, webhooks, background jobs. | **Fast Automated Execution:** Builds all passes back-to-back with deterministic unit tests and mechanical linter verification. | **Auto-Ship on Green Checks:** Once types, unit tests, and the Mechanical Architecture Linter pass, commit atomically and mark `[x]` in `roadmap.md`. |
| **`✨ SIGNATURE CRAFT`** *(High-Taste Product UX)* | Core Product Value Loop, differentiating UI/UX workflows, interactive editors/builders, novel domain algorithms. | **Mandatory Interactive Prototype First:** Must generate `design-reference/preview.html` (`<agent-embed>`) during `/prototype` so the human can feel and tweak the UX before coding starts. | **4-Point Craft Audit + Human Taste Gate:** Runs the full **4-Point UX & Code Craft Audit**, captures `evidence/*.png`, and pauses at **`✨ READY FOR HUMAN SIGN-OFF`** before marking `[x]`. |

---

## 3. The 3-Pass Implementation Loop (`/craft`)

Never dump a 1,500-line feature in a single unverified turn. Every feature in `docs/specs/<NN-feature-slug>/spec.md` is built across **3 Incremental Passes**:

1. **Pass 1 — Domain Engine, Data & Unit Tests (`[BE]`):**
   - Build pure domain logic, schemas, and server handlers within the feature's `Touches` isolation zone.
   - Write and pass mandatory unit/invariant tests (`Property 1` happy path + `Property 2` invalid/unauthorized rejection) and the **0-Token Mechanical Architecture Linter**.
   - Create an atomic Git checkpoint commit (`feat(<feature-slug>): pass 1 domain engine and unit tests`).
2. **Pass 2 — Core Interactive Experience (`[FE]`):**
   - Implement modular UI components (`<= 250` lines) matching `design-reference/preview.html` and `docs/foundation/design-system.md`.
   - Verify build & types and create the Pass 2 checkpoint commit.
3. **Pass 3 — Micro-Interactions, Keyboard Ergonomics & Edge-Case Empathy (`[CRAFT]`):**
   - Layer in instantaneous hover/active/loading feedback, zero-CLS skeletons, keyboard ergonomics (`Enter`, `Escape`, focus rings), human-empathetic empty/error states, and Golden-Path Playwright E2E coverage.
   - Run full terminal verification and hand off to **`/polish`**.

---

## 4. The Inverse Trust Pyramid & 4-Point Craft Standard

1. **Layer 1 — 0-Token Mechanical Architecture Guardrails (`architecture.test.*`):**
   - Generated during `/scaffold` and executed in `< 50ms` on every test run. Mechanically blocks cross-feature imports, missing `server-only`/`ABSPATH` guards, files `> 300` lines, `@ts-ignore`/`any` escape hatches, and unfinished `TODO:`/`FIXME:` placeholders.
2. **Layer 2 — Runtime & Visual Browser Evidence ("Test-Before-Notify"):**
   - Never use the human as a first-pass QA tester. Drive the real browser (via Playwright or `flash` Browser QA subagent), verify zero console/network errors, and save proof screenshots to `docs/specs/<NN-feature-slug>/evidence/*.png`.
3. **Layer 3 — The 4-Point UX & Code Craft Audit (During `/polish`):**
   - ✨ **Point 1 (Micro-Interactions & Visual Stability):** Instant hover/active/disabled/loading states; zero jarring layout shift (CLS).
   - ✨ **Point 2 (Copy, Empty & Error Empathy):** Empty states guide the user to the next action; error messages explain how to recover in clear human language.
   - ✨ **Point 3 (Keyboard & Ergonomic Flow):** Logical `Tab` order, `Enter` to submit, `Escape` to close modals, visible focus rings.
   - ✨ **Point 4 (Idiomatic Code Craft):** Zero bloated God-components (`<= 300` lines); clean separation of state, domain logic, and presentation.

---

## 5. Budget Guard, 3-Strike Rule & Automatic Self-Healing

### Budget Guard (Pause & Ask)
Pause and ask for confirmation (`"⚠️ CRAFT GUARD TRIGGERED: [reason]. Awaiting approval..."`) before touching more than 4 files in a single pass (unless defined in `spec.md`) or modifying shared contracts (`shared/types/`) without checking blast radius.

### The 3-Strike Rule
If the same error persists after **3 fix attempts**: **STOP** immediately, **REPORT** the exact error and 3 approaches tried, and **ASK** the user for guidance.

### 5.1 Automatic Self-Healing (After Any Bug Fix or User Correction)
Whenever you fix a bug or receive a UX/code correction from the user, automatically execute before ending your turn:
1. **Executable Regression Test & Mechanical Linter Rule:** Add a unit test reproducing the bug, and if it was a structural/slop pattern, encode it into `architecture.test.*`.
2. **Design System / Project Guardrail:** Add a 1-line rule to `AGENTS.md` or `docs/foundation/design-system.md` (Anti-Slop Manifesto) so future passes never repeat it.
3. **Issue Log:** Append a 1-line entry to `docs/planning/issues.md`.
