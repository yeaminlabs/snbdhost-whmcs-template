<script>
    // Define state tab index value
    var statesTab = 10;
    // Do not enforce state input client side
    var stateNotRequired = true;
</script>
{include file="orderforms/snbdhost_cart/common.tpl"}
<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/VatValidator.js"></script>
<script>
    window.langPasswordStrength = "{$LANG.pwstrength}";
    window.langPasswordWeak = "{$LANG.pwstrengthweak}";
    window.langPasswordModerate = "{$LANG.pwstrengthmoderate}";
    window.langPasswordStrong = "{$LANG.pwstrengthstrong}";
    window.langVatErrorInvalidFormat = "{$LANG.tax.errorVatInvalidFormat}";
</script>

<style>
/* Base Animations */
@keyframes slideUpFade {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}
@keyframes popIn {
    0% { opacity: 0; transform: scale(0.8); }
    70% { transform: scale(1.05); }
    100% { opacity: 1; transform: scale(1); }
}

/* Checkout Container & Columns */
#order-standard_cart {
    font-family: 'Outfit', 'Inter', sans-serif !important;
    color: #1e293b !important;
}

#order-standard_cart .checkout-card {
    background: #ffffff;
    border-radius: 20px;
    padding: 2.5rem;
    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
    border: 1px solid rgba(226, 232, 240, 0.8);
    margin-bottom: 2rem;
    animation: slideUpFade 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
}
.col-lg-8 > .checkout-card:nth-child(1) { animation-delay: 0.1s; }
.col-lg-8 > .checkout-card:nth-child(2) { animation-delay: 0.2s; }
.col-lg-8 > .checkout-card:nth-child(3) { animation-delay: 0.3s; }
.col-lg-8 > .checkout-card:nth-child(4) { animation-delay: 0.4s; }

/* Titles */
.checkout-section-title {
    font-size: 1.25rem;
    font-weight: 700;
    color: #0f172a;
    margin-bottom: 1.75rem;
    display: flex;
    align-items: center;
    border-bottom: 1px solid #f1f5f9;
    padding-bottom: 1rem;
}
.checkout-section-title i {
    font-size: 1.5rem;
    color: #e11d48;
    margin-right: 0.75rem;
    background: rgba(225, 29, 72, 0.1);
    padding: 8px;
    border-radius: 10px;
}

/* Already Registered callout */
.already-registered {
    background: linear-gradient(135deg, #f8fafc, #f1f5f9) !important;
    border-radius: 16px !important;
    padding: 1.5rem !important;
    margin-bottom: 2rem !important;
    border: 1px solid #e2e8f0 !important;
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    flex-wrap: wrap !important;
    gap: 1rem !important;
}
.already-registered p {
    margin: 0 !important;
    font-weight: 600 !important;
    color: #334155 !important;
}
.already-registered .btn {
    border-radius: 10px !important;
    font-weight: 600 !important;
    padding: 0.6rem 1.25rem !important;
    transition: transform 0.2s ease !important;
}
.already-registered .btn:hover {
    transform: translateY(-2px) !important;
}

/* Account selection & Payment Cards (The Interactive Elements) */
.account, .payment-method-card {
    border: 2px solid #e2e8f0 !important;
    border-radius: 16px !important;
    background: #ffffff !important;
    cursor: pointer !important;
    transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1) !important;
    position: relative !important;
    overflow: hidden !important;
}
.account {
    padding: 1.5rem !important;
    margin-bottom: 1rem !important;
    display: block !important;
}
.payment-method-card {
    padding: 1.5rem 1rem !important;
    display: flex !important;
    flex-direction: column !important;
    align-items: center !important;
    justify-content: center !important;
    margin: 0 !important;
    text-align: center !important;
    min-height: 120px;
}
.account input[type="radio"], .payment-method-card input[type="radio"] {
    position: absolute !important;
    opacity: 0 !important;
    width: 0 !important;
    height: 0 !important;
}

.account:hover, .payment-method-card:hover {
    border-color: #cbd5e1 !important;
    transform: translateY(-4px) !important;
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.04) !important;
}

