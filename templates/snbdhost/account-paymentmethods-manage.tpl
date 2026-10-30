<script src="{$BASE_PATH_JS}/StatesDropdown.js"></script>

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{lang key='paymentMethods.title'}</p>
        <h1 class="snbd-page-title">{if $editMode}{lang key='paymentMethodsManage.editPaymentMethod'}{else}{lang key='paymentMethodsManage.addPaymentMethod'}{/if}</h1>
        <p class="snbd-page-sub">{lang key='paymentMethodsManage.intro'}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="{routePath('account-paymentmethods')}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='paymentMethods.title'}
        </a>
    </div>
</div>

<section class="snbd-card" aria-labelledby="snbd-paymethod-form-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-paymethod-form-title">
            <i class="ti ti-credit-card" aria-hidden="true"></i>
            {if $editMode}{lang key='paymentMethodsManage.editPaymentMethod'}{else}{lang key='paymentMethodsManage.addPaymentMethod'}{/if}
        </h2>
    </div>

    <form id="frmManagePaymentMethod" class="frm-credit-card-input snbd-form" role="form" method="post" action="{if $editMode}{routePath('account-paymentmethods-save', $payMethod->id)}{else}{routePath('account-paymentmethods-add')}{/if}">
        <div class="snbd-card__body">
            <div class="snbd-alert snbd-alert--warn gateway-errors assisted-cc-input-feedback w-hidden" role="alert">
                <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethodsManage.invalidCardDetails'}</p></div>
            </div>

            <fieldset class="mb-4">
                <legend class="snbd-label">{lang key='paymentMethods.type'}</legend>
                <div class="snbd-choice">
                    {if $enabledTypes['tokenGateways']}
                        {foreach $tokenGateways as $tokenGateway}
                        <label class="snbd-choice__option">
                            <input type="radio" class="icheck-button" name="type" value="token_{$tokenGateway}" data-tokenised="true" data-gateway="{$tokenGateway}"{if $editMode && $payMethod->isCreditCard() && $payMethod->gateway_name == $tokenGateway} checked{/if}{if $editMode} disabled{/if}>
                            <span>{$gatewayDisplayNames[$tokenGateway]}</span>
                        </label>
                        {/foreach}
                    {/if}
                    {if $enabledTypes['localCreditCard']}
                        <label class="snbd-choice__option">
                            <input type="radio" class="icheck-button" name="type" value="localcard"{if ($editMode && $payMethod->isCreditCard() && !$payMethod->isTokenised()) || (!$editMode && $paymentMethodType != 'bankacct')} checked{/if}{if $editMode} disabled{/if}>
                            <span>{lang key='paymentMethodsManage.creditCard'}</span>
                        </label>
                    {/if}
                    {if $enabledTypes['bankAccount']}
                        <label class="snbd-choice__option">
                            <input type="radio" class="icheck-button" name="type" value="bankacct"{if ($editMode && !$payMethod->isCreditCard()) || ($paymentMethodType == 'bankacct')} checked{/if}{if $editMode} disabled{/if}>
                            <span>{lang key='paymentMethodsManage.bankAccount'}</span>
                        </label>
                    {/if}
                </div>
            </fieldset>

            <div class="fieldgroup-auxfields{if $remoteUpdate} w-hidden{/if}">
                <label class="snbd-label" for="inputDescription">{lang key='paymentMethods.description'}</label>
                <div class="input-group">
                    <input type="text" class="snbd-input form-control" id="inputDescription" name="description" autocomplete="off" value="{$payMethod->description}">
                    <span class="input-group-text snbd-muted">{lang key='paymentMethodsManage.optional'}</span>
                </div>
            </div>

            <div class="fieldgroup-loading w-hidden">
                <p class="snbd-caption mb-0"><i class="ti ti-refresh" aria-hidden="true"></i> {lang key='pleasewait'}</p>
            </div>

            <div id="paymentGatewayInput"></div>

            <div class="fieldgroup-creditcard{if ($editMode && !$payMethod->isCreditCard()) || $paymentMethodType == 'bankacct' || $remoteUpdate} w-hidden{/if}">
                <div class="cc-details">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="snbd-label" for="inputCardNumber">{lang key='creditcardcardnumber'}</label>
                            <input type="tel" class="snbd-input form-control cc-number-field {$creditCard->getCardType()|strtolower}" id="inputCardNumber" name="ccnumber" autocomplete="cc-number" value="{$creditCard->getMaskedCardNumber()}"{if !$creditCardNumberFieldEnabled} disabled{/if} aria-describedby="cc-type" data-message-unsupported="{lang key='paymentMethodsManage.unsupportedCardType'}" data-message-invalid="{lang key='paymentMethodsManage.cardNumberNotValid'}" data-supported-cards="{$supportedCardTypes}">
                            <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethodsManage.cardNumberNotValid'}</span>
                        </div>
                        <div class="col-md-4">
                            <span class="snbd-label d-block" id="cc-type">{lang key='creditcardcardtype'}</span>
                            <span class="snbd-chip snbd-chip--neutral">{$creditCard->getCardType()}</span>
                        </div>

                        {if $startDateEnabled}
                        <div class="col-md-4">
                            <label class="snbd-label" for="inputCardStart">{lang key='creditcardcardstart'}</label>
                            <input type="tel" class="snbd-input form-control" id="inputCardStart" name="ccstart" autocomplete="off" value="{if $creditCard->getStartDate()}{$creditCard->getStartDate()->format('m / y')}{/if}">
                        </div>
                        {/if}

                        <div class="col-md-4">
                            <label class="snbd-label" for="inputCardExpiry">{lang key='creditcardcardexpires'}</label>
                            <input type="tel" class="snbd-input form-control" id="inputCardExpiry" name="ccexpiry" autocomplete="cc-exp" value="{if $creditCard->getExpiryDate()}{$creditCard->getExpiryDate()->format('m / y')}{/if}"{if !$creditCardExpiryFieldEnabled} disabled{/if}>
                            <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethodsManage.expiryDateNotValid'}</span>
                        </div>

                        {if $issueNumberEnabled}
                        <div class="col-md-4">
                            <label class="snbd-label" for="inputCardIssue">{lang key='creditcardcardissuenum'}</label>
                            <input type="tel" class="snbd-input form-control" id="inputCardIssue" name="ccissuenum" autocomplete="off" value="{$creditCard->getIssueNumber()}">
                        </div>
                        {/if}

                        {if $creditCardCvcFieldEnabled}
                        <div class="col-md-4">
                            <label class="snbd-label" for="inputCardCvc">{lang key='creditcardcvvnumber'}</label>
                            <input type="tel" class="snbd-input form-control" id="inputCardCvc" name="cardcvv" autocomplete="off">
                            <button id="cvvWhereLink" type="button" class="snbd-btn snbd-btn--ghost snbd-btn--sm" data-bs-toggle="popover" data-bs-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' alt=''>">
                                {lang key='creditcardcvvwhere'}
                            </button>
                            <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethodsManage.cvcNumberNotValid'}</span>
                        </div>
                        {/if}
                    </div>
                </div>
            </div>

            <div class="fieldgroup-bankaccount{if $remoteUpdate || ($editMode && $payMethod->isCreditCard()) || ($paymentMethodType != 'bankacct' && !$editMode)} w-hidden{/if}">
                <fieldset class="mb-3">
                    <legend class="snbd-label">{lang key='paymentMethodsManage.accountType'}</legend>
                    <div class="snbd-choice">
                        <label class="snbd-choice__option">
                            <input type="radio" class="icheck-button" name="bankaccttype" id="inputBankAcctType" value="Checking"{if !$bankAccount->getAccountType() || $bankAccount->getAccountType() == 'Checking'} checked{/if}>
                            <span>{lang key='paymentMethodsManage.checking'}</span>
                        </label>
                        <label class="snbd-choice__option">
                            <input type="radio" class="icheck-button" name="bankaccttype" value="Savings"{if $bankAccount->getAccountType() == 'Savings'} checked{/if}>
                            <span>{lang key='paymentMethodsManage.savings'}</span>
                        </label>
                    </div>
                </fieldset>

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputBankAcctHolderName">{lang key='paymentMethodsManage.accountHolderName'}</label>
                        <input type="tel" class="snbd-input form-control" id="inputBankAcctHolderName" name="bankacctholdername" autocomplete="off" value="{$bankAccount->getAccountHolderName()}">
                        <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethods.fieldRequired'}</span>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputBankName">{lang key='paymentMethodsManage.bankName'}</label>
                        <input type="tel" class="snbd-input form-control" id="inputBankName" name="bankname" autocomplete="off" value="{$bankAccount->getBankName()}">
                        <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethods.fieldRequired'}</span>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputBankRoutingNum">{lang key='paymentMethodsManage.sortCodeRoutingNumber'}</label>
                        <input type="tel" class="snbd-input form-control" id="inputBankRoutingNum" name="bankroutingnum" autocomplete="off" value="{$bankAccount->getRoutingNumber()}">
                        <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethodsManage.routingNumberNotValid'}</span>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputBankAcctNum">{lang key='paymentMethodsManage.accountNumber'}</label>
                        <input type="tel" class="snbd-input form-control" id="inputBankAcctNum" name="bankacctnum" autocomplete="off" value="{$bankAccount->getAccountNumber()}">
                        <span class="field-error-msg snbd-hint snbd-hint--bad">{lang key='paymentMethodsManage.accountNumberNotValid'}</span>
                    </div>
                </div>
            </div>

            <div class="fieldgroup-auxfields{if $remoteUpdate} w-hidden{/if}">
                <span class="snbd-label d-block">{lang key='billingAddress'}</span>
                <div id="billingContactsContainer">
                    <div id="innerBillingContactsContainer">
                        <label class="snbd-choice__option billing-contact-0">
                            <input type="radio" class="icheck-button" name="billingcontact" value="0"{if $payMethod->contactType == 'Client' || ($payMethod->contactType === null && $client->billingContactId === 0)} checked{/if}>
                            <span>
                                <strong class="name">{$client->fullName}</strong>
                                <span class="address1">{$client->address1}</span>,
                                {if $client->address2}<span class="address2">{$client->address2}</span>,{/if}
                                <span class="city">{$client->city}</span>,
                                <span class="state">{$client->state}</span>,
                                <span class="postcode">{$client->postcode}</span>
                                <span class="country">{$client->country}</span>
                            </span>
                        </label>
                        {foreach $client->contacts()->orderBy('firstname', 'asc')->orderBy('lastname', 'asc')->get() as $contact}
                        <label class="snbd-choice__option billing-contact-{$contact->id}">
                            <input type="radio" class="icheck-button" name="billingcontact" value="{$contact->id}"{if $payMethod->contactType == 'Contact' && $contact->id == $payMethod->getContactId()} checked{elseif $payMethod->contactType === null && $client->billingContactId > 0}{if $contact->id == $client->billingContactId || $contact->id == $selectedContactId} checked{/if}{/if}>
                            <span>
                                <strong class="name">{$contact->fullName}</strong>
                                <span class="address1">{$contact->address1}</span>,
                                {if $contact->address2}<span class="address2">{$contact->address2}</span>,{/if}
                                <span class="city">{$contact->city}</span>,
                                <span class="state">{$contact->state}</span>,
                                <span class="postcode">{$contact->postcode}</span>
                                <span class="country">{$contact->country}</span>
                            </span>
                        </label>
                        {/foreach}
                    </div>
                </div>
                <button type="button" class="snbd-btn snbd-btn--secondary snbd-btn--sm mt-2" data-bs-toggle="modal" data-bs-target="#modalBillingAddress">
                    <i class="ti ti-plus" aria-hidden="true"></i>{lang key='paymentMethodsManage.addNewAddress'}
                </button>
            </div>

            <input type="hidden" name="billing_name" id="inputBillingName" value="">
            <input type="hidden" name="billing_address_1" id="inputBillingAddress1" value="">
            <input type="hidden" name="billing_address_2" id="inputBillingAddress2" value="">
            <input type="hidden" name="billing_city" id="inputBillingCity" value="">
            <input type="hidden" name="billing_state" id="inputBillingState" value="">
            <input type="hidden" name="billing_postcode" id="inputBillingPostcode" value="">
            <input type="hidden" name="billing_country" id="inputBillingCountry" value="">
        </div>

        <div class="snbd-card__foot submit-container">
            <button type="submit" name="submit" id="btnSubmit" class="snbd-btn snbd-btn--primary">{lang key='clientareasavechanges'}</button>
            <a href="{routePath('account-paymentmethods')}" class="snbd-btn snbd-btn--ghost">{lang key='cancel'}</a>
        </div>
    </form>

    <div class="fieldgroup-remoteinput{if ($editMode && !$remoteUpdate) || !$editMode} w-hidden{/if}">
        {if $remoteUpdate}
            <div id="tokenGatewayRemoteUpdateOutput" class="text-center">{$remoteUpdate}</div>
        {else}
            <div id="tokenGatewayRemoteInputOutput" class="text-center" align="center"></div>
            <div class="text-center">
                <iframe name="ccframe" class="auth3d-area" width="90%" height="600" scrolling="auto" src="about:blank" title="{lang key='paymentMethodsManage.addPaymentMethod'}"></iframe>
            </div>
        {/if}
    </div>
