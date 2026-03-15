<!-- ====== PASSWORD RESET PAGE ====== -->
<div class="auth-card">
    <div class="auth-accent-line"></div>

    <!-- Logo -->
    <div class="auth-logo-block">
        <div class="auth-logo-icon">
            <i class="fas fa-server"></i>
        </div>
        <div class="auth-logo-text">{$companyname}</div>
    </div>

    <div class="text-center mb-4">
        <div class="auth-icon-circle mb-3">
            <i class="fas fa-key"></i>
        </div>
        <h2 class="h5 fw-semibold">{$LANG.pwreset}</h2>
        <p class="small mb-0" style="color: var(--text-muted);">{$LANG.pwresetemailneeded}</p>
    </div>

    {if $success}
        <div class="alert alert-success py-2 text-center small">
            <i class="fas fa-check-circle me-1"></i>{$LANG.pwresetvalidationsent}
        </div>
    {else}
        {if $errormessage}
            <div class="alert alert-danger py-2 text-center small mb-3">
                <i class="fas fa-exclamation-circle me-1"></i>{$errormessage}
            </div>
        {/if}
        <form method="post" action="{$systemurl}pwreset.php" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="reset" />
            <div class="auth-input-group mb-4">
                <div class="auth-input-icon"><i class="fas fa-envelope"></i></div>
                <div class="form-floating flex-grow-1">
                    <input type="email" name="email" class="form-control" id="inputEmail" placeholder="Email" autofocus required>
                    <label for="inputEmail">{$LANG.loginemail}</label>
                </div>
            </div>
            <button type="submit" class="btn btn-auth-primary w-100">
                <span>{$LANG.pwresetsubmit}</span>
                <i class="fas fa-paper-plane ms-2"></i>
            </button>
        </form>
    {/if}

    <div class="auth-divider">
        <span>or</span>
    </div>

    <a href="{$WEB_ROOT}/login.php" class="btn btn-auth-outline w-100">
        <i class="fas fa-arrow-left me-2"></i>Back to Sign In
    </a>
</div>
