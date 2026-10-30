<div class="snbd-auth">
    <main class="snbd-auth__main">
        <div class="snbd-auth__card">
            <h1 class="snbd-auth__title">{lang key='twofactorauth'}</h1>
            <p class="snbd-auth__sub">{lang key='twofa2ndfactorreq'}</p>

            <div>
                {if $newbackupcode}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='twofabackupcodereset'}</p></div>
</div>
                {elseif $incorrect}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='twofa2ndfactorincorrect'}</p></div>
</div>
                {elseif $error}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$error}</p></div>
</div>
                {else}
<div class="snbd-alert snbd-alert--info" role="status">
    <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='twofa2ndfactorreq'}</p></div>
</div>
                {/if}

                <form method="post" action="{routePath('login-two-factor-challenge-verify')}" id="frmTwoFactorChallenge" class="snbd-form{if $usingBackup} w-hidden{/if}">
                    <div class="mb-3">
                        {$challenge}
                    </div>
                </form>

                <form method="post" action="{routePath('login-two-factor-challenge-backup-verify')}" id="frmTwoFactorBackup" class="snbd-form{if !$usingBackup} w-hidden{/if}">
                    <label class="snbd-label" for="inputTwoFactorBackupCode">{lang key='twofabackupcodelogin'}</label>
                    <input type="text" name="twofabackupcode" id="inputTwoFactorBackupCode" class="snbd-input form-control form-control-lg" placeholder="{lang key='twofabackupcodelogin'}" autocomplete="one-time-code">
                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block mt-3" id="btnLogin">{lang key='loginbutton'}</button>
                    <button type="button" class="snbd-btn snbd-btn--ghost snbd-btn--block mt-2" id="backupCodeCancel">{lang key='cancel'}</button>
                </form>
            </div>

            <div class="mt-3" id="frmTwoFactorChallengeFooter">
                <p class="snbd-caption mb-0">
                    {lang key='twofacantaccess2ndfactor'}
                    <a href="#" id="loginWithBackupCode">{lang key='twofaloginusingbackupcode'}</a>
                </p>
            </div>
        </div>
    </main>
</div>

<script>
    jQuery(document).ready(function() {
        jQuery('#loginWithBackupCode').on('click', function(e) {
            e.preventDefault();
            jQuery('#frmTwoFactorChallenge').hide();
            jQuery('#frmTwoFactorChallengeFooter').hide();
            jQuery('#frmTwoFactorBackup').show();
        });
        jQuery('#backupCodeCancel').on('click', function(e) {
            e.preventDefault();
            jQuery('#frmTwoFactorChallenge').show();
            jQuery('#frmTwoFactorChallengeFooter').show();
            jQuery('#frmTwoFactorBackup').hide();
        });
    });
</script>
