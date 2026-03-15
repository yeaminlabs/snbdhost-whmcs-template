<!-- ✦ UX Improvement Banner ✦ -->
<div id="snbd-ux-banner" style="
    background: linear-gradient(135deg, #e53935 0%, #c62828 55%, #b71c1c 100%);
    border-radius: 14px;
    padding: 1rem 1.4rem;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    box-shadow: 0 4px 20px rgba(229,57,53,0.22);
    position: relative;
    overflow: hidden;
">
    <!-- subtle shimmer overlay -->
    <div style="
        position:absolute; inset:0;
        background: linear-gradient(105deg, rgba(255,255,255,0.08) 0%, transparent 60%);
        pointer-events:none;
    "></div>

    <!-- Icon -->
    <div style="
        flex-shrink:0;
        width:42px; height:42px;
        background: rgba(255,255,255,0.18);
        border-radius: 50%;
        display:flex; align-items:center; justify-content:center;
        font-size:1.2rem; color:#fff;
    ">
        <i class="fas fa-magic"></i>
    </div>

    <!-- Text -->
    <div style="flex:1; min-width:0;">
        <div style="font-weight:700; font-size:0.9375rem; color:#fff; line-height:1.3; margin-bottom:0.2rem;">
            ✨ We're enhancing your experience!
        </div>
        <div style="font-size:0.8125rem; color:rgba(255,255,255,0.88); line-height:1.5;">
            We're working hard to bring you a brand-new modern dashboard. If you notice anything
            not working as expected, please don't hesitate to reach out — we'd love to hear from you.
        </div>
    </div>

    <!-- CTA -->
    <a href="submitticket.php" style="
        flex-shrink:0;
        background:#fff;
        color:#e53935;
        font-weight:700;
        font-size:0.8125rem;
        border-radius:50rem;
        padding:0.45rem 1.15rem;
        text-decoration:none;
        white-space:nowrap;
        transition: box-shadow 0.15s, transform 0.15s;
        box-shadow: 0 2px 8px rgba(0,0,0,0.12);
        display:inline-block;
    "
    onmouseover="this.style.boxShadow='0 4px 14px rgba(0,0,0,0.18)';this.style.transform='translateY(-1px)'"
    onmouseout="this.style.boxShadow='0 2px 8px rgba(0,0,0,0.12)';this.style.transform='translateY(0)'">
        <i class="fas fa-headset me-1"></i> Contact Us
    </a>

    <!-- Dismiss -->
    <button onclick="
        document.getElementById('snbd-ux-banner').style.display='none';
        try { sessionStorage.setItem('snbd_ux_banner_dismissed','1'); } catch(e) {}
    " style="
        flex-shrink:0;
        background:rgba(255,255,255,0.18);
        border:none; cursor:pointer;
        color:#fff; border-radius:50%;
        width:28px; height:28px;
        display:flex; align-items:center; justify-content:center;
        font-size:0.85rem;
        transition: background 0.15s;
        padding:0;
    "
    onmouseover="this.style.background='rgba(255,255,255,0.28)'"
    onmouseout="this.style.background='rgba(255,255,255,0.18)'"
    title="Dismiss">
        <i class="fas fa-times"></i>
    </button>
</div>
<script>
(function(){
    try {
        if (sessionStorage.getItem('snbd_ux_banner_dismissed') === '1') {
            var b = document.getElementById('snbd-ux-banner');
            if (b) b.style.display = 'none';
        }
    } catch(e) {}
})();
</script>

<!-- Dashboard Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h4 fw-bold mb-1">Welcome back, {$clientsdetails.firstname}</h1>
        <p class="text-secondary small mb-0">Here's an overview of your account.</p>
    </div>
    <a href="cart.php" class="btn btn-brand"><i class="fas fa-plus me-2"></i>Order Service</a>
</div>

<!-- Stat Cards -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <a href="clientarea.php?action=products" class="text-decoration-none">
            <div class="card stat-card h-100">
                <div class="card-body d-flex justify-content-between align-items-start">
                    <div>
                        <div class="stat-label mb-1">Active Services</div>
                        <div class="stat-value">{$clientsstats.productsnumactive|default:0}</div>
                        <span class="badge bg-success mt-2">Active</span>
                    </div>
                    <div class="stat-icon icon-services"><i class="fas fa-cube"></i></div>
                </div>
            </div>
        </a>
    </div>
    <div class="col-sm-6 col-xl-3">
        <a href="clientarea.php?action=invoices" class="text-decoration-none">
            <div class="card stat-card h-100">
                <div class="card-body d-flex justify-content-between align-items-start">
                    <div>
                        <div class="stat-label mb-1">Open Invoices</div>
                        <div class="stat-value">{$clientsstats.numunpaidinvoices|default:0}</div>
                        {if $clientsstats.numunpaidinvoices > 0}
                            <span class="badge bg-warning mt-2">Needs Attention</span>
                        {else}
                            <span class="badge bg-success mt-2">All Clear</span>
                        {/if}
                    </div>
                    <div class="stat-icon icon-invoices"><i class="fas fa-file-invoice-dollar"></i></div>
                </div>
            </div>
        </a>
    </div>
    <div class="col-sm-6 col-xl-3">
        <a href="clientarea.php?action=invoices" class="text-decoration-none">
            <div class="card stat-card h-100">
                <div class="card-body d-flex justify-content-between align-items-start">
                    <div>
                        <div class="stat-label mb-1">Unpaid Balance</div>
                        <div class="stat-value" style="font-size:1.25rem;">{$clientsstats.dueinvoicesbalance|default:"$0.00"}</div>
                        {if $clientsstats.numunpaidinvoices > 0}
                            <span class="badge bg-danger mt-2">Pending</span>
                        {else}
                            <span class="badge bg-success mt-2">Settled</span>
                        {/if}
                    </div>
                    <div class="stat-icon icon-balance"><i class="fas fa-wallet"></i></div>
                </div>
            </div>
        </a>
    </div>
    <div class="col-sm-6 col-xl-3">
        <a href="supporttickets.php" class="text-decoration-none">
            <div class="card stat-card h-100">
                <div class="card-body d-flex justify-content-between align-items-start">
                    <div>
                        <div class="stat-label mb-1">Open Tickets</div>
                        <div class="stat-value">{$clientsstats.numactivetickets|default:0}</div>
                        {if $clientsstats.numactivetickets > 0}
                            <span class="badge bg-info mt-2">In Progress</span>
                        {else}
                            <span class="badge bg-success mt-2">All Good</span>
                        {/if}
                    </div>
                    <div class="stat-icon icon-tickets"><i class="fas fa-life-ring"></i></div>
                </div>
            </div>
        </a>
    </div>
</div>

<!-- Quick Actions -->
<div class="mb-4 d-flex gap-2 flex-wrap">
    <a href="submitticket.php" class="btn btn-outline-custom"><i class="fas fa-headset me-2"></i>Open Ticket</a>
    <a href="clientarea.php?action=invoices" class="btn btn-outline-custom"><i class="fas fa-receipt me-2"></i>View Invoices</a>
    <a href="clientarea.php?action=products" class="btn btn-outline-custom"><i class="fas fa-server me-2"></i>My Services</a>
    <a href="affiliates.php" class="btn btn-outline-custom"><i class="fas fa-users me-2"></i>Affiliates</a>
    <a href="clientarea.php?action=addfunds" class="btn btn-outline-custom"><i class="fas fa-wallet me-2"></i>Add Funds</a>
</div>

<!-- ================================================================
     LOYALTY CARD — full-width horizontal premium design
     ================================================================ -->
<div class="card mb-4 overflow-hidden" style="border:none; box-shadow: 0 4px 24px rgba(229,57,53,0.13);">
    <div class="row g-0" style="min-height:130px;">

        <!-- ── Left accent panel ── -->
        <div class="col-auto d-flex flex-column align-items-center justify-content-center px-4"
             style="background: linear-gradient(160deg, #e53935 0%, #b71c1c 100%); min-width:130px; position:relative; overflow:hidden;">
            <!-- shimmer -->
            <div style="position:absolute;inset:0;background:linear-gradient(120deg,rgba(255,255,255,0.12) 0%,transparent 70%);pointer-events:none;"></div>
            <!-- sparkles -->
            <div style="position:absolute;top:10px;right:12px;font-size:0.6rem;color:rgba(255,255,255,0.4);">✦ ✦</div>
            <div style="position:absolute;bottom:12px;left:10px;font-size:0.55rem;color:rgba(255,255,255,0.3);">✦</div>

            <div class="mb-2" style="
                width:52px;height:52px;
                background:rgba(255,255,255,0.18);
                border-radius:50%;
                display:flex;align-items:center;justify-content:center;
                font-size:1.5rem;color:#fff;
                box-shadow:0 0 0 6px rgba(255,255,255,0.08);
            ">
                <i class="fas fa-trophy"></i>
            </div>
            <div style="font-size:0.65rem;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;color:rgba(255,255,255,0.75);">Loyalty</div>
            <div style="font-size:0.65rem;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;color:rgba(255,255,255,0.75);">Status</div>
        </div>

        <!-- ── Main content ── -->
        <div class="col d-flex flex-column justify-content-center px-4 py-3"
             style="background:#fff;">

            {if $loyalty_data}

                <div class="d-flex align-items-center gap-3 mb-2 flex-wrap">
                    <!-- Tier badge -->
                    <span style="
                        background:linear-gradient(135deg,#e53935,#b71c1c);
                        color:#fff; font-weight:700; font-size:0.8rem;
                        padding:0.3rem 1rem; border-radius:50rem;
                        display:inline-flex; align-items:center; gap:0.4rem;
                        box-shadow:0 3px 10px rgba(229,57,53,0.3);
                        white-space:nowrap;
                    ">
                        <i class="fas fa-star" style="font-size:0.7rem;"></i>
                        {$loyalty_data.tier}
                    </span>
                    <span class="badge rounded-pill" style="background:rgba(229,57,53,0.1);color:#c62828;font-size:0.8rem;font-weight:600;padding:0.35rem 0.9rem;">
                        <i class="fas fa-tag me-1"></i>{$loyalty_data.discount} OFF
                    </span>
                </div>

                {if $loyalty_data.next_tier}
                <div class="mb-1">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <span class="small text-secondary">
                            Progress to <strong style="color:#1a1a1a;">{$loyalty_data.next_tier}</strong>
                            {if $loyalty_data.next_discount}
                                <span class="ms-1 badge rounded-pill" style="background:rgba(100,100,100,0.08);color:#666;font-size:0.7rem;">{$loyalty_data.next_discount} OFF</span>
                            {/if}
                        </span>
                        <span class="small fw-semibold" style="color:#e53935;">Keep going! 🚀</span>
                    </div>
                    <!-- animated progress bar -->
                    <div style="height:8px;background:#f0f0f0;border-radius:50rem;overflow:hidden;">
                        <div class="loyalty-progress-fill" style="
                            height:100%;
                            background:linear-gradient(90deg,#e53935,#ff6f60);
                            border-radius:50rem;
                            transition:width 1.2s cubic-bezier(.4,0,.2,1);
                            box-shadow:0 0 8px rgba(229,57,53,0.4);
                        "></div>
                    </div>
                </div>
                {else}
                <p class="small text-secondary mb-0">You've reached the top tier. Thank you for your loyalty! 🎉</p>
                {/if}

            {else}
                <!-- No data state -->
                <div class="d-flex align-items-center gap-3">
                    <div>
                        <div class="fw-bold mb-1" style="font-size:0.9375rem;color:#1a1a1a;">Earn Rewards with Every Purchase</div>
                        <p class="small text-secondary mb-0">Stay with us and unlock exclusive discounts through our Loyalty Program. Check your tier and see how close you are to your next reward.</p>
                    </div>
                </div>
            {/if}
        </div>

        <!-- ── Right CTA ── -->
        <div class="col-auto d-flex align-items-center justify-content-center px-4"
             style="background:#fafafa;border-left:1px solid #f0f0f0;">
            <a href="index.php?m=loyaltymatrix"
               class="btn d-flex flex-column align-items-center gap-1"
               style="
                   background:linear-gradient(135deg,#e53935,#b71c1c);
                   color:#fff; font-weight:600; font-size:0.8125rem;
                   border-radius:12px; padding:0.75rem 1.25rem;
                   text-decoration:none; min-width:110px;
                   box-shadow:0 4px 14px rgba(229,57,53,0.3);
                   transition:all 0.2s;
               "
               onmouseover="this.style.transform='translateY(-2px)';this.style.boxShadow='0 6px 20px rgba(229,57,53,0.4)'"
               onmouseout="this.style.transform='';this.style.boxShadow='0 4px 14px rgba(229,57,53,0.3)'">
                <i class="fas fa-chart-line" style="font-size:1.2rem;"></i>
                View Journey
            </a>
        </div>

    </div>
</div>

<!-- ── WHMCS Addon Widgets (Sitejet, etc.) below loyalty if present ── -->
{if $widgets}
<div class="row g-3 mb-4">
    {foreach from=$widgets item=widget}
    {if $widget.content}
    <div class="col-md-6 col-xl-4">
        <div class="card h-100 dash-widget-card">
            <div class="card-header d-flex align-items-center gap-2">
                <span class="fw-semibold d-flex align-items-center gap-2">
                    {if $widget.icon}<i class="{$widget.icon}"></i>{else}<i class="fas fa-th-large"></i>{/if}
                    {$widget.title}
                </span>
            </div>
            <div class="card-body dash-widget-body">
                {$widget.content}
            </div>
        </div>
    </div>
    {/if}
    {/foreach}
</div>
{/if}


<!-- Active Products / Services (WHMCS built-in $homepageproducts) -->
{if $homepageproducts}
<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span><i class="fas fa-server me-2"></i>Your Active Products &amp; Services</span>
        <a href="clientarea.php?action=products" class="btn btn-sm btn-outline-custom">My Services</a>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover table-sm align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th style="width:90px;">Status</th>
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
                                <span class="badge bg-success"><i class="fas fa-circle me-1" style="font-size:6px;vertical-align:middle;"></i>Active</span>
                            {elseif $product.status eq "Pending"}
                                <span class="badge bg-warning">Pending</span>
                            {elseif $product.status eq "Suspended"}
                                <span class="badge bg-danger">Suspended</span>
                            {else}
                                <span class="badge bg-secondary">{$product.status}</span>
                            {/if}
                        </td>
                        <td class="fw-semibold">{$product.name}</td>
                        <td class="text-secondary small">{$product.domain}</td>
                        <td class="text-end">
                            <a href="clientarea.php?action=productdetails&id={$product.id}" class="btn btn-sm btn-outline-custom py-0 px-2">
                                <i class="fas fa-cog me-1"></i>Manage
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
<div class="row g-4">
    <div class="col-lg-8">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-file-invoice me-2"></i>Recent Invoices</span>
                <a href="clientarea.php?action=invoices" class="btn btn-sm btn-outline-custom">View All</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-sm mb-0">
                        <thead class="table-dark">
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
                                <td><strong>#{$invoice.invoicenum}</strong></td>
                                <td class="text-secondary">{$invoice.datecreated}</td>
                                <td class="fw-semibold">{$invoice.total}</td>
                                <td>
                                    {if $invoice.status eq "Paid"}
                                        <span class="badge bg-success">Paid</span>
                                    {elseif $invoice.status eq "Unpaid"}
                                        <span class="badge bg-warning">Unpaid</span>
                                    {elseif $invoice.status eq "Overdue"}
                                        <span class="badge bg-danger">Overdue</span>
                                    {else}
                                        <span class="badge bg-secondary">{$invoice.status}</span>
                                    {/if}
                                </td>
                                <td class="text-end">
                                    <a href="viewinvoice.php?id={$invoice.id}" class="btn btn-sm btn-outline-custom py-0 px-2">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </td>
                            </tr>
                            {foreachelse}
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <i class="fas fa-file-invoice d-block"></i>
                                        <p>No recent invoices. They will appear here once you have invoices.</p>
                                        <a href="clientarea.php?action=invoices" class="btn btn-sm btn-outline-custom mt-2">View All Invoices</a>
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
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-newspaper me-2"></i>News &amp; Announcements</span>
                <a href="announcements.php" class="btn btn-sm btn-outline-custom">View All</a>
            </div>
            <div class="card-body d-flex flex-column gap-3 p-3">
                {if $announcements}
                    {foreach key=num item=announcement from=$announcements}
                    {if $num < 5}
                    <div class="announce-item">
                        <a href="announcements.php?id={$announcement.id}" class="announce-title">
                            {$announcement.title}
                        </a>
                        <div class="announce-date">
                            <i class="far fa-calendar-alt me-1"></i>{$announcement.date}
                        </div>
                    </div>
                    {/if}
                    {foreachelse}
                    <div class="empty-state">
                        <i class="fas fa-newspaper d-block"></i>
                        <p>No announcements at this time.</p>
                    </div>
                    {/foreach}
                {else}
                    <div class="empty-state">
                        <i class="fas fa-newspaper d-block"></i>
                        <p>No announcements at this time.</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>
