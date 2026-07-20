<script>
{literal}
    // Define state tab index value
    var statesTab = 10;
    // Do not enforce state input client side
    var stateNotRequired = true;
{/literal}
</script>
{include file="orderforms/snbdhost_cart/common.tpl"}
<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/VatValidator.js"></script>
<script>
{literal}
    window.langPasswordStrength = {/literal}"{$LANG.pwstrength}"{literal};
    window.langPasswordWeak = {/literal}"{$LANG.pwstrengthweak}"{literal};
    window.langPasswordModerate = {/literal}"{$LANG.pwstrengthmoderate}"{literal};
    window.langPasswordStrong = {/literal}"{$LANG.pwstrengthstrong}"{literal};
    window.langVatErrorInvalidFormat = {/literal}"{$LANG.tax.errorVatInvalidFormat}"{literal};
{/literal}
</script>

<style>
/* Base Animations */
@keyframes slideUpFade {
    from { opacity: 0; transform: translateY(12px); }
    to { opacity: 1; transform: translateY(0); }
}
@keyframes checkPop {
    0% { opacity: 0; transform: scale(0.6); }
    70% { transform: scale(1.1); }
    100% { opacity: 1; transform: scale(1); }
}

/* ── Checkout Cards ─────────────────────────────────────────────── */
#order-standard_cart .checkout-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 2rem 2.25rem;
    border: 1px solid #eeeeee;
    box-shadow: 0 1px 3px rgba(0,0,0,0.04);
    margin-bottom: 1.5rem;
    animation: slideUpFade 0.4s ease both;
}
.col-lg-8 > .checkout-card:nth-child(1) { animation-delay: 0.05s; }
.col-lg-8 > .checkout-card:nth-child(2) { animation-delay: 0.1s; }
.col-lg-8 > .checkout-card:nth-child(3) { animation-delay: 0.15s; }
.col-lg-8 > .checkout-card:nth-child(4) { animation-delay: 0.2s; }

/* ── Section Titles ─────────────────────────────────────────────── */
.checkout-section-title {
    font-size: 1rem;
    font-weight: 700;
    color: #111111;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.6rem;
    border-bottom: 1px solid #eeeeee;
    padding-bottom: 0.875rem;
}
.checkout-section-title i {
    font-size: 1.1rem;
    color: #CC0000;
}

/* ── Already Registered Banner ──────────────────────────────────── */
.already-registered {
    background: #F7F7F4 !important;
    border-radius: 10px !important;
    padding: 1.125rem 1.25rem !important;
    margin-bottom: 1.5rem !important;
    border: 1px solid #eeeeee !important;
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    flex-wrap: wrap !important;
    gap: 0.75rem !important;
}
.already-registered p {
    margin: 0 !important;
    font-weight: 500 !important;
    color: #555555 !important;
    font-size: 0.875rem !important;
}

/* ── Account & Payment Selectable Cards ─────────────────────────── */
.account, .payment-method-card {
    border: 1px solid #eeeeee !important;
    border-radius: 8px !important;
    background: #ffffff !important;
    cursor: pointer !important;
    transition: border-color 0.15s ease, background 0.15s ease !important;
    padding: 1rem !important;
    margin-bottom: 0.75rem !important;
    display: flex !important;
    align-items: center !important;
    gap: 12px !important;
}
.account:hover, .payment-method-card:hover {
    border-color: #cccccc !important;
    background: #fafafa !important;
}

/* ── Form Fields ────────────────────────────────────────────────── */
.form-group.prepend-icon {
    position: relative;
    margin-bottom: 1.25rem;
}
.form-group.prepend-icon .field-icon {
    position: absolute;
    left: 0.75rem;
    top: 50%;
    transform: translateY(-50%);
    color: #999999;
    z-index: 4;
    margin-bottom: 0;
    transition: color 0.15s ease;
    pointer-events: none;
}
.form-group.prepend-icon .field {
    padding-left: 2.25rem !important;
}
.form-group.prepend-icon:has(.field:focus) .field-icon {
    color: #CC0000;
}

