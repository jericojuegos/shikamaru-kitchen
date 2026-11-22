---
trigger: always_on
globs: "**/*.php, **/*.ts, **/*.tsx, **/*.js, **/*.scss, composer.json, package.json, phpstan.neon, phpcs.xml.dist"
description: WordPress Hexagonal + Feature-Based Modular Monolith (PSR-4, Ports & Adapters, Selective DDD, React/TS Admin) architecture and security rules
---

# 🏗️ Stack Rules: WordPress Hexagonal Modular Monolith (`wp-hexagonal`)

**Architecture Principle:** Organize by **Feature Module first (`src/Modules/<Feature>/`)**, and **Hexagonal Layer second (`Domain`, `Application`, `Infrastructure`, `Presentation`)**. WordPress is an adapter, not your business domain.

---

## 1. Folder Responsibilities & Dependency Direction (`src/` + `resources/`)

| Path | What Lives Here | What NEVER Lives Here |
|------|-----------------|-----------------------|
| `[plugin-slug].php` & `src/Core/` | Plugin header, Composer autoloader, `Plugin`, `Container`, `ServiceProvider`, `ModuleRegistry` | Feature business logic, inline hook callbacks, raw SQL |
| `src/Modules/<Feature>/Domain/` | **Pure PHP** `Entities/`, `ValueObjects/`, `Contracts/` (Ports/Interfaces), domain `Services/` | **ANY** WordPress function (`get_option`, `WP_User`), `$wpdb`, REST/HTTP, or 3rd-party plugin call |
| `src/Modules/<Feature>/Application/` | Use-case orchestrators (`Commands/`, `Queries/`, `Handlers/`, `DTOs/`) depending only on `Domain/Contracts/` | Direct `$wpdb` queries, `$_POST`/`$_GET`, `WP_REST_Request`, HTML rendering |
| `src/Modules/<Feature>/Infrastructure/` | WordPress & external adapters (`Repositories/` using `$wpdb`/WP APIs, `Persistence/`, `Integrations/` for LearnDash/Woo/APIs) | Business rules/calculations that belong in `Domain/` or UI rendering |
| `src/Modules/<Feature>/Presentation/` | Thin delivery adapters (`Rest/` controllers, `Admin/` screens, `Ajax/` handlers) + `Providers/<Feature>ServiceProvider.php` | Business calculations or direct `$wpdb` queries (must call `Application/` handlers) |
| `src/Shared/` & `src/WordPress/` | Cross-module `Shared/{Contracts,Exceptions,Security,Support}` & `WordPress/{Hooks,Database,Lifecycle,Compatibility}` | Feature-specific logic that belongs inside a single `src/Modules/<Feature>/` |
| `resources/{js,scss,views}/` | React + TypeScript admin UI (`@wordpress/components`, TanStack Query/Table), SCSS (BEM), presentation-only PHP views | Permission enforcement in React alone, business rules, or SQL in views |
| `tests/{Unit,Integration,Feature,Architecture}/` | Fast zero-WP `tests/Unit/` for `Domain` & `Application`; WP test suite in `tests/Integration/`; Playwright E2E | Unmocked destructive production DB operations |

---

## 2. Mandatory Hexagonal, PHP 8.2+ & WordPress Security Standards

1. **Strict Types & Dependency Direction (`Presentation → Application → Domain ← Infrastructure`):**
   - Every PHP file starts with `declare(strict_types=1);` (and `if ( ! defined( 'ABSPATH' ) ) exit;` on entrypoints/views).
   - `Domain/` and `Application/` depend ONLY on interfaces (`Contracts/*Interface.php`). Never over-engineer repositories for a trivial `get_option()`—use ports/repositories where domain logic, complex queries, or isolated unit testing is needed.
2. **Module Isolation (No Cross-Module Internal Imports):**
   - `src/Modules/<FeatureA>/` must NEVER instantiate or import `src/Modules/<FeatureB>/{Infrastructure,Presentation,Domain}/` internals. Cross-module calls must go through `src/Shared/Contracts/` or events registered in `Container`.
3. **REST API, AJAX & Capability Gate (`Security by Default`):**
   - Every `register_rest_route` controller in `Presentation/Rest/` must define an explicit `permission_callback` checking `current_user_can()` (and nonce verification for cookie-authenticated requests).
   - Sanitize all inputs at the `Presentation/` boundary (`sanitize_text_field()`, `absint()`, schema validation) and map into typed `Application/DTOs/` before calling handlers. Escape all PHP view outputs (`esc_html()`, `esc_attr()`, `esc_url()`, `wp_kses_post()`).
4. **Database & Idempotent Migrations (`src/WordPress/Database/`):**
   - Every `$wpdb` query with dynamic inputs in `Infrastructure/Repositories/` MUST use `$wpdb->prepare()`.
   - Manage schema creation and upgrades via versioned, idempotent `dbDelta()` migrations in `src/WordPress/Database/` (never assume `register_activation_hook` runs on plugin updates).
5. **Third-Party Adapter Guards:** Wrap all LearnDash, WooCommerce, ACF, or external plugin calls inside `Infrastructure/Integrations/` adapters guarded by `class_exists()` / `function_exists()`.

---

## 3. Pre-Commit & Hard-Failure Checklist (Verify Before Marking `[x]`)

- [ ] `php -l <file.php>` passes with zero syntax errors on all touched PHP files
- [ ] `Domain/` and `Application/` classes contain **zero** direct calls to `$wpdb`, `WP_User`, `WP_REST_Request`, or unguarded WordPress globals
- [ ] `vendor/bin/phpunit` passes for standalone unit tests in `tests/Unit/` (and `phpstan` / `phpcs` pass when configured)
- [ ] `npm run build` succeeds when `resources/js/` or `resources/scss/` changed
- [ ] **Runtime & Browser Smoke Verification ("Test-Before-Notify"):** When a local WordPress site is reachable, verify REST/admin endpoints, migrations, and UI flows via WP-CLI + live `flash` Browser QA (saving proof screenshots to `docs/specs/<NN-feature-slug>/evidence/` and confirming zero new PHP errors in `wp-content/debug.log`)
- [ ] Every `$wpdb` query uses `$wpdb->prepare()` and every REST/AJAX handler checks `current_user_can()` + nonce
- [ ] Zero cross-module internal imports between sibling `src/Modules/<Feature>/` folders
- [ ] All `AGENTS.md` Critical Constraints satisfied
