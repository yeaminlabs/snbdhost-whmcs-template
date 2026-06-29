{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* ══════════════════════════════════════════════════════
   SNBD HOST — Choose a Domain  (Premium Redesign v2)
══════════════════════════════════════════════════════ */

/* ── Page Wrapper ── */
#order-standard_cart .cpd-outer {
    background: #f8fafc;
    min-height: 100vh;
}

/* ── Hero Banner ── */
.cpd-hero {
    background: linear-gradient(135deg, #0c0f1a 0%, #1a1f35 50%, #0d1525 100%);
    padding: 4rem 1.5rem 6rem;
    text-align: center;
    position: relative;
    overflow: hidden;
}
.cpd-hero::before {
    content: '';
    position: absolute;
    top: -60px; left: 50%;
    transform: translateX(-50%);
    width: 700px; height: 700px;
    background: radial-gradient(ellipse, rgba(211,47,47,0.18) 0%, transparent 65%);
    pointer-events: none;
}
.cpd-hero::after {
    content: '';
    position: absolute;
    bottom: -1px; left: 0; right: 0;
    height: 80px;
    background: #f8fafc;
    clip-path: ellipse(55% 100% at 50% 100%);
}
.cpd-hero-label {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: rgba(211,47,47,0.15);
    border: 1px solid rgba(211,47,47,0.35);
    color: #ff8a80;
    font-size: 0.78rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1px;
    padding: 0.35rem 1rem;
    border-radius: 99px;
    margin-bottom: 1.5rem;
}
.cpd-hero h1 {
    font-size: clamp(2rem, 5vw, 3.2rem);
    font-weight: 900;
    color: #ffffff;
    line-height: 1.1;
    letter-spacing: -0.03em;
    margin-bottom: 0.8rem;
}
.cpd-hero h1 span {
    background: linear-gradient(90deg, #ff6b6b, #ff8a80);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.cpd-hero p {
    color: #94a3b8;
    font-size: 1.05rem;
    max-width: 480px;
    margin: 0 auto;
}

/* ── Option Tabs (register / transfer / own) ── */
.cpd-options-wrap {
    max-width: 800px;
    margin: -2.5rem auto 0;
    padding: 0 1.5rem;
    position: relative;
    z-index: 10;
}
.cpd-tabs {
    display: flex;
    gap: 0.75rem;
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 20px;
    padding: 0.6rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.06), 0 20px 40px rgba(0,0,0,0.04);
    flex-wrap: wrap;
}
.cpd-tab-option {
    flex: 1;
    min-width: 140px;
    cursor: pointer;
    display: block;
    margin: 0;
}
.cpd-tab-option input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 0; height: 0;
}
.cpd-tab-inner {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.5rem;
    padding: 1.1rem 1rem;
    border-radius: 14px;
    border: 2px solid transparent;
    transition: all 0.25s cubic-bezier(0.4,0,0.2,1);
    text-align: center;
}
.cpd-tab-inner:hover {
    background: #f8fafc;
}
.cpd-tab-icon {
    width: 44px; height: 44px;
    border-radius: 12px;
    background: #f1f5f9;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem;
    color: #94a3b8;
    transition: all 0.25s ease;
}
.cpd-tab-label {
    font-size: 0.88rem;
    font-weight: 600;
    color: #64748b;
    line-height: 1.3;
    transition: color 0.25s ease;
}
.cpd-tab-option input[type="radio"]:checked + .cpd-tab-inner {
    background: linear-gradient(135deg, #fff5f5, #fff8f8);
    border-color: #fca5a5;
}
.cpd-tab-option input[type="radio"]:checked + .cpd-tab-inner .cpd-tab-icon {
    background: linear-gradient(135deg, #d32f2f, #ef5350);
    color: #ffffff;
    box-shadow: 0 4px 14px rgba(211,47,47,0.35);
}
.cpd-tab-option input[type="radio"]:checked + .cpd-tab-inner .cpd-tab-label {
    color: #b71c1c;
}

/* ── Search Box Area ── */
.cpd-search-area {
    max-width: 800px;
    margin: 1.5rem auto 0;
    padding: 0 1.5rem;
}
.domain-input-groups-wrapper .domain-input-group {
    background: #ffffff;
    border: 1.5px solid #e2e8f0;
    border-radius: 16px;
    padding: 0.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    transition: border-color 0.25s, box-shadow 0.25s;
    display: none;
}
.domain-input-groups-wrapper .domain-input-group:focus-within {
    border-color: #fca5a5;
    box-shadow: 0 0 0 4px rgba(211,47,47,0.08), 0 4px 20px rgba(0,0,0,0.06);
}
.domain-input-inner {
    display: flex;
    align-items: center;
    gap: 0;
}
.domain-prefix {
    font-size: 0.9rem;
    font-weight: 600;
    color: #94a3b8;
    padding: 0.65rem 0.9rem;
    white-space: nowrap;
    flex-shrink: 0;
}
.domain-input-field {
    flex: 1;
    border: none !important;
    outline: none !important;
    box-shadow: none !important;
    background: transparent !important;
    font-size: 1rem;
    font-weight: 500;
    color: #0f172a;
    padding: 0.65rem 0.5rem;
}
.domain-input-field::placeholder { color: #cbd5e1; }
.domain-tld-select {
    border: none !important;
    border-left: 1.5px solid #f1f5f9 !important;
    outline: none !important;
    box-shadow: none !important;
    background: transparent !important;
    font-size: 0.92rem;
    font-weight: 600;
    color: #475569;
    padding: 0.65rem 0.6rem;
    min-width: 70px;
    max-width: 120px;
    cursor: pointer;
}
.domain-submit-btn {
    background: linear-gradient(135deg, #d32f2f, #c62828);
    color: #ffffff;
    border: none;
    border-radius: 10px;
    font-weight: 700;
    font-size: 0.95rem;
    padding: 0.65rem 1.5rem;
    cursor: pointer;
    white-space: nowrap;
    flex-shrink: 0;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    box-shadow: 0 2px 8px rgba(211,47,47,0.3);
}
.domain-submit-btn:hover {
    background: linear-gradient(135deg, #b71c1c, #c62828);
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(211,47,47,0.4);
}

/* ── Free Domain Note ── */
.cpd-free-note {
    text-align: center;
    font-size: 0.82rem;
    color: #94a3b8;
    margin-top: 1rem;
    font-style: italic;
}

/* ── Results Area ── */
.cpd-results-outer {
    max-width: 800px;
    margin: 2rem auto 0;
    padding: 0 1.5rem;
}

/* Primary result card */
#searchDomainInfo {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 2rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}
.domain-checker-available.headline {
    font-size: 1.6rem;
    font-weight: 800;
    color: #16a34a;
    letter-spacing: -0.02em;
}
.domain-checker-unavailable.headline {
    font-size: 1.6rem;
    font-weight: 800;
    color: #dc2626;
    letter-spacing: -0.02em;
}
.domain-price .price {
    font-size: 2rem;
    font-weight: 900;
    color: #0f172a;
}
.domain-price .register-price-label,
.domain-price .transfer-price-label {
    font-size: 0.88rem;
    color: #94a3b8;
}
.primary-domain-header {
    font-size: 1.3rem;
    font-weight: 800;
    color: #0f172a;
    margin-bottom: 1rem;
    letter-spacing: -0.01em;
}

/* ── Spotlight TLDs ── */
.spotlight-tlds {
    margin-top: 2rem;
}
.spotlight-tlds-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
    gap: 1rem;
}
#order-standard_cart .spotlight-tld-container,
#order-snbdhost_cart .spotlight-tld-container {
    border: none !important;
    background: transparent !important;
    padding: 0 !important;
    margin: 0 !important;
}
.spotlight-tld {
    background: #ffffff !important;
    border: 1.5px solid #e2e8f0 !important;
    border-radius: 14px !important;
    padding: 1.25rem 0.75rem !important;
    text-align: center;
    position: relative;
    box-shadow: 0 1px 4px rgba(0,0,0,0.03) !important;
    display: flex !important;
    flex-direction: column !important;
    align-items: center !important;
    justify-content: space-between !important;
    min-height: 150px;
    transition: all 0.25s cubic-bezier(0.4,0,0.2,1) !important;
    font-size: 1.25rem !important;
    font-weight: 800 !important;
    color: #0f172a !important;
}
.spotlight-tld:hover {
    transform: translateY(-3px) !important;
    border-color: #fca5a5 !important;
    box-shadow: 0 8px 20px rgba(211,47,47,0.1) !important;
}
#order-standard_cart .spotlight-tld .domain-lookup-result,
#order-snbdhost_cart .spotlight-tld .domain-lookup-result {
    border: none !important;
    background: transparent !important;
    padding: 0 !important;
    margin: 0.75rem 0 0 !important;
    width: 100% !important;
}
.spotlight-tld .price {
    display: block !important;
    font-size: 1rem !important;
    color: #16a34a !important;
    font-weight: 700 !important;
    margin-bottom: 0.5rem !important;
}
.spotlight-tld .btn {
    width: 100% !important;
    border-radius: 8px !important;
    font-size: 0.78rem !important;
    font-weight: 700 !important;
    padding: 0.45rem 0.5rem !important;
    background: #f1f5f9 !important;
    color: #1e293b !important;
    border: 1px solid #e2e8f0 !important;
    transition: all 0.2s ease !important;
}
.spotlight-tld .btn:hover {
    background: #d32f2f !important;
    color: #fff !important;
    border-color: #d32f2f !important;
}
.spotlight-tld-hot  { background: #ef4444 !important; color: #fff !important; font-size: 0.65rem !important; padding: 0.15rem 0.7rem !important; border-radius: 99px !important; font-weight: 700 !important; text-transform: uppercase !important; letter-spacing: 0.4px !important; }
.spotlight-tld-sale { background: #f59e0b !important; color: #fff !important; font-size: 0.65rem !important; padding: 0.15rem 0.7rem !important; border-radius: 99px !important; font-weight: 700 !important; text-transform: uppercase !important; letter-spacing: 0.4px !important; }
.spotlight-tld-new  { background: #10b981 !important; color: #fff !important; font-size: 0.65rem !important; padding: 0.15rem 0.7rem !important; border-radius: 99px !important; font-weight: 700 !important; text-transform: uppercase !important; letter-spacing: 0.4px !important; }

/* ── Suggested Domains ── */
.suggested-domains {
    margin-top: 1.5rem;
    background: #ffffff !important;
    border: 1px solid #e2e8f0 !important;
    border-radius: 16px !important;
    overflow: hidden;
}
.suggested-domains .panel-heading {
    background: #f8fafc !important;
    padding: 1rem 1.25rem;
    font-size: 0.9rem;
    font-weight: 700;
    color: #475569;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #f1f5f9 !important;
}
.suggested-domains .list-group-item {
    border-left: none !important;
    border-right: none !important;
    border-color: #f1f5f9 !important;
    padding: 0.85rem 1.25rem !important;
    transition: background 0.15s;
}
.suggested-domains .list-group-item:hover {
    background: #f8fafc;
}
.suggested-domains .extension {
    font-weight: 700;
    color: #d32f2f;
}
.suggested-domains .price {
    font-weight: 800;
    color: #0f172a;
}
.suggested-domains .actions {
    float: right;
    display: flex;
    align-items: center;
    gap: 0.75rem;
}
.suggested-domains .btn:not(.domain-contact-support) {
    background: #0f172a;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 0.8rem;
    font-weight: 700;
    padding: 0.35rem 1rem;
    cursor: pointer;
}
.suggested-domains .btn:not(.domain-contact-support):hover {
    background: #d32f2f;
}
.suggested-domains .more-suggestions {
    padding: 0.75rem 1.25rem;
    background: #f8fafc !important;
    border-top: 1px solid #f1f5f9 !important;
}
.suggested-domains .more-suggestions a {
    color: #d32f2f;
    font-weight: 700;
    font-size: 0.88rem;
}
.suggested-domains .domain-suggestions-warning {
    background: #f8fafc;
    font-size: 0.78rem;
    color: #94a3b8;
    padding: 0.6rem 1.25rem !important;
    border-top: 1px solid #f1f5f9;
}

/* ── Continue Button ── */
.cpd-continue-wrap {
    max-width: 800px;
    margin: 2rem auto 0;
    padding: 0 1.5rem 3rem;
    text-align: center;
}
#btnDomainContinue {
    background: linear-gradient(135deg, #d32f2f, #c62828) !important;
    color: #fff !important;
    border: none !important;
    border-radius: 99px !important;
    font-size: 1.05rem !important;
    font-weight: 800 !important;
    padding: 1rem 3rem !important;
    box-shadow: 0 4px 20px rgba(211,47,47,0.35) !important;
    transition: all 0.25s ease !important;
    letter-spacing: 0.01em;
}
#btnDomainContinue:hover:not(:disabled) {
    transform: translateY(-2px) !important;
    box-shadow: 0 8px 30px rgba(211,47,47,0.45) !important;
}
#btnDomainContinue:disabled {
    opacity: 0.55 !important;
    cursor: not-allowed !important;
}
</style>

<div id="order-standard_cart">
<div class="cpd-outer">

    {* ── HERO ── *}
    <div class="cpd-hero">
        <div class="cpd-hero-label">
            <i class="fas fa-globe"></i> Domain Registration
        </div>
        <h1>{$LANG.domaincheckerchoosedomain|default:'Find Your Perfect <span>Domain</span>'}</h1>
        <p>Get your perfect domain name or use one you already own to continue.</p>
    </div>

    {* ── OPTION TABS ── *}
    <div class="cpd-options-wrap">
        <form id="frmProductDomain">
            <input type="hidden" id="frmProductDomainPid" value="{$pid}" />

            <div class="cpd-tabs domain-selection-options">

                {if $incartdomains}
                    <label class="cpd-tab-option">
                        <input type="radio" name="domainoption" value="incart" id="selincart" />
                        <div class="cpd-tab-inner">
                            <div class="cpd-tab-icon"><i class="fas fa-shopping-cart"></i></div>
                            <span class="cpd-tab-label">{$LANG.cartproductdomainuseincart}</span>
                        </div>
                    </label>
                {/if}

                {if $registerdomainenabled}
                    <label class="cpd-tab-option">
                        <input type="radio" name="domainoption" value="register" id="selregister"{if $domainoption eq "register"} checked{/if} />
                        <div class="cpd-tab-inner">
                            <div class="cpd-tab-icon"><i class="fas fa-search"></i></div>
                            <span class="cpd-tab-label">Register a new domain</span>
                        </div>
                    </label>
                {/if}

                {if $transferdomainenabled}
                    <label class="cpd-tab-option">
                        <input type="radio" name="domainoption" value="transfer" id="seltransfer"{if $domainoption eq "transfer"} checked{/if} />
                        <div class="cpd-tab-inner">
                            <div class="cpd-tab-icon"><i class="fas fa-exchange-alt"></i></div>
                            <span class="cpd-tab-label">Transfer domain to us</span>
                        </div>
                    </label>
                {/if}

                {if $owndomainenabled}
                    <label class="cpd-tab-option">
                        <input type="radio" name="domainoption" value="owndomain" id="selowndomain"{if $domainoption eq "owndomain"} checked{/if} />
                        <div class="cpd-tab-inner">
                            <div class="cpd-tab-icon"><i class="fas fa-link"></i></div>
                            <span class="cpd-tab-label">Use my existing domain</span>
                        </div>
                    </label>
                {/if}

                {if $subdomains}
                    <label class="cpd-tab-option">
                        <input type="radio" name="domainoption" value="subdomain" id="selsubdomain"{if $domainoption eq "subdomain"} checked{/if} />
                        <div class="cpd-tab-inner">
                            <div class="cpd-tab-icon"><i class="fas fa-sitemap"></i></div>
                            <span class="cpd-tab-label">Use a subdomain</span>
                        </div>
                    </label>
                {/if}

            </div>

            {* ── SEARCH INPUTS ── *}
            <div class="cpd-search-area">
                <div class="domain-input-groups-wrapper">

                    {if $incartdomains}
                        <div class="domain-input-group" id="domainincart">
                            <div class="domain-input-inner">
                                <div class="domain-prefix"><i class="fas fa-shopping-cart"></i></div>
                                <select id="incartsld" name="incartdomain" class="form-control domain-input-field">
                                    {foreach key=num item=incartdomain from=$incartdomains}
                                        <option value="{$incartdomain}">{$incartdomain}</option>
                                    {/foreach}
                                </select>
                                <button type="submit" class="domain-submit-btn">
                                    {$LANG.orderForm.use} <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    {/if}

                    {if $registerdomainenabled}
                        <div class="domain-input-group" id="domainregister">
                            <div class="domain-input-inner">
                                <div class="domain-prefix">www.</div>
                                <input type="text" id="registersld" value="{$sld}" class="form-control domain-input-field" autocapitalize="none" placeholder="enter-your-domain" />
                                <select id="registertld" class="domain-tld-select">
                                    {foreach from=$registertlds item=listtld}
                                        <option value="{$listtld}"{if $listtld eq $tld} selected="selected"{/if}>{$listtld}</option>
                                    {/foreach}
                                </select>
                                <button id="btnCheckAvailability" type="submit" class="domain-submit-btn">
                                    Check <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    {/if}

                    {if $transferdomainenabled}
                        <div class="domain-input-group" id="domaintransfer">
                            <div class="domain-input-inner">
                                <div class="domain-prefix">www.</div>
                                <input type="text" id="transfersld" value="{$sld}" class="form-control domain-input-field" autocapitalize="none" placeholder="enter-your-domain" />
                                <select id="transfertld" class="domain-tld-select">
                                    {foreach from=$transfertlds item=listtld}
                                        <option value="{$listtld}"{if $listtld eq $tld} selected="selected"{/if}>{$listtld}</option>
                                    {/foreach}
                                </select>
                                <button type="submit" class="domain-submit-btn">
                                    Transfer <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    {/if}

                    {if $owndomainenabled}
                        <div class="domain-input-group" id="domainowndomain">
                            <div class="domain-input-inner">
                                <div class="domain-prefix">www.</div>
                                <input type="text" id="owndomainsld" value="{$sld}" placeholder="yourdomain" class="form-control domain-input-field" autocapitalize="none" />
                                <input type="text" id="owndomaintld" value="{$tld|substr:1}" placeholder="com" class="form-control domain-tld-select" style="max-width:100px; text-align:center; appearance:none; background-image:none !important;" autocapitalize="none" />
                                <button type="submit" class="domain-submit-btn" id="useOwnDomain">
                                    Use Domain <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    {/if}

                    {if $subdomains}
                        <div class="domain-input-group" id="domainsubdomain">
                            <div class="domain-input-inner">
                                <div class="domain-prefix">http://</div>
                                <input type="text" id="subdomainsld" value="{$sld}" placeholder="yourname" class="form-control domain-input-field" autocapitalize="none" />
                                <select id="subdomaintld" class="domain-tld-select">
                                    {foreach $subdomains as $subid => $subdomain}
                                        <option value="{$subid}">{$subdomain}</option>
                                    {/foreach}
                                </select>
                                <button type="submit" class="domain-submit-btn">
                                    Check <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    {/if}

                </div>

                {if $freedomaintlds}
                    <p class="cpd-free-note">* {$LANG.orderfreedomainregistration} {$LANG.orderfreedomainappliesto}: {$freedomaintlds}</p>
                {/if}
            </div>

        </form>

        {* ── RESULTS ── *}
        <form method="post" action="{$WEB_ROOT}/cart.php?a=add&pid={$pid}&domainselect=1" id="frmProductDomainSelections">

            <div id="DomainSearchResults" class="w-hidden">

                <div id="primarySuggestionHeading" class="primary-domain-header mt-4"></div>
                <div id="primaryExactHeading" class="primary-domain-header mt-4" style="text-align:center;">{$LANG.domainSearch.exactMatch}</div>

                <div id="searchDomainInfo" class="mt-3 text-center">
                    <p id="primaryLookupSearching" class="domain-lookup-loader domain-lookup-primary-loader domain-searching domain-checker-result-headline" style="font-size:1.1rem; color:#64748b;">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span class="domain-lookup-register-loader"> {lang key='orderForm.checkingAvailability'}...</span>
                        <span class="domain-lookup-transfer-loader"> {lang key='orderForm.verifyingTransferEligibility'}...</span>
                        <span class="domain-lookup-other-loader"> {lang key='orderForm.verifyingDomain'}...</span>
                    </p>
                    <div id="primaryLookupResult" class="domain-lookup-result domain-lookup-primary-results w-hidden">
                        <div class="domain-unavailable domain-checker-unavailable headline">{lang key='orderForm.domainIsUnavailable'}</div>
                        <div class="domain-available domain-checker-available headline">{$LANG.domainavailablemessage}</div>
                        <div class="btn btn-primary domain-contact-support headline">{$LANG.domainContactUs}</div>
                        <div class="transfer-eligible">
                            <p class="domain-checker-available headline">{lang key='orderForm.transferEligible'}</p>
                            <p class="text-muted" style="font-size:0.9rem;">{lang key='orderForm.transferUnlockBeforeContinuing'}</p>
                        </div>
                        <div class="transfer-not-eligible">
                            <p class="domain-checker-unavailable headline">{lang key='orderForm.transferNotEligible'}</p>
                            <p class="text-muted" style="font-size:0.9rem;">{lang key='orderForm.transferNotRegistered'}</p>
                            <p class="text-muted" style="font-size:0.9rem;">{lang key='orderForm.trasnferRecentlyRegistered'}</p>
                            <p class="text-muted" style="font-size:0.9rem;">{lang key='orderForm.transferAlternativelyRegister'}</p>
                        </div>
                        <div class="domain-invalid">
                            <p class="domain-checker-unavailable headline">{lang key='orderForm.domainInvalid'}</p>
                            <p class="text-muted" style="font-size:0.9rem;">
                                {lang key='orderForm.domainLetterOrNumber'}<span class="domain-length-restrictions">{lang key='orderForm.domainLengthRequirements'}</span><br />
                                {lang key='orderForm.domainInvalidCheckEntry'}
                            </p>
                        </div>
                        <div id="idnLanguageSelector" class="margin-10 idn-language-selector idn-language w-hidden">
                            <div class="row">
                                <div class="col-sm-10 col-sm-offset-1 col-lg-8 col-lg-offset-2 offset-sm-1 offset-lg-2">
                                    <div class="margin-10 text-center">{lang key='cart.idnLanguageDescription'}</div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-8 col-lg-6 col-sm-offset-2 col-lg-offset-3 offset-sm-2 offset-lg-3">
                                    <div class="form-group">
                                        <select name="idnlanguage" class="form-control">
                                            <option value="">{lang key='cart.idnLanguage'}</option>
                                            {foreach $idnLanguages as $idnLanguageKey => $idnLanguage}
                                                <option value="{$idnLanguageKey}">{lang key='idnLanguage.'|cat:$idnLanguageKey}</option>
                                            {/foreach}
                                        </select>
                                        <div class="field-error-msg">{lang key='cart.selectIdnLanguageForRegister'}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="domain-price mt-3">
                            <span class="register-price-label text-muted">{lang key='orderForm.domainPriceRegisterLabel'}</span>
                            <span class="transfer-price-label w-hidden text-muted">{lang key='orderForm.domainPriceTransferLabel'}</span>
                            <span class="price"></span>
                        </div>
                        <p class="domain-error domain-checker-unavailable headline" style="color:#dc2626;"></p>
                        <input type="hidden" id="resultDomainOption" name="domainoption" />
                        <input type="hidden" id="resultDomain" name="domains[]" />
                        <input type="hidden" id="resultDomainPricingTerm" />
                    </div>
                </div>

                {if $registerdomainenabled}
                    {if $spotlightTlds}
                        <div id="spotlightTlds" class="spotlight-tlds clearfix w-hidden mt-4">
                            <div class="spotlight-tlds-container">
                                {foreach $spotlightTlds as $key => $data}
                                    <div class="spotlight-tld-container spotlight-tld-container-{$spotlightTlds|count}">
                                        <div id="spotlight{$data.tldNoDots}" class="spotlight-tld">
                                            {if $data.group}
                                                <div class="spotlight-tld-{$data.group}">{$data.groupDisplayName}</div>
                                            {/if}
                                            {$data.tld}
                                            <span class="domain-lookup-loader domain-lookup-spotlight-loader">
                                                <i class="fas fa-spinner fa-spin" style="font-size:0.8rem; color:#94a3b8;"></i>
                                            </span>
                                            <div class="domain-lookup-result">
                                                <button type="button" class="btn unavailable w-hidden" disabled="disabled">{lang key='domainunavailable'}</button>
                                                <button type="button" class="btn invalid w-hidden" disabled="disabled">{lang key='domainunavailable'}</button>
                                                <span class="available price w-hidden">{$data.register}</span>
                                                <button type="button" class="btn btn-add-to-cart product-domain w-hidden" data-whois="0" data-domain="">
                                                    <span class="to-add">{lang key='orderForm.add'}</span>
                                                    <span class="loading"><i class="fas fa-spinner fa-spin"></i></span>
                                                    <span class="added"><i class="far fa-shopping-cart"></i> {lang key='domaincheckeradded'}</span>
                                                    <span class="unavailable">{$LANG.domaincheckertaken}</span>
                                                </button>
                                                <button type="button" class="btn btn-primary domain-contact-support w-hidden">{lang key='domainChecker.contactSupport'}</button>
                                            </div>
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                    {/if}

                    <div class="suggested-domains w-hidden mt-4">
                        <div class="panel-heading card-header">{lang key='orderForm.suggestedDomains'}</div>
                        <div id="suggestionsLoader" class="card-body panel-body domain-lookup-loader domain-lookup-suggestions-loader text-center p-4">
                            <i class="fas fa-spinner fa-spin text-muted"></i>
                            <span class="text-muted ml-2">{lang key='orderForm.generatingSuggestions'}</span>
                        </div>
                        <div class="panel-body card-body domain-lookup-message domain-lookup-suggestions-message text-center p-4 text-muted">
                            {lang key='domainSearch.errors.noSuggestions'}
                        </div>
                        <div id="domainSuggestions" class="domain-lookup-result list-group w-hidden">
                            <div class="domain-suggestion list-group-item w-hidden">
                                <span class="domain"></span><span class="extension"></span>
                                <div class="actions">
                                    <button type="button" class="btn btn-add-to-cart product-domain" data-whois="1" data-domain="">
                                        <span class="to-add">{$LANG.addtocart}</span>
                                        <span class="loading"><i class="fas fa-spinner fa-spin"></i> {lang key='loading'}</span>
                                        <span class="added"><i class="far fa-shopping-cart"></i> {lang key='domaincheckeradded'}</span>
                                        <span class="unavailable">{$LANG.domaincheckertaken}</span>
                                    </button>
                                    <button type="button" class="btn btn-primary domain-contact-support w-hidden">{lang key='domainChecker.contactSupport'}</button>
                                    <span class="price"></span>
                                    <span class="promo w-hidden"></span>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer card-footer more-suggestions text-center w-hidden">
                            <a id="moreSuggestions" href="#" onclick="loadMoreSuggestions();return false;">{lang key='domainsmoresuggestions'}</a>
                            <span id="noMoreSuggestions" class="no-more small w-hidden text-muted">{lang key='domaincheckernomoresuggestions'}</span>
                        </div>
                        <div class="domain-suggestions-warning">
                            <p class="mb-0">{lang key='domainssuggestionswarnings'}</p>
                        </div>
                    </div>
                {/if}

            </div>

            <div class="cpd-continue-wrap">
                <button id="btnDomainContinue" type="submit" class="btn btn-primary btn-lg w-hidden" disabled="disabled">
                    {$LANG.continue} &nbsp;<i class="fas fa-arrow-right"></i>
                </button>
            </div>

        </form>
    </div>

</div>
</div>

{include file="orderforms/snbdhost_cart/recommendations-modal.tpl"}

{if $showAdvancedSearchOptions}
    <script>
        $(document).ready(function() {
            jQuery('#frmProductDomain .multiselect').each(function () {
                let enableFiltering = $(this).hasClass('multiselect-filter');
                const minSelection = jQuery(this).data('min-selection');
                $(this).multiselect({
                    onChange: function (element) {
                        const closestSelect = element.closest('select');
                        const selectedOptions = closestSelect.find('option:selected');
                        if (minSelection === undefined) { return; }
                        const atMinOptions = selectedOptions.length <= minSelection;
                        const targetOptions = atMinOptions ? selectedOptions : closestSelect.find('option');
                        targetOptions.each(function () {
                            const inputElement = jQuery('input[value="' + jQuery(this).val() + '"]');
                            inputElement.prop('disabled', atMinOptions ? 'disabled' : false);
                        });
                    },
                    buttonText: function(options, select) { return select.data('placeholder'); },
                    maxHeight: 200,
                    includeFilterClearBtn: false,
                    enableCaseInsensitiveFiltering: enableFiltering,
                });
            })
        });
    </script>
{/if}

<script>
    jQuery(document).ready(function() {
        function toggleDomainOption() {
            var val = jQuery(this).val();
            jQuery(".domain-input-group").hide();
            jQuery("#domain" + val).fadeIn('fast').css('display', 'block');
        }
        var $radios = jQuery(".domain-selection-options input[type='radio']");
        $radios.on('change click ifChecked', toggleDomainOption);
        var $checked = $radios.filter(":checked");
        if ($checked.length > 0) {
            jQuery(".domain-input-group").hide();
            jQuery("#domain" + $checked.val()).show();
        } else if ($radios.length > 0) {
            $radios.first().prop('checked', true);
            jQuery(".domain-input-group").hide();
            jQuery("#domain" + $radios.first().val()).show();
        }
    });
</script>
