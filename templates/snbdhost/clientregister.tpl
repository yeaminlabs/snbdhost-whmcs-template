<!-- ====== REGISTER PAGE — SNBD HOST BRAND ====== -->
<style>
/* ── SNBD HOST Brand Tokens ── */
:root {
    --snbd-red:          #BA1114;
    --snbd-red-hover:    #9E0D10;
    --snbd-red-dark:     #8A0C0E;
    --snbd-red-light:    rgba(186, 17, 20, 0.08);
    --snbd-red-border:   rgba(186, 17, 20, 0.20);
    --snbd-bg-body:      #F7F7F4;
    --snbd-surface:      #ffffff;
    --snbd-text-1:       #1a1a1a;
    --snbd-text-2:       #555555;
    --snbd-text-muted:   #757575;
    --snbd-border:       #e0e0e0;
    --snbd-border-sub:   #eeeeee;
    --snbd-font:         'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

/* ── Auth page reset ── */
.auth-page {
    background: var(--snbd-bg-body) !important;
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
    font-family: var(--snbd-font);
}

/* ──────────────────────────────────────────────────────
   LEFT PANEL — Deep brand dark with red accent
   ────────────────────────────────────────────────────── */
.register-left {
    flex: 0 0 38%;
    max-width: 500px;
    background: linear-gradient(160deg, #0f0f0f 0%, #1a0304 50%, #250507 80%, #2e0608 100%);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 3rem 3.5rem;
    position: relative;
    overflow: hidden;
    color: #ffffff;
}

/* Subtle grid overlay */
.register-left-grid {
    position: absolute;
    inset: 0;
    background-image:
        linear-gradient(rgba(255,255,255,0.025) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.025) 1px, transparent 1px);
    background-size: 36px 36px;
    pointer-events: none;
}

/* Glow orbs */
.reg-orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(70px);
    pointer-events: none;
}
.reg-orb-1 {
    width: 380px; height: 380px;
    background: radial-gradient(circle, rgba(186,17,20,0.45), rgba(186,17,20,0.05));
    top: -120px; right: -120px;
}
.reg-orb-2 {
    width: 220px; height: 220px;
    background: radial-gradient(circle, rgba(186,17,20,0.3), transparent);
    bottom: 60px; left: -60px;
}

/* Logo area */
.register-logo-wrap {
    position: relative;
    z-index: 2;
}
.register-logo-wrap img {
    max-height: 36px;
    width: auto;
    filter: brightness(0) invert(1); /* make logo white */
}

/* Content */
.register-brand-content {
    position: relative;
    z-index: 2;
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 3rem 0;
}

.register-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: rgba(186,17,20,0.2);
    border: 1px solid rgba(186,17,20,0.35);
    color: rgba(255,255,255,0.9);
    padding: 0.35rem 0.85rem;
    border-radius: 50rem;
    font-size: 0.72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    margin-bottom: 2rem;
    backdrop-filter: blur(10px);
    width: fit-content;
}

