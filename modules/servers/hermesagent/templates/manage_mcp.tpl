<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
.mcp-wrap { font-family:'Outfit',sans-serif; color:#111827; margin:20px 0; }
.mcp-wrap::before { content:''; display:block; height:3px; background:#CC0000; border-radius:3px 3px 0 0; }
.mcp-wrap { background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:30px; box-shadow:0 4px 20px rgba(0,0,0,.05); }

.mcp-head { display:flex; align-items:center; justify-content:space-between; margin-bottom:25px; }
.mcp-head h2 { font-size:22px; font-weight:700; margin:0; display:flex; align-items:center; gap:10px; }
.mcp-head p  { font-size:13px; color:#6b7280; margin:4px 0 0; }

.mcp-section-title {
    font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.06em;
    color:#9ca3af; margin:0 0 12px; display:flex; align-items:center; gap:7px;
}

/* Installed chips */
.installed-list { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:28px; min-height:36px; }
.installed-chip {
    display:inline-flex; align-items:center; gap:8px;
    background:#ecfdf5; border:1px solid #6ee7b7; border-radius:100px;
    padding:5px 14px; font-size:13px; font-weight:600; color:#065f46;
}
.installed-chip .chip-remove {
    cursor:pointer; color:#10b981; margin-left:2px; font-size:11px;
    background:none; border:none; padding:0; line-height:1;
}
.installed-chip .chip-remove:hover { color:#dc2626; }
.empty-state { font-size:13px; color:#9ca3af; padding:8px 0; }

/* Catalog cards */
.catalog-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:16px; }
.mcp-card {
    border:1px solid #e5e7eb; border-radius:10px; overflow:hidden; transition:box-shadow .2s;
}
.mcp-card:hover { box-shadow:0 4px 12px rgba(0,0,0,.08); }
.mcp-card-top {
    padding:18px 20px 14px; display:flex; align-items:flex-start; gap:14px;
}
.mcp-card-icon {
    width:42px; height:42px; border-radius:9px; flex-shrink:0;
    display:flex; align-items:center; justify-content:center; font-size:22px;
}
.mcp-card-info { flex:1; }
.mcp-card-name { font-size:15px; font-weight:700; color:#111827; margin-bottom:3px; }
.mcp-card-desc { font-size:12px; color:#6b7280; line-height:1.5; }
.mcp-tag {
    display:inline-block; padding:2px 7px; border-radius:4px;
    font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:.05em;
    margin-right:4px; margin-top:5px;
}
.tag-http  { background:#dbeafe; color:#1e40af; }
.tag-stdio { background:#fef3c7; color:#92400e; }
.tag-oauth { background:#f3e8ff; color:#6b21a8; }
.tag-apikey{ background:#ecfdf5; color:#065f46; }

.mcp-card-actions { padding:0 20px 18px; }
.btn-mcp-install {
    width:100%; padding:9px; border-radius:7px; font-size:13px; font-weight:700;
    cursor:pointer; border:none; display:flex; align-items:center; justify-content:center; gap:7px;
    background:#CC0000; color:#fff; transition:background .15s;
}
.btn-mcp-install:hover { background:#aa0000; }
.btn-mcp-install.installed {
    background:#ecfdf5; color:#065f46; border:1px solid #6ee7b7; cursor:default;
}
.btn-mcp-install:disabled { background:#d1d5db; color:#6b7280; cursor:not-allowed; }

/* Config form */
.mcp-config-form {
    padding:16px 20px; border-top:1px solid #f3f4f6; background:#fafafa;
}
.mcp-field { margin-bottom:12px; }
.mcp-field label { display:block; font-size:12px; font-weight:700; color:#4b5563; margin-bottom:5px; }
.mcp-field input {
    width:100%; padding:9px 12px; border:1px solid #d1d5db; border-radius:7px;
    font-size:13px; font-family:'Fira Code',monospace; box-sizing:border-box; outline:none;
}
.mcp-field input:focus { border-color:#CC0000; box-shadow:0 0 0 3px rgba(204,0,0,.1); }
.mcp-field small { font-size:11px; color:#9ca3af; display:block; margin-top:3px; }
.btn-mcp-save {
    width:100%; padding:9px; border-radius:7px; font-size:13px; font-weight:700;
    cursor:pointer; border:none; background:#CC0000; color:#fff;
    display:flex; align-items:center; justify-content:center; gap:7px; margin-top:4px;
}
.btn-mcp-save:hover { background:#aa0000; }
.btn-mcp-save:disabled { background:#d1d5db; cursor:not-allowed; }
.mcp-feedback {
    margin-top:10px; padding:9px 12px; border-radius:7px; font-size:13px; font-weight:600;
    display:flex; align-items:center; gap:7px;
}
.mcp-feedback.success { background:#ecfdf5; color:#065f46; border:1px solid #a7f3d0; }
.mcp-feedback.error   { background:#fef2f2; color:#991b1b; border:1px solid #fecaca; }
.mcp-feedback.working { background:#eff6ff; color:#1d4ed8; border:1px solid #bfdbfe; }

.mcp-spinner {
    display:inline-block; width:13px; height:13px; flex-shrink:0;
    border:2px solid currentColor; border-top-color:transparent;
    border-radius:50%; animation:mcp-spin .6s linear infinite;
}
@keyframes mcp-spin { to { transform:rotate(360deg); } }
</style>

<div class="mcp-wrap">
    {if $deployment_status eq 'Suspended' or $deployment_status eq 'Terminated'}
    <div style="background:#fef2f2;padding:15px;border-radius:8px;border:1px solid #fecaca;margin-bottom:20px;font-weight:600;color:#991b1b;">
        <i class="fas fa-ban"></i> Account {$deployment_status} — MCP management is unavailable.
    </div>
    {/if}

    <div class="mcp-head">
        <div>
            <h2><i class="fas fa-puzzle-piece" style="color:#CC0000;"></i> MCP Servers</h2>
            <p>Connect your agent to external tools and APIs through the Model Context Protocol.</p>
        </div>
        <a href="clientarea.php?action=productdetails&id={$serviceid}" style="color:#6b7280;font-size:13px;font-weight:600;text-decoration:none;">
            <i class="fas fa-arrow-left"></i> Back
        </a>
    </div>

    {if $error}
    <div style="background:#fef2f2;padding:12px 16px;border-radius:8px;border:1px solid #fecaca;font-size:13px;color:#991b1b;margin-bottom:20px;">
        <i class="fas fa-exclamation-triangle"></i> Could not read agent config: {$error}
    </div>
    {/if}

    <!-- Installed -->
    <p class="mcp-section-title"><i class="fas fa-check-circle" style="color:#10b981;"></i> Installed</p>
    <div class="installed-list" id="installed-list">
        {if count($installed) > 0}
            {foreach $installed as $srv}
            <span class="installed-chip" id="chip-{$srv}">
                <i class="fas fa-circle" style="font-size:7px;color:#10b981;"></i> {$srv}
                <button class="chip-remove" onclick="removeMcp('{$srv}')" title="Remove">✕</button>
            </span>
            {/foreach}
        {else}
            <span class="empty-state" id="empty-msg">No MCP servers installed yet.</span>
        {/if}
    </div>

    <!-- Catalog -->
    <p class="mcp-section-title"><i class="fas fa-store"></i> Catalog</p>
    <div class="catalog-grid">

        <!-- n8n -->
        <div class="mcp-card" id="card-n8n">
            <div class="mcp-card-top">
                <div class="mcp-card-icon" style="background:#fef9e7;">
                    <img src="https://n8n.io/favicon.ico" style="width:26px;height:26px;" onerror="this.style.display='none';this.parentNode.innerHTML='<i class=\'fas fa-project-diagram\' style=\'color:#ff6d00\'></i>'">
                </div>
                <div class="mcp-card-info">
                    <div class="mcp-card-name">n8n</div>
                    <div class="mcp-card-desc">Manage and trigger n8n workflows directly from your agent.</div>
                    <span class="mcp-tag tag-stdio">stdio</span>
                    <span class="mcp-tag tag-apikey">api key</span>
                </div>
            </div>
            <div class="mcp-card-actions">
                <button class="btn-mcp-install" id="btn-n8n" onclick="toggleMcpForm('n8n')">
                    <i class="fas fa-download"></i> Install
                </button>
            </div>
            <div class="mcp-config-form" id="form-n8n" style="display:none;">
                <div class="mcp-field">
                    <label>n8n Base URL</label>
                    <input type="url" id="n8n-N8N_BASE_URL" placeholder="https://your-n8n.example.com">
                    <small>The root URL of your n8n instance (no trailing slash).</small>
                </div>
                <div class="mcp-field">
                    <label>n8n API Key</label>
                    <input type="password" id="n8n-N8N_API_KEY" placeholder="n8n_api_...">
                    <small>Settings → API → Create API key inside n8n.</small>
                </div>
                <div id="fb-n8n" style="display:none;" class="mcp-feedback"></div>
                <button class="btn-mcp-save" id="save-n8n" onclick="installMcp('n8n',['N8N_BASE_URL','N8N_API_KEY'])">
                    <i class="fas fa-plug"></i> Connect & Install
                </button>
            </div>
        </div>

        <!-- Linear -->
        <div class="mcp-card" id="card-linear">
            <div class="mcp-card-top">
                <div class="mcp-card-icon" style="background:#f0f0ff;">
                    <i class="fas fa-tasks" style="color:#5e6ad2;font-size:20px;"></i>
                </div>
                <div class="mcp-card-info">
                    <div class="mcp-card-name">Linear</div>
                    <div class="mcp-card-desc">Find, create, and update Linear issues, projects, and comments.</div>
                    <span class="mcp-tag tag-http">http</span>
                    <span class="mcp-tag tag-apikey">api key</span>
                </div>
            </div>
            <div class="mcp-card-actions">
                <button class="btn-mcp-install" id="btn-linear" onclick="toggleMcpForm('linear')">
                    <i class="fas fa-download"></i> Install
                </button>
            </div>
            <div class="mcp-config-form" id="form-linear" style="display:none;">
                <div class="mcp-field">
                    <label>Linear API Key</label>
                    <input type="password" id="linear-LINEAR_API_KEY" placeholder="lin_api_...">
                    <small>Settings → API → Personal API keys in Linear.</small>
                </div>
                <div id="fb-linear" style="display:none;" class="mcp-feedback"></div>
                <button class="btn-mcp-save" id="save-linear" onclick="installMcp('linear',['LINEAR_API_KEY'])">
                    <i class="fas fa-plug"></i> Connect & Install
                </button>
            </div>
        </div>

    </div>
</div>

<script>
var _mcpSvcId  = {$serviceid};
var _mcpAjax   = 'modules/servers/hermesagent/ajax.php';
var _installed = {json_encode($installed)};

// Mark already-installed cards on load
_installed.forEach(function(s) { markInstalled(s); });

function toggleMcpForm(server) {
    var form = document.getElementById('form-' + server);
    form.style.display = form.style.display === 'none' ? 'block' : 'none';
}

function markInstalled(server) {
    var btn = document.getElementById('btn-' + server);
    if (!btn) return;
    btn.className = 'btn-mcp-install installed';
    btn.innerHTML = '<i class="fas fa-check-circle"></i> Installed';
    btn.onclick = null;
    var form = document.getElementById('form-' + server);
    if (form) form.style.display = 'none';
}

function addInstalledChip(server) {
    var list = document.getElementById('installed-list');
    var empty = document.getElementById('empty-msg');
    if (empty) empty.remove();
    if (!document.getElementById('chip-' + server)) {
        var chip = document.createElement('span');
        chip.className = 'installed-chip';
        chip.id = 'chip-' + server;
        chip.innerHTML = '<i class="fas fa-circle" style="font-size:7px;color:#10b981;"></i> ' + server
            + ' <button class="chip-remove" onclick="removeMcp(\'' + server + '\')" title="Remove">✕</button>';
        list.appendChild(chip);
    }
}

function installMcp(server, fields) {
    var btnEl    = document.getElementById('save-' + server);
    var feedback = document.getElementById('fb-' + server);

    // Collect values
    var fd = new FormData();
    fd.append('action', 'install_mcp');
    fd.append('serviceId', _mcpSvcId);
    fd.append('mcp_server', server);
    var valid = true;
    fields.forEach(function(f) {
        var el = document.getElementById(server + '-' + f);
        if (!el || !el.value.trim()) { el && el.focus(); valid = false; }
        else fd.append(f, el.value.trim());
    });
    if (!valid) return;

    btnEl.disabled = true;
    btnEl.innerHTML = '<span class="mcp-spinner"></span> Installing...';
    feedback.className = 'mcp-feedback working';
    feedback.innerHTML = '<span class="mcp-spinner"></span> Cloning repo &amp; installing dependencies inside your agent — this may take ~30s...';
    feedback.style.display = 'flex';

    fetch(_mcpAjax, { method:'POST', body:fd })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            btnEl.disabled = false;
            btnEl.innerHTML = '<i class="fas fa-plug"></i> Connect & Install';
            if (data.success) {
                feedback.className = 'mcp-feedback success';
                feedback.innerHTML = '<i class="fas fa-check-circle"></i> Installed! Your agent is restarting with the new MCP server.';
                markInstalled(server);
                addInstalledChip(server);
            } else {
                feedback.className = 'mcp-feedback error';
                feedback.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + (data.error || 'Install failed');
            }
        })
        .catch(function() {
            btnEl.disabled = false;
            btnEl.innerHTML = '<i class="fas fa-plug"></i> Connect & Install';
            feedback.className = 'mcp-feedback error';
            feedback.innerHTML = '<i class="fas fa-exclamation-circle"></i> Network error.';
        });
}

function removeMcp(server) {
    if (!confirm('Remove ' + server + ' MCP server and restart the agent?')) return;
    var chip = document.getElementById('chip-' + server);
    if (chip) chip.style.opacity = '.4';

    var fd = new FormData();
    fd.append('action', 'remove_mcp');
    fd.append('serviceId', _mcpSvcId);
    fd.append('mcp_server', server);

    fetch(_mcpAjax, { method:'POST', body:fd })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                if (chip) chip.remove();
                var list = document.getElementById('installed-list');
                if (!list.querySelector('.installed-chip')) {
                    list.innerHTML = '<span class="empty-state" id="empty-msg">No MCP servers installed yet.</span>';
                }
                // Re-enable install button
                var btn = document.getElementById('btn-' + server);
                if (btn) {
                    btn.className = 'btn-mcp-install';
                    btn.innerHTML = '<i class="fas fa-download"></i> Install';
                    btn.onclick = function() { toggleMcpForm(server); };
                }
            } else {
                if (chip) chip.style.opacity = '1';
                alert('Remove failed: ' + (data.error || 'Unknown error'));
            }
        })
        .catch(function() { if (chip) chip.style.opacity = '1'; });
}
</script>
