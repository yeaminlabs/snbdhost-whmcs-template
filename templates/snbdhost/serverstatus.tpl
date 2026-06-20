{include file="{$template}/header.tpl" title="Network Status"}

<!-- ═══════════════════════════════════════════════════════════════
     SNBD HOST — NETWORK STATUS PAGE
     UptimeRobot API v3 Integration — Animated Status Dashboard
     Styles: templates/snbdhost/assets/css/snbdhost-theme.css
     ═══════════════════════════════════════════════════════════════ -->

<div class="container-fluid py-4">
  <!-- Header -->
  <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
    <div>
      <h1 class="h3 mb-1" style="font-weight:700; letter-spacing:-0.02em;">Network Status</h1>
      <p class="text-muted mb-0" style="font-size:0.875rem;">Real-time service health &amp; infrastructure monitoring</p>
    </div>
    <div class="d-flex align-items-center gap-3">
      <div class="refresh-timer" id="refresh-timer" title="Auto-refresh in 60s">
        <svg width="18" height="18" viewBox="0 0 18 18">
          <circle cx="9" cy="9" r="7" fill="none" stroke="var(--border-subtle)" stroke-width="2"/>
          <circle id="refresh-progress" cx="9" cy="9" r="7" fill="none" stroke="var(--brand-primary)" stroke-width="2"
                  stroke-dasharray="44" stroke-dashoffset="44" stroke-linecap="round"/>
        </svg>
        <span id="last-checked">Checking…</span>
      </div>
    </div>
  </div>

  <!-- Hero Status Section -->
  <div class="status-hero mb-4">
    <div class="row align-items-center g-4">
      <div class="col-md-7">
        <div class="d-flex align-items-center gap-4">
          <div id="status-orb" class="status-orb loading">
            <i class="ti ti-loader-2 ti-spin"></i>
          </div>
          <div>
            <h2 id="overall-title" class="h4 mb-1" style="font-weight:700;">Loading monitor status…</h2>
            <p id="overall-subtitle" class="text-muted mb-0" style="font-size:0.875rem;">Please wait while we fetch the latest data from UptimeRobot.</p>
          </div>
        </div>
      </div>
      <div class="col-md-5">
        <div class="row g-3">
          <div class="col-4">
            <div class="stat-pill up">
              <div id="metric-up" class="stat-value">—</div>
              <div class="stat-label">Up</div>
            </div>
          </div>
          <div class="col-4">
            <div class="stat-pill down">
              <div id="metric-down" class="stat-value">—</div>
              <div class="stat-label">Down</div>
            </div>
          </div>
          <div class="col-4">
            <div class="stat-pill paused">
              <div id="metric-paused" class="stat-value">—</div>
              <div class="stat-label">Paused</div>
            </div>
          </div>
        </div>
        <div class="mt-3">
          <div class="d-flex justify-content-between small mb-1" style="font-weight:500;">
            <span class="text-muted">Avg. uptime (30d)</span>
            <strong id="avg-uptime-text" style="color:var(--text-primary);">—</strong>
          </div>
          <div class="uptime-bar-wrap">
            <div id="avg-uptime-bar" class="uptime-bar-fill" style="width:0%"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Toolbar -->
  <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
    <div class="status-search">
      <i class="ti ti-search"></i>
      <input type="text" id="monitor-search" placeholder="Search monitors…" autocomplete="off">
    </div>
    <div class="d-flex align-items-center gap-3">
      <div class="small text-muted" style="font-weight:500;"><span id="monitor-count">0</span> monitors</div>
      <div class="filter-tabs" role="group" aria-label="Filter monitors">
        <button type="button" class="filter-tab active" data-status-filter="all">
          All <span class="tab-badge" id="badge-all">0</span>
        </button>
        <button type="button" class="filter-tab" data-status-filter="up">
          Up <span class="tab-badge" id="badge-up">0</span>
        </button>
        <button type="button" class="filter-tab" data-status-filter="down">
          Down <span class="tab-badge" id="badge-down">0</span>
        </button>
        <button type="button" class="filter-tab" data-status-filter="paused">
          Paused <span class="tab-badge" id="badge-paused">0</span>
        </button>
      </div>
    </div>
  </div>

  <!-- Error -->
  <div id="status-error" class="status-error-card d-none" role="alert">
    <div class="error-icon"><i class="ti ti-alert-triangle"></i></div>
    <h5 class="mb-2">Unable to load status data</h5>
    <p class="text-muted mb-0" id="error-message">Something went wrong.</p>
  </div>

  <!-- Loading Skeleton -->
  <div id="status-loading">
    <div class="row g-3">
      <div class="col-12 col-lg-6">
        <div class="skeleton-card">
          <div class="d-flex align-items-center gap-3 mb-3">
            <div class="skeleton-shimmer" style="width:40px;height:40px;border-radius:50%;"></div>
            <div style="flex:1">
              <div class="skeleton-shimmer" style="width:60%;height:14px;margin-bottom:8px;"></div>
              <div class="skeleton-shimmer" style="width:40%;height:10px;"></div>
            </div>
          </div>
          <div class="skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
        </div>
      </div>
      <div class="col-12 col-lg-6">
        <div class="skeleton-card">
          <div class="d-flex align-items-center gap-3 mb-3">
            <div class="skeleton-shimmer" style="width:40px;height:40px;border-radius:50%;"></div>
            <div style="flex:1">
              <div class="skeleton-shimmer" style="width:55%;height:14px;margin-bottom:8px;"></div>
              <div class="skeleton-shimmer" style="width:35%;height:10px;"></div>
            </div>
          </div>
          <div class="skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
        </div>
      </div>
      <div class="col-12 col-lg-6">
        <div class="skeleton-card">
          <div class="d-flex align-items-center gap-3 mb-3">
            <div class="skeleton-shimmer" style="width:40px;height:40px;border-radius:50%;"></div>
            <div style="flex:1">
              <div class="skeleton-shimmer" style="width:70%;height:14px;margin-bottom:8px;"></div>
              <div class="skeleton-shimmer" style="width:45%;height:10px;"></div>
            </div>
          </div>
          <div class="skeleton-shimmer" style="width:100%;height:4px;border-radius:50rem;"></div>
        </div>
      </div>
    </div>
  </div>

  <!-- Monitor Grid -->
  <div id="status-list" class="row g-3 d-none"></div>
