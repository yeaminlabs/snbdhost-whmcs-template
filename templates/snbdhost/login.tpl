<div class="snbd-auth">
    <aside class="snbd-auth__brand" aria-label="About SNBD Host">
        <div class="snbd-auth__grid" aria-hidden="true"></div>
        <a href="https://snbdhost.com" class="snbd-auth__logo">
            <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}">
        </a>

        <div class="snbd-auth__pitch">
            <span class="snbd-auth__badge"><i class="ti ti-shield-check" aria-hidden="true"></i>Trusted by 10,000+ clients</span>
            <h1>Hosting built for speed,<br><span>managed in one place.</span></h1>
            <p>Hosting, domains, billing and support — all in a client portal designed to get out of your way.</p>
            <ul class="snbd-auth__features">
                <li><i class="ti ti-server-2" aria-hidden="true"></i>NVMe storage on AMD EPYC servers</li>
                <li><i class="ti ti-world" aria-hidden="true"></i>Domain registration with full DNS control</li>
                <li><i class="ti ti-headset" aria-hidden="true"></i>24/7 support from real engineers</li>
            </ul>
        </div>

        <dl class="snbd-auth__stats">
            <div><dt>10K+</dt><dd>Clients</dd></div>
            <div><dt>99.9%</dt><dd>Uptime SLA</dd></div>
            <div><dt>24/7</dt><dd>Support</dd></div>
        </dl>
    </aside>

    <main class="snbd-auth__main">
        <div class="snbd-auth__card">
            <nav class="snbd-auth__tabs" aria-label="Account access">
                <a href="{$WEB_ROOT}/login.php" class="snbd-auth__tab active" aria-current="page">Sign in</a>
                <a href="{$WEB_ROOT}/register.php" class="snbd-auth__tab">Create account</a>
            </nav>

            <h2 class="snbd-auth__title">Welcome back</h2>
            <p class="snbd-auth__sub">Sign in to your SNBD Host client portal.</p>

            {if $incorrect || $invalid || $smarty.get.incorrect}
            <div class="snbd-alert snbd-alert--bad" role="alert">
                <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='loginincorrect'}</p></div>
            </div>
            {elseif $errorMessage}
            <div class="snbd-alert snbd-alert--bad" role="alert">
                <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{$errorMessage}</p></div>
            </div>
            {elseif $errormessage}
            <div class="snbd-alert snbd-alert--bad" role="alert">
                <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{$errormessage}</p></div>
            </div>
            {elseif $turnstileError}
            <div class="snbd-alert snbd-alert--bad" role="alert">
                <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body"><p class="snbd-alert__text">{$turnstileError}</p></div>
            </div>
            {/if}

            {if $googleClientId}
            <div class="snbd-auth__google">
                <div id="g_id_onload"
                     data-client_id="{$googleClientId}"
                     data-context="signin"
                     data-ux_mode="popup"
                     data-callback="onGoogleSignIn"
                     data-auto_prompt="false"></div>
                <div class="g_id_signin"
                     data-type="standard"
                     data-shape="rectangular"
                     data-theme="outline"
                     data-text="signin_with"
                     data-size="large"
                     data-logo_alignment="center"></div>
                <div id="snbdGoogleSignInLoading" class="snbd-auth__google-status" hidden>
                    <i class="ti ti-loader-2 snbd-spin" aria-hidden="true"></i> Authenticating securely…
                </div>
                <div id="snbdGoogleSignInError" class="snbd-alert snbd-alert--bad mt-3" hidden></div>
                <div class="snbd-auth__or"><span>or continue with email</span></div>
            </div>
            {/if}

            <form method="post" action="{$WEB_ROOT}/dologin.php" class="snbd-form needs-validation" role="form" id="frmLogin" novalidate>
                <input type="hidden" name="token" value="{$token}">

                <div class="mb-3">
                    <label class="snbd-label" for="inputEmail">Email address</label>
                    <input type="email" name="username" class="form-control" id="inputEmail" placeholder="you@example.com" autocomplete="username" autofocus required>
                    <div class="invalid-feedback">Enter the email address on your account.</div>
                </div>

                <div class="mb-3">
                    <label class="snbd-label" for="inputPassword">Password</label>
                    <div class="snbd-password">
                        <input type="password" name="password" class="form-control" id="inputPassword" placeholder="Your password" autocomplete="current-password" required>
                        <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputPassword" aria-label="Show password">
                            <i class="ti ti-eye" aria-hidden="true"></i>
                        </button>
                    </div>
                    <div class="invalid-feedback">Enter your password.</div>
                </div>

                <div class="snbd-spread mb-4">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" name="rememberme" id="rememberme">
                        <label class="form-check-label" for="rememberme">{$LANG.loginrememberme}</label>
                    </div>
                    <a href="pwreset.php" class="snbd-small fw-semibold">{$LANG.forgotpw}</a>
                </div>

                {if $captcha || $turnstileEnabled}
                <div class="mb-3">
                    {include file="$template/includes/captcha.tpl"}
                </div>
                {/if}

                <button id="login" type="submit" class="snbd-btn snbd-btn--primary snbd-btn--lg snbd-btn--block{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                    Sign in<i class="ti ti-arrow-right" aria-hidden="true"></i>
                </button>
            </form>

            <ul class="snbd-auth__trust">
                <li><i class="ti ti-lock" aria-hidden="true"></i>SSL secured</li>
                <li><i class="ti ti-shield-check" aria-hidden="true"></i>2FA ready</li>
                <li><i class="ti ti-user-shield" aria-hidden="true"></i>Privacy safe</li>
            </ul>

            <p class="snbd-auth__switch">New to SNBD Host? <a href="{$WEB_ROOT}/register.php">Create a free account</a></p>
        </div>
    </main>
</div>
