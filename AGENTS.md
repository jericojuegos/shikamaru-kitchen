# 👨‍🍳 `shikamaru-kitchen` (Michelin-Grade Software Craft Engine v1.0) — Repository Instructions

**Purpose:** This repository is the **Master Software Craft Engine** — an AI-agnostic workflow system for designing, prototyping, and crafting high-taste software across Google Antigravity, Claude Code, Cursor, Codex, and Windsurf.

> **Core Philosophy:** Automate the repetitive *mise en place* (`/scaffold`) and enforce 0-token mechanical architecture guardrails so the human engineer can spend 80% of their energy on **interactive 4-state UI prototyping (`/prototype`), 3-pass guided implementation (`/craft`), and 4-point UX/code polish (`/polish`)**.

---

## 🗺️ Repository Map

| Directory / File | Purpose |
|------------------|---------|
| [`README.md`](README.md) | Overview of the Michelin-Grade Software Craft philosophy and 5-stage lifecycle |
| [`.agents/rules/kitchen-protocol.md`](.agents/rules/kitchen-protocol.md) | Always-on Craft Guardrails: *Mise en Place*, Interactive Prototype First, 3-Pass Build Loop, 4-Point Craft Audit, 3-Strike Rule |
| [`.agents/skills/`](.agents/skills/) | 5 Universal Software Craft Lifecycle Skills (`design/`, `scaffold/`, `prototype/`, `craft/`, `polish/`) |
| [`.agents/templates/`](.agents/templates/) | Universal Stack-Agnostic Templates (`AGENTS.md.template`, `stack-rules.md.template`, `CLAUDE.md.template`, `INDEX.md.template`, `issues.md.template`) |
| [`scripts/`](scripts/) | Sync & Eval scripts (`sync-kitchen.ps1`, `sync-kitchen.sh`, `eval-kitchen.ps1`, `eval-kitchen.sh`) |

---

## 🚀 Common Tasks in This Repo

1. **Design a New Product (`/design`):**
   Run `/design` (reads `.agents/skills/design/SKILL.md`) to auto-discover/select any tech stack, define Signature Craft vs. Plumbing features, lock `design-system.md`, and tailor `.agents/rules/stack-rules.md` (`<= 80` lines).
2. **Sync the Universal Craft Engine into Any Target Project:**
   - PowerShell: `.\scripts\sync-kitchen.ps1 -ProjectPath "..\my-project"`
   - Bash: `bash scripts/sync-kitchen.sh ../my-project`
3. **Run the Eval Suite (`eval-kitchen`):**
   - PowerShell: `.\scripts\eval-kitchen.ps1`
   - Bash: `bash scripts/eval-kitchen.sh`
