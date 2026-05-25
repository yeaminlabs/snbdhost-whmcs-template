<!-- ====== LOGIN PAGE ====== -->
<style>
.auth-page { background: #ffffff !important; }
#particles-js { display: none !important; }
.auth-clean-card {
    width: 100%; max-width: 480px;
    margin: 0 auto;
    padding: 3rem 1.5rem;
    text-align: center;
}
.auth-headline {
    font-size: 3rem;
    font-weight: 900;
    color: #111111;
    letter-spacing: -0.04em;
    line-height: 1.1;
    margin-bottom: 0.5rem;
}
.auth-headline-accent {
    color: #CC0000;
}
.auth-subhead {
    font-size: 1.15rem;
    color: #555555;
    font-weight: 500;
    margin-bottom: 2.5rem;
}
.auth-clean-input {
    background-color: #f9f9f9 !important;
    border: 1px solid #eeeeee !important;
    border-radius: 12px !important;
    padding: 1.25rem 1rem !important;
    font-size: 1.1rem !important;
    font-weight: 500 !important;
    color: #111111 !important;
    height: auto !important;
    box-shadow: none !important;
    transition: all 0.2s !important;
}
.auth-clean-input::placeholder {
    color: #666666 !important;
    opacity: 1 !important;
}
.auth-clean-input:focus {
    background-color: #ffffff !important;
    border-color: #CC0000 !important;
    box-shadow: 0 0 0 4px rgba(204,0,0,0.1) !important;
}
/* Prevent browser autofill from breaking style consistency */
.auth-clean-input:-webkit-autofill,
.auth-clean-input:-webkit-autofill:hover, 
.auth-clean-input:-webkit-autofill:focus, 
.auth-clean-input:-webkit-autofill:active {
    -webkit-box-shadow: 0 0 0 1000px #f9f9f9 inset !important;
    -webkit-text-fill-color: #111111 !important;
    transition: background-color 5000s ease-in-out 0s !important;
}
/* Style checkboxes properly with high contrast and custom border */
.form-check-input {
    border: 1.5px solid #cccccc !important;
    background-color: #ffffff !important;
    border-radius: 6px !important;
    width: 1.2em !important;
    height: 1.2em !important;
    cursor: pointer !important;
    margin-top: 0.15em !important;
    transition: all 0.2s !important;
}
.form-check-input:checked {
    background-color: #CC0000 !important;
    border-color: #CC0000 !important;
}
.form-check-input:focus {
    box-shadow: 0 0 0 3px rgba(204,0,0,0.15) !important;
    border-color: #CC0000 !important;
}
.auth-clean-btn {
    background: #CC0000;
    color: #ffffff;
    font-weight: 700;
    font-size: 1.15rem;
    border-radius: 50rem;
    padding: 1rem 2rem;
    border: none;
    transition: all 0.2s;
    box-shadow: 0 8px 24px rgba(204,0,0,0.25);
    width: 100%;
}
.auth-clean-btn:hover {
    background: #AA0000;
    transform: translateY(-2px);
    box-shadow: 0 12px 32px rgba(204,0,0,0.3);
    color: #ffffff;
}
.auth-clean-tabs {
    display: inline-flex;
    background: #f5f5f5;
    border-radius: 50rem;
    padding: 0.25rem;
    margin-bottom: 2rem;
}
.auth-clean-tab {
    padding: 0.6rem 1.5rem;
    font-weight: 600;
    font-size: 0.95rem;
    color: #555555;
    border-radius: 50rem;
    text-decoration: none;
    transition: all 0.2s;
}
.auth-clean-tab.active {
    background: #ffffff;
    color: #111111;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}
.auth-clean-tab:hover:not(.active) {
    color: #111111;
}
.auth-link { color: #555555; font-weight: 500; text-decoration: none; transition: color 0.2s; }
.auth-link:hover { color: #CC0000; }
</style>

<div class="auth-clean-card">
    <div style="margin-bottom:2rem;">
        <span style="display:inline-flex; align-items:center; gap:0.5rem; background:rgba(204,0,0,0.08); color:#CC0000; padding:0.4rem 1rem; border-radius:50rem; font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:1px;">
            <i class="fas fa-lock"></i> Secure Portal
        </span>
    </div>

    <h1 class="auth-headline">Welcome <span class="auth-headline-accent">Back.</span></h1>
    <p class="auth-subhead">Manage your hosting & domains securely.</p>

    <div class="auth-clean-tabs">
        <a href="{$WEB_ROOT}/login.php" class="auth-clean-tab active">Sign In</a>
        <a href="{$WEB_ROOT}/register.php" class="auth-clean-tab">Create Account</a>
    </div>

    {if $incorrect}
        <div class="alert alert-danger py-2 text-center small mb-4 rounded-3 border-0" style="background:rgba(204,0,0,0.1); color:#CC0000; font-weight:600;"><i class="fas fa-exclamation-circle me-1"></i>{$LANG.loginincorrect}</div>
    {elseif $invalid}
        <div class="alert alert-danger py-2 text-center small mb-4 rounded-3 border-0" style="background:rgba(204,0,0,0.1); color:#CC0000; font-weight:600;"><i class="fas fa-exclamation-circle me-1"></i>{$LANG.logininvalid}</div>
    {/if}

    <form method="post" action="{$WEB_ROOT}/dologin.php" class="needs-validation login-form text-start" role="form" id="frmLogin">
        <input type="hidden" name="token" value="{$token}" />
        
        <div class="mb-3">
            <input type="email" name="username" class="form-control auth-clean-input" id="inputEmail" placeholder="{$LANG.clientareaemail}" autofocus required>
        </div>

        <div class="mb-4">
            <input type="password" name="password" class="form-control auth-clean-input" id="inputPassword" placeholder="{$LANG.clientareapassword}" autocomplete="off" required>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 px-2">
            <div class="form-check d-flex align-items-start gap-2">
                <input type="checkbox" class="form-check-input" name="rememberme" id="rememberme">
                <label class="form-check-label small fw-semibold ms-1" for="rememberme" style="margin-top: 2px; color: #444444 !important; line-height: 1.3;">{$LANG.loginrememberme}</label>
            </div>
            <a href="pwreset.php" class="small auth-link">{$LANG.forgotpw}</a>
        </div>

        <button id="login" type="submit" class="auth-clean-btn">
            Sign In to Dashboard <i class="fas fa-arrow-right ms-2" style="font-size:0.9em;"></i>
        </button>
    </form>
    
    <div class="mt-5 text-muted small fw-medium">
        Powered by <a href="{$WEB_ROOT}/" class="text-dark fw-bold text-decoration-none">SNBD HOST</a>
    </div>
</div>