/* Active State (Glowing Ring Effect) */
.account:has(input:checked), .payment-method-card:has(input:checked) {
    border-color: transparent !important;
    background: #ffffff !important;
    box-shadow: 0 0 0 2px #ffffff, 0 0 0 4px #e11d48, 0 12px 24px rgba(225, 29, 72, 0.15) !important;
    transform: translateY(-2px) !important;
}
.account .address {
    font-size: 0.9rem !important;
    line-height: 1.5 !important;
    color: #475569 !important;
}
.account:has(input:checked) .address strong {
    color: #0f172a !important;
}

/* The Select Indicator (Animated Checkmark) */
.payment-method-card .select-indicator, .account .select-indicator {
    position: absolute;
    top: 12px;
    right: 12px;
    width: 24px;
    height: 24px;
    background: #e11d48;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    opacity: 0;
    transform: scale(0.5);
    transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    box-shadow: 0 4px 10px rgba(225, 29, 72, 0.3);
}
.account .select-indicator {
    top: 50%;
    transform: translateY(-50%) scale(0.5);
    right: 1.5rem;
}
.payment-method-card:has(input:checked) .select-indicator {
    opacity: 1;
    transform: scale(1);
}
.account:has(input:checked) .select-indicator {
    opacity: 1;
    transform: translateY(-50%) scale(1);
}

/* Form fields customization */
.form-group.prepend-icon {
    position: relative;
    margin-bottom: 1.5rem;
}
.form-group.prepend-icon .field-icon {
    position: absolute;
    left: 16px;
    top: 50%;
    transform: translateY(-50%);
    color: #94a3b8;
    z-index: 4;
    margin-bottom: 0;
    transition: color 0.3s ease;
}
.form-group.prepend-icon .field {
    padding-left: 46px !important;
    height: 52px !important;
    border-radius: 12px !important;
    border: 2px solid transparent !important;
    background-color: #f8fafc !important;
    font-weight: 500 !important;
    font-size: 0.95rem !important;
    color: #1e293b !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 2px 5px rgba(0,0,0,0.02) inset !important;
}
.form-group.prepend-icon .field:focus {
    background-color: #ffffff !important;
    border-color: #e11d48 !important;
    box-shadow: 0 0 0 4px rgba(225, 29, 72, 0.1), 0 2px 5px rgba(0,0,0,0.02) inset !important;
}
.form-group.prepend-icon:has(.field:focus) .field-icon {
    color: #e11d48;
}

/* Payment Methods Grid */
.payment-methods-grid {
    display: grid !important;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)) !important;
    gap: 1.25rem !important;
    margin-top: 1.5rem !important;
}
.payment-method-card .payment-method-icon {
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 1rem;
    transition: transform 0.3s ease;
}
.payment-method-card:hover .payment-method-icon {
    transform: scale(1.1);
}
.payment-method-card .gateway-name {
    font-size: 0.9rem !important;
    font-weight: 600 !important;
    color: #475569 !important;
    transition: color 0.3s ease;
}
.payment-method-card:has(input:checked) .gateway-name {
    color: #0f172a !important;
}

/* Gateway Badge (bKash, Nagad, etc) */
.gateway-badge {
    padding: 6px 14px;
    border-radius: 8px;
    font-size: 0.8rem;
    font-weight: 800;
    letter-spacing: 0.5px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}
