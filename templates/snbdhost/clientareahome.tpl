<!-- ====== SCoped styles FOR DASHBOARD ====== -->
<style>
.dash-headline {
    font-size: 2.75rem;
    font-weight: 900;
    color: #111111;
    letter-spacing: -0.04em;
    line-height: 1.1;
    margin-bottom: 0.5rem;
}
.dash-headline-accent {
    color: #CC0000;
}
.dash-subhead {
    font-size: 1.05rem;
    color: #555555;
    font-weight: 500;
    margin-bottom: 2rem;
}
.btn-brand-clean {
    background: #CC0000 !important;
    color: #ffffff !important;
    border-radius: 50rem !important;
    padding: 0.75rem 1.5rem !important;
    font-size: 0.9rem !important;
    font-weight: 700 !important;
    border: none !important;
    box-shadow: 0 4px 14px rgba(204, 0, 0, 0.2) !important;
    transition: all 0.2s !important;
    display: inline-flex;
    align-items: center;
}
.btn-brand-clean:hover {
    background: #AA0000 !important;
    box-shadow: 0 6px 20px rgba(204, 0, 0, 0.3) !important;
    transform: translateY(-2px) !important;
    color: #ffffff !important;
}

/* Stat Cards */
.stat-card-clean {
    background: #ffffff !important;
    border: 1px solid #eeeeee !important;
    border-radius: 16px !important;
    box-shadow: 0 1px 3px rgba(0,0,0,0.02) !important;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1) !important;
}
.stat-card-clean:hover {
    transform: translateY(-3px) !important;
    box-shadow: 0 12px 30px rgba(0,0,0,0.06) !important;
    border-color: #dddddd !important;
}
.stat-card-clean .stat-value-clean {
    font-size: 2.25rem !important;
    font-weight: 800 !important;
    color: #111111 !important;
    letter-spacing: -0.03em !important;
    line-height: 1 !important;
}
.stat-card-clean .stat-label-clean {
    font-size: 0.75rem !important;
    font-weight: 700 !important;
    color: #888888 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.5px !important;
    margin-bottom: 0.5rem !important;
}
.stat-card-clean .stat-icon-clean {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
}
.stat-card-clean .badge-clean {
    display: inline-flex;
    align-items: center;
    padding: 0.35rem 0.85rem;
    border-radius: 50rem;
    font-size: 0.75rem;
    font-weight: 600;
}
.badge-clean-success { background: rgba(46, 125, 50, 0.08) !important; color: #2e7d32 !important; border: 1px solid rgba(46, 125, 50, 0.15) !important; }
.badge-clean-warning { background: rgba(230, 81, 0, 0.08) !important; color: #e65100 !important; border: 1px solid rgba(230, 81, 0, 0.15) !important; }
.badge-clean-danger  { background: rgba(198, 40, 40, 0.08) !important; color: #c62828 !important; border: 1px solid rgba(198, 40, 40, 0.15) !important; }
.badge-clean-info    { background: rgba(204, 0, 0, 0.08) !important; color: #CC0000 !important; border: 1px solid rgba(204, 0, 0, 0.15) !important; }

/* Quick Actions */
.btn-outline-clean {
    background: #f5f5f5 !important;
    border: 1px solid #f5f5f5 !important;
    border-radius: 50rem !important;
    padding: 0.6rem 1.25rem !important;
    font-size: 0.875rem !important;
    font-weight: 600 !important;
    color: #555555 !important;
    transition: all 0.2s !important;
    display: inline-flex;
    align-items: center;
    text-decoration: none !important;
}
.btn-outline-clean:hover {
    background: #CC0000 !important;
    border-color: #CC0000 !important;
    color: #ffffff !important;
    transform: translateY(-2px) !important;
}
.btn-outline-clean i {
    color: #777777;
    transition: color 0.2s;
}
.btn-outline-clean:hover i {
    color: #ffffff !important;
}

/* Premium Loyalty Card */
.loyalty-card-premium {
    background: linear-gradient(135deg, #0a0a0a 0%, #171717 50%, #0d0d0d 100%) !important;
    border: 1px solid rgba(255, 255, 255, 0.06) !important;
    border-radius: 20px !important;
    box-shadow: 0 15px 35px rgba(0,0,0,0.15) !important;
    overflow: hidden;
    position: relative;
}
.loyalty-card-premium::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(204, 0, 0, 0.1) 0%, transparent 70%);
    pointer-events: none;
}
.loyalty-progress-container {
    height: 8px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50rem;
    overflow: hidden;
}
.loyalty-progress-fill-premium {
    height: 100%;
    background: linear-gradient(90deg, #CC0000, #ff5b5b);
    border-radius: 50rem;
    box-shadow: 0 0 10px rgba(204, 0, 0, 0.5);
    animation: loyaltyFill 1.2s ease-out forwards;
}
@keyframes loyaltyFill {
    from { width: 0; }
}
.btn-loyalty-premium {
    background: rgba(255, 255, 255, 0.08) !important;
    border: 1px solid rgba(255, 255, 255, 0.1) !important;
    color: #ffffff !important;
    border-radius: 12px !important;
    padding: 0.75rem 1.25rem !important;
    font-weight: 600 !important;
    font-size: 0.8125rem !important;
    transition: all 0.2s !important;
    backdrop-filter: blur(5px);
    display: inline-flex;
    align-items: center;
    text-decoration: none !important;
}
.btn-loyalty-premium:hover {
    background: #ffffff !important;
    color: #111111 !important;
    transform: translateY(-2px) !important;
    box-shadow: 0 5px 15px rgba(255, 255, 255, 0.1) !important;
}

/* Dashboard Cards & Tables */
.dash-card-clean {
    background: #ffffff !important;
    border: 1px solid #eeeeee !important;
    border-radius: 16px !important;
    box-shadow: 0 1px 3px rgba(0,0,0,0.01) !important;
    overflow: hidden;
}
.dash-card-clean .card-header {
    background: #ffffff !important;
    border-bottom: 1px solid #eeeeee !important;
    padding: 1.25rem 1.5rem !important;
    font-weight: 700 !important;
    font-size: 0.95rem !important;
    color: #111111 !important;
}
.table-clean {
    margin-bottom: 0 !important;
}
.table-clean thead th {
    background-color: #fafafa !important;
    color: #666666 !important;
    font-weight: 700 !important;
    font-size: 0.75rem !important;
    text-transform: uppercase !important;
    letter-spacing: 0.5px !important;
    border-bottom: 1px solid #eeeeee !important;
    padding: 0.85rem 1.5rem !important;
}
.table-clean tbody td {
    padding: 1.1rem 1.5rem !important;
    border-bottom: 1px solid #f6f6f6 !important;
    font-size: 0.85rem !important;
    color: #333333 !important;
    font-weight: 500 !important;
}
.table-clean tbody tr:last-child td {
    border-bottom: none !important;
}
.table-clean tbody tr:hover td {
    background-color: #fafafa !important;
}
.btn-outline-table {
    background: transparent !important;
    border: 1px solid #e0e0e0 !important;
    color: #555555 !important;
    border-radius: 50rem !important;
    padding: 0.35rem 0.85rem !important;
    font-size: 0.75rem !important;
    font-weight: 600 !important;
    transition: all 0.2s !important;
    text-decoration: none !important;
    display: inline-flex;
    align-items: center;
}
.btn-outline-table:hover {
    border-color: #CC0000 !important;
    background-color: #fff5f5 !important;
    color: #CC0000 !important;
}

/* Announcements */
.announce-item-clean {
    padding: 1rem 0 !important;
    border-bottom: 1px solid #f6f6f6 !important;
}
.announce-item-clean:last-child {
    border-bottom: none !important;
    padding-bottom: 0 !important;
}
.announce-item-clean:first-child {
    padding-top: 0 !important;
}
.announce-title-clean {
    font-weight: 600 !important;
    font-size: 0.9rem !important;
    color: #222222 !important;
    line-height: 1.4 !important;
    transition: color 0.15s !important;
    text-decoration: none !important;
    display: block;
    margin-bottom: 0.25rem !important;
}
.announce-title-clean:hover {
    color: #CC0000 !important;
}
.announce-date-clean {
    font-size: 0.75rem !important;
    color: #888888 !important;
    font-weight: 500 !important;
}
.empty-state-clean {
    padding: 3rem 1.5rem !important;
    text-align: center !important;
}
.empty-state-clean i {
    font-size: 2.25rem !important;
    color: #cccccc !important;
    margin-bottom: 1rem !important;
}
.empty-state-clean p {
    font-size: 0.875rem !important;
    color: #888888 !important;
    margin-bottom: 0 !important;
}
</style>

<!-- ✦ UX Improvement Banner ✦ -->
<div id="snbd-ux-banner" style="
    background: linear-gradient(135deg, #CC0000 0%, #990000 100%);
    border-radius: 14px;
    padding: 1.1rem 1.5rem;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1.25rem;
    box-shadow: 0 4px 20px rgba(204,0,0,0.18);
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
        color:#CC0000;
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
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline">Welcome back, <span class="dash-headline-accent">{$clientsdetails.firstname}</span>.</h1>
        <p class="dash-subhead">Here's an overview of your account.</p>
    </div>
    <a href="cart.php" class="btn btn-brand-clean"><i class="fas fa-plus me-2"></i>Order New Service</a>
</div>

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

<!-- Loyalty Card (Premium Credit Card Aesthetics) -->
<div class="card loyalty-card-premium mb-5 overflow-hidden">
    <div class="card-body p-4 p-md-5">
        <div class="row align-items-center g-4">
            <!-- Icon wrapper with metallic glow -->
            <div class="col-md-auto d-flex align-items-center justify-content-center">
                <div style="
                    width: 76px; height: 76px;
                    background: rgba(255,255,255,0.06);
                    border: 1px solid rgba(255,255,255,0.1);
                    border-radius: 50%;
                    display: flex; align-items: center; justify-content: center;
                    font-size: 2.25rem; color: #CC0000;
                    box-shadow: 0 0 25px rgba(204, 0, 0, 0.25);
                    position: relative;
                ">
                    <i class="fas fa-trophy" style="background: linear-gradient(135deg, #ffffff 30%, #aaaaaa 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"></i>
                </div>
            </div>
            
            <!-- Main Tier description and status progression -->
            <div class="col text-white text-center text-md-start">
                {if $loyalty_data}
                    <h4 style="font-weight: 800; font-size: 1.35rem; color: #ffffff; letter-spacing: -0.02em; margin-bottom: 0.5rem; line-height:1.2;">
                        Loyalty Tier: <span style="background: linear-gradient(90deg, #ff5b5b, #CC0000); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">{$loyalty_data.tier}</span>
                    </h4>
                    <div class="d-flex align-items-center gap-2 justify-content-center justify-content-md-start mb-3 flex-wrap">
                        <span class="badge rounded-pill" style="background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: #ffffff; font-size: 0.75rem; font-weight: 600; padding: 0.35rem 0.85rem;">
                            <i class="fas fa-percentage me-1"></i>{$loyalty_data.discount} Lifetime Discount
                        </span>
                    </div>
                    
                    {if $loyalty_data.next_tier}
                        <div class="mt-2" style="max-width: 450px; margin: 0 auto; margin-left: 0;">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="small" style="color: #aaaaaa; font-weight: 500; font-size:0.8rem;">
                                    Progress to <strong class="text-white">{$loyalty_data.next_tier}</strong> ({$loyalty_data.next_discount} Off)
                                </span>
                                <span class="small fw-bold" style="color: #ff5b5b; font-size:0.8rem;">Almost there! 🚀</span>
                            </div>
                            <div class="loyalty-progress-container">
                                <div class="loyalty-progress-fill-premium" style="width: {if $loyalty_data.progress}{$loyalty_data.progress}%{else}40%{/if};"></div>
                            </div>
                        </div>
                    {else}
                        <p class="small mb-0" style="color: #aaaaaa; font-size:0.85rem;">You've reached the highest loyalty tier. Thank you for being a valued client! 🎉</p>
                    {/if}
                {else}
                    <h4 style="font-weight: 800; font-size: 1.35rem; color: #ffffff; letter-spacing: -0.02em; margin-bottom: 0.5rem; line-height:1.2;">
                        SNBD HOST Loyalty Program
                    </h4>
                    <p class="small mb-0" style="color: #aaaaaa; max-width: 550px; font-size:0.85rem; line-height:1.5;">
                        Unlock higher discounts and VIP perks automatically as you stay with us. Check your details or place new orders to fast-track your status!
                    </p>
                {/if}
            </div>
            
            <!-- CTA Button -->
            <div class="col-md-auto text-center text-md-end">
                <a href="index.php?m=loyaltymatrix" class="btn-loyalty-premium">
                    <i class="fas fa-chart-line me-2"></i>View Benefits
                </a>
            </div>
        </div>
    </div>
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
                            <a href="clientarea.php?action=productdetails&id={$product.id}" class="btn-outline-table">
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
<div class="row g-4 mb-4">
    <div class="col-lg-8">
        <div class="card dash-card-clean h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-file-invoice me-2" style="color: #CC0000;"></i>Recent Invoices</span>
                <a href="clientarea.php?action=invoices" class="btn-outline-table">View All</a>
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
                                <td class="fw-bold" style="color: #111111;">#{$invoice.invoicenum}</td>
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
