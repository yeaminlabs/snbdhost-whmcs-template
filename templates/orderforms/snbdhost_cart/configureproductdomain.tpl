{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* ==========================================================================
   Choose a Domain (cart.php?a=add&pid=X → domain step)
   Built on the portal tokens (snbd-system.css) and the .cfg-head pattern
   used by configureproduct.tpl, so the two steps read as one flow.
   The domain-option radios opt out of iCheck (.no-icheck): iCheck wraps the
   input in a div, which breaks `input:checked + .cpd-tab__inner` and let the
   checked radio drift out of sync with the visible input group.
   ========================================================================== */
#order-standard_cart .cpd {
    max-width: 880px;
    margin: 0 auto;
    padding: var(--snbd-s2) 0 var(--snbd-s10);
}

/* ── Option tiles ── */
#order-standard_cart .cpd-tabs {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
    gap: var(--snbd-s3);
    margin: 0 0 var(--snbd-s5);
}
#order-standard_cart .cpd-tab {
    position: relative;
    display: block;
    margin: 0;
    cursor: pointer;
    font-weight: inherit;
}
#order-standard_cart .cpd-tab input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 1px;
    height: 1px;
    pointer-events: none;
}
#order-standard_cart .cpd-tab__inner {
    display: flex;
    align-items: center;
    gap: var(--snbd-s3);
    height: 100%;
    min-height: 64px;
    padding: var(--snbd-s3) var(--snbd-s4);
    background: var(--snbd-surface);
    border: 1px solid var(--snbd-line);
    border-radius: var(--snbd-r-lg);
    box-shadow: var(--snbd-e1);
    transition: border-color var(--snbd-fast) var(--snbd-ease),
                background var(--snbd-fast) var(--snbd-ease),
                box-shadow var(--snbd-fast) var(--snbd-ease);
}
#order-standard_cart .cpd-tab:hover .cpd-tab__inner {
    border-color: var(--snbd-line-strong);
    background: var(--snbd-surface-2);
}
#order-standard_cart .cpd-tab__icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: 0 0 auto;
    width: 36px;
    height: 36px;
    border-radius: var(--snbd-r-md);
    background: var(--snbd-surface-3);
    color: var(--snbd-ink-500);
    font-size: 0.9375rem;
    transition: background var(--snbd-fast) var(--snbd-ease), color var(--snbd-fast) var(--snbd-ease);
}
#order-standard_cart .cpd-tab__text { min-width: 0; }
#order-standard_cart .cpd-tab__label {
    display: block;
    font-family: var(--snbd-font-display);
    font-size: 0.875rem;
    font-weight: 700;
    line-height: 1.25;
    color: var(--snbd-ink-900);
}
#order-standard_cart .cpd-tab__hint {
    display: block;
    margin-top: 2px;
    font-size: 0.75rem;
    line-height: 1.3;
    color: var(--snbd-ink-500);
}
#order-standard_cart .cpd-tab input:checked + .cpd-tab__inner {
    border-color: var(--snbd-red);
    background: var(--snbd-red-soft);
    box-shadow: 0 0 0 1px var(--snbd-red) inset;
}
#order-standard_cart .cpd-tab input:checked + .cpd-tab__inner .cpd-tab__icon {
    background: var(--snbd-red);
    color: #fff;
}
#order-standard_cart .cpd-tab input:focus-visible + .cpd-tab__inner {
    box-shadow: 0 0 0 3px var(--snbd-red-ring);
}
#order-standard_cart .cpd-tab input:disabled + .cpd-tab__inner {
    cursor: progress;
    opacity: 0.65;
}

