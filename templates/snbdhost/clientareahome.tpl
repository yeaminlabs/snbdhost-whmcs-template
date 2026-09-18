{* Dashboard views powered by centralized snbdhost-theme.css *}


{if !$clientsdetails.phonenumber || !$clientsdetails.address1 || $clientsdetails.phonenumber == '+00000000000' || $clientsdetails.address1 == 'Pending Completion'}
<!-- Verification Notification -->
<div class="alert alert-warning alert-dismissible fade show" role="alert" style="border-radius: 14px; background-color: #fff8e1; border: 1px solid #ffe082; color: #8f6d00; display: flex; align-items: center; gap: 15px; box-shadow: 0 4px 15px rgba(255, 193, 7, 0.15); margin-bottom: 1.5rem; padding: 1rem 1.5rem;">
    <div style="font-size: 1.75rem; color: #ffb300; flex-shrink: 0;">
        <i class="fas fa-exclamation-circle"></i>
    </div>
    <div style="flex: 1;">
        <h5 style="margin-bottom: 0.25rem; font-weight: 700; color: #8f6d00; font-size: 1rem;">Action Required: Complete Your Profile</h5>
        <div style="font-size: 0.9rem; line-height: 1.5;">This is a verification process (often required after Google Sign-In). We just need a few details like your address and phone number before you can make purchases. <a href="clientarea.php?action=details" style="color: #d32f2f; font-weight: 700; text-decoration: none; border-bottom: 1px dashed #d32f2f; margin-left: 0.5rem;">Update Profile Now <i class="fas fa-arrow-right" style="font-size: 0.75rem;"></i></a></div>
    </div>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" style="position: static; padding: 0; filter: opacity(0.5);"></button>
</div>


{/if}

<!-- Dashboard Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline">Welcome back, <span class="dash-headline-accent">{$clientsdetails.firstname}</span>.</h1>
        <p class="dash-subhead">Here's an overview of your account.</p>
    </div>
    <a href="cart.php" class="btn btn-brand-clean"><i class="fas fa-plus me-2"></i>Order New Service</a>
</div>

{if $showN8nDashboardPromo}
<!-- n8n Video Masterclass Guide Promotion Segment -->
<div id="n8n-dashboard-promo-segment" class="mb-4" style="display: none;">
    <div class="card border-0 shadow-sm" style="border-radius: 20px; background: linear-gradient(135deg, #1e0505 0%, #3a0808 50%, #200404 100%); color: #ffffff; border: 1px solid rgba(255, 68, 68, 0.35) !important; position: relative; overflow: hidden;">
        <div style="position: absolute; top: -40px; right: -40px; width: 250px; height: 250px; background: radial-gradient(circle, rgba(204, 0, 0, 0.3) 0%, transparent 70%); pointer-events: none;"></div>
        <div class="card-body p-4 position-relative" style="z-index: 1;">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                <div class="d-flex align-items-center gap-3" style="max-width: 750px;">
                    <div style="background: rgba(255, 255, 255, 0.12); width: 54px; height: 54px; border-radius: 16px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; border: 1px solid rgba(255,255,255,0.18);">
                        <i class="fas fa-play-circle" style="font-size: 1.8rem; color: #ff6666;"></i>
                    </div>
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="badge" style="background: #CC0000; color: #fff; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px; border-radius: 6px;">EXCLUSIVE FOR N8N CLIENTS</span>
                            <span class="text-white-50 small" style="font-size: 0.78rem;"><i class="fas fa-video me-1"></i>Free Video Masterclass Guide</span>
                        </div>
                        <h4 class="fw-bold text-white mb-1" style="font-size: 1.25rem;">{$n8nDashboardPromoTitle|default:'SNBD Host n8n Free Video Masterclass Guide'}</h4>
                        <p class="text-white-50 mb-0 small" style="font-size: 0.88rem; line-height: 1.5;">{$n8nDashboardPromoDesc|default:'আমাদের ফ্রি স্টেপ-বাই-স্টেপ ভিডিও গাইডের মাধ্যমে শিখুন n8n ওয়ার্কফ্লো অটোমেশন, ওয়েবহুক, এপিআই ইন্টিগ্রেশন এবং এআই এজেন্ট।'}</p>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2 ms-auto flex-wrap">
                    <a href="{$n8nDashboardPromoUrl|default:'https://snbdhost.com/learn/n8n-basic-to-advanced-in-bangla'}" target="_blank" class="btn text-white fw-bold px-4 py-2.5 d-inline-flex align-items-center gap-2" style="background: linear-gradient(135deg, #CC0000 0%, #aa0000 100%); border-radius: 12px; box-shadow: 0 6px 20px rgba(204,0,0,0.4); border: none; font-size: 0.9rem; text-decoration: none;">
                        <span>{$n8nDashboardPromoBtnText|default:'Watch Masterclass Guide'}</span>
                        <i class="fas fa-arrow-right" style="font-size: 0.8rem;"></i>
                    </a>
                    <button type="button" id="n8n-dash-promo-close-btn" class="btn btn-sm text-white-50 p-2 text-decoration-none" title="Dismiss Segment" style="font-size: 1.2rem; line-height: 1; background: transparent; border: none;">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    var promoVersion = "{$n8nDashboardPromoVersion|default:'v1'}";
    var storageKey = "snbd_n8n_dash_promo_dismissed_" + promoVersion;
    var segment = document.getElementById("n8n-dashboard-promo-segment");
    
    if (segment && !localStorage.getItem(storageKey)) {
        segment.style.display = "block";
    }
    
    var closeBtn = document.getElementById("n8n-dash-promo-close-btn");
    if (closeBtn) {
        closeBtn.addEventListener("click", function() {
            localStorage.setItem(storageKey, "true");
            if (segment) segment.style.display = "none";
        });
    }
});
</script>
{/if}

