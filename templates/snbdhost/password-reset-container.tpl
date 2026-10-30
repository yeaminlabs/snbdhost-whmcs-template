<div class="snbd-auth snbd-auth--center">
    <main class="snbd-auth__main">
        <div class="snbd-auth__card">

            {if $loggedin && $innerTemplate}
                <div class="snbd-auth__result">
                    <span class="snbd-empty__icon snbd-auth__result-icon"><i class="ti ti-user-exclamation" aria-hidden="true"></i></span>
                    <h1 class="snbd-auth__result-title">Already signed in</h1>
                    <p class="snbd-auth__result-text">{$LANG.noPasswordResetWhenLoggedIn}</p>
                </div>
                <a href="{$WEB_ROOT}/logout.php" class="snbd-btn snbd-btn--primary snbd-btn--block">Log out</a>
                <p class="snbd-auth__switch"><a href="{$WEB_ROOT}/clientarea.php">Go to dashboard</a></p>
            {else}
                {if $successMessage}
                    {if $successTitle == $LANG.pwresetvalidationsuccess}
                        <div class="snbd-auth__result">
                            <span class="snbd-empty__icon snbd-auth__result-icon snbd-auth__result-icon--ok"><i class="ti ti-circle-check" aria-hidden="true"></i></span>
                            <h1 class="snbd-auth__result-title">{$successTitle}</h1>
                            <p class="snbd-auth__result-text">{$successMessage}</p>
                        </div>
                        <a href="{$WEB_ROOT}/login.php" class="snbd-btn snbd-btn--primary snbd-btn--block">{$LANG.loginbutton|default:"Return to login"}</a>
                    {else}
                        <div class="snbd-steps" aria-hidden="true">
                            <span class="snbd-steps__dot is-done"></span>
                            <span class="snbd-steps__dot is-active"></span>
                        </div>
                        <div class="snbd-auth__result">
                            <span class="snbd-empty__icon snbd-auth__result-icon"><i class="ti ti-mail-opened" aria-hidden="true"></i></span>
                            <h1 class="snbd-auth__result-title">{$successTitle|default:$LANG.pwresetrequested}</h1>
                            <p class="snbd-auth__result-text">Open the email and click the link inside to set a new password.</p>
                        </div>
                        <div class="snbd-alert snbd-alert--ok" role="status">
                            <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
                            <div class="snbd-alert__body"><p class="snbd-alert__text">{$successMessage}</p></div>
                        </div>
                        <a href="{$WEB_ROOT}/pwreset.php" class="snbd-btn snbd-btn--secondary snbd-btn--block"><i class="ti ti-refresh" aria-hidden="true"></i>Try a different email</a>

                        {if $googleClientId}
                            <div class="snbd-auth__or"><span>or skip the wait</span></div>
                            <p class="snbd-caption text-center mb-3">Sign in instantly with Google — no email link needed.</p>
                            {include file="$template/includes/google-signin-button.tpl"}
                        {/if}
                    {/if}
                {else}
                    {if $errorMessage}
                        <div class="snbd-alert snbd-alert--bad" role="alert">
                            <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                            <div class="snbd-alert__body"><p class="snbd-alert__text">{$errorMessage}</p></div>
                        </div>
                    {/if}

                    {if $innerTemplate == 'email-prompt'}
                        <div class="snbd-steps" aria-hidden="true">
                            <span class="snbd-steps__dot is-active"></span>
                            <span class="snbd-steps__dot"></span>
                        </div>
                        <h1 class="snbd-auth__title">{$LANG.pwreset}</h1>
                        <p class="snbd-auth__sub">{$LANG.pwresetemailneeded}</p>
                    {elseif $innerTemplate == 'change-prompt'}
                        <div class="snbd-steps" aria-hidden="true">
                            <span class="snbd-steps__dot is-done"></span>
                            <span class="snbd-steps__dot is-active"></span>
                        </div>
                        <h1 class="snbd-auth__title">Create a new password</h1>
                        <p class="snbd-auth__sub">{$LANG.pwresetenternewpw}</p>
                    {elseif $innerTemplate == 'security-prompt'}
                        <h1 class="snbd-auth__title">Security check</h1>
                        <p class="snbd-auth__sub">One more check before we continue.</p>
                    {/if}

                    {if $innerTemplate}
                        {include file="$template/password-reset-$innerTemplate.tpl"}
                    {/if}

                    {if $googleClientId && ($innerTemplate == 'email-prompt' || $innerTemplate == 'change-prompt')}
                        <div class="snbd-auth__or"><span>{if $innerTemplate == 'change-prompt'}or skip this step{else}or forget passwords for good{/if}</span></div>
                        <p class="snbd-caption text-center mb-3">
                            {if $innerTemplate == 'change-prompt'}Don't want to set a new password? Sign in with Google instead.{else}Link your Google account and sign in with one tap.{/if}
                        </p>
                        {include file="$template/includes/google-signin-button.tpl"}
                    {/if}
                {/if}

                <p class="snbd-auth__switch">
                    <a href="{$WEB_ROOT}/login.php" class="d-inline-flex align-items-center gap-1"><i class="ti ti-arrow-left" aria-hidden="true"></i>{$LANG.login}</a>
                </p>
            {/if}

        </div>
    </main>
</div>
