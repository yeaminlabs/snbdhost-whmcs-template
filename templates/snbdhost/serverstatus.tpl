{include file="{$template}/header.tpl" title="Network Status"}

<!-- ═══════════════════════════════════════════════════════════════
     SNBD HOST — NETWORK STATUS PAGE v2
     UptimeRobot API v3 · Premium Animated Dashboard
     ═══════════════════════════════════════════════════════════════ -->

<style>
/* ── Network Status Page Scoped Styles ── */

/* Hero Banner — dark premium style */
.ns-hero {
  position: relative;
  background: linear-gradient(135deg, #0a0a0a 0%, #171717 50%, #0d0d0d 100%);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 20px;
  padding: 2.5rem 2.5rem 2rem;
  overflow: hidden;
  margin-bottom: 1.75rem;
  color: #ffffff;
}
.ns-hero::before {
  content: '';
  position: absolute;
  top: -60%; left: -40%;
  width: 200%; height: 200%;
  background: radial-gradient(circle at 25% 35%, rgba(186,17,20,0.12) 0%, transparent 55%),
              radial-gradient(circle at 75% 65%, rgba(46,125,50,0.06) 0%, transparent 50%);
  pointer-events: none;
  animation: heroGradientDrift 12s ease-in-out infinite alternate;
}
@keyframes heroGradientDrift {
  0%   { transform: translate(0, 0) scale(1); }
  100% { transform: translate(3%, -2%) scale(1.02); }
}
.ns-hero::after {
  content: '';
  position: absolute;
  bottom: 0; left: 0; right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(186,17,20,0.3), transparent);
}

.ns-hero-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 2rem;
  position: relative;
  z-index: 1;
}
.ns-hero-title {
  font-family: 'Plus Jakarta Sans', var(--font-sans), sans-serif;
  font-size: 1.75rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  color: #ffffff;
  margin: 0 0 0.25rem;
  line-height: 1.2;
}
.ns-hero-subtitle {
  font-size: 0.8125rem;
  color: rgba(255,255,255,0.5);
  font-weight: 500;
  margin: 0;
}
.ns-refresh-pill {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 50rem;
  padding: 0.4rem 0.875rem;
  font-size: 0.7rem;
  color: rgba(255,255,255,0.5);
  font-weight: 600;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}
.ns-refresh-pill svg { transform: rotate(-90deg); }

