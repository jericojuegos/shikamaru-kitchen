# 👨‍🍳 `shikamaru-kitchen` (Michelin Brigade System v1.0) — Repository Instructions

**Purpose:** This repository is the **Master Kitchen** for **Culinary-Grade Software Engineering** — an AI-agnostic workflow system for designing, prototyping, and crafting high-taste software across Google Antigravity, Claude Code, Cursor, Codex, and Windsurf.

> **Core Philosophy:** Automate the repetitive *mise en place* (`/prep`) and enforce 0-token mechanical food-safety guardrails so the human Executive Chef can spend 80% of their energy on **taste, interactive prototyping (`/taste`), course-by-course craft (`/cook`), and final plating (`/plate`)**.

---

## 🗺️ Repository Map

| Directory / File | Purpose |
|------------------|---------|
| [`README.md`](README.md) | Overview of the Michelin-Star Software Kitchen philosophy and 5-stage lifecycle |
| [`INVENTORY.md`](INVENTORY.md) | **Single Source of Truth** catalog of active stack packs, culinary skills, rules, and golden recipe templates |
| [`core/rules/kitchen-protocol.md`](core/rules/kitchen-protocol.md) | Always-on Brigade Guardrails: *Mise en Place*, Tasting Spoon First, 3-Course Cooking Loop, 4-Star Craft Audit, 3-Strike Rule |
| [`core/skills/`](core/skills/) | 5 Culinary Lifecycle Skills (`menu/`, `prep/`, `taste/`, `cook/`, `plate/`) |
| [`core/templates/`](core/templates/) | Root initialization templates (`CLAUDE.md.template`, `INDEX.md.template`, `issues.md.template`) |
| [`stacks/nextjs-supabase/`](stacks/nextjs-supabase/) | Next.js 15+ · React 19 · TypeScript · Supabase · Vercel AI SDK stack pack (`v1.0`) |
| [`stacks/python-fastapi/`](stacks/python-fastapi/) | Python 3.12+ · `uv` · FastAPI · Pydantic v2 · Pytest stack pack (`v1.0`) |
| [`stacks/wp-modular-oop/`](stacks/wp-modular-oop/) | WordPress Modular OOP Plugin & Block Theme stack pack (`v1.0`) |
| [`scripts/`](scripts/) | Sync & Kitchen Eval scripts (`sync-kitchen.ps1`, `sync-kitchen.sh`, `eval-kitchen.ps1`, `eval-kitchen.sh`) |

---

## 🚀 Common Tasks in This Repo

1. **Design a New Product Menu (`/menu`):**
   Run `/menu` (reads `.agents/skills/menu/SKILL.md` or `core/skills/menu/SKILL.md`) to define Signature Dishes vs. House Staples and lock the Taste System.
2. **Sync the Kitchen Engine into a Target Project:**
   - PowerShell: `.\scripts\sync-kitchen.ps1 -ProjectPath "..\my-project" -Stack "nextjs-supabase"`
   - Bash: `bash scripts/sync-kitchen.sh ../my-project nextjs-supabase`
3. **Run the Michelin Kitchen Eval Suite (`eval-kitchen`):**
   - PowerShell: `.\scripts\eval-kitchen.ps1`
   - Bash: `bash scripts/eval-kitchen.sh`
