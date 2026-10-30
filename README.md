<div align="center">

# 🖥️ SNBD Host — WHMCS Portal Theme

### A fully custom, SaaS-grade WHMCS client area for [SNBD Host](https://snbdhost.com)

<img src="https://img.shields.io/badge/WHMCS-8.x-BA1114?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHJ4PSI0IiBmaWxsPSIjZTUzOTM1Ii8+PHBhdGggZD0iTTcgN2gxMHYxMEg3eiIgZmlsbD0iI2ZmZiIvPjwvc3ZnPg==&logoColor=white" alt="WHMCS 8.x"/>
<img src="https://img.shields.io/badge/PHP-7.4%2B-777bb4?style=for-the-badge&logo=php&logoColor=white" alt="PHP 7.4+"/>
<img src="https://img.shields.io/badge/Bootstrap-5.3-7952b3?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap 5.3"/>
<img src="https://img.shields.io/badge/Version-3.0.0-BA1114?style=for-the-badge" alt="v3.0.0"/>
<img src="https://img.shields.io/badge/Status-Stable-2e7d32?style=for-the-badge" alt="Status: Stable"/>
<img src="https://img.shields.io/badge/License-Proprietary-333333?style=for-the-badge" alt="License"/>

One design system — a single red on neutral gray, a persistent left sidebar and a shared
component layer — themed templates on the front end, PHP hooks on the back end.

</div>

<br/>

<div align="center">

