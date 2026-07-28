<!-- ====== DEVELOPER UPDATES PAGE ====== -->
<style>
/* ── Page Header ── */
.updates-page-header {
    background: linear-gradient(135deg, #0d0d0d 0%, #1a0000 45%, #2d0000 75%, #CC0000 100%);
    border-radius: 20px;
    padding: 3rem 2.5rem;
    margin-bottom: 2.5rem;
    position: relative;
    overflow: hidden;
}
.updates-page-header::before {
    content: '';
    position: absolute; inset: 0;
    background: radial-gradient(ellipse at 80% 50%, rgba(255,80,80,0.15) 0%, transparent 65%);
    pointer-events: none;
}
.updates-page-header-grid {
    position: absolute; inset: 0;
    background-image:
        linear-gradient(rgba(255,255,255,0.025) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.025) 1px, transparent 1px);
    background-size: 36px 36px;
    pointer-events: none;
}
.updates-header-eyebrow {
    display: inline-flex; align-items: center; gap: 0.45rem;
    background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.18);
    color: rgba(255,255,255,0.9); padding: 0.35rem 1rem;
    border-radius: 50rem; font-size: 0.72rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 1.5px;
    margin-bottom: 1.25rem; backdrop-filter: blur(10px);
}
.updates-header-title {
    font-size: clamp(2rem, 3.5vw, 2.75rem);
    font-weight: 900; color: #fff;
    letter-spacing: -0.04em; line-height: 1.1;
    margin-bottom: 0.75rem;
}
.updates-header-title span {
    background: linear-gradient(135deg, #ff7070, #ffb0b0);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
}
.updates-header-sub {
    font-size: 0.95rem; color: rgba(255,255,255,0.6);
    font-weight: 400; line-height: 1.6; max-width: 520px;
}
.updates-header-meta {
    display: flex; gap: 1.5rem; margin-top: 1.75rem; flex-wrap: wrap;
}
.updates-header-meta-item {
    display: flex; flex-direction: column; gap: 0.1rem;
}
.updates-header-meta-label {
    font-size: 0.68rem; font-weight: 700; color: rgba(255,255,255,0.45);
    text-transform: uppercase; letter-spacing: 1px;
}
.updates-header-meta-val {
    font-size: 1rem; font-weight: 800; color: #fff;
}

/* ── Timeline ── */
.changelog-timeline {
    position: relative;
}
.changelog-timeline::before {
    content: '';
    position: absolute; left: 22px; top: 0; bottom: 0;
    width: 2px;
    background: linear-gradient(to bottom, #CC0000 0%, rgba(204,0,0,0.15) 100%);
}

/* ── Version Card ── */
.version-card {
    background: #ffffff;
    border: 1px solid #eeeeee;
    border-radius: 18px;
    padding: 1.75rem 2rem 1.75rem 2rem;
    margin-left: 56px;
    margin-bottom: 2rem;
    position: relative;
    transition: box-shadow 0.22s, border-color 0.22s;
}
.version-card:hover {
    box-shadow: 0 8px 32px rgba(0,0,0,0.06);
    border-color: #ddd;
}
.version-card::before {
    content: '';
    position: absolute;
    left: -42px; top: 1.6rem;
    width: 14px; height: 14px;
    background: #CC0000;
    border: 3px solid #fff;
    border-radius: 50%;
    box-shadow: 0 0 0 3px rgba(204,0,0,0.2);
}
.version-card.latest::before {
    width: 18px; height: 18px;
    left: -44px; top: 1.45rem;
    box-shadow: 0 0 0 4px rgba(204,0,0,0.25), 0 0 12px rgba(204,0,0,0.3);
}
.version-card-head {
    display: flex; align-items: flex-start; gap: 1rem;
    margin-bottom: 1.25rem; flex-wrap: wrap;
}
.version-number {
    font-size: 1.35rem; font-weight: 900;
    color: #111; letter-spacing: -0.03em;
}
.version-date {
    font-size: 0.8rem; font-weight: 600; color: #757575;
    margin-top: 0.15rem;
}
.version-badge {
    display: inline-flex; align-items: center; gap: 0.35rem;
    padding: 0.3rem 0.85rem; border-radius: 50rem;
    font-size: 0.68rem; font-weight: 800;
    text-transform: uppercase; letter-spacing: 0.8px;
}
.version-badge.latest {
    background: rgba(204,0,0,0.09); color: #CC0000; border: 1px solid rgba(204,0,0,0.2);
}
.version-badge.stable {
    background: rgba(0,140,60,0.08); color: #007a32; border: 1px solid rgba(0,140,60,0.18);
}
.version-badge.legacy {
    background: rgba(0,0,0,0.05); color: #666; border: 1px solid #ddd;
}

/* ── Change Items ── */
.change-group { margin-bottom: 1.25rem; }
.change-group:last-child { margin-bottom: 0; }
.change-group-label {
    font-size: 0.7rem; font-weight: 800; text-transform: uppercase;
    letter-spacing: 1px; color: #757575; margin-bottom: 0.6rem;
    display: flex; align-items: center; gap: 0.45rem;
}
.change-group-label::after {
    content: ''; flex: 1; height: 1px; background: #efefef;
}
.change-list { list-style: none; padding: 0; margin: 0; }
.change-item {
    display: flex; align-items: flex-start; gap: 0.6rem;
    font-size: 0.875rem; color: #333; font-weight: 500;
    line-height: 1.5; padding: 0.3rem 0;
}
.change-item .ci-dot {
    flex-shrink: 0; width: 6px; height: 6px;
    border-radius: 50%; margin-top: 0.45rem;
}
.ci-dot.ui     { background: #3b82f6; }
.ci-dot.perf   { background: #f59e0b; }
.ci-dot.sec    { background: #10b981; }
.ci-dot.fix    { background: #ef4444; }
.ci-dot.new    { background: #8b5cf6; }
.ci-dot.infra  { background: #6b7280; }

/* ── Tag pills ── */
.ci-tag {
    display: inline-block; padding: 0.1rem 0.55rem;
    border-radius: 50rem; font-size: 0.62rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 0.5px;
    flex-shrink: 0; margin-top: 0.25rem;
}
.ci-tag.ui     { background: rgba(59,130,246,0.09); color: #3b82f6; }
.ci-tag.perf   { background: rgba(245,158,11,0.09); color: #b45309; }
.ci-tag.sec    { background: rgba(16,185,129,0.09); color: #065f46; }
.ci-tag.fix    { background: rgba(239,68,68,0.09);  color: #dc2626; }
.ci-tag.new    { background: rgba(139,92,246,0.09); color: #7c3aed; }
.ci-tag.infra  { background: rgba(107,114,128,0.09);color: #374151; }

/* ── Legend ── */
.legend-strip {
    display: flex; gap: 1rem; flex-wrap: wrap;
    background: #fafafa; border: 1px solid #eee;
    border-radius: 12px; padding: 0.85rem 1.1rem;
    margin-bottom: 2rem;
}
.legend-item {
    display: flex; align-items: center; gap: 0.45rem;
    font-size: 0.75rem; font-weight: 600; color: #666;
}

/* ── Back button ── */
.back-btn {
    display: inline-flex; align-items: center; gap: 0.5rem;
    font-size: 0.85rem; font-weight: 700; color: #CC0000;
    text-decoration: none; margin-bottom: 1.5rem;
    padding: 0.5rem 1rem; border-radius: 8px;
    border: 1px solid rgba(204,0,0,0.15);
    background: rgba(204,0,0,0.04);
    transition: all 0.18s;
}
.back-btn:hover { background: rgba(204,0,0,0.1); border-color: rgba(204,0,0,0.3); color: #CC0000; }

/* ── Footer note ── */
.updates-footer-note {
    text-align: center; font-size: 0.78rem; color: #757575; font-weight: 500;
    padding: 1.5rem 0 0.5rem;
    border-top: 1px solid #f0f0f0;
    margin-top: 1rem;
}

@media (max-width: 576px) {
    .version-card { margin-left: 40px; padding: 1.25rem 1rem; }
    .changelog-timeline::before { left: 14px; }
    .version-card::before { left: -32px; }
    .version-card.latest::before { left: -34px; }
    .updates-page-header { padding: 2rem 1.25rem; }
}
</style>

<!-- Back Button -->
<a href="clientarea.php" class="back-btn">
    <i class="fas fa-arrow-left"></i> Back to Dashboard
</a>

<!-- Page Header -->
<div class="updates-page-header">
    <div class="updates-page-header-grid"></div>
    <div style="position:relative; z-index:2;">
        <div class="updates-header-eyebrow">
            <i class="fas fa-code-branch"></i> Changelog
        </div>
        <h1 class="updates-header-title">
            Developer <span>Updates</span>
        </h1>
        <p class="updates-header-sub">
            Track every improvement, fix, and feature shipped to the SNBD HOST Client Panel.
            We build in the open — this is our public changelog.
        </p>
        <div class="updates-header-meta">
            <div class="updates-header-meta-item">
                <span class="updates-header-meta-label">Current Version</span>
                <span class="updates-header-meta-val">v3.5</span>
            </div>
            <div class="updates-header-meta-item">
                <span class="updates-header-meta-label">Released</span>
                <span class="updates-header-meta-val">May 2026</span>
            </div>
            <div class="updates-header-meta-item">
                <span class="updates-header-meta-label">Parent Theme</span>
                <span class="updates-header-meta-val">Twenty-One</span>
            </div>
            <div class="updates-header-meta-item">
                <span class="updates-header-meta-label">WHMCS Compat.</span>
                <span class="updates-header-meta-val">8.x</span>
            </div>
        </div>
    </div>
</div>

<!-- Legend -->
<div class="legend-strip">
    <div class="legend-item"><span class="ci-dot new" style="display:inline-block;"></span> New Feature</div>
    <div class="legend-item"><span class="ci-dot ui" style="display:inline-block;"></span> UI / Design</div>
    <div class="legend-item"><span class="ci-dot perf" style="display:inline-block;"></span> Performance</div>
    <div class="legend-item"><span class="ci-dot sec" style="display:inline-block;"></span> Security</div>
    <div class="legend-item"><span class="ci-dot fix" style="display:inline-block;"></span> Bug Fix</div>
    <div class="legend-item"><span class="ci-dot infra" style="display:inline-block;"></span> Infrastructure</div>
</div>

<!-- ===== CHANGELOG TIMELINE ===== -->
<div class="changelog-timeline">

    <!-- ─── v3.5 ─── -->
    <div class="version-card latest">
        <div class="version-card-head">
            <div>
                <div class="version-number">Version 3.5</div>
                <div class="version-date">May 2026</div>
            </div>
            <span class="version-badge latest"><i class="fas fa-circle" style="font-size:0.5rem;"></i> Latest Release</span>
        </div>

        <div class="change-group">
            <div class="change-group-label">Auth Pages</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Complete redesign of password reset flow using split-panel layout matching login/register pages.</li>
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Resolved particles.js canvas rendering above form content (z-index conflict with <code>#particles-js</code> positioned at z-index 1).</li>
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Added <code>getComputedStyle</code> guard to <code>initParticles()</code> so particles no longer initialize when hidden by template CSS.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Overrode <code>.auth-page</code> flex alignment on password reset pages — changed from <code>center</code> to <code>stretch</code> for full-height split layout.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Support Tickets</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Resolved a PHP 8+ TypeError crashing the ticket view page by safely referencing the client name property.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Dashboard</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Developer Updates page launched — public changelog accessible from the dashboard banner.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Dashboard banner updated to display release version and link to changelog.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Packaging</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot infra"></span><span class="ci-tag infra">Infra</span>Theme packaged and distributed as <code>snbd-theme-3.2.zip</code> for deployment.</li>
            </ul>
        </div>
    </div>

    <!-- ─── v3.4 ─── -->
    <div class="version-card">
        <div class="version-card-head">
            <div>
                <div class="version-number">Version 3.4</div>
                <div class="version-date">March 2026</div>
            </div>
            <span class="version-badge stable">Stable</span>
        </div>

        <div class="change-group">
            <div class="change-group-label">Dashboard Widgets</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Loyalty Matrix widget integrated into the dashboard — displays client tier, active discount, and next tier progress.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Recent invoices widget powered by the dashboard hook, showing last 5 invoices with status badges.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Active services list with billing cycle, next due date, and amount rendered directly in the dashboard.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Navigation & Layout</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Announcement bar added above the topbar for system-wide notifications and promotions.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Sidebar collapsed state now persisted across sessions via <code>localStorage</code>.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Mobile sidebar backdrop overlay added — closes on outside click.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Topbar currency selector added with BDT/USD display toggle.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Bug Fixes</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Fixed sidebar icon misalignment on collapsed state at desktop breakpoints.</li>
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Corrected topbar dropdown z-index clash with sidebar on smaller viewports.</li>
            </ul>
        </div>
    </div>

    <!-- ─── v3.3 ─── -->
    <div class="version-card">
        <div class="version-card-head">
            <div>
                <div class="version-number">Version 3.3</div>
                <div class="version-date">January 2026</div>
            </div>
            <span class="version-badge stable">Stable</span>
        </div>

        <div class="change-group">
            <div class="change-group-label">Framework & Compatibility</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot infra"></span><span class="ci-tag infra">Infra</span>Full WHMCS 8.x compatibility audit — resolved deprecated API usages and updated hook signatures.</li>
                <li class="change-item"><span class="ci-dot infra"></span><span class="ci-tag infra">Infra</span>Bootstrap upgraded from 5.2 to 5.3.0 — adopted new form control and utility classes.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Tabler Icons webfont integrated via CDN, replacing select Font Awesome icons in the sidebar and topbar.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Billing Pages</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Invoice list redesigned with color-coded status badges (Paid, Unpaid, Overdue, Cancelled).</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>View invoice page updated — improved line-item table with totals section and payment button emphasis.</li>
                <li class="change-item"><span class="ci-dot perf"></span><span class="ci-tag perf">Perf</span>Invoice page CSS scoped to reduce specificity conflicts with WHMCS core styles.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Polish</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Custom scrollbar styling added across the client area for a consistent design language.</li>
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Fixed support ticket list overflow on mobile causing horizontal scroll.</li>
            </ul>
        </div>
    </div>

    <!-- ─── v3.2 ─── -->
    <div class="version-card">
        <div class="version-card-head">
            <div>
                <div class="version-number">Version 3.2</div>
                <div class="version-date">November 2025</div>
            </div>
            <span class="version-badge legacy">Legacy</span>
        </div>

        <div class="change-group">
            <div class="change-group-label">Password Reset</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Password reset pages (email prompt, security question, new password) completely restyled with branded split-panel design.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Password strength indicator included on the new-password step with real-time visual feedback.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Security question step styled with matching auth layout for a seamless flow.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Password show/hide toggles added to new-password form fields.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">UX Improvements</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Session-based banner dismissal system — dismissed banners stay hidden for the browser session using <code>sessionStorage</code>.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Form input shake animation added on validation error for clearer user feedback.</li>
                <li class="change-item"><span class="ci-dot fix"></span><span class="ci-tag fix">Fix</span>Autofill background color override added to prevent browser-injected yellow autofill styling.</li>
            </ul>
        </div>
    </div>

    <!-- ─── v3.1 ─── -->
    <div class="version-card">
        <div class="version-card-head">
            <div>
                <div class="version-number">Version 3.1</div>
                <div class="version-date">September 2025</div>
            </div>
            <span class="version-badge legacy">Legacy</span>
        </div>

        <div class="change-group">
            <div class="change-group-label">Dashboard & Data</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Live dashboard data hook (<code>ClientAreaPageHome</code>) — real-time services, invoices, and Loyalty Matrix data served directly to the template via WHMCS database.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Quick-action row added below stat cards — Open Ticket, View Invoices, My Services, Affiliates, Add Funds.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Affiliate dashboard section integrated into the client area home page.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Navigation</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Topbar compact search bar added, routing to the WHMCS knowledge base search.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Currency selector (BDT / USD) introduced in topbar for future multi-currency support.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Floating Action Button (FAB) implemented — quick links for New Ticket, Pay Invoice, Order Service.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Typography & Assets</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Font stack migrated to Inter (Google Fonts) — improved readability at all weights.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>SNBD HOST logo asset standardised across sidebar, topbar, and auth pages.</li>
                <li class="change-item"><span class="ci-dot perf"></span><span class="ci-tag perf">Perf</span>Font Awesome upgraded to v6.4 with CSS-only loading (no JS kit).</li>
            </ul>
        </div>
    </div>

    <!-- ─── v3.0 ─── -->
    <div class="version-card">
        <div class="version-card-head">
            <div>
                <div class="version-number">Version 3.0</div>
                <div class="version-date">July 2025 — Initial Release</div>
            </div>
            <span class="version-badge legacy">Legacy</span>
        </div>

        <div class="change-group">
            <div class="change-group-label">Foundation</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>SNBD HOST custom WHMCS theme launched — built on top of the WHMCS Twenty-One parent theme.</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Custom CSS architecture established: <code>snbdhost-theme.css</code> (loaded after parent to cascade overrides).</li>
                <li class="change-item"><span class="ci-dot new"></span><span class="ci-tag new">New</span>Custom JS layer: <code>snbdhost-theme.js</code> — sidebar toggle, FAB, particles, loader, and form validation modules.</li>
                <li class="change-item"><span class="ci-dot infra"></span><span class="ci-tag infra">Infra</span><code>theme.yaml</code> configured with parent theme inheritance and version metadata.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">UI Components</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Custom sidebar navigation with section labels (Main, Support, Account), collapsible support, and logged-in user profile row.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Branded topbar with logo, navigation links, search, notifications, and user menu dropdown.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Login page with dark gradient branding panel (left) and clean form panel (right).</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Particles.js interactive background on the login page — red constellation effect.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>Full-screen branded loading spinner shown once per session on first load.</li>
                <li class="change-item"><span class="ci-dot ui"></span><span class="ci-tag ui">UI</span>SNBD HOST Loyalty Program promotional section embedded in the dashboard.</li>
            </ul>
        </div>

        <div class="change-group">
            <div class="change-group-label">Security & Routing</div>
            <ul class="change-list">
                <li class="change-item"><span class="ci-dot sec"></span><span class="ci-tag sec">Sec</span>Guest redirect hook — unauthenticated users accessing the portal home are automatically sent to the login page.</li>
                <li class="change-item"><span class="ci-dot sec"></span><span class="ci-tag sec">Sec</span>Dark mode preference cleared on load to enforce the light theme and prevent layout inconsistencies.</li>
            </ul>
        </div>
    </div>

</div><!-- .changelog-timeline -->

<div class="updates-footer-note">
    SNBD HOST Client Panel &mdash; Built with care for our clients &mdash;
    <a href="submitticket.php" style="color:#CC0000; font-weight:700; text-decoration:none;">Report an issue</a>
</div>
