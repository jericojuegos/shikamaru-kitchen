---
trigger: always_on
globs: "**/*.php, **/*.js, **/*.css, theme.json, block.json, composer.json"
description: Universal 2026 WordPress Stack Rules — Modular OOP Plugins, Block/FSE Themes, and Existing Repo Adaptation
---

# 🏗️ Stack Rules: Universal WordPress (`wp-modular-oop`)

**Supports 3 WordPress Project Shapes** (check `docs/foundation/architecture.md` or existing repo files to see which applies):
- **Shape A — Greenfield WordPress Plugin (Feature-Module OOP):** Isolated modules in `includes/modules/[feature-slug]/` so parallel developers and AI subagents never collide.
- **Shape B — WordPress Block / FSE / Hybrid Theme:** `theme.json` design tokens, `patterns/`, `parts/`, `templates/`, `blocks/[block-slug]/`, and `inc/`.
- **Shape C — Existing Plugin / Framework Repo (Client or Company Repo):** Always inspect and match the existing repo's framework, directory layout, autoloader/namespaces, and prefix first!

---

## 1. Folder Responsibilities & Layer Boundaries

### Shape A: Modular OOP Plugin (`includes/modules/[feature-slug]/`)

| Path | What Lives Here | What NEVER Lives Here |
|------|-----------------|-----------------------|
| `[plugin-slug].php` | Plugin header, constants, activation/deactivation hooks, bootstrap call | Business logic, inline hook callbacks, DB queries |
| `includes/modules/[feature-slug]/` | Self-contained feature module: controller/service class, REST/AJAX handlers, module assets | Cross-module tight coupling without hooks/interfaces |
| `includes/Database/` | Schema creation (`dbDelta()`), migrations, `$wpdb` repository classes | HTML output, admin UI, unescaped inputs |
| `includes/Admin/` | Global admin menu registration, settings, shared admin assets | Complex domain SQL queries |
| `includes/Integrations/` | Third-party plugin adapters (LearnDash, WooCommerce, ACF, BuddyBoss) | Unguarded calls when third-party plugin is inactive |
| `templates/` | Presentation-only PHP/HTML views | `$wpdb` queries, mutations, capability/nonce logic |
| `tests/Unit/[Domain]/` | PHPUnit unit & invariant tests (`*Test.php`) for domain calculations, sanitizers, and validators | Unmocked destructive production DB writes |

### Shape B: Block / FSE / Hybrid Theme

| Path | What Lives Here | What NEVER Lives Here |
|------|-----------------|-----------------------|
| `theme.json` | Global color palette, typography, spacing scale, layout widths | Custom business logic |
| `functions.php` & `inc/` | Theme setup, asset enqueueing, block category/pattern registration, helper functions | Custom post types or plugin-territory business logic |
| `templates/` & `parts/` | Block HTML templates and template parts (`header.html`, `footer.html`) | Hardcoded inline styles where `theme.json` tokens exist |
| `patterns/` | Reusable PHP/HTML block patterns | Raw SQL queries or unescaped dynamic output |
| `blocks/[block-slug]/` | Custom Gutenberg blocks (`block.json`, `render.php`, `index.js`, `style.css`) | Global side effects outside the block |

---

## 2. Mandatory 2026 WordPress Security & PHP 8.2+ Standards

1. **Strict Types & Direct Access Guard:** Every PHP class/file must begin with `declare(strict_types=1);` (where supported by repo) and:
   ```php
   if ( ! defined( 'ABSPATH' ) ) {
       exit;
   }
   ```
2. **Prepared SQL Only:** Every `$wpdb` query containing variables must use `$wpdb->prepare()`. Use `dbDelta()` for custom table creation/upgrades.
3. **Nonce + Capability on Every Endpoint (REST API & AJAX):**
   - Prefer **WP REST API (`register_rest_route`)** with an explicit `permission_callback` checking `current_user_can()` + `X-WP-Nonce` for modern endpoints.
   - For `wp_ajax_` / form handlers, always verify `check_ajax_referer()` / `check_admin_referer()` **AND** `current_user_can()` before reading sensitive data or mutating state.
4. **Sanitize Input, Escape Output:**
   - Sanitize `$_POST` / `$_GET` / `WP_REST_Request` params immediately (`sanitize_text_field()`, `absint()`, `sanitize_email()`, `sanitize_key()`, `wp_kses_post()`).
   - Escape every echoed variable in `templates/` or `render.php` (`esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`).
5. **Prefix & Namespace Everything:** Prefix all functions, hooks, options, DB tables, and script/style handles (and use PSR-4 namespaces or prefixed class names matching the repo).
6. **Third-Party Plugin Guards:** Always wrap LearnDash, WooCommerce, ACF, BuddyBoss, or Tangible Framework calls in `function_exists()` or `class_exists()` checks.

---

## 3. Pre-Commit & Hard-Failure Checklist (Verify Before Marking `[x]`)

- [ ] `php -l <file.php>` passes with zero syntax errors on all touched PHP files
- [ ] `vendor/bin/phpunit` passes for all unit tests in `tests/Unit/` (when PHPUnit is configured)
- [ ] **Runtime & Browser Smoke Verification ("Test-Before-Notify"):** When a local WordPress site is reachable, verify module toggles, settings saves (`wp_options`), REST/AJAX endpoints, and frontend hooks/shortcodes via WP-CLI (`wp eval` / `wp option get`) + live `flash` Browser QA (saving proof screenshots to `docs/specs/<NN-feature-slug>/evidence/` and confirming zero new PHP warnings/errors in `wp-content/debug.log`) before notifying the user
- [ ] `if ( ! defined( 'ABSPATH' ) ) exit;` at the top of every PHP file
- [ ] All `$wpdb` queries with dynamic values use `$wpdb->prepare()`
- [ ] Every REST/AJAX/form handler checks both nonce/auth and `current_user_can()`
- [ ] All inputs sanitized on entry and all template outputs escaped on render
- [ ] Zero SQL queries or business mutations inside `templates/` or `[plugin-slug].php`
- [ ] Third-party plugin calls guarded by `function_exists()` / `class_exists()`
- [ ] All `AGENTS.md` Critical Constraints satisfied
