# 👨‍🍳 `shikamaru-kitchen` (Michelin Brigade System v1.0) — Repository Instructions

**Purpose:** This repository is the **Master Kitchen** for **Culinary-Grade Software Engineering** — an AI-agnostic workflow system for designing, prototyping, and crafting high-taste software across Google Antigravity, Claude Code, Cursor, Codex, and Windsurf.

> **Core Philosophy:** Automate the repetitive *mise en place* (`/prep`) and enforce 0-token mechanical food-safety guardrails so the human Executive Chef can spend 80% of their energy on **taste, interactive prototyping (`/taste`), course-by-course craft (`/cook`), and final plating (`/plate`)**.

---

## 🗺️ Repository Map

| Directory / File | Purpose |
|------------------|---------|
| [`README.md`](README.md) | Overview of the Universal Michelin-Star Software Kitchen philosophy and 5-stage lifecycle |
| [`core/rules/kitchen-protocol.md`](core/rules/kitchen-protocol.md) | Always-on Brigade Guardrails: *Mise en Place*, Tasting Spoon First, 3-Course Cooking Loop, 4-Star Craft Audit, 3-Strike Rule |
| [`core/skills/`](core/skills/) | 5 Universal Culinary Lifecycle Skills (`menu/`, `prep/`, `taste/`, `cook/`, `plate/`) |
| [`core/templates/`](core/templates/) | Universal Stack-Agnostic Templates (`AGENTS.md.template`, `stack-rules.md.template`, `CLAUDE.md.template`, `INDEX.md.template`, `issues.md.template`) |
| [`scripts/`](scripts/) | Sync & Kitchen Eval scripts (`sync-kitchen.ps1`, `sync-kitchen.sh`, `eval-kitchen.ps1`, `eval-kitchen.sh`) |

---

## 🚀 Common Tasks in This Repo

1. **Design a New Product Menu (`/menu`):**
   Run `/menu` (reads `.agents/skills/menu/SKILL.md` or `core/skills/menu/SKILL.md`) to auto-discover/select any tech stack, define Signature Dishes vs. House Staples, lock the Taste System, and tailor `.agents/rules/stack-rules.md` (`<= 80` lines).
2. **Sync the Universal Kitchen Engine into Any Target Project:**
   - PowerShell: `.\scripts\sync-kitchen.ps1 -ProjectPath "..\my-project"`
   - Bash: `bash scripts/sync-kitchen.sh ../my-project`
3. **Run the Michelin Kitchen Eval Suite (`eval-kitchen`):**
   - PowerShell: `.\scripts\eval-kitchen.ps1`
   - Bash: `bash scripts/eval-kitchen.sh`