.gateway-badge.bkash { background: linear-gradient(135deg, #e2136e, #be105b); color: #ffffff; }
.gateway-badge.nagad { background: linear-gradient(135deg, #f7941d, #d97d13); color: #ffffff; }
.gateway-badge.rocket { background: linear-gradient(135deg, #8c3494, #732a79); color: #ffffff; }

/* Right Column Summary */
.checkout-summary-card {
    background: linear-gradient(145deg, #0f172a, #1e293b) !important;
    border-radius: 24px !important;
    padding: 2.5rem !important;
    color: #ffffff !important;
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.15), inset 0 1px 0 rgba(255,255,255,0.1) !important;
    border: none !important;
    animation: slideUpFade 0.6s cubic-bezier(0.16, 1, 0.3, 1) 0.2s both;
}
.checkout-summary-card h3 {
    font-size: 1.35rem !important;
    font-weight: 700 !important;
    margin-bottom: 1.75rem !important;
    border-bottom: 1px solid rgba(255,255,255,0.1) !important;
    padding-bottom: 1rem !important;
    color: #ffffff !important;
}
.summary-row {
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    margin-bottom: 1.25rem !important;
}
.summary-row.total {
    border-top: 1px solid rgba(255,255,255,0.1) !important;
    padding-top: 1.5rem !important;
    margin-top: 1.5rem !important;
}
.summary-row.total span {
    font-weight: 600 !important;
    color: #94a3b8 !important;
    font-size: 1.1rem;
}
.summary-row.total strong {
    font-size: 2.2rem !important;
    color: #38bdf8 !important;
    font-weight: 800 !important;
    display: inline-flex;
    align-items: baseline;
    gap: 6px;
    text-shadow: 0 4px 15px rgba(56, 189, 248, 0.2);
}

/* Apply Credit Box inside Summary */
.apply-credit-container {
    background: rgba(255,255,255,0.03) !important;
    border-radius: 16px !important;
    padding: 1.5rem !important;
    margin-bottom: 1.75rem !important;
    border: 1px solid rgba(255,255,255,0.05) !important;
}
.apply-credit-container p {
    font-size: 0.9rem !important;
    margin-bottom: 1rem !important;
    color: #e2e8f0 !important;
}
.apply-credit-container label {
    display: flex !important;
    align-items: center !important;
    font-size: 0.85rem !important;
    color: #cbd5e1 !important;
    cursor: pointer !important;
    margin-bottom: 0.75rem !important;
}
.apply-credit-container label:last-child {
    margin-bottom: 0 !important;
}

/* Notes textarea */
textarea.field.form-control {
    background: #f8fafc !important;
    border: 2px solid transparent !important;
    border-radius: 16px !important;
    padding: 1.25rem !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 2px 5px rgba(0,0,0,0.02) inset !important;
}
textarea.field.form-control:focus {
    border-color: #e11d48 !important;
    background: #ffffff !important;
    box-shadow: 0 0 0 4px rgba(225, 29, 72, 0.1), 0 2px 5px rgba(0,0,0,0.02) inset !important;
}

/* Complete Button */
#btnCompleteOrder {
    width: 100%;
    height: 58px;
    border-radius: 16px;
    background: linear-gradient(135deg, #e11d48, #be123c) !important;
    border: none !important;
    font-weight: 700;
    font-size: 1.15rem;
    letter-spacing: 0.5px;
    color: #ffffff !important;
    box-shadow: 0 8px 20px rgba(225, 29, 72, 0.3) !important;
    transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1) !important;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    margin-top: 2rem;
    position: relative;
    z-index: 1;
    overflow: hidden;
}
#btnCompleteOrder::before {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: linear-gradient(135deg, #be123c, #9f1239);
    opacity: 0;
    transition: opacity 0.3s ease;
    z-index: -1;
}
#btnCompleteOrder:hover:not(:disabled) {
    transform: translateY(-3px) !important;
    box-shadow: 0 12px 25px rgba(225, 29, 72, 0.4) !important;
}
#btnCompleteOrder:hover:not(:disabled)::before {
    opacity: 1;
}

/* Custom Checkbox for TOS */
.checkout-summary-card .checkbox-inline {
    position: relative;
    padding-left: 32px !important;
    cursor: pointer;
    user-select: none;
    font-size: 0.85rem !important;
    color: #cbd5e1 !important;
    display: flex !important;
    align-items: flex-start !important;
    text-align: left !important;
    line-height: 1.5 !important;
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
    top: 2px;
    left: 0;
    height: 20px;
    width: 20px;
    background-color: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 6px;
    transition: all 0.2s ease;
}
.checkout-summary-card .checkbox-inline:hover .checkmark {
    background-color: rgba(255,255,255,0.1);
    border-color: rgba(255,255,255,0.3);
}
.checkout-summary-card .checkbox-inline input:checked ~ .checkmark {
    background-color: #38bdf8;
    border-color: #38bdf8;
    box-shadow: 0 2px 8px rgba(56,189,248,0.4);
}
.checkout-summary-card .checkbox-inline .checkmark:after {
    content: "";
    position: absolute;
    display: none;
    left: 6px;
    top: 2px;
    width: 6px;
    height: 11px;
    border: solid white;
    border-width: 0 2px 2px 0;
    transform: rotate(45deg);
}
.checkout-summary-card .checkbox-inline input:checked ~ .checkmark:after {
    display: block;
    animation: popIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.checkout-summary-card .checkbox-inline a {
    color: #38bdf8 !important;
    text-decoration: underline !important;
    margin-left: 4px;
}

/* Security notice */
.checkout-security-msg {
    margin-top: 1.5rem !important;
    font-size: 0.8rem !important;
    color: #94a3b8 !important;
    background: rgba(255, 255, 255, 0.03) !important;
    border: 1px solid rgba(255, 255, 255, 0.05) !important;
    border-radius: 12px !important;
    padding: 1.25rem !important;
    line-height: 1.5 !important;
    text-align: center;
}
.checkout-security-msg i {
    font-size: 1.2rem !important;
    color: #38bdf8 !important;
    margin-right: 6px !important;
    vertical-align: middle;
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
                                                <label class="radio-inline w-100" for="account{$account->id}">
                                                    <input id="account{$account->id}" class="account-select no-icheck{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled{/if}" type="radio" name="account_id" value="{$account->id}"{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled="disabled"{/if}{if $selectedAccountId == $account->id} checked="checked"{/if}>
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
                                                    <div class="select-indicator"><i class="ti ti-check"></i></div>
                                                </label>
                                            </div>
                                        </div>
                                    {/foreach}
                                    <div class="col-sm-12">
                                        <div class="account {if !$selectedAccountId || !is_numeric($selectedAccountId)} active{/if}">
                                            <label class="radio-inline w-100 m-0">
                                                <input class="account-select no-icheck" type="radio" name="account_id" value="new"{if !$selectedAccountId || !is_numeric($selectedAccountId)} checked="checked"{/if}{if $inExpressCheckout} disabled="disabled" class="disabled"{/if}>
                                                <strong>{lang key='orderForm.createAccount'}</strong>
                                                <div class="select-indicator"><i class="ti ti-check"></i></div>
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

                                    <div class="payment-methods no-icheck-grid">
                                        {foreach $gateways as $gateway}
                                            <label class="payment-method-card" for="gateway_{$gateway.sysname}">
                                                <input type="radio"
                                                       name="paymentmethod"
                                                       id="gateway_{$gateway.sysname}"
                                                       value="{$gateway.sysname}"
                                                       data-payment-type="{$gateway.payment_type}"
                                                       data-show-local="{$gateway.show_local_cards}"
                                                       data-remote-inputs="{$gateway.uses_remote_inputs}"
                                                       class="payment-methods no-icheck{if $gateway.type eq "CC"} is-credit-card{/if}"
                                                        {if $selectedgateway eq $gateway.sysname} checked{/if}
                                                />
                                                <div class="payment-method-icon">
                                                    <!-- Injected dynamically via JS or falls back to wallet icon -->
                                                    <i class="ti ti-wallet font-size-26 text-muted"></i>
                                                </div>
                                                <span class="gateway-name">{$gateway.name}</span>
                                                <div class="select-indicator"><i class="ti ti-circle-check"></i></div>
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
                                                        <button type="button" class="btn btn-secondary px-3" data-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />" style="border-top-left-radius:0;border-bottom-left-radius:0;">
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
                                                        <button type="button" class="btn btn-secondary px-3" data-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />" style="border-top-left-radius:0;border-bottom-left-radius:0;">
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
</script>
