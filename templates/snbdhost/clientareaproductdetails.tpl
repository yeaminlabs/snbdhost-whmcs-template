{if $modulecustombuttonresult}
    {if $modulecustombuttonresult == "success"}
        <div class="alert alert-success alert-dismissible fade show mb-4" role="alert" id="alertModuleCustomButtonSuccess">
            <i class="ti ti-circle-check-filled me-2" style="font-size: 1.25rem;"></i> {lang key='moduleactionsuccess'}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    {else}
        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert" id="alertModuleCustomButtonFailed">
            <i class="ti ti-circle-x-filled me-2" style="font-size: 1.25rem;"></i> {lang key='moduleactionfailed'}: {$modulecustombuttonresult}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    {/if}
{/if}

{if $pendingcancellation}
    <div class="alert alert-warning d-flex align-items-center mb-4" role="alert" id="alertPendingCancellation">
        <i class="ti ti-alert-triangle-filled me-2" style="font-size: 1.25rem;"></i> {lang key='cancellationrequestedexplanation'}
    </div>
{/if}

{if $unpaidInvoice}
    <div class="alert alert-danger d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2" role="alert" id="alertUnpaidInvoice">
        <div class="d-flex align-items-center">
            <i class="ti ti-clock-filled me-2" style="font-size: 1.25rem;"></i>
            <span>{$unpaidInvoiceMessage}</span>
        </div>
        <a href="viewinvoice.php?id={$unpaidInvoice}" class="btn btn-sm btn-light text-danger fw-bold px-3 py-1.5" style="border-radius: 8px;">
            {lang key='payInvoice'}
        </a>
    </div>
{/if}

