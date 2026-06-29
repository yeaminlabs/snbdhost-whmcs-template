<!-- ====== LOGIN PAGE — SNBD HOST BRAND ====== -->
<style>
/* ── SNBD HOST Brand Tokens ── */
:root {
    --snbd-red:         #BA1114;
    --snbd-red-hover:   #9E0D10;
    --snbd-red-light:   rgba(186,17,20,0.08);
    --snbd-red-border:  rgba(186,17,20,0.20);
    --snbd-bg-body:     #F7F7F4;
    --snbd-surface:     #ffffff;
    --snbd-text-1:      #1a1a1a;
    --snbd-text-2:      #555555;
    --snbd-text-muted:  #999999;
    --snbd-border:      #e0e0e0;
    --snbd-border-sub:  #eeeeee;
    --snbd-font:        'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

/* ── Auth page reset ── */
.auth-page {
    background: var(--snbd-bg-body) !important;
    min-height: 100vh;
    display: flex;
    align-items: stretch;
    font-family: var(--snbd-font);
}
#particles-js { display: none !important; }

/* ── Split Layout ── */
.login-split {
    display: flex;
    width: 100%;
    min-height: 100vh;
}

/* ──────────────────────────────────────────
   LEFT PANEL — Brand dark panel
   ────────────────────────────────────────── */
.login-left {
    flex: 1;
    background: linear-gradient(160deg, #0f0f0f 0%, #1a0304 50%, #250507 80%, #2e0608 100%);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 3rem 3.5rem;
    position: relative;
    overflow: hidden;
    color: #ffffff;
}

/* Grid overlay */
.login-left-grid {
    position: absolute;
    inset: 0;
    background-image:
        linear-gradient(rgba(255,255,255,0.025) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.025) 1px, transparent 1px);
    background-size: 36px 36px;
    pointer-events: none;
}

/* Orbs */
.orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(70px);
    pointer-events: none;
}
.orb-1 {
    width: 380px; height: 380px;
    background: radial-gradient(circle, rgba(186,17,20,0.45), rgba(186,17,20,0.05));
    top: -120px; right: -120px;
}
.orb-2 {
    width: 220px; height: 220px;
    background: radial-gradient(circle, rgba(186,17,20,0.3), transparent);
    bottom: 60px; left: -60px;
}
.orb-3 {
    width: 140px; height: 140px;
    background: radial-gradient(circle, rgba(255,200,200,0.15), transparent);
    top: 45%; right: 8%;
}

/* Logo */
.login-logo-wrap {
    position: relative;
    z-index: 2;
    margin-bottom: 0;
}
.login-logo-wrap img {
    max-height: 36px;
    width: auto;
    filter: brightness(0) invert(1);
}