/* ── Search bar ── */
#order-standard_cart .cpd-search .domain-input-group {
    display: none;
    margin: 0;
}
#order-standard_cart .cpd-bar {
    display: flex;
    align-items: stretch;
    gap: var(--snbd-s2);
    padding: var(--snbd-s2);
    background: var(--snbd-surface);
    border: 1px solid var(--snbd-line);
    border-radius: var(--snbd-r-lg);
    box-shadow: var(--snbd-e2);
    transition: border-color var(--snbd-fast) var(--snbd-ease), box-shadow var(--snbd-fast) var(--snbd-ease);
}
#order-standard_cart .cpd-bar:focus-within {
    border-color: rgba(var(--snbd-red-rgb), 0.45);
    box-shadow: 0 0 0 4px var(--snbd-red-ring), var(--snbd-e2);
}
#order-standard_cart .cpd-field {
    display: flex;
    align-items: center;
    flex: 1 1 auto;
    min-width: 0;
    background: var(--snbd-surface-2);
    border: 1px solid var(--snbd-line);
    border-radius: var(--snbd-r-md);
}
#order-standard_cart .cpd-field__prefix {
    flex: 0 0 auto;
    padding-left: var(--snbd-s4);
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--snbd-ink-400);
    user-select: none;
}
#order-standard_cart .cpd-field__prefix i { color: var(--snbd-ink-400); }
#order-standard_cart .cpd-bar input[type="text"],
#order-standard_cart .cpd-bar select {
    flex: 1 1 auto;
    min-width: 0;
    height: 48px;
    margin: 0;
    padding: 0 var(--snbd-s3) 0 var(--snbd-s1);
    border: 0;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
    outline: none;
    font-family: var(--snbd-font-text);
    font-size: 1rem;
    font-weight: 500;
    color: var(--snbd-ink-900);
}
#order-standard_cart .cpd-bar input[type="text"]::placeholder { color: var(--snbd-ink-400); font-weight: 400; }
#order-standard_cart .cpd-field--tld {
    flex: 0 0 132px;
}
#order-standard_cart .cpd-field--tld .cpd-field__prefix {
    padding-left: var(--snbd-s3);
    font-size: 1rem;
    color: var(--snbd-ink-500);
}
#order-standard_cart .cpd-field--tld select,
#order-standard_cart .cpd-field--tld input[type="text"] {
    padding-left: var(--snbd-s3);
    font-weight: 600;
    cursor: pointer;
}
#order-standard_cart .cpd-field--tld input[type="text"] {
    padding-left: 2px;
    cursor: text;
}
#order-standard_cart .cpd-field--select select { padding-left: var(--snbd-s3); cursor: pointer; }
#order-standard_cart .cpd-submit {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--snbd-s2);
    flex: 0 0 auto;
    min-height: 48px;
    padding: 0 var(--snbd-s6);
    border: 1px solid var(--snbd-red);
    border-radius: var(--snbd-r-md);
    background: var(--snbd-red);
    color: #fff;
    font-family: var(--snbd-font-display);
    font-size: 0.9375rem;
    font-weight: 700;
    white-space: nowrap;
    cursor: pointer;
    transition: background var(--snbd-fast) var(--snbd-ease), border-color var(--snbd-fast) var(--snbd-ease);
}
#order-standard_cart .cpd-submit:hover { background: var(--snbd-red-hover); border-color: var(--snbd-red-hover); }
#order-standard_cart .cpd-submit:focus-visible { outline: 0; box-shadow: 0 0 0 3px var(--snbd-red-ring); }
#order-standard_cart .cpd-submit[disabled],
#order-standard_cart .cpd-submit.disabled { opacity: 0.6; cursor: progress; }
#order-standard_cart .cpd-help {
    margin: var(--snbd-s3) 0 0;
    font-size: 0.8125rem;
    color: var(--snbd-ink-500);
}
#order-standard_cart .cpd-help i { color: var(--snbd-ink-400); margin-right: 4px; }

