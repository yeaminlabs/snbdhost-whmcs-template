{include file="{$template}/header.tpl" title="Network Status"}

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
        <div>
            <h1 class="h3 mb-1">Network Status</h1>
            <p class="text-muted mb-0">Live service and infrastructure health for SNBD Host.</p>
        </div>
        <div class="d-flex align-items-center gap-3 small text-muted">
            <span id="status-last-checked">Checking…</span>
            <span id="status-refreshing" class="d-none">
                <i class="ti ti-loader-2 spinner-border spinner-border-sm border-0"></i>
                Refreshing
            </span>
        </div>
    </div>

    <div id="status-app">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4">
                <div class="d-flex align-items-start justify-content-between flex-wrap gap-4">
                    <div class="d-flex align-items-center gap-3">
                        <div id="overall-icon" class="rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;background:#eef2ff;color:#4f46e5;">
                            <i class="ti ti-loader-2 ti-spin fs-4"></i>
                        </div>
                        <div>
                            <h2 id="overall-title" class="h4 mb-1">Loading monitor status…</h2>
                            <p id="overall-subtitle" class="text-muted mb-0">Please wait while we fetch the latest UptimeRobot data.</p>
                        </div>
                    </div>
                    <div class="row g-3 text-center flex-grow-1" style="max-width:360px; min-width:280px;">
                        <div class="col-4">
                            <div class="border rounded-3 p-3 bg-light-subtle">
                                <div id="metric-up" class="fw-bold fs-4">—</div>
                                <div class="small text-muted text-uppercase">Up</div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="border rounded-3 p-3 bg-light-subtle">
                                <div id="metric-down" class="fw-bold fs-4">—</div>
                                <div class="small text-muted text-uppercase">Down</div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="border rounded-3 p-3 bg-light-subtle">
                                <div id="metric-paused" class="fw-bold fs-4">—</div>
                                <div class="small text-muted text-uppercase">Paused</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-4">
                    <div class="d-flex justify-content-between small text-muted mb-2">
                        <span>Average uptime (30 days)</span>
                        <strong id="avg-uptime-text">—</strong>
                    </div>
                    <div class="progress" style="height:10px;">
                        <div id="avg-uptime-bar" class="progress-bar bg-success" role="progressbar" style="width:0%"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
            <div class="small text-muted"><span id="monitor-count">0</span> monitors</div>
            <div class="btn-group" role="group" aria-label="Filter monitors">
                <button type="button" class="btn btn-outline-secondary active" data-status-filter="all">All</button>
                <button type="button" class="btn btn-outline-secondary" data-status-filter="up">Up</button>
                <button type="button" class="btn btn-outline-secondary" data-status-filter="down">Down</button>
                <button type="button" class="btn btn-outline-secondary" data-status-filter="paused">Paused</button>
            </div>
        </div>

        <div id="status-error" class="alert alert-danger d-none" role="alert"></div>

        <div id="status-loading" class="row g-3">
            <div class="col-12"><div class="card border-0 shadow-sm"><div class="card-body p-4 placeholder-glow"><span class="placeholder col-12 mb-3"></span><span class="placeholder col-8"></span></div></div></div>
            <div class="col-12"><div class="card border-0 shadow-sm"><div class="card-body p-4 placeholder-glow"><span class="placeholder col-10 mb-3"></span><span class="placeholder col-6"></span></div></div></div>
            <div class="col-12"><div class="card border-0 shadow-sm"><div class="card-body p-4 placeholder-glow"><span class="placeholder col-9 mb-3"></span><span class="placeholder col-5"></span></div></div></div>
        </div>

        <div id="status-list" class="row g-3 d-none"></div>
    </div>
</div>

