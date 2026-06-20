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

<!-- Scope styles to avoid polluting other pages -->
<style>
.nav-pills-snbd {
    background: #f7f7f7;
    border-radius: 14px;
    padding: 0.35rem;
    border: 1px solid #eeeeee;
}
.nav-pills-snbd .nav-link {
    color: #555555 !important;
    background: transparent !important;
    font-size: 0.85rem !important;
    font-weight: 600 !important;
    border-radius: 10px !important;
    padding: 0.55rem 1.25rem !important;
    transition: all 0.2s ease !important;
    border: none !important;
}
.nav-pills-snbd .nav-link:hover {
    color: #CC0000 !important;
    background: rgba(204, 0, 0, 0.04) !important;
}
.nav-pills-snbd .nav-link.active {
    color: #ffffff !important;
    background: #CC0000 !important;
    box-shadow: 0 4px 12px rgba(204, 0, 0, 0.15) !important;
}

/* SSO Button hover effects */
.btn-sso-cpanel {
    background: linear-gradient(135deg, #ff6c2c 0%, #ff5211 100%) !important;
    color: #ffffff !important;
    border: none !important;
    border-radius: 12px !important;
    font-weight: 700 !important;
    font-size: 1rem !important;
    box-shadow: 0 4px 18px rgba(255, 108, 44, 0.25) !important;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1) !important;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    text-decoration: none !important;
}
.btn-sso-cpanel:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 8px 25px rgba(255, 108, 44, 0.4) !important;
    color: #ffffff !important;
}
.btn-sso-cpanel:active {
    transform: translateY(0) !important;
}

/* Quick shortcut grid */
.shortcut-btn {
    border: 1px solid #eeeeee !important;
    border-radius: 12px !important;
    font-size: 0.75rem !important;
    font-weight: 600 !important;
    color: #444444 !important;
    background: #ffffff !important;
    transition: all 0.2s ease !important;
    text-decoration: none !important;
}
.shortcut-btn:hover {
    border-color: #ff6c2c !important;
    background: rgba(255, 108, 44, 0.03) !important;
    color: #ff6c2c !important;
    transform: translateY(-2px) !important;
    box-shadow: 0 4px 12px rgba(255, 108, 44, 0.08) !important;
}

/* Module area overrides */
.module-clientarea-wrap {
    width: 100%;
}
.module-clientarea-wrap .card, 
.module-clientarea-wrap .panel {
    background: #ffffff !important;
    border: 1px solid #eeeeee !important;
    border-radius: 16px !important;
    box-shadow: 0 1px 3px rgba(0,0,0,0.01) !important;
    margin-bottom: 1.5rem !important;
    overflow: hidden !important;
}
.module-clientarea-wrap .card-header, 
.module-clientarea-wrap .panel-heading {
    background: #ffffff !important;
    border-bottom: 1px solid #eeeeee !important;
    padding: 1.25rem 1.5rem !important;
    font-weight: 700 !important;
    font-size: 1.1rem !important;
    color: #111111 !important;
}
.module-clientarea-wrap .card-body,
.module-clientarea-wrap .panel-body {
    padding: 1.5rem !important;
}

/* Sitejet image scaling */
.module-clientarea-wrap img[src*="sitejet"],
.module-clientarea-wrap img[src*="Sitejet"],
.module-clientarea-wrap img[src*="sitejet-logo"],
.module-clientarea-wrap img[class*="sitejet"],
.module-clientarea-wrap .sitejet-logo img {
    max-height: 80px !important;
    width: auto !important;
    object-fit: contain !important;
    margin: 0 auto !important;
    display: block !important;
}

/* Target and style Sitejet buttons to match the theme */
.module-clientarea-wrap a.btn-danger, 
.module-clientarea-wrap .btn-danger {
    background-color: #CC0000 !important;
    border-color: #CC0000 !important;
    color: #ffffff !important;
    border-radius: 50rem !important;
    font-weight: 600 !important;
    padding: 0.5rem 1.5rem !important;
    box-shadow: 0 4px 12px rgba(204, 0, 0, 0.15) !important;
}
.module-clientarea-wrap a.btn-danger:hover, 
.module-clientarea-wrap .btn-danger:hover {
    background-color: #aa0000 !important;
    border-color: #aa0000 !important;
}

