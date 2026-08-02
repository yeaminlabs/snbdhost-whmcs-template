{* Overrides templates/twenty-one/password-reset-email-prompt.tpl *}
<form method="post" action="{routePath('password-reset-validate-email')}" novalidate>
    <input type="hidden" name="action" value="reset" />

    <div class="mb-3">
        <label class="pr-label" for="inputEmail">{lang key='loginemail'}</label>
        <input type="email" class="pr-field" name="email" id="inputEmail" placeholder="you@example.com" autofocus required>
    </div>

    {if $turnstileEnabled || ($captcha && $captcha->isEnabled() && $showCaptchaAfterLimit)}
        <div class="mb-3">
            {include file="$template/includes/captcha.tpl"}
        </div>
    {/if}

    <button type="submit" id="resetPasswordButton" {if $showCaptchaAfterLimit}data-captcha-required="true"{/if} class="pr-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
        {lang key='pwresetsubmit'}
    </button>
</form>
