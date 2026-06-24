{* Captcha include — supports reCAPTCHA v2 and built-in image captcha *}
{if $captcha}
    <div class="text-center{if $containerClass} {$containerClass}{/if}" style="width:100%;">
        <div class="captcha-container" id="captchaContainer">
            {if $captcha == "recaptcha"}
                {* reCAPTCHA v2 — WHMCS injects the full widget HTML via $recaptchahtml *}
                {$recaptchahtml}
            {elseif $captcha == "custom"}
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
