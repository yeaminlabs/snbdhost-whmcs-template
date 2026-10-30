<div class="snbd-auth snbd-auth--wide">
    <aside class="snbd-auth__brand" aria-label="About SNBD Host">
        <div class="snbd-auth__grid" aria-hidden="true"></div>
        <a href="https://snbdhost.com" class="snbd-auth__logo">
            <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}">
        </a>
        <div class="snbd-auth__pitch">
            <span class="snbd-auth__badge"><i class="ti ti-shield-check" aria-hidden="true"></i>Trusted by 10,000+ clients</span>
            <h1>Start hosting in<br><span>a few minutes.</span></h1>
            <p>Create one account for hosting, domains, billing and support — no setup fees, no surprises.</p>
            <ul class="snbd-auth__features">
                <li><i class="ti ti-server-2" aria-hidden="true"></i>NVMe storage on AMD EPYC servers</li>
                <li><i class="ti ti-world" aria-hidden="true"></i>Domain registration with full DNS control</li>
                <li><i class="ti ti-headset" aria-hidden="true"></i>24/7 support from real engineers</li>
            </ul>
        </div>
        <dl class="snbd-auth__stats">
            <div><dt>10K+</dt><dd>Clients</dd></div>
            <div><dt>99.9%</dt><dd>Uptime SLA</dd></div>
            <div><dt>24/7</dt><dd>Support</dd></div>
        </dl>
    </aside>

    <main class="snbd-auth__main">
        <div class="snbd-auth__card snbd-auth__card--wide">
            <nav class="snbd-auth__tabs" aria-label="Account access">
                <a href="{$WEB_ROOT}/login.php" class="snbd-auth__tab">Sign in</a>
                <a href="{$WEB_ROOT}/register.php" class="snbd-auth__tab active" aria-current="page">Create account</a>
            </nav>

            <h2 class="snbd-auth__title">Create your account</h2>
            <p class="snbd-auth__sub">It takes less than two minutes.</p>

            {if $errormessage}
            <div class="snbd-alert snbd-alert--bad" role="alert" id="regErrAlert">
                <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{$errormessage}</p></div>
            </div>
            {/if}

            {if $googleClientId}
            <div class="snbd-auth__google">
                <div id="g_id_onload"
                     data-client_id="{$googleClientId}"
                     data-context="signup"
                     data-ux_mode="popup"
                     data-callback="onGoogleSignIn"
                     data-auto_prompt="false"></div>
                <div class="g_id_signin"
                     data-type="standard"
                     data-shape="rectangular"
                     data-theme="outline"
                     data-text="signup_with"
                     data-size="large"
                     data-logo_alignment="center"></div>
                <div id="snbdGoogleSignInLoading" class="snbd-auth__google-status" hidden>
                    <i class="ti ti-loader-2 snbd-spin" aria-hidden="true"></i> Authenticating securely…
                </div>
                <div id="snbdGoogleSignInError" class="snbd-alert snbd-alert--bad mt-3" hidden></div>
                <div class="snbd-auth__or"><span>or register with email</span></div>
            </div>
            {/if}

            <form method="post" action="{$WEB_ROOT}/register.php" id="frmRegistration" class="snbd-form needs-validation" role="form">
                <input type="hidden" name="register" value="true">
                <input type="hidden" name="token" value="{$token}">

                <h3 class="snbd-auth__section">Personal information</h3>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputFirstName">First name <span aria-hidden="true">*</span></label>
                        <input type="text" name="firstname" class="form-control" id="inputFirstName" placeholder="First name" value="{$clientfirstname}" autocomplete="given-name" required>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputLastName">Last name <span aria-hidden="true">*</span></label>
                        <input type="text" name="lastname" class="form-control" id="inputLastName" placeholder="Last name" value="{$clientlastname}" autocomplete="family-name" required>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputEmail">Email address <span aria-hidden="true">*</span></label>
                        <input type="email" name="email" class="form-control" id="inputEmail" placeholder="you@example.com" value="{$clientemail}" autocomplete="email" required>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputPhone">Phone number <span aria-hidden="true">*</span></label>
                        <input type="tel" name="phonenumber" class="form-control" id="inputPhone" placeholder="1XXX-XXXXXX" value="{$clientphonenumber}" autocomplete="tel" required>
                    </div>
                </div>

                <h3 class="snbd-auth__section">Billing address</h3>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputCompanyName">Company <span class="snbd-muted fw-normal">(optional)</span></label>
                        <input type="text" name="companyname" class="form-control" id="inputCompanyName" placeholder="Company name" value="{$clientcompanyname}" autocomplete="organization">
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputAddress1">Street address <span aria-hidden="true">*</span></label>
                        <input type="text" name="address1" class="form-control" id="inputAddress1" placeholder="House, road, area" value="{$clientaddress1}" autocomplete="address-line1" required>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputAddress2">Address line 2 <span class="snbd-muted fw-normal">(optional)</span></label>
                        <input type="text" name="address2" class="form-control" id="inputAddress2" placeholder="Apartment, suite, etc." value="{$clientaddress2}" autocomplete="address-line2">
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputCity">City <span aria-hidden="true">*</span></label>
                        <input type="text" name="city" class="form-control" id="inputCity" placeholder="City" value="{$clientcity}" autocomplete="address-level2" required>
                    </div>
                    <div class="col-md-5">
                        <label class="snbd-label" for="inputCountry">Country <span aria-hidden="true">*</span></label>
                        <select name="country" class="form-select" id="inputCountry" autocomplete="country">
                            {foreach $clientcountries as $countryCode => $countryName}
                                <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>{$countryName}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="snbd-label" for="inputState">State / division <span aria-hidden="true">*</span></label>
                        <input type="text" name="state" class="form-control" id="inputState" placeholder="State" value="{$clientstate}" autocomplete="address-level1" required>
                    </div>
                    <div class="col-md-3">
                        <label class="snbd-label" for="inputPostcode">Postcode <span aria-hidden="true">*</span></label>
                        <input type="text" name="postcode" class="form-control" id="inputPostcode" placeholder="Postcode" value="{$clientpostcode}" autocomplete="postal-code" required>
                    </div>
                </div>

                {if $taxIdEnabled}
                <div class="row g-3 mt-0">
                    <div class="col-12">
                        <label class="snbd-label" for="inputTaxId">{$LANG.clientareataxid}</label>
                        <input type="text" name="tax_id" class="form-control" id="inputTaxId" value="{$clienttaxid}">
                    </div>
                </div>
                {/if}

                {if $customfields}
                <h3 class="snbd-auth__section">Additional information</h3>
                <div class="row g-3">
                    {foreach $customfields as $customfield}
                    <div class="col-md-6">
                        <label class="snbd-label" for="customfield{$customfield.id}">{$customfield.name}{if $customfield.required} <span aria-hidden="true">*</span>{/if}</label>
                        {$customfield.input}
                        {if $customfield.description}<p class="snbd-hint">{$customfield.description}</p>{/if}
                    </div>
                    {/foreach}
                </div>
                {/if}

                {if $securityquestions}
                <h3 class="snbd-auth__section">Security question</h3>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputSecurityQid">Question <span aria-hidden="true">*</span></label>
                        <select name="securityqid" class="form-select" id="inputSecurityQid">
                            {foreach $securityquestions as $question}
                            <option value="{$question.id}">{$question.question}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputSecurityAns">Answer <span aria-hidden="true">*</span></label>
                        <input type="text" name="securityqans" class="form-control" id="inputSecurityAns" placeholder="Your answer" required>
                    </div>
                </div>
                {/if}

                <h3 class="snbd-auth__section">Account security</h3>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputPassword">Password <span aria-hidden="true">*</span></label>
                        <div class="snbd-password">
                            <input type="password" name="password" class="form-control" id="inputPassword" placeholder="At least 5 characters" autocomplete="new-password" required>
                            <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputPassword" aria-label="Show password"><i class="ti ti-eye" aria-hidden="true"></i></button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputPasswordConfirm">Confirm password <span aria-hidden="true">*</span></label>
                        <div class="snbd-password">
                            <input type="password" name="password2" class="form-control" id="inputPasswordConfirm" placeholder="Repeat your password" autocomplete="new-password" required>
                            <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputPasswordConfirm" aria-label="Show password"><i class="ti ti-eye" aria-hidden="true"></i></button>
                        </div>
                    </div>
                </div>

                {if $showMarketingEmailOptIn}
                <div class="form-check mt-4">
                    <input type="checkbox" name="marketingoptin" class="form-check-input" value="1" id="marketingoptin" {if $marketingEmailOptIn}checked{/if}>
                    <label class="form-check-label" for="marketingoptin">{$marketingEmailOptInMessage|default:"Subscribe to our newsletter for hosting tips, promotions, and product updates."}</label>
                </div>
                {/if}

                {if $accepttos}
                <div class="form-check mt-3">
                    <input type="checkbox" name="accepttos" class="form-check-input" id="accepttos" required>
                    <label class="form-check-label" for="accepttos">{$LANG.ordertosagreement} <a href="{$tosurl}" target="_blank" rel="noopener">{$LANG.ordertos}</a></label>
                </div>
                {/if}

                {if $captcha || $turnstileEnabled}
                <div class="mt-4" id="regCaptchaWrap">
                    {include file="$template/includes/captcha.tpl"}
                    <div class="snbd-alert snbd-alert--warn mt-3" id="regCaptchaWarn" hidden>
                        <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
                        <div class="snbd-alert__body"><p class="snbd-alert__text">Please complete the CAPTCHA verification above before submitting.</p></div>
                    </div>
                </div>
                {/if}

                <button type="submit" id="btnRegistrationSubmit" class="snbd-btn snbd-btn--primary snbd-btn--lg snbd-btn--block mt-4{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                    Create my account<i class="ti ti-arrow-right" aria-hidden="true"></i>
                </button>
            </form>

            <ul class="snbd-auth__trust">
                <li><i class="ti ti-lock" aria-hidden="true"></i>SSL secured</li>
                <li><i class="ti ti-shield-check" aria-hidden="true"></i>2FA ready</li>
                <li><i class="ti ti-user-shield" aria-hidden="true"></i>Privacy safe</li>
            </ul>

            <p class="snbd-auth__switch">Already have an account? <a href="{$WEB_ROOT}/login.php">Sign in</a></p>
        </div>
    </main>
</div>

<script>
{literal}
(function () {
    var form = document.getElementById('frmRegistration');
    if (!form) return;
    form.addEventListener('submit', function (e) {
        var response = null;
        try { if (typeof grecaptcha !== 'undefined') response = grecaptcha.getResponse(); }
        catch (ex) { response = 'skip'; }
        var checkbox = document.querySelector('.g-recaptcha[data-sitekey]');
        if (checkbox && response !== null && response !== 'skip' && response === '') {
            e.preventDefault();
            var warn = document.getElementById('regCaptchaWarn');
            if (warn) {
                warn.hidden = false;
                warn.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    });
})();
{/literal}
</script>

{include file="$template/includes/generate-password.tpl"}
