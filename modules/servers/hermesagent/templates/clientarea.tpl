<style>
.ha-card {
    background: var(--card-bg, #fff);
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 12px;
    padding: 24px;
    margin-bottom: 20px;
}
.ha-card-title {
    font-size: 14px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: .08em;
    color: #CC0000;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
}
.ha-domain-row {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 0;
    border-bottom: 1px solid rgba(0,0,0,.06);
}
.ha-domain-row:last-child { border-bottom: none; }
.ha-domain-name {
    flex: 1;
    font-weight: 500;
    font-size: 14px;
    word-break: break-all;
}
.ha-domain-name a { color: inherit; text-decoration: none; }
.ha-domain-name a:hover { color: #CC0000; }
.ha-badge {
    font-size: 11px;
    font-weight: 600;
    padding: 2px 8px;
    border-radius: 20px;
    white-space: nowrap;
}
.ha-badge-active   { background: #d4edda; color: #155724; }
.ha-badge-pending  { background: #fff3cd; color: #856404; }
.ha-badge-default  { background: #e8e8e8; color: #555; font-size: 10px; }
.ha-badge-custom   { background: #cce5ff; color: #004085; }
.ha-btn {
    border: none;
    border-radius: 6px;
    padding: 6px 14px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: opacity .15s;
}
.ha-btn:hover { opacity: .85; }
.ha-btn-red    { background: #CC0000; color: #fff; }
.ha-btn-ghost  { background: transparent; color: #CC0000; border: 1px solid #CC0000; }
.ha-btn-danger { background: #f8d7da; color: #721c24; }
.ha-btn-sm     { padding: 4px 10px; font-size: 12px; }
.ha-btn-verify { background: #fff3cd; color: #856404; border: 1px solid #ffc107; }

.ha-tabs {
    display: flex;
    gap: 4px;
    margin-bottom: 16px;
    border-bottom: 2px solid #eee;
}
.ha-tab {
    padding: 8px 16px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    border: none;
    background: none;
    color: #888;
    border-bottom: 2px solid transparent;
    margin-bottom: -2px;
    transition: color .15s;
}
.ha-tab.active { color: #CC0000; border-bottom-color: #CC0000; }

.ha-form-group { margin-bottom: 14px; }
.ha-form-group label { display: block; font-size: 12px; font-weight: 600; margin-bottom: 5px; color: #555; }
.ha-input {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    box-sizing: border-box;
}
.ha-input:focus { outline: none; border-color: #CC0000; box-shadow: 0 0 0 3px rgba(204,0,0,.1); }
.ha-input-prefix {
    display: flex;
    align-items: center;
    border: 1px solid #ddd;
    border-radius: 6px;
    overflow: hidden;
}
.ha-input-prefix span {
    padding: 8px 10px;
    background: #f5f5f5;
    font-size: 13px;
    color: #666;
    white-space: nowrap;
    border-right: 1px solid #ddd;
}
.ha-input-prefix input {
    border: none;
    padding: 8px 12px;
    font-size: 14px;
    flex: 1;
    min-width: 0;
}
.ha-input-prefix input:focus { outline: none; }

.ha-dns-box {
    background: #f8f9fa;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 14px;
    font-family: monospace;
    font-size: 13px;
    margin: 12px 0;
}
.ha-dns-row { display: flex; gap: 16px; margin-bottom: 6px; }
.ha-dns-row:last-child { margin-bottom: 0; }
.ha-dns-label { color: #888; min-width: 60px; }
.ha-dns-value { font-weight: 600; color: #CC0000; }

.ha-alert {
    padding: 10px 14px;
    border-radius: 6px;
    font-size: 13px;
    margin-top: 10px;
    display: none;
}
.ha-alert-error   { background: #f8d7da; color: #721c24; }
.ha-alert-success { background: #d4edda; color: #155724; }

#ha-add-modal {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,.5);
    z-index: 9999;
    align-items: center;
    justify-content: center;
}
#ha-add-modal.open { display: flex; }
.ha-modal-box {
    background: #fff;
    border-radius: 12px;
    padding: 28px;
    width: 100%;
    max-width: 460px;
    margin: 16px;
    box-shadow: 0 20px 60px rgba(0,0,0,.2);
}
.ha-modal-title {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 20px;
    color: #CC0000;
}
.ha-modal-footer {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
    margin-top: 20px;
}
</style>

<div class="ha-card">
    <div class="ha-card-title">
        <i class="ti ti-world"></i> Domain Management
        <button class="ha-btn ha-btn-red" style="margin-left:auto;font-size:12px;padding:6px 14px" onclick="haOpenModal()">
            + Add Domain
        </button>
    </div>

    <div id="ha-domain-list">
        {foreach from=$domains item=d}
        <div class="ha-domain-row" id="ha-row-{$d->id}">
            <div class="ha-domain-name">
                {if $d->status === 'active'}
                    <a href="https://{$d->domain}" target="_blank">
                        <i class="ti ti-external-link" style="font-size:12px"></i> {$d->domain}
                    </a>
                {else}
                    {$d->domain}
                {/if}
            </div>

            {if $d->domain === $defaultDomain}
                <span class="ha-badge ha-badge-default">DEFAULT</span>
            {/if}
            {if $d->type === 'custom'}
                <span class="ha-badge ha-badge-custom">CUSTOM</span>
            {/if}

            {if $d->status === 'active'}
                <span class="ha-badge ha-badge-active">Active</span>
            {else}
                <span class="ha-badge ha-badge-pending">Pending DNS</span>
                <button class="ha-btn ha-btn-sm ha-btn-verify"
                        onclick="haVerify({$d->id}, '{$d->domain}', this)">
                    Verify DNS
                </button>
            {/if}

            {if $d->domain !== $defaultDomain}
                <button class="ha-btn ha-btn-sm ha-btn-danger"
                        onclick="haRemove({$d->id}, '{$d->domain}', this)">
                    Remove
                </button>
            {/if}
        </div>
        {foreachelse}
        <p style="color:#999;font-size:13px">No domains yet.</p>
        {/foreach}
    </div>
</div>

<!-- Add Domain Modal -->
<div id="ha-add-modal">
    <div class="ha-modal-box">
        <div class="ha-modal-title"><i class="ti ti-world-plus"></i> Add Domain</div>

        <div class="ha-tabs">
            <button class="ha-tab active" onclick="haSwitchTab('hermes', this)">
                Hermes Subdomain
            </button>
            <button class="ha-tab" onclick="haSwitchTab('custom', this)">
                Custom Domain
            </button>
        </div>

        <!-- Hermes subdomain tab -->
        <div id="ha-tab-hermes">
            <div class="ha-form-group">
                <label>Subdomain</label>
                <div class="ha-input-prefix">
                    <input type="text" id="ha-hermes-sub" placeholder="myapp" autocomplete="off">
                    <span>.hermes.deltadns.xyz</span>
                </div>
                <div style="font-size:11px;color:#999;margin-top:5px">
                    Instantly active — no DNS setup needed.
                </div>
            </div>
        </div>

        <!-- Custom domain tab -->
        <div id="ha-tab-custom" style="display:none">
            <div class="ha-form-group">
                <label>Your Domain</label>
                <input type="text" class="ha-input" id="ha-custom-domain" placeholder="app.yourdomain.com" autocomplete="off">
            </div>
            <div style="font-size:12px;color:#666;margin-bottom:8px">
                After adding, you'll see the DNS record to set. Activation happens once DNS propagates.
            </div>
        </div>

        <div id="ha-modal-alert" class="ha-alert"></div>

        <div class="ha-modal-footer">
            <button class="ha-btn ha-btn-ghost" onclick="haCloseModal()">Cancel</button>
            <button class="ha-btn ha-btn-red" id="ha-add-btn" onclick="haAddDomain()">Add Domain</button>
        </div>
    </div>
</div>

<!-- Pending DNS info shown inline after adding a custom domain -->
<div id="ha-dns-info" style="display:none" class="ha-card">
    <div class="ha-card-title"><i class="ti ti-info-circle"></i> DNS Setup Required</div>
    <p style="font-size:13px;margin-bottom:10px">
        Add the following A record to your domain's DNS, then click <strong>Verify DNS</strong> on the domain row above.
    </p>
    <div class="ha-dns-box">
        <div class="ha-dns-row">
            <span class="ha-dns-label">Type</span>
            <span class="ha-dns-value">A</span>
        </div>
        <div class="ha-dns-row">
            <span class="ha-dns-label">Name</span>
            <span class="ha-dns-value" id="ha-dns-name">@</span>
        </div>
        <div class="ha-dns-row">
            <span class="ha-dns-label">Value</span>
            <span class="ha-dns-value">{$serverIp}</span>
        </div>
        <div class="ha-dns-row">
            <span class="ha-dns-label">TTL</span>
            <span class="ha-dns-value">Auto</span>
        </div>
    </div>
</div>

<script>
(function() {
    var SID      = {$serviceId|intval};
    var AJAX_URL = '{$WHMCS.entrypoint}/modules/servers/hermesagent/ajax.php';
    var activeTab = 'hermes';

    window.haSwitchTab = function(tab, el) {
        activeTab = tab;
        document.querySelectorAll('.ha-tab').forEach(function(t) { t.classList.remove('active'); });
        el.classList.add('active');
        document.getElementById('ha-tab-hermes').style.display = tab === 'hermes' ? '' : 'none';
        document.getElementById('ha-tab-custom').style.display  = tab === 'custom'  ? '' : 'none';
        haModalAlert('', '');
    };

    window.haOpenModal = function() {
        document.getElementById('ha-add-modal').classList.add('open');
        document.getElementById('ha-hermes-sub').value = '';
        document.getElementById('ha-custom-domain').value = '';
        haModalAlert('', '');
    };
    window.haCloseModal = function() {
        document.getElementById('ha-add-modal').classList.remove('open');
    };

    function haModalAlert(type, msg) {
        var el = document.getElementById('ha-modal-alert');
        el.className = 'ha-alert' + (type ? ' ha-alert-' + type : '');
        el.textContent = msg;
        el.style.display = msg ? 'block' : 'none';
    }

    window.haAddDomain = function() {
        var btn = document.getElementById('ha-add-btn');
        var domain = '';

        if (activeTab === 'hermes') {
            var sub = document.getElementById('ha-hermes-sub').value.trim().toLowerCase();
            if (!sub) { haModalAlert('error', 'Enter a subdomain name.'); return; }
            if (!/^[a-z0-9][a-z0-9\-]*[a-z0-9]$/.test(sub) && !/^[a-z0-9]$/.test(sub)) {
                haModalAlert('error', 'Only lowercase letters, numbers, and hyphens allowed.'); return;
            }
            domain = sub + '.hermes.deltadns.xyz';
        } else {
            domain = document.getElementById('ha-custom-domain').value.trim().toLowerCase();
            if (!domain) { haModalAlert('error', 'Enter a domain name.'); return; }
        }

        btn.disabled = true;
        btn.textContent = 'Adding…';

        haPost({ action: 'add_domain', serviceId: SID, domain: domain, type: activeTab })
        .then(function(d) {
            if (!d.success) { haModalAlert('error', d.error || 'Failed'); btn.disabled = false; btn.textContent = 'Add Domain'; return; }

            haCloseModal();

            if (d.status === 'active') {
                haAppendRow(d.id || 0, d.domain, 'active', activeTab === 'custom' ? 'custom' : 'hermes');
            } else {
                // Pending custom domain — show DNS info card
                haAppendRow(0, d.domain, 'pending', 'custom');
                document.getElementById('ha-dns-name').textContent = d.domain;
                document.getElementById('ha-dns-info').style.display = 'block';
            }

            btn.disabled = false;
            btn.textContent = 'Add Domain';
        })
        .catch(function() {
            haModalAlert('error', 'Request failed. Try again.');
            btn.disabled = false;
            btn.textContent = 'Add Domain';
        });
    };

    window.haVerify = function(domainId, domain, btn) {
        btn.disabled = true;
        btn.textContent = 'Checking…';

        haPost({ action: 'verify_domain', serviceId: SID, domain: domain })
        .then(function(d) {
            if (!d.success) {
                alert('DNS check failed: ' + (d.error || 'Unknown error'));
                btn.disabled = false;
                btn.textContent = 'Verify DNS';
                return;
            }
            // Replace the row with an active one
            var row = document.getElementById('ha-row-' + domainId);
            if (row) {
                row.querySelector('.ha-badge-pending').className = 'ha-badge ha-badge-active';
                row.querySelector('.ha-badge-pending, .ha-badge-active').textContent = 'Active';
                btn.remove();
                // Make domain a link
                var nameEl = row.querySelector('.ha-domain-name');
                nameEl.innerHTML = '<a href="https://' + domain + '" target="_blank"><i class="ti ti-external-link" style="font-size:12px"></i> ' + domain + '</a>';
            }
            document.getElementById('ha-dns-info').style.display = 'none';
        })
        .catch(function() {
            alert('Request failed. Try again.');
            btn.disabled = false;
            btn.textContent = 'Verify DNS';
        });
    };

    window.haRemove = function(domainId, domain, btn) {
        if (!confirm('Remove ' + domain + '?\n\nThis will delete the Caddy config and the domain will stop working immediately.')) return;
        btn.disabled = true;

        haPost({ action: 'remove_domain', serviceId: SID, domain_id: domainId })
        .then(function(d) {
            if (!d.success) { alert('Error: ' + (d.error || 'Unknown')); btn.disabled = false; return; }
            var row = document.getElementById('ha-row-' + domainId);
            if (row) row.remove();
        })
        .catch(function() { alert('Request failed.'); btn.disabled = false; });
    };

    function haAppendRow(id, domain, status, type) {
        var list = document.getElementById('ha-domain-list');
        var noMsg = list.querySelector('p');
        if (noMsg) noMsg.remove();

        var row = document.createElement('div');
        row.className = 'ha-domain-row';
        row.id = 'ha-row-' + id;

        var nameHtml = status === 'active'
            ? '<a href="https://' + domain + '" target="_blank"><i class="ti ti-external-link" style="font-size:12px"></i> ' + domain + '</a>'
            : domain;

        var typeBadge = type === 'custom' ? '<span class="ha-badge ha-badge-custom">CUSTOM</span>' : '';
        var statusBadge = status === 'active'
            ? '<span class="ha-badge ha-badge-active">Active</span>'
            : '<span class="ha-badge ha-badge-pending">Pending DNS</span>';
        var verifyBtn = status !== 'active'
            ? '<button class="ha-btn ha-btn-sm ha-btn-verify" onclick="haVerify(' + id + ', \'' + domain + '\', this)">Verify DNS</button>'
            : '';
        var removeBtn = '<button class="ha-btn ha-btn-sm ha-btn-danger" onclick="haRemove(' + id + ', \'' + domain + '\', this)">Remove</button>';

        row.innerHTML = '<div class="ha-domain-name">' + nameHtml + '</div>' +
                        typeBadge + statusBadge + verifyBtn + removeBtn;
        list.appendChild(row);
    }

    function haPost(data) {
        var fd = new FormData();
        Object.keys(data).forEach(function(k) { fd.append(k, data[k]); });
        return fetch(AJAX_URL, { method: 'POST', body: fd }).then(function(r) { return r.json(); });
    }

    // Close modal on backdrop click
    document.getElementById('ha-add-modal').addEventListener('click', function(e) {
        if (e.target === this) haCloseModal();
    });
})();
</script>