{if $open_tickets || $clientsstats.numunpaidinvoices > 0}
<!-- Action Required Feed -->
<div class="card dash-card-clean mb-4 border-danger-subtle" style="border-color: rgba(204, 0, 0, 0.25) !important; background: rgba(204, 0, 0, 0.01) !important; border-radius: 12px; box-shadow: 0 4px 20px rgba(204, 0, 0, 0.04);">
    <div class="card-header d-flex justify-content-between align-items-center" style="background: rgba(204, 0, 0, 0.03) !important; border-bottom: 1px solid rgba(204, 0, 0, 0.08);">
        <span class="text-danger fw-bold"><i class="fas fa-exclamation-triangle me-2"></i>Action Required</span>
    </div>
    <div class="card-body p-0">
        <ul class="list-group list-group-flush" style="border-radius: 0 0 12px 12px; overflow: hidden;">
            <!-- Unpaid/Overdue Invoices -->
            {foreach key=num item=invoice from=$invoices}
                {if $invoice.status eq "Unpaid" || $invoice.status eq "Overdue"}
                <li class="list-group-item d-flex justify-content-between align-items-center p-3 bg-transparent" style="border-bottom: 1px solid rgba(204, 0, 0, 0.05);">
                    <div class="d-flex align-items-center gap-3">
                        <span class="badge-clean badge-clean-danger d-inline-flex align-items-center justify-content-center" style="width: 38px; height: 38px; border-radius: 8px; font-size: 1rem;"><i class="fas fa-file-invoice-dollar"></i></span>
                        <div>
                            <div class="fw-bold" style="color: #111111; font-size: 0.88rem;">Invoice {if $invoice.invoicenum|strpos:'#' === 0}{$invoice.invoicenum}{else}#{$invoice.invoicenum}{/if} is Unpaid</div>
                            <div class="text-secondary small mt-0.5">Due date: {$invoice.datedue} • Total: <span class="fw-semibold text-dark">{$invoice.total}</span></div>
                        </div>
                    </div>
                    <a href="viewinvoice.php?id={$invoice.id}" class="btn btn-sm btn-brand-clean py-1.5 px-3" style="font-size: 0.75rem !important; border-radius: 8px !important; box-shadow: none !important; display: inline-flex; align-items: center; font-weight: 600;">Pay Invoice</a>
                </li>
                {/if}
            {/foreach}
            
            <!-- Open Support Tickets -->
            {foreach item=ticket from=$open_tickets}
            <li class="list-group-item d-flex justify-content-between align-items-center p-3 bg-transparent" style="border-bottom: 1px solid rgba(204, 0, 0, 0.05);">
                <div class="d-flex align-items-center gap-3">
                    <span class="badge-clean d-inline-flex align-items-center justify-content-center" style="width: 38px; height: 38px; border-radius: 8px; font-size: 1rem; background: rgba(230, 81, 0, 0.08); color: #e65100; border: 1px solid rgba(230, 81, 0, 0.15);"><i class="fas fa-life-ring"></i></span>
                    <div>
                        <div class="fw-bold" style="color: #111111; font-size: 0.88rem;">Support Ticket #{$ticket.tid}: {$ticket.title}</div>
                        <div class="text-secondary small mt-0.5">Last reply: {$ticket.lastreply} • Status: <span class="badge bg-warning text-dark px-2 py-1" style="font-size: 0.7rem; border-radius: 4px;">{$ticket.status}</span></div>
                    </div>
                </div>
                <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="btn-outline-table py-1.5 px-3" style="font-size: 0.75rem !important; border-radius: 8px !important; font-weight: 600; display: inline-flex; align-items: center;">View Ticket</a>
            </li>
            {/foreach}
        </ul>
    </div>