/* ── Results ── */
#order-standard_cart #DomainSearchResults { margin-top: var(--snbd-s6); }
#order-standard_cart #DomainSearchResults .primary-domain-header {
    margin: 0 0 var(--snbd-s3) !important;
    padding: 0 !important;
    border: 0 !important;
    font-size: 0.6875rem !important;
    font-weight: 700 !important;
    letter-spacing: 0.08em !important;
    text-transform: uppercase !important;
    text-align: left !important;
    color: var(--snbd-ink-400) !important;
}
#order-standard_cart #searchDomainInfo {
    padding: var(--snbd-s6);
    background: var(--snbd-surface);
    border: 1px solid var(--snbd-line);
    border-radius: var(--snbd-r-lg);
    box-shadow: var(--snbd-e1);
    text-align: center;
}
#order-standard_cart #searchDomainInfo .domain-lookup-primary-loader,
#order-standard_cart #searchDomainInfo .domain-lookup-primary-results {
    margin: 0;
}
#order-standard_cart #searchDomainInfo .domain-searching {
    margin: 0;
    font-size: 0.9375rem !important;
    color: var(--snbd-ink-500) !important;
}
#order-standard_cart #searchDomainInfo .headline {
    margin: 0 0 var(--snbd-s2);
    font-family: var(--snbd-font-display);
    font-size: clamp(1.125rem, 1rem + 0.6vw, 1.375rem);
    font-weight: 800;
    letter-spacing: -0.01em;
    line-height: 1.3;
    word-break: break-word;
}
#order-standard_cart #searchDomainInfo .domain-checker-available { color: var(--snbd-ok); }
#order-standard_cart #searchDomainInfo .domain-checker-available strong { color: var(--snbd-ink-900) !important; }
#order-standard_cart #searchDomainInfo .domain-checker-unavailable { color: var(--snbd-bad); }
#order-standard_cart #searchDomainInfo .domain-checker-unavailable strong { color: var(--snbd-ink-900); }
#order-standard_cart #searchDomainInfo .domain-contact-support.headline {
    display: inline-flex;
    font-size: 0.875rem;
}
#order-standard_cart #searchDomainInfo .text-muted {
    margin: 0 auto var(--snbd-s1);
    max-width: 60ch;
    font-size: 0.875rem;
    color: var(--snbd-ink-500) !important;
}
#order-standard_cart #searchDomainInfo .domain-price {
    display: flex;
    align-items: baseline;
    justify-content: center;
    flex-wrap: wrap;
    gap: var(--snbd-s2);
    margin-top: var(--snbd-s3);
}
#order-standard_cart #searchDomainInfo .domain-price .register-price-label,
#order-standard_cart #searchDomainInfo .domain-price .transfer-price-label {
    font-size: 0.875rem;
    color: var(--snbd-ink-500);
}
#order-standard_cart #searchDomainInfo .domain-price .price {
    font-family: var(--snbd-font-display);
    font-size: 1.5rem;
    font-weight: 800;
    color: var(--snbd-ink-900);
    font-variant-numeric: tabular-nums;
}
#order-standard_cart #searchDomainInfo .domain-error { color: var(--snbd-bad); }
#order-standard_cart #searchDomainInfo .idn-language-selector { margin-top: var(--snbd-s4); }

#order-standard_cart .cpd-continue {
    margin-top: var(--snbd-s5);
    text-align: center;
}
#order-standard_cart #btnDomainContinue {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--snbd-s2);
    min-width: 240px;
    min-height: 48px;
    padding: 0 var(--snbd-s8);
    border: 1px solid var(--snbd-red);
    border-radius: var(--snbd-r-md);
    background: var(--snbd-red);
    color: #fff;
    font-family: var(--snbd-font-display);
    font-size: 0.9375rem;
    font-weight: 700;
    box-shadow: none;
    transition: background var(--snbd-fast) var(--snbd-ease);
}
#order-standard_cart #btnDomainContinue:hover:not(:disabled) { background: var(--snbd-red-hover); border-color: var(--snbd-red-hover); }
#order-standard_cart #btnDomainContinue:disabled { opacity: 0.45; cursor: not-allowed; }
#order-standard_cart #btnDomainContinue[style*="display: none"] { display: none !important; }