/* ── Payment Methods Grid ───────────────────────────────────────── */
.payment-methods-grid {
    display: grid !important;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)) !important;
    gap: 1rem !important;
    margin-top: 1rem !important;
}
.payment-method-card {
    margin-bottom: 0;
}
.payment-method-card .payment-method-icon {
    display: flex;
    align-items: center;
    justify-content: center;
}
.payment-method-card .gateway-name {
    font-size: 0.875rem !important;
    font-weight: 600 !important;
    color: #333333 !important;
}
/* Gateway Brand Badges */
.gateway-badge {
    padding: 4px 12px;
    border-radius: 6px;
    font-size: 0.75rem;
    font-weight: 700;
    letter-spacing: 0.3px;
}
.gateway-badge.bkash { background: #e2136e; color: #ffffff; }
.gateway-badge.nagad { background: #f7941d; color: #ffffff; }
.gateway-badge.rocket { background: #8c3494; color: #ffffff; }

/* ── Order Summary Sidebar ──────────────────────────────────────── */
.checkout-summary-card {
    background: #ffffff !important;
    border-radius: 16px !important;
    padding: 1.75rem !important;
    color: #111111 !important;
    border: 1px solid #eeeeee !important;
    box-shadow: 0 1px 3px rgba(0,0,0,0.04) !important;
    animation: slideUpFade 0.4s ease 0.1s both;
    position: sticky;
    top: 24px;
}
.checkout-summary-card h3 {
    font-size: 1rem !important;
    font-weight: 700 !important;
    margin-bottom: 1.25rem !important;
    border-bottom: 1px solid #eeeeee !important;
    padding-bottom: 0.875rem !important;
    color: #111111 !important;
}
.summary-row {
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    margin-bottom: 0.875rem !important;
    font-size: 0.875rem !important;
    color: #555555 !important;
}
.summary-row span { color: #555555 !important; }
.summary-row.total {
    border-top: 1px solid #eeeeee !important;
    padding-top: 1.125rem !important;
    margin-top: 0.875rem !important;
    margin-bottom: 0 !important;
}
.summary-row.total span {
    font-weight: 600 !important;
    color: #111111 !important;
    font-size: 0.9375rem !important;
}
.summary-row.total strong {
    font-size: 1.6rem !important;
    color: #CC0000 !important;
    font-weight: 800 !important;
    line-height: 1;
    letter-spacing: 0.5px;
}

/* ── Apply Credit Box ───────────────────────────────────────────── */
.apply-credit-container {
    background: #F7F7F4 !important;
    border-radius: 10px !important;
    padding: 1.125rem !important;
    margin-bottom: 1.25rem !important;
    border: 1px solid #eeeeee !important;
}
.apply-credit-container p {
    font-size: 0.875rem !important;
    margin-bottom: 0.75rem !important;
    color: #555555 !important;
    font-weight: 500 !important;
}
.apply-credit-container label {
    display: flex !important;
    align-items: center !important;
    font-size: 0.8125rem !important;
    color: #555555 !important;
    cursor: pointer !important;
    margin-bottom: 0.5rem !important;
    gap: 0.5rem !important;
}
.apply-credit-container label:last-child { margin-bottom: 0 !important; }

/* ── Notes Textarea ─────────────────────────────────────────────── */
textarea.field.form-control {
    background: #F7F7F4 !important;
    border: 1px solid #eeeeee !important;
    border-radius: 10px !important;
    padding: 0.875rem 1rem !important;
    transition: border-color 0.15s, box-shadow 0.15s !important;
    font-size: 0.875rem !important;
    resize: vertical !important;
}
textarea.field.form-control:focus {
    border-color: #CC0000 !important;
    background: #ffffff !important;
    box-shadow: 0 0 0 3px rgba(204, 0, 0, 0.1) !important;
}

/* ── Complete Order Button ──────────────────────────────────────── */
#btnCompleteOrder {
    width: 100%;
    height: 52px;
    border-radius: 10px;
    background: #CC0000 !important;
    border: none !important;
    font-weight: 700;
    font-size: 1rem;
    color: #ffffff !important;
    box-shadow: 0 4px 14px rgba(204, 0, 0, 0.2) !important;
    transition: all 0.2s ease !important;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 1.5rem;
}
#btnCompleteOrder:hover:not(:disabled) {
    background: #AA0000 !important;
    transform: translateY(-2px) !important;
    box-shadow: 0 6px 20px rgba(204, 0, 0, 0.3) !important;
}

/* ── TOS Checkbox ───────────────────────────────────────────────── */
.checkout-summary-card .checkbox-inline {
    position: relative;
    padding-left: 28px !important;
    cursor: pointer;
    user-select: none;
    font-size: 0.8125rem !important;
    color: #555555 !important;
    display: flex !important;
    align-items: center !important;
    line-height: 1.5 !important;
    margin-bottom: 0 !important;
    min-height: 20px;
}
.checkout-summary-card .checkbox-inline input {
    position: absolute;
    opacity: 0;
    cursor: pointer;
    height: 0;
    width: 0;
}
.checkout-summary-card .checkbox-inline .checkmark {
    position: absolute;
    top: 50%;
    left: 0;
    transform: translateY(-50%);
    height: 18px;
    width: 18px;
    background-color: #F7F7F4;
    border: 1.5px solid #eeeeee;
    border-radius: 5px;
    transition: all 0.15s ease;
    flex-shrink: 0;
}
.checkout-summary-card .checkbox-inline:hover .checkmark {
    border-color: #CC0000;
    background-color: rgba(204, 0, 0, 0.04);
}
.checkout-summary-card .checkbox-inline input:checked ~ .checkmark {
    background-color: #CC0000;
    border-color: #CC0000;
}
.checkout-summary-card .checkbox-inline .checkmark:after {
    content: "";
    position: absolute;
    display: none;
    left: 5px;
    top: 1px;
    width: 5px;
    height: 10px;
    border: solid white;
    border-width: 0 2px 2px 0;
    transform: rotate(45deg);
}
.checkout-summary-card .checkbox-inline input:checked ~ .checkmark:after {
    display: block;
    animation: checkPop 0.2s ease;
}
.checkout-summary-card .checkbox-inline a {
    color: #CC0000 !important;
    text-decoration: underline !important;
}

/* ── Security Notice ────────────────────────────────────────────── */
.checkout-security-msg {
    margin-top: 1.5rem !important;
    font-size: 0.75rem !important;
    color: #555555 !important;
    background: #F7F7F4 !important;
    border: 1px solid #eeeeee !important;
    border-radius: 8px !important;
    padding: 1rem !important;
    text-align: left !important;
    line-height: 1.5 !important;
}
.checkout-security-msg i {
    font-size: 1.125rem !important;
    color: #2e7d32 !important;
    float: left !important;
    margin-right: 8px !important;
    margin-top: 1px;
}
</style>


<div id="order-standard_cart">

    <div class="row">
        <div class="cart-body col-12">
            <div class="header-lined mb-4 border-0 pb-0">
                <h1 class="dash-headline" style="font-size: 2rem;">{$LANG.orderForm.checkout}</h1>
            </div>

            <div class="alert alert-danger checkout-error-feedback {if !$errormessage}d-none{/if}" role="alert">
                <p>{$LANG.orderForm.correctErrors}:</p>
                <ul>
                    {if $errormessage}
                        {$errormessage}
                    {/if}
                    <li class="vat-error d-none"></li>
                </ul>
            </div>

            <form method="post" action="{$smarty.server.PHP_SELF}?a=checkout" name="orderfrm" id="frmCheckout">
                <input type="hidden" name="checkout" value="true" />
                <input type="hidden" name="custtype" id="inputCustType" value="{$custtype}" />
                {if $taxIdValidationEnabled}
                    <input type="hidden" id="validation_tax_id" value="true">
                {/if}

                {if $isTaxEUTaxExempt}
                    <input type="hidden" id="isTaxEUTaxExempt" value="true">
                {/if}

                {if $taxType !== ''}
                    <input type="hidden" id="taxType" value="{$taxType}">
                {/if}

                {if $isTaxInclusiveDeduct}
                    <input type="hidden" id="isTaxInclusiveDeduct" value="true">
                {/if}

                <div class="row">
                    <!-- LEFT COLUMN: Input forms and options -->
                    <div class="col-lg-8">
                        
                        <!-- Account Selector / Signup Card -->
                        <div class="checkout-card">
                            {if $custtype neq "new" && $loggedin}
                                <div class="checkout-section-title">
                                    <i class="ti ti-users"></i>
                                    <span>{lang key='switchAccount.title'}</span>
                                </div>
                                <div id="containerExistingAccountSelect" class="row account-select-container">
                                    {foreach $accounts as $account}
                                        <div class="col-sm-{if $accounts->count() == 1}12{else}6{/if}">
                                            <div class="account{if $selectedAccountId == $account->id} active{/if}">
                                                <label class="radio-inline w-100" style="display: flex; align-items: center; gap: 8px;" for="account{$account->id}">
                                                    <input id="account{$account->id}" class="account-select{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled{/if}" type="radio" name="account_id" value="{$account->id}"{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled="disabled"{/if}{if $selectedAccountId == $account->id} checked="checked"{/if}>
                                                    <span class="address">
                                                        <strong>
                                                            {if $account->company}{$account->company}{else}{$account->fullName}{/if}
                                                        </strong>
                                                        {if $account->isClosed || $account->noPermission}
                                                            <span class="label label-default">
                                                                {if $account->isClosed}
                                                                    {lang key='closed'}
                                                                {else}
                                                                    {lang key='noPermission'}
                                                                {/if}
                                                            </span>
                                                        {elseif $account->currencyCode}
                                                            <span class="label label-info">
                                                                {$account->currencyCode}
                                                            </span>
                                                        {/if}
                                                        <br>
                                                        <span class="small text-muted">
                                                            {$account->address1}{if $account->address2}, {$account->address2}{/if}<br>
                                                            {if $account->city}{$account->city},{/if}
                                                            {if $account->state} {$account->state},{/if}
                                                            {if $account->postcode} {$account->postcode},{/if}
                                                            {$account->countryName}
                                                        </span>
                                                    </span>
                                                </label>
                                            </div>
                                        </div>
                                    {/foreach}
                                    <div class="col-sm-12">
                                        <div class="account {if !$selectedAccountId || !is_numeric($selectedAccountId)} active{/if}">
                                            <label class="radio-inline w-100 m-0" style="display: flex; align-items: center; gap: 8px; min-height: 50px;">
                                                <input class="account-select" type="radio" name="account_id" value="new"{if !$selectedAccountId || !is_numeric($selectedAccountId)} checked="checked"{/if}{if $inExpressCheckout} disabled="disabled" class="disabled"{/if}>
                                                <strong style="margin-top: 2px;">{lang key='orderForm.createAccount'}</strong>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            {/if}

                            <!-- Existing user signin option -->
                            <div id="containerExistingUserSignin"{if $loggedin || $custtype neq "existing"} class="w-hidden"{/if}>
                                <div class="checkout-section-title">
                                    <i class="ti ti-login"></i>
                                    <span>{$LANG.orderForm.existingCustomerLogin}</span>
                                </div>

                                <div class="alert alert-danger w-hidden" id="existingLoginMessage"></div>

                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputLoginEmail" class="field-icon">
                                                <i class="ti ti-mail"></i>
                                            </label>
                                            <input type="text" name="loginemail" id="inputLoginEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$loginemail}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputLoginPassword" class="field-icon">
                                                <i class="ti ti-lock"></i>
                                            </label>
                                            <input type="password" name="loginpassword" id="inputLoginPassword" class="field form-control" placeholder="{$LANG.clientareapassword}">
                                        </div>
                                    </div>
                                </div>

                                <div class="text-center mt-2 mb-4">
                                    <button type="button" id="btnExistingLogin" class="btn btn-primary px-4 py-2" style="border-radius:8px;">
                                        <span id="existingLoginButton">{lang key='login'}</span>
                                        <span id="existingLoginPleaseWait" class="w-hidden">{lang key='pleasewait'}</span>
                                    </button>
                                </div>

                                {include file="orderforms/snbdhost_cart/linkedaccounts.tpl" linkContext="checkout-existing"}
                            </div>

                            <!-- New user signup form -->
                            <div id="containerNewUserSignup"
                                {if
                                    $custtype === 'existing'
                                    || (is_numeric($selectedAccountId) && $selectedAccountId > 0)
                                    || (
                                        $loggedin
                                        && $selectedAccountId !== 'new'
                                        && $custtype !== 'add'
                                    )
                                }
                                    class="w-hidden"
                                {/if}
                            >
                                <div{if $loggedin} class="w-hidden"{/if}>
                                    {include file="orderforms/snbdhost_cart/linkedaccounts.tpl" linkContext="checkout-new"}
                                </div>

                                <!-- Dynamic switcher for guest users -->
                                <div class="already-registered clearfix">
                                    <p>{lang key='orderForm.enterPersonalDetails'}</p>
                                    <div>
                                        <button type="button" class="btn btn-info{if $loggedin || !$loggedin && $custtype eq "existing"} w-hidden{/if}" id="btnAlreadyRegistered">
                                            {$LANG.orderForm.alreadyRegistered}
                                        </button>
                                        <button type="button" class="btn btn-warning{if $loggedin || $custtype neq "existing"} w-hidden{/if}" id="btnNewUserSignup">
                                            {$LANG.orderForm.createAccount}
                                        </button>
                                    </div>
                                </div>

                                <div class="checkout-section-title mt-4">
                                    <i class="ti ti-user"></i>
                                    <span>{$LANG.orderForm.personalInformation}</span>
                                </div>

                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputFirstName" class="field-icon">
                                                <i class="ti ti-user"></i>
                                            </label>
                                            <input type="text" name="firstname" id="inputFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$clientsdetails.firstname}" autofocus>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputLastName" class="field-icon">
                                                <i class="ti ti-user"></i>
                                            </label>
                                            <input type="text" name="lastname" id="inputLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$clientsdetails.lastname}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputEmail" class="field-icon">
                                                <i class="ti ti-mail"></i>
                                            </label>
                                            <input type="email" name="email" id="inputEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$clientsdetails.email}">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputPhone" class="field-icon">
                                                <i class="ti ti-phone"></i>
                                            </label>
                                            <input type="tel" name="phonenumber" id="inputPhone" class="field form-control" placeholder="{$LANG.orderForm.phoneNumber}" value="{$clientsdetails.phonenumber}">
                                        </div>
                                    </div>
                                </div>

                                <div class="checkout-section-title mt-4">
                                    <i class="ti ti-map-pin"></i>
                                    <span>{$LANG.orderForm.billingAddress}</span>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group prepend-icon">
                                            <label for="inputCompanyName" class="field-icon">
                                                <i class="ti ti-building"></i>
                                            </label>
                                            <input type="text" name="companyname" id="inputCompanyName" class="field form-control" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$clientsdetails.companyname}">
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group prepend-icon">
                                            <label for="inputAddress1" class="field-icon">
                                                <i class="ti ti-building"></i>
                                            </label>
                                            <input type="text" name="address1" id="inputAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$clientsdetails.address1}">
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group prepend-icon">
                                            <label for="inputAddress2" class="field-icon">
                                                <i class="ti ti-map-pin"></i>
                                            </label>
                                            <input type="text" name="address2" id="inputAddress2" class="field form-control" placeholder="{$LANG.orderForm.streetAddress2}" value="{$clientsdetails.address2}">
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group prepend-icon">
                                            <label for="inputCity" class="field-icon">
                                                <i class="ti ti-building"></i>
                                            </label>
                                            <input type="text" name="city" id="inputCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$clientsdetails.city}">
                                        </div>
                                    </div>
                                    <div class="col-sm-5">
                                        <div class="form-group prepend-icon">
                                            <label for="state" class="field-icon" id="inputStateIcon">
                                                <i class="ti ti-map"></i>
                                            </label>
                                            <label for="stateinput" class="field-icon" id="inputStateIcon">
                                                <i class="ti ti-map"></i>
                                            </label>
                                            <input type="text" name="state" id="inputState" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$clientsdetails.state}">
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group prepend-icon">
                                            <label for="inputPostcode" class="field-icon">
                                                <i class="ti ti-certificate"></i>
                                            </label>
                                            <input type="text" name="postcode" id="inputPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$clientsdetails.postcode}">
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group prepend-icon">
                                            <label for="inputCountry" class="field-icon" id="inputCountryIcon">
                                                <i class="ti ti-world"></i>
                                            </label>
                                            <select name="country" id="inputCountry" class="field form-control">
                                                {foreach $countries as $countrycode => $countrylabel}
                                                    <option value="{$countrycode}"{if (!$country && $countrycode == $defaultcountry) || $countrycode eq $country} selected{/if}>
                                                        {$countrylabel}
                                                    </option>
                                                {/foreach}
                                            </select>
                                        </div>
                                    </div>
                                    {if $showTaxIdField}
                                        <div class="col-sm-12">
                                            <div class="form-group prepend-icon">
                                                <label for="inputTaxId" class="field-icon">
                                                    <i class="ti ti-building"></i>
                                                </label>
                                                <input type="text" name="tax_id" id="inputTaxId" class="field form-control" placeholder="{$taxLabel}" value="{$clientsdetails.tax_id}" autocomplete="off">
                                            </div>
                                        </div>
                                    {/if}
                                </div>

                                {if $customfields}
                                    <div class="checkout-section-title mt-4">
                                        <i class="ti ti-info-circle"></i>
                                        <span>{$LANG.orderadditionalrequiredinfo}</span>
                                    </div>
                                    <div class="field-container">
                                        <div class="row">
                                            {foreach $customfields as $customfield}
                                                <div class="col-sm-6">
                                                    <div class="form-group">
                                                        <label for="customfield{$customfield.id}">{$customfield.name} {$customfield.required}</label>
                                                        {$customfield.input}
                                                        {if $customfield.description}
                                                            <span class="field-help-text text-muted small">{$customfield.description}</span>
                                                        {/if}
                                                    </div>
                                                </div>
                                            {/foreach}
                                        </div>
                                    </div>
                                {/if}
                            </div>

                            {if isset($checkoutExtraFields) && !empty($checkoutExtraFields)}
                                <div class="checkout-section-title mt-4">
                                    <i class="ti ti-file-text"></i>
                                    <span>{lang key='orderForm.additionalInformation'}</span>
                                </div>
                                <div class="row">
                                    {foreach $checkoutExtraFields as $field}
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label for="{$field.name}">
                                                    {$field.label|escape}
                                                    {if $field.required}<span class="text-danger">*</span>{/if}
                                                </label>
                                                {$field.input}
                                                {if $field.description}
                                                    <span class="field-help-text text-muted small">{$field.description}</span>
                                                {/if}
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>
                            {/if}
                        </div>

                        <!-- Domain Registrant Card -->
                        {if $domainsinorder}
                            <div class="checkout-card">
                                <div class="checkout-section-title">
                                    <i class="ti ti-world"></i>
                                    <span>{$LANG.domainregistrantinfo}</span>
                                </div>

                                <p class="small text-muted mb-4">{$LANG.orderForm.domainAlternativeContact}</p>

                                <div class="row mb-4">
                                    <div class="col-sm-8 offset-sm-2">
                                        <select name="contact" id="inputDomainContact" class="field form-control">
                                            <option value="">{$LANG.usedefaultcontact}</option>
                                            {foreach $domaincontacts as $domcontact}
                                                <option value="{$domcontact.id}"{if $contact == $domcontact.id} selected{/if}>
                                                    {$domcontact.name}
                                                </option>
                                            {/foreach}
                                            <option value="addingnew"{if $contact == "addingnew"} selected{/if}>
                                                {$LANG.clientareanavaddcontact}...
                                            </option>
                                        </select>
                                    </div>
                                </div>

                                <div{if $contact neq "addingnew"} class="w-hidden"{/if}>
                                    <div class="row" id="domainRegistrantInputFields">
                                        <div class="col-sm-6">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCFirstName" class="field-icon">
                                                    <i class="ti ti-user"></i>
                                                </label>
                                                <input type="text" name="domaincontactfirstname" id="inputDCFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$domaincontact.firstname}">
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCLastName" class="field-icon">
                                                    <i class="ti ti-user"></i>
                                                </label>
                                                <input type="text" name="domaincontactlastname" id="inputDCLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$domaincontact.lastname}">
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCEmail" class="field-icon">
                                                    <i class="ti ti-mail"></i>
                                                </label>
                                                <input type="email" name="domaincontactemail" id="inputDCEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$domaincontact.email}">
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCPhone" class="field-icon">
                                                    <i class="ti ti-phone"></i>
                                                </label>
                                                <input type="tel" name="domaincontactphonenumber" id="inputDCPhone" class="field form-control" placeholder="{$LANG.orderForm.phoneNumber}" value="{$domaincontact.phonenumber}">
                                            </div>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCCompanyName" class="field-icon">
                                                    <i class="ti ti-building"></i>
                                                </label>
                                                <input type="text" name="domaincontactcompanyname" id="inputDCCompanyName" class="field form-control" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$domaincontact.companyname}">
                                            </div>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCAddress1" class="field-icon">
                                                    <i class="ti ti-building"></i>
                                                </label>
                                                <input type="text" name="domaincontactaddress1" id="inputDCAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$domaincontact.address1}">
                                            </div>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCAddress2" class="field-icon">
                                                    <i class="ti ti-map-pin"></i>
                                                </label>
                                                <input type="text" name="domaincontactaddress2" id="inputDCAddress2" class="field form-control" placeholder="{$LANG.orderForm.streetAddress2}" value="{$domaincontact.address2}">
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCCity" class="field-icon">
                                                    <i class="ti ti-building"></i>
                                                </label>
                                                <input type="text" name="domaincontactcity" id="inputDCCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$domaincontact.city}">
                                            </div>
                                        </div>
                                        <div class="col-sm-5">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCState" class="field-icon">
                                                    <i class="ti ti-map"></i>
                                                </label>
                                                <input type="text" name="domaincontactstate" id="inputDCState" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$domaincontact.state}">
                                            </div>
                                        </div>
                                        <div class="col-sm-3">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCPostcode" class="field-icon">
                                                    <i class="ti ti-certificate"></i>
                                                </label>
                                                <input type="text" name="domaincontactpostcode" id="inputDCPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$domaincontact.postcode}">
                                            </div>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCCountry" class="field-icon" id="inputCountryIcon">
                                                    <i class="ti ti-world"></i>
                                                </label>
                                                <select name="domaincontactcountry" id="inputDCCountry" class="field form-control">
                                                    {foreach $countries as $countrycode => $countrylabel}
                                                        <option value="{$countrycode}"{if (!$domaincontact.country && $countrycode == $defaultcountry) || $countrycode eq $domaincontact.country} selected{/if}>
                                                            {$countrylabel}
                                                        </option>
                                                    {/foreach}
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="form-group prepend-icon">
                                                <label for="inputDCTaxId" class="field-icon">
                                                    <i class="ti ti-building"></i>
                                                </label>
                                                <input type="text" name="domaincontacttax_id" id="inputDCTaxId" class="field form-control" placeholder="{$taxLabel}" value="{$domaincontact.tax_id}" autocomplete="off">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/if}

                        <!-- Account Security Card -->
                        {if !$loggedin}
                            <div id="containerNewUserSecurity" class="checkout-card {if (!$loggedin && $custtype eq "existing") || ($remote_auth_prelinked && !$securityquestions)}w-hidden{/if}">
                                <div class="checkout-section-title">
                                    <i class="ti ti-shield-lock"></i>
                                    <span>{$LANG.orderForm.accountSecurity}</span>
                                </div>

                                <div id="containerPassword" class="row{if $remote_auth_prelinked && $securityquestions} w-hidden{/if}">
                                    <div id="passwdFeedback" class="alert alert-info text-center col-sm-12 w-hidden"></div>
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputNewPassword1" class="field-icon">
                                                <i class="ti ti-lock"></i>
                                            </label>
                                            <input type="password" name="password" id="inputNewPassword1" data-error-threshold="{$pwStrengthErrorThreshold}" data-warning-threshold="{$pwStrengthWarningThreshold}" class="field form-control" placeholder="{$LANG.clientareapassword}"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group prepend-icon">
                                            <label for="inputNewPassword2" class="field-icon">
                                                <i class="ti ti-lock"></i>
                                            </label>
                                            <input type="password" name="password2" id="inputNewPassword2" class="field form-control" placeholder="{$LANG.clientareaconfirmpassword}"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                        </div>
                                    </div>
                                    <div class="col-sm-6 mb-3">
                                        <button type="button" class="btn btn-secondary btn-sm generate-password px-3" data-targetfields="inputNewPassword1,inputNewPassword2">
                                            {$LANG.generatePassword.btnLabel}
                                        </button>
                                    </div>
                                    <div class="col-sm-6 mb-3">
                                        <div class="password-strength-meter">
                                            <div class="progress" style="height:6px;">
                                                <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="passwordStrengthMeterBar"></div>
                                            </div>
                                            <p class="text-center small text-muted mt-1" id="passwordStrengthTextLabel">{$LANG.pwstrength}: {$LANG.pwstrengthenter}</p>
                                        </div>
                                    </div>
                                </div>
                                {if $securityquestions}
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <select name="securityqid" id="inputSecurityQId" class="field form-control">
                                                <option value="">{$LANG.clientareasecurityquestion}</option>
                                                {foreach $securityquestions as $question}
                                                    <option value="{$question.id}"{if $question.id eq $securityqid} selected{/if}>
                                                        {$question.question}
                                                    </option>
                                                {/foreach}
                                            </select>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group prepend-icon">
                                                <label for="inputSecurityQAns" class="field-icon">
                                                    <i class="ti ti-lock"></i>
                                                </label>
                                                <input type="password" name="securityqans" id="inputSecurityQAns" class="field form-control" placeholder="{$LANG.clientareasecurityanswer}">
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            </div>
                        {/if}

                        <!-- Hook Outputs -->
                        {foreach $hookOutput as $output}
                            <div class="mb-4">
                                {$output}
                            </div>
                        {/foreach}

                        <!-- Payment Gateways Card -->
                        <div class="checkout-card">
                            <div class="checkout-section-title">
                                <i class="ti ti-credit-card"></i>
                                <span>Payment Method</span>
                            </div>

                            {if !$inExpressCheckout}
                                <div id="paymentGatewaysContainer" class="form-group">
                                    <p class="small text-muted mb-3">{$LANG.orderForm.preferredPaymentMethod}</p>

                                    <div class="payment-methods-grid">
                                        {foreach $gateways as $gateway}
                                            <label class="payment-method-card" for="gateway_{$gateway.sysname}">
                                                <input type="radio"
                                                       name="paymentmethod"
                                                       id="gateway_{$gateway.sysname}"
                                                       value="{$gateway.sysname}"
                                                       data-payment-type="{$gateway.payment_type}"
                                                       data-show-local="{$gateway.show_local_cards}"
                                                       data-remote-inputs="{$gateway.uses_remote_inputs}"
                                                       class="payment-methods{if $gateway.type eq 'CC'} is-credit-card{/if}"
                                                        {if $selectedgateway eq $gateway.sysname} checked{/if}
                                                />
                                                <div class="payment-method-icon">
                                                    {if $gateway.sysname eq "stripe" || $gateway.sysname eq "stripe_sepa" || $gateway.sysname eq "stripe_ach"}
                                                        <i class="ti ti-brand-stripe" style="color: #635bff; font-size: 1.75rem;"></i>
                                                    {elseif $gateway.sysname eq "paypal" || $gateway.sysname eq "paypalcheckout"}
                                                        <i class="ti ti-brand-paypal" style="color: #003087; font-size: 1.5rem;"></i>
                                                    {else}
                                                        <i class="ti ti-wallet text-muted font-size-24"></i>
                                                    {/if}
                                                </div>
                                                <span class="gateway-name">{$gateway.name}</span>
                                            </label>
                                        {/foreach}
                                    </div>
                                </div>

                                <div class="alert alert-danger text-center gateway-errors w-hidden mt-3"></div>
                                <div id="paymentGatewayInput" class="mt-3"></div>

                                <!-- Credit Card Details -->
                                <div class="cc-input-container{if $selectedgatewaytype neq "CC"} w-hidden{/if} mt-4" id="creditCardInputFields">
                                    {if $client}
                                        <div id="existingCardsContainer" class="existing-cc-grid">
                                            {include file="orderforms/snbdhost_cart/includes/existing-paymethods.tpl"}
                                        </div>
                                    {/if}
                                    <div class="row cvv-input mt-3" id="existingCardInfo">
                                        <div class="col-lg-4 col-sm-6">
                                            <div class="form-group prepend-icon">
                                                <label for="inputCardCVV2" class="field-icon">
                                                    <i class="ti ti-barcode"></i>
                                                </label>
                                                <div class="input-group">
                                                    <input type="tel" name="cccvv" id="inputCardCVV2" class="field form-control" placeholder="{$LANG.creditcardcvvnumbershort}" autocomplete="cc-cvc">
                                                    <span class="input-group-btn input-group-append">
                                                        <button type="button" class="btn btn-secondary px-3" data-bs-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />" style="border-top-left-radius:0;border-bottom-left-radius:0;">
                                                            ?
                                                        </button>
                                                    </span>
                                                </div>
                                                <span class="field-error-msg">{lang key="paymentMethodsManage.cvcNumberNotValid"}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="radio-inline" style="font-weight:600;">
                                            <input type="radio" name="ccinfo" value="new" id="new" {if !$client || $client->payMethods->count() === 0} checked="checked"{/if} />
                                            &nbsp; {lang key='creditcardenternewcard'}
                                        </label>
                                    </div>

                                    <div class="row" id="newCardInfo">
                                        <div id="cardNumberContainer" class="col-sm-6 new-card-container">
                                            <div class="form-group prepend-icon">
                                                <label for="inputCardNumber" class="field-icon">
                                                    <i class="ti ti-credit-card"></i>
                                                </label>
                                                <input type="tel" name="ccnumber" id="inputCardNumber" class="field form-control cc-number-field" placeholder="{$LANG.orderForm.cardNumber}" autocomplete="cc-number" data-message-unsupported="{lang key='paymentMethodsManage.unsupportedCardType'}" data-message-invalid="{lang key='paymentMethodsManage.cardNumberNotValid'}" data-supported-cards="{$supportedCardTypes}" />
                                                <span class="field-error-msg"></span>
                                            </div>
                                        </div>
                                        <div class="col-sm-3 new-card-container">
                                            <div class="form-group prepend-icon">
                                                <label for="inputCardExpiry" class="field-icon">
                                                    <i class="ti ti-calendar"></i>
                                                </label>
                                                <input type="tel" name="ccexpirydate" id="inputCardExpiry" class="field form-control" placeholder="MM / YY{if $showccissuestart} ({$LANG.creditcardcardexpires}){/if}" autocomplete="cc-exp">
                                                <span class="field-error-msg">{lang key="paymentMethodsManage.expiryDateNotValid"}</span>
                                            </div>
                                        </div>
                                        <div class="col-sm-3" id="cvv-field-container">
                                            <div class="form-group prepend-icon">
                                                <label for="inputCardCVV" class="field-icon">
                                                    <i class="ti ti-barcode"></i>
                                                </label>
                                                <div class="input-group">
                                                    <input type="tel" name="cccvv" id="inputCardCVV" class="field form-control" placeholder="{$LANG.creditcardcvvnumbershort}" autocomplete="cc-cvc">
                                                    <span class="input-group-btn input-group-append">
                                                        <button type="button" class="btn btn-secondary px-3" data-bs-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />" style="border-top-left-radius:0;border-bottom-left-radius:0;">
                                                            ?
                                                        </button>
                                                    </span>
                                                </div>
                                                <span class="field-error-msg">{lang key="paymentMethodsManage.cvcNumberNotValid"}</span>
                                            </div>
                                        </div>
                                        {if $showccissuestart}
                                            <div class="col-sm-3 col-sm-offset-6 new-card-container offset-sm-6">
                                                <div class="form-group prepend-icon">
                                                    <label for="inputCardStart" class="field-icon">
                                                        <i class="ti ti-calendar-check"></i>
                                                    </label>
                                                    <input type="tel" name="ccstartdate" id="inputCardStart" class="field form-control" placeholder="MM / YY ({$LANG.creditcardcardstart})" autocomplete="cc-exp">
                                                </div>
                                            </div>
                                            <div class="col-sm-3 new-card-container">
                                                <div class="form-group prepend-icon">
                                                    <label for="inputCardIssue" class="field-icon">
                                                        <i class="ti ti-asterisk"></i>
                                                    </label>
                                                    <input type="tel" name="ccissuenum" id="inputCardIssue" class="field form-control" placeholder="{$LANG.creditcardcardissuenum}">
                                                </div>
                                            </div>
                                        {/if}
                                    </div>
                                    <div id="newCardSaveSettings">
                                        <div class="row form-group new-card-container">
                                            <div id="inputDescriptionContainer" class="col-md-6">
                                                <div class="prepend-icon">
                                                    <label for="inputDescription" class="field-icon">
                                                        <i class="ti ti-edit"></i>
                                                    </label>
                                                    <input type="text" class="field form-control" id="inputDescription" name="ccdescription" autocomplete="off" value="" placeholder="{$LANG.paymentMethods.descriptionInput} {$LANG.paymentMethodsManage.optional}" />
                                                </div>
                                            </div>
                                            {if $allowClientsToRemoveCards}
                                                <div id="inputNoStoreContainer" class="col-md-6" style="line-height: 32px;">
                                                    <input type="hidden" name="nostore" value="1">
                                                    <input type="checkbox" class="toggle-switch-success no-icheck" data-size="mini" checked="checked" name="nostore" id="inputNoStore" value="0" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
                                                    <label for="inputNoStore" class="checkbox-inline no-padding">
                                                        &nbsp;&nbsp; {$LANG.creditCardStore}
                                                    </label>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                            {else}
                                {if $expressCheckoutOutput}
                                    {$expressCheckoutOutput}
                                {else}
                                    <p align="center">
                                        {lang key='paymentPreApproved' gateway=$expressCheckoutGateway}
                                    </p>
                                {/if}
                            {/if}
                        </div>

                        <!-- Additional Notes Card -->
                        {if $shownotesfield}
                            <div class="checkout-card">
                                <div class="checkout-section-title">
                                    <i class="ti ti-edit"></i>
                                    <span>{$LANG.orderForm.additionalNotes}</span>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group mb-0">
                                            <textarea name="notes" class="field form-control" rows="4" placeholder="{$LANG.ordernotesdescription}">{$orderNotes}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/if}

                    </div>

                    <!-- RIGHT COLUMN: Order Summary (Sticky Sidebar) -->
                    <div class="col-lg-4">
                        <div class="checkout-summary-card sticky-top" style="top: 2rem; z-index: 10;">
                            <h3>Order Summary</h3>

                            <!-- Total due today -->
                            <div class="summary-row total mb-4">
                                <span>{$LANG.ordertotalduetoday}</span>
                                <strong id="totalCartPrice">{$total}</strong>
                            </div>

                            <!-- Apply Credit -->
                            <div id="applyCreditContainer" class="apply-credit-container{if !$canUseCreditOnCheckout} w-hidden{/if}" data-apply-credit="{$applyCredit}">
                                <p>{lang key='cart.availableCreditBalance' amount=$creditBalance}</p>

                                <label class="radio">
                                    <input id="useCreditOnCheckout" type="radio" name="applycredit" value="1"{if $applyCredit} checked{/if}>
                                    <span id="spanFullCredit"{if !($creditBalance->toNumeric() >= $total->toNumeric())} class="w-hidden"{/if}>
                                        {lang key='cart.applyCreditAmountNoFurtherPayment' amount=$total}
                                    </span>
                                    <span id="spanUseCredit"{if $creditBalance->toNumeric() >= $total->toNumeric()} class="w-hidden"{/if}>
                                        {lang key='cart.applyCreditAmount' amount=$creditBalance}
                                    </span>
                                </label>
                                <label class="radio">
                                    <input id="skipCreditOnCheckout" type="radio" name="applycredit" value="0"{if !$applyCredit} checked{/if}>
                                    {lang key='cart.applyCreditSkip' amount=$creditBalance}
                                </label>
                            </div>

                            <!-- Captcha -->
                            {if ($captcha && $captcha->isEnabled() && $captcha->isEnabledForForm($captchaForm)) || $turnstileEnabled}
                                <div class="text-center mb-4">
                                    {include file="$template/includes/captcha.tpl"}
                                </div>
                            {/if}

                            <!-- Marketing Opt In -->
                            {if $showMarketingEmailOptIn}
                                <div class="marketing-email-optin mb-4">
                                    <h4>{lang key='emailMarketing.joinOurMailingList'}</h4>
                                    <p>{$marketingEmailOptInMessage}</p>
                                    <input type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if} class="no-icheck toggle-switch-success" data-size="small" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
                                </div>
                            {/if}

                            <!-- TOS -->
                            {if $accepttos}
                                <div class="mb-4">
                                    <label class="checkbox-inline">
                                        <input type="checkbox" class="no-icheck" name="accepttos" id="accepttos" />
                                        <span class="checkmark"></span>
                                        <span>{$LANG.ordertosagreement} <a href="{$tosurl}" target="_blank">{$LANG.ordertos}</a></span>
                                    </label>
                                </div>
                            {/if}

                            <!-- Submit Button -->
                            <button type="submit"
                                    id="btnCompleteOrder"
                                    class="btn btn-primary btn-lg disable-on-click spinner-on-click{if $captcha}{$captcha->getButtonClass($captchaForm)}{/if}"
                                    {if $cartitems==0}disabled="disabled"{/if}
                            >
                                {if $inExpressCheckout}{$LANG.confirmAndPay}{else}{$LANG.completeorder}{/if}
                                &nbsp;<i class="ti ti-arrow-right-circle"></i>
                            </button>

                            <!-- Secure notice -->
                            {if $servedOverSsl}
                                <div class="checkout-security-msg">
                                    <i class="ti ti-lock"></i>
                                    {$LANG.ordersecure} (<strong>{$ipaddress}</strong>) {$LANG.ordersecure2}
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript" src="{$BASE_PATH_JS}/jquery.payment.js"></script>
<script>
    var hideCvcOnCheckoutForExistingCard = '{if $canUseCreditOnCheckout && $applyCredit && ($creditBalance->toNumeric() >= $total->toNumeric())}1{else}0{/if}';
