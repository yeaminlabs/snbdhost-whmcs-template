{include file="orderforms/snbdhost_cart/common.tpl"}

<script>
{literal}
var _localLang = {
{/literal}
    'addToCart': '{$LANG.orderForm.addToCart|escape}',
    'addedToCartRemove': '{$LANG.orderForm.addedToCartRemove|escape}'
{literal}
}
{/literal}
</script>

<style>
/* ── Domain Config Premium Redesign ── */
.dc-page-wrapper {
    max-width: 860px;
    margin: 0 auto;
    padding: 0 1rem 3rem;
}
.dc-page-header {
    margin-bottom: 2.5rem;
}
.dc-page-header h1 {
    font-size: 2rem;
    font-weight: 800;
    color: #0f172a;
    margin-bottom: 0.4rem;
}
.dc-page-header p {
    color: #64748b;
    font-size: 1rem;
    margin: 0;
}

/* Domain Card */
.dc-domain-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    overflow: hidden;
    margin-bottom: 2rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.04), 0 4px 16px rgba(0,0,0,0.04);
}
.dc-domain-card-header {
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
    padding: 1.25rem 1.75rem;
    display: flex;
    align-items: center;
    gap: 1rem;
}
.dc-domain-icon {
    width: 42px;
    height: 42px;
    background: rgba(255,255,255,0.1);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.dc-domain-icon i {
    color: #fff;
    font-size: 1.2rem;
}
.dc-domain-name {
    font-size: 1.25rem;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: -0.01em;
    word-break: break-all;
}

/* Domain Meta Row */
.dc-domain-meta {
    display: flex;
    gap: 0;
    border-bottom: 1px solid #f1f5f9;
}
.dc-meta-item {
    flex: 1;
    padding: 1.1rem 1.75rem;
    border-right: 1px solid #f1f5f9;
}
.dc-meta-item:last-child { border-right: none; }
.dc-meta-label {
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    color: #94a3b8;
    margin-bottom: 0.3rem;
}
.dc-meta-value {
    font-size: 1rem;
    font-weight: 700;
    color: #1e293b;
}
.dc-meta-value.has-hosting {
    color: #16a34a;
}
.dc-meta-value.no-hosting {
    color: #dc2626;
    font-size: 0.875rem;
}
.dc-meta-value.no-hosting a {
    color: #dc2626;
    text-decoration: underline;
    font-weight: 700;
}

/* EPP code */
.dc-epp-row {
    padding: 1rem 1.75rem;
    border-bottom: 1px solid #f1f5f9;
}
.dc-epp-row label {
    font-size: 0.85rem;
    font-weight: 600;
    color: #475569;
    margin-bottom: 0.5rem;
    display: block;
}
.dc-epp-row input {
    width: 100%;
    padding: 0.6rem 1rem;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.95rem;
    color: #1e293b;
    outline: none;
    transition: border-color 0.2s;
}
.dc-epp-row input:focus {
    border-color: #94a3b8;
    box-shadow: 0 0 0 3px rgba(148,163,184,0.15);
}

/* Addons Grid */
.dc-addons-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 1px;
    background: #f1f5f9;
}
.dc-addon-card {
    background: #ffffff;
    padding: 1.5rem 1.75rem;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    cursor: pointer;
    transition: background 0.15s;
    position: relative;
}
.dc-addon-card:hover {
    background: #fafbff;
}
.dc-addon-card.is-selected {
    background: #f0fdf4;
}
.dc-addon-card input[type="checkbox"] {
    position: absolute;
    top: 1.25rem;
    right: 1.25rem;
    width: 18px;
    height: 18px;
    accent-color: #16a34a;
    cursor: pointer;
}
.dc-addon-icon-wrap {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: #f1f5f9;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
    color: #475569;
}
.dc-addon-card.is-selected .dc-addon-icon-wrap {
    background: #dcfce7;
    color: #16a34a;
}
.dc-addon-title {
    font-size: 0.95rem;
    font-weight: 700;
    color: #1e293b;
    padding-right: 1.5rem;
}
.dc-addon-desc {
    font-size: 0.83rem;
    color: #64748b;
    line-height: 1.5;
    flex: 1;
}
.dc-addon-price {
    display: inline-block;
    background: #f0fdf4;
    color: #16a34a;
    font-weight: 700;
    font-size: 0.85rem;
    padding: 0.3rem 0.75rem;
    border-radius: 99px;
    border: 1px solid #bbf7d0;
    margin-top: 0.25rem;
}

/* Domain fields */
.dc-fields-row {
    padding: 1rem 1.75rem;
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    border-top: 1px solid #f1f5f9;
}