.register-brand-headline {
    font-size: clamp(2rem, 3vw, 2.8rem);
    font-weight: 900;
    line-height: 1.1;
    letter-spacing: -0.04em;
    margin-bottom: 1.25rem;
    color: #ffffff;
}
.register-brand-headline span {
    background: linear-gradient(135deg, #ff5555, #ff9090);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.register-brand-desc {
    font-size: 0.95rem;
    color: rgba(255,255,255,0.6);
    line-height: 1.75;
    margin-bottom: 2.5rem;
    max-width: 380px;
}

/* Feature list */
.register-features {
    display: flex;
    flex-direction: column;
    gap: 0.85rem;
    margin-bottom: 3rem;
}
.register-feature {
    display: flex;
    align-items: center;
    gap: 0.85rem;
    font-size: 0.875rem;
    color: rgba(255,255,255,0.75);
    font-weight: 500;
}
.register-feature-icon {
    width: 30px; height: 30px;
    background: rgba(186,17,20,0.25);
    border: 1px solid rgba(186,17,20,0.4);
    border-radius: 7px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.75rem;
    color: #ff8888;
    flex-shrink: 0;
}

/* Stats */
.register-stats {
    display: flex;
    gap: 2rem;
    padding-top: 2rem;
    border-top: 1px solid rgba(255,255,255,0.08);
    position: relative;
    z-index: 2;
}
.register-stat-num {
    font-size: 1.5rem;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: -0.03em;
    line-height: 1;
}
.register-stat-label {
    font-size: 0.7rem;
    color: rgba(255,255,255,0.45);
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-top: 0.2rem;
}

/* ──────────────────────────────────────────────────────
   RIGHT PANEL — Clean white form area
   ────────────────────────────────────────────────────── */
.register-right {
    flex: 1;
    background: var(--snbd-bg-body);
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 3rem 2rem;
    overflow-y: auto;
}
.register-card {
    background: var(--snbd-surface);
    border-radius: 12px;
    border: 1px solid var(--snbd-border);
    box-shadow: 0 2px 8px rgba(0,0,0,0.04), 0 1px 2px rgba(0,0,0,0.02);
    width: 100%;
    max-width: 820px;
    padding: 3rem 3.5rem;
}

/* Form headline */
.reg-form-headline {
    font-size: 1.9rem;
    font-weight: 800;
    color: var(--snbd-text-1);
    text-align: center;
    margin-bottom: 0.5rem;
    letter-spacing: -0.035em;
}
.reg-form-subhead {
    text-align: center;
    color: var(--snbd-text-muted);
    font-size: 0.9rem;
    margin-bottom: 2.5rem;
}

/* Section titles */
.reg-section-title {
    font-size: 0.85rem;
    font-weight: 700;
    color: var(--snbd-text-2);
    text-transform: uppercase;
    letter-spacing: 0.6px;
    margin-top: 2.25rem;
    margin-bottom: 1.25rem;
    padding-bottom: 0.5rem;
    border-bottom: 1px solid var(--snbd-border-sub);
}
.reg-section-title:first-of-type { margin-top: 0; }

/* Labels */
.reg-label {
    display: block;
    font-size: 0.8rem;
    font-weight: 600;
    color: var(--snbd-text-2);
    margin-bottom: 0.4rem;
    letter-spacing: 0.1px;
}

/* Inputs */
.reg-input {
    background-color: var(--snbd-surface) !important;
    border: 1px solid var(--snbd-border) !important;
    border-radius: 7px !important;
    padding-top: 0.75rem !important;
    padding-bottom: 0.75rem !important;
    padding-right: 0.9rem !important;
    padding-left: 0.9rem; /* Allow inline styles to override */
    font-size: 0.9rem !important;
    font-weight: 400 !important;
    color: var(--snbd-text-1) !important;
    box-shadow: none !important;
    transition: border-color 0.15s, box-shadow 0.15s !important;
    width: 100%;
    font-family: var(--snbd-font) !important;
}
.reg-input::placeholder {
    color: var(--snbd-text-muted) !important;
    font-weight: 400 !important;
}
.reg-input:focus {
    border-color: var(--snbd-red) !important;
    box-shadow: 0 0 0 3px rgba(186,17,20,0.1) !important;
    outline: none !important;
    background-color: var(--snbd-surface) !important;
}
.reg-input:-webkit-autofill,
.reg-input:-webkit-autofill:hover,
.reg-input:-webkit-autofill:focus {
    -webkit-box-shadow: 0 0 0 1000px var(--snbd-surface) inset !important;
    -webkit-text-fill-color: var(--snbd-text-1) !important;
}

/* Select */
.reg-select {
    background-color: var(--snbd-surface) !important;
    border: 1px solid var(--snbd-border) !important;
    border-radius: 7px !important;
    padding: 0.75rem 0.9rem !important;
    font-size: 0.9rem !important;
    color: var(--snbd-text-1) !important;
    box-shadow: none !important;
    transition: border-color 0.15s, box-shadow 0.15s !important;
    width: 100%;
    font-family: var(--snbd-font) !important;
}
.reg-select:focus {
    border-color: var(--snbd-red) !important;
    box-shadow: 0 0 0 3px rgba(186,17,20,0.1) !important;
    outline: none !important;
}

/* Checkbox */
.form-check-input {
    border: 1.5px solid var(--snbd-border) !important;
    background-color: var(--snbd-surface) !important;
    border-radius: 4px !important;
    width: 1.1em !important;
    height: 1.1em !important;
    cursor: pointer !important;
    transition: all 0.15s !important;
}
.form-check-input:checked {
    background-color: var(--snbd-red) !important;
    border-color: var(--snbd-red) !important;
}
.form-check-input:focus {
    box-shadow: 0 0 0 3px rgba(186,17,20,0.12) !important;
    border-color: var(--snbd-red) !important;
}

/* Submit Button */
.reg-btn {
    background: var(--snbd-red);
    color: #ffffff;
    font-weight: 600;
    font-size: 1rem;
    border-radius: 50rem;
    padding: 0.9rem 2rem;
    border: none;
    transition: all 0.2s;
    width: 100%;
    margin-top: 1.75rem;
    cursor: pointer;
    font-family: var(--snbd-font);
    box-shadow: 0 4px 14px rgba(186,17,20,0.25);
    letter-spacing: 0.1px;
}
.reg-btn:hover {
    background: var(--snbd-red-hover);
    transform: translateY(-1px);
    box-shadow: 0 8px 24px rgba(186,17,20,0.3);
    color: #ffffff;
}
.reg-btn:active {
    transform: translateY(0);
}

/* Error alert */
.reg-alert {
    background: rgba(186,17,20,0.07);
    border: 1px solid rgba(186,17,20,0.18);
    color: var(--snbd-red);
    font-weight: 600;
    font-size: 0.875rem;
    border-radius: 8px;
    padding: 0.75rem 1rem;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

/* Trust footer */
.reg-trust {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.5rem;
    margin-top: 1.5rem;
    padding-top: 1.25rem;
    border-top: 1px solid var(--snbd-border-sub);
}
.reg-trust-item {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.72rem;
    color: var(--snbd-text-muted);
    font-weight: 500;
}
.reg-trust-item i { color: var(--snbd-red); font-size: 0.72rem; }

/* Custom WHMCS form fields */
.register-card .form-control,
.register-card .form-select {
    background-color: var(--snbd-surface) !important;
    border: 1px solid var(--snbd-border) !important;
    border-radius: 7px !important;
    padding: 0.75rem 0.9rem !important;
    font-size: 0.9rem !important;
    color: var(--snbd-text-1) !important;
    box-shadow: none !important;
}
.register-card .form-control:focus,
.register-card .form-select:focus {
    border-color: var(--snbd-red) !important;
    box-shadow: 0 0 0 3px rgba(186,17,20,0.1) !important;
}

/* ITI phone width fix */
.iti { width: 100%; }
.iti__flag-container { z-index: 10; }
.iti__selected-flag { border-radius: 6px 0 0 6px; }
.phone-iti-wrap { position: relative; width: 100%; }
.phone-iti-wrap .iti { width: 100%; }
.phone-iti-wrap input[type="tel"] {
    padding-left: 95px !important;
    border-radius: 7px !important;
    border: 1px solid var(--snbd-border) !important;
    font-size: 0.9rem !important;
    height: auto !important;
    font-family: var(--snbd-font) !important;
    color: var(--snbd-text-1) !important;
    background: var(--snbd-surface) !important;
    transition: border-color 0.15s, box-shadow 0.15s !important;
}
.phone-iti-wrap input[type="tel"]:focus {
    border-color: var(--snbd-red) !important;
    box-shadow: 0 0 0 3px rgba(186,17,20,0.1) !important;
    outline: none !important;
}
.phone-iti-wrap .iti--separate-dial-code .iti__selected-flag {
    background: #f5f5f5;
    border-right: 1px solid var(--snbd-border);
    border-radius: 6px 0 0 6px;
}
/* reCAPTCHA fix */
.reg-captcha-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.5rem;
    margin-top: 1rem;
}
.reg-captcha-warn {
    background: rgba(186,17,20,0.07);
    border: 1px solid rgba(186,17,20,0.18);
    color: var(--snbd-red);
    font-size: 0.82rem;
    font-weight: 600;
    border-radius: 7px;
    padding: 0.5rem 1rem;
    display: none;
    width: 100%;
    text-align: center;
}

/* Animations */
@keyframes fadeSlideUp {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
}
.register-card { animation: fadeSlideUp 0.5s cubic-bezier(0.22,1,0.36,1) both; }

/* ── Responsive ── */
@media (max-width: 992px) {
    .register-left {
        flex: none;
        width: 100%;
        max-width: 100%;
        padding: 2.5rem 2rem;
        min-height: 260px;
        justify-content: flex-start;
        gap: 2rem;
    }
    .register-brand-content { padding: 1.5rem 0; }
    .register-right { padding: 2rem 1rem; }
    .register-card { padding: 2rem 1.5rem; }
    .register-split { flex-direction: column; }
    .reg-orb-1 { width: 200px; height: 200px; top: -60px; right: -60px; }
    .reg-orb-2 { display: none; }
}
@media (max-width: 576px) {
    .register-card { padding: 1.5rem 1rem; }
}
</style>

<div class="register-split">

    <!-- ===== LEFT: Branding Panel ===== -->
    <div class="register-left">
        <div class="register-left-grid"></div>
        <div class="reg-orb reg-orb-1"></div>
        <div class="reg-orb reg-orb-2"></div>

        <!-- Logo -->
        <div class="register-logo-wrap">
            <a href="https://snbdhost.com">
                <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" />
            </a>
        </div>

        <!-- Main content -->
        <div class="register-brand-content">
            <div class="register-badge">
                <i class="fas fa-shield-alt"></i> Trusted by 10,000+ Clients
            </div>
            <h2 class="register-brand-headline">
                Bangladesh's #1<br><span>Web Hosting</span><br>Provider
            </h2>
            <p class="register-brand-desc">
                Deploy hosting, manage domains, and get expert 24/7 support — all from one powerful and fast dashboard.
            </p>

            <div class="register-features">
                <div class="register-feature">
                    <div class="register-feature-icon"><i class="fas fa-server"></i></div>
                    NVMe SSD + AMD EPYC Powered Servers
                </div>
                <div class="register-feature">
                    <div class="register-feature-icon"><i class="fas fa-globe"></i></div>
                    Domain Registration &amp; Full DNS Control
                </div>
                <div class="register-feature">
                    <div class="register-feature-icon"><i class="fas fa-headset"></i></div>
                    24/7 Expert Support, Always Ready
                </div>
            </div>
        </div>

        <!-- Stats -->
        <div class="register-stats">
            <div>
                <div class="register-stat-num">10K+</div>
                <div class="register-stat-label">Happy Clients</div>
            </div>
            <div>
                <div class="register-stat-num">99.9%</div>
                <div class="register-stat-label">Uptime SLA</div>
            </div>
            <div>
                <div class="register-stat-num">24/7</div>
                <div class="register-stat-label">Support</div>
            </div>
        </div>
    </div>

    <!-- ===== RIGHT: Registration Form ===== -->
    <div class="register-right">
        <div class="register-card">

<h1 class="reg-form-headline">Create an Account</h1>
            <p class="reg-form-subhead">Join SNBD HOST and get started in seconds.</p>

            {if $errormessage}
                <div class="reg-alert" id="regErrAlert">
                    <i class="fas fa-exclamation-circle" id="regErrIcon"></i>
                    <span id="regErrMsg">{$errormessage}</span>
                </div>
                <script>
                {literal}
                (function(){
                    var msgEl = document.getElementById('regErrMsg');
                    var iconEl = document.getElementById('regErrIcon');
                    if (msgEl) {
                        var t = (msgEl.textContent || msgEl.innerText || '').toLowerCase();
                        if (t.indexOf('captcha') !== -1) {
                            iconEl.className = 'fas fa-shield-alt';
                            msgEl.innerHTML = 'CAPTCHA verification failed. Please <a href="javascript:location.reload()" style="color:var(--snbd-red);font-weight:700;text-decoration:underline;">refresh the page</a> and complete the CAPTCHA before submitting.';
                        }
                    }
                })();
                {/literal}
                </script>
            {/if}

            <!-- Custom Google Sign-In -->
            {if $googleClientId}
            <div class="snbd-google-signin-wrapper mb-4 mt-3 d-flex flex-column align-items-center">
                <div id="g_id_onload"
                     data-client_id="{$googleClientId}"
                     data-context="signup"
                     data-ux_mode="popup"
                     data-callback="onGoogleSignIn"
                     data-auto_prompt="false">
                </div>
                <div class="g_id_signin"
                     data-type="standard"
                     data-shape="rectangular"
                     data-theme="outline"
                     data-text="signup_with"
                     data-size="large"
                     data-logo_alignment="center">
                </div>
                <div id="snbdGoogleSignInLoading" style="display:none; width:100%; text-align:center; margin-top:1rem; color:var(--snbd-text-muted); font-size:0.9rem;">
                    <i class="fas fa-circle-notch fa-spin me-2" style="color:var(--snbd-red);"></i> Authenticating securely...
                </div>
                <div id="snbdGoogleSignInError" style="display:none; width:100%;" class="auth-alert mt-3 text-start"></div>
            </div>
            {/if}

            <form method="post" action="{$WEB_ROOT}/register.php" id="frmRegistration" class="needs-validation text-start" role="form">
                <input type="hidden" name="register" value="true" />
                <input type="hidden" name="token" value="{$token}" />

                <!-- Personal Information -->
                <div class="reg-section-title">Personal Information</div>
                <div class="row g-3 mb-0">
                    <div class="col-md-6">
                        <label class="reg-label" for="inputFirstName">First Name *</label>
                        <input type="text" name="firstname" class="reg-input" id="inputFirstName" placeholder="e.g. Yeamin" value="{$clientfirstname}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputLastName">Last Name *</label>
                        <input type="text" name="lastname" class="reg-input" id="inputLastName" placeholder="e.g. Adib" value="{$clientlastname}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputEmail">Email Address *</label>
                        <input type="email" name="email" class="reg-input" id="inputEmail" placeholder="you@example.com" value="{$clientemail}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputPhone">Phone Number *</label>
                        <div class="phone-iti-wrap">
                            <input type="tel" name="phonenumber" class="reg-input" id="inputPhone" placeholder="1XXX-XXXXXX" value="{$clientphonenumber}" required>
                        </div>
                    </div>
                </div>

                <!-- Billing Address -->
                <div class="reg-section-title">Billing Address</div>
                <div class="row g-3 mb-0">
                    <div class="col-md-6">
                        <label class="reg-label" for="inputCompanyName">Company Name <span class="fw-normal text-muted">(Optional)</span></label>
                        <input type="text" name="companyname" class="reg-input" id="inputCompanyName" placeholder="Your Company Ltd." value="{$clientcompanyname}">
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputAddress1">Street Address *</label>
                        <input type="text" name="address1" class="reg-input" id="inputAddress1" placeholder="House, Road, Area" value="{$clientaddress1}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputAddress2">Address Line 2 <span class="fw-normal text-muted">(Optional)</span></label>
                        <input type="text" name="address2" class="reg-input" id="inputAddress2" placeholder="Apartment, Suite, etc." value="{$clientaddress2}">
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputCity">City *</label>
                        <input type="text" name="city" class="reg-input" id="inputCity" placeholder="e.g. Dhaka" value="{$clientcity}" required>
                    </div>
                    <div class="col-md-5">
                        <label class="reg-label" for="inputCountry">Country *</label>
                        <select name="country" class="reg-input reg-select" id="inputCountry">
                            {foreach $clientcountries as $countryCode => $countryName}
                                <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>
                                    {$countryName}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="reg-label" for="inputState">State / Division *</label>
                        <input type="text" name="state" class="reg-input" id="inputState" placeholder="e.g. Dhaka" value="{$clientstate}" required>
                    </div>
                    <div class="col-md-3">
                        <label class="reg-label" for="inputPostcode">Postcode *</label>
                        <input type="text" name="postcode" class="reg-input" id="inputPostcode" placeholder="1207" value="{$clientpostcode}" required>
                    </div>
                </div>

                {if $taxIdEnabled}
                <div class="row g-3 mt-0">
                    <div class="col-12">
                        <label class="reg-label" for="inputTaxId">{$LANG.clientareataxid}</label>
                        <input type="text" name="tax_id" class="reg-input" id="inputTaxId" value="{$clienttaxid}">
                    </div>
                </div>
                {/if}

                <!-- Additional Information (Custom Fields) -->
                {if $customfields}
                    <div class="reg-section-title">Additional Information</div>
                    <div class="row g-3 mb-0">
                        {foreach $customfields as $customfield}
                            <div class="col-md-6">
                                <label class="reg-label" for="customfield{$customfield.id}">
                                    {$customfield.name}{if $customfield.required} *{/if}
                                </label>
                                <div class="control-group">
                                    {$customfield.input}
                                    {if $customfield.description}<div class="text-muted" style="font-size:0.75rem; margin-top:0.3rem;">{$customfield.description}</div>{/if}
                                </div>
                            </div>
                        {/foreach}
                    </div>
                {/if}

                <!-- Security Question -->
                {if $securityquestions}
                    <div class="reg-section-title">Security Question</div>
                    <div class="row g-3 mb-0">
                        <div class="col-md-6">
                            <label class="reg-label" for="inputSecurityQid">Question *</label>
                            <select name="securityqid" class="reg-input reg-select" id="inputSecurityQid">
                                {foreach $securityquestions as $question}
                                    <option value="{$question.id}">{$question.question}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="reg-label" for="inputSecurityAns">Answer *</label>
                            <input type="text" name="securityqans" class="reg-input" id="inputSecurityAns" placeholder="Your answer" required>
                        </div>
                    </div>
                {/if}

                <!-- Account Security -->
                <div class="reg-section-title">Account Security</div>
                <div class="row g-3 mb-0">
                    <div class="col-md-6">
                        <div class="d-flex justify-content-between align-items-end mb-1">
                            <label class="reg-label mb-0" for="inputPassword">Password *</label>
                            <span style="font-size:0.7rem; color:var(--snbd-text-muted);">
                                <i class="fas fa-info-circle" style="font-size:0.65rem;"></i> At least 5 characters
                            </span>
                        </div>
                        <input type="password" name="password" class="reg-input" id="inputPassword" placeholder="Create a strong password" autocomplete="off" required>
                    </div>
                    <div class="col-md-6">
                        <label class="reg-label" for="inputPasswordConfirm">Confirm Password *</label>
                        <input type="password" name="password2" class="reg-input" id="inputPasswordConfirm" placeholder="Repeat your password" autocomplete="off" required>
                    </div>
                </div>

                <!-- Marketing opt-in -->
                {if $showMarketingEmailOptIn}
                    <div class="form-check mt-3 px-1 d-flex align-items-start gap-2">
                        <input type="checkbox" name="marketingoptin" class="form-check-input flex-shrink-0 mt-1" value="1" id="marketingoptin" {if $marketingEmailOptIn}checked{/if}>
                        <label class="form-check-label small fw-medium" for="marketingoptin" style="color:var(--snbd-text-2); cursor:pointer; line-height:1.4;">
                            {$marketingEmailOptInMessage|default:"Subscribe to our newsletter for hosting tips, promotions, and product updates."}
                        </label>
                    </div>
                {/if}

                <!-- Terms of Service -->
                {if $accepttos}
                    <div class="form-check mt-2 px-1 d-flex align-items-start gap-2">
                        <input type="checkbox" name="accepttos" class="form-check-input flex-shrink-0 mt-1" id="accepttos" required>
                        <label class="form-check-label small fw-medium" for="accepttos" style="color:var(--snbd-text-2); cursor:pointer; line-height:1.4;">
                            {$LANG.ordertosagreement}
                            <a href="{$tosurl}" target="_blank" style="color:var(--snbd-red); font-weight:600; text-decoration:none;">{$LANG.ordertos}</a>
                        </label>
                    </div>
                {/if}

                <!-- CAPTCHA -->
                {if $captcha || $turnstileEnabled}
                    <div class="reg-captcha-wrap" id="regCaptchaWrap">
                        {include file="$template/includes/captcha.tpl"}
                        <div class="reg-captcha-warn" id="regCaptchaWarn" style="display:none;">
                            <i class="fas fa-exclamation-triangle"></i>
                            Please complete the CAPTCHA verification above before submitting.
                        </div>
                    </div>
                {/if}

                <button type="submit" id="btnRegistrationSubmit" class="reg-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                    Create My Account &nbsp;<i class="fas fa-arrow-right" style="font-size:0.85em;"></i>
                </button>
            </form>

            <!-- Trust footer -->
            <div class="reg-trust">
                <div class="reg-trust-item">
                    <i class="fas fa-lock"></i> SSL Secured
                </div>
                <div class="reg-trust-item">
                    <i class="fas fa-shield-alt"></i> 2FA Ready
                </div>
                <div class="reg-trust-item">
                    <i class="fas fa-user-shield"></i> Privacy Safe
                </div>
            </div>

            <div class="text-center mt-3" style="font-size:0.78rem; color:var(--snbd-text-muted);">
                Already have an account?
                <a href="{$WEB_ROOT}/login.php" style="color:var(--snbd-red); font-weight:600; text-decoration:none;">Sign In</a>
            </div>

        </div>
    </div>
</div>

<script>
{literal}
(function () {
    /* ── CAPTCHA client-side hint (non-blocking) ── */
    /* Note: WHMCS server-side handles actual captcha validation.
       We only show a visual hint if reCAPTCHA v2 checkbox is clearly unchecked. */
    var regForm2 = document.getElementById('frmRegistration');
    if (regForm2) {
        regForm2.addEventListener('submit', function (e) {
            var rcResp = null;
            try {
                if (typeof grecaptcha !== 'undefined') {
                    rcResp = grecaptcha.getResponse();
                }
            } catch (ex) { rcResp = 'skip'; }

            /* Only block if: grecaptcha is loaded, widget is a v2 checkbox type,
               AND the response is definitively empty */
            var captchaCheckbox = document.querySelector('.g-recaptcha[data-sitekey]');
            if (captchaCheckbox && rcResp !== null && rcResp !== 'skip' && rcResp === '') {
                e.preventDefault();
                var warn = document.getElementById('regCaptchaWarn');
                if (warn) {
                    warn.style.display = 'block';
                    warn.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return false;
            }
        });
    }
})();

// ── Note: Auto-trigger Google Auth removed because it conflicts with Google Identity Services clickjacking protection. ──
{/literal}
</script>