</div>
{/if}

<!-- Stat Cards -->
<div class="row g-3 mb-5">
    <div class="col-sm-6 col-xl-3">
        <a href="clientarea.php?action=products" class="text-decoration-none">
            <div class="card stat-card-clean h-100">
                <div class="card-body d-flex justify-content-between align-items-start p-4">
                    <div class="d-flex flex-column h-100 justify-content-between">
                        <div>
                            <div class="stat-label-clean">Active Services</div>
                            <div class="stat-value-clean mt-1">{$clientsstats.productsnumactive|default:0}</div>
                        </div>
                        <div class="mt-3">
                            <span class="badge-clean badge-clean-success">Running</span>
                        </div>
                    </div>
                    <div class="stat-icon-clean" style="background: rgba(46, 125, 50, 0.08); color: #2e7d32;"><i class="fas fa-cube"></i></div>
                </div>
            </div>
        </a>
    </div>
    <div class="col-sm-6 col-xl-3">
        <a href="clientarea.php?action=invoices" class="text-decoration-none">
            <div class="card stat-card-clean h-100">
                <div class="card-body d-flex justify-content-between align-items-start p-4">
                    <div class="d-flex flex-column h-100 justify-content-between">
                        <div>
                            <div class="stat-label-clean">Open Invoices</div>
                            <div class="stat-value-clean mt-1">{$clientsstats.numunpaidinvoices|default:0}</div>
                        </div>
                        <div class="mt-3">
                            {if $clientsstats.numunpaidinvoices > 0}
                                <span class="badge-clean badge-clean-warning">Needs Attention</span>
                            {else}
                                <span class="badge-clean badge-clean-success">All Paid</span>
                            {/if}
                        </div>
                    </div>
                    <div class="stat-icon-clean" style="background: rgba(230, 81, 0, 0.08); color: #e65100;"><i class="fas fa-file-invoice-dollar"></i></div>
                </div>
            </div>
        </a>
    </div>
    <div class="col-sm-6 col-xl-3">
        <a href="clientarea.php?action=invoices" class="text-decoration-none">
            <div class="card stat-card-clean h-100">
                <div class="card-body d-flex justify-content-between align-items-start p-4">
                    <div class="d-flex flex-column h-100 justify-content-between">
                        <div>
                            <div class="stat-label-clean">Unpaid Balance</div>
                            <div class="stat-value-clean mt-1" style="font-size:1.4rem !important; line-height:1.6 !important;">{$clientsstats.dueinvoicesbalance|default:"$0.00"}</div>
                        </div>
                        <div class="mt-3">
                            {if $clientsstats.numunpaidinvoices > 0}
                                <span class="badge-clean badge-clean-danger">Pending</span>
                            {else}
                                <span class="badge-clean badge-clean-success">Settled</span>
                            {/if}
                        </div>
                    </div>
                    <div class="stat-icon-clean" style="background: rgba(198, 40, 40, 0.08); color: #c62828;"><i class="fas fa-wallet"></i></div>
                </div>
            </div>
        </a>
    </div>
    <div class="col-sm-6 col-xl-3">
        <a href="supporttickets.php" class="text-decoration-none">
            <div class="card stat-card-clean h-100">
                <div class="card-body d-flex justify-content-between align-items-start p-4">
                    <div class="d-flex flex-column h-100 justify-content-between">
                        <div>
                            <div class="stat-label-clean">Open Tickets</div>
                            <div class="stat-value-clean mt-1">{$clientsstats.numactivetickets|default:0}</div>
                        </div>
                        <div class="mt-3">
                            {if $clientsstats.numactivetickets > 0}
                                <span class="badge-clean badge-clean-info">Support Open</span>
                            {else}
                                <span class="badge-clean badge-clean-success">No Tickets</span>
                            {/if}
                        </div>
                    </div>
                    <div class="stat-icon-clean" style="background: rgba(204, 0, 0, 0.08); color: #CC0000;"><i class="fas fa-life-ring"></i></div>
                </div>
            </div>
        </a>
    </div>