#order-standard_cart #spotlightTlds { margin-top: var(--snbd-s6) !important; }
#order-standard_cart .cpd-section-label {
    margin: 0 0 var(--snbd-s3);
    font-size: 0.6875rem;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--snbd-ink-400);
}

@media (max-width: 767px) {
    #order-standard_cart .cpd-tabs { grid-template-columns: 1fr; gap: var(--snbd-s2); }
    #order-standard_cart .cpd-tab__inner { min-height: 56px; }
    #order-standard_cart .cpd-bar { flex-wrap: wrap; }
    #order-standard_cart .cpd-field { flex: 1 1 100%; }
    #order-standard_cart .cpd-field--tld { flex: 1 1 0; }
    #order-standard_cart .cpd-submit { flex: 1 1 auto; }
    #order-standard_cart #searchDomainInfo { padding: var(--snbd-s5) var(--snbd-s4); }
    #order-standard_cart #btnDomainContinue { width: 100%; }
    #order-standard_cart .spotlight-tld-container {
        flex: 1 1 calc(50% - 0.625rem) !important;
        max-width: calc(50% - 0.32rem) !important;
    }
}
</style>

<div id="order-standard_cart">
<div class="cpd">

    <header class="cfg-head">
        <div>
            <span class="cfg-head__eyebrow">Domain</span>
            <h1 class="cfg-head__title">Choose a domain</h1>
            <p class="cfg-head__sub">Register a new domain, transfer one you own elsewhere, or point an existing domain at your new service.</p>
        </div>
    </header>

    <form id="frmProductDomain">
        <input type="hidden" id="frmProductDomainPid" value="{$pid}" />

        <div class="cpd-tabs domain-selection-options" role="radiogroup" aria-label="Domain option">

            {if $incartdomains}
                <label class="cpd-tab">
                    <input type="radio" class="no-icheck" name="domainoption" value="incart" id="selincart" />
                    <span class="cpd-tab__inner">
                        <span class="cpd-tab__icon" aria-hidden="true"><i class="fas fa-shopping-cart"></i></span>
                        <span class="cpd-tab__text">
                            <span class="cpd-tab__label">{$LANG.cartproductdomainuseincart}</span>
                        </span>
                    </span>
                </label>
            {/if}

            {if $registerdomainenabled}
                <label class="cpd-tab">
                    <input type="radio" class="no-icheck" name="domainoption" value="register" id="selregister"{if $domainoption eq "register"} checked{/if} />
                    <span class="cpd-tab__inner">
                        <span class="cpd-tab__icon" aria-hidden="true"><i class="fas fa-search"></i></span>
                        <span class="cpd-tab__text">
                            <span class="cpd-tab__label">Register a new domain</span>
                            <span class="cpd-tab__hint">Search and buy a name</span>
                        </span>
                    </span>
                </label>
            {/if}

            {if $transferdomainenabled}
                <label class="cpd-tab">
                    <input type="radio" class="no-icheck" name="domainoption" value="transfer" id="seltransfer"{if $domainoption eq "transfer"} checked{/if} />
                    <span class="cpd-tab__inner">
                        <span class="cpd-tab__icon" aria-hidden="true"><i class="fas fa-exchange-alt"></i></span>
                        <span class="cpd-tab__text">
                            <span class="cpd-tab__label">Transfer a domain</span>
                            <span class="cpd-tab__hint">Move it from another registrar</span>
                        </span>
                    </span>
                </label>
            {/if}

            {if $owndomainenabled}
                <label class="cpd-tab">
                    <input type="radio" class="no-icheck" name="domainoption" value="owndomain" id="selowndomain"{if $domainoption eq "owndomain"} checked{/if} />
                    <span class="cpd-tab__inner">
                        <span class="cpd-tab__icon" aria-hidden="true"><i class="fas fa-link"></i></span>
                        <span class="cpd-tab__text">
                            <span class="cpd-tab__label">Use my existing domain</span>
                            <span class="cpd-tab__hint">Update nameservers yourself</span>
                        </span>
                    </span>
                </label>
            {/if}

            {if $subdomains}
                <label class="cpd-tab">
                    <input type="radio" class="no-icheck" name="domainoption" value="subdomain" id="selsubdomain"{if $domainoption eq "subdomain"} checked{/if} />
                    <span class="cpd-tab__inner">
                        <span class="cpd-tab__icon" aria-hidden="true"><i class="fas fa-sitemap"></i></span>
                        <span class="cpd-tab__text">
                            <span class="cpd-tab__label">Use a subdomain</span>
                            <span class="cpd-tab__hint">Free, on one of our domains</span>
                        </span>
                    </span>
                </label>
            {/if}

        </div>

        <div class="cpd-search domain-input-groups-wrapper">

            {if $incartdomains}
                <div class="domain-input-group" id="domainincart">
                    <div class="cpd-bar">
                        <div class="cpd-field cpd-field--select">
                            <span class="cpd-field__prefix" aria-hidden="true"><i class="fas fa-shopping-cart"></i></span>
                            <select id="incartsld" name="incartdomain" aria-label="{$LANG.cartproductdomainuseincart}">
                                {foreach key=num item=incartdomain from=$incartdomains}
                                    <option value="{$incartdomain}">{$incartdomain}</option>
                                {/foreach}
                            </select>
                        </div>
                        <button type="submit" class="cpd-submit">
                            {$LANG.orderForm.use} <i class="fas fa-arrow-right" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
            {/if}

            {if $registerdomainenabled}
                <div class="domain-input-group" id="domainregister">
                    <div class="cpd-bar">
                        <div class="cpd-field">
                            <span class="cpd-field__prefix" aria-hidden="true">www.</span>
                            <input type="text" id="registersld" value="{$sld}" autocapitalize="none" autocomplete="off" spellcheck="false" placeholder="yourname" aria-label="Domain name" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-trigger="manual" title="{lang key='orderForm.enterDomain'}" />
                        </div>
                        <div class="cpd-field cpd-field--tld">
                            <select id="registertld" aria-label="Extension">
                                {foreach from=$registertlds item=listtld}
                                    <option value="{$listtld}"{if $listtld eq $tld} selected="selected"{/if}>{$listtld}</option>
                                {/foreach}
                            </select>
                        </div>
                        <button id="btnCheckAvailability" type="submit" class="cpd-submit">
                            <i class="fas fa-search" aria-hidden="true"></i> {$LANG.orderForm.check|default:'Check'}
                        </button>
                    </div>
                </div>
            {/if}

            {if $transferdomainenabled}
                <div class="domain-input-group" id="domaintransfer">
                    <div class="cpd-bar">
                        <div class="cpd-field">
                            <span class="cpd-field__prefix" aria-hidden="true">www.</span>
                            <input type="text" id="transfersld" value="{$sld}" autocapitalize="none" autocomplete="off" spellcheck="false" placeholder="yourname" aria-label="Domain name" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-trigger="manual" title="{lang key='orderForm.enterDomain'}" />
                        </div>
                        <div class="cpd-field cpd-field--tld">
                            <select id="transfertld" aria-label="Extension">
                                {foreach from=$transfertlds item=listtld}
                                    <option value="{$listtld}"{if $listtld eq $tld} selected="selected"{/if}>{$listtld}</option>
                                {/foreach}
                            </select>
                        </div>
                        <button type="submit" class="cpd-submit">
                            {$LANG.orderForm.transfer|default:'Transfer'} <i class="fas fa-arrow-right" aria-hidden="true"></i>
                        </button>
                    </div>
                    <p class="cpd-help"><i class="fas fa-info-circle" aria-hidden="true"></i> Unlock the domain at your current registrar and have its EPP / auth code ready.</p>
                </div>
            {/if}

            {if $owndomainenabled}
                <div class="domain-input-group" id="domainowndomain">
                    <div class="cpd-bar">
                        <div class="cpd-field">
                            <span class="cpd-field__prefix" aria-hidden="true">www.</span>
                            <input type="text" id="owndomainsld" value="{$sld}" autocapitalize="none" autocomplete="off" spellcheck="false" placeholder="yourname" aria-label="Domain name" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-trigger="manual" title="{lang key='orderForm.enterDomain'}" />
                        </div>
                        <div class="cpd-field cpd-field--tld">
                            <span class="cpd-field__prefix" aria-hidden="true">.</span>
                            <input type="text" id="owndomaintld" value="{$tld|substr:1}" autocapitalize="none" autocomplete="off" spellcheck="false" placeholder="com" aria-label="Extension" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-trigger="manual" title="{lang key='orderForm.required'}" />
                        </div>
                        <button type="submit" class="cpd-submit" id="useOwnDomain">
                            {$LANG.orderForm.use|default:'Use'} <i class="fas fa-arrow-right" aria-hidden="true"></i>
                        </button>
                    </div>
                    <p class="cpd-help"><i class="fas fa-info-circle" aria-hidden="true"></i> You'll point this domain's nameservers to us after checkout.</p>
                </div>
            {/if}

            {if $subdomains}
                <div class="domain-input-group" id="domainsubdomain">
                    <div class="cpd-bar">
                        <div class="cpd-field">
                            <span class="cpd-field__prefix" aria-hidden="true">http://</span>
                            <input type="text" id="subdomainsld" value="{$sld}" autocapitalize="none" autocomplete="off" spellcheck="false" placeholder="yourname" aria-label="Subdomain" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-trigger="manual" title="{lang key='orderForm.enterDomain'}" />
                        </div>
                        <div class="cpd-field cpd-field--select">
                            <select id="subdomaintld" aria-label="Parent domain">
                                {foreach $subdomains as $subid => $subdomain}
                                    <option value="{$subid}">{$subdomain}</option>
                                {/foreach}
                            </select>
                        </div>
                        <button type="submit" class="cpd-submit">
                            {$LANG.orderForm.use|default:'Use'} <i class="fas fa-arrow-right" aria-hidden="true"></i>
                        </button>
                    </div>
                </div>
            {/if}

            {if $freedomaintlds}
                <p class="cpd-help"><i class="fas fa-gift" aria-hidden="true"></i> {$LANG.orderfreedomainregistration} {$LANG.orderfreedomainappliesto}: {$freedomaintlds}</p>
            {/if}
        </div>

    </form>

    <form method="post" action="{$WEB_ROOT}/cart.php?a=add&pid={$pid}&domainselect=1" id="frmProductDomainSelections">

        <div id="DomainSearchResults" class="w-hidden" aria-live="polite">

            <div id="primarySuggestionHeading" class="primary-domain-header w-hidden"></div>
            <div id="primaryExactHeading" class="primary-domain-header">{$LANG.domainSearch.exactMatch}</div>

            <div id="searchDomainInfo">
                <p id="primaryLookupSearching" class="domain-lookup-loader domain-lookup-primary-loader domain-searching domain-checker-result-headline">
                    <i class="fas fa-spinner fa-spin" aria-hidden="true"></i>
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
                        <p class="text-muted">{lang key='orderForm.transferUnlockBeforeContinuing'}</p>
                    </div>
                    <div class="transfer-not-eligible">
                        <p class="domain-checker-unavailable headline">{lang key='orderForm.transferNotEligible'}</p>
                        <p class="text-muted">{lang key='orderForm.transferNotRegistered'}</p>
                        <p class="text-muted">{lang key='orderForm.trasnferRecentlyRegistered'}</p>
                        <p class="text-muted">{lang key='orderForm.transferAlternativelyRegister'}</p>
                    </div>
                    <div class="domain-invalid">
                        <p class="domain-checker-unavailable headline">{lang key='orderForm.domainInvalid'}</p>
                        <p class="text-muted">
                            {lang key='orderForm.domainLetterOrNumber'}<span class="domain-length-restrictions">{lang key='orderForm.domainLengthRequirements'}</span><br />
                            {lang key='orderForm.domainInvalidCheckEntry'}
                        </p>
                    </div>
                    <div id="idnLanguageSelector" class="idn-language-selector idn-language w-hidden">
                        <p class="text-muted">{lang key='cart.idnLanguageDescription'}</p>
                        <div class="form-group" style="max-width:360px;margin:0 auto;">
                            <select name="idnlanguage" class="form-control">
                                <option value="">{lang key='cart.idnLanguage'}</option>
                                {foreach $idnLanguages as $idnLanguageKey => $idnLanguage}
                                    <option value="{$idnLanguageKey}">{lang key='idnLanguage.'|cat:$idnLanguageKey}</option>
                                {/foreach}
                            </select>
                            <div class="field-error-msg">{lang key='cart.selectIdnLanguageForRegister'}</div>
                        </div>
                    </div>
                    <div class="domain-price">
                        <span class="register-price-label">{lang key='orderForm.domainPriceRegisterLabel'}</span>
                        <span class="transfer-price-label w-hidden">{lang key='orderForm.domainPriceTransferLabel'}</span>
                        <span class="price"></span>
                    </div>
                    <p class="domain-error domain-checker-unavailable headline"></p>
                    <input type="hidden" id="resultDomainOption" name="domainoption" />
                    <input type="hidden" id="resultDomain" name="domains[]" />
                    <input type="hidden" id="resultDomainPricingTerm" />
                </div>

                <div class="cpd-continue">
                    <button id="btnDomainContinue" type="submit" class="btn" style="display: none;" disabled="disabled">
                        {$LANG.continue} <i class="fas fa-arrow-right" aria-hidden="true"></i>
                    </button>
                </div>
            </div>

            {if $registerdomainenabled}
                {if $spotlightTlds}
                    <div id="spotlightTlds" class="spotlight-tlds clearfix w-hidden">
                        <p class="cpd-section-label">Also available</p>
                        <div class="spotlight-tlds-container">
                            {foreach $spotlightTlds as $key => $data}
                                <div class="spotlight-tld-container spotlight-tld-container-{$spotlightTlds|count}">
                                    <div id="spotlight{$data.tldNoDots}" class="spotlight-tld">
                                        {if $data.group}
                                            <div class="spotlight-tld-{$data.group}">{$data.groupDisplayName}</div>
                                        {/if}
                                        <span class="tld-name">{$data.tld}</span>
                                        <span class="domain-lookup-loader domain-lookup-spotlight-loader">
                                            <i class="fas fa-spinner fa-spin" aria-hidden="true"></i>
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

                {* Kept for scripts.js, which still targets these nodes; hidden by custom.css. *}
                <div class="suggested-domains w-hidden">
                    <div id="suggestionsLoader" class="domain-lookup-loader domain-lookup-suggestions-loader"></div>
                    <div class="domain-lookup-message domain-lookup-suggestions-message"></div>
                    <div id="domainSuggestions" class="domain-lookup-result list-group w-hidden">
                        <div class="domain-suggestion list-group-item w-hidden">
                            <span class="domain"></span><span class="extension"></span>
                            <div class="actions">
                                <button type="button" class="btn btn-add-to-cart product-domain" data-whois="1" data-domain="">
                                    <span class="to-add">{$LANG.addtocart}</span>
                                    <span class="loading"><i class="fas fa-spinner fa-spin"></i></span>
                                    <span class="added"><i class="far fa-shopping-cart"></i> {lang key='domaincheckeradded'}</span>
                                    <span class="unavailable">{$LANG.domaincheckertaken}</span>
                                </button>
                                <button type="button" class="btn btn-primary domain-contact-support w-hidden">{lang key='domainChecker.contactSupport'}</button>
                                <span class="price"></span>
                                <span class="promo w-hidden"></span>
                            </div>
                        </div>
                    </div>
                    <div class="more-suggestions w-hidden">
                        <a id="moreSuggestions" href="#" onclick="loadMoreSuggestions();return false;">{lang key='domainsmoresuggestions'}</a>
                        <span id="noMoreSuggestions" class="no-more w-hidden">{lang key='domaincheckernomoresuggestions'}</span>
                    </div>
                </div>
            {/if}

        </div>

    </form>

