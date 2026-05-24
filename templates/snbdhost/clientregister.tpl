<!-- ====== REGISTER PAGE ====== -->
<div class="auth-card auth-card-wide">
    <div class="auth-accent-line"></div>

    <!-- Logo -->
    <div class="auth-logo-block">
        <div class="auth-logo-icon">
            <i class="fas fa-server"></i>
        </div>
        <div class="auth-logo-text">{$companyname}</div>
        <div class="auth-logo-tagline">Cloud Infrastructure & Hosting</div>
    </div>

    <!-- Tab Switcher -->
    <div class="auth-tabs">
        <a href="{$WEB_ROOT}/login.php" class="auth-tab">Sign In</a>
        <a href="{$WEB_ROOT}/register.php" class="auth-tab active">Create Account</a>
    </div>

    <!-- Error Messages -->
    {if $errormessage}
        <div class="alert alert-danger py-2 text-center small mb-3">
            <i class="fas fa-exclamation-circle me-1"></i>{$errormessage}
        </div>
    {/if}

    <!-- Register Form -->
    <form method="post" action="{$WEB_ROOT}/register.php" id="frmRegister" class="needs-validation login-form" role="form">
        <input type="hidden" name="register" value="true" />
        <input type="hidden" name="token" value="{$token}" />
        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-user"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="firstname" class="form-control" id="inputFirstName" placeholder="First Name" value="{$clientfirstname}" required>
                        <label for="inputFirstName">{$LANG.clientareafirstname}</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-user-tag"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="lastname" class="form-control" id="inputLastName" placeholder="Last Name" value="{$clientlastname}" required>
                        <label for="inputLastName">{$LANG.clientarealastname}</label>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-envelope"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="email" name="email" class="form-control" id="inputEmail" placeholder="Email" value="{$clientemail}" required>
                        <label for="inputEmail">{$LANG.clientareaemail}</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-phone"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="tel" name="phonenumber" class="form-control" id="inputPhone" placeholder="Phone" value="{$clientphonenumber}" required>
                        <label for="inputPhone">{$LANG.clientareaphonenumber}</label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Address Section -->
        <h6 class="text-muted small text-uppercase fw-bold mt-4 mb-3">Billing Address</h6>
        <div class="auth-input-group mb-3">
            <div class="auth-input-icon"><i class="fas fa-map-marker-alt"></i></div>
            <div class="form-floating flex-grow-1">
                <input type="text" name="address1" class="form-control" id="inputAddress1" placeholder="Address" value="{$clientaddress1}" required>
                <label for="inputAddress1">{$LANG.clientareaaddress1}</label>
            </div>
        </div>
        
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-city"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="city" class="form-control" id="inputCity" placeholder="City" value="{$clientcity}" required>
                        <label for="inputCity">{$LANG.clientareacity}</label>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-map"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="state" class="form-control" id="inputState" placeholder="State/Region" value="{$clientstate}" required>
                        <label for="inputState">{$LANG.clientareastate}</label>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-mail-bulk"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="postcode" class="form-control" id="inputPostcode" placeholder="Zip/Postcode" value="{$clientpostcode}" required>
                        <label for="inputPostcode">{$LANG.clientareapostcode}</label>
                    </div>
                </div>
            </div>
            
            <div class="col-12 mt-3">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-globe"></i></div>
                    <div class="form-floating flex-grow-1">
                        <select name="country" class="form-select" id="inputCountry">
                            {foreach $clientcountries as $countryCode => $countryName}
                                <option value="{$countryCode}"{if (!$clientcountry && $countryCode eq $defaultCountry) || ($countryCode eq $clientcountry)} selected="selected"{/if}>
                                    {$countryName}
                                </option>
                            {/foreach}
                        </select>
                        <label for="inputCountry">{$LANG.clientareacountry}</label>
                    </div>
                </div>
            </div>
        </div>
        
        <h6 class="text-muted small text-uppercase fw-bold mt-4 mb-3">Account Security</h6>
        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-lock"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="password" name="password" class="form-control" id="inputPassword" placeholder="Password" autocomplete="off" required>
                        <label for="inputPassword">{$LANG.clientareapassword}</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-lock"></i></div>
                    <div class="form-floating flex-grow-1">
                        <!-- CRITICAL: Input MUST be named password2, not confirmpw -->
                        <input type="password" name="password2" class="form-control" id="inputPasswordConfirm" placeholder="Confirm" autocomplete="off" required>
                        <label for="inputPasswordConfirm">{$LANG.confirmpassword}</label>
                    </div>
                </div>
            </div>
        </div>

        {if $accepttos}
            <div class="form-check mb-4 small text-muted">
                <input type="checkbox" name="accepttos" class="form-check-input" id="accepttos" required>
                <label class="form-check-label" for="accepttos">
                    {$LANG.ordertosagreement} <a href="{$tosurl}" target="_blank" class="text-decoration-underline text-danger">{$LANG.ordertos}</a>
                </label>
            </div>
        {/if}

        <button type="submit" class="btn btn-auth-primary w-100">
            <span>Create Account</span>
            <i class="fas fa-rocket ms-2"></i>
        </button>
    </form>

    <!-- Divider -->
    <div class="auth-divider">
        <span>or</span>
    </div>

    <!-- Login CTA -->
    <a href="{$WEB_ROOT}/login.php" class="btn btn-auth-outline w-100">
        <i class="fas fa-sign-in-alt me-2"></i>Sign In to Existing Account
    </a>

    <!-- Trust Badges -->
    <div class="auth-trust-badges">
        <div class="trust-item"><i class="fas fa-shield-halved"></i><span>256-bit SSL</span></div>
        <div class="trust-item"><i class="fas fa-lock"></i><span>Secure</span></div>
        <div class="trust-item"><i class="fas fa-headset"></i><span>24/7 Support</span></div>
    </div>
</div>
