---
name: shika
description: >-
  Project GPS, Step-by-Step Router & Brain Doctor (/shika) for shikamaru-kitchen
  projects. Inspects repo state (uninitialized, Phase 0 scaffold, Signature Craft vs
  Plumbing triage, active 3-pass build, or polish), audits .agents/ and docs/ hygiene
  for weird, legacy, or conflicting files/folders, and tells you the exact next
  command (/design, /scaffold, /prototype, /craft, or /polish). Use whenever the user
  invokes /shika or asks what step to run next.
---

# 🧭 Skill: Kitchen Project GPS & Brain Doctor (`/shika`)

**Purpose:** Zero-memorization entry point and **Brain Hygiene Check** for **Michelin-Grade Software Craft (`shikamaru-kitchen`)**. Type **`/shika`** anytime to verify `.agents/` + `docs/` health and get the single next command.

*(Note: If the user passes an external `<target-path>` outside this repo that is uninitialized or uses another Master Brain, check `C:\Users\Jerico\.gemini\config\skills\shika\SKILL.md` if present to offer all 3 Master Brains.)*

---

## Step 1 — Inspect Kitchen State & Run Brain Hygiene Audit

1. **Kitchen State:**
   - `docs/planning/roadmap.md` (`SIGNATURE CRAFT` vs `PLUMBING`, `[x]` Shipped, `[>]` Active, `[ ]` Pending)
   - `docs/foundation/design-system.md` (Product Vision & Anti-Slop Manifesto)
   - Active or next feature `docs/specs/<NN-feature-slug>/` (`design-reference/preview.html`, `spec.md`, `evidence/*.png`)
   - `git branch --show-current` and `git status --short`

2. **Brain Doctor Hygiene Audit (`.agents/` & `docs/`):**
   - **`.agents/` Strict Check:** Canonical Kitchen subfolders are **only** `rules/`, `skills/`, and `scripts/` (plus `templates/` only inside the Master Kitchen repo itself). Flag `⚠️ .agents/ Drift` if:
     - Legacy root `.agent/` exists, or `.agents/{workflows,roles,knowledge,planning,specs}` exist
     - Multi-engine collision: `execution-protocol.md` or `factory-protocol.md` exists alongside `kitchen-protocol.md`
     - Foreign skills exist in `.agents/skills/` outside Kitchen (`shika`, `design`, `scaffold`, `prototype`, `craft`, `polish`)
   - **`docs/` Safe Check (Warn & Confirm Only — NEVER Auto-Delete):** Canonical Brain entries are `INDEX.md`, `foundation/`, `planning/`, `specs/` *(plus optional `audits/`)*. Flag `⚠️ docs/ Hygiene Warning` if legacy paths (`docs/knowledge/`, `docs/foundation/spec.md`) or unexpected folders/files exist in `docs/`. Never delete `docs/` files without explicit user confirmation (offer **Migrate**, **Keep/Ignore**, or **Remove**).

---

## Step 2 — Output the `/shika` GPS Card & Route

| Detected State | Exact Next Command | Why |
| :--- | :--- | :--- |
| **No `roadmap.md` or `design-system.md`** | **`/design`** | Auto-detects/selects stack, locks PRD, Anti-Slop Design System, and roadmap. |
| **`00-scaffold` is `[ ]`** | **`/scaffold`** | Runs Phase 0 *Mise en Place* + 0-Token Mechanical Architecture Linter. |
| **Next `[ ]` `SIGNATURE CRAFT` feature missing `preview.html`** | **`/prototype <NN-feature-slug>`** | Builds interactive 4-state UI prototype before writing production code. |
| **Next `[ ]` feature missing `spec.md`** | **`/prototype <NN-feature-slug>`** | Locks unified `spec.md` + 3-Pass plan. |
| **Feature `[ ]`/`[>]` has `spec.md`, passes incomplete** | **`/craft <NN-feature-slug>`** | Runs Pass 1 (Domain/Tests) -> Pass 2 (UI) -> Pass 3 (Micro-Interactions). |
| **All 3 passes complete, needs QA & Sign-Off** | **`/polish <NN-feature-slug>`** | Runs 4-Point Craft Audit, captures `evidence/*.png`, pauses for sign-off / ships. |
| **All Phase features are `[x]`** | **`/design`** | Plan and tier the next product milestone. |

```markdown
## 🧭 `/shika` Project GPS: [Project Name]
- **Engine:** `shikamaru-kitchen` · **Branch:** `[git branch]`
- **Brain Health:** `[✅ CLEAN | ⚠️ HYGIENE WARNING: <list .agents/ or docs/ anomalies>]`
- **Progress:** `[X] Shipped · [Y] Active · [Z] Pending`
- **Current Focus:** `[Active [>] feature or next unblocked [ ] feature, or Uninitialized]`

👉 **Next Command:** `/<exact-command>`
*(Reply `go` to run it now, or `clean` if Brain Health flagged `.agents/` / `docs/` drift — runs `sync-kitchen.ps1 -Clean` for `.agents/` and asks before touching `docs/`.)*
```