<!-- Scope styles -->
<style>
.nav-pills-snbd {
    background: var(--bg-elevated, #fafafa);
    border-radius: 14px;
    padding: 0.35rem;
    border: 1px solid var(--border-color, #e0e0e0);
}
.nav-pills-snbd .nav-link {
    color: var(--text-secondary, #555555) !important;
    background: transparent !important;
    font-size: 0.85rem !important;
    font-weight: 600 !important;
    border-radius: 10px !important;
    padding: 0.55rem 1.25rem !important;
    transition: all 0.2s ease !important;
    border: none !important;
}
.nav-pills-snbd .nav-link:hover {
    color: var(--brand-primary, #E05052) !important;
    background: var(--brand-light, rgba(224, 80, 82, 0.08)) !important;
}
.nav-pills-snbd .nav-link.active {
    color: var(--text-on-brand, #ffffff) !important;
    background: var(--brand-primary, #E05052) !important;
    box-shadow: 0 4px 12px rgba(224, 80, 82, 0.2) !important;
}

.module-clientarea-wrap {
    width: 100%;
}
.module-clientarea-wrap .card, 
.module-clientarea-wrap .panel {
    background: var(--bg-surface, #ffffff) !important;
    border: 1px solid rgba(204, 0, 0, 0.12) !important;
    border-radius: 16px !important;
    box-shadow: 0 6px 18px rgba(204, 0, 0, 0.05) !important;
    margin-bottom: 1.5rem !important;
    overflow: hidden !important;
    transition: all 0.25s ease;
}
.module-clientarea-wrap .card:hover, 
.module-clientarea-wrap .panel:hover {
    box-shadow: 0 10px 25px rgba(204, 0, 0, 0.08) !important;
    border-color: rgba(204, 0, 0, 0.2) !important;
}
.module-clientarea-wrap .card-header, 
.module-clientarea-wrap .panel-heading {
    background: linear-gradient(to right, rgba(204, 0, 0, 0.02), transparent) !important;
    border-bottom: 1px solid rgba(204, 0, 0, 0.08) !important;
    padding: 1.25rem 1.5rem !important;
    font-weight: 700 !important;
    font-size: 1.05rem !important;
    color: #CC0000 !important;
}
.module-clientarea-wrap .card-header i, 
.module-clientarea-wrap .panel-heading i {
    color: #CC0000 !important;
}
.module-clientarea-wrap .card-body,
.module-clientarea-wrap .panel-body {
    padding: 1.5rem !important;
}
.module-clientarea-wrap table {
    width: 100% !important;
}
</style>

<!-- Services Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <div class="d-flex align-items-center gap-2 mb-1">
            <h1 class="dash-headline mb-0" style="font-size: 2rem; font-weight: 800;">
                Manage <span class="dash-headline-accent">{$product}</span>
            </h1>
            {if $status eq "Active"}
                <span class="badge bg-success">Active</span>
            {elseif $status eq "Pending"}
                <span class="badge bg-warning text-dark">Pending</span>
            {elseif $status eq "Suspended"}
                <span class="badge bg-danger">Suspended</span>
            {else}
                <span class="badge bg-secondary">{$status}</span>
            {/if}
        </div>
        <p class="text-secondary small mb-0">
            {$groupname} {if $domain} — <a href="http://{$domain}" target="_blank" class="text-danger fw-bold text-decoration-none">{$domain} <i class="ti ti-external-link"></i></a>{/if}
        </p>
    </div>
    
    <div class="d-flex align-items-center gap-2">
        {if $packagesupgrade}
            <a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-brand-clean btn-sm d-inline-flex align-items-center gap-1" style="font-weight: 600;">
                <i class="ti ti-arrow-up-circle"></i> Upgrade Plan
            </a>
        {/if}
        <a href="clientarea.php?action=products" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1" style="font-weight: 600;">
            <i class="ti ti-arrow-left"></i> Back to Services
        </a>
    </div>
</div>

<!-- Navigation Tabs -->
<ul class="nav nav-pills nav-pills-snbd mb-4 d-inline-flex gap-1" id="productDetailsTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#tabOverview" type="button" role="tab" aria-controls="tabOverview" aria-selected="true">
            <i class="ti ti-layout-dashboard me-1"></i> Overview
        </button>
    </li>
    {if $modulechangepassword}
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#tabPassword" type="button" role="tab" aria-controls="tabPassword" aria-selected="false">
                <i class="ti ti-lock me-1"></i> Change Password
            </button>
        </li>
    {/if}
    {if $downloads}
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="downloads-tab" data-bs-toggle="tab" data-bs-target="#tabDownloads" type="button" role="tab" aria-controls="tabDownloads" aria-selected="false">
                <i class="ti ti-download me-1"></i> Downloads
            </button>
        </li>
    {/if}
    {if $addons}
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="addons-tab" data-bs-toggle="tab" data-bs-target="#tabAddons" type="button" role="tab" aria-controls="tabAddons" aria-selected="false">
                <i class="ti ti-puzzle me-1"></i> Addons ({$addons|count})
            </button>
        </li>
    {/if}
</ul>

<!-- Tab Contents -->
<div class="tab-content">
    
    <!-- OVERVIEW TAB -->
    <div class="tab-pane fade show active" id="tabOverview" role="tabpanel" aria-labelledby="overview-tab">
        
        <!-- Clean Service Overview Card for All Services -->
        <div class="card dash-card-clean border-0 mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid rgba(204,0,0,0.12) !important; box-shadow: 0 6px 18px rgba(204,0,0,0.05);">
            <div class="card-header py-3 px-4" style="background: linear-gradient(to right, rgba(204,0,0,0.02), transparent); border-bottom: 1px solid rgba(204,0,0,0.08);">
                <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                    <i class="ti ti-info-circle text-danger"></i> Service Overview
                </span>
            </div>
            <div class="card-body p-4">
                <div class="row g-3 mb-3">
                    <div class="col-md-6 col-lg-4">
                        <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                            <div class="small text-muted fw-semibold">Registration Date</div>
                            <div class="fw-bold text-dark mt-1">{$regdate}</div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                            <div class="small text-muted fw-semibold">Recurring Amount</div>
                            <div class="fw-bold text-danger mt-1">{$amount}</div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                            <div class="small text-muted fw-semibold">Billing Cycle</div>
                            <div class="fw-bold text-dark mt-1">{$billingcycle}</div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                            <div class="small text-muted fw-semibold">Next Due Date</div>
                            <div class="fw-bold text-dark mt-1">{$nextduedate}</div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4">
                        <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                            <div class="small text-muted fw-semibold">Payment Method</div>
                            <div class="fw-bold text-dark mt-1">{$paymentmethod}</div>
                        </div>
                    </div>
                    {if $domain}
                        <div class="col-md-6 col-lg-4">
                            <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                                <div class="small text-muted fw-semibold">Domain / Hostname</div>
                                <div class="fw-bold text-dark mt-1 text-truncate">{$domain}</div>
                            </div>
                        </div>
                    {/if}
                </div>
                
                <div class="pt-3 d-flex gap-2 flex-wrap" style="border-top: 1px solid var(--border-color, #e0e0e0);">
                    {if $packagesupgrade}
                        <a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-outline-secondary btn-sm py-2 px-3 fw-semibold" style="border-radius: 8px;">
                            <i class="ti ti-arrow-up-circle me-1"></i> Upgrade / Downgrade Plan
                        </a>
                    {/if}
                    {if $showcancelbutton}
                        <a href="clientarea.php?action=cancel&amp;id={$id}" class="btn btn-outline-danger btn-sm py-2 px-3 fw-semibold {if $pendingcancellation}disabled{/if}" style="border-radius: 8px;">
                            <i class="ti ti-ban me-1"></i> Request Cancellation
                        </a>
                    {/if}
                </div>
            </div>
        </div>



        <!-- Native Module Information & Control Output -->
        {if $tplOverviewTabOutput}
            <div class="module-clientarea-wrap mb-4" id="moduleClientAreaWrap">
                {$tplOverviewTabOutput}
            </div>
        {elseif $moduleclientarea}
            <div class="module-clientarea-wrap mb-4" id="moduleClientAreaWrap">
                {$moduleclientarea}
            </div>
        {/if}

        <script>
        document.addEventListener("DOMContentLoaded", function() {
            var wrap = document.getElementById("moduleClientAreaWrap");
            if (!wrap) return;
            
            var pageText = (document.body ? document.body.innerText : "").toLowerCase();
            var pageUrl = window.location.href.toLowerCase();
            var html = wrap.innerHTML;

            // Immediately abort for OpenClaw or non-n8n products
            if (pageUrl.indexOf("openclaw") !== -1 || pageText.indexOf("openclaw") !== -1 || html.toLowerCase().indexOf("openclaw") !== -1) {
                return;
            }

            if (pageUrl.indexOf("hermes") !== -1 || pageText.indexOf("hermes") !== -1 || html.toLowerCase().indexOf("hermes") !== -1) {
                return;
            }

            // Strict check for n8n dockern8n module / dashboard signatures
            var isStrictN8n = (
                html.indexOf("dockern8n") !== -1 ||
                html.indexOf("dockern8n/ajax.php") !== -1 ||
                html.indexOf("n8n-modern-dashboard") !== -1 ||
                (html.indexOf("n8n") !== -1 && (html.indexOf("Workflow") !== -1 || html.indexOf("v2.31") !== -1))
            );

            if (!isStrictN8n) {
                return;
            }
            
            if (document.getElementById("n8n-modern-dashboard")) return;
            
            // Hide raw dockern8n HTML
            var hiddenDiv = document.createElement("div");
            hiddenDiv.id = "n8n-original-module-data";
            hiddenDiv.style.cssText = "display:none !important;";
            hiddenDiv.innerHTML = html;
            
            wrap.innerHTML = "";
            wrap.appendChild(hiddenDiv);
            
            // Parse values from raw HTML
            var tmp = document.createElement("div");
            tmp.innerHTML = html;
            
            var extLink = tmp.querySelector("a[href*='n8n']") || tmp.querySelector("a[target='_blank'][href*='http']");
            var domainEl = tmp.querySelector("#service-domain");
            var versionEl = tmp.querySelector("#service-version");
            
            var instanceUrl = extLink ? extLink.href : (domainEl && domainEl.textContent ? domainEl.textContent.trim() : "");
            if (instanceUrl && !instanceUrl.startsWith("http")) instanceUrl = "https://" + instanceUrl;
            
            var version = (versionEl && versionEl.textContent.trim()) ? versionEl.textContent.trim() : "v2.31.6";
            
            // Build modern dashboard HTML
            var dash = document.createElement("div");
            dash.id = "n8n-modern-dashboard";
            dash.className = "n8n-modern-dashboard";
            dash.innerHTML = `
                <style>
                    .n8n-header-card {
                        background: linear-gradient(135deg, #180808 0%, #2a0b0b 50%, #150606 100%);
                        border: 1px solid rgba(239, 68, 68, 0.25);
                        border-radius: 20px;
                        padding: 1.75rem 2rem;
                        color: #ffffff;
                        box-shadow: 0 12px 35px rgba(204, 0, 0, 0.15);
                        margin-bottom: 1.5rem;
                    }
                    .n8n-card {
                        background: #ffffff;
                        border-radius: 20px;
                        border: 1px solid rgba(204, 0, 0, 0.12);
                        padding: 1.75rem;
                        box-shadow: 0 6px 24px rgba(204, 0, 0, 0.04);
                        margin-bottom: 1.5rem;
                        transition: all 0.3s ease;
                    }
                    .n8n-card:hover {
                        box-shadow: 0 12px 35px rgba(204, 0, 0, 0.08);
                        border-color: rgba(204, 0, 0, 0.25);
                    }
                    .n8n-progress-bar {
                        height: 10px;
                        background: #f1f3f5;
                        border-radius: 10px;
                        overflow: hidden;
                        display: flex;
                    }
                    .n8n-status-pill {
                        padding: 6px 14px;
                        border-radius: 50rem;
                        font-size: 0.78rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        background: rgba(16, 185, 129, 0.12);
                        color: #10B981;
                        border: 1px solid rgba(16, 185, 129, 0.25);
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                    }
                    .n8n-status-pill::before {
                        content: "";
                        width: 8px;
                        height: 8px;
                        border-radius: 50%;
                        background: #10B981;
                        box-shadow: 0 0 8px #10B981;
                    }
                    .btn-n8n-accent {
                        background: linear-gradient(135deg, #CC0000 0%, #990000 100%) !important;
                        color: #ffffff !important;
                        border: none !important;
                        border-radius: 12px !important;
                        font-weight: 700 !important;
                        padding: 0.7rem 1.6rem !important;
                        transition: all 0.25s ease !important;
                        box-shadow: 0 6px 20px rgba(204,0,0,0.35) !important;
                        display: inline-flex !important;
                        align-items: center !important;
                        justify-content: center !important;
                        text-decoration: none !important;
                    }
                    .btn-n8n-accent:hover {
                        transform: translateY(-2px) !important;
                        box-shadow: 0 10px 28px rgba(204,0,0,0.45) !important;
                        color: #ffffff !important;
                    }
                    .n8n-info-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
                        gap: 1rem;
                    }
                    .n8n-info-item {
                        background: #fffafa;
                        padding: 1.1rem;
                        border-radius: 14px;
                        border: 1px solid rgba(204,0,0,0.08);
                    }
                    .n8n-info-label {
                        font-size: 0.72rem;
                        color: #777;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        margin-bottom: 4px;
                    }
                    .n8n-info-value {
                        font-size: 0.98rem;
                        font-weight: 800;
                        color: #1a1a1a;
                    }
                </style>

                <!-- Top Header Card -->
                <div class="n8n-header-card d-flex align-items-center justify-content-between flex-wrap gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <div style="background: rgba(255,255,255,0.12); padding: 12px; border-radius: 16px;">
                            <svg width="34" height="34" viewBox="0 0 24 24" fill="none"><path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="#FF6D5A" stroke-width="2"/><path d="M2 17L12 22L22 17" stroke="#FF6D5A" stroke-width="2"/><path d="M2 12L12 17L22 12" stroke="#FF6D5A" stroke-width="2"/></svg>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <h4 class="fw-bold text-white mb-0" style="font-size: 1.35rem;">n8n Workflow Automation</h4>
                                <span class="n8n-status-pill" id="n8n-val-status">Running</span>
                            </div>
                            <p class="text-white-50 mb-0 small" id="n8n-val-url-subtitle"><i class="ti ti-link me-1"></i>` + (instanceUrl ? instanceUrl : 'Secured Cloud Instance') + `</p>
                        </div>
                    </div>
                    <div>
                        <a href="` + (instanceUrl ? instanceUrl : '#') + `" target="_blank" class="btn btn-n8n-accent">
                            <i class="ti ti-external-link me-2"></i> Launch n8n Dashboard
                        </a>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-lg-6">
                        <div class="n8n-card h-100">
                            <h5 class="fw-bold mb-4 text-dark d-flex align-items-center gap-2"><i class="ti ti-activity text-danger" style="font-size: 1.3rem;"></i> Live Server Resources</h5>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between small fw-bold text-secondary mb-1">
                                    <span><i class="ti ti-cpu me-1 text-danger"></i> CPU Utilization</span>
                                    <span id="n8n-val-cpu-text">N/A</span>
                                </div>
                                <div class="n8n-progress-bar"><div id="n8n-bar-cpu" style="width:0%; background: linear-gradient(90deg, #10B981, #059669);"></div></div>
                            </div>
                            <div class="mb-3">
                                <div class="d-flex justify-content-between small fw-bold text-secondary mb-1">
                                    <span><i class="ti ti-device-sd-micro me-1 text-danger"></i> Memory (RAM) Usage</span>
                                    <span id="n8n-val-mem-text">N/A</span>
                                </div>
                                <div class="n8n-progress-bar"><div id="n8n-bar-mem" style="width:0%; background: linear-gradient(90deg, #EF4444, #DC2626);"></div></div>
                            </div>
                            <div class="mb-0">
                                <div class="d-flex justify-content-between small fw-bold text-secondary mb-1">
                                    <span><i class="ti ti-database me-1 text-danger"></i> Storage (Disk) Usage</span>
                                    <span id="n8n-val-disk-text">N/A</span>
                                </div>
                                <div class="n8n-progress-bar"><div id="n8n-bar-disk" style="width:0%; background: linear-gradient(90deg, #10B981, #059669);"></div></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="n8n-card h-100 d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="fw-bold mb-4 text-dark pb-2 border-bottom d-flex align-items-center gap-2"><i class="ti ti-server-2 text-danger" style="font-size: 1.3rem;"></i> Instance Configuration</h5>
                                <div class="n8n-info-grid">
                                    <div class="n8n-info-item">
                                        <div class="n8n-info-label">n8n Version</div>
                                        <div class="n8n-info-value text-danger" id="n8n-val-version">` + version + `</div>
                                    </div>
                                    <div class="n8n-info-item">
                                        <div class="n8n-info-label">CPU Cores</div>
                                        <div class="n8n-info-value" id="n8n-val-owner">1 CPU</div>
                                    </div>
                                    <div class="n8n-info-item">
                                        <div class="n8n-info-label">Memory Allocated</div>
                                        <div class="n8n-info-value" id="n8n-val-users">1 GiB</div>
                                    </div>
                                    <div class="n8n-info-item">
                                        <div class="n8n-info-label">Access Protocol</div>
                                        <div class="n8n-info-value text-success">HTTPS Secured</div>
                                    </div>
                                </div>
                            </div>
                            <div class="pt-3 border-top d-flex justify-content-end gap-2 mt-4">
                                <button class="btn btn-n8n-accent" id="n8n-btn-reset-pw"><i class="ti ti-key me-2"></i> Reset Owner Password</button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            wrap.appendChild(dash);
            
            // Fetch live data via AJAX endpoint
            var mId = window.location.href.match(/[?&]id=(\d+)/i);
            var serviceId = mId ? mId[1] : null;
            if (serviceId) {
                fetch("modules/servers/dockern8n/ajax.php?action=getAllData&serviceId=" + serviceId)
                .then(function(r){ return r.json(); })
                .then(function(data){
                    if (data.status && data.status.status) {
                        var badge = document.getElementById("n8n-val-status");
                        if (badge) badge.innerText = data.status.status.toUpperCase();
                    }
                    var rs = data.resourcestats;
                    if (rs && rs.success) {
                        if (rs.cpu) {
                            document.getElementById("n8n-val-cpu-text").innerText = rs.cpu;
                            var cpuPct = parseFloat(rs.cpu);
                            if (!isNaN(cpuPct)) document.getElementById("n8n-bar-cpu").style.width = Math.min(cpuPct, 100) + "%";
                        }
                        if (rs.memory) {
                            document.getElementById("n8n-val-mem-text").innerText = rs.memory;
                            var memM = rs.memory.match(/([\d.]+)\s*(\w+)\s*\/\s*([\d.]+)\s*(\w+)/);
                            if (memM) {
                                var used = parseFloat(memM[1]), limit = parseFloat(memM[3]);
                                if (limit > 0) document.getElementById("n8n-bar-mem").style.width = Math.min((used/limit)*100, 100) + "%";
                            }
                        }
                        if (rs.storage) {
                            var diskStr = typeof rs.storage === "object" ? (rs.storage.used + " / " + rs.storage.total) : rs.storage;
                            document.getElementById("n8n-val-disk-text").innerText = diskStr;
                            if (typeof rs.storage === "object" && rs.storage.percent) {
                                document.getElementById("n8n-bar-disk").style.width = Math.min(parseFloat(rs.storage.percent), 100) + "%";
                            }
                        }
                    }
                }).catch(function(){});
            }

            var btnPw = document.getElementById("n8n-btn-reset-pw");
            if (btnPw) {
                btnPw.addEventListener("click", function(e) {
                    e.preventDefault();
                    if (!serviceId) return;
                    if (!confirm("Reset your n8n owner password?")) return;
                    btnPw.disabled = true;
                    btnPw.innerHTML = '<i class="ti ti-loader-2 ti-spin me-2"></i> Resetting...';
                    fetch("modules/servers/dockern8n/ajax.php?action=resetPassword&serviceId=" + serviceId)
                    .then(function(r){ return r.json(); })
                    .then(function(d){
                        btnPw.disabled = false;
                        btnPw.innerHTML = '<i class="ti ti-key me-2"></i> Reset Owner Password';
                        if (d.success) alert("New password generated: " + (d.password || "Check your email"));
                        else alert("Failed: " + (d.message || "Unknown error"));
                    }).catch(function(){
                        btnPw.disabled = false;
                        btnPw.innerHTML = '<i class="ti ti-key me-2"></i> Reset Owner Password';
                    });
                });
            }
        });
        </script>
    </div>
    
    <!-- CHANGE PASSWORD TAB -->
    {if $modulechangepassword}
        <div class="tab-pane fade" id="tabPassword" role="tabpanel" aria-labelledby="password-tab">
            <div class="card dash-card-clean border-0 mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid rgba(204,0,0,0.12) !important; box-shadow: 0 6px 18px rgba(204,0,0,0.05);">
                <div class="card-header py-3 px-4" style="background: linear-gradient(to right, rgba(204,0,0,0.02), transparent); border-bottom: 1px solid rgba(204,0,0,0.08);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-key text-danger"></i> Change Password
                    </span>
                </div>
                <div class="card-body p-4" style="max-width: 600px;">
                    <form class="using-password-strength" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails#tabPassword">
                        <input type="hidden" name="id" value="{$id}" />
                        <input type="hidden" name="modulechangepassword" value="true" />
                        
                        {if $username}
                            <div class="mb-4 row align-items-center">
                                <label class="col-sm-4 col-form-label fw-bold text-muted">Username</label>
                                <div class="col-sm-8">
                                    <input type="text" readonly class="form-control-plaintext text-dark fw-bold" value="{$username}" style="font-size: 1.05rem;">
                                </div>
                            </div>
                        {/if}
                        
                        <div class="mb-3 row">
                            <label for="inputNewPassword1" class="col-sm-4 col-form-label fw-semibold text-muted">New Password</label>
                            <div class="col-sm-8">
                                <input type="password" class="form-control py-2" id="inputNewPassword1" name="newpw" autocomplete="off" placeholder="Enter new password" style="border-radius: 8px;" />
                            </div>
                        </div>
                        
                        <div class="mb-4 row">
                            <label for="inputNewPassword2" class="col-sm-4 col-form-label fw-semibold text-muted">Confirm Password</label>
                            <div class="col-sm-8">
                                <input type="password" class="form-control py-2" id="inputNewPassword2" name="confirmpw" autocomplete="off" placeholder="Confirm new password" style="border-radius: 8px;" />
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-sm-8 offset-sm-4">
                                <button type="submit" class="btn btn-brand-clean px-4 py-2" style="border-radius: 10px !important; font-weight: 700;">
                                    Save Changes
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    {/if}
    
    <!-- DOWNLOADS TAB -->
    {if $downloads}
        <div class="tab-pane fade" id="tabDownloads" role="tabpanel" aria-labelledby="downloads-tab">
            <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-download text-danger"></i> Downloads
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr class="table-light">
                                    <th>File / Title</th>
                                    <th>Description</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$downloads item=download}
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark" style="font-size: 0.95rem;">{$download.title}</div>
                                        </td>
                                        <td class="text-muted small">{$download.description}</td>
                                        <td class="text-end">
                                            <a href="{$download.link}" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                                <i class="ti ti-download me-1"></i> Download
                                            </a>
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    {/if}
    
    <!-- ADDONS TAB -->
    {if $addons}
        <div class="tab-pane fade" id="tabAddons" role="tabpanel" aria-labelledby="addons-tab">
            <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-puzzle text-danger"></i> Addons &amp; Extras
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr class="table-light">
                                    <th>Addon Name</th>
                                    <th>Pricing</th>
                                    <th>Next Due Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$addons item=addon}
                                    <tr>
                                        <td class="fw-bold text-dark" style="font-size: 0.95rem;">{$addon.name}</td>
                                        <td class="fw-semibold text-secondary">{$addon.pricing}</td>
                                        <td class="text-muted">{$addon.nextduedate}</td>
                                        <td>
                                            {if $addon.status eq "Active"}
                                                <span class="badge bg-success">Active</span>
                                            {elseif $addon.status eq "Pending"}
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            {elseif $addon.status eq "Suspended"}
                                                <span class="badge bg-danger">Suspended</span>
                                            {else}
                                                <span class="badge bg-secondary">{$addon.status}</span>
                                            {/if}
                                        </td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    {/if}
</div>
