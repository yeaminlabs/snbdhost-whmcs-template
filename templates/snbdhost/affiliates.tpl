<!-- ====== AFFILIATES DASHBOARD — SNBD HOST BLUEPRINT DESIGN ====== -->
{if $inactive}
    {include file="$template/includes/alert.tpl" type="danger" msg="{lang key='affiliatesdisabled'}" textcenter=true}
{else}
    {include file="$template/includes/flashmessage.tpl"}
    {if $withdrawrequestsent}
        <div class="alert alert-success d-flex align-items-center gap-2 mb-4" style="border-radius: 12px; font-weight: 500;">
            <i class="fas fa-check-circle text-success" style="font-size: 1.15rem;"></i>
            {lang key='affiliateswithdrawalrequestsuccessful'}
        </div>
    {/if}

    <!-- Raw stats variables for JS validation -->
    <input type="hidden" id="rawPending"   value="{$pendingcommissions}">
    <input type="hidden" id="rawAvailable" value="{$balance}">
    <input type="hidden" id="rawWithdrawn" value="{$withdrawn}">
    <input type="hidden" id="valClicks"    value="{$visitors}">
    <input type="hidden" id="valSignups"   value="{$signups}">

    <style>
    /* ── SNBD HOST Affiliates Stylesheet ── */
    .aff-wrap {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 0 3rem;
        font-family: var(--font-sans, 'Inter', sans-serif);
    }
    
    /* ── Hero Header ── */
    .aff-hero-container {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: linear-gradient(135deg, #BA1114 0%, #8a0c0e 100%);
        border-radius: 16px;
        padding: 2.5rem;
        margin-bottom: 2rem;
        color: #ffffff;
        gap: 2rem;
        box-shadow: 0 4px 20px rgba(186, 17, 20, 0.15);
    }
    .aff-hero-left {
        flex: 1;
    }
    .aff-hero-title {
        font-size: 2.2rem;
        font-weight: 800;
        line-height: 1.2;
        margin-bottom: 0.75rem;
    }
    .aff-hero-sub {
        font-size: 1.05rem;
        color: rgba(255, 255, 255, 0.9);
        margin: 0;
    }
    .aff-hero-right {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        align-items: flex-end;
    }
    .aff-hero-stats-bar {
        display: flex;
        gap: 0.75rem;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 0.75rem 1.25rem;
        border-radius: 12px;
        backdrop-filter: blur(10px);
    }
    .aff-hero-stat-pill {
        display: flex;
        flex-direction: column;
    }
    .aff-hero-stat-pill:first-child {
        border-right: 1px solid rgba(255, 255, 255, 0.2);
        padding-right: 1rem;
    }
    .aff-hero-stat-pill:last-child {
        padding-left: 0.5rem;
    }
    .aff-hero-stat-label {
        font-size: 0.7rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: rgba(255, 255, 255, 0.75);
        font-weight: 600;
    }
    .aff-hero-stat-val {
        font-size: 1.25rem;
        font-weight: 800;
    }
    
    /* ── Cards & Action Zones ── */
    .aff-card {
        background: var(--bg-surface, #ffffff);
        border: 1px solid var(--border-color, #e0e0e0);
        border-radius: 16px;
        padding: 1.75rem;
        margin-bottom: 2rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.02);
    }
    .aff-card-title {
        font-size: 1.15rem;
        font-weight: 700;
        color: var(--text-primary, #1a1a1a);
        margin-bottom: 0.5rem;
    }
    .aff-card-sub {
        font-size: 0.85rem;
        color: var(--text-muted, #757575);
        margin-bottom: 1.25rem;
    }
    .aff-link-box {
        display: flex;
        gap: 0.5rem;
        background: var(--bg-input, #f8f9fa);
        border: 1px solid var(--border-color, #e0e0e0);
        border-radius: 10px;
        padding: 0.4rem;
        align-items: center;
    }
    .aff-link-box-input {
        flex: 1;
        border: none;
        background: transparent;
        font-size: 0.9rem;
        color: var(--text-primary, #1a1a1a);
        padding: 0.5rem;
        outline: none;
    }
    .aff-btn {
        background: var(--brand-primary, #BA1114);
        color: #ffffff;
        border: none;
        font-weight: 600;
        font-size: 0.9rem;
        border-radius: 8px;
        padding: 0.6rem 1.2rem;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        transition: background 0.2s;
    }
    .aff-btn:hover {
        background: var(--brand-hover, #9E0D10);
        color: #ffffff;
    }
    
    /* ── Performance Dashboard Grid ── */
    .aff-grid-3 {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1rem;
        margin-bottom: 1rem;
    }
    .aff-kpi-card {
        background: var(--bg-surface, #ffffff);
        border: 1px solid var(--border-color, #e0e0e0);
        border-radius: 14px;
        padding: 1.25rem 1.5rem;
        display: flex;
        flex-direction: column;
        position: relative;
    }
    .aff-kpi-label {
        font-size: 0.75rem;
        text-transform: uppercase;
        font-weight: 700;
        letter-spacing: 0.5px;
        color: var(--text-muted, #757575);
        margin-bottom: 0.35rem;
    }
    .aff-kpi-val {
        font-size: 1.75rem;
        font-weight: 800;
        color: var(--text-primary, #1a1a1a);
        line-height: 1.2;
    }
    
    /* ── 2-Column Info Section ── */
    .aff-split-2 {
        display: grid;
        grid-template-columns: 1.2fr 1fr;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }
    .aff-step-list {
        display: flex;
        flex-direction: column;
        gap: 1.25rem;
    }
    .aff-step-item {
        display: flex;
        gap: 1rem;
    }
    .aff-step-num {
        font-size: 1.5rem;
        font-weight: 900;
        color: var(--brand-primary, #BA1114);
        line-height: 1;
    }
    .aff-step-content h4 {
        font-size: 0.95rem;
        font-weight: 700;
        margin-bottom: 0.25rem;
        color: var(--text-primary, #1a1a1a);
    }
    .aff-step-content p {
        font-size: 0.85rem;
        color: var(--text-muted, #757575);
        margin: 0;
        line-height: 1.5;
    }
    .aff-table-rates {
        width: 100%;
        font-size: 0.85rem;
        border-collapse: collapse;
    }
    .aff-table-rates th {
        font-weight: 700;
        color: var(--text-muted, #757575);
        border-bottom: 1px solid var(--border-color, #e0e0e0);
        padding-bottom: 0.5rem;
    }
    .aff-table-rates td {
        padding: 0.65rem 0;
        border-bottom: 1px solid var(--border-subtle, #eeeeee);
        color: var(--text-secondary, #555555);
    }
    
    /* ── Activity Table & Zero State ── */
    .aff-table-container {
        background: var(--bg-surface, #ffffff);
        border: 1px solid var(--border-color, #e0e0e0);
        border-radius: 14px;
        overflow: hidden;
        margin-bottom: 2rem;
    }
    .aff-table-header {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid var(--border-color, #e0e0e0);
        font-weight: 700;
        font-size: 1.05rem;
        color: var(--text-primary, #1a1a1a);
    }
    .aff-dt-top {
        display: flex;
        justify-content: space-between;
        padding: 1rem 1.5rem;
        border-bottom: 1px solid var(--border-subtle, #eeeeee);
        font-size: 0.85rem;
    }
    .aff-dt-foot {
        display: flex;
        justify-content: space-between;
        padding: 1rem 1.5rem;
        border-top: 1px solid var(--border-subtle, #eeeeee);
        font-size: 0.85rem;
    }
    .dataTables_wrapper input {
        border: 1px solid var(--border-color, #e0e0e0);
        border-radius: 6px;
        padding: 0.25rem 0.5rem;
        background: var(--bg-input, #ffffff);
        color: var(--text-primary, #1a1a1a);
        outline: none;
    }
    .aff-empty-state {
        padding: 3rem 2rem;
        text-align: center;
    }
    .aff-empty-icon {
        font-size: 2.5rem;
        color: var(--text-muted, #757575);
        margin-bottom: 1rem;
    }
    .aff-empty-title {
        font-size: 1.1rem;
        font-weight: 700;
        color: var(--text-primary, #1a1a1a);
        margin-bottom: 0.25rem;
    }
    .aff-empty-sub {
        font-size: 0.85rem;
        color: var(--text-muted, #757575);
        margin: 0;
    }
    
    /* ── Responsive Reflow ── */
    @media (max-width: 900px) {
        .aff-hero-container {
            flex-direction: column;
            align-items: flex-start;
            padding: 2rem;
        }
        .aff-hero-right {
            align-items: flex-start;
            width: 100%;
        }
        .aff-hero-stats-bar {
            width: 100%;
            justify-content: space-between;
        }
        .aff-grid-3 {
            grid-template-columns: 1fr;
        }
        .aff-split-2 {
            grid-template-columns: 1fr;
            gap: 2rem;
        }
    }
    
    /* ── Tooltip Style override ── */
    .tooltip-inner {
        font-size: 0.8rem !important;
        font-weight: 600 !important;
    }

    /* Dark Mode variables and helper overrides */
    html[data-theme="dark"] .aff-hero-container {
        box-shadow: none;
        background: linear-gradient(135deg, #991b1b 0%, #450a0a 100%);
    }
    html[data-theme="dark"] .aff-card,
    html[data-theme="dark"] .aff-kpi-card,
    html[data-theme="dark"] .aff-table-container {
        background-color: var(--bg-surface) !important;
        border-color: var(--border-color) !important;
    }
    html[data-theme="dark"] .aff-table-rates td {
        border-bottom-color: var(--border-subtle) !important;
    }
    html[data-theme="dark"] .form-select {
        background-color: var(--bg-input) !important;
        border-color: var(--border-color) !important;
        color: var(--text-primary) !important;
    }
    </style>

    <div class="aff-wrap mt-3">

        <!-- 1. Hero Header (Value Prop + Live Earnings) -->
        <div class="aff-hero-container">
            <div class="aff-hero-left">
                <h1 class="aff-hero-title">Earn up to 20% Recurring Commission with SNBD HOST</h1>
                <p class="aff-hero-sub">Share your referral link and earn on every hosting, VPS, or reseller order. No cap, no limit.</p>
            </div>
            <div class="aff-hero-right">
                <div class="aff-hero-stats-bar">
                    <div class="aff-hero-stat-pill">
                        <span class="aff-hero-stat-label">Available Balance</span>
                        <span class="aff-hero-stat-val">{$balance}</span>
                    </div>
                    <div class="aff-hero-stat-pill">
                        <span class="aff-hero-stat-label">Pending Balance</span>
                        <span class="aff-hero-stat-val">{$pendingcommissions}</span>
                    </div>
                </div>
                {if !$withdrawrequestsent && $withdrawlevel}
                    <form method="POST" action="{$smarty.server.PHP_SELF}" class="m-0 p-0">
                        <input type="hidden" name="action" value="withdrawrequest">
                        <button type="submit" class="btn btn-light fw-bold px-4 py-2" style="border-radius: 8px; font-size: 0.9rem;">
                            Request Payout
                        </button>
                    </form>
                {else}
                    <button type="button" class="btn btn-light fw-bold px-4 py-2 disabled" data-bs-toggle="tooltip" data-bs-placement="top" title="Min. withdrawal ৳500 BDT" style="border-radius: 8px; font-size: 0.9rem; opacity: 0.65;">
                        Request Payout
                    </button>
                {/if}
            </div>
        </div>

        <!-- 2. Primary Action Zone: Referral Link Generator -->
        <div class="aff-card">
            <div class="aff-card-title"><i class="fas fa-link text-danger me-2"></i>Your Default Referral Link</div>
            <div class="aff-card-sub">Share this link to track referrals automatically</div>
            <div class="aff-link-box mb-4">
                <input type="text" class="aff-link-box-input" id="referralLinkInput" readonly value="{$referrallink}">
                <button class="aff-btn" type="button" onclick="copyReferralLink()" id="copyBtn">
                    <i class="fas fa-copy"></i> Copy Link
                </button>
            </div>

            <div style="border-top: 1px solid var(--border-subtle, #eeeeee); padding-top: 1.5rem;">
                <div class="aff-card-title"><i class="fas fa-route text-danger me-2"></i>Custom Deep-Link Generator</div>
                <p class="text-muted small mb-3">Direct your audience to a specific product for higher conversion.</p>
                
                <div class="row g-2 mb-3">
                    <div class="col-sm-6">
                        <label class="form-label small fw-semibold text-muted">Select Product Group</label>
                        <select class="form-select" id="genProductGroup">
                            <option value="">-- All Product Groups --</option>
                            {foreach $affiliateProductGroups as $pg}
                                <option value="{$pg.id}">{$pg.name}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-sm-6">
                        <label class="form-label small fw-semibold text-muted">Select Product</label>
                        <select class="form-select" id="genProduct" disabled>
                            <option value="">-- Select Group First --</option>
                        </select>
                    </div>
                </div>
                
                <div class="aff-link-box" style="border-style: dashed; background-color: transparent;">
                    <input type="text" class="aff-link-box-input" id="customReferralLinkOutput" readonly value="{$referrallink}">
                    <button class="aff-btn" type="button" onclick="generateAndCopy()" id="copyCustomBtn">
                        <i class="fas fa-bolt"></i> Generate & Copy
                    </button>
                </div>
            </div>
        </div>

        <!-- 3. Performance Dashboard (Grid) -->
        <div class="mb-4">
            <div class="small text-muted fw-bold mb-2 uppercase" style="letter-spacing: 0.5px;">Traffic & Conversion Metrics</div>
            <div class="aff-grid-3">
                <div class="aff-kpi-card">
                    <span class="aff-kpi-label">Total Clicks</span>
                    <span class="aff-kpi-val">{$visitors}</span>
                </div>
                <div class="aff-kpi-card">
                    <span class="aff-kpi-label">Signups</span>
                    <span class="aff-kpi-val">{$signups}</span>
                </div>
                <div class="aff-kpi-card">
                    <span class="aff-kpi-label">Conversion Rate</span>
                    <span class="aff-kpi-val">{$conversionrate}%</span>
                </div>
            </div>
        </div>

        <div class="mb-4">
            <div class="small text-muted fw-bold mb-2 uppercase" style="letter-spacing: 0.5px;">Financial Summary</div>
            <div class="aff-grid-3">
                <div class="aff-kpi-card">
                    <span class="aff-kpi-label">Pending Maturation</span>
                    <span class="aff-kpi-val">{$pendingcommissions}</span>
                </div>
                <div class="aff-kpi-card">
                    <span class="aff-kpi-label">Available for Payout</span>
                    <span class="aff-kpi-val" style="color: var(--brand-primary, #BA1114);">{$balance}</span>
                </div>
                <div class="aff-kpi-card">
                    <span class="aff-kpi-label">Total Withdrawn</span>
                    <span class="aff-kpi-val">{$withdrawn}</span>
                </div>
            </div>
        </div>

        <!-- 4. How It Works & Commission Breakdown (2-Column) -->
        <div class="aff-split-2 mt-4">
            <div class="aff-card m-0">
                <div class="aff-card-title mb-4">How It Works</div>
                <div class="aff-step-list">
                    <div class="aff-step-item">
                        <span class="aff-step-num">1</span>
                        <div class="aff-step-content">
                            <h4>Share Link</h4>
                            <p>Distribute via blog, YouTube, social channels, or direct message.</p>
                        </div>
                    </div>
                    <div class="aff-step-item">
                        <span class="aff-step-num">2</span>
                        <div class="aff-step-content">
                            <h4>Client Orders</h4>
                            <p>Automatic tracking captures commissions as soon as your referrals sign up.</p>
                        </div>
                    </div>
                    <div class="aff-step-item">
                        <span class="aff-step-num">3</span>
                        <div class="aff-step-content">
                            <h4>Get Paid</h4>
                            <p>Withdraw your funds directly to bKash or Bank once you hit the ৳500 BDT limit.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="aff-card m-0">
                <div class="aff-card-title mb-4">Commission Structure</div>
                <table class="aff-table-rates">
                    <thead>
                        <tr>
                            <th align="left">Product Group</th>
                            <th align="center" style="text-align: center;">Rate</th>
                            <th align="left">Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Shared Hosting</td>
                            <td align="center" style="text-align: center; font-weight: 700; color: var(--brand-primary, #BA1114);">20%</td>
                            <td>Recurring</td>
                        </tr>
                        <tr>
                            <td>Reseller Hosting</td>
                            <td align="center" style="text-align: center; font-weight: 700; color: var(--brand-primary, #BA1114);">20%</td>
                            <td>Recurring</td>
                        </tr>
                        <tr>
                            <td>n8n & Managed Hosting</td>
                            <td align="center" style="text-align: center; font-weight: 700; color: var(--brand-primary, #BA1114);">15%</td>
                            <td>Recurring</td>
                        </tr>
                        <tr>
                            <td>VPS Hosting</td>
                            <td align="center" style="text-align: center; font-weight: 700; color: var(--brand-primary, #BA1114);">10%</td>
                            <td>Recurring</td>
                        </tr>
                        <tr>
                            <td>Domain Registration</td>
                            <td align="center" style="text-align: center; font-weight: 700;">0%</td>
                            <td>Flat</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 5. Activity Log & Referral History (Table) -->
        <div class="aff-table-container">
            <div class="aff-table-header">{lang key='affiliatesreferals'}</div>
            
            <div class="table-responsive">
                <table id="tableAffiliatesList" class="table table-hover align-middle mb-0 w-100" style="display:none; font-size: 0.9rem;">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Signup Date</th>
                            <th>Product/Service</th>
                            <th>Order Value</th>
                            <th>Commission</th>
                            <th class="pe-4">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $referrals as $referral}
                        <tr>
                            <td class="ps-4 py-3">
                                <span class="d-none">{$referral.datets}</span>
                                <span>{$referral.date}</span>
                            </td>
                            <td class="py-3 fw-bold">{$referral.service}</td>
                            <td data-order="{$referral.amountnum}" class="py-3">{$referral.amountdesc}</td>
                            <td data-order="{$referral.commissionnum}" class="py-3 fw-bold" style="color: var(--brand-primary, #BA1114);">{$referral.commission}</td>
                            <td class="pe-4 py-3">
                                {if $referral.rawstatus|strtolower == 'pending'}
                                    <span class="badge bg-warning text-dark">{$referral.status}</span>
                                {elseif $referral.rawstatus|strtolower == 'active'}
                                    <span class="badge bg-success">{$referral.status}</span>
                                {elseif $referral.rawstatus|strtolower == 'cancelled' || $referral.rawstatus|strtolower == 'fraud'}
                                    <span class="badge bg-danger">{$referral.status}</span>
                                {else}
                                    <span class="badge bg-secondary">{$referral.status}</span>
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
            </div>

            {if !$referrals}
                <div class="aff-empty-state">
                    <div class="aff-empty-icon"><i class="fas fa-users"></i></div>
                    <div class="aff-empty-title">No referrals recorded yet</div>
                    <p class="aff-empty-sub text-muted">Grab your referral link above and share it on social media to generate your first commission!</p>
                </div>
            {/if}

            <div class="text-center py-4" id="tableLoading">
                <div class="spinner-border text-danger spinner-border-sm" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>

    </div>

    <!-- Script triggers -->
    <script>
    {literal}
    var affiliateProductGroupsData = {/literal}{$affiliateProductGroups|json_encode}{literal};
    var baseReferralLink = "{/literal}{$referrallink}{literal}";

    document.addEventListener("DOMContentLoaded", function() {
        var groupSelect = document.getElementById('genProductGroup');
        var productSelect = document.getElementById('genProduct');
        var linkOutput = document.getElementById('customReferralLinkOutput');

        // Initialize DataTable
        try {
            var table = jQuery('#tableAffiliatesList').show().DataTable({
                dom: '<"aff-dt-top"<"aff-dt-len"l><"aff-dt-search"f>>' +
                     '<"aff-dt-body"rt>' +
                     '<"aff-dt-foot"<"aff-dt-info"i><"aff-dt-pag"p>>',
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search referrals...",
                    lengthMenu: "Show _MENU_",
                    emptyTable: "No referrals recorded yet. Grab your referral link above!",
                    info: "Showing _START_–_END_ of _TOTAL_ referrals",
                    zeroRecords: "No referrals match your search"
                }
            });
            jQuery('#tableLoading').hide();
        } catch(e) {
            jQuery('#tableLoading').hide();
            jQuery('#tableAffiliatesList').show();
        }

        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Group selector handles
        if (groupSelect && productSelect && linkOutput) {
            groupSelect.addEventListener('change', function() {
                var gid = this.value;
                productSelect.innerHTML = '<option value="">-- All Products in Group --</option>';
                
                if (!gid) {
                    productSelect.disabled = true;
                    updateCustomLink();
                    return;
                }
                
                var selectedGroup = affiliateProductGroupsData.find(function(g) {
                    return g.id == gid;
                });
                
                if (selectedGroup && selectedGroup.products && selectedGroup.products.length > 0) {
                    selectedGroup.products.forEach(function(p) {
                        var opt = document.createElement('option');
                        opt.value = p.id;
                        opt.textContent = p.name;
                        productSelect.appendChild(opt);
                    });
                    productSelect.disabled = false;
                } else {
                    productSelect.disabled = true;
                }
                updateCustomLink();
            });
            
            productSelect.addEventListener('change', updateCustomLink);
            
            function updateCustomLink() {
                var gid = groupSelect.value;
                var pid = productSelect.value;
                var targetUrl = baseReferralLink;
                
                if (gid || pid) {
                    var path = '';
                    if (pid) {
                        path = 'cart.php?a=add&pid=' + pid;
                    } else if (gid) {
                        path = 'cart.php?gid=' + gid;
                    }
                    var separator = baseReferralLink.indexOf('?') !== -1 ? '&' : '?';
                    targetUrl += separator + 'url=' + encodeURIComponent(path);
                }
                linkOutput.value = targetUrl;
            }
        }
    });

    function copyReferralLink() {
        var input = document.getElementById('referralLinkInput');
        if (input) {
            input.select();
            input.setSelectionRange(0, 99999);
            try {
                document.execCommand('copy');
                var btn = document.getElementById('copyBtn');
                if (btn) {
                    var originalText = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    btn.style.background = '#2e7d32';
                    btn.style.borderColor = '#2e7d32';
                    setTimeout(function() {
                        btn.innerHTML = originalText;
                        btn.style.background = '';
                        btn.style.borderColor = '';
                    }, 2000);
                }
            } catch (e) {}
        }
    }

    function generateAndCopy() {
        var groupSelect = document.getElementById('genProductGroup');
        var productSelect = document.getElementById('genProduct');
        var linkOutput = document.getElementById('customReferralLinkOutput');
        
        if (groupSelect && productSelect && linkOutput) {
            var gid = groupSelect.value;
            var pid = productSelect.value;
            var targetUrl = baseReferralLink;
            
            if (gid || pid) {
                var path = '';
                if (pid) {
                    path = 'cart.php?a=add&pid=' + pid;
                } else if (gid) {
                    path = 'cart.php?gid=' + gid;
                }
                var separator = baseReferralLink.indexOf('?') !== -1 ? '&' : '?';
                targetUrl += separator + 'url=' + encodeURIComponent(path);
            }
            
            linkOutput.value = targetUrl;
            
            // Perform Copy
            linkOutput.select();
            linkOutput.setSelectionRange(0, 99999);
            try {
                document.execCommand('copy');
                var btn = document.getElementById('copyCustomBtn');
                if (btn) {
                    var originalText = btn.innerHTML;
                    btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                    btn.style.background = '#2e7d32';
                    btn.style.borderColor = '#2e7d32';
                    btn.style.color = '#ffffff';
                    setTimeout(function() {
                        btn.innerHTML = originalText;
                        btn.style.background = '';
                        btn.style.borderColor = '';
                        btn.style.color = '';
                    }, 2000);
                }
            } catch (e) {}
        }
    }
    {/literal}
    </script>
{/if}
