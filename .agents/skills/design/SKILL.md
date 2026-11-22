---
name: design
description: >-
  Design the Product Vision, Design System, Anti-Slop Craft Manifesto, auto-tailored
  stack-rules.md (<= 80 lines), and Feature Roadmap (AGENTS.md, docs/foundation/prd.md,
  docs/foundation/architecture.md, docs/foundation/design-system.md, docs/planning/roadmap.md,
  and starter docs/specs/00-scaffold/spec.md). Use when starting a new project, defining
  product architecture and UX craft standards, or when the user invokes /design.
---

# 🎨 Skill: Product Vision, Design System & Anti-Slop Architect (`/design`)

**Purpose:** Align with the human engineer across **4 crisp rounds** before coding begins—separating **Signature Craft Features (`✨ SIGNATURE CRAFT`)** from **Standard Plumbing (`⚙️ PLUMBING`)**, locking the **Anti-Slop Design System**, and auto-tailoring `.agents/rules/stack-rules.md` (`<= 80` lines) for any tech stack.

---

## Step 1 — Auto-Detect or Select Tech Stack & Ask Round 1 (Vision & Users)

1. **Auto-Discover or Choose the Tech Stack (Works on Any Language/Framework):**
   - If running in an existing repo, inspect manifests (`package.json`, `pyproject.toml`, `composer.json`, `go.mod`, `Cargo.toml`, etc.) to auto-detect the stack.
   - If greenfield, recommend the best modern stack for the product's problem and let the user pick or customize.
2. Summarize the user's product idea in 2 sentences and ask **Round 1 (Problem & Stack)**:
   - **Q1. Target Users & Core Problem:** Who is the primary user and what is the #1 painful workflow this product makes effortless?
   - **Q2. Tech Stack & Modular Architecture:** Present 3 tailored stack options (`A`, `B`, `C`, `Z) Custom`).

Wait for the user's reply, then print a `🔒 Locked: Round 1` summary.

---

## Step 2 — Round 2: Signature Craft (`✨ SIGNATURE CRAFT`) vs. Plumbing (`⚙️ PLUMBING`)

Present a proposed feature roadmap divided strictly into two tiers and ask the user to confirm or adjust:

1. **`✨ SIGNATURE CRAFT` (1 to 3 Core Features — 80% of Prototyping & UX Polish Energy):**
   - The differentiating user workflows, interactive editors, or domain engines that define why users love this product.
   - *Rule:* Every Signature Craft feature gets an interactive 4-state `<agent-embed>` prototype (`preview.html`) via `/prototype`, a 3-Pass implementation via `/craft`, and a 4-Point UX & Code Craft Audit via `/polish`.
2. **`⚙️ PLUMBING` (Infrastructure & Setup — Automated Rapidly):**
   - `00-scaffold`, auth/session setup, standard settings, DB schemas, webhooks.
   - *Rule:* Executed rapidly with deterministic unit tests and mechanical architecture checks.

Wait for the user's reply, then print a `🔒 Locked: Round 2 (Feature Tiers)` summary.

---

## Step 3 — Round 3: Design System & Anti-Slop Craft Manifesto (`design-system.md`)

Ask the user to pick or customize the product's **Aesthetic & Interaction Standards**:
1. **Visual & Typography Direction:** (e.g., *A: Warm Editorial Studio*, *B: Crisp Linear/Raycast Precision*, *C: Tactile Industrial Console*, *Z: Custom Brand Tokens*).
2. **Interaction & Motion Feel:** Instant optimistic updates, zero-CLS skeleton transitions, keyboard-first ergonomics (`Cmd+K`, `Enter`, `Escape`).
3. **The Anti-Slop Craft Manifesto (Banned Patterns):**
   - Explicitly list what is **forbidden** in this repo (e.g., no generic AI purple-to-blue gradients, no unstyled `"Loading..."` text jumps, no robotic placeholder copy, no `> 300-line` God-components, no `@ts-ignore` / `any`, no unfinished `TODO:` comments).

Wait for the user's reply, then print a `🔒 Locked: Round 3 (Design System)` summary.

---

## Step 4 — Round 4: Generate the Project Brain & Auto-Tailored `.agents/rules/stack-rules.md` (`<= 80` Lines)

Once Rounds 1–3 are locked, generate:

1. **`.agents/rules/stack-rules.md` (Strictly `<= 80` Lines):** Auto-tailor the stack rule file to the chosen tech stack (defining modular directory boundaries, forbidden cross-feature imports, security rules, `<= 300-line` modularity cap, and pre-commit verification commands).
2. **`AGENTS.md` & `CLAUDE.md`:** Project overview, chosen stack, active stage, and Anti-Slop rules.
3. **`docs/foundation/prd.md`:** Product thesis, personas, and Signature Craft vs. Plumbing breakdown.
4. **`docs/foundation/architecture.md`:** Mermaid system diagram, modular folder boundaries, and data models.
5. **`docs/foundation/design-system.md`:** Exact CSS/Tailwind color tokens, typography scale, micro-interaction rules, copy voice, and the **Anti-Slop Craft Manifesto**.
6. **`docs/foundation/decisions.md`:** Initial ADRs.
7. **`docs/planning/roadmap.md`:**
   - The master **Feature Specs Registry & Dependency Matrix** with columns: `Feature ID`, `Title`, `Tier (✨ SIGNATURE CRAFT | ⚙️ PLUMBING)`, `Wave`, `Depends On`, `Touches (Isolation Zone)`, and `Status ([ ])`.
8. **Starter Spec Folders (`docs/specs/00-scaffold/` and `docs/specs/01-<first-feature>/`):**
   - Populate `docs/specs/00-scaffold/spec.md` for `/scaffold`.
   - Populate starter `docs/specs/01-<first-feature>/spec.md` ready for `/prototype`.

End by telling the user:
> *"✨ **Design & Architecture Locked!** Run **`/scaffold`** next to set up your base codebase and 0-token Mechanical Architecture Linter, or run **`/prototype 01-<first-feature>`** to test-drive your first interactive 4-state UI prototype!"*
