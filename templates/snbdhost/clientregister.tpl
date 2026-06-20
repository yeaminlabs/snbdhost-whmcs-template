<!-- ====== REGISTER PAGE ====== -->
<style>
/* ── Reset & Base ── */
.auth-page {
    background: #f8f9fa !important;
    min-height: 100vh;
    display: flex;
    align-items: stretch;
}
#particles-js { display: none !important; }

/* ── Split Layout ── */
.register-split {
    display: flex;
    width: 100%;
    min-height: 100vh;
}

/* ── Left Panel (Branding) ── */
.register-left {
    flex: 0 0 35%;
    max-width: 480px;
    background: #0d3b9e;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    padding: 4rem;
    position: relative;
    overflow: hidden;
    color: #ffffff;
}
.register-brand {
    position: relative;
    z-index: 2;
    width: 100%;
}
.register-logo {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-size: 1.75rem;
    font-weight: 800;
    letter-spacing: -0.03em;
    margin-bottom: 5rem;
}
.register-logo i {
    font-size: 2rem;
}
.register-brand-title {
    font-size: 2.5rem;
    font-weight: 800;
    line-height: 1.1;
    margin-bottom: 0.5rem;
}
.register-brand-date {
    font-size: 0.85rem;
    color: rgba(255,255,255,0.6);
    margin-bottom: 1rem;
    display: block;
}
.register-brand-subtitle {
    font-size: 1.85rem;
    font-weight: 700;
    line-height: 1.3;
    margin-bottom: 1.5rem;
}
.register-brand-desc {
    font-size: 1rem;
    color: rgba(255,255,255,0.75);
    line-height: 1.6;
    margin-bottom: 2.5rem;
}
.register-dots {
    display: flex;
    gap: 0.5rem;
}
.register-dot {
    width: 10px; height: 10px;
    border-radius: 50%;
    background: rgba(255,255,255,0.3);
    transition: background 0.2s;
}
.register-dot.active {
    background: #ffffff;
}

/* ── Right Panel (Form) ── */
.register-right {
    flex: 1;
    background: #fcfcfc;
    display: flex;
    justify-content: center;
    align-items: flex-start; /* scrollable form */
    padding: 4rem 2rem;
    overflow-y: auto;
}
.register-card {
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.03), 0 1px 3px rgba(0,0,0,0.02);
    width: 100%;
    max-width: 800px;
    padding: 3.5rem;
}

.form-headline {
    font-size: 2.25rem;
    font-weight: 800;
    color: #111111;
    text-align: center;
    margin-bottom: 3rem;
}

.section-title {
    font-size: 1.25rem;
    font-weight: 400;
    color: #444444;
    margin-top: 2rem;
    margin-bottom: 1.5rem;
}
.section-title:first-of-type {
    margin-top: 0;
}

.auth-input-label {
    display: block;
    font-size: 0.85rem;
    font-weight: 600;
    color: #666666;
    margin-bottom: 0.5rem;
}

.auth-clean-input {
    background-color: #ffffff !important;
    border: 1px solid #e2e2e2 !important;
    border-radius: 6px !important;
    padding: 0.85rem 1rem !important;
    font-size: 0.95rem !important;
    color: #333333 !important;
    box-shadow: none !important;
    transition: all 0.2s !important;
    width: 100%;
}
.auth-clean-input::placeholder {
    color: #bbbbbb !important;
}
.auth-clean-input:focus {
    border-color: #0d3b9e !important;
    box-shadow: 0 0 0 3px rgba(13, 59, 158, 0.1) !important;
    outline: none !important;
}

/* Checkbox */
.form-check-input {
    border: 1.5px solid #dddddd !important;
    background-color: #ffffff !important;
    border-radius: 4px !important;
    width: 1.15em !important;
    height: 1.15em !important;
    cursor: pointer !important;
    margin-top: 0.15em !important;
    transition: all 0.2s !important;
}
.form-check-input:checked {
    background-color: #0d3b9e !important;
    border-color: #0d3b9e !important;
}
.form-check-input:focus {
    box-shadow: 0 0 0 3px rgba(13, 59, 158, 0.12) !important;
    border-color: #0d3b9e !important;
}