</div>
</div>

{include file="orderforms/snbdhost_cart/recommendations-modal.tpl"}

{if $showAdvancedSearchOptions}
    <script>
        {literal}
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
        {/literal}
    </script>
{/if}

<script>
    {literal}
    jQuery(function () {
        // One source of truth: the checked radio decides which input group shows.
        // scripts.js binds the same toggle; this also clears the previous result
        // so a stale lookup is never shown under a different option.
        var $radios = jQuery('#frmProductDomain input[name="domainoption"]');

        function showGroup(focus) {
            var $checked = $radios.filter(':checked');
            if (!$checked.length) {
                $checked = $radios.first().prop('checked', true);
            }
            jQuery('.domain-input-group').hide();
            var $group = jQuery('#domain' + $checked.val()).show();
            if (focus) {
                $group.find('input[type="text"], select').first().trigger('focus');
            }
        }

        showGroup(false);
        var currentOption = $radios.filter(':checked').val();

        // scripts.js calls iCheck('disable'/'enable') on these radios around every
        // lookup, and iCheck fires `change` on each one when it does. Only treat
        // it as a switch when the checked option really changed, otherwise the
        // results would be wiped the moment a lookup finished.
        $radios.on('change', function () {
            var selected = $radios.filter(':checked').val();
            if (selected === currentOption) {
                // scripts.js's own toggle just showed the group of whichever
                // radio fired last; put the checked option's group back.
                showGroup(false);
                return;
            }
            currentOption = selected;
            jQuery('#DomainSearchResults').hide();
            jQuery('#btnDomainContinue').hide().attr('disabled', 'disabled');
            jQuery('#resultDomain, #resultDomainOption').val('');
            showGroup(true);
        });

        // Accept a full domain ("https://www.example.com") typed or pasted into
        // the name field by splitting it into name + extension.
        function splitDomain($sld) {
            if (!$sld.length) {
                return;
            }
            var value = jQuery.trim($sld.val()).toLowerCase()
                .replace(/^https?:\/\//, '').replace(/^www\./, '').replace(/\/.*$/, '');
            var dot = value.indexOf('.'),
                $tld = jQuery('#' + $sld.attr('id').replace('sld', 'tld'));
            if (dot < 1) {
                $sld.val(value);
                return;
            }
            var sld = value.substr(0, dot),
                tld = value.substr(dot);
            if ($tld.is('select')) {
                if ($tld.find('option[value="' + tld + '"]').length) {
                    $tld.val(tld);
                    $sld.val(sld);
                }
            } else {
                $tld.val(tld.substr(1));
                $sld.val(sld);
            }
        }

        var sldSelector = '#registersld, #transfersld, #owndomainsld';
        jQuery(sldSelector).on('change paste', function () {
            var $sld = jQuery(this);
            setTimeout(function () { splitDomain($sld); }, 0);
        });
        jQuery('#owndomaintld').on('change', function () {
            this.value = jQuery.trim(this.value).toLowerCase().replace(/^\.+/, '');
        });

        // Capture phase on document runs before scripts.js's jQuery submit
        // handler on the form, so the lookup always gets the cleaned values.
        document.addEventListener('submit', function (e) {
            if (e.target && e.target.id === 'frmProductDomain') {
                splitDomain(jQuery('#' + $radios.filter(':checked').val() + 'sld').filter(sldSelector));
                jQuery('#owndomaintld').trigger('change');
            }
        }, true);
    });
    {/literal}
</script>
