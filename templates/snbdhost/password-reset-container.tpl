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
    border-radius: 16px;
    box-shadow: 0 4px 24px rgba(0,0,0,0.10);
    padding: 2.5rem 2rem;
    width: 100%;
    max-width: 460px;
}
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
    border-radius: 14px;
    color: #fff;
    font-size: 1.6rem;
    margin-bottom: .6rem;
}
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

    <!-- Step 1: Enter email -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-key"></i></div>
    </div>
    <div class="pr-title">{$LANG.pwreset}</div>
    <div class="pr-sub">{$LANG.pwresetemailneeded}</div>

    {if $successmessage || $successMessage || $success}
        <div class="pr-success"><i class="fas fa-check-circle me-2"></i>{$successmessage|default:$successMessage|default:$LANG.pwresetvalidationsent}</div>

        <!-- Success Popup Modal -->
        <div id="successModal" class="custom-modal-overlay">
            <div class="custom-modal-card">
                <div class="custom-modal-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h3 class="custom-modal-title">Reset Link Sent</h3>
                <p class="custom-modal-text">{$successmessage|default:$successMessage|default:$LANG.pwresetvalidationsent}</p>
                <button class="custom-modal-btn" onclick="closeSuccessModal()">Close</button>
            </div>
        </div>

        <style>{literal}
        .custom-modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 99999;
            opacity: 0;
            animation: fadeInModal 0.3s forwards;
        }
        .custom-modal-card {
            background: #ffffff;
            padding: 2.5rem 2rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            text-align: center;
            max-width: 400px;
            width: 90%;
            transform: scale(0.9);
            animation: scaleUpModal 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
        }
        .custom-modal-icon {
            font-size: 3.5rem;
            color: #28a745;
            margin-bottom: 1rem;
            animation: pulseIcon 1.5s infinite;
        }
        .custom-modal-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #111;
            margin-bottom: 0.5rem;
        }
        .custom-modal-text {
            font-size: 0.95rem;
            color: #555;
            margin-bottom: 1.5rem;
            line-height: 1.5;
        }
        .custom-modal-btn {
            background: #CC0000;
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            outline: none;
        }
        .custom-modal-btn:hover {
            background: #aa0000;
        }
        .custom-modal-btn:active {
            transform: scale(0.98);
        }
        @keyframes fadeInModal {
            to { opacity: 1; }
        }
        @keyframes scaleUpModal {
            to { transform: scale(1); }
        }
        @keyframes pulseIcon {
            0% { transform: scale(1); }
            50% { transform: scale(1.08); }
            100% { transform: scale(1); }
        }
        {/literal}</style>
        <script>{literal}
        function closeSuccessModal() {
            var modal = document.getElementById('successModal');
            if (modal) {
                modal.style.opacity = '1';
                modal.style.transition = 'opacity 0.2s ease';
                modal.style.opacity = '0';
                setTimeout(function() {
                    modal.remove();
                }, 200);
            }
        }
        {/literal}</script>
    {/if}
    {if $errormessage}
        <div class="pr-error"><i class="fas fa-exclamation-circle me-2"></i>{$errormessage}</div>
    {/if}

    {if !$successmessage && !$successMessage && !$success}
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

        <button type="submit" class="pr-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">{$LANG.pwresetsubmit}</button>
    </form>
    {/if}
    <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>

{elseif $innerTemplate == 'password-reset-validation'}

    <!-- Step 2: Set new password -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-lock"></i></div>
    </div>
    <div class="pr-title">{$LANG.pwreset}</div>
    <div class="pr-sub">{$LANG.pwresetenternewpw}</div>

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
            </div>
            <div class="mb-3">
                <label class="pr-label" for="prPw2">{$LANG.confirmnewpassword}</label>
                <div class="pr-pw-wrap">
                    <input type="password" name="confirmpw" class="pr-field" id="prPw2" autocomplete="off" required>
                    <button type="button" class="pr-eye" onclick="var f=document.getElementById('prPw2');f.type=f.type=='password'?'text':'password'"><i class="fas fa-eye"></i></button>
                </div>
            </div>
            <button type="submit" class="pr-btn">{$LANG.clientareasavechanges}</button>
        </form>
        <a href="{$WEB_ROOT}/login.php" class="pr-link"><i class="fas fa-arrow-left me-1"></i> {$LANG.login}</a>
    {/if}

{elseif $innerTemplate == 'password-reset-security-prompt'}

    <!-- Step: Security question -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-shield-alt"></i></div>
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

    <!-- Fallback if $innerTemplate is empty -->
    <div class="pr-icon-wrap">
        <div class="pr-icon-circle"><i class="fas fa-key"></i></div>
    </div>
    <div class="pr-title">{$LANG.pwreset}</div>
    <div class="pr-sub">{$LANG.pwresetemailneeded}</div>
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
