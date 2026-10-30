<div class="snbd-stack">

    <header class="snbd-page-head">
        <div class="snbd-page-head__text">
            <p class="snbd-eyebrow">Changelog</p>
            <h1 class="snbd-page-title">Developer updates</h1>
            <p class="snbd-page-sub">Every improvement, fix and feature shipped to the SNBD Host client panel — built in the open.</p>
        </div>
        <div class="snbd-page-actions">
            <a href="clientarea.php" class="snbd-btn snbd-btn--ghost">
                <i class="ti ti-arrow-left" aria-hidden="true"></i> Dashboard
            </a>
        </div>
    </header>

    <div class="snbd-stats">
        <div class="snbd-stat">
            <div class="snbd-stat__main"><span class="snbd-stat__label">Current version</span><span class="snbd-stat__value">v3.5</span></div>
        </div>
        <div class="snbd-stat">
            <div class="snbd-stat__main"><span class="snbd-stat__label">Released</span><span class="snbd-stat__value">May 2026</span></div>
        </div>
        <div class="snbd-stat">
            <div class="snbd-stat__main"><span class="snbd-stat__label">WHMCS</span><span class="snbd-stat__value">8.x</span></div>
        </div>
        <div class="snbd-stat">
            <div class="snbd-stat__main"><span class="snbd-stat__label">Parent theme</span><span class="snbd-stat__value snbd-stat__value--sm">Twenty-One</span></div>
        </div>
    </div>

    <div class="snbd-cl-legend">
        <span class="snbd-caption">Legend</span>
        <span class="snbd-chip snbd-chip--brand">New feature</span>
        <span class="snbd-chip snbd-chip--info">UI / design</span>
        <span class="snbd-chip snbd-chip--neutral">Performance</span>
        <span class="snbd-chip snbd-chip--warn">Security</span>
        <span class="snbd-chip snbd-chip--bad">Bug fix</span>
        <span class="snbd-chip snbd-chip--ok">Infrastructure</span>
    </div>

    <div class="snbd-cl-list">

        <!-- v3.5 -->
        <article class="snbd-card snbd-cl">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">Version 3.5 <span class="snbd-card__subtitle">May 2026</span></h2>
                <span class="snbd-chip snbd-chip--brand">Latest release</span>
            </div>
            <div class="snbd-card__body snbd-cl__body">
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Auth pages</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Complete redesign of the password reset flow with a split-panel layout matching login and registration.</li>
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Resolved the particle canvas rendering above form content.</li>
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Added a computed-style guard so particles no longer initialise on pages that hide the canvas.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Password reset pages now stretch to full height like the other auth screens.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Support tickets</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Fixed a PHP 8 TypeError that crashed the ticket view page.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Dashboard</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Developer updates page published — a public changelog linked from the dashboard.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Dashboard banner shows the release version and links to this changelog.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Packaging</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--ok">Infra</span>Theme packaged for deployment.</li>
                    </ul>
                </div>
            </div>
        </article>

        <!-- v3.4 -->
        <article class="snbd-card snbd-cl">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">Version 3.4 <span class="snbd-card__subtitle">March 2026</span></h2>
                <span class="snbd-chip snbd-chip--neutral">Stable</span>
            </div>
            <div class="snbd-card__body snbd-cl__body">
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Dashboard widgets</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Loyalty matrix widget with tier, active discount and next-tier progress.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Recent invoices widget showing the last five invoices with status.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Active services list with billing cycle, next due date and amount.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Navigation and layout</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Announcement bar added above the topbar for system notices and promotions.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Sidebar collapsed state persisted across sessions.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Mobile sidebar backdrop added, closing on outside click.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Topbar currency selector with BDT/USD display toggle.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Bug fixes</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Sidebar icons no longer misalign in the collapsed desktop state.</li>
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Corrected a topbar dropdown z-index clash with the sidebar.</li>
                    </ul>
                </div>
            </div>
        </article>

        <!-- v3.3 -->
        <article class="snbd-card snbd-cl">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">Version 3.3 <span class="snbd-card__subtitle">January 2026</span></h2>
                <span class="snbd-chip snbd-chip--neutral">Stable</span>
            </div>
            <div class="snbd-card__body snbd-cl__body">
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Framework and compatibility</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--ok">Infra</span>Full WHMCS 8.x compatibility audit — deprecated APIs replaced and hook signatures updated.</li>
                        <li><span class="snbd-chip snbd-chip--ok">Infra</span>Bootstrap upgraded to 5.3 with the new form controls and utilities.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Tabler icons integrated, replacing Font Awesome in the shell.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Billing pages</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Invoice list redesigned with colour-coded status badges.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Invoice view improved with a clearer line-item table and payment emphasis.</li>
                        <li><span class="snbd-chip snbd-chip--neutral">Perf</span>Invoice CSS scoped to stop specificity conflicts with core styles.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Polish</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Consistent scrollbar styling across the client area.</li>
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Fixed ticket list overflow on mobile that caused horizontal scrolling.</li>
                    </ul>
                </div>
            </div>
        </article>

        <!-- v3.2 -->
        <article class="snbd-card snbd-cl">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">Version 3.2 <span class="snbd-card__subtitle">November 2025</span></h2>
                <span class="snbd-chip snbd-chip--neutral">Legacy</span>
            </div>
            <div class="snbd-card__body snbd-cl__body">
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Password reset</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Email prompt, security question and new-password steps restyled to match the auth pages.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Live password strength indicator on the new-password step.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Security question step styled for a seamless flow.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Show/hide toggles on the new-password fields.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">UX improvements</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Session-based banner dismissal that stays hidden for the browser session.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Form inputs shake on validation errors for clearer feedback.</li>
                        <li><span class="snbd-chip snbd-chip--bad">Fix</span>Autofill background override stops browser-injected yellow fields.</li>
                    </ul>
                </div>
            </div>
        </article>

        <!-- v3.1 -->
        <article class="snbd-card snbd-cl">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">Version 3.1 <span class="snbd-card__subtitle">September 2025</span></h2>
                <span class="snbd-chip snbd-chip--neutral">Legacy</span>
            </div>
            <div class="snbd-card__body snbd-cl__body">
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Dashboard and data</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Live dashboard data hook for services, invoices and loyalty data.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Quick actions below the stat cards — open ticket, invoices, services, affiliates, add funds.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Affiliate summary integrated into the dashboard.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Navigation</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Compact topbar search routing to the knowledge base.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Currency selector introduced in the topbar.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Floating quick actions — new ticket, pay invoice, order service.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Typography and assets</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Font stack moved to Inter for better readability at every weight.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Logo asset standardised across the shell and auth pages.</li>
                        <li><span class="snbd-chip snbd-chip--neutral">Perf</span>Font Awesome upgraded with CSS-only loading.</li>
                    </ul>
                </div>
            </div>
        </article>

        <!-- v3.0 -->
        <article class="snbd-card snbd-cl">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">Version 3.0 <span class="snbd-card__subtitle">July 2025 — initial release</span></h2>
                <span class="snbd-chip snbd-chip--neutral">Legacy</span>
            </div>
            <div class="snbd-card__body snbd-cl__body">
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Foundation</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--brand">New</span>SNBD Host custom WHMCS theme launched on the Twenty-One parent.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Custom CSS architecture cascading over the parent theme.</li>
                        <li><span class="snbd-chip snbd-chip--brand">New</span>Custom JS layer for the shell and form utilities.</li>
                        <li><span class="snbd-chip snbd-chip--ok">Infra</span>Theme metadata with parent inheritance configured.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">UI components</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Custom sidebar with section labels and a profile row.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Branded topbar with search, notifications and account menu.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Login page with a branded panel and a clean form panel.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Interactive particle background on the login page.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Branded first-load spinner shown once per session.</li>
                        <li><span class="snbd-chip snbd-chip--info">UI</span>Loyalty programme section embedded in the dashboard.</li>
                    </ul>
                </div>
                <div class="snbd-cl__group">
                    <h3 class="snbd-cl__label">Security and routing</h3>
                    <ul class="snbd-cl__items">
                        <li><span class="snbd-chip snbd-chip--warn">Sec</span>Guest redirect hook sends unauthenticated visitors to login.</li>
                        <li><span class="snbd-chip snbd-chip--warn">Sec</span>Dark mode preference cleared on load to keep one light theme.</li>
                    </ul>
                </div>
            </div>
        </article>

    </div>

    <p class="snbd-caption text-center">SNBD Host client panel — built with care for our clients. <a href="submitticket.php">Report an issue</a></p>

</div>
