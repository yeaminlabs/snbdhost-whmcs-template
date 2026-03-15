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
    <form method="post" action="{$systemurl}register.php" class="needs-validation" novalidate>
        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-user"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="firstname" class="form-control" id="inputFirstName" placeholder="First Name" required>
                        <label for="inputFirstName">{$LANG.clientareafirstname}</label>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="auth-input-group">
                    <div class="auth-input-icon"><i class="fas fa-user"></i></div>
                    <div class="form-floating flex-grow-1">
                        <input type="text" name="lastname" class="form-control" id="inputLastName" placeholder="Last Name" required>
                        <label for="inputLastName">{$LANG.clientarealastname}</label>
                    </div>
                </div>
            </div>
        </div>

        <div class="auth-input-group mb-3">
            <div class="auth-input-icon"><i class="fas fa-envelope"></i></div>
            <div class="form-floating flex-grow-1">
                <input type="email" name="email" class="form-control" id="inputEmail" placeholder="Email" required>
                <label for="inputEmail">{$LANG.clientareaemail}</label>
            </div>
        </div>

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
                        <input type="password" name="confirmpw" class="form-control" id="inputPasswordConfirm" placeholder="Confirm" autocomplete="off" required>
                        <label for="inputPasswordConfirm">{$LANG.confirmpassword}</label>
                    </div>
                </div>
            </div>
        </div>

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