.module-clientarea-wrap a.btn-default,
.module-clientarea-wrap a.btn-outline-secondary,
.module-clientarea-wrap .btn-default,
.module-clientarea-wrap .btn-outline-secondary {
    background-color: #f5f5f5 !important;
    border: 1px solid #e0e0e0 !important;
    color: #555555 !important;
    border-radius: 50rem !important;
    font-weight: 600 !important;
    padding: 0.5rem 1.5rem !important;
}
.module-clientarea-wrap a.btn-default:hover,
.module-clientarea-wrap .btn-default:hover {
    background-color: #e8e8e8 !important;
}

/* Style default tables inside module client area if any */
.module-clientarea-wrap table {
    width: 100% !important;
}

/* Custom styles for WHMCS default cPanel panels */
.snbd-quick-shortcuts-panel .row {
    margin: 0 !important;
    display: flex !important;
    flex-wrap: wrap !important;
    gap: 1rem !important;
    justify-content: center !important;
}
.snbd-quick-shortcuts-panel .row > div[class*="col-"] {
    flex: 1 1 calc(25% - 1rem) !important;
    max-width: calc(25% - 1rem) !important;
    min-width: 140px !important;
    padding: 0 !important;
}
.snbd-quick-shortcuts-panel a {
    display: flex !important;
    flex-direction: column !important;
    align-items: center !important;
    justify-content: center !important;
    background: #ffffff !important;
    border: 1px solid #eeeeee !important;
    border-radius: 14px !important;
    padding: 1.5rem 1rem !important;
    color: #444444 !important;
    text-decoration: none !important;
    font-weight: 600 !important;
    font-size: 0.85rem !important;
    transition: all 0.25s ease !important;
    height: 100% !important;
    box-shadow: 0 2px 8px rgba(0,0,0,0.02) !important;
}
.snbd-quick-shortcuts-panel a:hover {
    border-color: #ff6c2c !important;
    transform: translateY(-4px) !important;
    box-shadow: 0 10px 25px rgba(255, 108, 44, 0.12) !important;
    color: #ff6c2c !important;
    background: #ffffff !important;
}
.snbd-quick-shortcuts-panel a img,
.snbd-quick-shortcuts-panel a i {
    max-height: 40px !important;
    margin-bottom: 0.75rem !important;
    font-size: 2rem !important;
    color: #ff6c2c !important;
}
</style>

