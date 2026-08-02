<!-- password-reset-container.tpl — All states handled inline, no sub-template includes -->
<style>{literal}
#particles-js { display: none !important; }
html, body { background: #f4f5f7 !important; }
.pr-page {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem 1rem;
    background: #f4f5f7;
}
.pr-card {
    background: #ffffff;
    border-radius: 18px;
    box-shadow: 0 4px 28px rgba(0,0,0,0.10);
    padding: 2.5rem 2.25rem;
    width: 100%;
    max-width: 460px;
}
.pr-steps {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: .5rem;
    margin-bottom: 1.75rem;
}
.pr-step-dot {
    width: 8px; height: 8px;
    border-radius: 50%;
    background: #e5e5e5;
    transition: background .2s, width .2s;
}
.pr-step-dot.is-active {
    background: #CC0000;
    width: 22px;
    border-radius: 5px;
}
.pr-step-dot.is-done { background: #009e4d; }
.pr-icon-wrap {
    text-align: center;
    margin-bottom: 1.5rem;
}
.pr-icon-circle {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 60px; height: 60px;
    background: linear-gradient(135deg, #CC0000, #880000);
    border-radius: 16px;
    color: #fff;
    font-size: 1.6rem;
    margin-bottom: .6rem;
    box-shadow: 0 8px 20px rgba(204,0,0,.25);
}
.pr-icon-circle.is-success { background: linear-gradient(135deg, #12b76a, #047a45); box-shadow: 0 8px 20px rgba(18,183,106,.25); }
.pr-icon-circle.is-lock { background: linear-gradient(135deg, #2563eb, #1e3a8a); box-shadow: 0 8px 20px rgba(37,99,235,.25); }
.pr-icon-circle.is-shield { background: linear-gradient(135deg, #7c3aed, #4c1d95); box-shadow: 0 8px 20px rgba(124,58,237,.25); }
.pr-title {
    font-size: 1.4rem;
    font-weight: 700;
    color: #111;
    text-align: center;
    margin-bottom: .25rem;
}
.pr-sub {
    font-size: .9rem;
    color: #757575;
    text-align: center;
    margin-bottom: 1.75rem;
    line-height: 1.5;
}
.pr-sub strong { color: #333; }
.pr-label {
    display: block;
    font-size: .78rem;
    font-weight: 600;
    color: #777;
    margin-bottom: .35rem;
    text-transform: uppercase;
    letter-spacing: .3px;
}
.pr-field {
    background: #f8f8f8 !important;
    border: 1.5px solid #e5e5e5 !important;
    border-radius: 10px !important;
    padding: .85rem 1rem !important;
    font-size: .95rem !important;
    color: #111 !important;
    height: auto !important;
    box-shadow: none !important;
    width: 100%;
    transition: border-color .2s;
    display: block;
}
.pr-field:focus {
    border-color: #CC0000 !important;
    background: #fff !important;
    box-shadow: 0 0 0 3px rgba(204,0,0,.08) !important;
    outline: none !important;
}
.pr-btn {
    display: block;
    width: 100%;
    background: #CC0000;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: .9rem 1rem;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background .2s;
    text-align: center;
    text-decoration: none;
    margin-top: .5rem;
}
.pr-btn:hover { background: #aa0000; color: #fff; }
.pr-btn-outline {
    display: block;
    width: 100%;
    background: #fff;
    color: #333;
    border: 1.5px solid #e0e0e0;
    border-radius: 10px;
    padding: .85rem 1rem;
    font-size: .95rem;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    margin-top: .6rem;
    transition: border-color .2s, background .2s;
}
.pr-btn-outline:hover { border-color: #CC0000; background: #fff8f8; color: #CC0000; }
.pr-link {
    display: block;
    text-align: center;
    margin-top: 1.25rem;
    color: #777;
    font-size: .88rem;
    text-decoration: none;
}
.pr-link:hover { color: #CC0000; }
.pr-success {
    background: rgba(0,140,60,.08);
    border: 1px solid rgba(0,140,60,.2);
    color: #006828;
    border-radius: 10px;
    padding: .85rem 1rem;
    font-size: .9rem;
    margin-bottom: 1.25rem;
}
.pr-error {
    background: rgba(204,0,0,.07);
    border: 1px solid rgba(204,0,0,.15);
    color: #CC0000;
    border-radius: 10px;
    padding: .85rem 1rem;
    font-size: .9rem;
    margin-bottom: 1.25rem;
}
.pr-pw-wrap { position: relative; }
.pr-eye {
    position: absolute;
    right: .85rem; top: 50%;
    transform: translateY(-50%);
    background: none; border: none;
    color: #bbb; cursor: pointer;
    font-size: .85rem; padding: 0;
}
.pr-eye:hover { color: #CC0000; }
.pr-pw-hint {
    font-size: .78rem;
    color: #999;
    margin-top: .35rem;
    display: flex;
    align-items: center;
    gap: .35rem;
}
.pr-pw-hint.is-ok { color: #009e4d; }
.pr-pw-hint.is-bad { color: #CC0000; }
.pr-divider {
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
.pr-divider::before, .pr-divider::after {
    content: "";
    flex: 1;
    border-bottom: 1px solid #ececec;
}
.pr-divider span { padding: 0 .85rem; }
.pr-google-box {
    background: #f9f9fb;
    border: 1px solid #ececec;
    border-radius: 12px;
    padding: 1.1rem 1rem 1.3rem;
    text-align: center;
    margin-top: .25rem;
}
.pr-google-box p {
    font-size: .82rem;
    color: #777;
    line-height: 1.5;
    margin: 0 0 .9rem;
}
.pr-google-box p i { color: #2563eb; margin-right: .3rem; }
.snbd-google-signin-wrapper { display: flex; flex-direction: column; align-items: center; }
#snbdGoogleSignInLoading { display: none; width: 100%; text-align: center; margin-top: .75rem; color: #999; font-size: .85rem; }
#snbdGoogleSignInError { display: none; width: 100%; margin-top: .75rem; }
.pr-resend-row {
    display: flex;
    justify-content: center;
    gap: .4rem;
    font-size: .85rem;
    color: #888;
    margin-top: .25rem;
}
.pr-resend-row button {
    background: none; border: none; padding: 0;
    color: #CC0000; font-weight: 600; cursor: pointer; font-size: .85rem;
}
.pr-resend-row button:hover { text-decoration: underline; }
{/literal}</style>

<div class="pr-page">
<div class="pr-card">

{if $loggedin}

    <!-- Already logged in -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-exclamation-triangle"></i></div>
    </div>
    <div class="pr-title">Already Signed In</div>
    <div class="pr-sub">You cannot reset your password while logged in. Please log out first.</div>
    <a href="{$WEB_ROOT}/logout.php" class="pr-btn">Log Out</a>
    <a href="{$WEB_ROOT}/clientarea.php" class="pr-link">Go to Dashboard</a>

{elseif $innerTemplate == 'password-reset-email-prompt'}

    <div class="pr-steps">
        <div class="pr-step-dot {if !($successmessage || $successMessage || $success)}is-active{else}is-done{/if}"></div>
        <div class="pr-step-dot"></div>
    </div>

    {if $successmessage || $successMessage || $success}

        <!-- Step 1 result: confirmation -->
        <div class="pr-icon-wrap">
            <div class="pr-icon-circle is-success"><i class="fas fa-envelope-open-text"></i></div>
        </div>
        <div class="pr-title">Check Your Email</div>
        <div class="pr-sub">
            We've sent a confirmation link to<br>
            <strong>{$email|default:$smarty.post.email}</strong>.<br>
            Open it and click the button inside to set a new password. The link stays valid for a short time, so use it soon.
        </div>

        <div class="pr-success"><i class="fas fa-check-circle me-2"></i>{$successmessage|default:$successMessage|default:$LANG.pwresetvalidationsent}</div>

        <div class="pr-resend-row">
            <span>Didn't get it? Check your spam folder, or</span>
        </div>
        <form method="post" action="{routePath('password-reset-begin')}" novalidate>
            <input type="hidden" name="action" value="reset" />
            <input type="hidden" name="email" value="{$email|default:$smarty.post.email}" />
            <button type="submit" class="pr-btn-outline"><i class="fas fa-rotate-right me-2"></i>Resend the Link</button>
        </form>

        {if $googleClientId}
        <div class="pr-divider"><span>or skip the wait</span></div>
        <div class="pr-google-box">
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
                <div id="snbdGoogleSignInLoading"><i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...</div>
                <div id="snbdGoogleSignInError" class="pr-error text-start"></div>
            </div>
        </div>
        {/if}

        <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>

    {else}

        <!-- Step 1: Enter email -->
        <div class="pr-icon-wrap">
            <div class="pr-icon-circle"><i class="fas fa-key"></i></div>
        </div>
        <div class="pr-title">{$LANG.pwreset}</div>
        <div class="pr-sub">Enter the email address on your account and we'll send a confirmation link to reset your password.</div>

        {if $errormessage}
            <div class="pr-error"><i class="fas fa-exclamation-circle me-2"></i>{$errormessage}</div>
        {/if}

        <form method="post" action="{routePath('password-reset-begin')}" novalidate>
            <input type="hidden" name="action" value="reset" />
            <div class="mb-3">
                <label class="pr-label" for="prEmail">{$LANG.loginemail}</label>
                <input type="email" name="email" class="pr-field" id="prEmail" placeholder="you@example.com" autofocus required>
            </div>

            {if $captcha || $turnstileEnabled}
                <div style="margin-bottom: 1.25rem;">
                    {include file="$template/includes/captcha.tpl"}
                </div>
            {/if}

            <button type="submit" class="pr-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">Send Confirmation Link</button>
        </form>

        {if $googleClientId}
        <div class="pr-divider"><span>or forget passwords for good</span></div>
        <div class="pr-google-box">
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
                <div id="snbdGoogleSignInLoading"><i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...</div>
                <div id="snbdGoogleSignInError" class="pr-error text-start"></div>
            </div>
        </div>
        {/if}

        <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>

    {/if}

{elseif $innerTemplate == 'password-reset-validation' || (!$innerTemplate && $key)}

    <div class="pr-steps">
        <div class="pr-step-dot is-done"></div>
        <div class="pr-step-dot {if !$success}is-active{else}is-done{/if}"></div>
    </div>

    <!-- Step 2: Set new password -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle is-lock"><i class="fas fa-lock"></i></div>
    </div>
    <div class="pr-title">{if $success}All Set{else}Create a New Password{/if}</div>
    <div class="pr-sub">{if $success}{$LANG.pwresetvalidationsuccess}{else}Your link checks out. Choose a new password below to finish resetting your account.{/if}</div>

    {if $success}
        <div class="pr-success"><i class="fas fa-check-circle me-2"></i>{$LANG.pwresetvalidationsuccess}</div>
        <a href="{$WEB_ROOT}/login.php" class="pr-btn">{$LANG.loginbutton}</a>
    {else}
        {if $errormessage}
            <div class="pr-error"><i class="fas fa-exclamation-circle me-2"></i>{$errormessage}</div>
        {/if}
        <form method="post" action="{$systemurl}pwreset.php" novalidate id="frmPasswordReset">
            <input type="hidden" name="action" value="reset" />
            <input type="hidden" name="key" value="{$key}" />
            <div class="mb-3">
                <label class="pr-label" for="prPw1">{$LANG.newpassword}</label>
                <div class="pr-pw-wrap">
                    <input type="password" name="newpw" class="pr-field" id="prPw1" autocomplete="off" required>
                    <button type="button" class="pr-eye" onclick="var f=document.getElementById('prPw1');f.type=f.type=='password'?'text':'password'"><i class="fas fa-eye"></i></button>
                </div>
                <div class="pr-pw-hint" id="prPwStrength"><i class="fas fa-circle-info"></i><span>At least 8 characters recommended</span></div>
            </div>
            <div class="mb-3">
                <label class="pr-label" for="prPw2">{$LANG.confirmnewpassword}</label>
                <div class="pr-pw-wrap">
                    <input type="password" name="confirmpw" class="pr-field" id="prPw2" autocomplete="off" required>
                    <button type="button" class="pr-eye" onclick="var f=document.getElementById('prPw2');f.type=f.type=='password'?'text':'password'"><i class="fas fa-eye"></i></button>
                </div>
                <div class="pr-pw-hint" id="prPwMatch"></div>
            </div>
            <button type="submit" class="pr-btn">{$LANG.clientareasavechanges}</button>
        </form>
        <script>{literal}
        (function() {
            var pw1 = document.getElementById('prPw1');
            var pw2 = document.getElementById('prPw2');
            var strength = document.getElementById('prPwStrength');
            var match = document.getElementById('prPwMatch');
            if (!pw1 || !pw2) return;
            pw1.addEventListener('input', function() {
                if (!pw1.value) {
                    strength.className = 'pr-pw-hint';
                    strength.innerHTML = '<i class="fas fa-circle-info"></i><span>At least 8 characters recommended</span>';
                } else if (pw1.value.length < 8) {
                    strength.className = 'pr-pw-hint is-bad';
                    strength.innerHTML = '<i class="fas fa-circle-exclamation"></i><span>Too short — use 8+ characters</span>';
                } else {
                    strength.className = 'pr-pw-hint is-ok';
                    strength.innerHTML = '<i class="fas fa-circle-check"></i><span>Looks good</span>';
                }
            });
            function checkMatch() {
                if (!pw2.value) { match.textContent = ''; match.className = 'pr-pw-hint'; return; }
                if (pw1.value === pw2.value) {
                    match.className = 'pr-pw-hint is-ok';
                    match.innerHTML = '<i class="fas fa-circle-check"></i><span>Passwords match</span>';
                } else {
                    match.className = 'pr-pw-hint is-bad';
                    match.innerHTML = '<i class="fas fa-circle-exclamation"></i><span>Passwords do not match</span>';
                }
            }
            pw2.addEventListener('input', checkMatch);
            pw1.addEventListener('input', checkMatch);
        })();
        {/literal}</script>

        {if $googleClientId}
        <div class="pr-divider"><span>or skip this step</span></div>
        <div class="pr-google-box">
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
                <div id="snbdGoogleSignInLoading"><i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...</div>
                <div id="snbdGoogleSignInError" class="pr-error text-start"></div>
            </div>
        </div>
        {/if}

        <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>
    {/if}

{elseif $innerTemplate == 'password-reset-security-prompt'}

    <!-- Step: Security question -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle is-shield"><i class="fas fa-shield-alt"></i></div>
    </div>
    <div class="pr-title">Security Check</div>
    <div class="pr-sub">Please answer your security question to continue.</div>

    {if $errorMessage}
        <div class="pr-error"><i class="fas fa-exclamation-circle me-2"></i>{$errorMessage}</div>
    {/if}
    <form method="post" action="{routePath('password-reset-security-verify')}" novalidate>
        <div class="mb-3">
            <label class="pr-label">{$question}</label>
            <input type="text" name="inputAnswer" class="pr-field" autofocus required>
        </div>
        <button type="submit" class="pr-btn">Verify <i class="fas fa-arrow-right ms-2"></i></button>
    </form>
    <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>

{else}

    <!-- Fallback if $innerTemplate is empty and no reset key present -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-key"></i></div>
    </div>
    <div class="pr-title">{$LANG.pwreset}</div>
    <div class="pr-sub">Enter the email address on your account and we'll send a confirmation link to reset your password.</div>
    <form method="post" action="pwreset.php" novalidate>
        <input type="hidden" name="action" value="reset" />
        <div class="mb-3">
            <label class="pr-label" for="prEmailFb">{$LANG.loginemail}</label>
            <input type="email" name="email" class="pr-field" id="prEmailFb" placeholder="you@example.com" autofocus required>
        </div>

        {if $captcha || $turnstileEnabled}
            <div style="margin-bottom: 1.25rem;">
                {include file="$template/includes/captcha.tpl"}
            </div>
        {/if}

        <button type="submit" class="pr-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">{$LANG.pwresetsubmit}</button>
    </form>
    <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>

{/if}

</div>
</div>
