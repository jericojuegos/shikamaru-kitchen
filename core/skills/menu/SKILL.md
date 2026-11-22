---
name: menu
description: >-
  Design the Product Menu, Taste System, Anti-Slop Manifesto, and Service Board
  (AGENTS.md, docs/foundation/menu-vision.md, docs/foundation/architecture.md,
  docs/foundation/taste-system.md, docs/planning/service-board.md, and starter
  docs/dishes/00-prep/ + 01+ dish folders). Use when starting a new project,
  designing a product concept, or when the user invokes /menu.
---

# 📜 Skill: Executive Chef Menu & Taste System Designer (`/menu`)

**Purpose:** Align with the human **Executive Chef** across **4 crisp rounds** before a single line of code is written—separating **Signature Dishes** (high-craft differentiating UX) from **House Staples** (automated prep plumbing) and locking the **Anti-Slop Taste System**.

---

## Step 1 — Auto-Detect or Select Tech Stack & Ask Round 1 (Concept & Diners)

1. **Auto-Discover or Choose the Kitchen Stack (Works on Any Language/Framework):**
   - If running in an existing repo, inspect manifests (`package.json`, `pyproject.toml`, `composer.json`, `go.mod`, `Cargo.toml`, etc.) to auto-detect the stack.
   - If greenfield, recommend the best modern stack for the product's problem and let the Chef pick or customize.
2. Summarize the user's product idea in 2 sentences and ask **Round 1 (Concept & Stack)**:
   - **Q1. Target Diners & Core Problem:** Who is the primary user and what is the #1 painful job this software makes effortless?
   - **Q2. Kitchen Stack & Architecture:** Present 3 tailored stack options (`A`, `B`, `C`, `Z) Custom`).

Wait for the Chef's reply, then print a `🔒 Locked: Round 1` summary.

---

## Step 2 — Round 2: Signature Dishes (`👨‍🍳 SIGNATURE`) vs. House Staples (`🔪 STAPLE`)

Present a proposed feature menu divided strictly into two categories and ask the Chef to confirm or adjust:

1. **`👨‍🍳 SIGNATURE DISHES` (1 to 3 Core Features — 80% of Craft & Tasting Energy):**
   - The differentiating user workflows, interactive editors, or domain engines that define why someone loves this product.
   - *Rule:* Every Signature Dish will get an interactive `<agent-embed>` Tasting Spoon (`preview.html`), a 3-Course build with a mid-cook taste check, and a 4-Star Culinary Craft Audit.
2. **`🔪 HOUSE STAPLES` (Plumbing & Infrastructure — Automated by AI Prep Cooks):**
   - `00-prep` scaffolding, auth/session plumbing, standard settings, DB schemas, webhooks.
   - *Rule:* Executed rapidly via golden templates and mechanical food-safety checks.

Wait for the Chef's reply, then print a `🔒 Locked: Round 2 (The Menu)` summary.

---

## Step 3 — Round 3: The Taste System & Anti-Slop Manifesto (`taste-system.md`)

Ask the Chef to pick or customize the product's **Aesthetic & Interaction Flavor**:
1. **Visual & Typography Direction:** (e.g., *A: Warm Editorial Studio*, *B: Crisp Linear/Raycast Precision*, *C: Tactile Industrial Console*, *Z: Custom Brand Tokens*).
2. **Interaction & Motion Feel:** Instant optimistic updates, skeleton transitions, keyboard-first navigation (`Cmd+K`, `Enter`, `Escape`).
3. **The Anti-Slop Manifesto (Banned Patterns):**
   - Explicitly list what is **forbidden** in this repo (e.g., no generic AI purple-to-blue gradients, no unstyled `"Loading..."` text jumps, no robotic marketing filler, no `> 300-line` God-components, no `@ts-ignore` / `any`).

Wait for the Chef's reply, then print a `🔒 Locked: Round 3 (Taste System)` summary.

---

## Step 4 — Round 4: Generate the Kitchen Brain & Auto-Tailored `.agents/rules/stack-rules.md` (`<= 80` Lines)

Once Rounds 1–3 are locked, generate the project's Kitchen Brain:

1. **`.agents/rules/stack-rules.md` (Strictly `<= 80` Lines):** Auto-tailor the stack rule file to the chosen tech stack (defining station directory boundaries, forbidden cross-feature imports, security rules, `<= 300-line` modularity cap, and pre-commit Food-Safety commands).
2. **`AGENTS.md` & `CLAUDE.md`:** Project overview, chosen stack, active service state, and Anti-Slop rules.
3. **`docs/foundation/menu-vision.md`:** Product thesis, personas, and Signature Dish vs. House Staple breakdown.
4. **`docs/foundation/architecture.md`:** Mermaid system diagram, station folder boundaries, and data models.
5. **`docs/foundation/taste-system.md`:** Exact CSS/Tailwind color tokens, typography scale, micro-interaction rules, copy voice, and the **Anti-Slop Manifesto**.
6. **`docs/foundation/decisions.md`:** Initial ADRs.
7. **`docs/planning/service-board.md`:**
   - The master **Service Board & Dish Dependency Matrix** with columns: `Dish ID`, `Title`, `Category (👨‍🍳 SIGNATURE | 🔪 STAPLE)`, `Wave`, `Depends On`, `Station (Touches)`, and `Status ([ ])`.
8. **Starter Dish Folders (`docs/dishes/00-prep/` and `docs/dishes/01-<first-dish>/`):**
   - Populate `docs/dishes/00-prep/recipe.md` for `/prep`.
   - Populate starter `docs/dishes/01-<first-dish>/recipe.md` ready for `/taste`.

End by telling the Chef:
> *"👨‍🍳 **Menu Locked!** Run **`/prep`** next to set up your *mise en place* and mechanical architecture guardrails, or run **`/taste 01-<first-dish>`** to sample your first interactive Tasting Spoon!"*
