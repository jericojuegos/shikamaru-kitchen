---
name: polish
description: >-
  Run Michelin-Grade Quality Control & Polish against docs/specs/<NN-feature-slug>/spec.md:
  Level 1 (Types, Unit Tests & 0-Token Mechanical Architecture Linter), Level 2 (EARS
  Requirement Proof Citations), Level 3 (Autonomous Browser QA capturing
  docs/specs/<NN-feature-slug>/evidence/*.png), and Level 4 (The 4-Point UX & Code Craft
  Audit), then pause for human sign-off or ship to Git. Use after /craft completes or when
  the user invokes /polish.
---

# ✨ Skill: 4-Point UX & Code Craft Audit, Browser Proof & Ship (`/polish`)

**Purpose:** Before a feature ships, verify both **Mechanical Safety** (it compiles, passes unit/E2E tests, and passes the 0-token Mechanical Architecture Linter) and **Product Craft** (the 4-Point UX & Code Craft Audit + real browser screenshots in `evidence/*.png`).

---

## Step 1 — Level 1: Deterministic Build, Tests & 0-Token Mechanical Architecture Linter

Run the project's deterministic test and architecture suite:
- **TypeScript / Next.js:** `pnpm tsc --noEmit && pnpm test --run && pnpm build` (automatically executes `architecture.test.ts` in `< 50ms`).
- **Python / FastAPI:** `uv run ruff check . && uv run pytest` (automatically executes `test_architecture.py`).
- **PHP / WordPress:** `php -l` across all PHP files + `vendor/bin/phpunit` (automatically executes `ArchitectureTest.php`).

If any compiler error, failing test, or mechanical architecture violation occurs (e.g., file `> 300` lines, cross-feature import, `@ts-ignore`, or leftover `TODO:`), **fix it immediately** before proceeding.

---

## Step 2 — Level 2 & 3: EARS Proof Table & Autonomous First-Pass Browser QA ("Test-Before-Notify")

1. **Core Rule:** Never use the human engineer as your first-pass functional QA tester.
2. **🚫 Hard Gate — Mandatory `docs/specs/<NN-feature-slug>/evidence/*.png` for UI / Interactive Features:**
   - Drive the live application in a real browser (via Playwright `page.screenshot()` or the `flash` `browser` subagent).
   - Test all 4 states where applicable (Happy Path, Empty State, Loading/Submission, Validation/Error State), verify zero `console.error` or network `4xx/5xx` failures, and save proof screenshots to `docs/specs/<NN-feature-slug>/evidence/*.png`.
   - Populate every row of the **`Evidence / Proof`** column in `docs/specs/<NN-feature-slug>/spec.md` (Section 4) with exact unit test citations (`feature.test.ts:L24 PASS`) and browser screenshot paths (`./evidence/01-happy-path.png`).

---

## Step 3 — Level 4: The 4-Point UX & Code Craft Audit

Inspect the rendered screenshots (`evidence/*.png`), live DOM, and touched source files against the **4 Craft Checkpoints** (and self-heal any gap inline before notifying the user):

- ✨ **Point 1 — Micro-Interactions & Visual Stability:**
  Buttons/toggles respond immediately on hover/active/loading; async data transitions use smooth skeletons or optimistic updates with zero jarring layout shifts (CLS).
- ✨ **Point 2 — Copy, Empty & Error Empathy:**
  Zero robotic placeholder strings (`"No data"`, `"Error 500"`). Empty states guide the user to start with a clear CTA; errors preserve user input and explain how to recover.
- ✨ **Point 3 — Keyboard & Ergonomic Flow:**
  Forms submit on `Enter`, modals/popovers close on `Escape`, focus lands naturally on open, and `Tab` order has crisp `focus-visible` rings.
- ✨ **Point 4 — Idiomatic Code Craft (Zero AI Slop):**
  Every component/module stays under the `300`-line cap, follows `docs/foundation/design-system.md` tokens (zero arbitrary hardcoded hex colors), and contains zero escape hatches or dead comments.

---

## Step 4 — Human Sign-Off Gate (`✨ SIGNATURE CRAFT` vs. `⚙️ PLUMBING`)

Output the **Craft & Polish Report**:

```markdown
## ✨ Craft & Polish Report: `<NN-feature-slug>` — [Feature Title]
**Tier:** `[✨ SIGNATURE CRAFT | ⚙️ PLUMBING]` · **Result:** `✅ 4/4 CRAFT AUDIT PASS`

- **Level 1 (Build, Unit Tests & Mechanical Architecture Linter):** ✅ PASS (`0` violations)
- **Level 2 (EARS Acceptance Criteria):** ✅ `[X/X]` Verified with evidence in `spec.md`
- **Level 3 (Browser Evidence `evidence/*.png`):** ✅ Saved (`./evidence/01-happy-path.png`, ...)
- **Level 4 (4-Point UX & Code Craft Audit):**
  - ✨ **Micro-Interactions & Zero CLS:** PASS
  - ✨ **Copy, Empty & Error Empathy:** PASS
  - ✨ **Keyboard & Ergonomic Flow:** PASS
  - ✨ **Idiomatic Code Craft (`<= 300` lines, zero escape hatches):** PASS
```

### Ship & Review Routing (Remote PR Default + Optional Local Review):

1. **DEFAULT — Remote Pull Request Flow (When `origin` Remote Exists & `--local` Not Passed):**
   - For **`⚙️ PLUMBING`** features (or once the user approves a **`✨ SIGNATURE CRAFT`** feature, or anytime the user wants to review directly inside GitHub/GitLab PR UI):
     - Mark `[x]` in `docs/planning/roadmap.md` and create the final feature commit (`feat(<NN-feature-slug>): complete and verify <summary>`).
     - Push the branch and automatically open the Pull / Merge Request with the **EARS Evidence Table** and **4-Point UX & Code Craft Audit** in the PR description:
       ```bash
       git push -u origin feat/<NN-feature-slug>
       gh pr create --title "feat(<NN-feature-slug>): <Feature Title>" --body "<Craft & Polish Report + Evidence Citations>"
       ```
       *(Supports `glab mr create` on GitLab or outputs the direct remote PR URL if CLI is unauthenticated.)*
     - Share the clickable GitHub/GitLab PR URL (plus the local URL if the user also wants to interact with it locally before clicking Merge on the PR).
2. **OPTIONAL — Local-First Interactive Review & Local Merge (`--local` or When No `origin` Remote Exists):**
   - For **`✨ SIGNATURE CRAFT`** features in local-first mode (or when no `origin` remote is configured yet):
     - Keep all verified work committed on `feat/<NN-feature-slug>`.
     - Present the live local URL (`http://localhost:...`) and `docs/specs/<NN-feature-slug>/evidence/*.png` screenshots:
       > *"✨ **READY FOR REVIEW (`<NN-feature-slug>`):** Passed all 4 UX & Code Craft checks! Review the PR on GitHub/GitLab (or test live at `<local-url>`). Reply **'open pr'** to push & create a GitHub PR, **'merge locally'** to merge `feat/<NN-feature-slug>` into local `main`, or describe any UX tweak to run a 30-second `/prototype` delta pass!"*