</script>

<script>
{literal}
document.addEventListener("DOMContentLoaded", function() {
    // Style payment method cards based on gateway type/value
    var gatewayCards = document.querySelectorAll('.payment-method-card');
    gatewayCards.forEach(function(card) {
        var radio = card.querySelector('input[type="radio"]');
        if (!radio) return;
        var val = radio.value.toLowerCase();
        var iconDiv = card.querySelector('.payment-method-icon');
        
        if (val.includes('bkash')) {
            iconDiv.innerHTML = '<span class="gateway-badge bkash">bKash</span>';
        } else if (val.includes('nagad')) {
            iconDiv.innerHTML = '<span class="gateway-badge nagad">Nagad</span>';
        } else if (val.includes('rocket')) {
            iconDiv.innerHTML = '<span class="gateway-badge rocket">Rocket</span>';
        } else if (val.includes('stripe') || val.includes('card') || radio.classList.contains('is-credit-card')) {
            iconDiv.innerHTML = '<i class="ti ti-credit-card font-size-26 text-primary"></i>';
        } else if (val.includes('paypal')) {
            iconDiv.innerHTML = '<i class="ti ti-brand-paypal font-size-26" style="color:#003087;"></i>';
        } else {
            iconDiv.innerHTML = '<i class="ti ti-wallet font-size-26 text-muted"></i>';
        }
    });
});
{/literal}
</script>
