<!-- ====== AFFILIATES ====== -->
{if $inactive}
    {include file="$template/includes/alert.tpl" type="danger" msg="{lang key='affiliatesdisabled'}" textcenter=true}
{else}
    {include file="$template/includes/flashmessage.tpl"}

    <div class="snbd-stack">

        <header class="snbd-page-head">
            <div class="snbd-page-head__text">
                <p class="snbd-eyebrow">Affiliate programme</p>
                <h1 class="snbd-page-title">Referrals</h1>
                <p class="snbd-page-sub">Earn recurring commission on every referral — no cap, no expiry.</p>
            </div>
            <div class="snbd-page-actions">
                {if !$withdrawrequestsent && $withdrawlevel}
                    <form method="POST" action="{$smarty.server.PHP_SELF}">
                        <input type="hidden" name="action" value="withdrawrequest">
                        <button type="submit" class="snbd-btn snbd-btn--primary">
                            <i class="ti ti-send" aria-hidden="true"></i> Request payout
                        </button>
                    </form>
                {else}
                    <span class="snbd-cluster">
                        <button type="button" class="snbd-btn snbd-btn--secondary" data-bs-toggle="tooltip" title="Minimum ৳500 BDT required to withdraw" disabled>
                            <i class="ti ti-lock" aria-hidden="true"></i> Request payout
                        </button>
                        <span class="snbd-caption">Min. ৳500 BDT</span>
                    </span>
                {/if}
            </div>
        </header>

        {if $withdrawrequestsent}
            <div class="snbd-alert snbd-alert--ok" role="status">
                <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body">
                    <p class="snbd-alert__title">Payout requested</p>
                    <p class="snbd-alert__text">We will process the withdrawal shortly.</p>
                </div>
            </div>
        {/if}

        <section class="snbd-card snbd-card--spotlight">
            <div class="snbd-card__body">
                <div class="snbd-spread snbd-aff-hero">
                    <div>
                        <span class="snbd-chip snbd-chip--brand"><span class="snbd-chip__dot"></span> Active</span>
                        <h2 class="snbd-aff-hero__title">Your earnings</h2>
                        <p class="snbd-aff-hero__copy">Commission is credited when a referred order is paid, and matures before it can be withdrawn.</p>
                    </div>
                    <div class="snbd-aff-hero__figures">
                        <div>
                            <span class="snbd-aff-hero__label">Available</span>
                            <span class="snbd-aff-hero__value">{$balance}</span>
                        </div>
                        <div>
                            <span class="snbd-aff-hero__label">Pending</span>
                            <span class="snbd-aff-hero__value">{$pendingcommissions}</span>
                        </div>
                        <div>
                            <span class="snbd-aff-hero__label">Withdrawn</span>
                            <span class="snbd-aff-hero__value">{$withdrawn}</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="snbd-stats">
            <div class="snbd-stat">
                <div class="snbd-stat__main"><span class="snbd-stat__label">Total clicks</span><span class="snbd-stat__value">{$visitors}</span></div>
                <span class="snbd-stat__icon snbd-stat__icon--info"><i class="ti ti-pointer" aria-hidden="true"></i></span>
            </div>
            <div class="snbd-stat">
                <div class="snbd-stat__main"><span class="snbd-stat__label">Signups</span><span class="snbd-stat__value">{$signups}</span></div>
                <span class="snbd-stat__icon snbd-stat__icon--ok"><i class="ti ti-user-plus" aria-hidden="true"></i></span>
            </div>
            <div class="snbd-stat">
                <div class="snbd-stat__main"><span class="snbd-stat__label">Conversion</span><span class="snbd-stat__value">{$conversionrate}<span class="snbd-stat__unit">%</span></span></div>
                <span class="snbd-stat__icon snbd-stat__icon--warn"><i class="ti ti-percentage" aria-hidden="true"></i></span>
            </div>
            <div class="snbd-stat">
                <div class="snbd-stat__main"><span class="snbd-stat__label">Maturing</span><span class="snbd-stat__value">{$pendingcommissions}</span></div>
                <span class="snbd-stat__icon"><i class="ti ti-clock" aria-hidden="true"></i></span>
            </div>
            <div class="snbd-stat">
                <div class="snbd-stat__main"><span class="snbd-stat__label">Available</span><span class="snbd-stat__value">{$balance}</span></div>
                <span class="snbd-stat__icon snbd-stat__icon--bad"><i class="ti ti-wallet" aria-hidden="true"></i></span>
            </div>
            <div class="snbd-stat">
                <div class="snbd-stat__main"><span class="snbd-stat__label">Paid out</span><span class="snbd-stat__value">{$withdrawn}</span></div>
                <span class="snbd-stat__icon"><i class="ti ti-checks" aria-hidden="true"></i></span>
            </div>
        </div>

        <div class="snbd-grid snbd-grid--sidebar">

            <div class="snbd-stack">
                <section class="snbd-card">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title"><i class="ti ti-link" aria-hidden="true"></i> Your referral link</h2>
                    </div>
                    <div class="snbd-card__body snbd-stack">
                        <div class="snbd-copy">
                            <label class="snbd-visually-hidden" for="referralLinkInput">Referral link</label>
                            <input type="text" id="referralLinkInput" value="{$referrallink}" readonly>
                            <button type="button" onclick="copyAffLink('referralLinkInput','copyBtn')" id="copyBtn">
                                <i class="ti ti-copy" aria-hidden="true"></i> Copy
                            </button>
                        </div>
                        <div class="snbd-cluster">
                            <a href="https://www.facebook.com/sharer/sharer.php?u={$referrallink|urlencode}" target="_blank" rel="noopener" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
                                <i class="ti ti-brand-facebook" aria-hidden="true"></i> Facebook
                            </a>
                            <a href="https://wa.me/?text={$referrallink|urlencode}" target="_blank" rel="noopener" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
                                <i class="ti ti-brand-whatsapp" aria-hidden="true"></i> WhatsApp
                            </a>
                            <a href="https://t.me/share/url?url={$referrallink|urlencode}" target="_blank" rel="noopener" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
                                <i class="ti ti-brand-telegram" aria-hidden="true"></i> Telegram
                            </a>
                        </div>
                    </div>
                </section>

                <section class="snbd-card">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title"><i class="ti ti-bolt" aria-hidden="true"></i> Deep link</h2>
                        <span class="snbd-caption">Send traffic straight to a product</span>
                    </div>
                    <div class="snbd-card__body snbd-stack">
                        <div class="snbd-grid snbd-grid--2">
                            <div>
                                <label class="snbd-label" for="genProductGroup">Product group</label>
                                <select class="form-select" id="genProductGroup">
                                    <option value="">All groups</option>
                                    {foreach $affiliateProductGroups as $pg}
                                        <option value="{$pg.id}">{$pg.name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div>
                                <label class="snbd-label" for="genProduct">Product</label>
                                <select class="form-select" id="genProduct" disabled>
                                    <option value="">Select a group first</option>
                                </select>
                            </div>
                        </div>
                        <div class="snbd-copy">
                            <label class="snbd-visually-hidden" for="customReferralLinkOutput">Deep link</label>
                            <input type="text" id="customReferralLinkOutput" value="{$referrallink}" readonly>
                            <button type="button" onclick="generateAndCopy()" id="copyCustomBtn">
                                <i class="ti ti-bolt" aria-hidden="true"></i> Generate
                            </button>
                        </div>
                    </div>
                </section>
            </div>

            <div class="snbd-stack">
                <section class="snbd-card">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title"><i class="ti ti-route" aria-hidden="true"></i> How it works</h2>
                    </div>
                    <div class="snbd-card__body">
                        <ol class="snbd-timeline">
                            <li class="snbd-timeline__item">
                                <span class="snbd-timeline__dot"></span>
                                <h3 class="snbd-timeline__title">Share your link</h3>
                                <p class="snbd-small snbd-muted mb-0">Post it on YouTube, social, WhatsApp or your blog.</p>
                            </li>
                            <li class="snbd-timeline__item">
                                <span class="snbd-timeline__dot"></span>
                                <h3 class="snbd-timeline__title">They order</h3>
                                <p class="snbd-small snbd-muted mb-0">Tracking is automatic from signup through payment.</p>
                            </li>
                            <li class="snbd-timeline__item">
                                <span class="snbd-timeline__dot"></span>
                                <h3 class="snbd-timeline__title">You get paid</h3>
                                <p class="snbd-small snbd-muted mb-0">Withdraw to bKash or bank once ৳500 BDT is available.</p>
                            </li>
                        </ol>
                    </div>
                </section>

                <section class="snbd-card">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title"><i class="ti ti-tags" aria-hidden="true"></i> Commission rates</h2>
                    </div>
                    <div class="snbd-card__body snbd-card__body--flush">
                        <ul class="snbd-rate-list">
                            <li class="snbd-rate"><span class="snbd-rate__name"><i class="ti ti-server" aria-hidden="true"></i> Shared hosting</span><span class="snbd-rate__meta"><span class="snbd-chip snbd-chip--ok">20%</span> Recurring</span></li>
                            <li class="snbd-rate"><span class="snbd-rate__name"><i class="ti ti-database" aria-hidden="true"></i> Reseller hosting</span><span class="snbd-rate__meta"><span class="snbd-chip snbd-chip--ok">20%</span> Recurring</span></li>
                            <li class="snbd-rate"><span class="snbd-rate__name"><i class="ti ti-robot" aria-hidden="true"></i> n8n &amp; managed</span><span class="snbd-rate__meta"><span class="snbd-chip snbd-chip--info">15%</span> Recurring</span></li>
                            <li class="snbd-rate"><span class="snbd-rate__name"><i class="ti ti-cloud" aria-hidden="true"></i> VPS hosting</span><span class="snbd-rate__meta"><span class="snbd-chip snbd-chip--neutral">10%</span> Recurring</span></li>
                            <li class="snbd-rate"><span class="snbd-rate__name"><i class="ti ti-world" aria-hidden="true"></i> Domains</span><span class="snbd-rate__meta"><span class="snbd-chip snbd-chip--neutral">0%</span> Flat</span></li>
                        </ul>
                    </div>
                </section>
            </div>
        </div>

        <section class="snbd-card">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title"><i class="ti ti-users" aria-hidden="true"></i> {lang key='affiliatesreferals'}</h2>
                <span class="snbd-caption{if !$referrals} d-none{/if}" id="tableLoading">Loading…</span>
            </div>

            {if $referrals}
                <div class="snbd-card__body snbd-card__body--flush">
                    <div class="snbd-table-wrap">
                        <table id="tableAffiliatesList" class="snbd-table snbd-table--compact w-100 d-none">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Service</th>
                                    <th class="snbd-table__num">Order value</th>
                                    <th class="snbd-table__num">Commission</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            {foreach $referrals as $referral}
                                <tr>
                                    <td>
                                        <span class="d-none">{$referral.datets}</span>
                                        <span class="snbd-muted snbd-small">{$referral.date}</span>
                                    </td>
                                    <td class="fw-semibold">{$referral.service}</td>
                                    <td data-order="{$referral.amountnum}" class="snbd-table__num">{$referral.amountdesc}</td>
                                    <td data-order="{$referral.commissionnum}" class="snbd-table__num fw-semibold">{$referral.commission}</td>
                                    <td>
                                        {if $referral.rawstatus|strtolower == 'pending'}
                                            <span class="snbd-chip snbd-chip--warn">{$referral.status}</span>
                                        {elseif $referral.rawstatus|strtolower == 'active'}
                                            <span class="snbd-chip snbd-chip--ok">{$referral.status}</span>
                                        {elseif $referral.rawstatus|strtolower == 'cancelled' || $referral.rawstatus|strtolower == 'fraud'}
                                            <span class="snbd-chip snbd-chip--bad">{$referral.status}</span>
                                        {else}
                                            <span class="snbd-chip snbd-chip--neutral">{$referral.status}</span>
                                        {/if}
                                    </td>
                                </tr>
                            {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            {else}
                <div class="snbd-empty">
                    <span class="snbd-empty__icon"><i class="ti ti-users" aria-hidden="true"></i></span>
                    <p class="snbd-empty__title">No referrals yet</p>
                    <p class="snbd-empty__text">Share your link — your first commission appears here as soon as someone signs up and pays.</p>
                </div>
            {/if}
        </section>

    </div>

    <script>
    {literal}
    var affiliateProductGroupsData = {/literal}{$affiliateProductGroups|json_encode}{literal};
    var baseReferralLink = "{/literal}{$referrallink}{literal}";

    document.addEventListener("DOMContentLoaded", function () {

        try {
            jQuery('#tableAffiliatesList').removeClass('d-none').DataTable({
                dom: '<"snbd-dt-toolbar"<"snbd-dt-length"l><"snbd-dt-search"f>>rt<"snbd-dt-foot"<"snbd-dt-info"i><"snbd-dt-pag"p>>',
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search referrals…",
                    lengthMenu: "Show _MENU_",
                    info: "_START_–_END_ of _TOTAL_ referrals",
                    emptyTable: "No referrals yet.",
                    zeroRecords: "No matches found."
                }
            });
            jQuery('#tableLoading').addClass('d-none');
        } catch (e) {
            jQuery('#tableLoading').addClass('d-none');
            jQuery('#tableAffiliatesList').removeClass('d-none');
        }

        [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]')).forEach(function (el) {
            new bootstrap.Tooltip(el);
        });

        var groupSel = document.getElementById('genProductGroup');
        var prodSel = document.getElementById('genProduct');
        var linkOut = document.getElementById('customReferralLinkOutput');

        if (groupSel && prodSel && linkOut) {
            groupSel.addEventListener('change', function () {
                var gid = this.value;
                prodSel.innerHTML = '<option value="">All products</option>';
                if (!gid) { prodSel.disabled = true; updateDeepLink(); return; }
                var g = affiliateProductGroupsData.find(function (x) { return x.id == gid; });
                if (g && g.products && g.products.length) {
                    g.products.forEach(function (p) {
                        var o = document.createElement('option');
                        o.value = p.id;
                        o.textContent = p.name;
                        prodSel.appendChild(o);
                    });
                    prodSel.disabled = false;
                } else {
                    prodSel.disabled = true;
                }
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
        inp.select();
        inp.setSelectionRange(0, 99999);
        try {
            document.execCommand('copy');
            if (btn) {
                var orig = btn.innerHTML;
                btn.innerHTML = '<i class="ti ti-check"></i> Copied';
                btn.classList.add('is-copied');
                setTimeout(function () { btn.innerHTML = orig; btn.classList.remove('is-copied'); }, 2000);
            }
        } catch (e) {}
    }

    function generateAndCopy() {
        var groupSel = document.getElementById('genProductGroup');
        var prodSel = document.getElementById('genProduct');
        var linkOut = document.getElementById('customReferralLinkOutput');
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