/* Status Orb */
.ns-status-row {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  position: relative;
  z-index: 1;
  margin-bottom: 2rem;
}
.ns-orb {
  width: 64px; height: 64px;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 1.5rem; flex-shrink: 0;
  transition: all 0.5s cubic-bezier(0.4,0,0.2,1);
}
.ns-orb.loading { background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.3); }
.ns-orb.up { background: rgba(46,125,50,0.15); color: #66bb6a; animation: nsOrbPulseUp 3s ease-in-out infinite; }
.ns-orb.down { background: rgba(198,40,40,0.2); color: #ef5350; animation: nsOrbPulseDown 1.5s ease-in-out infinite; }
.ns-orb.warning { background: rgba(230,81,0,0.15); color: #ffb74d; animation: nsOrbPulseWarn 2s ease-in-out infinite; }
@keyframes nsOrbPulseUp { 0%,100% { box-shadow: 0 0 0 0 rgba(46,125,50,0.3); } 50% { box-shadow: 0 0 0 18px rgba(46,125,50,0); } }
@keyframes nsOrbPulseDown { 0%,100% { box-shadow: 0 0 0 0 rgba(198,40,40,0.4); } 50% { box-shadow: 0 0 0 20px rgba(198,40,40,0); } }
@keyframes nsOrbPulseWarn { 0%,100% { box-shadow: 0 0 0 0 rgba(230,81,0,0.3); } 50% { box-shadow: 0 0 0 14px rgba(230,81,0,0); } }

.ns-status-text h2 {
  font-family: 'Plus Jakarta Sans', var(--font-sans), sans-serif;
  font-size: 1.25rem;
  font-weight: 700;
  color: #ffffff;
  margin: 0 0 0.2rem;
  letter-spacing: -0.01em;
}
.ns-status-text p {
  font-size: 0.8125rem;
  color: rgba(255,255,255,0.45);
  margin: 0;
  font-weight: 400;
}

/* Metric Cards inside hero */
.ns-metrics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.75rem;
  position: relative;
  z-index: 1;
}
.ns-metric-card {
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 14px;
  padding: 1.25rem 1rem;
  text-align: center;
  transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
}
.ns-metric-card:hover {
  background: rgba(255,255,255,0.07);
  border-color: rgba(255,255,255,0.1);
  transform: translateY(-2px);
}
.ns-metric-value {
  font-family: 'Plus Jakarta Sans', var(--font-sans), sans-serif;
  font-size: 2rem;
  font-weight: 800;
  line-height: 1;
  margin-bottom: 0.3rem;
  letter-spacing: -0.02em;
}
.ns-metric-value.up { color: #66bb6a; }
.ns-metric-value.down { color: #ef5350; }
.ns-metric-value.paused { color: rgba(255,255,255,0.3); }
.ns-metric-label {
  font-size: 0.65rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  color: rgba(255,255,255,0.35);
}

/* Uptime bar inside hero */
.ns-uptime-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1.25rem;
  position: relative;
  z-index: 1;
}
.ns-uptime-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: rgba(255,255,255,0.4);
}
.ns-uptime-value {
  font-family: 'Plus Jakarta Sans', var(--font-sans), sans-serif;
  font-size: 0.875rem;
  font-weight: 700;
  color: #66bb6a;
}
.ns-uptime-track {
  position: relative;
  height: 6px;
  background: rgba(255,255,255,0.06);
  border-radius: 50rem;
  overflow: hidden;
  margin-top: 0.5rem;
  z-index: 1;
}
.ns-uptime-fill {
  height: 100%;
  border-radius: 50rem;
  background: linear-gradient(90deg, #2e7d32, #66bb6a);
  width: 0%;
  transition: width 1.4s cubic-bezier(0.4,0,0.2,1);
  position: relative;
}
.ns-uptime-fill::after {
  content: '';
  position: absolute;
  top: 0; right: 0; bottom: 0;
  width: 30px;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25));
  border-radius: 0 50rem 50rem 0;
}

/* Toolbar */
.ns-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-bottom: 1.25rem;
}
.ns-search {
  position: relative;
}
.ns-search input {
  width: 280px;
  padding: 0.625rem 1rem 0.625rem 2.5rem;
  border: 1px solid var(--border-subtle);
  border-radius: 12px;
  background: var(--bg-surface);
  color: var(--text-primary);
  font-size: 0.8125rem;
  font-weight: 500;
  transition: all 0.25s;
  outline: none;
  font-family: var(--font-sans);
}
.ns-search input:focus {
  border-color: var(--brand-primary);
  box-shadow: 0 0 0 3px rgba(var(--brand-primary-rgb), 0.08);
}
.ns-search i {
  position: absolute;
  left: 0.875rem; top: 50%;
  transform: translateY(-50%);
  color: var(--text-muted);
  font-size: 0.9rem;
  pointer-events: none;
}
.ns-toolbar-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.ns-monitor-count {
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-muted);
}
.ns-filter-tabs {
  display: inline-flex;
  background: var(--bg-surface);
  border: 1px solid var(--border-subtle);
  border-radius: 12px;
  padding: 4px;
  gap: 2px;
}
.ns-filter-tab {
  border: none;
  background: transparent;
  padding: 0.5rem 1.125rem;
  border-radius: 10px;
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-muted);
  cursor: pointer;
  transition: all 0.2s ease;
  font-family: var(--font-sans);
}
.ns-filter-tab:hover { color: var(--text-secondary); background: var(--bg-elevated); }
.ns-filter-tab.active {
  background: var(--brand-primary);
  color: #ffffff;
  box-shadow: 0 2px 8px rgba(var(--brand-primary-rgb), 0.25);
}
.ns-tab-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 18px; height: 18px;
  padding: 0 5px;
  border-radius: 50rem;
  font-size: 0.65rem;
  font-weight: 700;
  margin-left: 5px;
  transition: all 0.2s;
  background: var(--border-subtle);
  color: var(--text-muted);
}
.ns-filter-tab.active .ns-tab-badge {
  background: rgba(255,255,255,0.25);
  color: #ffffff;
}

/* Error Card */
.ns-error-card {
  background: var(--bg-surface);
  border: 1px solid rgba(198,40,40,0.15);
  border-radius: 16px;
  padding: 3rem;
  text-align: center;
}
.ns-error-card .error-icon {
  width: 64px; height: 64px;
  border-radius: 50%;
  background: rgba(198,40,40,0.06);
  color: #c62828;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  margin-bottom: 1rem;
}

/* Loading Skeleton */
.ns-skeleton-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-subtle);
  border-radius: 16px;
  padding: 1.5rem;
  overflow: hidden;
}
.ns-skeleton-shimmer {
  background: linear-gradient(90deg, var(--bg-elevated) 25%, var(--bg-surface) 50%, var(--bg-elevated) 75%);
  background-size: 200% 100%;
  animation: nsShimmer 1.5s infinite;
  border-radius: 6px;
}
@keyframes nsShimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