/* Submit button */
.auth-clean-btn {
    background: #0d3b9e;
    color: #ffffff;
    font-weight: 600;
    font-size: 1.1rem;
    border-radius: 6px;
    padding: 1rem 2rem;
    border: none;
    transition: all 0.2s;
    width: 100%;
    margin-top: 1.5rem;
    cursor: pointer;
}
.auth-clean-btn:hover {
    background: #0a2d7a;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(13, 59, 158, 0.2);
}

/* Custom fields from WHMCS */
.register-card .form-control {
    border-radius: 6px !important;
    background-color: #ffffff !important;
    border: 1px solid #e2e2e2 !important;
    padding: 0.85rem 1rem !important;
    font-size: 0.95rem !important;
    color: #333333 !important;
    box-shadow: none !important;
    transition: all 0.2s !important;
}
.register-card .form-control:focus {
    border-color: #0d3b9e !important;
    box-shadow: 0 0 0 3px rgba(13, 59, 158, 0.1) !important;
}

/* Responsive */
@media (max-width: 991px) {
    .register-split { flex-direction: column; }
    .register-left { flex: none; width: 100%; max-width: 100%; padding: 3rem 2rem; }
    .register-right { padding: 2rem 1rem; }
    .register-card { padding: 2rem; }
}

.iti { width: 100%; } /* Int-tel-input fix */
</style>

