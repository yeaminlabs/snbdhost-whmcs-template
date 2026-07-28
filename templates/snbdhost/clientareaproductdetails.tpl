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

<!-- Determine Service Type -->
{assign var="prodLower" value=$product|lower}
{assign var="groupLower" value=$groupname|lower}
{assign var="modLower" value=$module|lower}

{if $modLower eq 'n8n' || $prodLower|strpos:'n8n' !== false || $groupLower|strpos:'n8n' !== false}
    {assign var="serviceType" value="n8n"}
{elseif $prodLower|strpos:'reseller' !== false || $groupLower|strpos:'reseller' !== false || $modLower eq 'whm'}
    {assign var="serviceType" value="reseller"}
{elseif $prodLower|strpos:'openclaw' !== false || $groupLower|strpos:'openclaw' !== false || $modLower eq 'openclaw'}
    {assign var="serviceType" value="openclaw"}
{elseif $modLower eq 'cpanel' || $groupLower|strpos:'shared' !== false || $groupLower|strpos:'cpanel' !== false || $prodLower|strpos:'shared' !== false}
    {assign var="serviceType" value="cpanel"}
{else}
    {assign var="serviceType" value="universal"}
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

.sso-btn-main {
    background: linear-gradient(135deg, var(--brand-primary, #E05052) 0%, var(--brand-dark, #4A1416) 100%) !important;
    color: #ffffff !important;
    border: none !important;
    border-radius: 12px !important;
    font-weight: 700 !important;
    font-size: 1rem !important;
    box-shadow: 0 4px 18px rgba(224, 80, 82, 0.25) !important;
    transition: all 0.25s ease !important;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    text-decoration: none !important;
}
.sso-btn-main:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 8px 25px rgba(224, 80, 82, 0.4) !important;
    color: #ffffff !important;
}

.shortcut-card-item {
    border: 1px solid var(--border-color, #e0e0e0) !important;
    border-radius: 12px !important;
    font-size: 0.85rem !important;
    font-weight: 600 !important;
    color: var(--text-primary, #1a1a1a) !important;
    background: var(--bg-surface, #ffffff) !important;
    transition: all 0.2s ease !important;
    text-decoration: none !important;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.25rem 0.75rem;
    height: 100%;
}
.shortcut-card-item:hover {
    border-color: var(--brand-primary, #E05052) !important;
    background: var(--brand-light, rgba(224, 80, 82, 0.04)) !important;
    color: var(--brand-primary, #E05052) !important;
    transform: translateY(-3px) !important;
    box-shadow: 0 6px 16px rgba(224, 80, 82, 0.12) !important;
}
.shortcut-card-item i {
    font-size: 1.75rem;
    color: var(--brand-primary, #E05052);
    margin-bottom: 0.5rem;
}

.progress-thin {
    height: 10px;
    border-radius: 10px;
    background: var(--bg-elevated, #eeeeee);
    overflow: hidden;
}
.progress-bar-danger {
    background: linear-gradient(90deg, var(--brand-primary, #E05052), var(--brand-hover, #E87072));
}

html[data-theme="dark"] .dash-card-clean {
    background: var(--bg-surface, #1C1416) !important;
    border: 1px solid var(--border-color, #332326) !important;
}
html[data-theme="dark"] .dash-card-clean .card-header {
    background: var(--bg-surface, #1C1416) !important;
    border-bottom: 1px solid var(--border-color, #332326) !important;
    color: var(--text-primary, #E8E1E2) !important;
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
        <div class="row g-4 mb-4">
            
            <!-- Left Card: Service Overview -->
            <div class="col-lg-6">
                <div class="card h-100 dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                    <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                        <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                            <i class="ti ti-info-circle text-danger"></i> Service Overview
                        </span>
                    </div>
                    <div class="card-body p-4 d-flex flex-column justify-content-between">
                        <table class="table table-borderless align-middle mb-0" style="font-size: 0.9rem;">
                            <tbody>
                                <tr style="border-bottom: 1px solid var(--border-color, #f6f6f6);">
                                    <td class="text-muted py-2.5">Registration Date</td>
                                    <td class="fw-semibold text-end py-2.5">{$regdate}</td>
                                </tr>
                                <tr style="border-bottom: 1px solid var(--border-color, #f6f6f6);">
                                    <td class="text-muted py-2.5">Recurring Amount</td>
                                    <td class="fw-bold text-end py-2.5 text-danger">{$amount}</td>
                                </tr>
                                <tr style="border-bottom: 1px solid var(--border-color, #f6f6f6);">
                                    <td class="text-muted py-2.5">Billing Cycle</td>
                                    <td class="fw-semibold text-end py-2.5">{$billingcycle}</td>
                                </tr>
                                <tr style="border-bottom: 1px solid var(--border-color, #f6f6f6);">
                                    <td class="text-muted py-2.5">Next Due Date</td>
                                    <td class="fw-bold text-end py-2.5">{$nextduedate}</td>
                                </tr>
                                <tr>
                                    <td class="text-muted py-2.5">Payment Method</td>
                                    <td class="fw-semibold text-end py-2.5">{$paymentmethod}</td>
                                </tr>
                            </tbody>
                        </table>
                        
                        <div class="mt-4 pt-3 d-flex gap-2 flex-wrap" style="border-top: 1px solid var(--border-color, #e0e0e0);">
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
            </div>
            
            <!-- Right Card: Control Panel Access / Workspace SSO -->
            <div class="col-lg-6">
                <div class="card h-100 dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                    <div class="card-header bg-transparent py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                        <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                            {if $serviceType eq "n8n"}
                                <i class="ti ti-bolt text-danger"></i> n8n Workspace Access
                            {elseif $serviceType eq "reseller"}
                                <i class="ti ti-building text-danger"></i> Reseller Control Panel
                            {elseif $serviceType eq "openclaw"}
                                <i class="ti ti-cpu text-danger"></i> OpenClaw Workspace
                            {else}
                                <i class="ti ti-world text-danger"></i> Control Panel Access
                            {/if}
                        </span>
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1" style="font-size: 0.75rem; font-weight: 600;">
                            <i class="ti ti-shield-check me-1"></i> Secure SSO
                        </span>
                    </div>
                    <div class="card-body p-4 d-flex flex-column justify-content-between text-center">
                        <div>
                            <div class="my-3">
                                {if $serviceType eq "n8n"}
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/N8n-logo-new.svg" alt="n8n Logo" style="max-height: 48px; width: auto;">
                                {elseif $serviceType eq "reseller"}
                                    <div class="fw-bold fs-3 text-danger" style="font-family: var(--font-heading);">WHM</div>
                                {elseif $serviceType eq "openclaw"}
                                    <div class="fw-bold fs-3 text-danger" style="font-family: var(--font-heading);"><i class="ti ti-cpu me-1"></i> OpenClaw</div>
                                {else}
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/4/4f/Cpanel-logo.png" alt="cPanel Logo" style="max-height: 40px; width: auto;">
                                {/if}
                            </div>
                            <p class="text-muted small px-2 mb-3">
                                {if $serviceType eq "n8n"}
                                    Direct Single Sign-On to your private n8n workflow automation instance.
                                {elseif $serviceType eq "reseller"}
                                    Full WHM Reseller Portal to manage client accounts and packages.
                                {elseif $serviceType eq "openclaw"}
                                    High-performance managed web automation &amp; AI workflow engine.
                                {else}
                                    Manage files, databases, emails, and domain settings directly.
                                {/if}
                            </p>
                        </div>
                        
                        <div class="d-flex flex-column gap-2 mt-3">
                            {if $serviceType eq "n8n"}
                                {if $domain}
                                    <a href="https://{$domain}" target="_blank" class="sso-btn-main w-100 py-3">
                                        <i class="ti ti-external-link"></i> GO TO N8N WORKSPACE
                                    </a>
                                {else}
                                    <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1" target="_blank" class="sso-btn-main w-100 py-3">
                                        <i class="ti ti-external-link"></i> GO TO N8N WORKSPACE
                                    </a>
                                {/if}
                                <a href="https://snbdhost.com/learn/n8n-basic-to-advanced-in-bangla" target="_blank" class="btn btn-outline-danger w-100 py-2 fw-bold" style="border-radius: 10px; font-size: 0.9rem;">
                                    <i class="ti ti-school me-1"></i> Free n8n Masterclass (বাংলায়)
                                </a>
                            {elseif $serviceType eq "reseller"}
                                <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1" target="_blank" class="sso-btn-main w-100 py-3">
                                    <i class="ti ti-login me-1"></i> LOGIN TO WHM
                                </a>
                            {elseif $serviceType eq "openclaw"}
                                {if $domain}
                                    <a href="https://{$domain}" target="_blank" class="sso-btn-main w-100 py-3">
                                        <i class="ti ti-terminal me-1"></i> OPEN CONSOLE ACCESS
                                    </a>
                                {else}
                                    <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1" target="_blank" class="sso-btn-main w-100 py-3">
                                        <i class="ti ti-terminal me-1"></i> OPEN CONSOLE ACCESS
                                    </a>
                                {/if}
                            {else}
                                <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1" target="_blank" class="sso-btn-main w-100 py-3">
                                    <i class="ti ti-login me-1"></i> LOGIN TO CPANEL
                                </a>
                            {/if}
                        </div>
                        
                        <div class="mt-3 p-2 text-start rounded" style="background: var(--bg-elevated, #fafafa); border: 1px solid var(--border-color, #e0e0e0);">
                            <span class="text-muted" style="font-size: 0.7rem; line-height: 1.4;">
                                Licensed software provided under owner terms. SNBD HOST claims no ownership over third-party licensors.
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>

        <!-- SERVICE FEATURE CARDS -->

        <!-- A. n8n Managed Hosting Features -->
        {if $serviceType eq "n8n"}
            <div class="row g-4 mb-4">
                <div class="col-12">
                    <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-transparent py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                            <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                                <i class="ti ti-activity text-danger"></i> RESOURCE CONSUMPTION
                            </span>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1" style="font-size: 0.75rem;">
                                <i class="ti ti-point-filled me-1"></i> Running
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">CPU Usage (1 CPU)</span>
                                        <span class="fw-bold small text-dark">0.17% used</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 1%;" aria-valuenow="0.17" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">Memory Usage (544.3MiB / 1GiB)</span>
                                        <span class="fw-bold small text-dark">53.15% used</span>
                                    </div>
                                    <div class="progress progress-thin mb-2">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 53%;" aria-valuenow="53.15" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    {if $packagesupgrade}
                                        <a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-outline-secondary btn-xs py-0.5 px-2 fw-semibold float-end" style="font-size: 0.75rem; border-radius: 6px;">
                                            <i class="ti ti-adjustments-alt me-1"></i> Scale Memory
                                        </a>
                                    {/if}
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">Disk Usage (6.7M / 9.8G)</span>
                                        <span class="fw-bold small text-dark">1.00% used</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 1%;" aria-valuenow="1.0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-transparent py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                            <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                                <i class="ti ti-server text-danger"></i> INSTANCE DETAILS
                            </span>
                            {if $domain}
                                <a href="https://{$domain}" target="_blank" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                    <i class="ti ti-external-link me-1"></i> Open Instance
                                </a>
                            {/if}
                        </div>
                        <div class="card-body p-4">
                            <div class="p-3 mb-3 rounded border font-monospace small d-flex justify-content-between align-items-center" style="background: var(--bg-elevated, #fafafa);">
                                <span>Instance URL: <strong class="text-danger">https://{$domain|default:"2369-1670.n8nbysnbd.top"}/</strong></span>
                                <button type="button" onclick="navigator.clipboard.writeText('https://{$domain|default:"2369-1670.n8nbysnbd.top"}')" class="btn btn-xs btn-outline-secondary">
                                    <i class="ti ti-copy"></i> Copy
                                </button>
                            </div>
                            
                            <div class="row text-center g-3">
                                <div class="col-md-4">
                                    <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                        <div class="small text-muted fw-semibold mb-1">Version</div>
                                        <div class="fw-bold text-dark">2.31.7</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                        <div class="small text-muted fw-semibold mb-1">Owner</div>
                                        <div class="fw-bold text-dark">N/A</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                        <div class="small text-muted fw-semibold mb-1">Users</div>
                                        <div class="fw-bold text-dark text-truncate">{$username|default:"swadeallhadefp@gmail.com"}</div>
                                    </div>
                                </div>
                            </div>
                            
                            {if $modulechangepassword}
                                <div class="mt-3 text-end">
                                    <button type="button" onclick="jQuery('#password-tab').click()" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                        <i class="ti ti-key me-1"></i> Change Owner Password
                                    </button>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>

        <!-- B. cPanel / Shared Hosting Features -->
        {elseif $serviceType eq "cpanel"}
            {if $domain}
                <div class="card dash-card-clean border-0 shadow-sm mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                    <div class="card-body p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="fw-bold text-danger fs-4" style="font-family: var(--font-heading);">SITEJET</div>
                            <div>
                                <h6 class="fw-bold mb-0">Sitejet Website Builder</h6>
                                <p class="text-muted small mb-0">Build your website for {$domain} instantly without coding.</p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <a href="http://{$domain}" target="_blank" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                <i class="ti ti-external-link me-1"></i> Visit Website
                            </a>
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Sitejet" target="_blank" class="btn btn-brand-clean btn-sm fw-bold" style="border-radius: 8px;">
                                <i class="ti ti-edit me-1"></i> Edit with Sitejet
                            </a>
                        </div>
                    </div>
                </div>
            {/if}

            <div class="card dash-card-clean border-0 shadow-sm mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-layout-grid text-danger"></i> QUICK SHORTCUTS (Direct cPanel SSO)
                    </span>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Email" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-mail"></i>
                                <span>Email Accounts</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Forwarders" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-arrow-forward"></i>
                                <span>Forwarders</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Autoresponders" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-message-dots"></i>
                                <span>Autoresponders</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Filemanager" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-folder"></i>
                                <span>File Manager</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Backups" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-database-export"></i>
                                <span>Backups</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=AddonDomains" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-world"></i>
                                <span>Addon Domains</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Cron" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-clock"></i>
                                <span>Cron Jobs</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-4 col-md-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Phpmyadmin" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-database"></i>
                                <span>MySQL Databases</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        <!-- C. Reseller Hosting Features -->
        {elseif $serviceType eq "reseller"}
            <div class="row g-4 mb-4">
                <div class="col-12">
                    <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                            <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                                <i class="ti ti-dns text-danger"></i> BRANDED NAMESERVERS &amp; DELEGATION
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <div class="p-3 rounded border d-flex justify-content-between align-items-center" style="background: var(--bg-elevated, #fafafa);">
                                        <div>
                                            <div class="small text-muted fw-semibold">Primary Nameserver (NS1)</div>
                                            <div class="fw-bold text-dark font-monospace">ns1.{$domain|default:"agencybrand.com"} <span class="text-muted fw-normal">(103.87.214.10)</span></div>
                                        </div>
                                        <button type="button" onclick="navigator.clipboard.writeText('ns1.{$domain|default:"agencybrand.com"}')" class="btn btn-xs btn-outline-secondary">
                                            <i class="ti ti-copy"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="p-3 rounded border d-flex justify-content-between align-items-center" style="background: var(--bg-elevated, #fafafa);">
                                        <div>
                                            <div class="small text-muted fw-semibold">Secondary Nameserver (NS2)</div>
                                            <div class="fw-bold text-dark font-monospace">ns2.{$domain|default:"agencybrand.com"} <span class="text-muted fw-normal">(103.87.214.11)</span></div>
                                        </div>
                                        <button type="button" onclick="navigator.clipboard.writeText('ns2.{$domain|default:"agencybrand.com"}')" class="btn btn-xs btn-outline-secondary">
                                            <i class="ti ti-copy"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="p-2.5 rounded border small text-secondary d-flex justify-content-between flex-wrap gap-2" style="background: var(--bg-elevated, #fafafa);">
                                <span>Server Hostname: <strong class="text-dark">us-reseller-01.snbdhost.com</strong></span>
                                <span>Server IP: <strong class="text-dark">103.87.214.70</strong></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                            <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                                <i class="ti ti-chart-pie text-danger"></i> RESELLER RESOURCE QUOTAS
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">Client Accounts (14 / 50)</span>
                                        <span class="fw-bold small text-dark">28.0% used</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 28%;" aria-valuenow="28.0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">Disk Space (45.2GB / 200GB)</span>
                                        <span class="fw-bold small text-dark">22.6% used</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 22.6%;" aria-valuenow="22.6" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">Monthly Bandwidth (120GB / 2TB)</span>
                                        <span class="fw-bold small text-dark">6.00% used</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 6%;" aria-valuenow="6.0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <!-- D. OpenClaw Managed Instance Features -->
        {elseif $serviceType eq "openclaw"}
            <div class="row g-4 mb-4">
                <div class="col-12">
                    <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-transparent py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                            <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                                <i class="ti ti-cpu text-danger"></i> MANAGED NODE TELEMETRY &amp; RESOURCES
                            </span>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2.5 py-1" style="font-size: 0.75rem;">
                                <i class="ti ti-point-filled me-1"></i> Online
                            </span>
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">vCPU Load (2 vCPUs)</span>
                                        <span class="fw-bold small text-dark">12.4% allocated</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 12.4%;" aria-valuenow="12.4" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">RAM Allocation (1.2GB / 4GB)</span>
                                        <span class="fw-bold small text-dark">30.0% used</span>
                                    </div>
                                    <div class="progress progress-thin mb-2">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 30%;" aria-valuenow="30.0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    {if $packagesupgrade}
                                        <a href="upgrade.php?type=package&amp;id={$id}" class="btn btn-outline-secondary btn-xs py-0.5 px-2 fw-semibold float-end" style="font-size: 0.75rem; border-radius: 6px;">
                                            <i class="ti ti-adjustments-alt me-1"></i> Scale RAM
                                        </a>
                                    {/if}
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="small text-muted fw-semibold">SSD Storage (4.8GB / 40GB)</span>
                                        <span class="fw-bold small text-dark">12.0% used</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar progress-bar-danger" role="progressbar" style="width: 12%;" aria-valuenow="12.0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-transparent py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                            <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                                <i class="ti ti-key text-danger"></i> INSTANCE ENDPOINT &amp; API KEYS
                            </span>
                            <button type="button" onclick="navigator.clipboard.writeText('https://{$domain|default:"claw-node-09.snbd.io"}/api/v1')" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                <i class="ti ti-copy me-1"></i> Copy Endpoint
                            </button>
                        </div>
                        <div class="card-body p-4">
                            <div class="p-3 mb-3 rounded border font-monospace small" style="background: var(--bg-elevated, #fafafa);">
                                Endpoint URL: <strong class="text-danger">https://{$domain|default:"claw-node-09.snbd.io"}/api/v1</strong>
                            </div>
                            
                            <div class="row text-center g-3 mb-3">
                                <div class="col-md-4">
                                    <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                        <div class="small text-muted fw-semibold mb-1">Status</div>
                                        <div class="fw-bold text-success"><i class="ti ti-check me-1"></i> Online (18ms)</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                        <div class="small text-muted fw-semibold mb-1">Region</div>
                                        <div class="fw-bold text-dark">BDIX (Dhaka)</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                        <div class="small text-muted fw-semibold mb-1">API Secret</div>
                                        <div class="fw-bold text-muted font-monospace">************************</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end gap-2">
                                <button type="button" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                    <i class="ti ti-refresh me-1"></i> Regenerate API Key
                                </button>
                                {if $modulechangepassword}
                                    <button type="button" onclick="jQuery('#password-tab').click()" class="btn btn-outline-secondary btn-sm fw-semibold" style="border-radius: 8px;">
                                        <i class="ti ti-key me-1"></i> Change Master Password
                                    </button>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <!-- E. Universal / Generic Hosting Features -->
        {else}
            <div class="card dash-card-clean border-0 shadow-sm mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-layout-grid text-danger"></i> QUICK ACTIONS &amp; SHORTCUTS
                    </span>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-6 col-sm-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Email" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-mail"></i>
                                <span>Email Accounts</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Filemanager" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-folder"></i>
                                <span>File Manager</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-3">
                            <a href="clientarea.php?action=productdetails&amp;id={$id}&amp;dosinglesignon=1&amp;app=Phpmyadmin" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-database"></i>
                                <span>Databases</span>
                            </a>
                        </div>
                        <div class="col-6 col-sm-3">
                            <a href="clientarea.php?action=domaindetails&amp;id={$id}" target="_blank" class="shortcut-card-item">
                                <i class="ti ti-dns"></i>
                                <span>DNS Management</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        {/if}

        {if $customfields}
            <div class="card dash-card-clean border-0 shadow-sm mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-list-details text-danger"></i> Additional Information
                    </span>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        {foreach from=$customfields item=field}
                            <div class="col-md-6 col-xl-4">
                                <div class="p-3 rounded border" style="background: var(--bg-elevated, #fafafa);">
                                    <div class="small text-muted fw-semibold">{$field.name}</div>
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
    </div>
    
    <!-- CHANGE PASSWORD TAB -->
    {if $modulechangepassword}
        <div class="tab-pane fade" id="tabPassword" role="tabpanel" aria-labelledby="password-tab">
            <div class="card dash-card-clean border-0 shadow-sm" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-transparent py-3 px-4" style="border-bottom: 1px solid var(--border-color, #e0e0e0);">
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

<script>
document.addEventListener("DOMContentLoaded", function() {
    const panels = document.querySelectorAll('.module-clientarea-wrap .card, .module-clientarea-wrap .panel, .module-clientarea-wrap > div');
    panels.forEach(panel => {
        const headerElement = panel.querySelector('.card-header, .panel-heading, h3');
        if (headerElement) {
            const headerText = headerElement.innerText.trim().toLowerCase();
            if (headerText.includes('quick create email') || headerText.includes('billing overview') || headerText.includes('usage statistics')) {
                panel.style.display = 'none';
            }
        }
    });
});
</script>
