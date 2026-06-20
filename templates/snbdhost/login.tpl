<!-- ====== LOGIN PAGE ====== -->
<style>
/* ── Reset & Base ── */
.auth-page {
    background: #ffffff !important;
    min-height: 100vh;
    display: flex;
    align-items: stretch;
}
#particles-js { display: none !important; }

/* ── Split Layout ── */
.login-split {
    display: flex;
    width: 100%;
    min-height: 100vh;
}

/* ── Left Panel (Branding) ── */
.login-left {
    flex: 1;
    background: linear-gradient(135deg, #0a0a0a 0%, #1a0000 40%, #2d0000 70%, #CC0000 100%);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    padding: 4rem;
    position: relative;
    overflow: hidden;
}
.login-left::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse at 30% 50%, rgba(204,0,0,0.35) 0%, transparent 65%),
                radial-gradient(ellipse at 80% 20%, rgba(255,60,60,0.15) 0%, transparent 50%);
    pointer-events: none;
}

/* Floating Orbs */
.orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(60px);
    opacity: 0.4;
    animation: float-orb 8s ease-in-out infinite;
}
.orb-1 {
    width: 320px; height: 320px;
    background: radial-gradient(circle, #ff3333, #CC0000);
    top: -80px; right: -60px;
    animation-delay: 0s;
}
.orb-2 {
    width: 200px; height: 200px;
    background: radial-gradient(circle, #ff6666, #cc3300);
    bottom: 10%; left: 10%;
    animation-delay: -3s;
}
.orb-3 {
    width: 140px; height: 140px;
    background: radial-gradient(circle, #ffffff, #ffcccc);
    top: 45%; right: 8%;
    opacity: 0.12;
    animation-delay: -5s;
}
@keyframes float-orb {
    0%, 100% { transform: translateY(0) scale(1); }
    50%       { transform: translateY(-30px) scale(1.08); }
}

/* Grid pattern overlay */
.login-left-grid {
    position: absolute;
    inset: 0;
    background-image:
        linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px);
    background-size: 40px 40px;
    pointer-events: none;
}

.login-brand {
    position: relative;
    z-index: 2;
    animation: slide-up 0.8s cubic-bezier(0.22,1,0.36,1) both;
}
.login-brand-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.15);
    color: rgba(255,255,255,0.85);
    padding: 0.4rem 1rem;
    border-radius: 50rem;
    font-size: 0.72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    margin-bottom: 2rem;
    backdrop-filter: blur(10px);
}
.login-brand-title {
    font-size: clamp(2.8rem, 4vw, 4rem);
    font-weight: 900;
    color: #ffffff;
    line-height: 1.05;
    letter-spacing: -0.04em;
    margin-bottom: 1.25rem;
}
.login-brand-title span {
    background: linear-gradient(135deg, #ff6666, #ffaaaa);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}
.login-brand-desc {
    font-size: 1.05rem;
    color: rgba(255,255,255,0.6);
    font-weight: 400;
    line-height: 1.7;
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
    gap: 0.75rem;
    color: rgba(255,255,255,0.75);
    font-size: 0.9rem;
    font-weight: 500;
    animation: slide-up 0.8s cubic-bezier(0.22,1,0.36,1) both;
}
.login-feature-item:nth-child(1) { animation-delay: 0.15s; }
.login-feature-item:nth-child(2) { animation-delay: 0.25s; }
.login-feature-item:nth-child(3) { animation-delay: 0.35s; }
.login-feature-icon {
    width: 32px; height: 32px;
    background: rgba(204,0,0,0.3);
    border: 1px solid rgba(204,0,0,0.5);
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.8rem;
    color: #ff8888;
    flex-shrink: 0;
}

/* Stats row */
.login-stats {
    display: flex;
    gap: 2rem;
    margin-top: 3rem;
    padding-top: 2rem;
    border-top: 1px solid rgba(255,255,255,0.08);
    animation: fade-in 1s ease 0.5s both;
}
.login-stat-item { text-align: left; }
.login-stat-num {
    font-size: 1.6rem;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: -0.03em;
    line-height: 1;
}
.login-stat-label {
    font-size: 0.72rem;
    color: rgba(255,255,255,0.45);
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-top: 0.2rem;
}

/* ── Right Panel (Form) ── */
.login-right {
    width: 480px;
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 3.5rem 3rem;
    background: #ffffff;
    position: relative;
    overflow: hidden;
}
.login-right::before {
    content: '';
    position: absolute;
    top: -100px; right: -100px;
    width: 300px; height: 300px;
    background: radial-gradient(circle, rgba(204,0,0,0.04) 0%, transparent 70%);
    pointer-events: none;
}
.login-right::after {
    content: '';
    position: absolute;
    bottom: -80px; left: -80px;
    width: 250px; height: 250px;
    background: radial-gradient(circle, rgba(204,0,0,0.04) 0%, transparent 70%);
    pointer-events: none;
}

/* Form entrance animation */
.login-form-wrap {
    position: relative;
    z-index: 2;
    animation: slide-in-right 0.7s cubic-bezier(0.22,1,0.36,1) both;
}
@keyframes slide-in-right {
    from { opacity: 0; transform: translateX(30px); }
    to   { opacity: 1; transform: translateX(0); }
}
@keyframes slide-up {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
}
@keyframes fade-in {
    from { opacity: 0; }
    to   { opacity: 1; }
}

/* Shimmer on headline accent */
@keyframes shimmer {
    0%   { background-position: -200% center; }
    100% { background-position: 200% center; }
}
.form-headline-accent {
    background: linear-gradient(90deg, #CC0000 30%, #ff4444 50%, #CC0000 70%);
    background-size: 200% auto;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    animation: shimmer 3s linear infinite;
}

.form-headline {
    font-size: 2.2rem;
    font-weight: 900;
    color: #111111;
    letter-spacing: -0.04em;
    line-height: 1.1;
    margin-bottom: 0.4rem;
}
.form-subhead {
    font-size: 0.95rem;
    color: #888888;
    font-weight: 400;
    margin-bottom: 2rem;
}

/* Tabs */
.auth-clean-tabs {
    display: inline-flex;
    background: #f5f5f5;
    border-radius: 50rem;
    padding: 0.25rem;
    margin-bottom: 1.75rem;
}
.auth-clean-tab {
    padding: 0.55rem 1.3rem;
    font-weight: 600;
    font-size: 0.88rem;
    color: #888888;
    border-radius: 50rem;
    text-decoration: none;
    transition: all 0.25s cubic-bezier(0.4,0,0.2,1);
}
.auth-clean-tab.active {
    background: #ffffff;
    color: #111111;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
}
.auth-clean-tab:hover:not(.active) { color: #333333; }

/* Input fields */
.auth-input-wrap {
    position: relative;
    margin-bottom: 1rem;
}
.auth-input-icon {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #bbbbbb;
    font-size: 0.9rem;
    transition: color 0.2s;
    pointer-events: none;
    z-index: 2;
    display: flex !important;
    align-items: center;
    justify-content: center;
    width: auto !important;
    height: auto !important;
    border-right: none !important;
    background: transparent !important;
}
.auth-clean-input {
    background-color: #f8f8f8 !important;
    border: 1.5px solid #eeeeee !important;
    border-radius: 14px !important;
    padding: 1rem 1rem 1rem 2.8rem !important;
    font-size: 0.95rem !important;
    font-weight: 500 !important;
    color: #111111 !important;
    height: auto !important;
    box-shadow: none !important;
    transition: all 0.25s cubic-bezier(0.4,0,0.2,1) !important;
    width: 100%;
}
.auth-clean-input::placeholder {
    color: #aaaaaa !important;
    opacity: 1 !important;
}
.auth-clean-input:focus {
    background-color: #ffffff !important;
    border-color: #CC0000 !important;
    box-shadow: 0 0 0 4px rgba(204,0,0,0.08) !important;
    outline: none !important;
}
.auth-clean-input:focus + .auth-input-icon,
.auth-input-wrap:focus-within .auth-input-icon { color: #CC0000; }
.auth-clean-input:-webkit-autofill,
.auth-clean-input:-webkit-autofill:hover,
.auth-clean-input:-webkit-autofill:focus,
.auth-clean-input:-webkit-autofill:active {
    -webkit-box-shadow: 0 0 0 1000px #f8f8f8 inset !important;
    -webkit-text-fill-color: #111111 !important;
    transition: background-color 5000s ease-in-out 0s !important;
}

/* Password toggle */
.auth-pw-toggle {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: #bbbbbb;
    cursor: pointer;
    padding: 0;
    font-size: 0.85rem;
    transition: color 0.2s;
    z-index: 2;
}
.auth-pw-toggle:hover { color: #CC0000; }

/* Input label floating */
.auth-input-label {
    display: block;
    font-size: 0.78rem;
    font-weight: 600;
    color: #888888;
    margin-bottom: 0.35rem;
    letter-spacing: 0.3px;
    text-transform: uppercase;
}

/* Checkbox */
.form-check-input {
    border: 1.5px solid #dddddd !important;
    background-color: #ffffff !important;
    border-radius: 6px !important;
    width: 1.15em !important;
    height: 1.15em !important;
    cursor: pointer !important;
    margin-top: 0.15em !important;
    transition: all 0.2s !important;
}
.form-check-input:checked {
    background-color: #CC0000 !important;
    border-color: #CC0000 !important;
}
.form-check-input:focus {
    box-shadow: 0 0 0 3px rgba(204,0,0,0.12) !important;
    border-color: #CC0000 !important;
}

/* Forgot link */
.auth-link { color: #999999; font-weight: 500; text-decoration: none; transition: color 0.2s; font-size: 0.85rem; }
.auth-link:hover { color: #CC0000; }

/* Submit button */
.auth-clean-btn {
    background: linear-gradient(135deg, #CC0000 0%, #990000 100%);
    color: #ffffff;
    font-weight: 700;
    font-size: 1rem;
    border-radius: 14px;
    padding: 1rem 2rem;
    border: none;
    transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
    box-shadow: 0 8px 24px rgba(204,0,0,0.3), 0 2px 8px rgba(204,0,0,0.2);
    width: 100%;
    position: relative;
    overflow: hidden;
    cursor: pointer;
}
.auth-clean-btn::before {
    content: '';
    position: absolute;
    top: 0; left: -100%;
    width: 100%; height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
    transition: left 0.5s ease;
}
.auth-clean-btn:hover::before { left: 100%; }
.auth-clean-btn:hover {
    background: linear-gradient(135deg, #dd0000 0%, #aa0000 100%);
    transform: translateY(-2px);
    box-shadow: 0 16px 40px rgba(204,0,0,0.4), 0 4px 12px rgba(204,0,0,0.25);
    color: #ffffff;
}
.auth-clean-btn:active { transform: translateY(0); }

/* Divider */
.auth-or-divider {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin: 1.25rem 0;
    color: #cccccc;
    font-size: 0.78rem;
    font-weight: 600;
    letter-spacing: 0.5px;
}
.auth-or-divider::before, .auth-or-divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: #eeeeee;
}

/* Social / trust badge row */
.auth-trust-row {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.5rem;
    margin-top: 1.5rem;
    padding-top: 1.25rem;
    border-top: 1px solid #f0f0f0;
}
.auth-trust-item {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.72rem;
    color: #aaaaaa;
    font-weight: 500;
}
.auth-trust-item i { color: #CC0000; font-size: 0.75rem; }

/* Alert */
.auth-alert {
    background: rgba(204,0,0,0.07);
    border: 1px solid rgba(204,0,0,0.15);
    color: #CC0000;
    font-weight: 600;
    font-size: 0.88rem;
    border-radius: 12px;
    padding: 0.75rem 1rem;
    margin-bottom: 1.25rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    animation: shake 0.4s ease;
}
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    20%       { transform: translateX(-6px); }
    40%       { transform: translateX(6px); }
    60%       { transform: translateX(-4px); }
    80%       { transform: translateX(4px); }
}

/* Responsive */
@media (max-width: 900px) {
    .login-left { display: none; }
    .login-right {
        width: 100%;
        padding: 2.5rem 1.5rem;
        align-items: center;
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

        <div class="login-brand">
            <div class="login-brand-badge">
                <i class="fas fa-shield-alt"></i> Trusted Hosting Panel
            </div>
            <h2 class="login-brand-title">
                Everything you<br>need to <span>grow online.</span>
            </h2>
            <p class="login-brand-desc">
                Manage hosting, domains, billing, and support from one powerful dashboard built for speed and simplicity.
            </p>

            <div class="login-features">
                <div class="login-feature-item">
                    <div class="login-feature-icon"><i class="fas fa-server"></i></div>
                    Instant server provisioning & management
                </div>
                <div class="login-feature-item">
                    <div class="login-feature-icon"><i class="fas fa-globe"></i></div>
                    Domain registration & DNS control
                </div>
                <div class="login-feature-item">
                    <div class="login-feature-icon"><i class="fas fa-headset"></i></div>
                    24/7 expert support, always ready
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
    </div>

    <!-- ===== RIGHT: Login Form ===== -->
    <div class="login-right">
        <div class="login-form-wrap">

            <!-- Header -->
            <div style="margin-bottom: 0.25rem;">
                <div class="form-headline">Welcome <span class="form-headline-accent">Back.</span></div>
                <div class="form-subhead">Sign in to your SNBD HOST portal</div>
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

                <!-- Submit -->
                <button id="login" type="submit" class="auth-clean-btn">
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

            <div class="mt-4 text-center text-muted" style="font-size:0.78rem; font-weight:500;">
                Powered by <a href="{$WEB_ROOT}/" class="text-dark fw-bold text-decoration-none">SNBD HOST</a>
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