/* Brand section */
.login-brand {
    position: relative;
    z-index: 2;
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 3rem 0;
    animation: slide-up 0.7s cubic-bezier(0.22,1,0.36,1) both;
}
.login-brand-badge {
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
    width: fit-content;
}
.login-brand-title {
    font-size: clamp(2.2rem, 3.5vw, 3.2rem);
    font-weight: 900;
    color: #ffffff;
    line-height: 1.08;
    letter-spacing: -0.04em;
    margin-bottom: 1.25rem;
}
.login-brand-title span {
    background: linear-gradient(135deg, #ff5555, #ff9090);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.login-brand-desc {
    font-size: 0.95rem;
    color: rgba(255,255,255,0.6);
    line-height: 1.75;
    max-width: 380px;
    margin-bottom: 2.5rem;
}
.login-features {
    display: flex;
    flex-direction: column;
    gap: 0.85rem;
}
.login-feature-item {
    display: flex;
    align-items: center;
    gap: 0.85rem;
    color: rgba(255,255,255,0.75);
    font-size: 0.875rem;
    font-weight: 500;
}
.login-feature-icon {
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
.login-stats {
    display: flex;
    gap: 2rem;
    padding-top: 2rem;
    border-top: 1px solid rgba(255,255,255,0.08);
    position: relative;
    z-index: 2;
}
.login-stat-item { text-align: left; }
.login-stat-num {
    font-size: 1.5rem;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: -0.03em;
    line-height: 1;
}
.login-stat-label {
    font-size: 0.7rem;
    color: rgba(255,255,255,0.45);
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-top: 0.2rem;
}

/* ── Right Panel (Form) ── */
.login-right {
    width: 460px;
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 3rem 2.5rem;
    background: var(--snbd-bg-body);
    position: relative;
}

.login-form-wrap {
    position: relative;
    z-index: 2;
    background: var(--snbd-surface);
    border-radius: 12px;
    border: 1px solid var(--snbd-border);
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
    padding: 2.5rem;
    animation: slide-in-right 0.6s cubic-bezier(0.22,1,0.36,1) both;
}

@keyframes slide-in-right {
    from { opacity: 0; transform: translateX(24px); }
    to   { opacity: 1; transform: translateX(0); }
}
@keyframes slide-up {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
}
@keyframes fade-in {
    from { opacity: 0; }
    to   { opacity: 1; }
}

/* Form headline */
.form-headline {
    font-size: 1.8rem;
    font-weight: 800;
    color: var(--snbd-text-1);
    letter-spacing: -0.04em;
    line-height: 1.1;
    margin-bottom: 0.35rem;
}
.form-headline-accent {
    color: var(--snbd-red);
}
.form-subhead {
    font-size: 0.875rem;
    color: var(--snbd-text-muted);
    margin-bottom: 1.75rem;
}

/* Tabs */
.auth-clean-tabs {
    display: inline-flex;
    background: #f0f0f0;
    border-radius: 50rem;
    padding: 0.25rem;
    margin-bottom: 1.75rem;
}
.auth-clean-tab {
    padding: 0.5rem 1.2rem;
    font-weight: 600;
    font-size: 0.85rem;
    color: var(--snbd-text-muted);
    border-radius: 50rem;
    text-decoration: none;
    transition: all 0.2s;
}
.auth-clean-tab.active {
    background: var(--snbd-surface);
    color: var(--snbd-text-1);
    box-shadow: 0 2px 8px rgba(0,0,0,0.07);
}
.auth-clean-tab:hover:not(.active) { color: var(--snbd-text-1); }

/* Input label */
.auth-input-label {
    display: block;
    font-size: 0.78rem;
    font-weight: 600;
    color: var(--snbd-text-2);
    margin-bottom: 0.35rem;
    text-transform: uppercase;
    letter-spacing: 0.3px;
}

/* Input wrap */
.auth-input-wrap {
    position: relative;
    margin-bottom: 1rem;
}
.auth-input-icon {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #cccccc;
    font-size: 0.875rem;
    pointer-events: none;
    z-index: 2;
    display: flex !important;
    align-items: center;
    width: auto !important;
    height: auto !important;
    border-right: none !important;
    background: transparent !important;
    transition: color 0.2s;
}

/* Inputs */
.auth-clean-input {
    background-color: var(--snbd-surface) !important;
    border: 1px solid var(--snbd-border) !important;
    border-radius: 7px !important;
    padding: 0.8rem 1rem 0.8rem 2.75rem !important;
    font-size: 0.9rem !important;
    font-weight: 400 !important;
    color: var(--snbd-text-1) !important;
    height: auto !important;
    box-shadow: none !important;
    transition: border-color 0.15s, box-shadow 0.15s !important;
    width: 100%;
    font-family: var(--snbd-font) !important;
}
.auth-clean-input::placeholder {
    color: var(--snbd-text-muted) !important;
}
.auth-clean-input:focus {
    background-color: var(--snbd-surface) !important;
    border-color: var(--snbd-red) !important;
    box-shadow: 0 0 0 3px rgba(186,17,20,0.1) !important;
    outline: none !important;
}
.auth-input-wrap:focus-within .auth-input-icon { color: var(--snbd-red); }
.auth-clean-input:-webkit-autofill,
.auth-clean-input:-webkit-autofill:hover,
.auth-clean-input:-webkit-autofill:focus {
    -webkit-box-shadow: 0 0 0 1000px var(--snbd-surface) inset !important;
    -webkit-text-fill-color: var(--snbd-text-1) !important;
}

/* Password toggle */
.auth-pw-toggle {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: #cccccc;
    cursor: pointer;
    padding: 0;
    font-size: 0.85rem;
    transition: color 0.2s;
    z-index: 2;
}
.auth-pw-toggle:hover { color: var(--snbd-red); }

/* Checkbox */
.form-check-input {
    border: 1.5px solid var(--snbd-border) !important;
    background-color: var(--snbd-surface) !important;
    border-radius: 4px !important;
    width: 1.1em !important;
    height: 1.1em !important;
    cursor: pointer !important;
    margin-top: 0.15em !important;
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

/* Forgot link */
.auth-link { color: var(--snbd-text-muted); font-weight: 500; text-decoration: none; transition: color 0.2s; font-size: 0.83rem; }
.auth-link:hover { color: var(--snbd-red); }

/* Submit button */
.auth-clean-btn {
    background: var(--snbd-red);
    color: #ffffff;
    font-weight: 600;
    font-size: 1rem;
    border-radius: 50rem;
    padding: 0.9rem 2rem;
    border: none;
    transition: all 0.2s;
    box-shadow: 0 4px 14px rgba(186,17,20,0.25);
    width: 100%;
    cursor: pointer;
    font-family: var(--snbd-font);
    position: relative;
    overflow: hidden;
}
.auth-clean-btn::before {
    content: '';
    position: absolute;
    top: 0; left: -100%;
    width: 100%; height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.12), transparent);
    transition: left 0.5s;
}
.auth-clean-btn:hover::before { left: 100%; }
.auth-clean-btn:hover {
    background: var(--snbd-red-hover);
    transform: translateY(-1px);
    box-shadow: 0 8px 24px rgba(186,17,20,0.3);
    color: #ffffff;
}
.auth-clean-btn:active { transform: translateY(0); }

/* Trust row */
.auth-trust-row {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.5rem;
    margin-top: 1.5rem;
    padding-top: 1.25rem;
    border-top: 1px solid var(--snbd-border-sub);
}
.auth-trust-item {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.72rem;
    color: var(--snbd-text-muted);
    font-weight: 500;
}
.auth-trust-item i { color: var(--snbd-red); font-size: 0.72rem; }

/* Alert */
.auth-alert {
    background: rgba(186,17,20,0.07);
    border: 1px solid rgba(186,17,20,0.18);
    color: var(--snbd-red);
    font-weight: 600;
    font-size: 0.875rem;
    border-radius: 8px;
    padding: 0.75rem 1rem;
    margin-bottom: 1.25rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    animation: shake 0.4s ease;
}
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    20%       { transform: translateX(-5px); }
    40%       { transform: translateX(5px); }
    60%       { transform: translateX(-3px); }
    80%       { transform: translateX(3px); }
}

