{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* Modern Premium Domain Configuration Styles */
#order-standard_cart .domain-config-container {
    max-width: 900px;
    margin: 0 auto;
    padding: 2rem 0;
}
.domain-headline {
    font-size: 2.25rem;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 0.5rem;
    letter-spacing: -0.02em;
}
.domain-subheadline {
    font-size: 1.1rem;
    color: #64748b;
    margin-bottom: 2.5rem;
}

/* Domain Option Cards */
.domain-cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2.5rem;
}
.domain-option-card {
    position: relative;
    cursor: pointer;
    display: block;
    margin: 0;
}
.domain-option-card input[type="radio"] {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
}
.domain-card-content {
    background: #ffffff;
    border: 2px solid #e2e8f0;
    border-radius: 16px;
    padding: 1.5rem;
    text-align: center;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
}
.domain-card-icon {
    font-size: 2rem;
    color: #94a3b8;
    margin-bottom: 1rem;
    transition: color 0.3s ease;
}
.domain-card-title {
    font-size: 1.05rem;
    font-weight: 600;
    color: #334155;
    line-height: 1.4;
    transition: color 0.3s ease;
}
.domain-option-card:hover .domain-card-content {
    border-color: #cbd5e1;
    transform: translateY(-2px);
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
}
.domain-option-card input[type="radio"]:checked + .domain-card-content {
    border-color: #d32f2f;
    background: #fffafa;
    box-shadow: 0 8px 20px rgba(211, 47, 47, 0.15);
}
.domain-option-card input[type="radio"]:checked + .domain-card-content .domain-card-icon {
    color: #d32f2f;
}
.domain-option-card input[type="radio"]:checked + .domain-card-content .domain-card-title {
    color: #b71c1c;
}
.domain-option-card input[type="radio"]:focus-visible + .domain-card-content {
    outline: 3px solid #ef4444;
    outline-offset: 2px;
}

/* Domain Search Bar */
.domain-input-group {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 99px;
    padding: 0.5rem;
    box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
    transition: box-shadow 0.3s ease;
    display: none; /* Handled by JS */
}
.domain-input-group:focus-within {
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
    border-color: #cbd5e1;
}
.domain-input-inner {
    display: flex;
    align-items: center;
    width: 100%;
}
.domain-prefix {
    padding: 0 1rem 0 1.5rem;
    color: #64748b;
    font-weight: 600;
    font-size: 1.1rem;
    border-right: 2px solid #f1f5f9;
}
.domain-input-field {
    flex: 1;
    border: none !important;
    box-shadow: none !important;
    font-size: 1.25rem;
    padding: 1rem 1.5rem;
    color: #0f172a;
    font-weight: 500;
    background: transparent !important;
    outline: none !important;
}
.domain-input-field::placeholder {
    color: #94a3b8;
    font-weight: 400;
}
.domain-tld-select {
    border: none !important;
    box-shadow: none !important;
    font-size: 1.1rem;
    font-weight: 600;
    color: #334155;
    background: transparent !important;
    padding: 1rem 2rem 1rem 1rem;
    cursor: pointer;
    outline: none !important;
    border-left: 2px solid #f1f5f9 !important;
    appearance: none;
    -webkit-appearance: none;
    background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%2364748b%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E") !important;
    background-repeat: no-repeat !important;
    background-position: right 0.7rem top 50% !important;
    background-size: 0.65rem auto !important;
}
.domain-submit-btn {
    background: #d32f2f;
    color: white;
    border: none;
    border-radius: 99px;
    padding: 1rem 2.5rem;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    margin-left: 0.5rem;
    box-shadow: 0 4px 14px 0 rgba(211, 47, 47, 0.39);
}
.domain-submit-btn:hover {
    background: #b71c1c;
    box-shadow: 0 6px 20px rgba(211, 47, 47, 0.23);
    transform: translateY(-1px);
    color: white;
}

