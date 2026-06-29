{* Captcha include — supports reCAPTCHA v2/v3 and built-in image captcha *}
{assign var="showCaptcha" value=false}
{if is_object($captcha)}
    {if $captcha->isEnabled() && $captcha->isEnabledForForm($captchaForm|default:'register')}
        {assign var="showCaptcha" value=true}
    {/if}
{elseif $captcha}
    {assign var="showCaptcha" value=true}
{/if}

{if $showCaptcha}
    {if is_object($captcha)}
        {assign var="isRecaptcha" value=$captcha->recaptcha->isEnabled()}
    {else}
        {assign var="isRecaptcha" value=($captcha == "recaptcha")}
    {/if}

    <div class="text-center{if $containerClass} {$containerClass}{/if}" style="width:100%;">
        <div class="captcha-container" id="captchaContainer">
            {if $isRecaptcha}
                {* reCAPTCHA v2 / v3 *}
                {if $recaptchahtml}
                    {$recaptchahtml}
                {else}
                    <div class="form-group recaptcha-container mx-auto" data-action="{$captchaForm|default:'register'}"></div>
                {/if}
            {elseif $captcha == "custom" || (is_object($captcha) && $captcha->isCustom())}
                <div class="captchainput text-center">
                    <p>{$LANG.captchaverify}</p>
                    {$customcaptcha}
                </div>
            {else}
                {* Built-in image captcha *}
                <div class="captchainput text-center">
                    <p>{$LANG.captchaverify}</p>
                    <img src="{$systemurl}includes/verifyimage.php" id="captchaImage" alt="captcha" class="mb-2" style="border-radius:6px; border:1px solid #e0e0e0;" />
                    <div class="input-group mt-2">
                        <input type="text" name="code" class="form-control" maxlength="6" required
                               placeholder="Enter code above"
                               data-fv-notempty="true"
                               data-fv-notempty-message="{$LANG.captcharequired}" />
                        <div class="input-group-append">
                            <span class="input-group-text" title="Refresh captcha" id="btnCaptchaRefresh" style="cursor:pointer;">
                                <i class="fas fa-sync"></i>
                            </span>
                        </div>
                    </div>
                </div>
                <script>
                (function(){
                    var btn = document.getElementById('btnCaptchaRefresh');
                    var img = document.getElementById('captchaImage');
                    if (btn && img) {
                        btn.addEventListener('click', function(){
                            img.src = img.src.split('?')[0] + '?r=' + Math.random();
                        });
                    }
                })();
                </script>
            {/if}
        </div>
    </div>
{/if}
