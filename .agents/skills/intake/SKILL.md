---
name: intake
description: >-
  Ingest Day-2 Figma screenshots (docs/design-reference/ or docs/foundation/design-reference/),
  Figma URLs, client PRDs, or raw notes into a shikamaru-kitchen project. Auto-creates or
  updates docs/foundation/design-system.md (with Anti-Slop Manifesto) and docs/planning/roadmap.md
  without writing code, then routes directly to /prototype. Use when the user drops design
  references or invokes /intake.
---

# 🎨 Skill: Kitchen Design & Requirement Intake (`/intake`)

**Purpose:** Zero-friction Day-2 ingestion for **Michelin-Grade Software Craft (`shikamaru-kitchen`)**. Drop Figma `.png`/`.jpg` exports into `docs/design-reference/` (or paste a Figma URL / client PRD / notes) and run **`/intake`** — no prompt memorization required.

---

## Step 1 — Scan Drop-Zones & Existing Kitchen Context

1. **Inspect Design & Doc Drop-Zones:**
   - Check `docs/design-reference/` and `docs/foundation/design-reference/` for `.png`, `.jpg`, `.jpeg`, `.webp`, `.pdf`, `.html`, or `.md` files.
   - Read every image directly with `read_file` (or inspect the Figma URL via the Figma plugin/MCP if provided).
   - Also incorporate any inline notes, PRDs, or user-flow briefs pasted alongside `/intake`.
2. **Read Existing Foundation:**
   - Read `AGENTS.md`, `docs/foundation/` (`prd.md`, `architecture.md`, `design-system.md` if present), and `docs/planning/roadmap.md`.

---

## Step 2 — Create or Update `docs/foundation/design-system.md`

Extract concrete craft specifications from the ingested designs and write (or merge into) `docs/foundation/design-system.md`:
1. **UI Layer & Shell:** Exact UI framework / design tokens used (e.g., Tailwind/shadcn, WordPress `--wpds-*` / `@tangible/ui` `--tui-*`, etc.).
2. **Color Palette, Typography & Spacing:** Exact hex/CSS variables, font scale, radii, elevation, and motion feel.
3. **Component Patterns & 4-State Expectations:** Happy, Empty, Loading Skeleton, and Error states visible or implied by the Figma.
4. **Anti-Slop Craft Manifesto:** Explicit banned patterns so `/prototype` and `/craft` honor the design 1:1.

---

## Step 3 — Sync `docs/planning/roadmap.md` & Organize Feature References

1. **Update `docs/planning/roadmap.md`:**
   - Map each distinct screen/workflow from the Figma/PRD into `[ ]` rows classified as **`✨ SIGNATURE CRAFT`** or **`⚙️ PLUMBING`** with `Wave`, `Depends On`, and `Touches`, preserving all existing `[x]` and `[>]` rows.
2. **Link Feature References (Non-Destructive):**
   - Link or copy feature-specific screenshots into `docs/specs/<NN-feature-slug>/design-reference/` without deleting originals in `docs/design-reference/`.

---

## Step 4 — Stop Before Coding & Output Intake Card

Do **not** write application code during `/intake`. End with this concise summary card:

```markdown
## 🎨 Intake Complete: [Project Name]
- **Inputs Ingested:** `[list files in docs/design-reference/ or Figma URL / PRD]`
- **Design System:** `docs/foundation/design-system.md` (`Created` | `Updated`)
- **Roadmap Synced:** `[N] new/updated features in docs/planning/roadmap.md`

👉 **Next Command:** `/prototype <NN-first-feature-slug>`
*(Reply `go` to generate the interactive 4-state prototype & unified spec from your Figma designs now.)*
```