/* Nameservers */
.dc-ns-section {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 2rem 1.75rem;
    margin-bottom: 2rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.04);
}
.dc-ns-section h3 {
    font-size: 1.1rem;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 0.4rem;
}
.dc-ns-section p {
    font-size: 0.88rem;
    color: #64748b;
    margin-bottom: 1.25rem;
}
.dc-ns-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 1rem;
}
.dc-ns-grid .form-group {
    margin: 0;
}
.dc-ns-grid label {
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #94a3b8;
    margin-bottom: 0.4rem;
    display: block;
}
.dc-ns-grid input {
    width: 100%;
    padding: 0.6rem 1rem;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.93rem;
    color: #1e293b;
    outline: none;
    transition: border-color 0.2s;
}
.dc-ns-grid input:focus {
    border-color: #94a3b8;
    box-shadow: 0 0 0 3px rgba(148,163,184,0.15);
}

/* Continue Button */
.dc-continue-wrap {
    display: flex;
    justify-content: center;
    padding-top: 1rem;
}
.dc-continue-btn {
    background: #d32f2f;
    color: #fff;
    font-size: 1.05rem;
    font-weight: 700;
    padding: 0.85rem 3rem;
    border: none;
    border-radius: 99px;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 0.65rem;
    box-shadow: 0 4px 15px rgba(211,47,47,0.25);
    transition: all 0.2s ease;
}
.dc-continue-btn:hover {
    background: #b71c1c;
    transform: translateY(-1px);
    box-shadow: 0 8px 25px rgba(211,47,47,0.3);
}
.dc-continue-btn i { font-size: 1.1rem; }

/* Error alert */
.dc-alert-error {
    background: #fef2f2;
    border: 1px solid #fecaca;
    border-radius: 12px;
    padding: 1rem 1.25rem;
    margin-bottom: 1.5rem;
    color: #991b1b;
    font-size: 0.9rem;
}
@media (max-width: 575px) {
    .dc-domain-meta {
        flex-direction: column !important;
    }
    .dc-meta-item {
        border-right: none !important;
        border-bottom: 1px solid #f1f5f9 !important;
        padding: 0.85rem 1.25rem !important;
    }
    .dc-meta-item:last-child {
        border-bottom: none !important;
    }
}
</style>