[**Screenshots**](#-screenshots) · [**How It Works**](#-how-it-works) · [**Hooks**](#-hooks) · [**Features**](#-features) · [**File Structure**](#-file-structure) · [**Installation**](#-installation) · [**Customization**](#-customization)

</div>

<br/>

---

<br/>

## 🚀 What's New in v3.0.0 — whole-application redesign

<table>
<tr><th align="left" width="200">Area</th><th align="left">Change</th></tr>
<tr><td>🎨 Design system</td><td><code>snbd-system.css</code> replaces three competing palettes with one red (<code>#BA1114</code>) on a neutral ramp, one type scale and one radius scale</td></tr>
<tr><td>🧭 Navigation</td><td>A single persistent left sidebar (collapsible rail on desktop, off-canvas + backdrop on mobile). The duplicate topbar nav is gone.</td></tr>
<tr><td>🧱 Components</td><td>Cards, stats, tables, chips, buttons, forms, alerts, tabs, menus, modals and empty states are defined once and reused on every page</td></tr>
<tr><td>📄 Page cleanup</td><td>Page-level <code>&lt;style&gt;</code> blocks and dozens of inline styles removed from every customised template; pages migrated to the shared components</td></tr>
<tr><td>📦 Page coverage</td><td>Account details, add funds, mass pay, quotes, email history, payment methods, knowledge base, announcements, contact, downloads and account security now have their own templates, so every link the sidebar, topbar and account menu offer lands on the same system</td></tr>
<tr><td>🌉 Legacy bridge</td><td>Pages WHMCS ships that the theme has not rebuilt (store, user profile, upgrade flows) still render parent markup; <code>snbd-legacy.css</code> re-skins them. A new template opts in automatically — no list to edit</td></tr>
<tr><td>⚙️ Bootstrap</td><td>Exactly one Bootstrap per page — Bootstrap 5 on rebuilt pages, parent Bootstrap 4 on legacy pages — ending the 4/5 class collision</td></tr>
<tr><td>🛒 Cart</td><td>Order form tokens aliased to the shared system, one brand red, hard-coded hexes removed</td></tr>
<tr><td>♿ Access</td><td>Skip link, <code>aria-current</code> navigation, labelled icon buttons, visible focus rings, 44px targets and reduced-motion support</td></tr>
<tr><td>🧹 Dead code</td><td>Removed the phantom announcement offset, FAB, particles, loader, unused loyalty styles and 500 KB of unreferenced parent CSS/JS</td></tr>
</table>

<br/>

---

<br/>

## 📸 Screenshots

<table>
<tr>
<td align="center" width="50%"><img src="screenshots/dashboard.png" alt="Dashboard" width="100%"/><br/><sub><b>Dashboard</b></sub></td>
<td align="center" width="50%"><img src="screenshots/services.png" alt="My Services" width="100%"/><br/><sub><b>My Services</b></sub></td>
</tr>
<tr>
<td align="center" width="50%"><img src="screenshots/invoices.png" alt="Invoices" width="100%"/><br/><sub><b>Invoices</b></sub></td>
<td align="center" width="50%"><img src="screenshots/invoice-view.png" alt="Invoice Detail" width="100%"/><br/><sub><b>Invoice Detail</b></sub></td>
</tr>
</table>

<br/>

---

<br/>

## 🧩 How It Works

This project is **two systems working together**:

1. **The theme** (`templates/snbdhost/`) — Smarty `.tpl` files, CSS, and JS that WHMCS renders whenever a client loads the portal. This is purely presentational: it receives variables from WHMCS core and from hooks, and renders them.
2. **The logic layer** (`includes/hooks/` + `modules/addons/snbdhost_manager/`) — PHP that runs *before* the templates render, using the WHMCS **Hooks API** to inject extra data, intercept requests, validate forms, and rewrite HTML output.

```
┌─────────────────────────────────────────────────────────────────────┐
│  1. Client requests a page  (e.g. clientarea.php?action=home)       │
└───────────────────────────────┬─────────────────────────────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  2. WHMCS core builds the default $vars for that page                │
└───────────────────────────────┬─────────────────────────────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  3. WHMCS fires named hook points — every add_hook() listening on    │
│     that point runs and can return extra Smarty variables or HTML    │
│                                                                       │
│     includes/hooks/snbdhost_dashboard_hook.php  ─┐                    │
│     modules/addons/snbdhost_manager/hooks.php    ─┼─► merged into     │
│                                                    │   the template   │
│                                                    │   variable pool  │
└───────────────────────────────┬─────────────────────────────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  4. Smarty renders templates/snbdhost/*.tpl using WHMCS core vars     │
│     PLUS everything the hooks injected ($loyalty_data, $open_tickets, │
│     turnstileEnabled, googleClientId, affiliateProductGroups, ...)    │
└───────────────────────────────┬─────────────────────────────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│  5. theme.yaml falls back to the stock "twenty-one" theme for any     │
│     template file that snbdhost/ doesn't override                    │
└─────────────────────────────────────────────────────────────────────┘
```

**Why hooks instead of editing WHMCS core?** WHMCS core files are overwritten on every WHMCS update. Hooks and theme overrides live entirely outside core, so the customizations in this repo survive WHMCS upgrades untouched.

**The addon module** (`snbdhost_manager`) is the admin-facing control panel for the whole system — it stores settings in `tbladdonmodules` (GitHub repo for one-click updates, UptimeRobot API key, Google OAuth client ID, Turnstile keys, n8n promo copy, developer mode) that the hooks read at runtime. Nothing is hardcoded — every togglable behavior below is configured from **Addons → SNBDHost Theme Manager** in the WHMCS admin.

<br/>

---

<br/>

## 🪝 Hooks

All server-side logic lives in two hook files, both using WHMCS's `add_hook('EventName', priority, callback)` API. Hooks are the **only** supported way this theme talks to the database or intercepts requests — templates themselves stay logic-free.

<table>
<tr><th align="left" width="230">File</th><th align="left">Role</th></tr>
<tr>
<td><code>includes/hooks/<br/>snbdhost_dashboard_hook.php</code></td>
<td>Standalone, dependency-free hook file. Feeds the dashboard and affiliates page with data the stock WHMCS theme doesn't provide.</td>
</tr>
<tr>
<td><code>modules/addons/<br/>snbdhost_manager/hooks.php</code></td>
<td>Bundled with the <b>SNBDHost Theme Manager</b> addon module. Everything here reads its configuration from the addon's settings, so it can be toggled without touching code.</td>
</tr>
</table>

### `includes/hooks/snbdhost_dashboard_hook.php`

| Hook Point | Purpose |
|---|---|
| `ClientAreaPage` | Sets `$snbdCustomTemplate` by checking whether the page's `templatefile` exists in this theme. The header uses it to load one Bootstrap per page, so a page joins the SNBD design system by having a template file rather than by being listed anywhere. |
| `ClientAreaPageHome` | Queries `tblinvoices`, `tblhosting`, `mod_loyaltymatrix_*`, and `tbltickets` directly via `Capsule` to build `$invoices` (last 5), `$services` (active/pending), `$loyalty_data` (tier + progress to next tier), and `$open_tickets` (last 5 unresolved) — all in the client's own currency format. |
| `ClientAreaPageAffiliates` | Builds `$affiliateProductGroups`, a nested list of visible product groups and their products, used to power custom referral-link generation on the affiliates page. |

Both hooks wrap every query in `try/catch (\Throwable)` and return an empty result on failure rather than throwing — a broken Loyalty Matrix install, for example, degrades the dashboard gracefully instead of white-screening it.

### `modules/addons/snbdhost_manager/hooks.php`

| Hook Point | Purpose |
|---|---|
| `ClientAreaPage` *(×2)* | (1) Handles the AJAX profile-completion form (`snbd_action=save_profile`) posted from the dashboard modal, validating and forwarding to the `UpdateClient` API. (2) Exposes `$googleClientId` to `login`/`clientregister` templates, and `turnstileEnabled` / `turnstileSiteKey` to every page when Cloudflare Turnstile is turned on. |
| `ClientAreaPrimarySidebar` | Removes the **Security Settings** sidebar link for accounts still carrying placeholder OAuth profile data, until the client completes their profile. |
| `AdminHomeWidgets` | Registers `SnbdhostThemeWidget`, a WHMCS admin dashboard widget (theme/version status at a glance). |
| `AdminAreaFooterOutput` | Renders `DashboardTopNotice` (update/announcement banner) on the admin dashboard only. |
| `ClientAreaPageHome` | Reads the addon's `developer_mode` and n8n-promo settings from `tbladdonmodules`, checks whether the client owns an n8n product, and exposes the promo title/description/URL/button text used by the in-dashboard n8n masterclass segment. |
| `ClientAreaFooterOutput` *(×2)* | (1) Injects the profile-completion modal markup on `clientareahome` when required fields are still placeholder values. (2) On `clientareaproductdetails`, runs the **client-side n8n dashboard transformer** as a JS fallback when the server-side output hook (below) didn't already convert the page. |
| `init` | Fires before routing on every request. When Turnstile is enabled, intercepts `login.php`, `contact.php`, and `pwreset.php` `POST`s early to validate the captcha token before WHMCS processes the form. |
| `ClientDetailsValidation` | Rejects client registration when Turnstile is enabled and the submitted token fails verification. |
| `ShoppingCartValidateCheckout` | Rejects checkout submission on captcha failure, same Turnstile flow, scoped to the cart. |
| `TicketOpenValidation` | Rejects new support ticket submission on captcha failure. |
| `ClientAreaProductDetailsOutput` | Server-side rewrite: detects n8n products by name/module/domain heuristics (`isSnbdhostN8nProduct()`) and replaces the raw module HTML with `renderSnbdhostN8nDashboardHtml()` — a themed dashboard — **before** it ever reaches the template. |
| `ClientAreaPageProductDetails` | Same n8n detection, applied to `$vars['tplOverviewTabOutput']` / `$vars['moduleclientarea']` so the transform also covers the overview tab path some server modules use instead of raw output. |

> **Design note:** the two n8n hooks (`ClientAreaProductDetailsOutput` + `ClientAreaPageProductDetails`) intentionally overlap — different server modules populate different variables, so both paths are covered. The `ClientAreaFooterOutput` JS transformer is the last-resort fallback if neither PHP hook could rewrite the HTML (e.g. content loaded via a later AJAX call).

### Installing the hooks

```bash
# Standalone dashboard hook
cp includes/hooks/snbdhost_dashboard_hook.php /path/to/whmcs/includes/hooks/

# Addon module (bundles its own hooks.php — installs automatically once activated)
cp -r modules/addons/snbdhost_manager /path/to/whmcs/modules/addons/
# Then in WHMCS Admin → System Settings → Addon Modules → Activate "SNBDHost Theme Manager"
```

Hook files are auto-loaded by WHMCS on every request from `includes/hooks/` — no registration step needed beyond copying the file. Addon-module hooks load automatically once the module is activated from **Addons**.

<br/>

---

<br/>

## ✨ Features

<table>
<tr><td width="33%">🎨 <b>One Design System</b><br/><sub>Persistent sidebar + sticky topbar, one red on neutral gray</sub></td>
<td width="33%">📊 <b>Stat Cards</b><br/><sub>Metric cards for services, invoices, balance & tickets</sub></td>
<td width="33%">🏆 <b>Loyalty Matrix</b><br/><sub>Full-width tier card with progress to the next tier</sub></td></tr>
<tr><td>🧾 <b>Custom Invoice</b><br/><sub>Print-ready invoice document with gateway selector</sub></td>
<td>💳 <b>Gateway Switcher</b><br/><sub>Payment method selector on invoice pages</sub></td>
<td>🔍 <b>Working Search</b><br/><sub>Topbar search that queries the WHMCS Knowledge Base</sub></td></tr>
<tr><td>🎫 <b>Ticket Chat UI</b><br/><sub>Chat-bubble ticket thread with avatar initials</sub></td>
<td>⚡ <b>Command Shortcuts</b><br/><sub>Press <kbd>/</kbd> to search, <kbd>Esc</kbd> to close menus</sub></td>
<td>🔐 <b>Auth Pages</b><br/><sub>Login, register & password reset on the shared system</sub></td></tr>
<tr><td>🛒 <b>Custom Order Cart</b><br/><sub>Order form on the same tokens as the client area</sub></td>
<td>📱 <b>Fully Responsive</b><br/><sub>Sidebar rail on desktop, off-canvas drawer on mobile</sub></td>
<td>🤖 <b>n8n Dashboard</b><br/><sub>Auto-transforms n8n product pages into a modern client dashboard</sub></td></tr>
<tr><td>🛡️ <b>Cloudflare Turnstile</b><br/><sub>Optional captcha across login, register, checkout & tickets</sub></td>
<td>🔑 <b>Google Sign-In</b><br/><sub>OAuth login/register, client ID managed from the addon</sub></td>
<td>🪝 <b>PHP Hooks</b><br/><sub>Server-side hooks power everything above — see <a href="#-hooks">Hooks</a></sub></td></tr>
</table>

<br/>

---

<br/>

## 📁 File Structure

```
SNBDHOST Portal template/
│
├── 📄 README.md                              ← You are here
├── 📁 screenshots/                           UI screenshots for documentation
│
├── 📁 includes/                              ═══ STANDALONE HOOK ═══
│   └── 📁 hooks/
│       └── 📄 snbdhost_dashboard_hook.php     Dashboard + affiliates data injection
│
├── 📁 modules/                                ═══ ADDON MODULE ═══
│   └── 📁 addons/
│       └── 📁 snbdhost_manager/
│           ├── 📄 snbdhost_manager.php        Config, activation, admin settings UI
│           ├── 📄 hooks.php                   14 hook points — see Hooks section
│           └── 📁 lib/
│               ├── 📄 SnbdhostThemeWidget.php  Admin dashboard widget
│               ├── 📄 DashboardTopNotice.php   Admin update/announcement banner
│               ├── 📄 ModuleManager.php        Managed external module installer
│               └── 📄 Updater.php              One-click GitHub theme updater
│
└── 📁 templates/
    │
    ├── 📁 snbdhost/                           ═══ CLIENT AREA THEME ═══
    │   ├── 📄 header.tpl                      HTML head, persistent sidebar, topbar, search
    │   ├── 📄 footer.tpl                      Page close, JS dependencies
    │   │
    │   ├── ── Pages ──────────────────────
    │   ├── 📄 clientareahome.tpl              Dashboard (stats, loyalty, invoices, news)
    │   ├── 📄 clientareaproducts.tpl          My Services — card grid layout
    │   ├── 📄 clientareaproductdetails.tpl    Product details — n8n dashboard embed target
    │   ├── 📄 clientareainvoices.tpl          Invoice list — sortable table
    │   ├── 📄 viewinvoice.tpl                 Invoice detail — print-ready document inside the shell
    │   ├── 📄 clientareaquotes.tpl            Quotes list · viewquote.tpl prints and accepts one
    │   ├── 📄 clientareaemails.tpl            Email history · viewemail.tpl standalone popup
    │   ├── 📄 masspay.tpl                     Pay several invoices in one payment
    │   ├── 📄 clientareaaddfunds.tpl          Balance top-up with gateway picker
    │   ├── 📄 clientareadetails.tpl           My details — contact, billing, preferences
    │   ├── 📄 account-paymentmethods.tpl      Stored cards/bank accounts, set default, delete
    │   ├── 📄 clientareasecurity.tpl          Single sign-on toggle
    │   ├── 📄 knowledgebase.tpl               Knowledge base index · knowledgebasecat.tpl · knowledgebasearticle.tpl
    │   ├── 📄 downloads.tpl                   Downloads index · downloadscat.tpl file list
    │   ├── 📄 announcements.tpl               Service notices · viewannouncement.tpl detail
    │   ├── 📄 contact.tpl                     Pre-sales contact form
    │   ├── 📄 supportticketslist.tpl          Support tickets list
    │   ├── 📄 viewticket.tpl                  Ticket thread — chat bubble UI
    │   │
    │   ├── ── Auth ───────────────────────
    │   ├── 📄 login.tpl                       Login page — split panel with Google sign-in
    │   ├── 📄 clientregister.tpl              Registration page
    │   ├── 📄 pwreset.tpl                     Password reset page
    │   │
    │   ├── ── Assets ─────────────────────
    │   ├── 📁 assets/
    │   │   ├── 📁 css/snbd-system.css         Design tokens, typography, shared components
    │   │   ├── 📁 css/snbd-shell.css          Sidebar, topbar, rail mode, mobile off-canvas
    │   │   ├── 📁 css/snbd-pages.css          Page layouts: dashboard → tickets → auth → status
    │   │   ├── 📁 css/snbd-legacy.css         Bridge for WHMCS pages that use parent markup
    │   │   └── 📁 js/snbd-shell.js            Sidebar, popovers, modals, copy, passwords, prices
    │   │
    │   ├── 📁 css/                            WHMCS core CSS overrides
    │   ├── 📁 js/                             WHMCS core JS
    │   ├── 📁 images/ · 📁 img/                Theme images
    │   └── 📄 theme.yaml                      WHMCS theme config (fallback: twenty-one)
    │
    └── 📁 orderforms/
        ├── 📁 snbdhost_cart/                  ═══ CUSTOM ORDER FORM ═══
        │   ├── 📄 common.tpl · products.tpl · configureproduct.tpl · checkout.tpl
        │   ├── 📄 viewcart.tpl · complete.tpl · fraudcheck.tpl · error.tpl
        │   ├── 📄 domainregister.tpl · domaintransfer.tpl · domainoptions.tpl
        │   ├── 📁 css/custom.css               Custom cart styles (Red & White)
        │   ├── 📁 js/ · 📁 includes/
        │   └── 📄 theme.yaml                   Cart theme config
        │
        └── 📁 orderforms-standard_cart/        ═══ STANDARD CART (backup) ═══
```

<br/>

---

<br/>

## 🚀 Installation

### Prerequisites

- **WHMCS** 8.x or later
- **PHP** 7.4+
- **Bootstrap 5.3** (loaded via CDN — no build step required)

### Steps

```bash
# 1. Clone or download this repository
git clone https://github.com/yeaminlabs/snbdhost-whmcs-template.git

# 2. Copy the client area theme
cp -r templates/snbdhost /path/to/whmcs/templates/

# 3. Copy the custom order form
cp -r templates/orderforms/snbdhost_cart /path/to/whmcs/templates/orderforms/

# 4. Copy the standalone dashboard hook
cp includes/hooks/snbdhost_dashboard_hook.php /path/to/whmcs/includes/hooks/

# 5. Copy and activate the addon module (bundles its own hooks + admin settings)
cp -r modules/addons/snbdhost_manager /path/to/whmcs/modules/addons/
#    → WHMCS Admin → System Settings → Addon Modules → Activate "SNBDHost Theme Manager"

# 6. Set the theme in WHMCS Admin
#    → Setup → General Settings → Ordering tab
#    → Template: snbdhost
#    → Order Form Template: snbdhost_cart
```

### Theme Configuration

```yaml
# templates/snbdhost/theme.yaml
parent: twenty-one
```

> Any template file not found in `snbdhost/` automatically falls back to the stock `twenty-one` WHMCS theme.

<br/>

---

<br/>

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | WHMCS 8.x (Smarty Templates + Hooks API) |
| **CSS Framework** | Bootstrap 5.3 on redesigned pages; parent Bootstrap 4 + `snbd-legacy.css` bridge on pages still using Twenty-One markup (one Bootstrap per page) |
| **Typography** | Inter (body) + Plus Jakarta Sans (display) via Google Fonts |
| **Icons** | Tabler Icons 3.x; Font Awesome only on legacy pages and the order form |
| **Animations** | CSS transitions only — no particle, loader or FAB layers |
| **JavaScript** | Vanilla JS for the shell; jQuery/WHMCS utilities for core pages |
| **Server Logic** | PHP hooks + `WHMCS\Database\Capsule` query builder |
| **Security** | Cloudflare Turnstile (optional captcha), Google OAuth 2.0 |

<br/>

---

<br/>

## 🎨 Customization

### Brand Colors

One red, one neutral ramp, one radius scale — all defined in `assets/css/snbd-system.css`. Change these and every page, card and control follows:

```css
:root {
  --snbd-red: #BA1114;                 /* The only accent colour */
  --snbd-red-hover: #9E0D10;
  --snbd-red-soft: rgba(186, 17, 20, 0.06);

  --snbd-canvas: #F7F7F4;              /* Page background */
  --snbd-surface: #FFFFFF;             /* Cards and panels */
  --snbd-surface-2: #FAFAF8;           /* Subtle fills and table heads */
  --snbd-line: #E7E4DE;                /* Hairline borders */

  --snbd-ink-900: #14161A;             /* Primary text */
  --snbd-ink-700: #3C4248;
  --snbd-ink-500: #6B7278;             /* Secondary text */
}
```

Status colours (`--snbd-ok`, `--snbd-warn`, `--snbd-bad`, `--snbd-info`) are always paired with a dot or icon, never colour alone.

### Layout Dimensions

```css
:root {
  --snbd-sidebar-w: 264px;      /* Sidebar width (expanded) */
  --snbd-sidebar-rail: 76px;    /* Sidebar width (collapsed rail, ≥1200px) */
  --snbd-topbar-h: 60px;        /* Sticky topbar height */
}
```

The sidebar is the single navigation system: persistent on desktop (collapsible to a rail), off-canvas with a backdrop below 1024px. There is no second topbar nav.

### Adding a new page

Use the shared components instead of page CSS — `snbd-page-head`, `snbd-card`, `snbd-stats`, `snbd-table`, `snbd-chip`, `snbd-btn`, `snbd-form`. A page that still falls back to the parent theme is automatically bridged by `snbd-legacy.css`.

<br/>

---

<br/>

## 📋 Template Variable Reference

| Variable | Source | Used In |
|---|---|---|
| `{$clientsdetails}` | WHMCS Core | header, dashboard |
| `{$clientsstats}` | WHMCS Core | dashboard stat cards |
| `{$homepageproducts}` | WHMCS Core | dashboard services table |
| `{$invoices}` | WHMCS Core + hook override | dashboard + invoices page |
| `{$announcements}` | WHMCS Core | dashboard news panel |
| `{$gateways}` | WHMCS Core | invoice gateway switcher |
| `{$loyalty_data}` | `snbdhost_dashboard_hook.php` | dashboard loyalty card |
| `{$open_tickets}` | `snbdhost_dashboard_hook.php` | dashboard open-tickets widget |
| `{$affiliateProductGroups}` | `snbdhost_dashboard_hook.php` | affiliates page |
| `{$googleClientId}` | `snbdhost_manager/hooks.php` | login, clientregister |
| `{$turnstileEnabled}` / `{$turnstileSiteKey}` | `snbdhost_manager/hooks.php` | login, register, checkout, tickets |

<br/>

---

<br/>

## 🔗 Related Modules

| Module | Description |
|---|---|
| **SNBDHost Theme Manager** | Addon module — one-click GitHub theme updates, managed module installer, admin widgets, and every setting the hooks read at runtime |
| **Loyalty Matrix** | Third-party tiered discount system — data surfaced on the dashboard via hooks |
| **n8n Dashboard Transformer** | Detects n8n hosting products and rewrites their module output into a themed client dashboard |

<br/>

---

<br/>

## 📄 License

This theme is proprietary software developed for **SNBD Host**. All rights reserved.

<br/>

<div align="center">
<sub>Built with ❤️ by the <strong>SNBD Host</strong> team — Dhaka, Bangladesh</sub>
</div>
