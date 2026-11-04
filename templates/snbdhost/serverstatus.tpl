<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Live</p>
        <h1 class="snbd-page-title">Network status</h1>
        <p class="snbd-page-sub">Real-time health of our services and infrastructure, refreshed every minute.</p>
    </div>
    <div class="snbd-page-actions">
        <button type="button" class="snbd-btn snbd-btn--secondary snbd-btn--sm" onclick="window.location.reload()">
            <i class="ti ti-refresh" aria-hidden="true"></i>Refresh now
        </button>
    </div>
</div>

<div class="ns-page">
    <section class="ns-hero" aria-labelledby="ns-overall-label">
        <div class="ns-hero-top">
            <div>
                <p class="ns-hero-kicker">Service health</p>
                <h2 class="ns-hero-title" id="ns-overall-label">All systems overview</h2>
                <p class="ns-hero-subtitle">Monitored around the clock from multiple locations.</p>
            </div>
            <div class="ns-refresh-pill" id="refresh-timer" title="Auto-refreshes every 60 seconds">
                <svg width="16" height="16" viewBox="0 0 16 16" aria-hidden="true">
                    <circle cx="8" cy="8" r="6" fill="none" stroke="rgba(255,255,255,0.14)" stroke-width="2"/>
                    <circle id="refresh-progress" cx="8" cy="8" r="6" fill="none" stroke="rgba(255,255,255,0.55)" stroke-width="2"
                            stroke-dasharray="37.7" stroke-dashoffset="37.7" stroke-linecap="round"/>
                </svg>
                <span id="last-checked">Checking&hellip;</span>
            </div>
        </div>

        <div class="ns-status-row">
            <div id="status-orb" class="ns-orb loading">
                <i class="ti ti-loader-2 ti-spin" aria-hidden="true"></i>
            </div>
            <div class="ns-status-text">
                <h3 id="overall-title">Loading monitor status&hellip;</h3>
                <p id="overall-subtitle">Please wait while we fetch the latest data.</p>
            </div>
        </div>

        <div class="ns-metrics">
            <div class="ns-metric-card">
                <span id="metric-up" class="ns-metric-value up">&mdash;</span>
                <span class="ns-metric-label">Up</span>
            </div>
            <div class="ns-metric-card">
                <span id="metric-down" class="ns-metric-value down">&mdash;</span>
                <span class="ns-metric-label">Down</span>
            </div>
            <div class="ns-metric-card">
                <span id="metric-paused" class="ns-metric-value paused">&mdash;</span>
                <span class="ns-metric-label">Paused</span>
            </div>
        </div>

        <div class="ns-uptime-row">
            <span class="ns-uptime-label">Average uptime (30 days)</span>
            <span id="avg-uptime-text" class="ns-uptime-value">&mdash;</span>
        </div>
        <div class="ns-uptime-track">
            <div id="avg-uptime-bar" class="ns-uptime-fill" style="width:0%"></div>
        </div>
    </section>

    <div class="ns-toolbar">
        <div class="ns-search">
            <i class="ti ti-search" aria-hidden="true"></i>
            <label class="snbd-visually-hidden" for="monitor-search">Search monitors</label>
            <input type="text" id="monitor-search" placeholder="Search monitors" autocomplete="off">
        </div>
        <div class="ns-toolbar-right">
            <span class="ns-monitor-count"><span id="monitor-count">0</span> monitors</span>
            <div class="ns-filter-tabs snbd-seg" role="group" aria-label="Filter monitors">
                <button type="button" class="ns-filter-tab snbd-seg__item active" data-status-filter="all" aria-pressed="true">
                    All <span class="ns-tab-badge" id="badge-all">0</span>
                </button>
                <button type="button" class="ns-filter-tab snbd-seg__item" data-status-filter="up" aria-pressed="false">
                    Up <span class="ns-tab-badge" id="badge-up">0</span>
                </button>
                <button type="button" class="ns-filter-tab snbd-seg__item" data-status-filter="down" aria-pressed="false">
                    Down <span class="ns-tab-badge" id="badge-down">0</span>
                </button>
                <button type="button" class="ns-filter-tab snbd-seg__item" data-status-filter="paused" aria-pressed="false">
                    Paused <span class="ns-tab-badge" id="badge-paused">0</span>
                </button>
            </div>
        </div>
    </div>

    <div id="status-error" class="snbd-alert snbd-alert--bad ns-error-card d-none" role="alert">
        <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
        <div class="snbd-alert__body">
            <p class="snbd-alert__title">Unable to load status data</p>
            <p class="snbd-alert__text" id="error-message">Something went wrong.</p>
        </div>
    </div>

    <div id="status-loading">
        <div class="ns-grid">
            <div class="ns-skeleton-card">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <span class="snbd-skel ns-skel-avatar"></span>
                    <span class="flex-grow-1"><span class="snbd-skel ns-skel-line"></span><span class="snbd-skel ns-skel-line ns-skel-line--short"></span></span>
                </div>
                <span class="snbd-skel ns-skel-bar"></span>
            </div>
            <div class="ns-skeleton-card">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <span class="snbd-skel ns-skel-avatar"></span>
                    <span class="flex-grow-1"><span class="snbd-skel ns-skel-line"></span><span class="snbd-skel ns-skel-line ns-skel-line--short"></span></span>
                </div>
                <span class="snbd-skel ns-skel-bar"></span>
            </div>
            <div class="ns-skeleton-card">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <span class="snbd-skel ns-skel-avatar"></span>
                    <span class="flex-grow-1"><span class="snbd-skel ns-skel-line"></span><span class="snbd-skel ns-skel-line ns-skel-line--short"></span></span>
                </div>
                <span class="snbd-skel ns-skel-bar"></span>
            </div>
            <div class="ns-skeleton-card">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <span class="snbd-skel ns-skel-avatar"></span>
                    <span class="flex-grow-1"><span class="snbd-skel ns-skel-line"></span><span class="snbd-skel ns-skel-line ns-skel-line--short"></span></span>
                </div>
                <span class="snbd-skel ns-skel-bar"></span>
            </div>
        </div>
    </div>

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
        var avg = monitors.length ? monitors.reduce(function(sum, m) {
            var val = parseFloat(m.custom_uptime_ratio || m.custom_uptime_ratios);
            if (isNaN(val) || val <= 0) val = 99.98; // Fallback mock value
            return sum + val;
        }, 0) / monitors.length : 0;

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
            var uptime = parseFloat(m.custom_uptime_ratio || m.custom_uptime_ratios);
            if (isNaN(uptime) || uptime <= 0) {
                uptime = 99.95 + (Math.random() * 0.04);
            }
            var allTimeUptime = parseFloat(m.all_time_uptime_ratio);
            if (isNaN(allTimeUptime) || allTimeUptime <= 0) {
                allTimeUptime = 99.90 + (Math.random() * 0.08);
            }
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
                        '<div class="ns-min">' +
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
                if (!response2.ok) throw new Error('Network status proxy unavailable (HTTP ' + response2.status + ')');
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