/* Monitor Cards */
.ns-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}
.ns-card {
  background: var(--bg-surface);
  border: 1px solid var(--border-subtle);
  border-radius: 16px;
  padding: 1.5rem;
  position: relative;
  overflow: hidden;
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.5s ease, transform 0.5s cubic-bezier(0.4,0,0.2,1), box-shadow 0.3s ease, border-color 0.3s ease;
}
.ns-card.visible {
  opacity: 1;
  transform: translateY(0);
}
.ns-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 40px rgba(0,0,0,0.06);
  border-color: var(--border-color);
}
.ns-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 3px;
  background: transparent;
  transition: background 0.3s;
}
.ns-card.up::before { background: linear-gradient(90deg, #2e7d32, #66bb6a); }
.ns-card.down::before { background: linear-gradient(90deg, #c62828, #ef5350); }
.ns-card.paused::before { background: linear-gradient(90deg, #999, #bbb); }

.ns-card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
}
.ns-card-left {
  display: flex;
  align-items: flex-start;
  gap: 0.875rem;
  min-width: 0;
}

/* Status indicator */
.ns-dot-wrap {
  position: relative;
  width: 36px; height: 36px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}
.ns-dot {
  width: 10px; height: 10px;
  border-radius: 50%;
  position: relative;
  z-index: 1;
}
.ns-dot.up { background: #2e7d32; }
.ns-dot.down { background: #c62828; }
.ns-dot.paused { background: #999; }
.ns-dot-ring {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  opacity: 0;
}
.ns-dot.up + .ns-dot-ring {
  background: rgba(46,125,50,0.08);
  animation: nsDotPing 2.5s ease-out infinite;
}
.ns-dot.down + .ns-dot-ring {
  background: rgba(198,40,40,0.1);
  animation: nsDotPing 1.5s ease-out infinite;
}
@keyframes nsDotPing {
  0% { opacity: 0.6; transform: scale(0.5); }
  100% { opacity: 0; transform: scale(1.3); }
}

.ns-card-name {
  font-weight: 700;
  font-size: 0.9375rem;
  color: var(--text-primary);
  letter-spacing: -0.01em;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.ns-card-url {
  font-size: 0.75rem;
  color: var(--text-muted);
  margin-top: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.ns-card-tags {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.625rem;
  flex-wrap: wrap;
}
.ns-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.3rem 0.75rem;
  border-radius: 50rem;
  font-size: 0.6875rem;
  font-weight: 700;
  letter-spacing: 0.3px;
}
.ns-badge-success { background: rgba(46,125,50,0.08); color: #2e7d32; border: 1px solid rgba(46,125,50,0.15); }
.ns-badge-danger { background: rgba(198,40,40,0.08); color: #c62828; border: 1px solid rgba(198,40,40,0.15); }
.ns-badge-secondary { background: rgba(100,100,100,0.06); color: #777; border: 1px solid rgba(100,100,100,0.12); }
.ns-badge-warning { background: rgba(230,81,0,0.08); color: #e65100; border: 1px solid rgba(230,81,0,0.15); }
.ns-badge-info { background: rgba(186,17,20,0.06); color: var(--brand-primary); border: 1px solid rgba(186,17,20,0.12); }
.ns-card-meta {
  font-size: 0.6875rem;
  font-weight: 600;
  color: var(--text-muted);
}

/* Right side — uptime & sparkline */
.ns-card-right {
  text-align: right;
  flex-shrink: 0;
  min-width: 100px;
}
.ns-card-uptime {
  font-family: 'Plus Jakarta Sans', var(--font-sans), sans-serif;
  font-size: 1.375rem;
  font-weight: 800;
  color: var(--text-primary);
  line-height: 1;
  letter-spacing: -0.02em;
}
.ns-card-uptime-label {
  font-size: 0.65rem;
  font-weight: 600;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-top: 2px;
}

/* SVG Sparkline */
.ns-sparkline {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 24px;
  justify-content: flex-end;
  margin-top: 0.5rem;
}
.ns-spark-bar {
  width: 3.5px;
  border-radius: 2px;
  transition: height 0.4s ease, opacity 0.3s ease;
}
.ns-card.up .ns-spark-bar { background: #2e7d32; }
.ns-card.down .ns-spark-bar { background: #c62828; }
.ns-card.paused .ns-spark-bar { background: #999; }
.ns-card:hover .ns-spark-bar { opacity: 1 !important; }

.ns-card-response {
  font-size: 0.75rem;
  color: var(--text-secondary);
  margin-top: 0.375rem;
  font-weight: 600;
}
.ns-card-response i { font-size: 0.7rem; }

/* Mini progress bar */
.ns-bar-track {
  height: 4px;
  background: var(--bg-elevated);
  border-radius: 50rem;
  overflow: hidden;
  margin-top: 1rem;
}
.ns-bar-fill {
  height: 100%;
  border-radius: 50rem;
  background: linear-gradient(90deg, #2e7d32, #66bb6a);
  transition: width 1s cubic-bezier(0.4,0,0.2,1);
}
.ns-bar-fill.warn { background: linear-gradient(90deg, #e65100, #ffb74d); }
.ns-bar-fill.crit { background: linear-gradient(90deg, #c62828, #ef5350); }

.ns-bar-meta {
  display: flex;
  justify-content: space-between;
  margin-top: 0.375rem;
}
.ns-bar-meta span {
  font-size: 0.625rem;
  color: var(--text-muted);
  font-weight: 600;
}

/* Empty state */
.ns-empty {
  background: var(--bg-surface);
  border: 1px solid var(--border-subtle);
  border-radius: 16px;
  padding: 3.5rem 2rem;
  text-align: center;
  grid-column: 1 / -1;
}
.ns-empty i {
  font-size: 2rem;
  color: var(--text-muted);
  margin-bottom: 0.75rem;
  display: block;
}

/* Entrance animations */
@keyframes nsFadeUp {
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
}
.ns-hero-top { animation: nsFadeUp 0.6s ease both; }
.ns-status-row { animation: nsFadeUp 0.6s ease 0.1s both; }
.ns-metrics { animation: nsFadeUp 0.6s ease 0.2s both; }
.ns-uptime-row, .ns-uptime-track { animation: nsFadeUp 0.6s ease 0.3s both; }
.ns-toolbar { animation: nsFadeUp 0.5s ease 0.35s both; }

/* Stagger monitor cards */
.ns-card:nth-child(1)  { transition-delay: 0.00s; }
.ns-card:nth-child(2)  { transition-delay: 0.06s; }
.ns-card:nth-child(3)  { transition-delay: 0.12s; }
.ns-card:nth-child(4)  { transition-delay: 0.18s; }
.ns-card:nth-child(5)  { transition-delay: 0.24s; }
.ns-card:nth-child(6)  { transition-delay: 0.30s; }
.ns-card:nth-child(7)  { transition-delay: 0.36s; }
.ns-card:nth-child(8)  { transition-delay: 0.42s; }
.ns-card:nth-child(9)  { transition-delay: 0.48s; }
.ns-card:nth-child(10) { transition-delay: 0.54s; }
.ns-card:nth-child(11) { transition-delay: 0.60s; }
.ns-card:nth-child(12) { transition-delay: 0.66s; }

/* Responsive */
@media (max-width: 991px) {
  .ns-grid { grid-template-columns: 1fr; }
}
@media (max-width: 768px) {
  .ns-hero { padding: 1.5rem; border-radius: 16px; }
  .ns-hero-title { font-size: 1.375rem; }
  .ns-metrics { grid-template-columns: repeat(3, 1fr); gap: 0.5rem; }
  .ns-metric-value { font-size: 1.5rem; }
  .ns-metric-card { padding: 1rem 0.625rem; }
  .ns-search input { width: 100%; }
  .ns-toolbar { flex-direction: column; align-items: stretch; }
  .ns-toolbar-right { flex-wrap: wrap; justify-content: space-between; }
  .ns-filter-tabs { overflow-x: auto; -webkit-overflow-scrolling: touch; }
}
@media (max-width: 480px) {
  .ns-hero-top { flex-direction: column; }
  .ns-status-row { flex-direction: column; text-align: center; }
  .ns-card-header { flex-direction: column; }
  .ns-card-right { text-align: left; }
  .ns-sparkline { justify-content: flex-start; }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  .ns-hero::before { animation: none; }
  .ns-card { opacity: 1; transform: none; transition-delay: 0s !important; }
  .ns-orb { animation: none !important; }
  .ns-dot-ring { animation: none !important; }
  .ns-hero-top, .ns-status-row, .ns-metrics, .ns-uptime-row, .ns-uptime-track, .ns-toolbar {
    animation: none;
    opacity: 1;
    transform: none;
  }
  .ns-bar-fill, .ns-uptime-fill { transition-duration: 0.01ms !important; }
}
</style>

<div class="ns-page">
  <!-- Hero Banner -->
  <div class="ns-hero">
    <div class="ns-hero-top">
      <div>
        <h1 class="ns-hero-title">Network Status</h1>
        <p class="ns-hero-subtitle">Real-time service health & infrastructure monitoring</p>
      </div>
      <div class="ns-refresh-pill" id="refresh-timer" title="Auto-refresh in 60s">
        <svg width="16" height="16" viewBox="0 0 16 16">
          <circle cx="8" cy="8" r="6" fill="none" stroke="rgba(255,255,255,0.12)" stroke-width="2"/>
          <circle id="refresh-progress" cx="8" cy="8" r="6" fill="none" stroke="rgba(255,255,255,0.5)" stroke-width="2"
                  stroke-dasharray="37.7" stroke-dashoffset="37.7" stroke-linecap="round"/>
        </svg>
        <span id="last-checked">Checking&hellip;</span>
      </div>
    </div>

    <div class="ns-status-row">
      <div id="status-orb" class="ns-orb loading">
        <i class="ti ti-loader-2 ti-spin"></i>
      </div>
      <div class="ns-status-text">
        <h2 id="overall-title">Loading monitor status&hellip;</h2>
        <p id="overall-subtitle">Please wait while we fetch the latest data.</p>
      </div>
    </div>

    <div class="ns-metrics">
      <div class="ns-metric-card">
        <div id="metric-up" class="ns-metric-value up">&mdash;</div>
        <div class="ns-metric-label">Up</div>
      </div>
      <div class="ns-metric-card">
        <div id="metric-down" class="ns-metric-value down">&mdash;</div>
        <div class="ns-metric-label">Down</div>
      </div>
      <div class="ns-metric-card">
        <div id="metric-paused" class="ns-metric-value paused">&mdash;</div>
        <div class="ns-metric-label">Paused</div>
      </div>
    </div>

    <div class="ns-uptime-row">
      <span class="ns-uptime-label">Avg. uptime (30d)</span>
      <span id="avg-uptime-text" class="ns-uptime-value">&mdash;</span>
    </div>
    <div class="ns-uptime-track">
      <div id="avg-uptime-bar" class="ns-uptime-fill" style="width:0%"></div>
    </div>
  </div>

  <!-- Toolbar -->
  <div class="ns-toolbar">
    <div class="ns-search">
      <i class="ti ti-search"></i>
      <input type="text" id="monitor-search" placeholder="Search monitors&hellip;" autocomplete="off">
    </div>
    <div class="ns-toolbar-right">
      <div class="ns-monitor-count"><span id="monitor-count">0</span> monitors</div>
      <div class="ns-filter-tabs" role="group" aria-label="Filter monitors">
        <button type="button" class="ns-filter-tab active" data-status-filter="all">
          All <span class="ns-tab-badge" id="badge-all">0</span>
        </button>
        <button type="button" class="ns-filter-tab" data-status-filter="up">
          Up <span class="ns-tab-badge" id="badge-up">0</span>
        </button>
        <button type="button" class="ns-filter-tab" data-status-filter="down">
          Down <span class="ns-tab-badge" id="badge-down">0</span>
        </button>
        <button type="button" class="ns-filter-tab" data-status-filter="paused">
          Paused <span class="ns-tab-badge" id="badge-paused">0</span>
        </button>
      </div>
    </div>
  </div>

  <!-- Error -->
  <div id="status-error" class="ns-error-card d-none" role="alert">
    <div class="error-icon"><i class="ti ti-alert-triangle"></i></div>
    <h5 class="mb-2">Unable to load status data</h5>
    <p class="text-muted mb-0" id="error-message">Something went wrong.</p>
  </div>

  <!-- Loading Skeleton -->
  <div id="status-loading">
    <div class="ns-grid">
      <div class="ns-skeleton-card">
        <div class="d-flex align-items-center gap-3 mb-3">
          <div class="ns-skeleton-shimmer" style="width:36px;height:36px;border-radius:50%;"></div>
          <div style="flex:1">
            <div class="ns-skeleton-shimmer" style="width:60%;height:14px;margin-bottom:8px;"></div>
            <div class="ns-skeleton-shimmer" style="width:40%;height:10px;"></div>
          </div>
        </div>
        <div class="ns-skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
      </div>
      <div class="ns-skeleton-card">
        <div class="d-flex align-items-center gap-3 mb-3">
          <div class="ns-skeleton-shimmer" style="width:36px;height:36px;border-radius:50%;"></div>
          <div style="flex:1">
            <div class="ns-skeleton-shimmer" style="width:55%;height:14px;margin-bottom:8px;"></div>
            <div class="ns-skeleton-shimmer" style="width:35%;height:10px;"></div>
          </div>
        </div>
        <div class="ns-skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
      </div>
      <div class="ns-skeleton-card">
        <div class="d-flex align-items-center gap-3 mb-3">
          <div class="ns-skeleton-shimmer" style="width:36px;height:36px;border-radius:50%;"></div>
          <div style="flex:1">
            <div class="ns-skeleton-shimmer" style="width:65%;height:14px;margin-bottom:8px;"></div>
            <div class="ns-skeleton-shimmer" style="width:42%;height:10px;"></div>
          </div>
        </div>
        <div class="ns-skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
      </div>
      <div class="ns-skeleton-card">
        <div class="d-flex align-items-center gap-3 mb-3">
          <div class="ns-skeleton-shimmer" style="width:36px;height:36px;border-radius:50%;"></div>
          <div style="flex:1">
            <div class="ns-skeleton-shimmer" style="width:50%;height:14px;margin-bottom:8px;"></div>
            <div class="ns-skeleton-shimmer" style="width:38%;height:10px;"></div>
          </div>
        </div>
        <div class="ns-skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
      </div>
    </div>
  </div>

  <!-- Monitor Grid -->
  <div id="status-list" class="ns-grid d-none"></div>
</div>

<script>
{literal}
(function () {
{/literal}
    const API_JSON = '{$WEB_ROOT}/network-status.json';
    const API_PROXY = '{$WEB_ROOT}/serverstatus-data.php';
{literal}
    let monitors = [];
    let activeFilter = 'all';
    let searchQuery = '';
    let refreshTimer = null;
    let countdownInterval = null;
    let refreshIn = 60;
    const REFRESH_PERIOD = 60;
    const REFRESH_CIRCUM = 37.7;
    let lastUpdatedTimestamp = null;

    const els = {
        lastChecked: document.getElementById('last-checked'),
        orb: document.getElementById('status-orb'),
        overallTitle: document.getElementById('overall-title'),
        overallSubtitle: document.getElementById('overall-subtitle'),
        up: document.getElementById('metric-up'),
        down: document.getElementById('metric-down'),
        paused: document.getElementById('metric-paused'),
        avgText: document.getElementById('avg-uptime-text'),
        avgBar: document.getElementById('avg-uptime-bar'),
        count: document.getElementById('monitor-count'),
        error: document.getElementById('status-error'),
        errorMsg: document.getElementById('error-message'),
        loading: document.getElementById('status-loading'),
        list: document.getElementById('status-list'),
        search: document.getElementById('monitor-search'),
        refreshProgress: document.getElementById('refresh-progress'),
        badges: {
            all: document.getElementById('badge-all'),
            up: document.getElementById('badge-up'),
            down: document.getElementById('badge-down'),
            paused: document.getElementById('badge-paused')
        }
    };

    function setError(message) {
        els.errorMsg.textContent = message;
        els.error.classList.remove('d-none');
        els.loading.classList.add('d-none');
        els.list.classList.add('d-none');
    }

    function clearError() { els.error.classList.add('d-none'); }

    function escapeHtml(str) {
        return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
    }

    function statusMeta(status) {
        if (status === 2) return { key: 'up', label: 'Operational', badgeCls: 'ns-badge-success', dot: 'up', icon: 'ti-circle-check' };
        if (status === 9) return { key: 'down', label: 'Down', badgeCls: 'ns-badge-danger', dot: 'down', icon: 'ti-alert-circle' };
        if (status === 0) return { key: 'paused', label: 'Paused', badgeCls: 'ns-badge-secondary', dot: 'paused', icon: 'ti-player-pause' };
        if (status === 1) return { key: 'pending', label: 'Pending', badgeCls: 'ns-badge-warning', dot: 'paused', icon: 'ti-clock' };
        return { key: 'unknown', label: 'Unknown', badgeCls: 'ns-badge-info', dot: 'paused', icon: 'ti-help-circle' };
    }

    function animateValue(el, from, to, duration) {
        duration = duration || 800;
        if (from === to) { el.textContent = to; return; }
        var start = performance.now();
        function step(now) {
            var progress = Math.min((now - start) / duration, 1);
            var ease = 1 - Math.pow(1 - progress, 3);
            el.textContent = Math.round(from + (to - from) * ease);
            if (progress < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    function animatePercent(el, from, to, duration) {
        duration = duration || 1000;
        var start = performance.now();
        function step(now) {
            var progress = Math.min((now - start) / duration, 1);
            var ease = 1 - Math.pow(1 - progress, 3);
            el.textContent = (from + (to - from) * ease).toFixed(2) + '%';
            if (progress < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    function renderSummary() {
        var up = monitors.filter(function(m) { return m.status === 2; }).length;
        var down = monitors.filter(function(m) { return m.status === 9; }).length;
        var paused = monitors.filter(function(m) { return m.status === 0; }).length;
        var avg = monitors.length ? monitors.reduce(function(sum, m) { return sum + (parseFloat(m.custom_uptime_ratio) || 0); }, 0) / monitors.length : 0;

        var prevUp = parseInt(els.up.textContent) || 0;
        var prevDown = parseInt(els.down.textContent) || 0;
        var prevPaused = parseInt(els.paused.textContent) || 0;
        var prevAvg = parseFloat(els.avgText.textContent) || 0;

        animateValue(els.up, prevUp, up);
        animateValue(els.down, prevDown, down);
        animateValue(els.paused, prevPaused, paused);
        animatePercent(els.avgText, prevAvg, avg);

        els.avgBar.style.width = Math.max(0, Math.min(100, avg)).toFixed(2) + '%';
        els.count.textContent = monitors.length;

        els.badges.all.textContent = monitors.length;
        els.badges.up.textContent = up;
        els.badges.down.textContent = down;
        els.badges.paused.textContent = paused;

        els.orb.classList.remove('loading', 'up', 'down', 'warning');
        if (down > 0) {
            els.orb.classList.add('down');
            els.orb.innerHTML = '<i class="ti ti-alert-circle"></i>';
            els.overallTitle.textContent = down + ' service' + (down > 1 ? 's are' : ' is') + ' down';
            els.overallSubtitle.textContent = 'Some monitored endpoints are currently unavailable. Our team has been notified.';
        } else if (paused > 0 && up > 0) {
            els.orb.classList.add('warning');
            els.orb.innerHTML = '<i class="ti ti-alert-triangle"></i>';
            els.overallTitle.textContent = 'All systems operational';
            els.overallSubtitle.textContent = 'All active services are responding normally. Some monitors are paused.';
        } else if (up > 0) {
            els.orb.classList.add('up');
            els.orb.innerHTML = '<i class="ti ti-circle-check"></i>';
            els.overallTitle.textContent = 'All systems operational';
            els.overallSubtitle.textContent = 'All monitored services are responding normally.';
        } else if (paused > 0) {
            els.orb.classList.add('warning');
            els.orb.innerHTML = '<i class="ti ti-player-pause"></i>';
            els.overallTitle.textContent = 'Monitors paused';
            els.overallSubtitle.textContent = 'All monitors are currently paused.';
        } else {
            els.orb.classList.add('loading');
            els.orb.innerHTML = '<i class="ti ti-loader-2 ti-spin"></i>';
            els.overallTitle.textContent = 'No monitors found';
            els.overallSubtitle.textContent = 'There are no monitors configured in UptimeRobot.';
        }
    }

    function updateLastCheckedText() {
        if (lastUpdatedTimestamp) {
            var diffSecs = Math.floor((Date.now() / 1000) - lastUpdatedTimestamp);
            if (diffSecs < 60) {
                els.lastChecked.textContent = 'Updated just now';
            } else if (diffSecs < 3600) {
                els.lastChecked.textContent = 'Updated ' + Math.floor(diffSecs / 60) + 'm ago';
            } else {
                els.lastChecked.textContent = 'Updated ' + Math.floor(diffSecs / 3600) + 'h ago';
            }
        } else {
            els.lastChecked.textContent = 'Updated ' + new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        }
    }

    function filteredMonitors() {
        var list = monitors;
        if (activeFilter !== 'all') {
            if (activeFilter === 'up') list = list.filter(function(m) { return m.status === 2; });
            else if (activeFilter === 'down') list = list.filter(function(m) { return m.status === 9; });
            else if (activeFilter === 'paused') list = list.filter(function(m) { return m.status === 0; });
        }
        if (searchQuery.trim()) {
            var q = searchQuery.toLowerCase();
            list = list.filter(function(m) {
                return String(m.friendly_name || m.url || '').toLowerCase().indexOf(q) !== -1
                    || String(m.url || '').toLowerCase().indexOf(q) !== -1;
            });
        }
        return list;
    }

    function generateSparkline(responseTimes) {
        var values;
        if (!Array.isArray(responseTimes) || responseTimes.length < 2) {
            values = [];
            for (var i = 0; i < 10; i++) values.push(Math.max(20, Math.min(100, 40 + Math.random() * 60)));
        } else {
            values = responseTimes.map(function(rt) { return rt.value; }).reverse().slice(0, 10);
        }
        var max = Math.max.apply(null, values.concat([1]));
        return values.map(function(v, i) {
            var h = Math.max(15, (v / max) * 100);
            return '<div class="ns-spark-bar" style="height:' + h + '%;opacity:' + (0.25 + (i/10)*0.6) + '"></div>';
        }).join('');
    }

    function renderList() {
        var items = filteredMonitors();
        els.loading.classList.add('d-none');
        els.list.classList.remove('d-none');
        els.count.textContent = items.length;

        if (!items.length) {
            els.list.innerHTML = '<div class="ns-empty">' +
                '<i class="ti ti-search"></i>' +
                '<h5 class="mb-1">' + (searchQuery ? 'No monitors match your search' : 'No monitors match this filter') + '</h5>' +
                '<p class="text-muted mb-0">' + (searchQuery ? 'Try a different search term.' : 'Select a different filter above.') + '</p>' +
                '</div>';
            return;
        }

        els.list.innerHTML = items.map(function(m) {
            var meta = statusMeta(m.status);
            var uptime = parseFloat(m.custom_uptime_ratio || 0);
            var allTimeUptime = parseFloat(m.all_time_uptime_ratio || 0);
            var response = Array.isArray(m.response_times) && m.response_times.length ? (m.response_times[0].value + ' ms') : '—';
            var name = escapeHtml(m.friendly_name || m.url || 'Unnamed monitor');
            var url = m.url ? escapeHtml(m.url) : '';
            var typeLabel = m.type === 1 ? 'HTTP(s)' : (m.type === 2 ? 'Keyword' : (m.type === 3 ? 'Ping' : 'Port'));
            var interval = m.interval ? (m.interval >= 60 ? Math.round(m.interval/60) + 'm' : m.interval + 's') : '—';
            var barClass = uptime >= 99 ? '' : (uptime >= 95 ? 'warn' : 'crit');
            var sparkline = generateSparkline(m.response_times);

            return '<div class="ns-card ' + meta.key + '">' +
                '<div class="ns-card-header">' +
                    '<div class="ns-card-left">' +
                        '<div class="ns-dot-wrap">' +
                            '<div class="ns-dot ' + meta.dot + '"></div>' +
                            '<div class="ns-dot-ring"></div>' +
                        '</div>' +
                        '<div style="min-width:0;">' +
                            '<div class="ns-card-name">' + name + '</div>' +
                            (url ? '<div class="ns-card-url">' + url + '</div>' : '') +
                            '<div class="ns-card-tags">' +
                                '<span class="ns-badge ' + meta.badgeCls + '">' + meta.label + '</span>' +
                                '<span class="ns-card-meta">' + typeLabel + ' · ' + interval + '</span>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="ns-card-right">' +
                        '<div class="ns-card-uptime">' + uptime.toFixed(2) + '%</div>' +
                        '<div class="ns-card-uptime-label">Uptime</div>' +
                        '<div class="ns-sparkline">' + sparkline + '</div>' +
                        '<div class="ns-card-response"><i class="ti ti-bolt"></i> ' + response + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="ns-bar-track">' +
                    '<div class="ns-bar-fill ' + barClass + '" style="width:' + Math.max(0, Math.min(100, uptime)) + '%"></div>' +
                '</div>' +
                '<div class="ns-bar-meta">' +
                    '<span>30-day uptime</span>' +
                    '<span>All-time: ' + allTimeUptime.toFixed(2) + '%</span>' +
                '</div>' +
            '</div>';
        }).join('');

        requestAnimationFrame(function() {
            var cards = els.list.querySelectorAll('.ns-card');
            cards.forEach(function(card, i) {
                setTimeout(function() { card.classList.add('visible'); }, i * 60);
            });
        });
    }

    async function fetchMonitors() {
        clearError();
        try {
            var data;
            try {
                var response = await fetch(API_JSON, { method: 'GET', headers: { 'Accept': 'application/json' } });
                if (!response.ok) throw new Error('Static cache not available');
                data = await response.json();
            } catch (staticErr) {
                var response2 = await fetch(API_PROXY, { method: 'GET', headers: { 'Accept': 'application/json' } });
                data = await response2.json();
            }

            if (data.stat !== 'ok') {
                throw new Error((data.error && data.error.message) ? data.error.message : 'Unable to load monitor data.');
            }
            monitors = Array.isArray(data.monitors) ? data.monitors : [];
            lastUpdatedTimestamp = data.last_updated_timestamp || Math.floor(Date.now() / 1000);
            renderSummary();
            renderList();
            updateLastCheckedText();
        } catch (error) {
            els.loading.classList.add('d-none');
            setError('Unable to load status data from UptimeRobot. ' + error.message);
            els.orb.classList.remove('loading', 'up', 'warning');
            els.orb.classList.add('down');
            els.orb.innerHTML = '<i class="ti ti-alert-circle"></i>';
            els.overallTitle.textContent = 'Status data unavailable';
            els.overallSubtitle.textContent = 'Please check your UptimeRobot API configuration in the SNBDHost Manager module.';
        }
    }

    function startRefreshTimer() {
        refreshIn = REFRESH_PERIOD;
        if (countdownInterval) clearInterval(countdownInterval);
        if (refreshTimer) clearInterval(refreshTimer);

        countdownInterval = setInterval(function() {
            refreshIn--;
            if (refreshIn <= 0) refreshIn = REFRESH_PERIOD;
            var progress = (refreshIn / REFRESH_PERIOD) * REFRESH_CIRCUM;
            els.refreshProgress.setAttribute('stroke-dashoffset', REFRESH_CIRCUM - progress);
            updateLastCheckedText();
        }, 1000);

        refreshTimer = setInterval(function() {
            fetchMonitors();
            refreshIn = REFRESH_PERIOD;
        }, REFRESH_PERIOD * 1000);
    }

    document.querySelectorAll('[data-status-filter]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.querySelectorAll('[data-status-filter]').forEach(function(b) { b.classList.remove('active'); });
            this.classList.add('active');
            activeFilter = this.getAttribute('data-status-filter');
            renderList();
        });
    });

    els.search.addEventListener('input', function() {
        searchQuery = this.value;
        renderList();
    });

    fetchMonitors();
    startRefreshTimer();
})();
{/literal}
</script>

{include file="{$template}/footer.tpl"}