</div>

<!-- Quick Actions -->
<div class="mb-5 d-flex gap-2 flex-wrap">
    <a href="submitticket.php" class="btn-outline-clean"><i class="fas fa-headset me-2"></i>Open Ticket</a>
    <a href="clientarea.php?action=invoices" class="btn-outline-clean"><i class="fas fa-receipt me-2"></i>View Invoices</a>
    <a href="clientarea.php?action=products" class="btn-outline-clean"><i class="fas fa-server me-2"></i>My Services</a>
    <a href="affiliates.php" class="btn-outline-clean"><i class="fas fa-users me-2"></i>Affiliates</a>
    <a href="clientarea.php?action=addfunds" class="btn-outline-clean"><i class="fas fa-wallet me-2"></i>Add Funds</a>
</div>


<!-- WHMCS Addon Widgets -->
{if $widgets}
<div class="row g-3 mb-5">
    {foreach from=$widgets item=widget}
    {if $widget.content}
    <div class="col-md-6 col-xl-4">
        <div class="card h-100 dash-card-clean">
            <div class="card-header d-flex align-items-center gap-2">
                <span class="fw-semibold d-flex align-items-center gap-2">
                    {if $widget.icon}<i class="{$widget.icon}" style="color: #CC0000;"></i>{else}<i class="fas fa-th-large" style="color: #CC0000;"></i>{/if}
                    {$widget.title}
                </span>
            </div>
            <div class="card-body">
                {$widget.content}
            </div>
        </div>
    </div>
    {/if}
    {/foreach}
</div>
{/if}

<!-- Active Products / Services -->
{if $homepageproducts}
<div class="card dash-card-clean mb-5">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span><i class="fas fa-server me-2" style="color: #CC0000;"></i>Your Active Products &amp; Services</span>
        <a href="clientarea.php?action=products" class="btn-outline-table">My Services</a>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover table-clean align-middle mb-0">
                <thead>
                    <tr>
                        <th style="width:120px;">Status</th>
                        <th>Product / Service</th>
                        <th>Domain / Label</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach key=k item=product from=$homepageproducts}
                    <tr>
                        <td>
                            {if $product.status eq "Active"}
                                <span class="badge-clean badge-clean-success">Active</span>
                            {elseif $product.status eq "Pending"}
                                <span class="badge-clean badge-clean-warning">Pending</span>
                            {elseif $product.status eq "Suspended"}
                                <span class="badge-clean badge-clean-danger">Suspended</span>
                            {else}
                                <span class="badge bg-secondary">{$product.status}</span>
                            {/if}
                        </td>
                        <td class="fw-bold" style="color: #111111;">{$product.name}</td>
                        <td class="text-secondary small">{$product.domain}</td>
                        <td class="text-end">
                            <a href="clientarea.php?action=productdetails&id={$product.id}" class="btn btn-brand-clean btn-sm text-decoration-none" style="font-weight: 600; border-radius: 8px; padding: 0.4rem 0.8rem; font-size: 0.85rem; display: inline-flex; align-items: center;">
                                <i class="ti ti-settings me-1"></i>Manage Service
                            </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>
{/if}

