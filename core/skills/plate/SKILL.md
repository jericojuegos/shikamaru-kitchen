---
name: plate
description: >-
  Run Michelin Plating & Quality Control against docs/dishes/<NN-dish-slug>/plating.md:
  Level 1 (Food Safety: Types, Unit Tests & 0-Token Mechanical Architecture Linter),
  Level 2 (EARS Recipe Verification with concrete proof citations), Level 3 (Autonomous
  Browser QA capturing docs/dishes/<NN-dish-slug>/evidence/*.png), and Level 4 (The 4-Star
  Culinary Craft Audit), then pause at the Chef Pass Gate or serve to Git. Use after /cook
  completes or when the user invokes /plate.
---

# 🍽️ Skill: Michelin Plating, 4-Star Craft Audit & Serve (`/plate`)

**Purpose:** Before a dish leaves the kitchen pass, the Executive Chef and Expediter verify both **Food Safety** (it compiles, passes unit/E2E tests, and passes the 0-token Mechanical Architecture Linter) and **Michelin Flavor & Plating** (the 4-Star Culinary Craft Audit + real browser screenshots in `evidence/*.png`).

---

## Step 1 — Level 1: Food Safety Check (Deterministic Build, Tests & Mechanical Architecture Linter)

Run the stack's deterministic test and architecture suite:
- **Next.js / TypeScript:** `pnpm tsc --noEmit && pnpm test --run && pnpm build` (which automatically executes `src/shared/__tests__/architecture.test.ts` in `< 50ms`).
- **Python / FastAPI:** `uv run ruff check . && uv run pytest` (which automatically executes `tests/test_architecture.py`).
- **WordPress / PHP:** `php -l` across all PHP files + `vendor/bin/phpunit` (which automatically executes `tests/Unit/ArchitectureTest.php`).

If any compiler error, failing test, or mechanical architecture violation occurs (e.g., file `> 300` lines, cross-feature import, `@ts-ignore`, or leftover `TODO:`), **fix it immediately** before proceeding.

---

## Step 2 — Level 2 & 3: EARS Recipe Proof & Autonomous First-Pass Browser QA ("Test-Before-Notify")

1. **Core Rule:** Never use the Head Chef as your first-pass functional QA tester.
2. ** Hard Gate — Mandatory `docs/dishes/<NN-dish-slug>/evidence/*.png` for UI / Interactive Dishes:**
   - Drive the live application in a real browser (via Playwright `page.screenshot()` or the `flash` `browser` subagent).
   - Test all 4 states where applicable (Happy Path, Empty State, Loading/Submission, Validation/Error State), verify zero `console.error` or network `4xx/5xx` failures, and save proof screenshots to `docs/dishes/<NN-dish-slug>/evidence/*.png`.
   - Populate every row of the **`Evidence / Proof`** column in `docs/dishes/<NN-dish-slug>/plating.md` with exact unit test citations (`feature.test.ts:L24 PASS`) and browser screenshot paths (`./evidence/01-happy-path.png`).

---

## Step 3 — Level 4: The 4-Star Culinary Craft Audit

Inspect the rendered screenshots (`evidence/*.png`), live DOM, and touched source files against the **4 Michelin Craft Stars** (and self-heal any gap inline before calling the Chef):

- ⭐ **Star 1 — Micro-Interactions & Visual Stability:**
  Buttons/toggles respond immediately on hover/active/loading; async data transitions use smooth skeletons or optimistic updates with zero jarring layout shifts (CLS).
- ⭐ **Star 2 — Copy, Empty & Error Empathy:**
  Zero robotic placeholder strings (`"No data"`, `"Error 500"`). Empty states teach the diner how to start with a clear CTA; errors preserve user input and explain how to recover.
- ⭐ **Star 3 — Keyboard & Ergonomic Flow:**
  Forms submit on `Enter`, modals/popovers close on `Escape`, focus lands naturally on open, and `Tab` order has crisp `focus-visible` rings.
- ⭐ **Star 4 — Idiomatic Code Craft (Zero AI Slop):**
  Every component/module stays under the `300`-line cap, follows `docs/foundation/taste-system.md` tokens (zero arbitrary hardcoded hex colors), and contains zero escape hatches or dead comments.

---

## Step 4 — The Chef Pass Gate (Signature Dish vs. House Staple)

Output the **Michelin Plating Report**:

```markdown
## 🍽️ Michelin Plating Report: `<NN-dish-slug>` — [Dish Title]
**Category:** `[👨‍🍳 SIGNATURE DISH | 🔪 HOUSE STAPLE]` · **Result:** `⭐⭐⭐⭐ 4-STAR PASS`

- **Level 1 (Food Safety & Mechanical Architecture Linter):** ✅ PASS (`0` violations)
- **Level 2 (EARS Recipe Criteria):** ✅ `[X/X]` Verified with evidence in `plating.md`
- **Level 3 (Browser Evidence `evidence/*.png`):** ✅ Saved (`./evidence/01-happy-path.png`, ...)
- **Level 4 (4-Star Culinary Craft Audit):**
  - ⭐ **Micro-Interactions & Zero CLS:** PASS
  - ⭐ **Copy, Empty & Error Empathy:** PASS
  - ⭐ **Keyboard & Ergonomic Flow:** PASS
  - ⭐ **Idiomatic Code Craft (`<= 300` lines, zero escape hatches):** PASS
```

### Routing at the Pass:
- **If `🔪 HOUSE STAPLE` (or `--auto-serve` requested):**
  Immediately mark `[x]` on `docs/planning/service-board.md`, create the final clean feature commit (`feat(<dish-slug>): plate and serve <summary>`), and report completion.
- **If `👨‍🍳 SIGNATURE DISH` (Interactive Session):**
  Keep the dish at `[>]` on `docs/planning/service-board.md` with all code safely committed on `feat/<NN-dish-slug>` and prompt the Executive Chef:
  > *"👨‍🍳 **AT THE PASS (`<NN-dish-slug>`):** Your Signature Dish passed all 4 Michelin Craft Stars! Taste it live at `<local-url>` or inspect `docs/dishes/<NN-dish-slug>/evidence/*.png`. Reply **'serve'** to mark `[x]` on `service-board.md` and finalize the commit/PR, or tell me any flavor tweak to run a 30-second `/taste` re-seasoning pass!"*
