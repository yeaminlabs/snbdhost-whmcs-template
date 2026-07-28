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

        {if $customfields}
            <div class="card dash-card-clean border-0 mb-4" style="border-radius: 16px; background: var(--bg-surface, #ffffff); border: 1px solid rgba(204,0,0,0.12) !important; box-shadow: 0 6px 18px rgba(204,0,0,0.05);">
                <div class="card-header py-3 px-4" style="background: linear-gradient(to right, rgba(204,0,0,0.02), transparent); border-bottom: 1px solid rgba(204,0,0,0.08);">
                    <span class="fw-bold d-flex align-items-center gap-2" style="font-size: 1.05rem;">
                        <i class="ti ti-list-details text-danger"></i> Additional Information
                    </span>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        {foreach from=$customfields item=field}
                            <div class="col-md-6 col-xl-4">
                                <div class="p-3 rounded" style="background: #fffafa; border: 1px solid rgba(204,0,0,0.08);">
                                    <div class="small text-muted fw-semibold">{$field.name}</div>
                                    <div class="text-dark fw-bold mt-1" style="font-size: 0.95rem;">{$field.value|default:"-"}</div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                </div>
            </div>
        {/if}

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
