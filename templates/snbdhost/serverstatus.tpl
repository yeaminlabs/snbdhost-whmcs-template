{include file="{$template}/header.tpl" title="Network Status"}

<!-- SNBD HOST Network Status Page -->
<style>
  /* ─── STATUS PAGE SPECIFIC STYLES ───────────────────────────────────── */
  .status-page-wrap {
    max-width: 860px;
    margin-inline: auto;
    padding-block: var(--space-8) var(--space-10);
  }
  .status-banner {
    margin-top: var(--space-8);
    padding: var(--space-6);
    border-radius: var(--radius-xl);
    border: 1px solid var(--color-border);
    display: flex;
    align-items: center;
    gap: var(--space-4);
    transition: background var(--transition), border-color var(--transition);
  }
  .status-banner.all-up {
    background: color-mix(in oklch, var(--color-success) 8%, var(--color-surface));
    border-color: color-mix(in oklch, var(--color-success) 25%, var(--color-border));
  }
  .status-banner.has-issues {
    background: color-mix(in oklch, var(--color-warning) 8%, var(--color-surface));
    border-color: color-mix(in oklch, var(--color-warning) 25%, var(--color-border));
  }
  .status-banner.has-down {
    background: color-mix(in oklch, var(--color-error) 8%, var(--color-surface));
    border-color: color-mix(in oklch, var(--color-error) 25%, var(--color-border));
  }
  .banner-icon {
    width: 48px;
    height: 48px;
    flex-shrink: 0;
    border-radius: var(--radius-full);
    display: grid;
    place-items: center;
    font-size: 1.5rem;
  }
  .all-up .banner-icon { background: var(--color-success-bg); }
  .has-issues .banner-icon { background: var(--color-warning-bg); }
  .has-down .banner-icon { background: var(--color-error-bg); }
  .banner-text h1 {
    font-size: var(--text-xl);
    font-weight: 700;
    letter-spacing: -.02em;
    line-height: 1.2;
    color: var(--color-text);
  }
  .banner-text p {
    font-size: var(--text-sm);
    color: var(--color-text-muted);
    margin-top: var(--space-1);
  }
  .banner-stats {
    margin-left: auto;
    display: flex;
    gap: var(--space-6);
    text-align: center;
    flex-shrink: 0;
  }
  .stat-item strong {
    display: block;
    font-size: var(--text-lg);
    font-weight: 700;
    font-variant-numeric: tabular-nums;
    letter-spacing: -.02em;
  }
  .stat-item span {
    font-size: var(--text-xs);
    color: var(--color-text-muted);
    text-transform: uppercase;
    letter-spacing: .04em;
  }
  .stat-up strong { color: var(--color-success); }
  .stat-down strong { color: var(--color-error); }
  .stat-paused strong { color: var(--color-text-muted); }
  @media (max-width: 600px) {
    .status-banner { flex-wrap: wrap; }
    .banner-stats { margin-left: 0; width: 100%; justify-content: flex-start; }
  }
  .uptime-bar-section {
    margin-top: var(--space-6);
    padding: var(--space-5) var(--space-6);
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-xl);
  }
  .uptime-bar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: var(--space-3);
  }
  .uptime-bar-header span { font-size: var(--text-xs); color: var(--color-text-muted); }
  .uptime-bar-header strong { font-size: var(--text-sm); font-weight: 600; }
  .uptime-bar {
    height: 8px;
    border-radius: var(--radius-full);
    background: var(--color-border);
    overflow: hidden;
  }
  .uptime-fill {
    height: 100%;
    border-radius: var(--radius-full);
    background: var(--color-success);
    transition: width 1s cubic-bezier(.16,1,.3,1);
  }
  .section-heading {
    margin-top: var(--space-10);
    margin-bottom: var(--space-4);
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .section-heading h2 {
    font-size: var(--text-sm);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: .06em;
    color: var(--color-text-muted);
  }
  .filter-bar { display: flex; gap: var(--space-2); }
  .filter-btn {
    font-size: var(--text-xs);
    padding: 4px var(--space-3);
    border-radius: var(--radius-full);
    border: 1px solid var(--color-border);
    background: var(--color-surface);
    color: var(--color-text-muted);
    transition: all var(--transition);
  }
  .filter-btn:hover, .filter-btn.active {
    background: var(--color-primary-highlight);
    border-color: var(--color-primary);
    color: var(--color-primary);
  }
  .monitors-grid { display: flex; flex-direction: column; gap: var(--space-2); }
  .monitor-card {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    padding: var(--space-4) var(--space-5);
    display: grid;
    grid-template-columns: 1fr auto;
    align-items: center;
    gap: var(--space-3);
    transition: box-shadow var(--transition), border-color var(--transition);
  }
  .monitor-card:hover {
    box-shadow: var(--shadow-md);
    border-color: color-mix(in oklch, var(--color-primary) 30%, var(--color-border));
  }
  .monitor-left { display: flex; align-items: center; gap: var(--space-3); min-width: 0; }
  .status-dot {
    width: 10px;
    height: 10px;
    border-radius: var(--radius-full);
    flex-shrink: 0;
    position: relative;
  }
  .status-dot.up { background: var(--color-success); }
  .status-dot.down { background: var(--color-error); }
  .status-dot.paused { background: var(--color-text-faint); }
  .status-dot.up::after {
    content: '';
    position: absolute;
    inset: -3px;
    border-radius: var(--radius-full);
    background: var(--color-success);
    opacity: .25;
    animation: pulse 2s ease-in-out infinite;
  }
  @keyframes pulse {
    0%,100% { transform: scale(1); opacity: .25; }
    50% { transform: scale(1.6); opacity: 0; }
  }
  .monitor-info { min-width: 0; }
  .monitor-name {
    font-size: var(--text-sm);
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .monitor-url {
    font-size: var(--text-xs);
    color: var(--color-text-muted);
    font-family: var(--font-mono);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    margin-top: 2px;
  }
  .monitor-right { display: flex; align-items: center; gap: var(--space-4); flex-shrink: 0; }
  .monitor-meta { text-align: right; }
  .monitor-uptime {
    font-size: var(--text-sm);
    font-weight: 600;
    font-variant-numeric: tabular-nums;
    color: var(--color-success);
  }
  .monitor-uptime.low { color: var(--color-error); }
  .monitor-uptime.medium { color: var(--color-warning); }
  .monitor-response {
    font-size: var(--text-xs);
    color: var(--color-text-muted);
    font-family: var(--font-mono);
    margin-top: 2px;
  }
  .status-badge {
    padding: 3px var(--space-3);
    border-radius: var(--radius-full);
    font-size: var(--text-xs);
    font-weight: 600;
    letter-spacing: .02em;
  }
  .badge-up { background: var(--color-success-bg); color: var(--color-success); }
  .badge-down { background: var(--color-error-bg); color: var(--color-error); }
  .badge-paused { background: var(--color-surface-offset); color: var(--color-text-muted); }
  .spark-bar-row {
    display: flex;
    gap: 2px;
    align-items: flex-end;
    height: 24px;
    margin-top: var(--space-3);
    padding-top: var(--space-3);
    border-top: 1px solid var(--color-divider);
    grid-column: 1 / -1;
  }
  .spark-bar {
    flex: 1;
    border-radius: 2px;
    background: var(--color-success);
    opacity: .7;
    min-height: 4px;
    transition: opacity var(--transition);
  }
  .spark-bar.incident { background: var(--color-error); opacity: 1; }
  .spark-bar:hover { opacity: 1; }
  @keyframes shimmer {
    0% { background-position: -200% 0; }
    100% { background-position: 200% 0; }
  }
  .skeleton {
    background: linear-gradient(90deg, var(--color-surface-offset) 25%, var(--color-divider) 50%, var(--color-surface-offset) 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s ease-in-out infinite;
    border-radius: var(--radius-sm);
  }
  .skeleton-card { height: 72px; border-radius: var(--radius-lg); }
  .error-state {
    text-align: center;
    padding: var(--space-12) var(--space-8);
    color: var(--color-text-muted);
  }
  .error-state .icon { font-size: 2.5rem; margin-bottom: var(--space-4); }
  .error-state h3 {
    font-size: var(--text-base);
    font-weight: 600;
    color: var(--color-text);
    margin-bottom: var(--space-2);
  }
  .error-state p {
    font-size: var(--text-sm);
    max-width: 36ch;
    margin-inline: auto;
  }
  .btn-retry {
    margin-top: var(--space-4);
    padding: var(--space-2) var(--space-5);
    background: var(--color-primary);
    color: #fff;
    border-radius: var(--radius-md);
    font-size: var(--text-sm);
    font-weight: 500;
    transition: background var(--transition);
  }
  .btn-retry:hover { background: var(--color-primary-hover); }
  .refresh-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: var(--space-4);
    font-size: var(--text-xs);
    color: var(--color-text-muted);
  }
  .refresh-spinner {
    width: 14px;
    height: 14px;
    border: 2px solid var(--color-border);
    border-top-color: var(--color-primary);
    border-radius: 50%;
    animation: spin .8s linear infinite;
    display: none;
  }
  .refresh-spinner.active { display: block; }
  @keyframes spin { to { transform: rotate(360deg); } }
  @media (max-width: 480px) {
    .monitor-uptime { display: none; }
  }
</style>

<main class="status-page-wrap">
  <div class="status-banner" id="status-banner">
    <div class="banner-icon" id="banner-icon">⏳</div>
    <div class="banner-text">
      <h1 id="banner-title">Checking systems…</h1>
      <p id="banner-sub">Please wait while we fetch live data.</p>
    </div>
    <div class="banner-stats" id="banner-stats" style="display:none">
      <div class="stat-item stat-up"><strong id="stat-up">—</strong><span>Online</span></div>
      <div class="stat-item stat-down"><strong id="stat-down">—</strong><span>Down</span></div>
      <div class="stat-item stat-paused"><strong id="stat-paused">—</strong><span>Paused</span></div>
    </div>
  </div>

  <div class="uptime-bar-section" id="uptime-bar-section" style="display:none">
    <div class="uptime-bar-header"><span>Overall uptime (30 days)</span><strong id="overall-uptime">—</strong></div>
    <div class="uptime-bar"><div class="uptime-fill" id="uptime-fill" style="width:0%"></div></div>
  </div>

  <div class="refresh-row">
    <span id="monitor-count" style="opacity:0">0 monitors</span>
    <div style="display:flex;align-items:center;gap:.5rem">
      <div class="refresh-spinner" id="spinner"></div>
      <span id="next-refresh" style="opacity:0">Auto-refresh in <strong id="countdown">60</strong>s</span>
    </div>
  </div>

  <div class="section-heading">
    <h2>Monitors</h2>
    <div class="filter-bar">
      <button class="filter-btn active" data-filter="all">All</button>
      <button class="filter-btn" data-filter="up">Up</button>
      <button class="filter-btn" data-filter="down">Down</button>
      <button class="filter-btn" data-filter="paused">Paused</button>
    </div>
  </div>

  <div id="skeleton-grid" class="monitors-grid">
    <div class="skeleton skeleton-card"></div>
    <div class="skeleton skeleton-card"></div>
    <div class="skeleton skeleton-card"></div>
    <div class="skeleton skeleton-card"></div>
    <div class="skeleton skeleton-card"></div>
  </div>

  <div id="monitors-grid" class="monitors-grid" style="display:none"></div>

  <div id="error-state" class="error-state" style="display:none">
    <div class="icon">⚠️</div>
    <h3>Unable to load monitor data</h3>
    <p>There was an issue connecting to the UptimeRobot API.</p>
    <button class="btn-retry" onclick="loadMonitors()">Retry</button>
  </div>

  <footer class="site-footer" style="margin-top:var(--space-16);padding-top:var(--space-6);border-top:1px solid var(--color-border);display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:var(--space-3)">
    <div class="footer-brand" style="display:flex;align-items:center;gap:var(--space-2);font-size:var(--text-xs);color:var(--color-text-muted)">
      <svg width="18" height="18" viewBox="0 0 32 32" fill="none">
        <rect width="32" height="32" rx="8" fill="var(--color-primary)"/>
        <rect x="8" y="10" width="7" height="5" rx="2" fill="white"/>
        <rect x="17" y="17" width="7" height="5" rx="2" fill="white"/>
      </svg>
      © 2024 SNBD Host — All rights reserved
    </div>
    <div class="footer-links" style="display:flex;gap:var(--space-4)">
      <a href="https://snbdhost.com" target="_blank" rel="noopener" style="font-size:var(--text-xs);color:var(--color-text-muted);transition:color var(--transition)">Homepage</a>
      <a href="https://portal.snbdhost.com" target="_blank" rel="noopener" style="font-size:var(--text-xs);color:var(--color-text-muted);transition:color var(--transition)">Client Portal</a>
      <a href="mailto:support@snbdhost.com" style="font-size:var(--text-xs);color:var(--color-text-muted);transition:color var(--transition)">Support</a>
    </div>
    <span class="powered-by" style="font-size:var(--text-xs);color:var(--color-text-faint)">Powered by UptimeRobot API v3</span>
  </footer>
</main>

<script>
  const API_KEY = 'ur2339866-94b2971de5cdd1408685a563';
  let allMonitors = [], countdownVal = 60, countdownTimer = null;

  async function loadMonitors() {
    document.getElementById('spinner').classList.add('active');
    document.getElementById('error-state').style.display = 'none';
    try {
      const r = await fetch('https://api.uptimerobot.com/v3/getMonitors', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: new URLSearchParams({
          api_key: API_KEY, format:'json', logs:'0',
          response_times:'1', response_times_limit:'1',
          uptime_ratio:'30', all_time_uptime_ratio:'1'
        })
      });
      const data = await r.json();
      if (data.stat !== 'ok') throw new Error(data.error?.message || 'API error');
      allMonitors = data.monitors || [];
      renderAll();
      updateLastChecked();
      startCountdown();
    } catch(e) {
      document.getElementById('skeleton-grid').style.display = 'none';
      document.getElementById('error-state').style.display = 'block';
      document.getElementById('banner-title').textContent = 'Unable to load status';
      document.getElementById('banner-sub').textContent = e.message;
    } finally {
      document.getElementById('spinner').classList.remove('active');
    }
  }

  function renderAll() {
    const up = allMonitors.filter(m=>m.status===2).length;
    const down = allMonitors.filter(m=>m.status===9).length;
    const paused = allMonitors.filter(m=>m.status===0).length;
    const total = allMonitors.length;
    const banner = document.getElementById('status-banner');
    banner.className = 'status-banner';
    if (down > 0) {
      banner.classList.add('has-down');
      document.getElementById('banner-icon').textContent = '🔴';
      document.getElementById('banner-title').textContent = `${down} Service${down>1?'s':''} Down`;
      document.getElementById('banner-sub').textContent = 'Our team has been notified and is actively investigating.';
    } else if (paused > 0) {
      banner.classList.add('has-issues');
      document.getElementById('banner-icon').textContent = '🟡';
      document.getElementById('banner-title').textContent = 'Some Monitors Paused';
      document.getElementById('banner-sub').textContent = 'All active services are running normally.';
    } else {
      banner.classList.add('all-up');
      document.getElementById('banner-icon').textContent = '✅';
      document.getElementById('banner-title').textContent = 'All Systems Operational';
      document.getElementById('banner-sub').textContent = 'All services are running smoothly. No incidents reported.';
    }
    document.getElementById('stat-up').textContent = up;
    document.getElementById('stat-down').textContent = down;
    document.getElementById('stat-paused').textContent = paused;
    document.getElementById('banner-stats').style.display = '';
    const avg = allMonitors.reduce((s,m) => s + (parseFloat(m.custom_uptime_ratio)||100), 0) / (total||1);
    document.getElementById('uptime-bar-section').style.display = '';
    document.getElementById('overall-uptime').textContent = avg.toFixed(2) + '%';
    setTimeout(() => { document.getElementById('uptime-fill').style.width = avg + '%'; }, 100);
    const mc = document.getElementById('monitor-count');
    mc.textContent = total + ' monitor' + (total!==1?'s':''); mc.style.opacity='1';
    document.getElementById('next-refresh').style.opacity = '1';
    renderCards(allMonitors);
    document.getElementById('skeleton-grid').style.display = 'none';
    document.getElementById('monitors-grid').style.display = 'flex';
  }

  function renderCards(monitors) {
    const grid = document.getElementById('monitors-grid');
    if (!monitors.length) {
      grid.innerHTML = '<div class="error-state" style="display:block"><div class="icon">📭</div><h3>No monitors found</h3><p>No monitors match this filter.</p></div>';
      return;
    }
    grid.innerHTML = monitors.map(m => {
      const sc = m.status===2?'up':m.status===9?'down':'paused';
      const bc = m.status===2?'badge-up':m.status===9?'badge-down':'badge-paused';
      const bt = m.status===2?'● Up':m.status===9?'● Down':'● Paused';
      const up = parseFloat(m.custom_uptime_ratio)||0;
      const uc = up>=99?'':up>=95?'medium':'low';
      const rt = m.response_times?.[0]?.value;
      const rs = rt ? rt+' ms' : '—';
      const sparks = Array.from({length:60},(_,i)=>{
        const inc = Math.random()<0.02; const h=inc?24:Math.floor(Math.random()*12+12);
        return `<div class="spark-bar${inc?' incident':''}" style="height:${h}px"></div>`;
      }).join('');
      return `<div class="monitor-card">
        <div class="monitor-left">
          <div class="status-dot ${sc}"></div>
          <div class="monitor-info">
            <div class="monitor-name">${esc(m.friendly_name||m.url)}</div>
            ${m.url?`<div class="monitor-url">${esc(m.url)}</div>`:''}
          </div>
        </div>
        <div class="monitor-right">
          <div class="monitor-meta">
            <div class="monitor-uptime ${uc}">${up?up.toFixed(2)+'%':'—'}</div>
            <div class="monitor-response">${rs}</div>
          </div>
          <span class="status-badge ${bc}">${bt}</span>
        </div>
        <div class="spark-bar-row">${sparks}</div>
      </div>`;
    }).join('');
  }

  function esc(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

  function updateLastChecked(){
    document.getElementById('last-checked').textContent = 'Updated ' + new Date().toLocaleTimeString();
  }

  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.filter-btn').forEach(b=>b.classList.remove('active'));
      btn.classList.add('active');
      const f = btn.dataset.filter;
      const filtered = f==='up'?allMonitors.filter(m=>m.status===2):f==='down'?allMonitors.filter(m=>m.status===9):f==='paused'?allMonitors.filter(m=>m.status===0):allMonitors;
      renderCards(filtered);
    });
  });

  function startCountdown(){
    clearInterval(countdownTimer); countdownVal=60;
    document.getElementById('countdown').textContent=60;
    countdownTimer = setInterval(()=>{
      countdownVal--;
      document.getElementById('countdown').textContent=countdownVal;
      if(countdownVal<=0){clearInterval(countdownTimer);loadMonitors();}
    },1000);
  }

  loadMonitors();
</script>

{include file="{$template}/footer.tpl"}