</section>

<div class="modal fade" id="modalBillingAddress" tabindex="-1" role="dialog" aria-labelledby="modalBillingAddressLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <form id="billingContactForm" action="{routePath('account-paymentmethods-billing-contacts-create')}" data-role="json-form">
                <input type="hidden" name="token" value="{$csrfToken}" />
                <div class="modal-header">
                    <h2 class="modal-title" id="modalBillingAddressLabel">{lang key='paymentMethodsManage.addNewBillingAddress'}</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{lang key='paymentMethods.close'}"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputFirstName">{lang key='clientareafirstname'}</label>
                            <input type="text" name="firstname" id="inputFirstName" value="{$contactfirstname}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputLastName">{lang key='clientarealastname'}</label>
                            <input type="text" name="lastname" id="inputLastName" value="{$contactlastname}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputCompanyName">{lang key='clientareacompanyname'}</label>
                            <input type="text" name="companyname" id="inputCompanyName" value="{$contactcompanyname}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputPhone">{lang key='clientareaphonenumber'}</label>
                            <input type="tel" name="phonenumber" id="inputPhone" value="{$contactphonenumber}" class="snbd-input form-control">

                            {if $showTaxIdField}
                            <label class="snbd-label" for="inputTaxId">{lang key=$taxIdLabel}</label>
                            <input type="text" name="tax_id" id="inputTaxId" class="snbd-input form-control" value="{$contactTaxId}">
                            {/if}
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputAddress1">{lang key='clientareaaddress1'}</label>
                            <input type="text" name="address1" id="inputAddress1" value="{$contactaddress1}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputAddress2">{lang key='clientareaaddress2'}</label>
                            <input type="text" name="address2" id="inputAddress2" value="{$contactaddress2}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputCity">{lang key='clientareacity'}</label>
                            <input type="text" name="city" id="inputCity" value="{$contactcity}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputState">{lang key='clientareastate'}</label>
                            <input type="text" name="state" id="inputState" value="{$contactstate}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputPostcode">{lang key='clientareapostcode'}</label>
                            <input type="text" name="postcode" id="inputPostcode" value="{$contactpostcode}" class="snbd-input form-control">

                            <label class="snbd-label" for="inputCountry">{lang key='clientareacountry'}</label>
                            <select class="snbd-input form-select" name="country" id="inputCountry">
                                {foreach $countries as $countryCode => $countryName}
                                <option value="{$countryCode}"{if ($countryCode == $clientCountry)} selected="selected"{/if}>{$countryName}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="snbd-btn snbd-btn--ghost" data-bs-dismiss="modal">{lang key='paymentMethods.close'}</button>
                    <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='paymentMethods.saveChanges'}</button>
                </div>
            </form>
        </div>
    </div>
