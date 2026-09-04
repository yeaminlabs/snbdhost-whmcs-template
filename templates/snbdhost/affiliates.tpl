<!-- ====== AFFILIATES — SNBD HOST REDESIGN ====== -->
{if $inactive}
    {include file="$template/includes/alert.tpl" type="danger" msg="{lang key='affiliatesdisabled'}" textcenter=true}
{else}
    {include file="$template/includes/flashmessage.tpl"}

    <!-- Hidden raw values for JS -->
    <input type="hidden" id="rawPending"   value="{$pendingcommissions}">
    <input type="hidden" id="rawAvailable" value="{$balance}">
    <input type="hidden" id="rawWithdrawn" value="{$withdrawn}">
    <input type="hidden" id="valClicks"    value="{$visitors}">
    <input type="hidden" id="valSignups"   value="{$signups}">

    <style>
    /* ─── Base Wrapper ─── */
    .aff2 { max-width: 1160px; margin: 0 auto; padding: 0 0 4rem; }

    /* ─── Page Title Row ─── */
    .aff2-title-row {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        margin-bottom: 2rem;
        gap: 1rem;
        flex-wrap: wrap;
    }
    .aff2-page-title {
        font-size: 2rem;
        font-weight: 900;
        letter-spacing: -0.04em;
        color: #111;
        line-height: 1;
        margin: 0;
    }
    .aff2-page-sub {
        font-size: 0.9rem;
        color: #777;
        margin: 0.35rem 0 0;
        font-weight: 500;
    }

    /* ─── Payout Banner ─── */
    .aff2-payout-banner {
        background: linear-gradient(135deg, #CC0000 0%, #8B0000 100%);
        border-radius: 20px;
        padding: 2rem 2.5rem;
        color: #fff;
        display: flex;
        align-items: center;
        gap: 2.5rem;
        margin-bottom: 2rem;
        position: relative;
        overflow: hidden;
    }
    .aff2-payout-banner::before {
        content: '';
        position: absolute;
        top: -60px; right: -60px;
        width: 220px; height: 220px;
        border-radius: 50%;
        background: rgba(255,255,255,0.06);
    }
    .aff2-payout-banner::after {
        content: '';
        position: absolute;
        bottom: -80px; right: 100px;
        width: 160px; height: 160px;
        border-radius: 50%;
        background: rgba(255,255,255,0.04);
    }
    .aff2-banner-badge {
        background: rgba(255,255,255,0.15);
        border: 1px solid rgba(255,255,255,0.25);
        border-radius: 50rem;
        font-size: 0.7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        padding: 0.3rem 0.9rem;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        margin-bottom: 0.75rem;
    }
    .aff2-banner-headline {
        font-size: 1.65rem;
        font-weight: 900;
        letter-spacing: -0.03em;
        line-height: 1.15;
        margin: 0 0 0.4rem;
    }
    .aff2-banner-copy {
        font-size: 0.9rem;
        color: rgba(255,255,255,0.8);
        margin: 0;
    }
    .aff2-banner-divider {
        width: 1px;
        background: rgba(255,255,255,0.2);
        align-self: stretch;
        flex-shrink: 0;
    }
    .aff2-banner-stat-group {
        display: flex;
        gap: 2rem;
        flex-shrink: 0;
    }
    .aff2-banner-stat {
        display: flex;
        flex-direction: column;
        gap: 0.2rem;
    }
    .aff2-banner-stat-label {
        font-size: 0.68rem;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        color: rgba(255,255,255,0.65);
        font-weight: 700;
    }
    .aff2-banner-stat-val {
        font-size: 1.5rem;
        font-weight: 900;
        letter-spacing: -0.03em;
        line-height: 1;
    }
    .aff2-banner-actions {
        margin-left: auto;
        flex-shrink: 0;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
        position: relative;
        z-index: 1;
    }
    .aff2-btn-payout {
        background: #fff;
        color: #CC0000;
        border: none;
        font-weight: 700;
        font-size: 0.88rem;
        border-radius: 10px;
        padding: 0.7rem 1.5rem;
        cursor: pointer;
        white-space: nowrap;
        transition: all 0.2s;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
    }
    .aff2-btn-payout:hover { background: #f5f5f5; transform: translateY(-1px); }
    .aff2-btn-payout.disabled {
        background: rgba(255,255,255,0.25);
        color: rgba(255,255,255,0.6);
        cursor: default;
        border: 1px dashed rgba(255,255,255,0.3);
    }
    .aff2-btn-payout.disabled:hover { transform: none; }
    .aff2-payout-hint {
        font-size: 0.72rem;
        color: rgba(255,255,255,0.55);
        text-align: center;
    }

    /* ─── Stat Card Grid ─── */
    .aff2-stats-grid {
        display: grid;
        grid-template-columns: repeat(6, 1fr);
        gap: 1rem;
        margin-bottom: 2rem;
    }
    .aff2-stat {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 16px;
        padding: 1.25rem 1.5rem;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
        transition: all 0.2s;
    }
    .aff2-stat:hover {
        border-color: #ddd;
        box-shadow: 0 8px 24px rgba(0,0,0,0.05);
        transform: translateY(-2px);
    }
    .aff2-stat-icon {
        width: 36px; height: 36px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 0.9rem;
    }
    .aff2-stat-icon.red   { background: #FFF0F0; color: #CC0000; }
    .aff2-stat-icon.green { background: #F0FFF4; color: #1a7a3c; }
    .aff2-stat-icon.blue  { background: #EFF6FF; color: #1d4ed8; }
    .aff2-stat-icon.amber { background: #FFFBEB; color: #b45309; }
    .aff2-stat-icon.purple{ background: #F5F3FF; color: #6d28d9; }
    .aff2-stat-icon.gray  { background: #F5F5F5; color: #555; }
    .aff2-stat-label {
        font-size: 0.72rem;
        text-transform: uppercase;
        letter-spacing: 0.6px;
        font-weight: 700;
        color: #999;
    }
    .aff2-stat-val {
        font-size: 1.65rem;
        font-weight: 900;
        letter-spacing: -0.04em;
        color: #111;
        line-height: 1;
    }
    .aff2-stat-val.red { color: #CC0000; }

    /* ─── Two-Column Main Grid ─── */
    .aff2-main-grid {
        display: grid;
        grid-template-columns: 1.05fr 0.95fr;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    /* ─── Card Shell ─── */
    .aff2-card {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 18px;
        overflow: hidden;
    }
    .aff2-card-head {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid #f0f0f0;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .aff2-card-head-icon {
        width: 32px; height: 32px;
        border-radius: 8px;
        background: #FFF0F0;
        color: #CC0000;
        display: flex; align-items: center; justify-content: center;
        font-size: 0.8rem;
        flex-shrink: 0;
    }
    .aff2-card-head-title {
        font-size: 0.95rem;
        font-weight: 700;
        color: #111;
        margin: 0;
    }
    .aff2-card-head-sub {
        font-size: 0.8rem;
        color: #999;
        margin: 0;
    }
    .aff2-card-body { padding: 1.5rem; }

    /* ─── Referral Link Input ─── */
    .aff2-link-wrap {
        display: flex;
        background: #f8f8f8;
        border: 1.5px solid #e8e8e8;
        border-radius: 12px;
        overflow: hidden;
        transition: border-color 0.2s;
    }
    .aff2-link-wrap:focus-within { border-color: #CC0000; }
    .aff2-link-input {
        flex: 1;
        border: none;
        background: transparent;
        font-size: 0.875rem;
        color: #333;
        padding: 0.75rem 1rem;
        outline: none;
        min-width: 0;
    }
    .aff2-copy-btn {
        background: #CC0000;
        color: #fff;
        border: none;
        font-weight: 700;
        font-size: 0.82rem;
        padding: 0.75rem 1.15rem;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        white-space: nowrap;
        transition: background 0.2s;
        flex-shrink: 0;
    }
    .aff2-copy-btn:hover { background: #AA0000; }
    .aff2-copy-btn.copied { background: #1a7a3c; }

    /* ─── Generator Selects ─── */
    .aff2-gen-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.75rem;
        margin-bottom: 1rem;
    }
    .aff2-select-label {
        font-size: 0.75rem;
        font-weight: 700;
        color: #888;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.35rem;
        display: block;
    }

    /* ─── Steps ─── */
    .aff2-steps {
        display: flex;
        flex-direction: column;
        gap: 0;
    }
    .aff2-step {
        display: flex;
        gap: 1rem;
        padding: 1rem 0;
        position: relative;
    }
    .aff2-step:not(:last-child)::before {
        content: '';
        position: absolute;
        left: 18px;
        top: 52px;
        bottom: 0;
        width: 2px;
        background: #f0f0f0;
    }
    .aff2-step-icon-wrap {
        flex-shrink: 0;
        width: 36px; height: 36px;
        border-radius: 50%;
        border: 2px solid #CC0000;
        display: flex; align-items: center; justify-content: center;
        color: #CC0000;
        font-size: 0.85rem;
        background: #fff;
        position: relative;
        z-index: 1;
    }
    .aff2-step-body h4 {
        font-size: 0.9rem;
        font-weight: 700;
        color: #111;
        margin: 0 0 0.2rem;
    }
    .aff2-step-body p {
        font-size: 0.82rem;
        color: #888;
        margin: 0;
        line-height: 1.5;
    }

    /* ─── Commission Rates ─── */
    .aff2-rate-list { display: flex; flex-direction: column; gap: 0.5rem; }
    .aff2-rate-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.7rem 0;
        border-bottom: 1px solid #f5f5f5;
    }
    .aff2-rate-item:last-child { border-bottom: none; }
    .aff2-rate-name {
        font-size: 0.875rem;
        font-weight: 600;
        color: #333;
    }
    .aff2-rate-right { display: flex; align-items: center; gap: 0.6rem; }
    .aff2-rate-badge {
        font-size: 0.78rem;
        font-weight: 800;
        border-radius: 6px;
        padding: 0.25rem 0.6rem;
    }
    .aff2-rate-badge.high   { background: #FFF0F0; color: #CC0000; }
    .aff2-rate-badge.mid    { background: #FFF7ED; color: #c2410c; }
    .aff2-rate-badge.low    { background: #FFFBEB; color: #b45309; }
    .aff2-rate-badge.zero   { background: #F5F5F5; color: #888; }
    .aff2-rate-type {
        font-size: 0.72rem;
        color: #aaa;
        font-weight: 600;
    }

    /* ─── History Table ─── */
    .aff2-table-card {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 18px;
        overflow: hidden;
        margin-bottom: 2rem;
    }
    .aff2-table-head {
        padding: 1.25rem 1.5rem;
        border-bottom: 1px solid #f0f0f0;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .aff2-table-title {
        font-size: 0.95rem;
        font-weight: 700;
        color: #111;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.6rem;
    }
    .aff2-empty {
        padding: 4rem 2rem;
        text-align: center;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1rem;
    }
    .aff2-empty-icon {
        width: 64px; height: 64px;
        border-radius: 50%;
        background: #FFF0F0;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.5rem;
        color: #CC0000;
    }
    .aff2-empty h3 { font-size: 1.05rem; font-weight: 700; color: #111; margin: 0; }
    .aff2-empty p { font-size: 0.85rem; color: #999; margin: 0; max-width: 360px; }

    /* ─── Responsive ─── */
    @media (max-width: 1000px) {
        .aff2-stats-grid { grid-template-columns: repeat(3, 1fr); }
        .aff2-main-grid  { grid-template-columns: 1fr; }
    }
    @media (max-width: 700px) {
        .aff2-payout-banner {
            flex-direction: column;
            align-items: flex-start;
            gap: 1.5rem;
        }
        .aff2-banner-divider { display: none; }
        .aff2-banner-actions { margin-left: 0; width: 100%; }
        .aff2-btn-payout { width: 100%; justify-content: center; }
        .aff2-stats-grid { grid-template-columns: repeat(2, 1fr); }
        .aff2-gen-row { grid-template-columns: 1fr; }
    }
    @media (max-width: 480px) {
        .aff2-stats-grid { grid-template-columns: 1fr 1fr; }
        .aff2-banner-stat-group { gap: 1.5rem; }
    }

    /* ─── DataTable overrides ─── */
    .aff2-table-card .dataTables_wrapper .dataTables_filter input {
        border: 1.5px solid #e8e8e8;
        border-radius: 8px;
        padding: 0.35rem 0.75rem;
        font-size: 0.85rem;
        outline: none;
        background: #f8f8f8;
    }
    .aff2-table-card .dataTables_wrapper .dataTables_filter input:focus {
        border-color: #CC0000;
    }
    .aff2-table-card .dataTables_wrapper { padding: 0; }
    .aff2-table-card .dataTables_wrapper .dataTables_length select {
        border: 1.5px solid #e8e8e8;
        border-radius: 8px;
        padding: 0.3rem 0.5rem;
        font-size: 0.85rem;
        background: #f8f8f8;
    }
    .aff2-dt-controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 1.5rem;
        border-bottom: 1px solid #f5f5f5;
        gap: 1rem;
    }
    .aff2-dt-foot {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 1.5rem;
        border-top: 1px solid #f5f5f5;
        font-size: 0.82rem;
        color: #888;
        flex-wrap: wrap;
        gap: 0.5rem;
    }
    </style>

    {if $withdrawrequestsent}
    <div class="alert alert-success d-flex align-items-center gap-2 mb-4" style="border-radius: 12px; font-weight: 600;">
        <i class="fas fa-check-circle"></i>
        Withdrawal request sent! We'll process it shortly.
    </div>
    {/if}

    <div class="aff2 mt-2">

        <!-- ── Page Title ── -->
        <div class="aff2-title-row">
            <div>
                <h1 class="aff2-page-title">Affiliate Program</h1>
                <p class="aff2-page-sub">Earn up to 20% recurring commission on every referral — no cap, no expiry.</p>
            </div>
        </div>

        <!-- ── Payout Banner ── -->
        <div class="aff2-payout-banner">
            <div>
                <div class="aff2-banner-badge">
                    <i class="fas fa-star"></i> Active
                </div>
                <h2 class="aff2-banner-headline">Your Earnings Dashboard</h2>
                <p class="aff2-banner-copy">Refer customers to SNBD HOST and earn on every renewed payment.</p>
            </div>

            <div class="aff2-banner-divider"></div>

            <div class="aff2-banner-stat-group">
                <div class="aff2-banner-stat">
                    <span class="aff2-banner-stat-label">Available</span>
                    <span class="aff2-banner-stat-val">{$balance}</span>
                </div>
                <div class="aff2-banner-stat">
                    <span class="aff2-banner-stat-label">Pending</span>
                    <span class="aff2-banner-stat-val">{$pendingcommissions}</span>
                </div>
                <div class="aff2-banner-stat">
                    <span class="aff2-banner-stat-label">Withdrawn</span>
                    <span class="aff2-banner-stat-val">{$withdrawn}</span>
                </div>
            </div>

            <div class="aff2-banner-actions">
                {if !$withdrawrequestsent && $withdrawlevel}
                    <form method="POST" action="{$smarty.server.PHP_SELF}" class="m-0">
                        <input type="hidden" name="action" value="withdrawrequest">
                        <button type="submit" class="aff2-btn-payout">
                            <i class="fas fa-paper-plane"></i> Request Payout
                        </button>
                    </form>
                {else}
                    <button type="button" class="aff2-btn-payout disabled" data-bs-toggle="tooltip" title="Minimum ৳500 BDT required to withdraw">
                        <i class="fas fa-lock"></i> Request Payout
                    </button>
                    <span class="aff2-payout-hint">Min. ৳500 BDT to withdraw</span>
                {/if}
            </div>
        </div>

        <!-- ── Stat Cards ── -->
        <div class="aff2-stats-grid">
            <div class="aff2-stat">
                <div class="aff2-stat-icon blue"><i class="fas fa-mouse-pointer"></i></div>
                <div>
                    <div class="aff2-stat-label">Total Clicks</div>
                    <div class="aff2-stat-val">{$visitors}</div>
                </div>
            </div>
            <div class="aff2-stat">
                <div class="aff2-stat-icon green"><i class="fas fa-user-plus"></i></div>
                <div>
                    <div class="aff2-stat-label">Signups</div>
                    <div class="aff2-stat-val">{$signups}</div>
                </div>
            </div>
            <div class="aff2-stat">
                <div class="aff2-stat-icon purple"><i class="fas fa-percent"></i></div>
                <div>
                    <div class="aff2-stat-label">Conversion</div>
                    <div class="aff2-stat-val">{$conversionrate}%</div>
                </div>
            </div>
            <div class="aff2-stat">
                <div class="aff2-stat-icon amber"><i class="fas fa-clock"></i></div>
                <div>
                    <div class="aff2-stat-label">Maturing</div>
                    <div class="aff2-stat-val">{$pendingcommissions}</div>
                </div>
            </div>
            <div class="aff2-stat">
                <div class="aff2-stat-icon red"><i class="fas fa-wallet"></i></div>
                <div>
                    <div class="aff2-stat-label">Available</div>
                    <div class="aff2-stat-val red">{$balance}</div>
                </div>
            </div>
            <div class="aff2-stat">
                <div class="aff2-stat-icon gray"><i class="fas fa-check-double"></i></div>
                <div>
                    <div class="aff2-stat-label">Total Paid Out</div>
                    <div class="aff2-stat-val">{$withdrawn}</div>
                </div>
            </div>
        </div>

        <!-- ── Main 2-Column Grid ── -->
        <div class="aff2-main-grid">

            <!-- Left: Links -->
            <div style="display: flex; flex-direction: column; gap: 1.5rem;">

                <!-- Default Referral Link -->
                <div class="aff2-card">
                    <div class="aff2-card-head">
                        <div class="aff2-card-head-icon"><i class="fas fa-link"></i></div>
                        <div>
                            <p class="aff2-card-head-title">Your Referral Link</p>
                            <p class="aff2-card-head-sub">Share this link to track signups automatically</p>
                        </div>
                    </div>
                    <div class="aff2-card-body">
                        <div class="aff2-link-wrap">
                            <input type="text" class="aff2-link-input" id="referralLinkInput" readonly value="{$referrallink}">
                            <button class="aff2-copy-btn" type="button" onclick="copyAffLink('referralLinkInput','copyBtn')" id="copyBtn">
                                <i class="fas fa-copy"></i> Copy Link
                            </button>
                        </div>

                        <!-- Social share quick-links -->
                        <div class="d-flex gap-2 mt-3 flex-wrap">
                            <a href="https://www.facebook.com/sharer/sharer.php?u={$referrallink|urlencode}" target="_blank" rel="noopener"
                               class="btn btn-sm" style="background:#1877F2;color:#fff;border-radius:8px;font-size:0.8rem;font-weight:600;padding:0.4rem 0.9rem;">
                                <i class="fab fa-facebook-f me-1"></i> Facebook
                            </a>
                            <a href="https://wa.me/?text={$referrallink|urlencode}" target="_blank" rel="noopener"
                               class="btn btn-sm" style="background:#25D366;color:#fff;border-radius:8px;font-size:0.8rem;font-weight:600;padding:0.4rem 0.9rem;">
                                <i class="fab fa-whatsapp me-1"></i> WhatsApp
                            </a>
                            <a href="https://t.me/share/url?url={$referrallink|urlencode}" target="_blank" rel="noopener"
                               class="btn btn-sm" style="background:#229ED9;color:#fff;border-radius:8px;font-size:0.8rem;font-weight:600;padding:0.4rem 0.9rem;">
                                <i class="fab fa-telegram-plane me-1"></i> Telegram
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Deep Link Generator -->
                <div class="aff2-card">
                    <div class="aff2-card-head">
                        <div class="aff2-card-head-icon"><i class="fas fa-bolt"></i></div>
                        <div>
                            <p class="aff2-card-head-title">Deep-Link Generator</p>
                            <p class="aff2-card-head-sub">Direct your audience to a specific product for higher conversion</p>
                        </div>
                    </div>
                    <div class="aff2-card-body">
                        <div class="aff2-gen-row">
                            <div>
                                <label class="aff2-select-label">Product Group</label>
                                <select class="form-select form-select-sm" id="genProductGroup" style="border-radius:8px;border:1.5px solid #e8e8e8;background:#f8f8f8;">
                                    <option value="">— All Groups —</option>
                                    {foreach $affiliateProductGroups as $pg}
                                        <option value="{$pg.id}">{$pg.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div>
                                <label class="aff2-select-label">Product</label>
                                <select class="form-select form-select-sm" id="genProduct" disabled style="border-radius:8px;border:1.5px solid #e8e8e8;background:#f8f8f8;">
                                    <option value="">— Select Group First —</option>
                                </select>
                            </div>
                        </div>
                        <div class="aff2-link-wrap" style="border-style: dashed; background: transparent;">
                            <input type="text" class="aff2-link-input" id="customReferralLinkOutput" readonly value="{$referrallink}">
                            <button class="aff2-copy-btn" type="button" onclick="generateAndCopy()" id="copyCustomBtn">
                                <i class="fas fa-bolt"></i> Generate & Copy
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: How It Works + Rates -->
            <div style="display: flex; flex-direction: column; gap: 1.5rem;">

                <!-- How It Works -->
                <div class="aff2-card">
                    <div class="aff2-card-head">
                        <div class="aff2-card-head-icon"><i class="fas fa-route"></i></div>
                        <div>
                            <p class="aff2-card-head-title">How It Works</p>
                            <p class="aff2-card-head-sub">Three steps to earning commissions</p>
                        </div>
                    </div>
                    <div class="aff2-card-body">
                        <div class="aff2-steps">
                            <div class="aff2-step">
                                <div class="aff2-step-icon-wrap"><i class="fas fa-share-alt"></i></div>
                                <div class="aff2-step-body">
                                    <h4>Share Your Link</h4>
                                    <p>Post on YouTube, Facebook, WhatsApp, or your blog. Any platform works.</p>
                                </div>
                            </div>
                            <div class="aff2-step">
                                <div class="aff2-step-icon-wrap"><i class="fas fa-shopping-cart"></i></div>
                                <div class="aff2-step-body">
                                    <h4>Referral Orders</h4>
                                    <p>Tracking is automatic — commissions are captured the moment they sign up and pay.</p>
                                </div>
                            </div>
                            <div class="aff2-step">
                                <div class="aff2-step-icon-wrap"><i class="fas fa-money-bill-wave"></i></div>
                                <div class="aff2-step-body">
                                    <h4>Get Paid</h4>
                                    <p>Withdraw to bKash or your bank once your available balance hits ৳500 BDT.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Commission Rates -->
                <div class="aff2-card">
                    <div class="aff2-card-head">
                        <div class="aff2-card-head-icon"><i class="fas fa-tags"></i></div>
                        <div>
                            <p class="aff2-card-head-title">Commission Rates</p>
                            <p class="aff2-card-head-sub">All recurring — you earn every renewal cycle</p>
                        </div>
                    </div>
                    <div class="aff2-card-body">
                        <div class="aff2-rate-list">
                            <div class="aff2-rate-item">
                                <span class="aff2-rate-name"><i class="fas fa-server me-2 text-muted" style="font-size:0.8rem;"></i>Shared Hosting</span>
                                <div class="aff2-rate-right">
                                    <span class="aff2-rate-badge high">20%</span>
                                    <span class="aff2-rate-type">Recurring</span>
                                </div>
                            </div>
                            <div class="aff2-rate-item">
                                <span class="aff2-rate-name"><i class="fas fa-database me-2 text-muted" style="font-size:0.8rem;"></i>Reseller Hosting</span>
                                <div class="aff2-rate-right">
                                    <span class="aff2-rate-badge high">20%</span>
                                    <span class="aff2-rate-type">Recurring</span>
                                </div>
                            </div>
                            <div class="aff2-rate-item">
                                <span class="aff2-rate-name"><i class="fas fa-robot me-2 text-muted" style="font-size:0.8rem;"></i>n8n & Managed</span>
                                <div class="aff2-rate-right">
                                    <span class="aff2-rate-badge mid">15%</span>
                                    <span class="aff2-rate-type">Recurring</span>
                                </div>
                            </div>
                            <div class="aff2-rate-item">
                                <span class="aff2-rate-name"><i class="fas fa-cloud me-2 text-muted" style="font-size:0.8rem;"></i>VPS Hosting</span>
                                <div class="aff2-rate-right">
                                    <span class="aff2-rate-badge low">10%</span>
                                    <span class="aff2-rate-type">Recurring</span>
                                </div>
                            </div>
                            <div class="aff2-rate-item">
                                <span class="aff2-rate-name"><i class="fas fa-globe me-2 text-muted" style="font-size:0.8rem;"></i>Domain Registration</span>
                                <div class="aff2-rate-right">
                                    <span class="aff2-rate-badge zero">0%</span>
                                    <span class="aff2-rate-type">Flat</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- ── Referral History Table ── -->
        <div class="aff2-table-card">
            <div class="aff2-table-head">
                <span class="aff2-table-title">
                    <span style="width:28px;height:28px;background:#FFF0F0;border-radius:7px;display:inline-flex;align-items:center;justify-content:center;color:#CC0000;font-size:0.75rem;"><i class="fas fa-users"></i></span>
                    {lang key='affiliatesreferals'}
                </span>
            </div>

            {if $referrals}
                <div class="aff2-dt-controls" id="dtControlsTop"></div>
                <div class="table-responsive">
                    <table id="tableAffiliatesList" class="table table-hover align-middle mb-0 w-100" style="display:none; font-size:0.875rem;">
                        <thead>
                            <tr style="background:#fafafa;border-bottom:1.5px solid #f0f0f0;">
                                <th class="ps-4 py-3 fw-700" style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.5px;color:#999;font-weight:700;">Date</th>
                                <th class="py-3 fw-700" style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.5px;color:#999;font-weight:700;">Service</th>
                                <th class="py-3 fw-700" style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.5px;color:#999;font-weight:700;">Order Value</th>
                                <th class="py-3 fw-700" style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.5px;color:#999;font-weight:700;">Commission</th>
                                <th class="pe-4 py-3 fw-700" style="font-size:0.75rem;text-transform:uppercase;letter-spacing:0.5px;color:#999;font-weight:700;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        {foreach $referrals as $referral}
                            <tr>
                                <td class="ps-4 py-3">
                                    <span class="d-none">{$referral.datets}</span>
                                    <span style="color:#555;">{$referral.date}</span>
                                </td>
                                <td class="py-3 fw-semibold" style="color:#111;">{$referral.service}</td>
                                <td data-order="{$referral.amountnum}" class="py-3" style="color:#555;">{$referral.amountdesc}</td>
                                <td data-order="{$referral.commissionnum}" class="py-3" style="color:#CC0000;font-weight:700;">{$referral.commission}</td>
                                <td class="pe-4 py-3">
                                    {if $referral.rawstatus|strtolower == 'pending'}
                                        <span class="badge" style="background:#FFF7ED;color:#c2410c;font-size:0.75rem;padding:0.3rem 0.65rem;border-radius:6px;font-weight:700;">{$referral.status}</span>
                                    {elseif $referral.rawstatus|strtolower == 'active'}
                                        <span class="badge" style="background:#F0FFF4;color:#1a7a3c;font-size:0.75rem;padding:0.3rem 0.65rem;border-radius:6px;font-weight:700;">{$referral.status}</span>
                                    {elseif $referral.rawstatus|strtolower == 'cancelled' || $referral.rawstatus|strtolower == 'fraud'}
                                        <span class="badge" style="background:#FFF0F0;color:#CC0000;font-size:0.75rem;padding:0.3rem 0.65rem;border-radius:6px;font-weight:700;">{$referral.status}</span>
                                    {else}
                                        <span class="badge" style="background:#F5F5F5;color:#777;font-size:0.75rem;padding:0.3rem 0.65rem;border-radius:6px;font-weight:700;">{$referral.status}</span>
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}
                        </tbody>
                    </table>
                </div>
                <div class="aff2-dt-foot" id="dtControlsBottom">
                    <div id="dtInfoEl"></div>
                    <div id="dtPagEl"></div>
                </div>
            {else}
                <div class="aff2-empty">
                    <div class="aff2-empty-icon"><i class="fas fa-users"></i></div>
                    <h3>No referrals yet</h3>
                    <p>Copy your referral link and share it — your first commission will appear here as soon as someone signs up.</p>
                </div>
            {/if}

            <div class="text-center py-4" id="tableLoading" {if !$referrals}style="display:none;"{/if}>
                <div class="spinner-border spinner-border-sm text-danger" role="status">
                    <span class="visually-hidden">Loading…</span>
                </div>
            </div>
        </div>

    </div><!-- /.aff2 -->

    <script>
    {literal}
    var affiliateProductGroupsData = {/literal}{$affiliateProductGroups|json_encode}{literal};
    var baseReferralLink = "{/literal}{$referrallink}{literal}";

    document.addEventListener("DOMContentLoaded", function() {

        // ── DataTable ──
        try {
            jQuery('#tableAffiliatesList').show().DataTable({
                dom: '<"aff2-dt-controls"<"ms-0"l><"ms-auto"f>>' +
                     'rt' +
                     '<"aff2-dt-foot"<"aff2-dt-info"i><"aff2-dt-pag"p>>',
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search referrals…",
                    lengthMenu: "Show _MENU_",
                    info: "_START_–_END_ of _TOTAL_ referrals",
                    emptyTable: "No referrals yet.",
                    zeroRecords: "No matches found."
                }
            });
            jQuery('#tableLoading').hide();
        } catch(e) {
            jQuery('#tableLoading').hide();
            jQuery('#tableAffiliatesList').show();
        }

        // ── Tooltips ──
        [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]')).forEach(function(el) {
            new bootstrap.Tooltip(el);
        });

        // ── Deep-link generator ──
        var groupSel = document.getElementById('genProductGroup');
        var prodSel  = document.getElementById('genProduct');
        var linkOut  = document.getElementById('customReferralLinkOutput');

        if (groupSel && prodSel && linkOut) {
            groupSel.addEventListener('change', function() {
                var gid = this.value;
                prodSel.innerHTML = '<option value="">— All Products —</option>';
                if (!gid) { prodSel.disabled = true; updateDeepLink(); return; }
                var g = affiliateProductGroupsData.find(function(x){ return x.id == gid; });
                if (g && g.products && g.products.length) {
                    g.products.forEach(function(p) {
                        var o = document.createElement('option');
                        o.value = p.id; o.textContent = p.name;
                        prodSel.appendChild(o);
                    });
                    prodSel.disabled = false;
                } else { prodSel.disabled = true; }
                updateDeepLink();
            });
            prodSel.addEventListener('change', updateDeepLink);
        }

        function updateDeepLink() {
            if (!groupSel || !prodSel || !linkOut) return;
            var gid = groupSel.value, pid = prodSel.value;
            var url = baseReferralLink;
            if (gid || pid) {
                var path = pid ? 'cart.php?a=add&pid=' + pid : 'cart.php?gid=' + gid;
                url += (baseReferralLink.indexOf('?') !== -1 ? '&' : '?') + 'url=' + encodeURIComponent(path);
            }
            linkOut.value = url;
        }
    });

    function copyAffLink(inputId, btnId) {
        var inp = document.getElementById(inputId);
        var btn = document.getElementById(btnId);
        if (!inp) return;
        inp.select(); inp.setSelectionRange(0, 99999);
        try {
            document.execCommand('copy');
            if (btn) {
                var orig = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                btn.classList.add('copied');
                setTimeout(function(){ btn.innerHTML = orig; btn.classList.remove('copied'); }, 2000);
            }
        } catch(e){}
    }

    function generateAndCopy() {
        var groupSel = document.getElementById('genProductGroup');
        var prodSel  = document.getElementById('genProduct');
        var linkOut  = document.getElementById('customReferralLinkOutput');
        if (!groupSel || !prodSel || !linkOut) return;
        var gid = groupSel.value, pid = prodSel.value;
        var url = baseReferralLink;
        if (gid || pid) {
            var path = pid ? 'cart.php?a=add&pid=' + pid : 'cart.php?gid=' + gid;
            url += (baseReferralLink.indexOf('?') !== -1 ? '&' : '?') + 'url=' + encodeURIComponent(path);
        }
        linkOut.value = url;
        copyAffLink('customReferralLinkOutput', 'copyCustomBtn');
    }
    {/literal}
    </script>
{/if}
