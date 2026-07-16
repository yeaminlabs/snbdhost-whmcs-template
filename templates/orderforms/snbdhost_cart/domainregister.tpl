{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* ── Premium Domain Search Form Redesign ── */
.domain-checker-container {
    background: #ffffff !important;
    border: 1px solid #e2e8f0 !important;
    border-radius: 20px !important;
    padding: 1.25rem 1.5rem !important;
    box-shadow: 0 10px 30px rgba(0,0,0,0.04) !important;
    margin-bottom: 1.5rem !important;
}
.domain-checker-bg {
    padding: 0 !important;
    background-image: none !important; /* Remove giant globe background space */
}
.input-group-box {
    display: flex !important;
    width: 100% !important;
    gap: 0.75rem !important;
}
.input-group-box input#inputDomain {
    border-radius: 12px !important;
    border: 1.5px solid #cbd5e1 !important;
    padding: 0.85rem 1.25rem !important;
    font-size: 1.05rem !important;
    background: #f8fafc !important;
    transition: all 0.2s ease !important;
    height: auto !important;
}
.input-group-box input#inputDomain:focus {
    border-color: #CC0000 !important;
    background: #ffffff !important;
    box-shadow: 0 0 0 4px rgba(204, 0, 0, 0.12) !important;
    outline: none !important;
}
.input-group-box .btn-primary, .domain-check-availability {
    background: #CC0000 !important;
    border-color: #CC0000 !important;
    color: #ffffff !important;
    border-radius: 12px !important;
    padding: 0.85rem 2rem !important;
    font-weight: 700 !important;
    font-size: 1rem !important;
    transition: all 0.2s ease !important;
    box-shadow: 0 4px 14px rgba(204, 0, 0, 0.25) !important;
    display: inline-flex !important;
    align-items: center !important;
    justify-content: center !important;
    height: auto !important;
}
.input-group-box .btn-primary:hover, .domain-check-availability:hover {
    background: #aa0000 !important;
    border-color: #aa0000 !important;
    transform: translateY(-1px) !important;
    box-shadow: 0 6px 20px rgba(204, 0, 0, 0.35) !important;
}

/* Compact Textarea for AI search step */
.domain-checker-advanced textarea {
    height: 70px !important;
    border-radius: 12px !important;
    padding: 1.2rem 8.5rem 1rem 1.2rem !important;
}
.domain-checker-advanced #btnCheckAvailability {
    top: 15px !important;
    right: 15px !important;
    height: 40px !important;
    padding: 0 1.5rem !important;
}

@media (max-width: 480px) {
    .domain-checker-advanced textarea {
        height: 110px !important;
        padding: 0.8rem 1rem 3.2rem 1rem !important;
    }
    .domain-checker-advanced #btnCheckAvailability {
        top: auto !important;
        bottom: 10px !important;
        right: 10px !important;
        width: calc(100% - 20px) !important;
        height: 34px !important;
        padding: 0 !important;
    }
}

/* ── Add to Cart Buttons Red Brand Styling ── */
.btn-add-to-cart {
    background: #CC0000 !important;
    border-color: #CC0000 !important;
    color: #ffffff !important;
    font-weight: 700 !important;
    border-radius: 10px !important;
    padding: 0.6rem 1.5rem !important;
    transition: all 0.2s ease !important;
}
.btn-add-to-cart:hover {
    background: #aa0000 !important;
    border-color: #aa0000 !important;
    color: #ffffff !important;
}
.btn-add-to-cart .added {
    background: #2e7d32 !important; /* Keep checkouts green for success */
}

/* Hide Support Button */
.domain-contact-support {
    display: none !important;
}
</style>

