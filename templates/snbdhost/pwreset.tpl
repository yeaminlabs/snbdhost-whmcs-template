<!-- ====== PASSWORD RESET PAGE ====== -->
<style>
.pwreset-wrap {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f4f5f7;
    padding: 2rem 1rem;
}
.pwreset-card {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 4px 32px rgba(0,0,0,0.10);
    padding: 2.5rem 2rem;
    width: 100%;
    max-width: 440px;
}
.pwreset-logo {
    text-align: center;
    margin-bottom: 1.5rem;
}
.pwreset-logo .logo-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 56px; height: 56px;
    background: linear-gradient(135deg, #CC0000, #990000);
    border-radius: 14px;
    color: #fff;
    font-size: 1.5rem;
    margin-bottom: 0.75rem;
}
.pwreset-logo .logo-name {
    font-size: 1.2rem;
    font-weight: 700;
    color: #111;
}
.pwreset-title {
    text-align: center;
    font-size: 1.4rem;
    font-weight: 700;
    color: #111;
    margin-bottom: 0.35rem;
}
.pwreset-sub {
    text-align: center;
    font-size: 0.9rem;
    color: #777;
    margin-bottom: 1.75rem;
}
.pwreset-input {
    background: #f8f8f8 !important;
    border: 1.5px solid #e5e5e5 !important;
    border-radius: 10px !important;
    padding: 0.85rem 1rem !important;
    font-size: 0.95rem !important;
    color: #111 !important;
    height: auto !important;
    box-shadow: none !important;
    width: 100%;
    transition: border-color 0.2s;
}
.pwreset-input:focus {
    border-color: #CC0000 !important;
    background: #fff !important;
    box-shadow: 0 0 0 3px rgba(204,0,0,0.09) !important;
    outline: none !important;
}
.pwreset-btn {
    width: 100%;
    background: #CC0000;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 0.85rem 1rem;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
    margin-top: 0.25rem;
}
.pwreset-btn:hover { background: #aa0000; color: #fff; }
.pwreset-back {
    display: block;
    text-align: center;
    margin-top: 1.25rem;
    color: #666;
    font-size: 0.9rem;
    text-decoration: none;
}
.pwreset-back:hover { color: #CC0000; }
.pwreset-alert-ok {
    background: rgba(0,150,70,0.09);
    border: 1px solid rgba(0,150,70,0.2);
    color: #006830;
    border-radius: 10px;
    padding: 0.75rem 1rem;
    font-size: 0.9rem;
    margin-bottom: 1.25rem;
}
.pwreset-alert-err {
    background: rgba(204,0,0,0.08);
    border: 1px solid rgba(204,0,0,0.18);
    color: #CC0000;
    border-radius: 10px;
    padding: 0.75rem 1rem;
    font-size: 0.9rem;
    margin-bottom: 1.25rem;
}
</style>

<div class="pwreset-wrap">
    <div class="pwreset-card">

        <div class="pwreset-logo">
            <div class="logo-icon"><i class="fas fa-key"></i></div>
            <div class="logo-name">{$companyname}</div>
        </div>

        <div class="pwreset-title">{$LANG.pwreset}</div>
        <div class="pwreset-sub">{$LANG.pwresetemailneeded}</div>

        {if $success}
            <div class="pwreset-alert-ok">
                <i class="fas fa-check-circle me-2"></i>{$LANG.pwresetvalidationsent}
            </div>

            <!-- Success Popup Modal -->
            <div id="successModal" class="custom-modal-overlay">
                <div class="custom-modal-card">
                    <div class="custom-modal-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h3 class="custom-modal-title">Reset Link Sent</h3>
                    <p class="custom-modal-text">{$LANG.pwresetvalidationsent}</p>
                    <button class="custom-modal-btn" onclick="closeSuccessModal()">Close</button>
                </div>
            </div>

            <style>
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
            </style>
            <script>
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
            </script>
        {else}
            {if $errormessage}
                <div class="pwreset-alert-err">
                    <i class="fas fa-exclamation-circle me-2"></i>{$errormessage}
                </div>
            {/if}

            <form method="post" action="{$systemurl}pwreset.php" novalidate>
                <input type="hidden" name="action" value="reset" />
                <div class="mb-3">
                    <input type="email" name="email" class="form-control pwreset-input" id="inputEmail" placeholder="{$LANG.loginemail}" autofocus required>
                </div>

                {if $captcha || $turnstileEnabled}
                    <div style="margin-bottom: 1.25rem;">
                        {include file="$template/includes/captcha.tpl"}
                    </div>
                {/if}

                <button type="submit" class="pwreset-btn{if is_object($captcha)} {$captcha->getButtonClass($captchaForm)}{/if}">
                    {$LANG.pwresetsubmit}
                </button>
            </form>
        {/if}

        <a href="{$WEB_ROOT}/login.php" class="pwreset-back">
            <i class="fas fa-arrow-left me-1"></i> {$LANG.login}
        </a>

    </div>
</div>
