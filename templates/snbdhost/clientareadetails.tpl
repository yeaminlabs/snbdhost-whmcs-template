{if $successful}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='changessavedsuccessfully'}</p></div>
</div>
{/if}

{if $errormessage}
<div class="snbd-alert snbd-alert--bad" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">{$errormessage}</div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='clientareanavdetails'}</h1>
        <p class="snbd-page-sub">Keep your contact and billing information accurate so invoices, renewals and support replies reach you.</p>
    </div>
</div>

{if in_array('state', $optionalFields)}
<script>var stateNotRequired = true;</script>
{/if}
<script src="{$BASE_PATH_JS|default:'/assets/js'}/StatesDropdown.js"></script>

<form method="post" action="?action=details" class="snbd-form" role="form">
    <div class="row g-4">
        <div class="col-lg-6">
            <section class="snbd-card h-100" aria-labelledby="snbd-details-personal">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-details-personal"><i class="ti ti-user" aria-hidden="true"></i>Personal</h2>
                </div>
                <div class="snbd-card__body">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputFirstName">{lang key='clientareafirstname'}</label>
                            <input type="text" name="firstname" id="inputFirstName" value="{$clientfirstname}"{if in_array('firstname', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="given-name">
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputLastName">{lang key='clientarealastname'}</label>
                            <input type="text" name="lastname" id="inputLastName" value="{$clientlastname}"{if in_array('lastname', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="family-name">
                        </div>
                        <div class="col-12">
                            <label class="snbd-label" for="inputCompanyName">{lang key='clientareacompanyname'}</label>
                            <input type="text" name="companyname" id="inputCompanyName" value="{$clientcompanyname}"{if in_array('companyname', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="organization">
                        </div>
                        <div class="col-sm-7">
                            <label class="snbd-label" for="inputEmail">{lang key='clientareaemail'}</label>
                            <input type="email" name="email" id="inputEmail" value="{$clientemail}"{if in_array('email', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="email">
                        </div>
                        <div class="col-sm-5">
                            <label class="snbd-label" for="inputPhone">{lang key='clientareaphonenumber'}</label>
                            <input type="tel" name="phonenumber" id="inputPhone" value="{$clientphonenumber}"{if in_array('phonenumber', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="tel">
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <div class="col-lg-6">
            <section class="snbd-card h-100" aria-labelledby="snbd-details-address">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-details-address"><i class="ti ti-map-pin" aria-hidden="true"></i>Billing address</h2>
                </div>
                <div class="snbd-card__body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="snbd-label" for="inputAddress1">{lang key='clientareaaddress1'}</label>
                            <input type="text" name="address1" id="inputAddress1" value="{$clientaddress1}"{if in_array('address1', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="address-line1">
                        </div>
                        <div class="col-12">
                            <label class="snbd-label" for="inputAddress2">{lang key='clientareaaddress2'}</label>
                            <input type="text" name="address2" id="inputAddress2" value="{$clientaddress2}"{if in_array('address2', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="address-line2">
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputCity">{lang key='clientareacity'}</label>
                            <input type="text" name="city" id="inputCity" value="{$clientcity}"{if in_array('city', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="address-level2">
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputState">{lang key='clientareastate'}</label>
                            <input type="text" name="state" id="inputState" value="{$clientstate}"{if in_array('state', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="address-level1">
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputPostcode">{lang key='clientareapostcode'}</label>
                            <input type="text" name="postcode" id="inputPostcode" value="{$clientpostcode}"{if in_array('postcode', $uneditablefields)} disabled="disabled"{/if} class="form-control" autocomplete="postal-code">
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="country">{lang key='clientareacountry'}</label>
                            {$clientcountriesdropdown}
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <div class="col-lg-6">
            <section class="snbd-card h-100" aria-labelledby="snbd-details-preferences">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-details-preferences"><i class="ti ti-settings" aria-hidden="true"></i>Preferences</h2>
                </div>
                <div class="snbd-card__body">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputPaymentMethod">{lang key='paymentmethod'}</label>
                            <select name="paymentmethod" id="inputPaymentMethod" class="form-select">
                                <option value="none">{lang key='paymentmethoddefault'}</option>
                                {foreach $paymentmethods as $method}
                                <option value="{$method.sysname}"{if $method.sysname eq $defaultpaymentmethod} selected="selected"{/if}>{$method.name}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputBillingContact">{lang key='defaultbillingcontact'}</label>
                            <select name="billingcid" id="inputBillingContact" class="form-select">
                                <option value="0">{lang key='usedefaultcontact'}</option>
                                {foreach $contacts as $contact}
                                <option value="{$contact.id}"{if $contact.id eq $billingcid} selected="selected"{/if}>{$contact.name}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputAccountLanguage">{lang key='clientarealanguage'}</label>
                            <select name="accountLanguage" id="inputAccountLanguage" class="form-select"{if in_array('language', $uneditablefields)} disabled="disabled"{/if}>
                                <option value="">{lang key='default'}</option>
                                {foreach $languages as $language}
                                <option value="{$language}"{if $language eq $clientLanguage} selected="selected"{/if}>{$language|ucfirst}</option>
                                {/foreach}
                            </select>
                        </div>
                        {if $showTaxIdField}
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputTaxId">{lang key=$taxIdLabel}</label>
                            <input type="text" name="tax_id" id="inputTaxId" class="form-control" value="{$clientTaxId}"{if in_array('tax_id', $uneditablefields)} disabled="disabled"{/if}>
                        </div>
                        {/if}
                    </div>

                    {if $customfields}
                    <div class="snbd-divider"></div>
                    <div class="row g-3">
                        {foreach $customfields as $customfield}
                        <div class="col-sm-6">
                            <label class="snbd-label" for="customfield{$customfield.id}">{$customfield.name}</label>
                            {$customfield.input}
                            {if $customfield.description}<p class="snbd-hint">{$customfield.description}</p>{/if}
                        </div>
                        {/foreach}
                    </div>
                    {/if}
                </div>
            </section>
        </div>

        <div class="col-lg-6">
            <section class="snbd-card h-100" aria-labelledby="snbd-details-emails">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-details-emails"><i class="ti ti-mail" aria-hidden="true"></i>Email preferences</h2>
                </div>
                <div class="snbd-card__body">
                    {if $emailPreferencesEnabled}
                        {foreach $emailPreferences as $emailType => $value}
                        <div class="form-check mb-2">
                            <input type="hidden" name="email_preferences[{$emailType}]" value="0">
                            <input type="checkbox" class="form-check-input" name="email_preferences[{$emailType}]" id="{$emailType}Emails" value="1"{if $value} checked="checked"{/if}>
                            <label class="form-check-label" for="{$emailType}Emails">{lang key="emailPreferences."|cat:$emailType}</label>
                        </div>
                        {/foreach}
                    {else}
                        <p class="snbd-caption mb-0">No optional email notifications are available on this account.</p>
                    {/if}

                    {if $showMarketingEmailOptIn}
                    <div class="snbd-divider"></div>
                    <div class="form-check">
                        <input type="checkbox" name="marketingoptin" id="inputMarketingOptIn" value="1"{if $marketingEmailOptIn} checked{/if} class="form-check-input">
                        <label class="form-check-label" for="inputMarketingOptIn">{lang key='emailMarketing.joinOurMailingList'}</label>
                    </div>
                    <p class="snbd-hint">{$marketingEmailOptInMessage}</p>
                    {/if}
                </div>
            </section>
        </div>

        {if !empty($accountDetailsExtraFields)}
        <div class="col-12">
            <section class="snbd-card" aria-labelledby="snbd-details-extra">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-details-extra"><i class="ti ti-forms" aria-hidden="true"></i>{lang key='orderForm.additionalInformation'}</h2>
                </div>
                <div class="snbd-card__body">
                    <div class="row g-3">
                        {foreach $accountDetailsExtraFields as $field}
                        <div class="col-sm-6">
                            <label class="snbd-label" for="{$field.name}">{$field.label|escape}{if $field.required} <span class="text-danger" aria-hidden="true">*</span>{/if}</label>
                            {$field.input}
                        </div>
                        {/foreach}
                    </div>
                </div>
            </section>
        </div>
        {/if}
    </div>

    <div class="snbd-cluster mt-4">
        <button type="submit" name="save" class="snbd-btn snbd-btn--primary"><i class="ti ti-device-floppy" aria-hidden="true"></i>{lang key='clientareasavechanges'}</button>
        <button type="reset" class="snbd-btn snbd-btn--secondary">{lang key='cancel'}</button>
    </div>
</form>