<!-- Recent Invoices + Announcements -->
<div class="row g-4 mb-4">
    <div class="col-lg-8">
        <div class="card dash-card-clean h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-file-invoice me-2" style="color: #CC0000;"></i>Recent Invoices</span>
                <div class="d-flex gap-2">
                    {if $clientsstats.numunpaidinvoices > 0}
                    <a href="clientarea.php?action=masspay&all=true" class="btn btn-sm btn-brand-clean py-1 px-3" style="font-size: 0.75rem !important; border-radius: 8px !important; box-shadow: none !important; display: inline-flex; align-items: center;"><i class="fas fa-credit-card me-1"></i>Pay All Unpaid ({$clientsstats.numunpaidinvoices})</a>
                    {/if}
                    <a href="clientarea.php?action=invoices" class="btn-outline-table">View All</a>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-clean align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Invoice #</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach key=num item=invoice from=$invoices}
                            <tr>
                                <td class="fw-bold" style="color: #111111;">{if $invoice.invoicenum|strpos:'#' === 0}{$invoice.invoicenum}{else}#{$invoice.invoicenum}{/if}</td>
                                <td class="text-secondary">{$invoice.datecreated}</td>
                                <td class="fw-bold" style="color: #111111;">{$invoice.total}</td>
                                <td>
                                    {if $invoice.status eq "Paid"}
                                        <span class="badge-clean badge-clean-success">Paid</span>
                                    {elseif $invoice.status eq "Unpaid"}
                                        <span class="badge-clean badge-clean-warning">Unpaid</span>
                                    {elseif $invoice.status eq "Overdue"}
                                        <span class="badge-clean badge-clean-danger">Overdue</span>
                                    {else}
                                        <span class="badge bg-secondary">{$invoice.status}</span>
                                    {/if}
                                </td>
                                <td class="text-end">
                                    <a href="viewinvoice.php?id={$invoice.id}" class="btn-outline-table">
                                        <i class="fas fa-eye me-1"></i>View
                                    </a>
                                </td>
                            </tr>
                            {foreachelse}
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state-clean">
                                        <i class="fas fa-file-invoice d-block"></i>
                                        <p>No recent invoices found.</p>
                                        <a href="clientarea.php?action=invoices" class="btn-outline-table mt-3">View All Invoices</a>
                                    </div>
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card dash-card-clean h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-newspaper me-2" style="color: #CC0000;"></i>Announcements</span>
                <a href="announcements.php" class="btn-outline-table">View All</a>
            </div>
            <div class="card-body d-flex flex-column gap-3 p-4">
                {if $announcements}
                    {foreach key=num item=announcement from=$announcements}
                    {if $num < 5}
                    <div class="announce-item-clean">
                        <a href="announcements.php?id={$announcement.id}" class="announce-title-clean">
                            {$announcement.title}
                        </a>
                        <div class="announce-date-clean">
                            <i class="far fa-calendar-alt me-1"></i>{$announcement.date}
                        </div>
                    </div>
                    {/if}
                    {foreachelse}
                    <div class="empty-state-clean">
                        <i class="fas fa-newspaper d-block"></i>
                        <p>No announcements at this time.</p>
                    </div>
                    {/foreach}
                {else}
                    <div class="empty-state-clean">
                        <i class="fas fa-newspaper d-block"></i>
                        <p>No announcements at this time.</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>
