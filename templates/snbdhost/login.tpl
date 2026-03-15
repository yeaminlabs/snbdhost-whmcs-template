<!-- ====== LOGIN PAGE ====== -->
<div class="auth-card">
    <!-- Glowing accent line at top -->
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
        <a href="{$WEB_ROOT}/login.php" class="auth-tab active">Sign In</a>
        <a href="{$WEB_ROOT}/register.php" class="auth-tab">Create Account</a>
    </div>

    <!-- Error Messages -->
    {if $incorrect}
        <div class="alert alert-danger py-2 text-center small mb-3">
            <i class="fas fa-exclamation-circle me-1"></i>{$LANG.loginincorrect}
        </div>
    {elseif $verificationId && empty($transientData.Name)}
        <div class="alert alert-danger py-2 text-center small mb-3">
            <i class="fas fa-exclamation-circle me-1"></i>{$LANG.verificationKeyExpired}
        </div>
    {elseif $ssoredirect}
        <div class="alert alert-info py-2 text-center small mb-3">
            <i class="fas fa-info-circle me-1"></i>{$LANG.sso.redirectafterlogin}
        </div>
    {elseif $invalid}
        <div class="alert alert-danger py-2 text-center small mb-3">
            <i class="fas fa-exclamation-circle me-1"></i>{$LANG.logininvalid}
        </div>
    {/if}

    <!-- Login Form -->
    <form method="post" action="{$systemurl}dologin.php" class="needs-validation" novalidate>
        <div class="auth-input-group">
            <div class="auth-input-icon"><i class="fas fa-envelope"></i></div>
            <div class="form-floating flex-grow-1">
                <input type="email" name="username" class="form-control" id="inputEmail" placeholder="Email" autofocus required>
                <label for="inputEmail">{$LANG.clientareaemail}</label>
            </div>
        </div>

        <div class="auth-input-group">
            <div class="auth-input-icon"><i class="fas fa-lock"></i></div>
            <div class="form-floating flex-grow-1">
                <input type="password" name="password" class="form-control" id="inputPassword" placeholder="Password" autocomplete="off" required>
                <label for="inputPassword">{$LANG.clientareapassword}</label>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
                <input type="checkbox" class="form-check-input" name="rememberme" id="rememberme">
                <label class="form-check-label small" for="rememberme">{$LANG.loginrememberme}</label>
            </div>
            <a href="pwreset.php" class="small auth-link">{$LANG.forgotpw}</a>
        </div>

        <button id="login" type="submit" class="btn btn-auth-primary w-100">
            <span>Sign In</span>
            <i class="fas fa-arrow-right ms-2"></i>
        </button>
    </form>

    <!-- Divider -->
    <div class="auth-divider">
        <span>or</span>
    </div>

    <!-- Register CTA -->
    <a href="{$WEB_ROOT}/register.php" class="btn btn-auth-outline w-100">
        <i class="fas fa-user-plus me-2"></i>Create a New Account
    </a>

    <!-- Trust Badges -->
    <div class="auth-trust-badges">
        <div class="trust-item"><i class="fas fa-shield-halved"></i><span>256-bit SSL</span></div>
        <div class="trust-item"><i class="fas fa-lock"></i><span>Secure Login</span></div>
        <div class="trust-item"><i class="fas fa-headset"></i><span>24/7 Support</span></div>
    </div>
</div>