</div>

<input type="hidden" name="paymentmethod" id="inputPaymentMethod" value="">
<div id="tokenGatewayAssistedOutput"></div>

<script src="{$BASE_PATH_JS}/jquery.payment.js"></script>
<script>
    var paymentInitSingleton = new Map;
    jQuery(document).ready(function() {
        var ccNumberFieldEnabled = '{$creditCardNumberFieldEnabled}',
            ccExpiryFieldEnabled = '{$creditCardExpiryFieldEnabled}',
            ccCvcFieldEnabled = '{$creditCardCvcFieldEnabled}',
            ccForm = jQuery('.frm-credit-card-input');

        ccForm.find('#inputCardNumber').payment('formatCardNumber');
        ccForm.find('#inputCardStart').payment('formatCardExpiry');
        ccForm.find('#inputCardExpiry').payment('formatCardExpiry');
        ccForm.find('#inputCardCvc').payment('formatCardCVC');
        ccForm.find('#inputCardIssue').payment('restrictNumeric');
        ccForm.find('#inputBankRoutingNum').payment('restrictNumeric');
        ccForm.find('#inputBankAcctNum').payment('restrictNumeric');

        var reloadBillingContacts = function (selectContactId) {
            WHMCS.http.jqClient.get({
                url: "{routePath('account-paymentmethods-billing-contacts', $payMethod->id)}",
                data: {
                    'contact_id': selectContactId ? selectContactId : 0
                },
                success: function(response) {
                    jQuery('#billingContactsContainer').html(response);
                }
            });
        };
        var whmcsPaymentModuleMetadata = {
            _source: 'payment-method-add',
        };

        jQuery(document).on('click', '.frm-credit-card-input button[type="submit"]', function(e) {
            ccForm.find('.field-error-msg').hide();

            var checkedInput = jQuery('input[name="type"]:checked', ccForm);

            if (checkedInput.val() === 'bankacct') {
                if (!jQuery('#inputBankAcctHolderName').val()) {
                    jQuery('#inputBankAcctHolderName').showInputError();
                    e.preventDefault();
                }
                if (!jQuery('#inputBankName').val()) {
                    jQuery('#inputBankName').showInputError();
                    e.preventDefault();
                }
                if (!jQuery('#inputBankRoutingNum').val()) {
                    jQuery('#inputBankRoutingNum').showInputError();
                    e.preventDefault();
                }
                if (!jQuery('#inputBankAcctNum').val()) {
                    jQuery('#inputBankAcctNum').showInputError();
                    e.preventDefault();
                }
            } else if (checkedInput.val() === 'localcard') {
                var cardType = $.payment.cardType(ccForm.find('#inputCardNumber').val()),
                    cardNumber = ccForm.find('#inputCardNumber');
                if (
                    ccNumberFieldEnabled
                    && (!$.payment.validateCardNumber(cardNumber.val()) || cardNumber.hasClass('unsupported'))
                ) {
                    var error = cardNumber.data('message-invalid');
                    if (cardNumber.hasClass('unsupported')) {
                        error = cardNumber.data('message-unsupported');
                    }
                    ccForm.find('#inputCardNumber').setInputError(error).showInputError();
                    e.preventDefault();
                }
                if (
                    ccExpiryFieldEnabled
                    && !$.payment.validateCardExpiry(ccForm.find('#inputCardExpiry').payment('cardExpiryVal'))
                ) {
                    ccForm.find('#inputCardExpiry').showInputError();
                    e.preventDefault();
                }
                if (
                    ccCvcFieldEnabled
                    && !$.payment.validateCardCVC(ccForm.find('#inputCardCvc').val(), cardType)
                ) {
                    ccForm.find('#inputCardCvc').showInputError();
                    e.preventDefault();
                }
            }
            WHMCS.payment.event.addPayMethodFormSubmit(
                {literal}{...whmcsPaymentModuleMetadata, ...{event: e}}{/literal},
                WHMCS.payment.event.previouslySelected?.module,
                jQuery(this)
            );
        });

        jQuery('input[name="type"]').on('ifChecked', function(e) {
            var element = jQuery(this);
            var module = element.data('gateway');
            WHMCS.payment.event.gatewayUnselected(whmcsPaymentModuleMetadata);
            WHMCS.payment.display.errorClear();
            jQuery('.fieldgroup-creditcard').hide();
            jQuery('.fieldgroup-bankaccount').hide();
            jQuery('.fieldgroup-remoteinput').hide();
            jQuery('.fieldgroup-auxfields').hide();
            jQuery('.fieldgroup-loading').show();
            jQuery('#tokenGatewayAssistedOutput').html('');
            if (element.data('tokenised') === true) {
                jQuery('#inputPaymentMethod').val(module);
                WHMCS.http.jqClient.jsonPost({
                    url: "{routePath('account-paymentmethods-inittoken')}",
                    data: 'gateway=' + module,
                    success: function(response) {
                        jQuery('.fieldgroup-loading').hide();
                        if (response.remoteInputForm) {
                            jQuery('#tokenGatewayRemoteInputOutput').html(response.remoteInputForm);
                            jQuery('#tokenGatewayRemoteInputOutput').find('form:first').attr('target', 'ccframe');
                            setTimeout("autoSubmitFormByContainer('tokenGatewayRemoteInputOutput')", 1000);
                            jQuery('.fieldgroup-remoteinput').show();
                        } else if (response.assistedOutput) {
                            jQuery('.fieldgroup-creditcard').show('fast', function () {
                                jQuery('#tokenGatewayAssistedOutput').html(response.assistedOutput);
                                if (!paymentInitSingleton.has(module)) {
                                    WHMCS.payment.event.gatewayInit(whmcsPaymentModuleMetadata, module, element);
                                    WHMCS.payment.event.gatewayOptionInit(whmcsPaymentModuleMetadata, module, element);
                                    paymentInitSingleton.set(module, true);
                                }
                                WHMCS.payment.event.gatewaySelected(whmcsPaymentModuleMetadata, module, element);
                            });
                            jQuery('.fieldgroup-auxfields').show();
                        } else if (response.gatewayType === 'Bank') {
                            jQuery('.fieldgroup-loading').hide();
                            jQuery('.fieldgroup-bankaccount').show();
                            jQuery('.fieldgroup-auxfields').show();
                        } else {
                            jQuery('.fieldgroup-creditcard').show();
                            jQuery('.fieldgroup-auxfields').show();
                        }
                    },
                });
            } else if (element.val() === 'bankacct') {
                jQuery('.fieldgroup-loading').hide();
                jQuery('.fieldgroup-bankaccount').show();
                jQuery('.fieldgroup-auxfields').show();
            } else {
                jQuery('.fieldgroup-loading').hide();
                jQuery('.fieldgroup-creditcard').show();
                jQuery('.fieldgroup-auxfields').show();
            }
        });
        jQuery('input[name="billingcontact"]').on('ifChecked', function(e) {
            var contact = jQuery('.billing-contact-' + jQuery(this).val());
            jQuery('#inputBillingName').val(contact.find('.name').html());
            jQuery('#inputBillingAddress1').val(contact.find('.address1').html());
            jQuery('#inputBillingAddress2').val(contact.find('.address2').html());
            jQuery('#inputBillingCity').val(contact.find('.city').html());
            jQuery('#inputBillingState').val(contact.find('.state').html());
            jQuery('#inputBillingPostcode').val(contact.find('.postcode').html());
            jQuery('#inputBillingCountry').val(contact.find('.country').html());
        });

        jQuery('#innerBillingContactsContainer').find('.icheck-button').iCheck({
            inheritID: true,
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%'
        });

        if (jQuery('input[name="type"]:checked', ccForm).length === 0) {
            jQuery('input[name="type"]', ccForm).first().parents('label').trigger('click');
        }

        jQuery('#billingContactForm')
            .data('on-success', function(data) {
                var modal = bootstrap.Modal.getInstance(document.getElementById('modalBillingAddress'));
                if (modal) { modal.hide(); }
                reloadBillingContacts(data.id);
            });
    });
</script>