<div id="order-standard_cart">

    <div class="row">
        <div class="cart-body">
            <div class="header-lined mb-4 border-0 pb-0">
                    <h1 class="dash-headline" style="font-size: 2rem;">
                    {$LANG.registerdomain}
                </h1>
                </div>

            <p>{if $showAdvancedSearchOptions}{$LANG.orderForm.findNewDomainAi}{else}{$LANG.orderForm.findNewDomain}{/if}</p>

            <div class="domain-checker-container{if $showAdvancedSearchOptions} domain-checker-advanced{/if}">
                <div class="domain-checker-bg clearfix">
                    <form method="post" action="{$WEB_ROOT}/cart.php" id="frmDomainChecker">
                        <input type="hidden" name="a" value="checkDomain">
                        <div class="row">
                            <div class="col-md-8 col-md-offset-2 offset-md-2 col-xs-10 col-xs-offset-1 col-10 offset-1">
                                <div class="input-group input-group-lg input-group-box">
                                    {if $showAdvancedSearchOptions}
                                        <textarea name="message"
                                              id="message"
                                              title="{lang key='domainSearch.domainOrAiPrompt'}"
                                              data-placement="left"
                                              data-trigger="manual"
                                              placeholder="{lang key='domainSearch.domainOrAiInstruction'}">{$message}</textarea>
                                        <button type="submit"
                                                id="btnCheckAvailability"
                                                class="btn btn-primary domain-check-availability{$captcha->getButtonClass($captchaForm)}">
                                            {lang key='search'} <i class="fa-regular fa-sparkles"></i>
                                        </button>
                                        <select name="tlds[]" class="multiselect multiselect-filter" multiple="multiple" data-placeholder="{lang key='domainSearch.tlds'}" data-min-selection="1">
                                            {foreach $tlds as $tld}
                                                <option{if in_array($tld, $selectedTlds)} selected {if count($selectedTlds) <= 1}disabled="disabled"{/if}{/if} value="{$tld}">{$tld}</option>
                                            {/foreach}
                                        </select>
                                        <select name="maxLength" class="multiselect" data-placeholder="{lang key='domainSearch.maxLength'}">
                                            {foreach $searchLengths as $len}
                                                <option value="{$len}" {if $maxLength === $len}selected{/if}>{$len}</option>
                                            {/foreach}
                                        </select>
                                        <label>
                                            <input type="checkbox" class="no-icheck" name="filter" {if $safeSearchSelected}checked{/if}>{lang key="domainSearch.safeSearch"}
                                        </label>
                                    {else}
                                        <input type="text" name="domain" class="form-control" placeholder="{$LANG.findyourdomain}" value="{$lookupTerm}" id="inputDomain" data-bs-toggle="tooltip" data-placement="left" data-trigger="manual" title="{lang key='orderForm.domainOrKeyword'}" />
                                        <span class="input-group-btn input-group-append">
                                            <button type="submit" id="btnCheckAvailability" class="btn btn-primary domain-check-availability{$captcha->getButtonClass($captchaForm)}">{$LANG.search}</button>
                                        </span>
                                    {/if}
                                </div>
                            </div>

                            {if $captcha->isEnabled() && $captcha->isEnabledForForm($captchaForm) && !$captcha->recaptcha->isInvisible()}
                                <div class="col-md-8 col-md-offset-2 offset-md-2 col-xs-10 col-xs-offset-1 col-10 offset-1">
                                    <div class="captcha-container" id="captchaContainer">
                                        {if $captcha->recaptcha->isEnabled()}
                                            <br>
                                            <div class="text-center">
                                                <div class="form-group recaptcha-container"></div>
                                            </div>
                                        {else}
                                            <div class="default-captcha default-captcha-register-margin">
                                                <p>{lang key="cartSimpleCaptcha"}</p>
                                                <div>
                                                    <img id="inputCaptchaImage" src="{$systemurl}includes/verifyimage.php" align="middle" />
                                                    <input id="inputCaptcha" type="text" name="code" maxlength="6" class="form-control input-sm" data-bs-toggle="tooltip" data-placement="right" data-trigger="manual" title="{lang key='orderForm.required'}" />
                                                </div>
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            {/if}
                        </div>
                    </form>
                </div>
            </div>

            <div id="DomainSearchResults" class="w-hidden">
                <div id="primarySuggestionHeading" class="primary-domain-header"><i class="fa-regular fa-sparkles"></i> {$LANG.domainSearch.topSuggestion}</div>
                <div id="primaryExactHeading" class="primary-domain-header">{$LANG.domainSearch.exactMatch}</div>
                <div id="searchDomainInfo" class="domain-checker-result-headline">
                    <p id="primaryLookupSearching" class="domain-lookup-loader domain-lookup-primary-loader domain-searching"><i class="fas fa-spinner fa-spin"></i> {lang key='orderForm.searching'}...</p>
                    <div id="primaryLookupResult" class="domain-lookup-result w-hidden">
                        <p class="domain-invalid domain-checker-invalid">{lang key='orderForm.domainLetterOrNumber'}<span class="domain-length-restrictions">{lang key='orderForm.domainLengthRequirements'}</span></p>
                        <p class="domain-unavailable domain-checker-unavailable">{lang key='orderForm.domainIsUnavailable'}</p>
                        <p class="domain-tld-unavailable domain-checker-unavailable">{lang key='orderForm.domainHasUnavailableTld'}</p>
                        <p class="domain-available domain-checker-available">{$LANG.domainavailablemessage}</p>
                        <a class="domain-contact-support btn btn-primary">{$LANG.domainContactUs}</a>
                        <div id="idnLanguageSelector" class="form-group idn-language-selector w-hidden">
                            <div class="row">
                                <div class="col-sm-10 col-sm-offset-1 col-lg-8 col-lg-offset-2 offset-sm-1 offset-lg-2">
                                    <div class="margin-10 text-center">
                                        {lang key='cart.idnLanguageDescription'}
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-8 col-lg-6 col-sm-offset-2 col-lg-offset-3 offset-sm-2 offset-lg-3">
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
                        <p class="domain-price">
                            <span class="price"></span>
                            <button class="btn btn-primary btn-add-to-cart" data-whois="0" data-domain="">
                                <span class="to-add">{$LANG.addtocart}</span>
                                <span class="loading">
                                    <i class="fas fa-spinner fa-spin"></i> {lang key='loading'}
                                </span>
                                <span class="added"><i class="far fa-shopping-cart"></i> {lang key='checkout'}</span>
                                <span class="unavailable">{$LANG.domaincheckertaken}</span>
                            </button>
                        </p>
                        <p class="domain-error domain-checker-unavailable"></p>
                    </div>
                </div>

                {if $spotlightTlds}
                    <div id="spotlightTlds" class="spotlight-tlds clearfix">
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
                                            <button type="button" class="btn btn-add-to-cart w-hidden" data-whois="0" data-domain="">
                                                <span class="to-add">{lang key='orderForm.add'}</span>
                                                <span class="loading">
                                                    <i class="fas fa-spinner fa-spin"></i> {lang key='loading'}
                                                </span>
                                                <span class="added"><i class="far fa-shopping-cart"></i> {lang key='checkout'}</span>
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

                <div class="suggested-domains{if !$showSuggestionsContainer} w-hidden{/if}">
                    <div class="panel-heading card-header">
                        {lang key='orderForm.suggestedDomains'}
                    </div>
                    <div id="suggestionsLoader" class="panel-body card-body domain-lookup-loader domain-lookup-suggestions-loader">
                        <i class="fas fa-spinner fa-spin"></i> {lang key='orderForm.generatingSuggestions'}
                    </div>
                    <div class="panel-body card-body domain-lookup-message domain-lookup-suggestions-message">
                        {lang key='domainSearch.errors.noSuggestions'}
                    </div>
                    <div id="domainSuggestions" class="domain-lookup-result list-group w-hidden">
                        <div class="domain-suggestion list-group-item w-hidden">
                            <span class="domain"></span><span class="extension"></span>
                            <span class="promo w-hidden">
                                <span class="sales-group-hot w-hidden">{lang key='domainCheckerSalesGroup.hot'}</span>
                                <span class="sales-group-new w-hidden">{lang key='domainCheckerSalesGroup.new'}</span>
                                <span class="sales-group-sale w-hidden">{lang key='domainCheckerSalesGroup.sale'}</span>
                            </span>
                            <div class="actions">
                                <span class="price"></span>
                                <button type="button" class="btn btn-add-to-cart" data-whois="1" data-domain="">
                                    <span class="to-add">{$LANG.addtocart}</span>
                                    <span class="loading">
                                        <i class="fas fa-spinner fa-spin"></i> {lang key='loading'}
                                    </span>
                                    <span class="added"><i class="far fa-shopping-cart"></i> {lang key='checkout'}</span>
                                    <span class="unavailable">{$LANG.domaincheckertaken}</span>
                                </button>
                                <button type="button" class="btn btn-primary domain-contact-support w-hidden">
                                    {lang key='domainChecker.contactSupport'}
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer card-footer more-suggestions text-center w-hidden">
                        <a id="moreSuggestions" href="#" onclick="loadMoreSuggestions();return false;">{lang key='domainsmoresuggestions'}</a>
                        <span id="noMoreSuggestions" class="no-more small w-hidden">{lang key='domaincheckernomoresuggestions'}</span>
                    </div>
                    <div class="text-center domain-suggestions-warning">
                        <p>{lang key='domainssuggestionswarnings'}</p>
                    </div>
                </div>

            </div>

            <div class="domain-pricing">

                {if $featuredTlds}
                    <div class="featured-tlds-container">
                        <div class="row">
                            {foreach $featuredTlds as $num => $tldinfo}
                                {if $num % 3 == 0 && (count($featuredTlds) - $num < 3)}
                                    {if count($featuredTlds) - $num == 2}
                                        <div class="col-sm-2"></div>
                                    {else}
                                        <div class="col-sm-4"></div>
                                    {/if}
                                {/if}
                                <div class="col-lg-4 col-sm-6">
                                    <div class="featured-tld">
                                        <div class="img-container">
                                            <img src="{$BASE_PATH_IMG}/tld_logos/{$tldinfo.tldNoDots}.png" alt="{$tldinfo.tld}">
                                        </div>
                                        <div class="price {$tldinfo.tldNoDots}">
                                            {if is_object($tldinfo.register)}
                                                {$tldinfo.register->toPrefixed()}{if $tldinfo.period > 1}{lang key="orderForm.shortPerYears" years={$tldinfo.period}}{else}{lang key="orderForm.shortPerYear" years=''}{/if}
                                            {else}
                                                {lang key="domainregnotavailable"}
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                {/if}

                <h4 class="font-size-18">{lang key='pricing.browseExtByCategory'}</h4>

                <div class="tld-filters">
                    {foreach $categoriesWithCounts as $category => $count}
                        <a href="#" data-category="{$category}" class="badge badge-secondary">{lang key="domainTldCategory.$category" defaultValue=$category} ({$count})</a>
                    {/foreach}
                </div>

                <div class="bg-white">
                    <div class="row no-gutters tld-pricing-header text-center">
                        <div class="col-md-4 tld-column">{lang key='orderdomain'}</div>
                        <div class="col-md-8">
                            <div class="row no-gutters">
                                <div class="col-xs-4 col-4">{lang key='pricing.register'}</div>
                                <div class="col-xs-4 col-4">{lang key='pricing.transfer'}</div>
                                <div class="col-xs-4 col-4">{lang key='pricing.renewal'}</div>
                            </div>
                        </div>
                    </div>
                    {foreach $pricing['pricing'] as $tld => $price}
                        <div class="row no-gutters tld-row" data-category="{foreach $price.categories as $category}|{$category}|{/foreach}">
                            <div class="col-md-4 two-row-center px-4">
                                <strong>.{$tld}</strong>
                                {if $price.group}
                                    <span class="tld-sale-group tld-sale-group-{$price.group}">
                                        {lang key='domainCheckerSalesGroup.'|cat:$price.group}
                                    </span>
                                {/if}
                            </div>
                            <div class="col-md-8">
                                <div class="row">
                                    <div class="col-xs-4 col-4 text-center">
                                        {if isset($price.register) && current($price.register) > 0}
                                            {current($price.register)}<br>
                                            <small>{key($price.register)} {if key($price.register) > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
                                        {elseif isset($price.register) && current($price.register) == 0}
                                            <small>{lang key='orderfree'}</small>
                                        {else}
                                            <small>{lang key='na'}</small>
                                        {/if}
                                    </div>
                                    <div class="col-xs-4 col-4 text-center">
                                        {if isset($price.transfer) && current($price.transfer) > 0}
                                            {current($price.transfer)}<br>
                                            <small>{key($price.transfer)} {if key($price.register) > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
                                        {elseif isset($price.transfer) && current($price.transfer) == 0}
                                            <small>{lang key='orderfree'}</small>
                                        {else}
                                            <small>{lang key='na'}</small>
                                        {/if}
                                    </div>
                                    <div class="col-xs-4 col-4 text-center">
                                        {if isset($price.renew) && current($price.renew) > 0}
                                            {current($price.renew)}<br>
                                            <small>{key($price.renew)} {if key($price.register) > 1}{lang key="orderForm.years"}{else}{lang key="orderForm.year"}{/if}</small>
                                        {elseif isset($price.renew) && current($price.renew) == 0}
                                            <small>{lang key='orderfree'}</small>
                                        {else}
                                            <small>{lang key='na'}</small>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                    <div class="row tld-row no-tlds">
                        <div class="col-xs-12 col-12 text-center">
                            <br>
                            {lang key='pricing.selectExtCategory'}
                            <br><br>
                        </div>
                    </div>
                </div>

            </div>

            <div class="row">
                <div class="{if $domainTransferEnabled}col-md-6{else}col-md-8 col-md-offset-2 offset-md-2{/if}">
                    <div class="domain-promo-box">

                        <div class="clearfix">
                            <i class="fas fa-server fa-4x"></i>
                            <h3 class="font-size-24 no-wrap">{lang key='orderForm.addHosting'}</h3>
                            <p class="font-bold text-warning">{lang key='orderForm.chooseFromRange'}</p>
                        </div>

                        <p>{lang key='orderForm.packagesForBudget'}</p>

                        <a href="{$WEB_ROOT}/cart.php" class="btn btn-warning">
                            {lang key='orderForm.exploreNow'}
                        </a>
                    </div>
                </div>
                {if $domainTransferEnabled}
                    <div class="col-md-6">
                        <div class="domain-promo-box">

                            <div class="clearfix">
                                <i class="ti ti-world fa-4x"></i>
                                <h3 class="font-size-22">{lang key='orderForm.transferToUs'}</h3>
                                <p class="font-bold text-primary">{lang key='orderForm.transferExtend'}*</p>
                            </div>

                            <a href="{$WEB_ROOT}/cart.php?a=add&domain=transfer" class="btn btn-primary">
                                {lang key='orderForm.transferDomain'}
                            </a>

                            <p class="small">* {lang key='orderForm.extendExclusions'}</p>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>

<script>
{literal}
jQuery(document).ready(function() {
    jQuery('.tld-filters a:first-child').click();
    
    // Auto scroll to results when they are displayed
    var resultsNode = document.getElementById('DomainSearchResults');
    if (resultsNode) {
        var resultObserver = new MutationObserver(function(mutations) {
            if (!resultsNode.classList.contains('w-hidden') && window.getComputedStyle(resultsNode).display !== 'none') {
                resultsNode.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
        resultObserver.observe(resultsNode, { attributes: true, attributeFilter: ['class', 'style'] });
    }
{/literal}
{if $lookupTerm && !$captchaError && !$invalid}
    jQuery('#btnCheckAvailability').click();
{/if}
{if $invalid}
    jQuery('#primaryLookupSearching').toggle();
    jQuery('#primaryLookupResult').children().toggle();
    jQuery('#primaryLookupResult').toggle();
    jQuery('#DomainSearchResults').toggle();
    jQuery('.domain-invalid').toggle();
{/if}
{literal}
});
{/literal}

{if $showAdvancedSearchOptions}
    {literal}
    $(document).ready(function() {
        jQuery('#frmDomainChecker .multiselect').each(function () {
            const enableFiltering = $(this).hasClass('multiselect-filter');
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
    {/literal}
{/if}
</script>

