{if $captcha->isEnabled() && $captcha->isEnabledForForm($captchaForm)}
    <div class="text-center{if $containerClass} {$containerClass}{/if}">
        <div class="captcha-container" id="captchaContainer">
            {if $captcha == "recaptcha"}
                {$recaptchahtml}
            {elseif $captcha != "recaptcha"}
                <div class="captchainput text-center">
                    <p>{$LANG.captchaverify}</p>
                    {if $captcha == "custom"}
                        {$customcaptcha}
                    {else}
                        <img src="{$systemurl}includes/verifyimage.php" id="captchaImage" alt="captcha" class="mb-2" />
                        <div class="input-group">
                            <input type="text" name="code" class="form-control" maxlength="6" required data-fv-notempty="true" data-fv-notempty-message="{$LANG.captcharequired}" />
                            <div class="input-group-append">
                                <span class="input-group-text" data-toggle="tooltip" title="{$LANG.captchaverify}" id="btnCaptchaRefresh" style="cursor: pointer;">
                                    <i class="fas fa-sync"></i>
                                </span>
                            </div>
                        </div>
                    {/if}
                </div>
            {/if}
        </div>
    </div>
{/if}
