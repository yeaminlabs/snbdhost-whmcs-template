<!-- ====== PASSWORD RESET PAGE (legacy pwreset.php flow) ====== -->
<style>{literal}
.pwreset-wrap {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--bg-body, #f4f5f7);
    padding: 2rem 1rem;
}
.pwreset-card {
    background: var(--bg-surface, #ffffff);
    border: 1px solid var(--border-color, #e0e0e0);
    border-radius: 16px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.12);
    padding: 2.5rem 2rem;
    width: 100%;
    max-width: 440px;
}
.pwreset-logo {
    text-align: center;
    margin-bottom: 1.5rem;
}
.pwreset-logo .logo-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 56px; height: 56px;
    background: var(--brand-primary, #E05052);
    border-radius: 14px;
    color: var(--text-on-brand, #ffffff);
    font-size: 1.5rem;
    margin-bottom: 0.75rem;
}
.pwreset-logo .logo-name {
    font-size: 1.2rem;
    font-weight: 700;
    color: var(--text-primary, #111111);
}
.pwreset-title {
    text-align: center;
    font-size: 1.4rem;
    font-weight: 700;
    color: var(--text-primary, #111111);
    margin-bottom: 0.35rem;
}
.pwreset-sub {
    text-align: center;
    font-size: 0.9rem;
    color: var(--text-secondary, #666666);
    margin-bottom: 1.75rem;
    line-height: 1.5;
}
.pwreset-sub strong { color: var(--text-primary, #111111); }
.pwreset-input {
    background: var(--bg-elevated, #f8f8f8) !important;
    border: 1.5px solid var(--border-color, #e5e5e5) !important;
    border-radius: 10px !important;
    padding: 0.85rem 1rem !important;
    font-size: 0.95rem !important;
    color: var(--text-primary, #111111) !important;
    height: auto !important;
    box-shadow: none !important;
    width: 100%;
    transition: border-color 0.2s;
}
.pwreset-input:focus {
    border-color: var(--brand-primary, #E05052) !important;
    background: var(--bg-surface, #ffffff) !important;
    box-shadow: 0 0 0 3px rgba(224, 80, 82, 0.15) !important;
    outline: none !important;
}
.pwreset-btn {
    width: 100%;
    background: var(--brand-primary, #E05052);
    color: var(--text-on-brand, #ffffff);
    border: none;
    border-radius: 10px;
    padding: 0.85rem 1rem;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
    margin-top: 0.25rem;
}
.pwreset-btn:hover {
    background: var(--brand-hover, #E87072);
    color: var(--text-on-brand, #ffffff);
}
.pwreset-btn-outline {
    display: block;
    width: 100%;
    background: transparent;
    color: var(--text-secondary, #666666);
    border: 1.5px solid var(--border-color, #e0e0e0);
    border-radius: 10px;
    padding: 0.8rem 1rem;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    margin-top: 0.6rem;
    transition: border-color 0.2s, color 0.2s;
}
.pwreset-btn-outline:hover {
    border-color: var(--brand-primary, #E05052);
    color: var(--brand-primary, #E05052);
}
.pwreset-back {
    display: block;
    text-align: center;
    margin-top: 1.25rem;
    color: var(--text-secondary, #666666);
    font-size: 0.9rem;
    text-decoration: none;
}
.pwreset-back:hover { color: var(--brand-primary, #E05052); }
.pwreset-alert-ok {
    background: rgba(46, 125, 50, 0.12);
    border: 1px solid rgba(46, 125, 50, 0.25);
    color: #2e7d32;
    border-radius: 10px;
    padding: 0.75rem 1rem;
    font-size: 0.9rem;
    margin-bottom: 1.25rem;
}
.pwreset-alert-err {
    background: rgba(224, 80, 82, 0.12);
    border: 1px solid rgba(224, 80, 82, 0.25);
    color: var(--brand-primary, #E05052);
    border-radius: 10px;
    padding: 0.75rem 1rem;
    font-size: 0.9rem;
    margin-bottom: 1.25rem;
}
.pwreset-icon-circle {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 56px; height: 56px;
    margin: 0 auto 1rem;
    border-radius: 14px;
    background: linear-gradient(135deg, #12b76a, #047a45);
    color: #fff;
    font-size: 1.4rem;
    box-shadow: 0 8px 20px rgba(18,183,106,.25);
}
.pwreset-divider {
    display: flex;
    align-items: center;
    text-align: center;
    color: #aaa;
    font-size: .78rem;
    font-weight: 600;
    letter-spacing: .4px;
    text-transform: uppercase;
    margin: 1.5rem 0;
}
.pwreset-divider::before, .pwreset-divider::after {
    content: "";
    flex: 1;
    border-bottom: 1px solid var(--border-color, #ececec);
}
.pwreset-divider span { padding: 0 .85rem; }
.pwreset-google-box {
    background: var(--bg-elevated, #f9f9fb);
    border: 1px solid var(--border-color, #ececec);
    border-radius: 12px;
    padding: 1.1rem 1rem 1.3rem;
    text-align: center;
    margin-top: .25rem;
}
.pwreset-google-box p {
    font-size: .82rem;
    color: var(--text-secondary, #777);
    line-height: 1.5;
    margin: 0 0 .9rem;
}
.pwreset-google-box p i { color: #2563eb; margin-right: .3rem; }
{/literal}</style>

<div class="pwreset-wrap">
    <div class="pwreset-card">

        <a href="{$WEB_ROOT}/" style="text-decoration: none;">
            <div class="pwreset-logo">
                <div class="logo-icon"><i class="ti ti-key"></i></div>
                <div class="logo-name">{$companyname}</div>
            </div>
        </a>

        {if !$success}
        <div class="pwreset-title">{$LANG.pwreset}</div>
        <div class="pwreset-sub">
            {if $key || $action eq "pwreset"}
                Your link checks out. Choose a new password below to finish resetting your account.
            {elseif $securityquestion}
                {$LANG.pwresetsecurityquestionrequired|default:"Please answer your security question below."}
            {else}
                Enter the email address on your account and we'll send a confirmation link to reset your password.
            {/if}
        </div>
        {/if}

        {if $errormessage}
            <div class="pwreset-alert-err">
                <i class="ti ti-alert-circle me-2"></i>{$errormessage}
            </div>
        {/if}

        {if $success}
            <div class="pwreset-icon-circle"><i class="ti ti-mail-opened"></i></div>
            <div class="pwreset-title">Check Your Email</div>
            <div class="pwreset-sub">
                We've sent a confirmation link to<br>
                <strong>{$email|default:$smarty.post.email}</strong>.<br>
                Open it and click the button inside to set a new password.
            </div>
            <div class="pwreset-alert-ok">
                <i class="ti ti-circle-check me-2"></i>{$LANG.pwresetvalidationsent}
            </div>
            <a href="{$WEB_ROOT}/login.php" class="pwreset-btn text-center d-block text-decoration-none mt-3">
                <i class="ti ti-login me-1"></i> {$LANG.loginbutton|default:"Return to Login"}
            </a>

            {if $googleClientId}
            <div class="pwreset-divider"><span>or skip the wait</span></div>
            <div class="pwreset-google-box">
                <p><i class="fab fa-google"></i>Sign in instantly with Google — no email link, no password to remember.</p>
                <div class="snbd-google-signin-wrapper">
                    <div id="g_id_onload"
                         data-client_id="{$googleClientId}"
                         data-context="signin"
                         data-ux_mode="popup"
                         data-callback="onGoogleSignIn"
                         data-auto_prompt="false">
                    </div>
                    <div class="g_id_signin"
                         data-type="standard"
                         data-shape="rectangular"
                         data-theme="outline"
                         data-text="signin_with"
                         data-size="large"
                         data-logo_alignment="center">
                    </div>
                    <div id="snbdGoogleSignInLoading" style="display:none; width:100%; text-align:center; margin-top:.75rem; color:var(--text-secondary,#999); font-size:.85rem;">
                        <i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...
                    </div>
                    <div id="snbdGoogleSignInError" style="display:none; width:100%; margin-top:.75rem;" class="pwreset-alert-err text-start"></div>
                </div>
            </div>
            {/if}
        {elseif $securityquestion}
            <!-- Security Question Stage -->
            <form method="post" action="{$WEB_ROOT}/pwreset.php">
                <input type="hidden" name="email" value="{$email}" />
                <input type="hidden" name="action" value="reset" />
                <input type="hidden" name="sub" value="send" />

                <div class="mb-3">
                    <label class="form-label small fw-bold text-muted">{$securityquestion}</label>
                    <input type="text" name="answer" class="form-control pwreset-input" required autofocus autocomplete="off">
                </div>

                <button type="submit" class="pwreset-btn mt-2">
                    {$LANG.pwresetsubmit}
                </button>
            </form>
        {elseif $key || $action eq "pwreset" || $step eq "3"}
            <!-- Set New Password Stage -->
            <form method="post" action="{$WEB_ROOT}/pwreset.php">
                <input type="hidden" name="key" value="{$key}" />
                <input type="hidden" name="email" value="{$email}" />
                <input type="hidden" name="action" value="pwreset" />
                <input type="hidden" name="sub" value="save" />

                <div class="mb-3">
                    <label for="inputNewPassword1" class="form-label small fw-bold text-muted">{$LANG.newpassword}</label>
                    <input type="password" name="newpw" id="inputNewPassword1" class="form-control pwreset-input" required autofocus autocomplete="off">
                </div>

                <div class="mb-3">
                    <label for="inputNewPassword2" class="form-label small fw-bold text-muted">{$LANG.confirmnewpassword}</label>
                    <input type="password" name="confirmpw" id="inputNewPassword2" class="form-control pwreset-input" required autocomplete="off">
                </div>

                <button type="submit" class="pwreset-btn mt-2">
                    {$LANG.pwresetsubmit}
                </button>
            </form>

            {if $googleClientId}
            <div class="pwreset-divider"><span>or skip this step</span></div>
            <div class="pwreset-google-box">
                <p><i class="fab fa-google"></i>Don't want to set a new password? Sign in instantly with Google instead.</p>
                <div class="snbd-google-signin-wrapper">
                    <div id="g_id_onload"
                         data-client_id="{$googleClientId}"
                         data-context="signin"
                         data-ux_mode="popup"
                         data-callback="onGoogleSignIn"
                         data-auto_prompt="false">
                    </div>
                    <div class="g_id_signin"
                         data-type="standard"
                         data-shape="rectangular"
                         data-theme="outline"
                         data-text="signin_with"
                         data-size="large"
                         data-logo_alignment="center">
                    </div>
                    <div id="snbdGoogleSignInLoading" style="display:none; width:100%; text-align:center; margin-top:.75rem; color:var(--text-secondary,#999); font-size:.85rem;">
                        <i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...
                    </div>
                    <div id="snbdGoogleSignInError" style="display:none; width:100%; margin-top:.75rem;" class="pwreset-alert-err text-start"></div>
                </div>
            </div>
            {/if}
        {else}
            <!-- Request Reset Link Stage -->
            <form method="post" action="{$WEB_ROOT}/pwreset.php" novalidate>
                <input type="hidden" name="action" value="reset" />
                <input type="hidden" name="sub" value="send" />

                <div class="mb-3">
                    <input type="email" name="email" class="form-control pwreset-input" id="inputEmail" placeholder="{$LANG.loginemail}" autofocus required>
                </div>

                {if $captcha || $turnstileEnabled}
                    <div class="mb-3">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                {/if}

                <button type="submit" class="pwreset-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                    {$LANG.pwresetsubmit}
                </button>
            </form>

            {if $googleClientId}
            <div class="pwreset-divider"><span>or forget passwords for good</span></div>
            <div class="pwreset-google-box">
                <p><i class="fab fa-google"></i>Link your Google account and sign in with one tap — no password to reset ever again.</p>
                <div class="snbd-google-signin-wrapper">
                    <div id="g_id_onload"
                         data-client_id="{$googleClientId}"
                         data-context="signin"
                         data-ux_mode="popup"
                         data-callback="onGoogleSignIn"
                         data-auto_prompt="false">
                    </div>
                    <div class="g_id_signin"
                         data-type="standard"
                         data-shape="rectangular"
                         data-theme="outline"
                         data-text="signin_with"
                         data-size="large"
                         data-logo_alignment="center">
                    </div>
                    <div id="snbdGoogleSignInLoading" style="display:none; width:100%; text-align:center; margin-top:.75rem; color:var(--text-secondary,#999); font-size:.85rem;">
                        <i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...
                    </div>
                    <div id="snbdGoogleSignInError" style="display:none; width:100%; margin-top:.75rem;" class="pwreset-alert-err text-start"></div>
                </div>
            </div>
            {/if}
        {/if}

        <a href="{$WEB_ROOT}/login.php" class="pwreset-back">
            <i class="ti ti-arrow-left me-1"></i> {$LANG.login}
        </a>

    </div>
</div>