<div class="register-split">
    <!-- ===== LEFT: Branding Panel ===== -->
    <div class="register-left">
        <div class="register-brand">
            <div class="register-logo">
                <i class="fas fa-layer-group"></i> SNBD HOST
            </div>
            
            <h2 class="register-brand-title">What's new</h2>
            <span class="register-brand-date">{$smarty.now|date_format:"%b %d, %Y"}</span>
            <h3 class="register-brand-subtitle">Launches Remarkable New Range of Premium Dedicated Servers</h3>
            <p class="register-brand-desc">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam felis augue, rutrum at lorem nec, cursus gravida turpis. Curabitur sagittis, enim sit amet fringilla mollis, nulla dolor rhoncus eros, quis consectetur nibh velit sed purus. Etiam sodales dui eu hendrerit varius...
            </p>
            
            <div class="register-dots">
                <div class="register-dot active"></div>
                <div class="register-dot"></div>
                <div class="register-dot"></div>
                <div class="register-dot"></div>
            </div>
        </div>
    </div>

    <!-- ===== RIGHT: Registration Form ===== -->
    <div class="register-right">
        <div class="register-card">
            
            <h1 class="form-headline">Register</h1>

            {if $errormessage}
                <div class="alert alert-danger py-2 text-center small mb-4 rounded border-0" style="background:rgba(204,0,0,0.1); color:#CC0000; font-weight:600;">
                    <i class="fas fa-exclamation-circle me-1"></i>{$errormessage}
                </div>
            {/if}

            <form method="post" action="{$WEB_ROOT}/register.php" id="frmRegistration" class="needs-validation text-start" role="form">
                <input type="hidden" name="register" value="true" />
                <input type="hidden" name="token" value="{$token}" />
                
                <div class="section-title">Personal Information</div>
                
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputFirstName">First Name *</label>
                        <input type="text" name="firstname" class="form-control auth-clean-input" id="inputFirstName" value="{$clientfirstname}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputLastName">Last Name *</label>
                        <input type="text" name="lastname" class="form-control auth-clean-input" id="inputLastName" value="{$clientlastname}" required>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputEmail">Email Address *</label>
                        <input type="email" name="email" class="form-control auth-clean-input" id="inputEmail" value="{$clientemail}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputPhone">Phone Number *</label>
                        <input type="tel" name="phonenumber" class="form-control auth-clean-input" id="inputPhone" value="{$clientphonenumber}" required>
                    </div>
                </div>

                <div class="section-title">Billing Address</div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputCompanyName">Company Name (Optional)</label>
                        <input type="text" name="companyname" class="form-control auth-clean-input" id="inputCompanyName" value="{$clientcompanyname}">
                    </div>
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputAddress1">Street Address *</label>
                        <input type="text" name="address1" class="form-control auth-clean-input" id="inputAddress1" value="{$clientaddress1}" required>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputAddress2">Street Address 2 (Optional)</label>
                        <input type="text" name="address2" class="form-control auth-clean-input" id="inputAddress2" value="{$clientaddress2}">
                    </div>
                    <div class="col-md-6">
                        <label class="auth-input-label" for="inputCity">City *</label>
                        <input type="text" name="city" class="form-control auth-clean-input" id="inputCity" value="{$clientcity}" required>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="auth-input-label" for="inputCountry">Country *</label>
                        <select name="country" class="form-select auth-clean-input" id="inputCountry">
                            {foreach $clientcountries as $countryCode => $countryName}
                                <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>
                                    {$countryName}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="auth-input-label" for="inputState">State *</label>
                        <input type="text" name="state" class="form-control auth-clean-input" id="inputState" value="{$clientstate}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="auth-input-label" for="inputPostcode">Postcode *</label>
                        <input type="text" name="postcode" class="form-control auth-clean-input" id="inputPostcode" value="{$clientpostcode}" required>
                    </div>
                </div>

                {if $taxIdEnabled}
                <div class="row g-3 mb-3">
                    <div class="col-md-12">
                        <label class="auth-input-label" for="inputTaxId">{$LANG.clientareataxid}</label>
                        <input type="text" name="tax_id" class="form-control auth-clean-input" id="inputTaxId" value="{$clienttaxid}">
                    </div>
                </div>
                {/if}
                
                {if $customfields}
                    <div class="section-title">Additional Information</div>
                    {foreach $customfields as $customfield}
                        <div class="mb-3 text-start">
                            <label class="auth-input-label" for="customfield{$customfield.id}">{$customfield.name} {if $customfield.required}*{/if}</label>
                            <div class="control-group">
                                {$customfield.input} 
                                {if $customfield.description}<div class="text-muted small mt-1">{$customfield.description}</div>{/if}
                            </div>
                        </div>
                    {/foreach}
                {/if}

                {if $securityquestions}
                    <div class="section-title">Security Question</div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="auth-input-label" for="inputSecurityQid">Choose a security question *</label>
                            <select name="securityqid" class="form-select auth-clean-input" id="inputSecurityQid">
                                {foreach $securityquestions as $question}
                                    <option value="{$question.id}">{$question.question}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="auth-input-label" for="inputSecurityAns">Answer *</label>
                            <input type="text" name="securityqans" class="form-control auth-clean-input" id="inputSecurityAns" required>
                        </div>
                    </div>
                {/if}
                
                <div class="section-title">Account Security</div>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <div class="d-flex justify-content-between align-items-end">
                            <label class="auth-input-label mb-0" for="inputPassword">Password *</label>
                            <span class="small text-muted" style="font-size: 0.7rem;"><i class="fas fa-info-circle"></i> at least 5 characters</span>
                        </div>
                        <input type="password" name="password" class="form-control auth-clean-input mt-1" id="inputPassword" autocomplete="off" required>
                    </div>
                    <div class="col-md-6">
                        <label class="auth-input-label mt-1 mt-md-0" for="inputPasswordConfirm">Confirm Password *</label>
                        <input type="password" name="password2" class="form-control auth-clean-input" id="inputPasswordConfirm" autocomplete="off" required>
                    </div>
                </div>

                {if $showMarketingEmailOptIn}
                    <div class="form-check mb-3 px-2 text-start d-flex align-items-start gap-2">
                        <input type="checkbox" name="marketingoptin" class="form-check-input flex-shrink-0" value="1" id="marketingoptin" {if $marketingEmailOptIn}checked{/if}>
                        <label class="form-check-label small fw-medium ms-1" for="marketingoptin" style="margin-top: 2px; color: #555555 !important;">
                            {$marketingEmailOptInMessage|default:"Subscribe to our newsletter for updates, promotions, and special offers."}
                        </label>
                    </div>
                {/if}

                {if $accepttos}
                    <div class="form-check mb-4 px-2 text-start d-flex align-items-start gap-2">
                        <input type="checkbox" name="accepttos" class="form-check-input flex-shrink-0" id="accepttos" required>
                        <label class="form-check-label small fw-medium ms-1" for="accepttos" style="margin-top: 2px; color: #555555 !important;">
                            I have read and agree to the <a href="{$tosurl}" target="_blank" class="text-primary text-decoration-none fw-semibold">Terms of Service</a>.
                        </label>
                    </div>
                {/if}

                {if $captcha}
                    <div class="mb-4 d-flex justify-content-center">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                {/if}

                <button type="submit" id="btnRegistrationSubmit" class="auth-clean-btn">
                    Register
                </button>
            </form>
        </div>
    </div>
</div>
