<div class="snbd-auth snbd-auth--center">
    <main class="snbd-auth__main">
        <div class="snbd-auth__card">
            <a href="{$WEB_ROOT}/" class="snbd-auth__mark">
                <span class="snbd-avatar snbd-avatar--lg" aria-hidden="true"><i class="ti ti-key"></i></span>
                <span>{$companyname}</span>
            </a>

            {if !$success}
                <h1 class="snbd-auth__title">{$LANG.pwreset}</h1>
                <p class="snbd-auth__sub">
                    {if $key || $action eq "pwreset"}
                        Your link checks out. Choose a new password below.
                    {elseif $securityquestion}
                        {$LANG.pwresetsecurityquestionrequired|default:"Please answer your security question below."}
                    {else}
                        Enter the email address on your account and we'll send you a link to reset your password.
                    {/if}
                </p>
            {/if}

            {if $errormessage}
            <div class="snbd-alert snbd-alert--bad" role="alert">
                <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{$errormessage}</p></div>
            </div>
            {/if}

            {if $success}
                <div class="snbd-auth__result">
                    <span class="snbd-empty__icon snbd-auth__result-icon"><i class="ti ti-mail-opened" aria-hidden="true"></i></span>
                    <h2 class="snbd-auth__result-title">Check your email</h2>
                    <p class="snbd-auth__result-text">
                        We sent a confirmation link to<br>
                        <strong>{$email|default:$smarty.post.email}</strong>.<br>
                        Open it and follow the link to set a new password.
                    </p>
                </div>
                <div class="snbd-alert snbd-alert--ok" role="status">
                    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
                    <div class="snbd-alert__body"><p class="snbd-alert__text">{$LANG.pwresetvalidationsent}</p></div>
                </div>
                <a href="{$WEB_ROOT}/login.php" class="snbd-btn snbd-btn--primary snbd-btn--block mt-3">
                    <i class="ti ti-login" aria-hidden="true"></i>{$LANG.loginbutton|default:"Return to login"}
                </a>

                {if $googleClientId}
                    <div class="snbd-auth__or"><span>or skip the wait</span></div>
                    <p class="snbd-caption text-center mb-3">Sign in instantly with Google — no email link needed.</p>
                    {include file="$template/includes/google-signin-button.tpl"}
                {/if}
            {elseif $securityquestion}
                <form method="post" action="{$WEB_ROOT}/pwreset.php" class="snbd-form">
                    <input type="hidden" name="email" value="{$email}">
                    <input type="hidden" name="action" value="reset">
                    <input type="hidden" name="sub" value="send">
                    <div class="mb-3">
                        <label class="snbd-label" for="securityAnswer">{$securityquestion}</label>
                        <input type="text" name="answer" id="securityAnswer" class="form-control" required autofocus autocomplete="off">
                    </div>
                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block">{$LANG.pwresetsubmit}</button>
                </form>
            {elseif $key || $action eq "pwreset" || $step eq "3"}
                <form method="post" action="{$WEB_ROOT}/pwreset.php" class="snbd-form">
                    <input type="hidden" name="key" value="{$key}">
                    <input type="hidden" name="email" value="{$email}">
                    <input type="hidden" name="action" value="pwreset">
                    <input type="hidden" name="sub" value="save">
                    <div class="mb-3">
                        <label for="inputNewPassword1" class="snbd-label">{$LANG.newpassword}</label>
                        <div class="snbd-password">
                            <input type="password" name="newpw" id="inputNewPassword1" class="form-control" required autofocus autocomplete="new-password">
                            <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputNewPassword1" aria-label="Show password"><i class="ti ti-eye" aria-hidden="true"></i></button>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="inputNewPassword2" class="snbd-label">{$LANG.confirmnewpassword}</label>
                        <div class="snbd-password">
                            <input type="password" name="confirmpw" id="inputNewPassword2" class="form-control" required autocomplete="new-password">
                            <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputNewPassword2" aria-label="Show password"><i class="ti ti-eye" aria-hidden="true"></i></button>
                        </div>
                    </div>
                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block">{$LANG.pwresetsubmit}</button>
                </form>

                {if $googleClientId}
                    <div class="snbd-auth__or"><span>or skip this step</span></div>
                    <p class="snbd-caption text-center mb-3">Don't want to set a new password? Sign in with Google instead.</p>
                    {include file="$template/includes/google-signin-button.tpl"}
                {/if}
            {else}
                <form method="post" action="{$WEB_ROOT}/pwreset.php" class="snbd-form" novalidate>
                    <input type="hidden" name="action" value="reset">
                    <input type="hidden" name="sub" value="send">
                    <div class="mb-3">
                        <label class="snbd-label" for="inputEmail">Email address</label>
                        <input type="email" name="email" class="form-control" id="inputEmail" placeholder="you@example.com" autofocus required autocomplete="email">
                    </div>

                    {if $captcha || $turnstileEnabled}
                    <div class="mb-3">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                    {/if}

                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                        {$LANG.pwresetsubmit}
                    </button>
                </form>

                {if $googleClientId}
                    <div class="snbd-auth__or"><span>or forget passwords for good</span></div>
                    <p class="snbd-caption text-center mb-3">Link your Google account and sign in with one tap.</p>
                    {include file="$template/includes/google-signin-button.tpl"}
                {/if}
            {/if}

            <p class="snbd-auth__switch">
                <a href="{$WEB_ROOT}/login.php" class="d-inline-flex align-items-center gap-1"><i class="ti ti-arrow-left" aria-hidden="true"></i>{$LANG.login}</a>
            </p>
        </div>
    </main>
</div>