/* Mobile Adjustments */
@media (max-width: 768px) {
    .domain-input-group {
        border-radius: 16px;
        padding: 1rem;
    }
    .domain-input-inner {
        flex-direction: column;
    }
    .domain-prefix {
        display: none;
    }
    .domain-input-field {
        width: 100%;
        border-bottom: 2px solid #f1f5f9 !important;
        border-radius: 0;
        text-align: center;
    }
    .domain-tld-select {
        width: 100%;
        border-left: none !important;
        text-align: center;
        background-position: right 1rem top 50% !important;
    }
    .domain-submit-btn {
        width: 100%;
        margin-left: 0;
        margin-top: 1rem;
    }
}
/* Spotlight TLD Redesign */
.spotlight-tlds-container {
    display: flex;
    flex-wrap: wrap;
    gap: 1.5rem;
    justify-content: center;
    margin-top: 2rem;
}
#order-standard_cart .spotlight-tld-container,
#order-snbdhost_cart .spotlight-tld-container {
    border: none !important;
    background: transparent !important;
    padding: 0 !important;
    margin: 0 !important;
    flex: 1 1 calc(15% - 1.5rem);
    min-width: 140px;
    max-width: 200px;
}
.spotlight-tld {
    background: #ffffff !important;
    border: 1px solid #e2e8f0 !important;
    border-radius: 16px !important;
    padding: 1.5rem 1rem !important;
    text-align: center;
    position: relative;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02) !important;
    display: flex !important;
    flex-direction: column !important;
    align-items: center !important;
    justify-content: space-between !important;
    min-height: 160px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
    font-size: 1.5rem !important;
    font-weight: 800 !important;
    color: #0f172a !important;
}
.spotlight-tld:hover {
    transform: translateY(-4px) !important;
    box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1) !important;
    border-color: #cbd5e1 !important;
}
#order-standard_cart .spotlight-tld .domain-lookup-result,
#order-snbdhost_cart .spotlight-tld .domain-lookup-result {
    border: none !important;
    background: transparent !important;
    padding: 0 !important;
    margin: 1rem 0 0 0 !important;
    width: 100% !important;
}
.spotlight-tld .price {
    display: block !important;
    font-size: 1.15rem !important;
    color: #16a34a !important;
    font-weight: 700 !important;
    margin-bottom: 0.75rem !important;
}
.spotlight-tld .btn {
    width: 100% !important;
    border-radius: 99px !important;
    font-size: 0.85rem !important;
    font-weight: 600 !important;
    padding: 0.6rem !important;
    white-space: normal !important;
    line-height: 1.2 !important;
    background: #f8fafc !important;
    color: #1e293b !important;
    border: 1px solid #e2e8f0 !important;
    transition: all 0.2s ease !important;
}
.spotlight-tld .btn:hover {
    background: #d32f2f !important;
    color: #ffffff !important;
    border-color: #d32f2f !important;
}
.spotlight-tld-hot, .spotlight-tld-sale, .spotlight-tld-new {
    position: absolute !important;
    top: -10px !important;
    left: 50% !important;
    transform: translateX(-50%) !important;
    font-size: 0.7rem !important;
    padding: 0.2rem 0.8rem !important;
    border-radius: 99px !important;
    text-transform: uppercase !important;
    font-weight: 700 !important;
    letter-spacing: 0.5px !important;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1) !important;
}
.spotlight-tld-hot { background: #ef4444 !important; color: white !important; }
.spotlight-tld-sale { background: #f59e0b !important; color: white !important; }
.spotlight-tld-new { background: #10b981 !important; color: white !important; }
</style>

<div id="order-standard_cart">
    <div class="domain-config-container">
        
        <div class="text-center mb-5">
            <h1 class="domain-headline">{$LANG.domaincheckerchoosedomain}</h1>
            <p class="domain-subheadline">Get your perfect domain name or use one you already own to continue.</p>
        </div>

        <form id="frmProductDomain">
            <input type="hidden" id="frmProductDomainPid" value="{$pid}" />
            
            <div class="domain-selection-options">
                
                <!-- 1. Selection Cards -->
                <div class="domain-cards-grid">
                    {if $incartdomains}
                        <label class="domain-option-card">
                            <input type="radio" name="domainoption" value="incart" id="selincart" />
                            <div class="domain-card-content">
                                <i class="fas fa-shopping-cart domain-card-icon"></i>
                                <span class="domain-card-title">{$LANG.cartproductdomainuseincart}</span>
                            </div>
                        </label>
                    {/if}
                    
                    {if $registerdomainenabled}
                        <label class="domain-option-card">
                            <input type="radio" name="domainoption" value="register" id="selregister"{if $domainoption eq "register"} checked{/if} />
                            <div class="domain-card-content">
                                <i class="fas fa-search domain-card-icon"></i>
                                <span class="domain-card-title">Register a new domain</span>
                            </div>
                        </label>
                    {/if}
                    
                    {if $transferdomainenabled}
                        <label class="domain-option-card">
                            <input type="radio" name="domainoption" value="transfer" id="seltransfer"{if $domainoption eq "transfer"} checked{/if} />
                            <div class="domain-card-content">
                                <i class="fas fa-exchange-alt domain-card-icon"></i>
                                <span class="domain-card-title">Transfer domain to us</span>
                            </div>
                        </label>
                    {/if}
                    
                    {if $owndomainenabled}
                        <label class="domain-option-card">
                            <input type="radio" name="domainoption" value="owndomain" id="selowndomain"{if $domainoption eq "owndomain"} checked{/if} />
                            <div class="domain-card-content">
                                <i class="fas fa-link domain-card-icon"></i>
                                <span class="domain-card-title">Use my existing domain</span>
                            </div>
                        </label>
                    {/if}
                    
                    {if $subdomains}
                        <label class="domain-option-card">
                            <input type="radio" name="domainoption" value="subdomain" id="selsubdomain"{if $domainoption eq "subdomain"} checked{/if} />
                            <div class="domain-card-content">
                                <i class="fas fa-sitemap domain-card-icon"></i>
                                <span class="domain-card-title">Use a subdomain</span>
                            </div>
                        </label>
                    {/if}
                </div>

                <!-- 2. Input Groups -->
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
                                    {$LANG.orderForm.use}
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
                                    Check <i class="fas fa-arrow-right ml-1"></i>
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
                                    Transfer
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
                                    Use Domain
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
                                    Check
                                </button>
                            </div>
                        </div>
                    {/if}

                </div>
            </div>

            {if $freedomaintlds}
                <p class="text-center mt-4 text-muted" style="font-size:0.9rem;">* <em>{$LANG.orderfreedomainregistration} {$LANG.orderfreedomainappliesto}: {$freedomaintlds}</em></p>
            {/if}

        </form>

        <div class="clearfix"></div>
        <form method="post" action="{$WEB_ROOT}/cart.php?a=add&pid={$pid}&domainselect=1" id="frmProductDomainSelections">
            <div id="DomainSearchResults" class="w-hidden mt-5">
                <div id="primarySuggestionHeading" class="primary-domain-header"><i class="fa-regular fa-sparkles"></i> {$LANG.domainSearch.topSuggestion}</div>
                <div id="primaryExactHeading" class="primary-domain-header" style="font-size: 1.5rem; font-weight: 700; color: #1e293b; margin-bottom:1rem; text-align:center;">{$LANG.domainSearch.exactMatch}</div>
                
                <div id="searchDomainInfo" class="text-center p-4" style="background:#f8fafc; border-radius: 16px; border: 1px solid #e2e8f0;">
                    <p id="primaryLookupSearching" class="domain-lookup-loader domain-lookup-primary-loader domain-searching domain-checker-result-headline" style="font-size: 1.25rem; color: #64748b;">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span class="domain-lookup-register-loader">{lang key='orderForm.checkingAvailability'}...</span>
                        <span class="domain-lookup-transfer-loader">{lang key='orderForm.verifyingTransferEligibility'}...</span>
                        <span class="domain-lookup-other-loader">{lang key='orderForm.verifyingDomain'}...</span>
                    </p>
                    <div id="primaryLookupResult" class="domain-lookup-result domain-lookup-primary-results w-hidden">
                        <div class="domain-unavailable domain-checker-unavailable headline" style="color: #dc2626; font-weight: 600;">{lang key='orderForm.domainIsUnavailable'}</div>
                        <div class="domain-available domain-checker-available headline" style="color: #16a34a; font-weight: 600;">{$LANG.domainavailablemessage}</div>
                        <div class="btn btn-primary domain-contact-support headline">{$LANG.domainContactUs}</div>
                        <div class="transfer-eligible">
                            <p class="domain-checker-available headline" style="color: #16a34a; font-weight: 600;">{lang key='orderForm.transferEligible'}</p>
                            <p>{lang key='orderForm.transferUnlockBeforeContinuing'}</p>
                        </div>
                        <div class="transfer-not-eligible">
                            <p class="domain-checker-unavailable headline" style="color: #dc2626; font-weight: 600;">{lang key='orderForm.transferNotEligible'}</p>
                            <p>{lang key='orderForm.transferNotRegistered'}</p>
                            <p>{lang key='orderForm.trasnferRecentlyRegistered'}</p>
                            <p>{lang key='orderForm.transferAlternativelyRegister'}</p>
                        </div>
                        <div class="domain-invalid">
                            <p class="domain-checker-unavailable headline" style="color: #dc2626; font-weight: 600;">{lang key='orderForm.domainInvalid'}</p>
                            <p>
                                {lang key='orderForm.domainLetterOrNumber'}<span class="domain-length-restrictions">{lang key='orderForm.domainLengthRequirements'}</span><br />
                                {lang key='orderForm.domainInvalidCheckEntry'}
                            </p>
                        </div>
                        <div id="idnLanguageSelector" class="margin-10 idn-language-selector idn-language w-hidden">
                            <div class="row">
                                <div class="col-sm-10 col-sm-offset-1 col-lg-8 col-lg-offset-2 offset-sm-1 offset-lg-2">
                                    <div class="margin-10 text-center">
                                        {lang key='cart.idnLanguageDescription'}
                                    </div>
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
                                        <div class="field-error-msg">
                                            {lang key='cart.selectIdnLanguageForRegister'}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="domain-price mt-3">
                            <span class="register-price-label text-muted">{lang key='orderForm.domainPriceRegisterLabel'}</span>
                            <span class="transfer-price-label w-hidden text-muted">{lang key='orderForm.domainPriceTransferLabel'}</span>
                            <span class="price" style="font-size: 1.5rem; font-weight: 700; color: #0f172a; margin-left: 0.5rem;"></span>
                        </div>
                        <p class="domain-error domain-checker-unavailable headline" style="color: #dc2626;"></p>
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
                                                <i class="fas fa-spinner fa-spin"></i>
                                            </span>
                                            <div class="domain-lookup-result">
                                                <button type="button" class="btn unavailable w-hidden" disabled="disabled">
                                                    {lang key='domainunavailable'}
                                                </button>
                                                <button type="button" class="btn invalid w-hidden" disabled="disabled">
                                                    {lang key='domainunavailable'}
                                                </button>
                                                <span class="available price w-hidden">{$data.register}</span>
                                                <button type="button" class="btn btn-add-to-cart product-domain w-hidden" data-whois="0" data-domain="">
                                                    <span class="to-add">{lang key='orderForm.add'}</span>
                                                    <span class="loading">
                                                        <i class="fas fa-spinner fa-spin"></i> {lang key='loading'}
                                                    </span>
                                                    <span class="added"><i class="far fa-shopping-cart"></i> {lang key='domaincheckeradded'}</span>
                                                    <span class="unavailable">{$LANG.domaincheckertaken}</span>
                                                </button>
                                                <button type="button" class="btn btn-primary domain-contact-support w-hidden">
                                                    {lang key='domainChecker.contactSupport'}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                    {/if}

                    <div class="suggested-domains w-hidden mt-4" style="border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden;">
                        <div class="panel-heading card-header" style="background:#f8fafc; font-weight:600; border-bottom: 1px solid #e2e8f0;">
                            {lang key='orderForm.suggestedDomains'}
                        </div>
                        <div id="suggestionsLoader" class="card-body panel-body domain-lookup-loader domain-lookup-suggestions-loader text-center p-4">
                            <i class="fas fa-spinner fa-spin text-muted"></i> <span class="text-muted ml-2">{lang key='orderForm.generatingSuggestions'}</span>
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
                                        <span class="loading">
                                            <i class="fas fa-spinner fa-spin"></i> {lang key='loading'}
                                        </span>
                                        <span class="added"><i class="far fa-shopping-cart"></i> {lang key='domaincheckeradded'}</span>
                                        <span class="unavailable">{$LANG.domaincheckertaken}</span>
                                    </button>
                                    <button type="button" class="btn btn-primary domain-contact-support w-hidden">{lang key='domainChecker.contactSupport'}</button>
                                    <span class="price"></span>
                                    <span class="promo w-hidden"></span>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer card-footer more-suggestions text-center w-hidden bg-white">
                            <a id="moreSuggestions" href="#" onclick="loadMoreSuggestions();return false;" class="text-danger font-weight-bold">{lang key='domainsmoresuggestions'}</a>
                            <span id="noMoreSuggestions" class="no-more small w-hidden text-muted">{lang key='domaincheckernomoresuggestions'}</span>
                        </div>
                        <div class="text-center domain-suggestions-warning p-3 bg-light text-muted small">
                            <p class="mb-0">{lang key='domainssuggestionswarnings'}</p>
                        </div>
                    </div>
                {/if}
            </div>

            <div class="text-center mt-5">
                <button id="btnDomainContinue" type="submit" class="btn btn-primary btn-lg w-hidden" disabled="disabled" style="border-radius: 99px; padding: 1rem 3rem; font-weight: 600; box-shadow: 0 4px 14px rgba(211, 47, 47, 0.4);">
                    {$LANG.continue}
                    <i class="fas fa-arrow-right ml-2"></i>
                </button>
            </div>
        </form>
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
                        if (minSelection === undefined) {
                            return;
                        }
                        const atMinOptions = selectedOptions.length <= minSelection;
                        const targetOptions = atMinOptions ? selectedOptions : closestSelect.find('option');
                        targetOptions.each(function () {
                            const inputElement = jQuery('input[value="' + jQuery(this).val() + '"]');
                            inputElement.prop('disabled', atMinOptions ? 'disabled' : false);
                        });
                    },
                    buttonText: function(options, select) {
                        return select.data('placeholder');
                    },
                    maxHeight: 200,
                    includeFilterClearBtn: false,
                    enableCaseInsensitiveFiltering: enableFiltering,
                });
            })
        });
    </script>
{/if}

<script>
    // Fallback script to ensure domain options are toggled correctly 
    // even if iCheck or other JS encounters an error and stops execution early.
    jQuery(document).ready(function() {
        function toggleDomainOption() {
            var val = jQuery(this).val();
            jQuery(".domain-input-group").hide();
            jQuery("#domain" + val).fadeIn('fast').css('display', 'block');
        }

        var $radios = jQuery(".domain-selection-options input[type='radio']");
        $radios.on('change click ifChecked', toggleDomainOption);

        // Initialize state
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