<!-- Services Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline" style="font-size: 2.25rem; margin-bottom: 0.25rem;">Manage <span class="dash-headline-accent">{$product}</span></h1>
        <p class="text-secondary small mb-0">{$groupname} {if $domain} — <a href="http://{$domain}" target="_blank" class="text-danger fw-bold text-decoration-none">{$domain} <i class="ti ti-external-link"></i></a>{/if}</p>
    </div>
    <a href="clientarea.php?action=products" class="btn btn-outline-clean"><i class="ti ti-arrow-left me-2"></i>Back to Services</a>
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
            <div class="row g-4 mb-4">
                
                <!-- Left: Service Details Card -->
                <div class="col-lg-6">
                    <div class="card h-100 dash-card-clean">
                        <div class="card-header">
                            <span class="d-flex align-items-center gap-2">
                                <i class="ti ti-info-circle" style="color: #CC0000; font-size: 1.2rem;"></i> Service Overview
                            </span>
                        </div>
                        <div class="card-body p-4 d-flex flex-column justify-content-between">
                            <div class="table-responsive">
                                <table class="table table-borderless align-middle mb-0" style="font-size: 0.9rem;">
                                    <tbody>
                                        <tr style="border-bottom: 1px solid #f6f6f6;">
                                            <td class="text-secondary py-3" style="font-weight: 500;">Status</td>
                                            <td class="text-end py-3">
                                                {if $status eq "Active"}
                                                    <span class="badge-clean badge-clean-success">Active</span>
                                                {elseif $status eq "Pending"}
                                                    <span class="badge-clean badge-clean-warning">Pending</span>
                                                {elseif $status eq "Suspended"}
                                                    <span class="badge-clean badge-clean-danger">Suspended</span>
                                                {elseif $status eq "Terminated"}
                                                    <span class="badge-clean badge-clean-danger" style="background: rgba(100,100,100,0.08) !important; color: #666666 !important; border: 1px solid rgba(100,100,100,0.15) !important;">Terminated</span>
                                                {else}
                                                    <span class="badge-clean badge-clean-info">{$status}</span>
                                                {/if}
                                            </td>
                                        </tr>
                                        <tr style="border-bottom: 1px solid #f6f6f6;">
                                            <td class="text-secondary py-3" style="font-weight: 500;">Registration Date</td>
                                            <td class="text-dark fw-semibold text-end py-3">{$regdate}</td>
                                        </tr>
                                        <tr style="border-bottom: 1px solid #f6f6f6;">
                                            <td class="text-secondary py-3" style="font-weight: 500;">Recurring Amount</td>
                                            <td class="text-dark fw-bold text-end py-3">{$amount}</td>
                                        </tr>
                                        <tr style="border-bottom: 1px solid #f6f6f6;">
                                            <td class="text-secondary py-3" style="font-weight: 500;">Billing Cycle</td>
                                            <td class="text-dark fw-semibold text-end py-3">{$billingcycle}</td>
                                        </tr>
                                        <tr style="border-bottom: 1px solid #f6f6f6;">
                                            <td class="text-secondary py-3" style="font-weight: 500;">Next Due Date</td>
                                            <td class="text-dark fw-bold text-end py-3">{$nextduedate}</td>
                                        </tr>
                                        <tr>
                                            <td class="text-secondary py-3" style="font-weight: 500;">Payment Method</td>
                                            <td class="text-dark fw-semibold text-end py-3">{$paymentmethod}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="mt-4 pt-3 d-flex gap-2 flex-wrap" style="border-top: 1px solid #f0f0f0;">
                                {if $packagesupgrade}
                                    <a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-outline-clean py-2 px-3" style="font-size: 0.8rem; border-radius: 10px !important;">
                                        <i class="ti ti-arrow-up-circle me-1"></i> Upgrade / Downgrade
                                    </a>
                                {/if}
                                {if $showcancelbutton}
                                    <a href="clientarea.php?action=cancel&amp;id={$id}" class="btn btn-outline-danger py-2 px-3 {if $pendingcancellation}disabled{/if}" style="font-size: 0.8rem; border-radius: 10px !important; display: inline-flex; align-items: center; border: 1px solid #ffcccc; color: #cc0000; background: #fff5f5;">
                                        <i class="ti ti-ban me-1"></i> Request Cancellation
                                    </a>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Right: Control Panel Access Card -->
                <div class="col-lg-6">
                    <div class="card h-100 dash-card-clean" style="border-top: 4px solid #ff6c2c !important;">
                        <div class="card-header d-flex justify-content-between align-items-center">
                                <span class="d-flex align-items-center gap-2" id="cpanelCardTitle">
                                    <i class="fab fa-cpanel" style="color: #ff6c2c; font-size: 1.5rem; vertical-align: middle;"></i> Control Panel Access
                            </span>
                            <span class="badge bg-light text-success border border-success-subtle px-2 py-1" style="font-size: 0.75rem; font-weight: 600;">
                                <i class="ti ti-shield-check me-1"></i> Secure SSO
                            </span>
                        </div>
                        <div class="card-body p-4 d-flex flex-column justify-content-between">
                            <div class="text-center my-2">
                                <div class="mb-4 mt-2" id="cpanelLogoWrap">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Cpanel-logo.png" alt="cPanel Logo" id="cpanelLogo" style="max-height: 40px; width: auto; object-fit: contain;">
                                </div>
                                <p class="text-secondary small px-3">
                                </p>
                                
                                <div class="text-start mt-4 mb-2 p-3" style="background: rgba(255, 108, 44, 0.04); border: 1px solid rgba(255, 108, 44, 0.1); border-radius: 8px;">
                                    <p class="text-secondary mb-0" style="font-size: 0.7rem; line-height: 1.5; color: #777777 !important;">
                                        SNBD HOST utilizes various third-party software and services to operate our web hosting servers and infrastructure. This software is provided under separate license by the respective owners.<br><br>
                                        Please be aware that any third-party software running on SNBD HOST servers is subject to the terms and conditions set forth by the original software licensors. SNBD HOST claims no ownership or control over this third-party software.
                                    </p>
                                </div>
                            </div>
                            
                            <div class="d-flex flex-column gap-3 mt-3">
                                <!-- n8n button placeholder (shown via JS for n8n products) -->
                                <div id="n8nButtonContainer" style="display:none;">
                                    <a href="#" class="btn btn-sso-cpanel w-100 py-3" id="n8nMainBtn" style="background-color: #ff6c2c !important; color: white !important; display: flex; align-items: center; justify-content: center; gap: 10px; border-radius: 12px; font-weight: 700; font-size: 1.1rem; box-shadow: 0 4px 15px rgba(255,108,44,0.3); transition: all 0.3s ease;">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/N8n-logo-new.svg" style="height: 1.5rem; filter: brightness(0) invert(1);" alt="n8n"> GO TO N8N
                                    </a>
                                </div>

                                <!-- Big cPanel SSO Login Button (hidden for n8n via JS) -->
                                <a href="clientarea.php?action=productdetails&id={$id}&dosinglesignon=1" target="_blank" class="btn btn-sso-cpanel w-100 py-3" id="cpanelLoginBtn">
                                    <i class="fab fa-cpanel" style="font-size: 2.2rem; line-height: 1;"></i> LOGIN TO CPANEL
                                </a>

                                <!-- Quick Links Grid (hidden for n8n via JS) -->
                                <div class="row g-2 mt-1" id="cpanelQuickLinks">
                                    <div class="col-4">
                                        <a href="clientarea.php?action=productdetails&id={$id}&dosinglesignon=1&app=Filemanager" target="_blank" class="shortcut-btn py-2.5 d-flex flex-column align-items-center gap-1.5 text-center">
                                            <i class="ti ti-folder" style="font-size: 1.4rem; color: #ff6c2c;"></i>
                                            <span>File Manager</span>
                                        </a>
                                    </div>
                                    <div class="col-4">
                                        <a href="clientarea.php?action=productdetails&id={$id}&dosinglesignon=1&app=Email" target="_blank" class="shortcut-btn py-2.5 d-flex flex-column align-items-center gap-1.5 text-center">
                                            <i class="ti ti-mail" style="font-size: 1.4rem; color: #ff6c2c;"></i>
                                            <span>Email Accounts</span>
                                        </a>
                                    </div>
                                    <div class="col-4">
                                        <a href="clientarea.php?action=productdetails&id={$id}&dosinglesignon=1&app=Phpmyadmin" target="_blank" class="shortcut-btn py-2.5 d-flex flex-column align-items-center gap-1.5 text-center">
                                            <i class="ti ti-database" style="font-size: 1.4rem; color: #ff6c2c;"></i>
                                            <span>phpMyAdmin</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
            </div>
            
            {if $customfields}
                <div class="card dash-card-clean mb-4">
                    <div class="card-header">
                        <span class="d-flex align-items-center gap-2">
                            <i class="ti ti-list-details" style="color: #CC0000; font-size: 1.2rem;"></i> Additional Information
                        </span>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3">
                            {foreach from=$customfields item=field}
                                <div class="col-md-6 col-xl-4">
                                    <div style="background: #fafafa; border-radius: 12px; padding: 1rem; border: 1px solid #eeeeee;">
                                        <div class="small text-secondary fw-semibold">{$field.name}</div>
                                        <div class="text-dark fw-bold mt-1" style="font-size: 0.95rem;">{$field.value|default:"-"}</div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                </div>
            {/if}
            
            {if $tplOverviewTabOutput}
                <div class="module-clientarea-wrap mt-4" id="moduleClientAreaWrap">
                    {$tplOverviewTabOutput}
                </div>
            {elseif $moduleclientarea}
                <div class="module-clientarea-wrap mt-4" id="moduleClientAreaWrap">
                    {$moduleclientarea}
                </div>
            {/if}

            <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Detect n8n purely from the rendered product name in the DOM
                var productHeading = document.querySelector('.dash-headline .dash-headline-accent');
                var productName = productHeading ? productHeading.textContent.toLowerCase() : '';
                var isN8n = productName.indexOf('n8n') !== -1;

                if (!isN8n) return; // Nothing to do for non-n8n products

                // 1. Swap the card title
                var cardTitle = document.getElementById('cpanelCardTitle');
                if (cardTitle) {
                    cardTitle.innerHTML = '<img src="https://upload.wikimedia.org/wikipedia/commons/5/53/N8n-logo-new.svg" style="height:1.5rem;vertical-align:middle;" alt="n8n"> n8n Access';
                }

                // 2. Swap the logo
                var logo = document.getElementById('cpanelLogo');
                if (logo) {
                    logo.src = 'https://upload.wikimedia.org/wikipedia/commons/5/53/N8n-logo-new.svg';
                    logo.alt = 'n8n Logo';
                }

                // 3. Hide cPanel login button and quick links
                var cpBtn = document.getElementById('cpanelLoginBtn');
                if (cpBtn) cpBtn.style.display = 'none';
                var cpLinks = document.getElementById('cpanelQuickLinks');
                if (cpLinks) cpLinks.style.display = 'none';

                // 4. Show n8n button container
                var n8nContainer = document.getElementById('n8nButtonContainer');
                if (n8nContainer) n8nContainer.style.display = 'block';

                // 5. Restyle the n8n module output
                var wrap = document.getElementById('moduleClientAreaWrap');
                if (wrap) {
                    // Find and move the main "Go to n8n" button / URL
                    var buttons = wrap.querySelectorAll('a[href], button, input[type="submit"], input[type="button"]');
                    var n8nBtn = null;
                    buttons.forEach(function(btn) {
                        var text = (btn.innerText || btn.value || '').toLowerCase();
                        if (!n8nBtn && (text.indexOf('n8n') !== -1 || text.indexOf('go to') !== -1 || text.indexOf('login') !== -1 || text.indexOf('access') !== -1)) {
                            n8nBtn = btn;
                        }
                    });
                    if (!n8nBtn && buttons.length > 0) n8nBtn = buttons[0];

                    var mainBtn = document.getElementById('n8nMainBtn');
                    if (n8nBtn && mainBtn) {
                        var href = n8nBtn.getAttribute('href');
                        if (href && href !== '#') {
                            mainBtn.href = href;
                            mainBtn.target = '_blank';
                        }
                        
                        // Hide original button/link in module
                        if (n8nBtn.closest('tr')) n8nBtn.closest('tr').style.display = 'none';
                        else if (n8nBtn.closest('.row')) n8nBtn.closest('.row').style.display = 'none';
                        else n8nBtn.style.display = 'none';
                    }

                    // Hide giant raw n8n logo/links if they appear directly in the module body
                    wrap.querySelectorAll('img').forEach(function(img) {
                        if(img.src.includes('n8n')) {
                            if (img.closest('tr')) img.closest('tr').style.display = 'none';
                            else img.style.display = 'none';
                        }
                    });

                    // Hide raw URLs that point to n8n
                    wrap.querySelectorAll('a').forEach(function(a) {
                        if (a.innerText.includes('.n8n') || a.href.includes('.n8n')) {
                            a.style.display = 'none';
                        }
                    });

                    // 6. Style the module tables (this catches the raw rows of CPU, Memory, etc.)
                    var tables = wrap.querySelectorAll('table');
                    tables.forEach(function(tbl) {
                        tbl.classList.add('table', 'table-borderless');
                        tbl.style.background = '#ffffff';
                        tbl.style.borderRadius = '16px';
                        tbl.style.overflow = 'hidden';
                        tbl.style.boxShadow = '0 4px 15px rgba(0,0,0,0.02)';
                        tbl.style.border = '1px solid #f0f0f0';
                        tbl.style.marginBottom = '2rem';
                        
                        var cells = tbl.querySelectorAll('td, th');
                        cells.forEach(function(cell) {
                            cell.style.padding = '1.25rem 1.5rem';
                            cell.style.verticalAlign = 'middle';
                            cell.style.borderBottom = '1px solid #f6f6f6';
                            cell.style.color = '#444';
                            cell.style.fontWeight = '500';
                            
                            // Make labels bolder
                            if (cell.innerText.includes(':')) {
                                cell.style.color = '#888';
                                cell.style.fontWeight = '600';
                                cell.style.width = '30%';
                            }
                        });
                    });

                    // 7. Auto-detect and beautifully style inline-styled progress bars (green/red blocks)
                    var allDivs = wrap.querySelectorAll('div, td, span');
                    allDivs.forEach(function(el) {
                        var bg = (el.style.backgroundColor || '').toLowerCase();
                        var width = el.style.width || '';
                        
                        // If it looks like a progress bar segment
                        if (width && (bg === 'green' || bg === 'red' || bg.includes('rgb(') || bg.includes('#'))) {
                            el.style.display = 'inline-flex';
                            el.style.alignItems = 'center';
                            el.style.justifyContent = 'center';
                            el.style.color = '#fff';
                            el.style.fontWeight = '700';
                            el.style.fontSize = '0.75rem';
                            el.style.textShadow = '0 1px 2px rgba(0,0,0,0.2)';
                            el.style.height = '28px';
                            el.style.lineHeight = '28px';
                            el.style.boxShadow = 'inset 0 2px 4px rgba(0,0,0,0.1)';
                            
                            // Match branding
                            if (bg === 'green' || bg === '#008000') {
                                el.style.backgroundColor = '#10B981'; // Modern emerald green
                                el.style.backgroundImage = 'linear-gradient(45deg,rgba(255,255,255,.15) 25%,transparent 25%,transparent 50%,rgba(255,255,255,.15) 50%,rgba(255,255,255,.15) 75%,transparent 75%,transparent)';
                                el.style.backgroundSize = '1rem 1rem';
                            }
                            if (bg === 'red' || bg === '#ff0000') {
                                el.style.backgroundColor = '#EF4444'; // Modern red
                            }
                            
                            // Give parents nice rounded corners
                            var parent = el.parentElement;
                            if (parent) {
                                parent.style.backgroundColor = '#f4f5f7';
                                parent.style.borderRadius = '14px';
                                parent.style.overflow = 'hidden';
                                parent.style.display = 'flex';
                                parent.style.width = '100%';
                                parent.style.boxShadow = 'inset 0 1px 3px rgba(0,0,0,0.06)';
                            }
                        }
                    });

                    // 8. Style other buttons (like "Change Owner Password")
                    wrap.querySelectorAll('.btn-danger, a[href*="password"]').forEach(function(btn) {
                        btn.style.backgroundColor = '#fff';
                        btn.style.color = '#EF4444';
                        btn.style.border = '1px solid #EF4444';
                        btn.style.borderRadius = '12px';
                        btn.style.padding = '0.75rem 1.5rem';
                        btn.style.fontWeight = '700';
                        btn.style.boxShadow = '0 4px 10px rgba(239, 68, 68, 0.1)';
                        btn.style.transition = 'all 0.3s ease';
                        btn.onmouseover = function() { btn.style.backgroundColor = '#EF4444'; btn.style.color = '#fff'; };
                        btn.onmouseout = function() { btn.style.backgroundColor = '#fff'; btn.style.color = '#EF4444'; };
                    });

                    // Format raw status text
                    wrap.innerHTML = wrap.innerHTML.replace('running', '<span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill" style="font-weight:700; font-size:0.85rem;"><i class="ti ti-activity me-1"></i> Running</span>');
                }
            });
            </script>
            <style>
            .n8n-main-btn:hover, #n8nMainBtn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255,108,44,0.4) !important;
                background-color: #f55b1c !important;
            }
            </style>
    </div>
    
    <!-- CHANGE PASSWORD TAB -->
    {if $modulechangepassword}
        <div class="tab-pane fade" id="tabPassword" role="tabpanel" aria-labelledby="password-tab">
            <div class="card dash-card-clean">
                <div class="card-header">
                    <span class="d-flex align-items-center gap-2">
                        <i class="ti ti-key" style="color: #CC0000; font-size: 1.2rem;"></i> Change Password
                    </span>
                </div>
                <div class="card-body p-4" style="max-width: 600px;">
                    <form class="using-password-strength" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails#tabPassword">
                        <input type="hidden" name="id" value="{$id}" />
                        <input type="hidden" name="modulechangepassword" value="true" />
                        
                        {if $username}
                            <div class="mb-4 row align-items-center">
                                <label class="col-sm-4 col-form-label fw-bold text-secondary">Username</label>
                                <div class="col-sm-8">
                                    <input type="text" readonly class="form-control-plaintext text-dark fw-bold" value="{$username}" style="font-size: 1.05rem;">
                                </div>
                            </div>
                        {/if}
                        
                        <div class="mb-3 row">
                            <label for="inputNewPassword1" class="col-sm-4 col-form-label fw-semibold text-secondary">New Password</label>
                            <div class="col-sm-8">
                                <input type="password" class="form-control py-2" id="inputNewPassword1" name="newpw" autocomplete="off" placeholder="Enter new password" style="border-radius: 8px;" />
                            </div>
                        </div>
                        
                        <div class="mb-4 row">
                            <label for="inputNewPassword2" class="col-sm-4 col-form-label fw-semibold text-secondary">Confirm Password</label>
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
            <div class="card dash-card-clean">
                <div class="card-header">
                    <span class="d-flex align-items-center gap-2">
                        <i class="ti ti-download" style="color: #CC0000; font-size: 1.2rem;"></i> Downloads
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-clean align-middle mb-0">
                            <thead>
                                <tr>
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
                                        <td class="text-secondary small">{$download.description}</td>
                                        <td class="text-end">
                                            <a href="{$download.link}" class="btn-outline-table">
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
            <div class="card dash-card-clean">
                <div class="card-header">
                    <span class="d-flex align-items-center gap-2">
                        <i class="ti ti-puzzle" style="color: #CC0000; font-size: 1.2rem;"></i> Addons &amp; Extras
                    </span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-clean align-middle mb-0">
                            <thead>
                                <tr>
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
                                        <td class="text-secondary">{$addon.nextduedate}</td>
                                        <td>
                                            {if $addon.status eq "Active"}
                                                <span class="badge-clean badge-clean-success">Active</span>
                                            {elseif $addon.status eq "Pending"}
                                                <span class="badge-clean badge-clean-warning">Pending</span>
                                            {elseif $addon.status eq "Suspended"}
                                                <span class="badge-clean badge-clean-danger">Suspended</span>
                                            {else}
                                                <span class="badge bg-light text-secondary border px-2 py-1" style="font-size: 0.75rem;">{$addon.status}</span>
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

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Hide default WHMCS panels we don't want, and style the ones we do
    const panels = document.querySelectorAll('.module-clientarea-wrap .card, .module-clientarea-wrap .panel, .module-clientarea-wrap > div');
    
    panels.forEach(panel => {
        const headerElement = panel.querySelector('.card-header, .panel-heading, h3');
        if (headerElement) {
            const headerText = headerElement.innerText.trim().toLowerCase();
            
            // Hide Quick Create Email, Billing Overview, and Usage Statistics
            if (headerText.includes('quick create email') || headerText.includes('billing overview') || headerText.includes('usage statistics')) {
                panel.style.display = 'none';
            }
            
            // Apply redesign class to Quick Shortcuts
            if (headerText.includes('quick shortcuts')) {
                panel.classList.add('snbd-quick-shortcuts-panel');
            }
        }
    });
});
</script>