<script>
(function () {
    const API_KEY = 'ur2339866-94b2971de5cdd1408685a563';
    const API_ENDPOINT = 'https://portal.snbdhost.com/serverstatus-data.php';
    let monitors = [];

    let activeFilter = 'all';
    let refreshTimer = null;

    const els = {
        lastChecked: document.getElementById('status-last-checked'),
        refreshing: document.getElementById('status-refreshing'),
        overallIcon: document.getElementById('overall-icon'),
        overallTitle: document.getElementById('overall-title'),
        overallSubtitle: document.getElementById('overall-subtitle'),
        up: document.getElementById('metric-up'),
        down: document.getElementById('metric-down'),
        paused: document.getElementById('metric-paused'),
        avgText: document.getElementById('avg-uptime-text'),
        avgBar: document.getElementById('avg-uptime-bar'),
        count: document.getElementById('monitor-count'),
        error: document.getElementById('status-error'),
        loading: document.getElementById('status-loading'),
        list: document.getElementById('status-list')
    };

    function setRefreshing(state) {
        els.refreshing.classList.toggle('d-none', !state);
    }

    function setError(message) {
        els.error.textContent = message;
        els.error.classList.remove('d-none');
    }

    function clearError() {
        els.error.textContent = '';
        els.error.classList.add('d-none');
    }

    function escapeHtml(str) {
        return String(str || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }

    function statusMeta(status) {
        if (status === 2) return { key: 'up', label: 'Up', badge: 'success', icon: 'ti-circle-check', dot: 'bg-success' };
        if (status === 9) return { key: 'down', label: 'Down', badge: 'danger', icon: 'ti-alert-circle', dot: 'bg-danger' };
        return { key: 'paused', label: 'Paused', badge: 'secondary', icon: 'ti-player-pause', dot: 'bg-secondary' };
    }

    function renderSummary() {
        const up = monitors.filter(m => m.status === 2).length;
        const down = monitors.filter(m => m.status === 9).length;
        const paused = monitors.filter(m => m.status === 0).length;
        const avg = monitors.length
            ? monitors.reduce((sum, m) => sum + (parseFloat(m.custom_uptime_ratio) || 0), 0) / monitors.length
            : 0;

        els.up.textContent = up;
        els.down.textContent = down;
        els.paused.textContent = paused;
        els.avgText.textContent = avg.toFixed(2) + '%';
        els.avgBar.style.width = Math.max(0, Math.min(100, avg)).toFixed(2) + '%';
        els.count.textContent = monitors.length;

        if (down > 0) {
            els.overallIcon.className = 'rounded-circle d-flex align-items-center justify-content-center bg-danger-subtle text-danger';
            els.overallIcon.style.width = '56px';
            els.overallIcon.style.height = '56px';
            els.overallIcon.innerHTML = '<i class="ti ti-alert-circle fs-4"></i>';
            els.overallTitle.textContent = down + ' service' + (down > 1 ? 's are' : ' is') + ' down';
            els.overallSubtitle.textContent = 'Some monitored endpoints are currently unavailable.';
        } else if (paused > 0) {
            els.overallIcon.className = 'rounded-circle d-flex align-items-center justify-content-center bg-warning-subtle text-warning';
            els.overallIcon.style.width = '56px';
            els.overallIcon.style.height = '56px';
            els.overallIcon.innerHTML = '<i class="ti ti-alert-triangle fs-4"></i>';
            els.overallTitle.textContent = 'Some monitors are paused';
            els.overallSubtitle.textContent = 'All active services are currently operational.';
        } else {
            els.overallIcon.className = 'rounded-circle d-flex align-items-center justify-content-center bg-success-subtle text-success';
            els.overallIcon.style.width = '56px';
            els.overallIcon.style.height = '56px';
            els.overallIcon.innerHTML = '<i class="ti ti-circle-check fs-4"></i>';
            els.overallTitle.textContent = 'All systems operational';
            els.overallSubtitle.textContent = 'All monitored services are responding normally.';
        }
    }

    function filteredMonitors() {
        if (activeFilter === 'all') return monitors;
        if (activeFilter === 'up') return monitors.filter(m => m.status === 2);
        if (activeFilter === 'down') return monitors.filter(m => m.status === 9);
        return monitors.filter(m => m.status === 0);
    }

    function renderList() {
        const items = filteredMonitors();
        els.loading.classList.add('d-none');
        els.list.classList.remove('d-none');

        if (!items.length) {
            els.list.innerHTML = '<div class="col-12"><div class="card border-0 shadow-sm"><div class="card-body p-4 text-muted">No monitors match this filter.</div></div></div>';
            return;
        }

        els.list.innerHTML = items.map((m) => {
            const meta = statusMeta(m.status);
            const uptime = parseFloat(m.custom_uptime_ratio || 0);
            const response = Array.isArray(m.response_times) && m.response_times.length ? (m.response_times[0].value + ' ms') : '—';
            const name = escapeHtml(m.friendly_name || m.url || 'Unnamed monitor');
            const url = m.url ? '<div class="small text-muted text-break mt-1">' + escapeHtml(m.url) + '</div>' : '';
            return `
                <div class="col-12">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start gap-3 flex-wrap">
                                <div class="d-flex align-items-start gap-3">
                                    <span class="rounded-circle ${meta.dot}" style="width:12px;height:12px;display:inline-block;margin-top:7px;"></span>
                                    <div>
                                        <div class="fw-semibold">${name}</div>
                                        ${url}
                                    </div>
                                </div>
                                <div class="text-md-end d-flex flex-column align-items-md-end gap-2">
                                    <span class="badge text-bg-${meta.badge}">${meta.label}</span>
                                    <div class="small text-muted">Uptime: <strong>${uptime.toFixed(2)}%</strong></div>
                                    <div class="small text-muted">Response: <strong>${response}</strong></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>`;
        }).join('');
    }

    async function fetchMonitors() {
        setRefreshing(true);
        clearError();
        try {
            const response = await fetch(API_ENDPOINT, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    api_key: API_KEY,
                    format: 'json',
                    logs: '0',
                    response_times: '1',
                    response_times_limit: '1',
                    uptime_ratio: '30',
                    all_time_uptime_ratio: '1'
                })
            });

            const data = await response.json();
            if (data.stat !== 'ok') {
                throw new Error((data.error && data.error.message) ? data.error.message : 'Unable to load monitor data.');
            }

            monitors = Array.isArray(data.monitors) ? data.monitors : [];
            renderSummary();
            renderList();
            els.lastChecked.textContent = 'Updated ' + new Date().toLocaleTimeString();
        } catch (error) {
            els.loading.classList.add('d-none');
            setError('Unable to load status data from UptimeRobot. This is usually caused by browser-side CORS blocking on direct API requests.');
            els.overallIcon.className = 'rounded-circle d-flex align-items-center justify-content-center bg-danger-subtle text-danger';
            els.overallIcon.style.width = '56px';
            els.overallIcon.style.height = '56px';
            els.overallIcon.innerHTML = '<i class="ti ti-alert-circle fs-4"></i>';
            els.overallTitle.textContent = 'Status data unavailable';
            els.overallSubtitle.textContent = error.message;
        } finally {
            setRefreshing(false);
        }
    }

    document.querySelectorAll('[data-status-filter]').forEach((btn) => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('[data-status-filter]').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            activeFilter = this.getAttribute('data-status-filter');
            renderList();
        });
    });

    fetchMonitors();
    refreshTimer = setInterval(fetchMonitors, 60000);
})();
</script>

{include file="{$template}/footer.tpl"}
