---
name: shika
description: >-
  Project GPS & Step-by-Step Router (/shika) for shikamaru-kitchen projects. Inspects
  the current repo state (uninitialized, Phase 0 scaffold, Signature Craft vs Plumbing
  triage, active 3-pass build, or polish) and tells you the exact next command
  (/design, /scaffold, /prototype, /craft, or /polish) so you never have to memorize
  the workflow. Use whenever the user invokes /shika or asks what step to run next.
---

# 🧭 Skill: Kitchen Project GPS & Router (`/shika`)

**Purpose:** Zero-memorization entry point for **Michelin-Grade Software Craft (`shikamaru-kitchen`)**. Type **`/shika`** at any point to see exactly where you are and what single command to run next.

---

## Step 1 — Inspect Current Kitchen State

Check these paths in order:
1. `docs/planning/roadmap.md` (Feature Registry: `SIGNATURE CRAFT` vs `PLUMBING`, `[x]` Shipped, `[>]` Active, `[ ]` Pending)
2. `docs/foundation/design-system.md` (check if Product Vision & Anti-Slop Manifesto are locked)
3. Active or next feature folder `docs/specs/<NN-feature-slug>/` (check if `design-reference/preview.html`, `spec.md`, and `evidence/*.png` exist)
4. `git branch --show-current` and `git status --short`

---

## Step 2 — Output the `/shika` GPS Card & Single Next Command

Determine the exact kitchen state:

| Detected State | Exact Next Command | Why |
| :--- | :--- | :--- |
| **No `roadmap.md` or `design-system.md`** | **`/design`** | Auto-detects/selects stack, locks PRD, Anti-Slop Design System, and roadmap. |
| **`00-scaffold` is `[ ]`** | **`/scaffold`** | Runs Phase 0 *Mise en Place* + 0-Token Mechanical Architecture Linter. |
| **Next `[ ]` `SIGNATURE CRAFT` feature missing `preview.html`** | **`/prototype <NN-feature-slug>`** | Builds interactive 4-state UI prototype before writing production code. |
| **Next `[ ]` feature missing `spec.md`** | **`/prototype <NN-feature-slug>`** | Locks unified `spec.md` + 3-Pass plan. |
| **Feature `[ ]`/`[>]` has `spec.md`, passes incomplete** | **`/craft <NN-feature-slug>`** | Runs Pass 1 (Domain/Tests) -> Pass 2 (UI) -> Pass 3 (Micro-Interactions). |
| **All 3 passes complete, needs QA & Sign-Off** | **`/polish <NN-feature-slug>`** | Runs 4-Point Craft Audit, captures `evidence/*.png`, pauses for sign-off / ships. |
| **All Phase features are `[x]`** | **`/design`** | Plan and tier the next product milestone. |

Print this compact status card:

```markdown
## 🧭 `/shika` Project GPS: [Project Name]
- **Engine:** `shikamaru-kitchen` · **Branch:** `[git branch]`
- **Progress:** `[X] Shipped · [Y] Active · [Z] Pending`
- **Current Focus:** `[Active [>] feature or next unblocked [ ] feature, or Uninitialized]`

👉 **Next Command:** `/<exact-command>`
*(Reply `go` and I will run it now.)*
```