<div id="order-standard_cart">
    <div class="row">
        <div class="cart-body">
            <div class="dc-page-wrapper">

                <div class="dc-page-header">
                    <h1>{$LANG.cartdomainsconfig}</h1>
                    <p>{$LANG.orderForm.reviewDomainAndAddons}</p>
                </div>

                <form method="post" action="{$smarty.server.PHP_SELF}?a=confdomains" id="frmConfigureDomains">
                    <input type="hidden" name="update" value="true" />

                    {if $errormessage}
                        <div class="dc-alert-error">
                            <strong>{$LANG.orderForm.correctErrors}:</strong>
                            <ul style="margin:0.5rem 0 0 1rem; padding:0;">
                                {$errormessage}
                            </ul>
                        </div>
                    {/if}

                    {foreach $domains as $num => $domain}

                        <div class="dc-domain-card">

                            {* Header *}
                            <div class="dc-domain-card-header">
                                <div class="dc-domain-icon">
                                    <i class="fas fa-globe"></i>
                                </div>
                                <div class="dc-domain-name">{$domain.domain}</div>
                            </div>

                            {* Meta row: reg period + hosting *}
                            <div class="dc-domain-meta">
                                <div class="dc-meta-item">
                                    <div class="dc-meta-label">{$LANG.orderregperiod}</div>
                                    <div class="dc-meta-value">{$domain.regperiod} {$LANG.orderyears}</div>
                                </div>
                                <div class="dc-meta-item">
                                    <div class="dc-meta-label">{$LANG.hosting}</div>
                                    <div class="dc-meta-value {if $domain.hosting}has-hosting{else}no-hosting{/if}">
                                        {if $domain.hosting}
                                            <i class="fas fa-check-circle" style="margin-right:4px;"></i>{$LANG.cartdomainshashosting}
                                        {else}
                                            <a href="{$WEB_ROOT}/cart.php"><i class="fas fa-exclamation-triangle" style="margin-right:4px;"></i>{$LANG.cartdomainsnohosting}</a>
                                        {/if}
                                    </div>
                                </div>
                            </div>

                            {* EPP Code *}
                            {if $domain.eppenabled}
                                <div class="dc-epp-row">
                                    <label for="inputEppcode{$num}">
                                        <i class="fas fa-lock" style="margin-right:5px; color:#94a3b8;"></i>{$LANG.domaineppcode}
                                    </label>
                                    <input type="text" name="epp[{$num}]" id="inputEppcode{$num}" value="{$domain.eppvalue}" placeholder="{$LANG.domaineppcode}" />
                                    <div style="font-size:0.8rem; color:#94a3b8; margin-top:0.4rem;">{$LANG.domaineppcodedesc}</div>
                                </div>
                            {/if}

                            {* Addon Cards *}
                            {if $domain.dnsmanagement || $domain.emailforwarding || $domain.idprotection}
                                <div class="dc-addons-grid">

                                    {if $domain.dnsmanagement}
                                        <label class="dc-addon-card{if $domain.dnsmanagementselected} is-selected{/if}" style="cursor:pointer; display:flex; flex-direction:column; gap:0.75rem;">
                                            <input type="checkbox" name="dnsmanagement[{$num}]"{if $domain.dnsmanagementselected} checked{/if} onclick="this.closest('.dc-addon-card').classList.toggle('is-selected', this.checked)" />
                                            <div class="dc-addon-icon-wrap">
                                                <i class="fas fa-server"></i>
                                            </div>
                                            <div class="dc-addon-title">{$LANG.domaindnsmanagement}</div>
                                            <div class="dc-addon-desc">{$LANG.domainaddonsdnsmanagementinfo}</div>
                                            <span class="dc-addon-price">{$domain.dnsmanagementprice} / {$domain.regperiod} {$LANG.orderyears}</span>
                                        </label>
                                    {/if}

                                    {if $domain.idprotection}
                                        <label class="dc-addon-card{if $domain.idprotectionselected} is-selected{/if}" style="cursor:pointer; display:flex; flex-direction:column; gap:0.75rem;">
                                            <input type="checkbox" name="idprotection[{$num}]"{if $domain.idprotectionselected} checked{/if} onclick="this.closest('.dc-addon-card').classList.toggle('is-selected', this.checked)" />
                                            <div class="dc-addon-icon-wrap">
                                                <i class="fas fa-shield-alt"></i>
                                            </div>
                                            <div class="dc-addon-title">{$LANG.domainidprotection}</div>
                                            <div class="dc-addon-desc">{$LANG.domainaddonsidprotectioninfo}</div>
                                            <span class="dc-addon-price">{$domain.idprotectionprice} / {$domain.regperiod} {$LANG.orderyears}</span>
                                        </label>
                                    {/if}

                                    {if $domain.emailforwarding}
                                        <label class="dc-addon-card{if $domain.emailforwardingselected} is-selected{/if}" style="cursor:pointer; display:flex; flex-direction:column; gap:0.75rem;">
                                            <input type="checkbox" name="emailforwarding[{$num}]"{if $domain.emailforwardingselected} checked{/if} onclick="this.closest('.dc-addon-card').classList.toggle('is-selected', this.checked)" />
                                            <div class="dc-addon-icon-wrap">
                                                <i class="fas fa-envelope-open-text"></i>
                                            </div>
                                            <div class="dc-addon-title">{$LANG.domainemailforwarding}</div>
                                            <div class="dc-addon-desc">{$LANG.domainaddonsemailforwardinginfo}</div>
                                            <span class="dc-addon-price">{$domain.emailforwardingprice} / {$domain.regperiod} {$LANG.orderyears}</span>
                                        </label>
                                    {/if}

                                </div>
                            {/if}

                            {* Extra domain fields *}
                            {if $domain.fields}
                                <div class="dc-fields-row">
                                    {foreach from=$domain.fields key=domainfieldname item=domainfield}
                                        <div style="display:flex; gap:1rem; align-items:center; font-size:0.9rem; color:#475569;">
                                            <span style="font-weight:600; min-width:130px;">{$domainfieldname}:</span>
                                            <span>{$domainfield}</span>
                                        </div>
                                    {/foreach}
                                </div>
                            {/if}

                        </div>

                    {/foreach}

                    {* Nameservers *}
                    {if $atleastonenohosting}
                        <div class="dc-ns-section">
                            <h3><i class="fas fa-network-wired" style="margin-right:8px; color:#94a3b8;"></i>{$LANG.domainnameservers}</h3>
                            <p>{$LANG.cartnameserversdesc}</p>
                            <div class="dc-ns-grid">
                                <div class="form-group">
                                    <label for="inputNs1">{$LANG.domainnameserver1}</label>
                                    <input type="text" class="form-control" id="inputNs1" name="domainns1" value="{$domainns1}" />
                                </div>
                                <div class="form-group">
                                    <label for="inputNs2">{$LANG.domainnameserver2}</label>
                                    <input type="text" class="form-control" id="inputNs2" name="domainns2" value="{$domainns2}" />
                                </div>
                                <div class="form-group">
                                    <label for="inputNs3">{$LANG.domainnameserver3}</label>
                                    <input type="text" class="form-control" id="inputNs3" name="domainns3" value="{$domainns3}" />
                                </div>
                                <div class="form-group">
                                    <label for="inputNs4">{$LANG.domainnameserver4}</label>
                                    <input type="text" class="form-control" id="inputNs4" name="domainns4" value="{$domainns4}" />
                                </div>
                                <div class="form-group">
                                    <label for="inputNs5">{$LANG.domainnameserver5}</label>
                                    <input type="text" class="form-control" id="inputNs5" name="domainns5" value="{$domainns5}" />
                                </div>
                            </div>
                        </div>
                    {/if}

                    <div class="dc-continue-wrap">
                        <button type="submit" class="dc-continue-btn">
                            {$LANG.continue}
                            <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>

{include file="orderforms/snbdhost_cart/recommendations-modal.tpl"}
