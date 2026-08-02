<!--
    password-reset-container.tpl
    WHMCS's core container includes {"$template/password-reset-$innerTemplate.tpl"}
    where $innerTemplate is one of: email-prompt | change-prompt | security-prompt.
    This file provides the shared page chrome; the three stages live in their
    own override files (password-reset-email-prompt.tpl, -change-prompt.tpl,
    -security-prompt.tpl) so each stage's markup/fields match WHMCS's expectations.
-->
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
    text-align: center;
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
{/literal}</style>

<div class="pr-page">
<div class="pr-card">

{if $loggedin && $innerTemplate}

    <!-- Already logged in -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-exclamation-triangle"></i></div>
    </div>
    <div class="pr-title">Already Signed In</div>
    <div class="pr-sub">{$LANG.noPasswordResetWhenLoggedIn}</div>
    <a href="{$WEB_ROOT}/logout.php" class="pr-btn">Log Out</a>
    <a href="{$WEB_ROOT}/clientarea.php" class="pr-link">Go to Dashboard</a>

{else}

    {if $successMessage}

        {if $successTitle == $LANG.pwresetvalidationsuccess}

            <!-- Final success: password changed -->
            <div class="pr-steps">
                <div class="pr-step-dot is-done"></div>
                <div class="pr-step-dot is-done"></div>
            </div>
            <div class="pr-icon-wrap">
                <div class="pr-icon-circle is-success"><i class="fas fa-check"></i></div>
            </div>
            <div class="pr-title">{$successTitle}</div>
            <div class="pr-success">{$successMessage}</div>
            <a href="{$WEB_ROOT}/login.php" class="pr-btn">{$LANG.loginbutton|default:"Return to Login"}</a>

        {else}

            <!-- Email-request success: link is on its way -->
            <div class="pr-steps">
                <div class="pr-step-dot is-active"></div>
                <div class="pr-step-dot"></div>
            </div>
            <div class="pr-icon-wrap">
                <div class="pr-icon-circle is-success"><i class="fas fa-envelope-open-text"></i></div>
            </div>
            <div class="pr-title">{$successTitle|default:$LANG.pwresetrequested}</div>
            <div class="pr-sub">Open the email and click the button inside it to set a new password.</div>
            <div class="pr-success">{$successMessage}</div>

            <a href="{$WEB_ROOT}/pwreset.php" class="pr-btn-outline"><i class="fas fa-rotate-right me-2"></i>Try a Different Email</a>

            {if $googleClientId}
            <div class="pr-divider"><span>or skip the wait</span></div>
            <div class="pr-google-box">
                <p><i class="fab fa-google"></i>Sign in instantly with Google — no email link, no password to remember.</p>
                {include file="$template/includes/google-signin-button.tpl"}
            </div>
            {/if}

        {/if}

    {else}

        {if $errorMessage}
            <div class="pr-error"><i class="fas fa-exclamation-circle me-2"></i>{$errorMessage}</div>
        {/if}

        {if $innerTemplate == 'email-prompt'}
            <div class="pr-steps">
                <div class="pr-step-dot is-active"></div>
                <div class="pr-step-dot"></div>
            </div>
            <div class="pr-icon-wrap">
                <div class="pr-icon-circle"><i class="fas fa-key"></i></div>
            </div>
            <div class="pr-title">{$LANG.pwreset}</div>
            <div class="pr-sub">{$LANG.pwresetemailneeded}</div>
        {elseif $innerTemplate == 'change-prompt'}
            <div class="pr-steps">
                <div class="pr-step-dot is-done"></div>
                <div class="pr-step-dot is-active"></div>
            </div>
            <div class="pr-icon-wrap">
                <div class="pr-icon-circle is-lock"><i class="fas fa-lock"></i></div>
            </div>
            <div class="pr-title">Create a New Password</div>
            <div class="pr-sub">{$LANG.pwresetenternewpw}</div>
        {elseif $innerTemplate == 'security-prompt'}
            <div class="pr-icon-wrap">
                <div class="pr-icon-circle is-shield"><i class="fas fa-shield-alt"></i></div>
            </div>
            <div class="pr-title">Security Check</div>
            <div class="pr-sub">One more check before we continue.</div>
        {/if}

        {if $innerTemplate}
            {include file="$template/password-reset-$innerTemplate.tpl"}
        {/if}

        {if $googleClientId && ($innerTemplate == 'email-prompt' || $innerTemplate == 'change-prompt')}
        <div class="pr-divider"><span>{if $innerTemplate == 'change-prompt'}or skip this step{else}or forget passwords for good{/if}</span></div>
        <div class="pr-google-box">
            {if $innerTemplate == 'change-prompt'}
                <p><i class="fab fa-google"></i>Don't want to set a new password? Sign in instantly with Google instead.</p>
            {else}
                <p><i class="fab fa-google"></i>Link your Google account and sign in with one tap — no password to reset ever again.</p>
            {/if}
            {include file="$template/includes/google-signin-button.tpl"}
        </div>
        {/if}

    {/if}

    <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>

{/if}

</div>
</div>