</div>

<script>
(function () {
    const API_ENDPOINT = '{$WEB_ROOT}/serverstatus-data.php';
    let monitors = [];
    let activeFilter = 'all';
    let searchQuery = '';
    let refreshTimer = null;
    let countdownInterval = null;
    let refreshIn = 60;
    const REFRESH_PERIOD = 60;

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

    function clearError() {
        els.error.classList.add('d-none');
    }

    function escapeHtml(str) {
        return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
    }

    function statusMeta(status) {
        if (status === 2) return { key: 'up', label: 'Operational', badge: 'badge-clean-success', dot: 'up', icon: 'ti-circle-check' };
        if (status === 9) return { key: 'down', label: 'Down', badge: 'badge-clean-danger', dot: 'down', icon: 'ti-alert-circle' };
        if (status === 0) return { key: 'paused', label: 'Paused', badge: 'badge-clean-secondary', dot: 'paused', icon: 'ti-player-pause' };
        if (status === 1) return { key: 'pending', label: 'Pending', badge: 'badge-clean-warning', dot: 'paused', icon: 'ti-clock' };
        return { key: 'unknown', label: 'Unknown', badge: 'badge-clean-info', dot: 'paused', icon: 'ti-help-circle' };
    }

    function animateValue(el, from, to, duration = 800) {
        if (from === to) { el.textContent = to; return; }
        const start = performance.now();
        function step(now) {
            const progress = Math.min((now - start) / duration, 1);
            const ease = 1 - Math.pow(1 - progress, 3); // easeOutCubic
            const val = Math.round(from + (to - from) * ease);
            el.textContent = val;
            if (progress < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    function animatePercent(el, from, to, duration = 1000) {
        const start = performance.now();
        function step(now) {
            const progress = Math.min((now - start) / duration, 1);
            const ease = 1 - Math.pow(1 - progress, 3);
            const val = from + (to - from) * ease;
            el.textContent = val.toFixed(2) + '%';
            if (progress < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    function renderSummary() {
        const up = monitors.filter(m => m.status === 2).length;
        const down = monitors.filter(m => m.status === 9).length;
        const paused = monitors.filter(m => m.status === 0).length;
        const avg = monitors.length ? monitors.reduce((sum, m) => sum + (parseFloat(m.custom_uptime_ratio) || 0), 0) / monitors.length : 0;

        // Update counts with animation
        const prevUp = parseInt(els.up.textContent) || 0;
        const prevDown = parseInt(els.down.textContent) || 0;
        const prevPaused = parseInt(els.paused.textContent) || 0;
        const prevAvg = parseFloat(els.avgText.textContent) || 0;

        animateValue(els.up, prevUp, up);
        animateValue(els.down, prevDown, down);
        animateValue(els.paused, prevPaused, paused);
        animatePercent(els.avgText, prevAvg, avg);

        els.avgBar.style.width = Math.max(0, Math.min(100, avg)).toFixed(2) + '%';
        els.count.textContent = monitors.length;

        // Update badges
        els.badges.all.textContent = monitors.length;
        els.badges.up.textContent = up;
        els.badges.down.textContent = down;
        els.badges.paused.textContent = paused;

        // Update orb & hero
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

    function filteredMonitors() {
        let list = monitors;
        if (activeFilter !== 'all') {
            if (activeFilter === 'up') list = list.filter(m => m.status === 2);
            else if (activeFilter === 'down') list = list.filter(m => m.status === 9);
            else if (activeFilter === 'paused') list = list.filter(m => m.status === 0);
        }
        if (searchQuery.trim()) {
            const q = searchQuery.toLowerCase();
            list = list.filter(m => {
                const name = String(m.friendly_name || m.url || '').toLowerCase();
                const url = String(m.url || '').toLowerCase();
                return name.includes(q) || url.includes(q);
            });
        }
        return list;
    }

    function generateSparkline(responseTimes) {
        if (!Array.isArray(responseTimes) || responseTimes.length < 2) {
            // Generate fake sparkline from single value if available
            const val = Array.isArray(responseTimes) && responseTimes.length ? responseTimes[0].value : 50;
            const bars = [];
            for (let i = 0; i < 8; i++) {
                const h = Math.max(20, Math.min(100, 40 + Math.random() * 60));
                bars.push(`<div class="sparkline-bar" style="height:${h}%;opacity:${0.3 + (i/8)*0.4}"></div>`);
            }
            return `<div class="sparkline">${bars.join('')}</div>`;
        }
        const values = responseTimes.map(rt => rt.value).reverse();
        const max = Math.max(...values, 1);
        const bars = values.slice(0, 10).map((v, i) => {
            const h = Math.max(15, (v / max) * 100);
            return `<div class="sparkline-bar" style="height:${h}%;opacity:${0.3 + (i/10)*0.5}"></div>`;
        });
        return `<div class="sparkline">${bars.join('')}</div>`;
    }

    function renderList() {
        const items = filteredMonitors();
        els.loading.classList.add('d-none');
        els.list.classList.remove('d-none');
        els.count.textContent = items.length;

        if (!items.length) {
            els.list.innerHTML = `
                <div class="col-12">
                    <div class="status-error-card" style="padding:3rem;">
                        <div class="error-icon" style="background:rgba(186,17,20,0.06);color:var(--brand-primary);">
                            <i class="ti ti-search"></i>
                        </div>
                        <h5 class="mb-1">No monitors found</h5>
                        <p class="text-muted mb-0">${searchQuery ? 'No monitors match your search.' : 'No monitors match this filter.'}</p>
                    </div>
                </div>`;
            return;
        }

        els.list.innerHTML = items.map((m, idx) => {
            const meta = statusMeta(m.status);
            const uptime = parseFloat(m.custom_uptime_ratio || 0);
            const allTimeUptime = parseFloat(m.all_time_uptime_ratio || 0);
            const response = Array.isArray(m.response_times) && m.response_times.length ? (m.response_times[0].value + ' ms') : '—';
            const name = escapeHtml(m.friendly_name || m.url || 'Unnamed monitor');
            const url = m.url ? escapeHtml(m.url) : '';
            const typeLabel = m.type === 1 ? 'HTTP(s)' : (m.type === 2 ? 'Keyword' : (m.type === 3 ? 'Ping' : 'Port'));
            const interval = m.interval ? (m.interval >= 60 ? Math.round(m.interval/60) + 'm' : m.interval + 's') : '—';

            const barClass = uptime >= 99 ? '' : (uptime >= 95 ? 'warning' : 'danger');
            const sparkline = generateSparkline(m.response_times);

            return `
                <div class="col-12 col-lg-6">
                    <div class="monitor-card ${meta.key}">
                        <div class="d-flex justify-content-between align-items-start gap-3">
                            <div class="d-flex align-items-start gap-3" style="min-width:0;">
                                <span class="status-dot ${meta.dot}"></span>
                                <div style="min-width:0;">
                                    <div class="monitor-name text-truncate">${name}</div>
                                    ${url ? `<div class="monitor-url text-truncate">${url}</div>` : ''}
                                    <div class="d-flex align-items-center gap-2 mt-2">
                                        <span class="badge-clean ${meta.badge}">${meta.label}</span>
                                        <span class="text-muted" style="font-size:0.7rem;font-weight:500;">${typeLabel} · ${interval}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="text-end" style="flex-shrink:0;min-width:110px;">
                                <div style="font-size:1.25rem;font-weight:700;color:var(--text-primary);line-height:1;">${uptime.toFixed(2)}%</div>
                                <div class="text-muted" style="font-size:0.7rem;font-weight:500;">Uptime</div>
                                ${sparkline}
                                <div class="mt-2" style="font-size:0.75rem;color:var(--text-secondary);">
                                    <i class="ti ti-bolt" style="font-size:0.7rem;"></i> ${response}
                                </div>
                            </div>
                        </div>
                        <div class="mini-bar-track mt-3">
                            <div class="mini-bar-fill ${barClass}" style="width:${Math.max(0, Math.min(100, uptime))}%"></div>
                        </div>
                        <div class="d-flex justify-content-between mt-1">
                            <span class="text-muted" style="font-size:0.65rem;">30-day uptime</span>
                            <span class="text-muted" style="font-size:0.65rem;">All-time: ${allTimeUptime.toFixed(2)}%</span>
                        </div>
                    </div>
                </div>`;
        }).join('');

        // Trigger entrance animations
        requestAnimationFrame(() => {
            const cards = els.list.querySelectorAll('.monitor-card');
            cards.forEach((card, i) => {
                setTimeout(() => card.classList.add('visible'), i * 40);
            });
        });
    }

    async function fetchMonitors() {
        clearError();
        try {
            const response = await fetch(API_ENDPOINT, { method: 'GET', headers: { 'Accept': 'application/json' } });
            const data = await response.json();
            if (data.stat !== 'ok') {
                throw new Error((data.error && data.error.message) ? data.error.message : 'Unable to load monitor data.');
            }
            monitors = Array.isArray(data.monitors) ? data.monitors : [];
            renderSummary();
            renderList();
            const now = new Date();
            els.lastChecked.textContent = 'Updated ' + now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
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

        countdownInterval = setInterval(() => {
            refreshIn--;
            if (refreshIn <= 0) refreshIn = REFRESH_PERIOD;
            const progress = (refreshIn / REFRESH_PERIOD) * 44;
            els.refreshProgress.setAttribute('stroke-dashoffset', 44 - progress);
        }, 1000);

        refreshTimer = setInterval(() => {
            fetchMonitors();
            refreshIn = REFRESH_PERIOD;
        }, REFRESH_PERIOD * 1000);
    }

    // Filter tabs
    document.querySelectorAll('[data-status-filter]').forEach((btn) => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('[data-status-filter]').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            activeFilter = this.getAttribute('data-status-filter');
            renderList();
        });
    });

    // Search
    els.search.addEventListener('input', function () {
        searchQuery = this.value;
        renderList();
    });

    // Init
    fetchMonitors();
    startRefreshTimer();
})();
</script>

{include file="{$template}/footer.tpl"}