/* Responsive */
@media (max-width: 900px) {
    .login-left { display: none; }
    .login-right {
        width: 100%;
        padding: 2rem 1.25rem;
        align-items: center;
        justify-content: center;
    }
    .login-form-wrap { width: 100%; max-width: 420px; }
}
</style>

<div class="login-split">

    <!-- ===== LEFT: Branding Panel ===== -->
    <div class="login-left">
        <div class="login-left-grid"></div>
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>
        <div class="orb orb-3"></div>

        <!-- Logo -->
        <div class="login-logo-wrap">
            <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" />
        </div>

        <div class="login-brand">
            <div class="login-brand-badge">
                <i class="fas fa-shield-alt"></i> Trusted by 10,000+ Clients
            </div>
            <h2 class="login-brand-title">
                Bangladesh's #1<br><span>Web Hosting</span><br>Provider
            </h2>
            <p class="login-brand-desc">
                Manage hosting, domains, billing, and support from one powerful dashboard built for speed and simplicity.
            </p>

            <div class="login-features">
                <div class="login-feature-item">
                    <div class="login-feature-icon"><i class="fas fa-server"></i></div>
                    NVMe SSD + AMD EPYC Powered Servers
                </div>
                <div class="login-feature-item">
                    <div class="login-feature-icon"><i class="fas fa-globe"></i></div>
                    Domain Registration &amp; Full DNS Control
                </div>
                <div class="login-feature-item">
                    <div class="login-feature-icon"><i class="fas fa-headset"></i></div>
                    24/7 Expert Support, Always Ready
                </div>
            </div>
        </div>

        <div class="login-stats">
            <div class="login-stat-item">
                <div class="login-stat-num">10K+</div>
                <div class="login-stat-label">Happy Clients</div>
            </div>
            <div class="login-stat-item">
                <div class="login-stat-num">99.9%</div>
                <div class="login-stat-label">Uptime SLA</div>
            </div>
            <div class="login-stat-item">
                <div class="login-stat-num">24/7</div>
                <div class="login-stat-label">Support</div>
            </div>
        </div>
    </div>

    <!-- ===== RIGHT: Login Form ===== -->
    <div class="login-right">
        <div class="login-form-wrap">

            <!-- Header -->
            <div style="margin-bottom: 0.25rem;">
                <div class="form-headline">Welcome <span class="form-headline-accent">Back.</span></div>
                <div class="form-subhead">Sign in to your SNBD HOST client portal</div>
            </div>

            <!-- Tabs -->
            <div class="auth-clean-tabs" style="margin-top:1.25rem;">
                <a href="{$WEB_ROOT}/login.php" class="auth-clean-tab active">Sign In</a>
                <a href="{$WEB_ROOT}/register.php" class="auth-clean-tab">Create Account</a>
            </div>

            <!-- Error Messages -->
            {if $incorrect}
                <div class="auth-alert">
                    <i class="fas fa-exclamation-circle"></i> {$LANG.loginincorrect}
                </div>
            {elseif $invalid}
                <div class="auth-alert">
                    <i class="fas fa-exclamation-circle"></i> {$LANG.logininvalid}
                </div>
            {/if}

            <div class="providerLinking mb-4 mt-3" data-link-context="registration">
                {include file="$template/includes/linkedaccounts.tpl" linkContext="registration" customFeedback=true}
            </div>

            <!-- Form -->
            <form method="post" action="{$WEB_ROOT}/dologin.php" class="needs-validation login-form" role="form" id="frmLogin" novalidate>
                <input type="hidden" name="token" value="{$token}" />

                <!-- Email -->
                <div style="margin-bottom: 1rem;">
                    <label class="auth-input-label" for="inputEmail">Email Address</label>
                    <div class="auth-input-wrap">
                        <input type="email" name="username" class="form-control auth-clean-input" id="inputEmail" placeholder="you@example.com" autofocus required>
                        <span class="auth-input-icon"><i class="fas fa-envelope"></i></span>
                    </div>
                </div>

                <!-- Password -->
                <div style="margin-bottom: 1.25rem;">
                    <label class="auth-input-label" for="inputPassword">Password</label>
                    <div class="auth-input-wrap">
                        <input type="password" name="password" class="form-control auth-clean-input" id="inputPassword" placeholder="Your password" autocomplete="off" required>
                        <span class="auth-input-icon"><i class="fas fa-lock"></i></span>
                        <button type="button" class="auth-pw-toggle" id="togglePw" aria-label="Show/hide password">
                            <i class="fas fa-eye" id="togglePwIcon"></i>
                        </button>
                    </div>
                </div>

                <!-- Remember me + Forgot -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check d-flex align-items-center gap-2">
                        <input type="checkbox" class="form-check-input" name="rememberme" id="rememberme">
                        <label class="form-check-label small fw-semibold" for="rememberme" style="color:#666666; cursor:pointer;">{$LANG.loginrememberme}</label>
                    </div>
                    <a href="pwreset.php" class="auth-link">
                        <i class="fas fa-key me-1" style="font-size:0.7rem;"></i>{$LANG.forgotpw}
                    </a>
                </div>

                <!-- Captcha -->
                {if $captcha}
                    <div style="margin-bottom: 1.25rem;">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                {/if}

                <!-- Submit -->
                <button id="login" type="submit" class="auth-clean-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                    Sign In to Dashboard &nbsp;<i class="fas fa-arrow-right" style="font-size:0.85em;"></i>
                </button>
            </form>

            <!-- Trust Row -->
            <div class="auth-trust-row">
                <div class="auth-trust-item">
                    <i class="fas fa-lock"></i> SSL Secured
                </div>
                <div class="auth-trust-item">
                    <i class="fas fa-shield-alt"></i> 2FA Ready
                </div>
                <div class="auth-trust-item">
                    <i class="fas fa-user-shield"></i> Privacy Safe
                </div>
            </div>

            <div class="mt-3 text-center" style="font-size:0.78rem; color:var(--snbd-text-muted);">
                Don't have an account?
                <a href="{$WEB_ROOT}/register.php" style="color:var(--snbd-red); font-weight:600; text-decoration:none;">Create one free</a>
            </div>
        </div>
    </div>
