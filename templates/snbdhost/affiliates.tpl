<!-- ====== AFFILIATES DASHBOARD — SNBD HOST REDESIGN ====== -->
{if $inactive}
    {include file="$template/includes/alert.tpl" type="danger" msg="{lang key='affiliatesdisabled'}" textcenter=true}
{else}
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    {include file="$template/includes/flashmessage.tpl"}
    {if $withdrawrequestsent}
        <div class="aff-toast aff-toast--success" id="affToast">
            <i class="fas fa-check-circle me-2"></i>{lang key='affiliateswithdrawalrequestsuccessful'}
            <button class="aff-toast__close" onclick="this.parentElement.remove()">&times;</button>
        </div>
    {/if}

    <!-- Hidden inputs for JS -->
    <input type="hidden" id="rawPending"   value="{$pendingcommissions}">
    <input type="hidden" id="rawAvailable" value="{$balance}">
    <input type="hidden" id="rawWithdrawn" value="{$withdrawn}">
    <input type="hidden" id="valClicks"    value="{$visitors}">
    <input type="hidden" id="valSignups"   value="{$signups}">

    <div class="aff-wrap">

        <!-- ═══════════════════════════════════════════
             HERO BANNER
        ═══════════════════════════════════════════ -->
        <div class="aff-hero reveal-hero">
            <div class="aff-hero__bg-grid"></div>
            <div class="aff-hero__bg-glow"></div>

            <div class="aff-hero__content">
                <div class="aff-hero__badge">
                    <i class="fas fa-bolt me-1"></i> Partner Program
                </div>
                <h1 class="aff-hero__title">Earn Real Money<br>Referring SNBD HOST</h1>
                <p class="aff-hero__sub">Share your unique link — earn a commission on every order your referrals place. No cap. No limit.</p>

                <div class="aff-hero__commission-row">
                    <div class="aff-hero__comm-pill">
                        <span class="aff-hero__comm-pct">10<sup>%</sup></span>
                        <span class="aff-hero__comm-label">Commission<br>Per Sale</span>
                    </div>
                    <div class="aff-hero__comm-pill">
                        <span class="aff-hero__comm-pct"><i class="fas fa-infinity" style="font-size:1.2rem"></i></span>
                        <span class="aff-hero__comm-label">No Referral<br>Limit</span>
                    </div>
                    <div class="aff-hero__comm-pill">
                        <span class="aff-hero__comm-pct"><i class="fas fa-lock-open" style="font-size:1.1rem"></i></span>
                        <span class="aff-hero__comm-label">Withdraw<br>Anytime</span>
                    </div>
                </div>
            </div>

            <div class="aff-hero__actions">
                {if !$withdrawrequestsent && $withdrawlevel}
                    <form method="POST" action="{$smarty.server.PHP_SELF}" class="d-inline">
                        <input type="hidden" name="action" value="withdrawrequest">
                        <button type="submit" class="aff-btn aff-btn--white">
                            <i class="fas fa-money-bill-wave me-2"></i>{lang key='affiliatesrequestwithdrawal'}
                        </button>
                    </form>
                {/if}
                {if !$withdrawrequestsent && !$withdrawlevel}
                    <div class="aff-hero__notice">
                        <i class="fas fa-info-circle me-1"></i>
                        {lang key="affiliateWithdrawalSummary" amountForWithdrawal=$affiliatePayoutMinimum}
                    </div>
                {/if}
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             HOW IT WORKS
        ═══════════════════════════════════════════ -->
        <div class="aff-section aff-section--steps reveal">
            <div class="aff-section__header">
                <div class="aff-section__tag">How It Works</div>
                <h2 class="aff-section__title">Three steps to earning</h2>
            </div>
            <div class="aff-steps">
                <div class="aff-step reveal" style="transition-delay:.05s">
                    <div class="aff-step__num">01</div>
                    <div class="aff-step__icon"><i class="fas fa-link"></i></div>
                    <h3 class="aff-step__title">Share Your Link</h3>
                    <p class="aff-step__desc">Copy your unique referral URL and share it on social media, YouTube, blogs, or directly with contacts.</p>
                </div>
                <div class="aff-step__divider"><i class="fas fa-chevron-right"></i></div>
                <div class="aff-step reveal" style="transition-delay:.15s">
                    <div class="aff-step__num">02</div>
                    <div class="aff-step__icon"><i class="fas fa-user-plus"></i></div>
                    <h3 class="aff-step__title">They Sign Up & Order</h3>
                    <p class="aff-step__desc">When your referral registers and places an order, we automatically track and attribute the sale to you.</p>
                </div>
                <div class="aff-step__divider"><i class="fas fa-chevron-right"></i></div>
                <div class="aff-step reveal" style="transition-delay:.25s">
                    <div class="aff-step__num">03</div>
                    <div class="aff-step__icon"><i class="fas fa-wallet"></i></div>
                    <h3 class="aff-step__title">Earn Commission</h3>
                    <p class="aff-step__desc">Receive <strong>10% commission</strong> on every qualifying order. Request a withdrawal once you hit the minimum threshold.</p>
                </div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             KPI CARDS
        ═══════════════════════════════════════════ -->
        <div class="aff-kpi-row">
            <div class="aff-kpi reveal" style="transition-delay:.05s">
                <div class="aff-kpi__icon"><i class="fas fa-mouse-pointer"></i></div>
                <div class="aff-kpi__body">
                    <div class="aff-kpi__label">Total Clicks</div>
                    <div class="aff-kpi__value" data-target="{$visitors}" data-suffix="">{$visitors}</div>
                    <div class="aff-kpi__sub">Visitors referred</div>
                </div>
                <div class="aff-kpi__bar" style="--kpi-color: #BA1114;"></div>
            </div>
            <div class="aff-kpi reveal" style="transition-delay:.12s">
                <div class="aff-kpi__icon" style="--icon-bg: rgba(186,17,20,0.08); --icon-color: #BA1114;"><i class="fas fa-user-check"></i></div>
                <div class="aff-kpi__body">
                    <div class="aff-kpi__label">Signups</div>
                    <div class="aff-kpi__value" data-target="{$signups}" data-suffix="">{$signups}</div>
                    <div class="aff-kpi__sub">Accounts created</div>
                </div>
                <div class="aff-kpi__bar" style="--kpi-color: #BA1114;"></div>
            </div>
            <div class="aff-kpi reveal" style="transition-delay:.19s">
                <div class="aff-kpi__icon"><i class="fas fa-percent"></i></div>
                <div class="aff-kpi__body">
                    <div class="aff-kpi__label">Conversion Rate</div>
                    <div class="aff-kpi__value">{$conversionrate}%</div>
                    <div class="aff-kpi__sub">Click-to-signup ratio</div>
                </div>
                <div class="aff-kpi__bar" style="--kpi-color: #BA1114;"></div>
            </div>
            <div class="aff-kpi aff-kpi--highlight reveal" style="transition-delay:.26s">
                <div class="aff-kpi__icon" style="--icon-bg: rgba(255,255,255,0.15); --icon-color: #fff;"><i class="fas fa-coins"></i></div>
                <div class="aff-kpi__body">
                    <div class="aff-kpi__label" style="color:rgba(255,255,255,0.7)">Available Balance</div>
                    <div class="aff-kpi__value" style="color:#fff; font-size:1.6rem">{$balance}</div>
                    <div class="aff-kpi__sub" style="color:rgba(255,255,255,0.6)">Ready to withdraw</div>
                </div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             CHARTS + FINANCIAL
        ═══════════════════════════════════════════ -->
        <div class="aff-grid-2 aff-grid-2--charts">
            <!-- Earnings Bar Chart -->
            <div class="aff-card reveal" style="transition-delay:.05s">
                <div class="aff-card__head">
                    <div>
                        <div class="aff-card__title">Earnings Summary</div>
                        <div class="aff-card__sub">Pending · Available · Withdrawn</div>
                    </div>
                    <div class="aff-card__badge"><i class="fas fa-chart-bar me-1"></i>Overview</div>
                </div>
                <div class="aff-card__body" style="height:230px; position:relative;">
                    <canvas id="earningsChart"></canvas>
                </div>
            </div>

            <!-- Conversion Doughnut -->
            <div class="aff-card reveal" style="transition-delay:.12s">
                <div class="aff-card__head">
                    <div>
                        <div class="aff-card__title">Conversion Overview</div>
                        <div class="aff-card__sub">Signups vs lost clicks</div>
                    </div>
                    <div class="aff-card__badge"><i class="fas fa-chart-pie me-1"></i>Funnel</div>
                </div>
                <div class="aff-card__body d-flex justify-content-center align-items-center" style="height:230px; position:relative;">
                    <canvas id="conversionChart"></canvas>
                </div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             REFERRAL LINK + FINANCIAL OVERVIEW
        ═══════════════════════════════════════════ -->
        <div class="aff-grid-2">
            <!-- Referral Link -->
            <div class="aff-card reveal" style="transition-delay:.05s">
                <div class="aff-card__head">
                    <div>
                        <div class="aff-card__title"><i class="fas fa-link text-danger me-2"></i>{lang key='affiliatesreferallink'}</div>
                        <div class="aff-card__sub">Share this link to track referrals automatically</div>
                    </div>
                </div>
                <div class="aff-card__body">
                    <div class="aff-link-box">
                        <input type="text" class="aff-link-box__input" id="referralLinkInput" readonly value="{$referrallink}">
                        <button class="aff-link-box__btn" type="button" onclick="copyReferralLink()" id="copyBtn">
                            <i class="fas fa-copy me-1"></i> Copy
                        </button>
                    </div>

                    <div class="aff-share-row mt-3">
                        <span class="aff-share-label">Share:</span>
                        <a class="aff-share-btn aff-share-btn--fb" onclick="shareAffiliate('facebook')" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a class="aff-share-btn aff-share-btn--tw" onclick="shareAffiliate('twitter')" title="Twitter/X"><i class="fab fa-x-twitter"></i></a>
                        <a class="aff-share-btn aff-share-btn--wa" onclick="shareAffiliate('whatsapp')" title="WhatsApp"><i class="fab fa-whatsapp"></i></a>
                    </div>

                    {if $affiliatelinkscode}
                        <div class="aff-code-block mt-4">
                            <div class="aff-code-block__label">{lang key='affiliateslinktous'}</div>
                            <pre class="aff-code-block__pre">{$affiliatelinkscode}</pre>
                        </div>
                    {/if}
                </div>
            </div>

            <!-- Financial Overview -->
            <div class="aff-finance reveal" style="transition-delay:.12s">
                <div class="aff-finance__glow"></div>
                <div class="aff-finance__icon-bg"><i class="fas fa-wallet"></i></div>

                <div class="aff-finance__head">Financial Overview</div>
                <div class="aff-finance__subtitle">Your current earnings at a glance</div>

                <div class="aff-finance__rows">
                    <div class="aff-finance__row">
                        <div class="aff-finance__row-label">
                            <i class="fas fa-clock"></i>
                            {lang key='affiliatescommissionspending'}
                        </div>
                        <div class="aff-finance__row-val">{$pendingcommissions}</div>
                    </div>
                    <div class="aff-finance__divider"></div>
                    <div class="aff-finance__row">
                        <div class="aff-finance__row-label">
                            <i class="fas fa-check-circle"></i>
                            {lang key='affiliatescommissionsavailable'}
                        </div>
                        <div class="aff-finance__row-val aff-finance__row-val--highlight">{$balance}</div>
                    </div>
                    <div class="aff-finance__divider"></div>
                    <div class="aff-finance__row">
                        <div class="aff-finance__row-label">
                            <i class="fas fa-arrow-up"></i>
                            {lang key='affiliateswithdrawn'}
                        </div>
                        <div class="aff-finance__row-val">{$withdrawn}</div>
                    </div>
                </div>

                {if !$withdrawrequestsent && $withdrawlevel}
                    <form method="POST" action="{$smarty.server.PHP_SELF}" class="mt-4">
                        <input type="hidden" name="action" value="withdrawrequest">
                        <button type="submit" class="aff-btn aff-btn--white w-100">
                            <i class="fas fa-money-bill-wave me-2"></i>{lang key='affiliatesrequestwithdrawal'}
                        </button>
                    </form>
                {/if}
            </div>
        </div>

        <!-- ═══════════════════════════════════════════
             COMMISSION RATES BREAKDOWN
        ═══════════════════════════════════════════ -->
        <div class="aff-section aff-section--rates reveal">
            <div class="aff-section__header">
                <div class="aff-section__tag">Commission Structure</div>
                <h2 class="aff-section__title">What you earn, clearly</h2>
            </div>
            <div class="aff-rates-grid">
                <div class="aff-rate-card reveal" style="transition-delay:.05s">
                    <div class="aff-rate-card__pct">10%</div>
                    <div class="aff-rate-card__name">Shared Hosting</div>
                    <div class="aff-rate-card__desc">cPanel, LiteSpeed & NVMe shared plans</div>
                </div>
                <div class="aff-rate-card reveal" style="transition-delay:.12s">
                    <div class="aff-rate-card__pct">10%</div>
                    <div class="aff-rate-card__name">VPS & Servers</div>
                    <div class="aff-rate-card__desc">Cloud VPS, dedicated & managed VPS</div>
                </div>
                <div class="aff-rate-card reveal" style="transition-delay:.19s">
                    <div class="aff-rate-card__pct">10%</div>
                    <div class="aff-rate-card__name">SSL Certificates</div>
                    <div class="aff-rate-card__desc">DV, OV & wildcard SSL products</div>
                </div>
            </div>
            <p class="aff-rates-note"><i class="fas fa-info-circle me-1"></i>Commissions are calculated on the net order value and credited after the maturation period. Contact support for custom partnership rates.</p>
        </div>

        <!-- ═══════════════════════════════════════════
             REFERRALS TABLE
        ═══════════════════════════════════════════ -->
        <div class="aff-section reveal">
            <div class="aff-section__header aff-section__header--row">
                <div>
                    <div class="aff-section__tag">Activity Log</div>
                    <h2 class="aff-section__title">{lang key='affiliatesreferals'}</h2>
                </div>
            </div>

            <div class="aff-card aff-card--table">
                <script>
                    jQuery(document).ready(function() {
                        var table = jQuery('#tableAffiliatesList').show().DataTable({
                            dom: '<"aff-dt-top"<"aff-dt-len"l><"aff-dt-search"f>>' +
                                 '<"aff-dt-body"<"col-sm-12 px-0"tr>>' +
                                 '<"aff-dt-foot"<"aff-dt-info"i><"aff-dt-pag"p>>',
                            language: {
                                search: "_INPUT_",
                                searchPlaceholder: "Search referrals...",
                                lengthMenu: "Show _MENU_",
                                emptyTable: "No referrals yet. Start sharing your link!",
                                info: "Showing _START_–_END_ of _TOTAL_ referrals",
                                zeroRecords: "No referrals match your search"
                            }
                        });

                        {if $orderby == 'regdate'}   table.order(0, '{$sort}');
                        {elseif $orderby == 'product'} table.order(1, '{$sort}');
                        {elseif $orderby == 'amount'}  table.order(2, '{$sort}');
                        {elseif $orderby == 'status'}  table.order(4, '{$sort}');
                        {/if}

                        table.draw();
                        jQuery('#tableLoading').hide();
                    });
                </script>

                <div class="table-responsive">
                    <table id="tableAffiliatesList" class="table aff-table w-100" style="display:none;">
                        <thead>
                            <tr>
                                <th class="ps-4">{lang key='affiliatessignupdate'}</th>
                                <th>{lang key='orderproduct'}</th>
                                <th>{lang key='affiliatesamount'}</th>
                                <th>{lang key='affiliatescommission'}</th>
                                <th class="pe-4">{lang key='affiliatesstatus'}</th>
                            </tr>
                        </thead>
                        <tbody>
                        {foreach $referrals as $referral}
                            <tr>
                                <td class="ps-4 py-3">
                                    <span class="d-none">{$referral.datets}</span>
                                    <i class="far fa-calendar-alt me-2 text-muted"></i>
                                    <span>{$referral.date}</span>
                                </td>
                                <td class="py-3 fw-medium">{$referral.service}</td>
                                <td data-order="{$referral.amountnum}" class="py-3">{$referral.amountdesc}</td>
                                <td data-order="{$referral.commissionnum}" class="py-3">
                                    <span class="aff-commission-val">{$referral.commission}</span>
                                </td>
                                <td class="pe-4 py-3">
                                    {if $referral.rawstatus|strtolower == 'pending'}
                                        <span class="aff-badge aff-badge--pending">{$referral.status}</span>
                                    {elseif $referral.rawstatus|strtolower == 'active'}
                                        <span class="aff-badge aff-badge--active">{$referral.status}</span>
                                    {elseif $referral.rawstatus|strtolower == 'cancelled' || $referral.rawstatus|strtolower == 'fraud'}
                                        <span class="aff-badge aff-badge--cancelled">{$referral.status}</span>
                                    {else}
                                        <span class="aff-badge aff-badge--default">{$referral.status}</span>
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}
                        {if !$referrals}
                            <tr>
                                <td colspan="5" class="aff-empty-row">
                                    <div class="aff-empty">
                                        <div class="aff-empty__icon"><i class="fas fa-users"></i></div>
                                        <div class="aff-empty__title">No referrals yet</div>
                                        <div class="aff-empty__sub">Share your referral link above to start earning commissions.</div>
                                    </div>
                                </td>
                            </tr>
                        {/if}
                        </tbody>
                    </table>
                </div>
                <div class="text-center py-5" id="tableLoading">
                    <div class="aff-spinner"></div>
                </div>
            </div>
        </div>

    </div><!-- /.aff-wrap -->


    <!-- ═══════════════════════════════════════════════════════════════
         STYLES
    ═══════════════════════════════════════════════════════════════ -->
    <style>
    /* ── Reset & wrap ── */
    .aff-wrap {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 0 3rem;
        font-family: var(--font-sans, 'Inter', sans-serif);
    }

    /* ── Toast ── */
    .aff-toast {
        display: flex; align-items: center; gap: .5rem;
        padding: 1rem 1.25rem; border-radius: 10px;
        font-weight: 500; margin-bottom: 1.5rem;
        animation: slideDown .4s ease;
    }
    .aff-toast--success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
    .aff-toast__close { margin-left: auto; background: none; border: none; font-size: 1.2rem; cursor: pointer; color: inherit; line-height:1; }

    /* ══════════════════════════════════════
       HERO
    ══════════════════════════════════════ */
    .aff-hero {
        position: relative;
        background: #BA1114;
        border-radius: 16px;
        overflow: hidden;
        padding: 3rem 2.5rem 2.5rem;
        margin-bottom: 2rem;
        color: #fff;
    }
    .aff-hero__bg-grid {
        position: absolute; inset: 0;
        background-image:
            linear-gradient(rgba(255,255,255,.06) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255,255,255,.06) 1px, transparent 1px);
        background-size: 32px 32px;
        pointer-events: none;
    }
    .aff-hero__bg-glow {
        position: absolute;
        width: 500px; height: 500px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(255,255,255,.15) 0%, transparent 70%);
        top: -200px; right: -100px;
        pointer-events: none;
        animation: heroGlow 6s ease-in-out infinite alternate;
    }
    @keyframes heroGlow {
        0%   { transform: scale(1)   translate(0, 0); }
        100% { transform: scale(1.2) translate(-30px, 30px); }
    }
    .aff-hero__content { position: relative; z-index: 2; max-width: 700px; }
    .aff-hero__badge {
        display: inline-flex; align-items: center;
        background: rgba(255,255,255,.15);
        border: 1px solid rgba(255,255,255,.25);
        color: #fff;
        border-radius: 100px;
        padding: .35rem .9rem;
        font-size: .75rem; font-weight: 600; letter-spacing: .5px; text-transform: uppercase;
        margin-bottom: 1.25rem;
        animation: fadeUp .6s ease both;
    }
    .aff-hero__title {
        font-size: 2.4rem; font-weight: 800; line-height: 1.15;
        color: #fff; margin: 0 0 1rem;
        animation: fadeUp .6s ease .1s both;
    }
    .aff-hero__sub {
        font-size: 1.05rem; color: rgba(255,255,255,.82); margin: 0 0 2rem;
        animation: fadeUp .6s ease .2s both;
    }
    .aff-hero__commission-row {
        display: flex; gap: 1rem; flex-wrap: wrap;
        animation: fadeUp .6s ease .3s both;
    }
    .aff-hero__comm-pill {
        display: flex; align-items: center; gap: 1rem;
        background: rgba(255,255,255,.12);
        border: 1px solid rgba(255,255,255,.2);
        border-radius: 12px;
        padding: 1rem 1.5rem;
        backdrop-filter: blur(4px);
        transition: transform .2s ease, background .2s ease;
    }
    .aff-hero__comm-pill:hover {
        transform: translateY(-3px);
        background: rgba(255,255,255,.18);
    }
    .aff-hero__comm-pct {
        font-size: 2rem; font-weight: 800; color: #fff; line-height: 1;
    }
    .aff-hero__comm-pct sup { font-size: 1rem; }
    .aff-hero__comm-label {
        font-size: .72rem; font-weight: 600; color: rgba(255,255,255,.75);
        text-transform: uppercase; letter-spacing: .5px; line-height: 1.4;
    }
    .aff-hero__actions {
        position: relative; z-index: 2;
        margin-top: 2rem;
        animation: fadeUp .6s ease .4s both;
    }
    .aff-hero__notice {
        display: inline-flex; align-items: center;
        background: rgba(255,255,255,.15);
        border: 1px solid rgba(255,255,255,.25);
        border-radius: 8px;
        padding: .65rem 1rem;
        font-size: .85rem; color: rgba(255,255,255,.9);
    }

    /* ── Buttons ── */
    .aff-btn {
        display: inline-flex; align-items: center; justify-content: center;
        padding: .7rem 1.6rem; border-radius: 8px;
        font-weight: 600; font-size: .9rem;
        border: 2px solid transparent;
        cursor: pointer; text-decoration: none;
        transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
    }
    .aff-btn:active { transform: scale(.97); }
    .aff-btn--white {
        background: #fff; color: #BA1114; border-color: #fff;
    }
    .aff-btn--white:hover {
        background: transparent; color: #fff;
        box-shadow: 0 6px 20px rgba(0,0,0,.2);
        transform: translateY(-2px);
    }
    .aff-btn--red {
        background: #BA1114; color: #fff; border-color: #BA1114;
    }
    .aff-btn--red:hover {
        background: #a00e10; transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(186,17,20,.4);
    }

    /* ══════════════════════════════════════
       HOW IT WORKS
    ══════════════════════════════════════ */
    .aff-section {
        margin-bottom: 2rem;
    }
    .aff-section__header { text-align: center; margin-bottom: 2rem; }
    .aff-section__header--row { text-align: left; }
    .aff-section__tag {
        display: inline-block;
        background: rgba(186,17,20,.08);
        color: #BA1114;
        border: 1px solid rgba(186,17,20,.2);
        border-radius: 100px;
        padding: .3rem .9rem;
        font-size: .72rem; font-weight: 700; letter-spacing: .7px; text-transform: uppercase;
        margin-bottom: .75rem;
    }
    .aff-section__title {
        font-size: 1.7rem; font-weight: 800; color: #1a1a1a; margin: 0;
    }
    .aff-steps {
        display: flex; align-items: flex-start; gap: 0;
        background: #fff;
        border: 1px solid #e8e8e8;
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(0,0,0,.06);
    }
    .aff-step {
        flex: 1; padding: 2rem 1.75rem; position: relative;
        transition: background .2s ease;
    }
    .aff-step:hover { background: rgba(186,17,20,.025); }
    .aff-step__divider {
        display: flex; align-items: center; justify-content: center;
        color: #BA1114; font-size: .85rem;
        padding: 2rem 0;
        opacity: .4;
        flex-shrink: 0;
    }
    .aff-step__num {
        font-size: 3rem; font-weight: 900; color: rgba(186,17,20,.08);
        line-height: 1; margin-bottom: .5rem;
        font-family: var(--font-sans);
    }
    .aff-step__icon {
        width: 48px; height: 48px;
        display: flex; align-items: center; justify-content: center;
        background: rgba(186,17,20,.08);
        color: #BA1114; border-radius: 12px;
        font-size: 1.15rem;
        margin-bottom: 1rem;
    }
    .aff-step__title { font-size: 1rem; font-weight: 700; color: #1a1a1a; margin: 0 0 .5rem; }
    .aff-step__desc  { font-size: .85rem; color: #666; line-height: 1.6; margin: 0; }

    /* ══════════════════════════════════════
       KPI CARDS
    ══════════════════════════════════════ */
    .aff-kpi-row {
        display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem;
        margin-bottom: 2rem;
    }
    .aff-kpi {
        background: #fff;
        border: 1px solid #e8e8e8;
        border-radius: 14px;
        padding: 1.5rem;
        display: flex; align-items: flex-start; gap: 1rem;
        position: relative; overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,.05);
        transition: transform .22s ease, box-shadow .22s ease;
    }
    .aff-kpi:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 30px rgba(186,17,20,.12);
    }
    .aff-kpi__icon {
        width: 48px; height: 48px; flex-shrink: 0;
        display: flex; align-items: center; justify-content: center;
        background: var(--icon-bg, rgba(186,17,20,.08));
        color: var(--icon-color, #BA1114);
        border-radius: 12px; font-size: 1.1rem;
    }
    .aff-kpi__body { flex: 1; min-width: 0; }
    .aff-kpi__label { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: #888; margin-bottom: .35rem; }
    .aff-kpi__value { font-size: 1.9rem; font-weight: 800; color: #1a1a1a; line-height: 1; margin-bottom: .35rem; }
    .aff-kpi__sub   { font-size: .78rem; color: #BA1114; font-weight: 500; }
    .aff-kpi__bar {
        position: absolute; bottom: 0; left: 0; right: 0; height: 3px;
        background: var(--kpi-color, #BA1114);
        transform: scaleX(0); transform-origin: left;
        transition: transform .6s ease .2s;
        border-radius: 0 0 14px 14px;
    }
    .aff-kpi.visible .aff-kpi__bar { transform: scaleX(1); }
    .aff-kpi--highlight {
        background: linear-gradient(135deg, #BA1114 0%, #8a0d0f 100%);
        border-color: transparent;
    }
    .aff-kpi--highlight:hover { box-shadow: 0 12px 30px rgba(186,17,20,.35); }

    /* ══════════════════════════════════════
       CARDS
    ══════════════════════════════════════ */
    .aff-card {
        background: #fff;
        border: 1px solid #e8e8e8;
        border-radius: 14px;
        box-shadow: 0 2px 8px rgba(0,0,0,.05);
        overflow: hidden;
        transition: transform .22s ease, box-shadow .22s ease;
    }
    .aff-card:hover { transform: translateY(-3px); box-shadow: 0 10px 28px rgba(0,0,0,.08); }
    .aff-card__head {
        display: flex; align-items: flex-start; justify-content: space-between;
        padding: 1.25rem 1.5rem 0;
    }
    .aff-card__title { font-size: 1rem; font-weight: 700; color: #1a1a1a; }
    .aff-card__sub   { font-size: .78rem; color: #999; margin-top: .2rem; }
    .aff-card__badge {
        background: rgba(186,17,20,.07); color: #BA1114;
        border: 1px solid rgba(186,17,20,.15);
        border-radius: 100px; padding: .25rem .7rem;
        font-size: .7rem; font-weight: 700; white-space: nowrap;
        flex-shrink: 0;
    }
    .aff-card__body { padding: 1.25rem 1.5rem; }
    .aff-card--table { border-radius: 14px; }
    .aff-card--table:hover { transform: none; box-shadow: 0 2px 8px rgba(0,0,0,.05); }

    /* 2-col grid */
    .aff-grid-2 {
        display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;
        margin-bottom: 2rem;
    }
    .aff-grid-2--charts { grid-template-columns: 2fr 1fr; }

    /* ══════════════════════════════════════
       REFERRAL LINK BOX
    ══════════════════════════════════════ */
    .aff-link-box {
        display: flex; gap: .5rem;
        background: #f5f5f5; border: 1px solid #e0e0e0;
        border-radius: 10px; overflow: hidden;
        padding: .4rem;
    }
    .aff-link-box__input {
        flex: 1; border: none; background: transparent;
        font-size: .85rem; color: #444; padding: .4rem .6rem;
        outline: none; min-width: 0;
    }
    .aff-link-box__btn {
        background: #BA1114; color: #fff;
        border: none; border-radius: 7px;
        padding: .5rem 1.1rem; font-weight: 600; font-size: .85rem;
        cursor: pointer; white-space: nowrap;
        transition: background .18s ease, transform .12s ease;
        flex-shrink: 0;
    }
    .aff-link-box__btn:hover { background: #a00e10; }
    .aff-link-box__btn:active { transform: scale(.97); }
    /* Share buttons */
    .aff-share-row { display: flex; align-items: center; gap: .5rem; }
    .aff-share-label { font-size: .78rem; font-weight: 600; color: #888; }
    .aff-share-btn {
        width: 34px; height: 34px; border-radius: 8px;
        display: inline-flex; align-items: center; justify-content: center;
        font-size: .85rem; color: #fff; cursor: pointer;
        transition: transform .18s ease, opacity .18s ease;
        text-decoration: none;
    }
    .aff-share-btn:hover { transform: translateY(-2px); opacity: .9; color: #fff; }
    .aff-share-btn--fb { background: #1877f2; }
    .aff-share-btn--tw { background: #000; }
    .aff-share-btn--wa { background: #25d366; }
    /* Code block */
    .aff-code-block { }
    .aff-code-block__label { font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; color: #888; margin-bottom: .5rem; }
    .aff-code-block__pre {
        background: #f5f5f5; border: 1px solid #e8e8e8; border-radius: 8px;
        padding: .75rem 1rem; font-size: .78rem; color: #444;
        white-space: pre-wrap; word-break: break-all; margin: 0;
    }

    /* ══════════════════════════════════════
       FINANCIAL OVERVIEW CARD
    ══════════════════════════════════════ */
    .aff-finance {
        background: linear-gradient(145deg, #BA1114 0%, #7a0a0c 100%);
        border-radius: 14px; color: #fff;
        padding: 1.75rem; position: relative; overflow: hidden;
        box-shadow: 0 8px 30px rgba(186,17,20,.35);
        transition: transform .22s ease, box-shadow .22s ease;
    }
    .aff-finance:hover { transform: translateY(-4px); box-shadow: 0 16px 40px rgba(186,17,20,.45); }
    .aff-finance__glow {
        position: absolute; inset: 0;
        background: radial-gradient(circle at 80% 20%, rgba(255,255,255,.12) 0%, transparent 60%);
        pointer-events: none;
    }
    .aff-finance__icon-bg {
        position: absolute; bottom: -20px; right: -10px;
        font-size: 7rem; color: rgba(255,255,255,.06); pointer-events: none;
        line-height: 1;
    }
    .aff-finance__head { font-size: 1.1rem; font-weight: 700; color: #fff; margin-bottom: .3rem; position: relative; }
    .aff-finance__subtitle { font-size: .78rem; color: rgba(255,255,255,.6); margin-bottom: 1.5rem; position: relative; }
    .aff-finance__rows { display: flex; flex-direction: column; gap: 0; position: relative; }
    .aff-finance__row { display: flex; justify-content: space-between; align-items: center; padding: .85rem 0; }
    .aff-finance__row-label { display: flex; align-items: center; gap: .6rem; font-size: .84rem; color: rgba(255,255,255,.75); }
    .aff-finance__row-label i { font-size: .75rem; opacity: .7; }
    .aff-finance__row-val { font-size: 1rem; font-weight: 700; color: #fff; }
    .aff-finance__row-val--highlight { font-size: 1.3rem; color: #ffd6d7; }
    .aff-finance__divider { height: 1px; background: rgba(255,255,255,.12); }

    /* ══════════════════════════════════════
       COMMISSION RATES
    ══════════════════════════════════════ */
    .aff-section--rates { }
    .aff-rates-grid {
        display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem;
        margin-bottom: 1rem;
    }
    .aff-rate-card {
        background: #fff; border: 1px solid #e8e8e8;
        border-radius: 14px; padding: 1.75rem 1.5rem;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0,0,0,.05);
        transition: transform .22s ease, box-shadow .22s ease, border-color .22s ease;
        position: relative; overflow: hidden;
    }
    .aff-rate-card::before {
        content: '';
        position: absolute; top: 0; left: 0; right: 0; height: 3px;
        background: #BA1114;
        transform: scaleX(0);
        transition: transform .3s ease;
    }
    .aff-rate-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 16px 36px rgba(186,17,20,.14);
        border-color: rgba(186,17,20,.25);
    }
    .aff-rate-card:hover::before { transform: scaleX(1); }
    .aff-rate-card__pct {
        font-size: 2.8rem; font-weight: 900; color: #BA1114;
        line-height: 1; margin-bottom: .6rem;
    }
    .aff-rate-card__name { font-size: .95rem; font-weight: 700; color: #1a1a1a; margin-bottom: .4rem; }
    .aff-rate-card__desc { font-size: .78rem; color: #888; line-height: 1.5; }
    .aff-rates-note {
        font-size: .8rem; color: #888;
        background: rgba(186,17,20,.04);
        border: 1px solid rgba(186,17,20,.1);
        border-radius: 8px; padding: .75rem 1rem;
        text-align: center; margin: 0;
    }

    /* ══════════════════════════════════════
       TABLE
    ══════════════════════════════════════ */
    .aff-table { color: #1a1a1a; border-collapse: collapse; }
    .aff-table thead tr { border-bottom: 2px solid #f0f0f0; }
    .aff-table thead th {
        font-size: .72rem; font-weight: 700; text-transform: uppercase;
        letter-spacing: .5px; color: #888; padding: .75rem 1rem;
        border: none; background: #fafafa;
    }
    .aff-table tbody tr {
        border-bottom: 1px solid #f5f5f5;
        transition: background .15s ease;
    }
    .aff-table tbody tr:hover { background: rgba(186,17,20,.025); }
    .aff-table tbody tr:last-child { border-bottom: none; }
    .aff-commission-val { font-weight: 700; color: #BA1114; }
    /* Badges */
    .aff-badge {
        display: inline-flex; align-items: center;
        padding: .3rem .8rem; border-radius: 100px;
        font-size: .72rem; font-weight: 600;
    }
    .aff-badge--pending  { background: rgba(230,81,0,.08);   color: #e65100; border: 1px solid rgba(230,81,0,.2); }
    .aff-badge--active   { background: rgba(46,125,50,.08);  color: #2e7d32; border: 1px solid rgba(46,125,50,.2); }
    .aff-badge--cancelled{ background: rgba(186,17,20,.08);  color: #BA1114; border: 1px solid rgba(186,17,20,.2); }
    .aff-badge--default  { background: rgba(0,0,0,.05);      color: #555;    border: 1px solid rgba(0,0,0,.1); }

    /* Empty state */
    .aff-empty-row { padding: 3rem !important; }
    .aff-empty { text-align: center; }
    .aff-empty__icon {
        width: 60px; height: 60px; margin: 0 auto 1rem;
        background: rgba(186,17,20,.06); border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        font-size: 1.4rem; color: rgba(186,17,20,.4);
    }
    .aff-empty__title { font-weight: 700; color: #1a1a1a; margin-bottom: .4rem; }
    .aff-empty__sub   { font-size: .85rem; color: #888; }

    /* DataTables custom wrapper */
    .aff-dt-top {
        display: flex; align-items: center; justify-content: space-between;
        padding: 1rem 1.5rem; border-bottom: 1px solid #f0f0f0;
    }
    .aff-dt-len, .aff-dt-search { display: flex; align-items: center; gap: .5rem; }
    .aff-dt-foot {
        display: flex; align-items: center; justify-content: space-between;
        padding: .85rem 1.5rem; border-top: 1px solid #f0f0f0;
        font-size: .8rem; color: #888;
    }
    div.dataTables_wrapper div.dataTables_filter input {
        border: 1px solid #e0e0e0; border-radius: 8px;
        padding: .4rem .8rem; font-size: .85rem;
        transition: border-color .15s, box-shadow .15s; outline: none;
    }
    div.dataTables_wrapper div.dataTables_filter input:focus {
        border-color: #BA1114;
        box-shadow: 0 0 0 3px rgba(186,17,20,.12);
    }
    div.dataTables_wrapper div.dataTables_length select {
        border: 1px solid #e0e0e0; border-radius: 8px;
        padding: .4rem 2rem .4rem .7rem; font-size: .85rem; outline: none;
    }
    .dataTables_paginate .paginate_button {
        border-radius: 6px !important;
        border: 1px solid #e0e0e0 !important;
        margin: 0 2px !important;
        padding: .3rem .65rem !important;
        font-size: .82rem !important;
        transition: background .15s, color .15s !important;
    }
    .dataTables_paginate .paginate_button.current,
    .dataTables_paginate .paginate_button.current:hover {
        background: #BA1114 !important; color: #fff !important;
        border-color: #BA1114 !important;
    }
    .dataTables_paginate .paginate_button:hover:not(.current) {
        background: rgba(186,17,20,.06) !important; color: #BA1114 !important;
        border-color: rgba(186,17,20,.2) !important;
    }
    table.dataTable.no-footer { border-bottom: none; }

    /* Spinner */
    .aff-spinner {
        width: 36px; height: 36px; margin: 0 auto;
        border: 3px solid rgba(186,17,20,.15);
        border-top-color: #BA1114;
        border-radius: 50%;
        animation: spin .7s linear infinite;
    }

    /* ══════════════════════════════════════
       ANIMATIONS
    ══════════════════════════════════════ */
    @keyframes fadeUp {
        from { opacity: 0; transform: translateY(20px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    /* Scroll reveal */
    .reveal {
        opacity: 0;
        transform: translateY(24px);
        transition: opacity .55s ease, transform .55s ease;
    }
    .reveal.visible {
        opacity: 1;
        transform: translateY(0);
    }
    /* Hero uses CSS animation directly — don't double-animate */
    .reveal-hero { opacity: 1 !important; transform: none !important; }

    /* ── Reduced motion ── */
    @media (prefers-reduced-motion: reduce) {
        *, *::before, *::after {
            animation-duration: .01ms !important;
            transition-duration: .01ms !important;
        }
        .reveal { opacity: 1; transform: none; }
        .aff-kpi__bar { transform: scaleX(1); }
    }

    /* ── Responsive ── */
    @media (max-width: 1024px) {
        .aff-kpi-row       { grid-template-columns: repeat(2, 1fr); }
        .aff-rates-grid    { grid-template-columns: repeat(2, 1fr); }
        .aff-grid-2--charts{ grid-template-columns: 1fr; }
    }
    @media (max-width: 768px) {
        .aff-hero__title          { font-size: 1.7rem; }
        .aff-hero__commission-row { flex-direction: column; gap: .75rem; }
        .aff-hero__comm-pill      { width: 100%; }
        .aff-kpi-row              { grid-template-columns: 1fr 1fr; }
        .aff-grid-2               { grid-template-columns: 1fr; }
        .aff-rates-grid           { grid-template-columns: 1fr 1fr; }
        .aff-steps                { flex-direction: column; }
        .aff-step__divider        { display: none; }
    }
    @media (max-width: 480px) {
        .aff-kpi-row   { grid-template-columns: 1fr; }
        .aff-rates-grid{ grid-template-columns: 1fr; }
        .aff-hero      { padding: 2rem 1.25rem 1.75rem; }
    }
    </style>


    <!-- ═══════════════════════════════════════════════════════════════
         SCRIPTS
    ═══════════════════════════════════════════════════════════════ -->
    <script>
    /* ── Copy referral link ── */
    function copyReferralLink() {
        var input = document.getElementById('referralLinkInput');
        input.select(); input.setSelectionRange(0, 99999);
        navigator.clipboard.writeText(input.value).catch(function() {
            document.execCommand('copy');
        });
        var btn = document.getElementById('copyBtn');
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check me-1"></i> Copied!';
        btn.style.background = '#198754';
        setTimeout(function() {
            btn.innerHTML = orig;
            btn.style.background = '#BA1114';
        }, 2200);
    }

    /* ── Social share ── */
    function shareAffiliate(platform) {
        var link = document.getElementById('referralLinkInput').value;
        var text = encodeURIComponent('Get reliable hosting with SNBD HOST! Use my link: ');
        var url  = encodeURIComponent(link);
        var target = '';
        if (platform === 'facebook') target = 'https://www.facebook.com/sharer/sharer.php?u=' + url;
        if (platform === 'twitter')  target = 'https://twitter.com/intent/tweet?text=' + text + url;
        if (platform === 'whatsapp') target = 'https://api.whatsapp.com/send?text=' + text + url;
        if (target) window.open(target, '_blank', 'width=600,height=450');
    }

    /* ── Scroll reveal ── */
    (function() {
        var obs = new IntersectionObserver(function(entries) {
            entries.forEach(function(e) {
                if (e.isIntersecting) {
                    e.target.classList.add('visible');
                    obs.unobserve(e.target);
                }
            });
        }, { threshold: 0.1 });
        document.querySelectorAll('.reveal').forEach(function(el) { obs.observe(el); });
    })();

    /* ── Animated counters ── */
    (function() {
        var counterObs = new IntersectionObserver(function(entries) {
            entries.forEach(function(e) {
                if (e.isIntersecting) {
                    animateCounter(e.target);
                    counterObs.unobserve(e.target);
                }
            });
        }, { threshold: 0.5 });

        document.querySelectorAll('[data-target]').forEach(function(el) {
            counterObs.observe(el);
        });

        function animateCounter(el) {
            var target = parseInt(el.dataset.target, 10) || 0;
            if (target === 0) return;
            var duration = 1400;
            var start = performance.now();
            function update(now) {
                var progress = Math.min((now - start) / duration, 1);
                var eased = 1 - Math.pow(1 - progress, 3);
                el.textContent = Math.floor(eased * target).toLocaleString() + (el.dataset.suffix || '');
                if (progress < 1) requestAnimationFrame(update);
            }
            requestAnimationFrame(update);
        }
    })();

    /* ── Charts ── */
    document.addEventListener('DOMContentLoaded', function() {

        function parseCurrency(str) {
            if (!str) return 0;
            var n = parseFloat(str.replace(/[^0-9.]/g, ''));
            return isNaN(n) ? 0 : n;
        }

        var pendingVal   = parseCurrency(document.getElementById('rawPending').value);
        var availableVal = parseCurrency(document.getElementById('rawAvailable').value);
        var withdrawnVal = parseCurrency(document.getElementById('rawWithdrawn').value);
        var clicksVal    = parseInt(document.getElementById('valClicks').value)  || 0;
        var signupsVal   = parseInt(document.getElementById('valSignups').value) || 0;
        var lostClicks   = Math.max(0, clicksVal - signupsVal);

        Chart.defaults.font.family = "'Inter', 'Helvetica Neue', sans-serif";
        Chart.defaults.color = '#999';

        /* Bar — Earnings */
        var ctxE = document.getElementById('earningsChart').getContext('2d');
        var gradRed = ctxE.createLinearGradient(0, 0, 0, 280);
        gradRed.addColorStop(0, 'rgba(186,17,20,.85)');
        gradRed.addColorStop(1, 'rgba(186,17,20,.25)');
        var gradDark = ctxE.createLinearGradient(0, 0, 0, 280);
        gradDark.addColorStop(0, 'rgba(26,26,26,.85)');
        gradDark.addColorStop(1, 'rgba(26,26,26,.3)');
        var gradGray = ctxE.createLinearGradient(0, 0, 0, 280);
        gradGray.addColorStop(0, 'rgba(136,136,136,.7)');
        gradGray.addColorStop(1, 'rgba(136,136,136,.2)');

        new Chart(ctxE, {
            type: 'bar',
            data: {
                labels: ['Pending', 'Available', 'Withdrawn'],
                datasets: [{
                    label: 'Amount',
                    data: [pendingVal, availableVal, withdrawnVal],
                    backgroundColor: [gradGray, gradRed, gradDark],
                    borderRadius: 8,
                    borderSkipped: false,
                    maxBarThickness: 64
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1a1a1a', titleColor: '#fff', bodyColor: '#ccc',
                        borderWidth: 0, padding: 12, displayColors: false,
                        callbacks: {
                            label: function(ctx) { return ctx.parsed.y.toFixed(2); }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0,0,0,.06)', drawBorder: false },
                        ticks: { padding: 8 }
                    },
                    x: {
                        grid: { display: false, drawBorder: false },
                        ticks: { padding: 8, font: { weight: '600' } }
                    }
                },
                animation: { duration: 900, easing: 'easeOutQuart' }
            }
        });

        /* Doughnut — Conversion */
        var ctxD = document.getElementById('conversionChart').getContext('2d');
        var hasData = clicksVal > 0 || signupsVal > 0;
        new Chart(ctxD, {
            type: 'doughnut',
            data: {
                labels: hasData ? ['Signups', 'Not Converted'] : ['No Data'],
                datasets: [{
                    data: hasData ? [signupsVal, lostClicks] : [1],
                    backgroundColor: hasData ? ['#BA1114', '#1a1a1a'] : ['#f0f0f0'],
                    borderWidth: 0, hoverOffset: 6
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                cutout: '72%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 16, usePointStyle: true, pointStyle: 'circle', font: { size: 12 } }
                    },
                    tooltip: {
                        enabled: hasData,
                        backgroundColor: '#1a1a1a', titleColor: '#fff', bodyColor: '#ccc',
                        borderWidth: 0, padding: 10
                    }
                },
                animation: { animateRotate: true, duration: 900 }
            }
        });
    });
    </script>

{/if}