</div>

<script>
// Password show/hide toggle
(function() {
    var btn  = document.getElementById('togglePw');
    var inp  = document.getElementById('inputPassword');
    var icon = document.getElementById('togglePwIcon');
    if (btn && inp && icon) {
        btn.addEventListener('click', function() {
            var isPass = inp.type === 'password';
            inp.type   = isPass ? 'text' : 'password';
            icon.className = isPass ? 'fas fa-eye-slash' : 'fas fa-eye';
        });
    }
})();
</script>

{* ── If Google OAuth has returned a new user who needs to register, redirect instantly ── *}
{if $linkedaccounts}
    {foreach $linkedaccounts as $la}
        {if $la.pending || !$la.accountid}
            <script>window.location.replace("{$WEB_ROOT}/register.php");</script>
        {/if}
    {/foreach}
{/if}

{* Smarty-side catch: if WHMCS signalled an OAuth pending registration via template vars *}
{if $linkedaccountpendingregistration || $oauthPendingRegistration}
    <script>window.location.replace("{$WEB_ROOT}/register.php");</script>
{/if}

<script>
// ── Safety Net: Detect WHMCS "Account not found" error on login page and push to register ──
document.addEventListener("DOMContentLoaded", function() {
    function checkSocialError() {
        var alerts = document.querySelectorAll('.providerLinking .alert, .providerLinking .social-login-error, .auth-alert');
        for (var i = 0; i < alerts.length; i++) {
            var text = alerts[i].innerText.toLowerCase();
            if (text.includes('could not find') || text.includes('not find an account') || text.includes('register a new account')) {
                // WHMCS couldn't log them in because they don't exist. Push to register and auto-click Google.
                window.location.replace("{$WEB_ROOT}/register.php?auto_google=1");
                return true;
            }
        }
        return false;
    }
    
    if (!checkSocialError()) {
        // Watch for AJAX changes in case the error is injected dynamically
        var targetNode = document.querySelector('.providerLinking');
        if (targetNode) {
            var observer = new MutationObserver(function() { checkSocialError(); });
            observer.observe(targetNode, { childList: true, subtree: true });
        }
    }
});
</script>
