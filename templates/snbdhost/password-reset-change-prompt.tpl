{* Overrides templates/twenty-one/password-reset-change-prompt.tpl *}
<form class="using-password-strength snbd-form" method="post" action="{routePath('password-reset-change-perform')}" novalidate id="frmPasswordReset">
    <input type="hidden" name="answer" id="answer" value="{$securityAnswer}">

    <div class="mb-3">
        <label class="snbd-label" for="inputNewPassword1">{lang key='newpassword'}</label>
        <div class="snbd-password">
            <input type="password" name="newpw" id="inputNewPassword1" class="form-control" autocomplete="new-password" required>
            <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputNewPassword1" aria-label="Show password"><i class="ti ti-eye" aria-hidden="true"></i></button>
        </div>
    </div>

    <div class="mb-3">
        <label class="snbd-label" for="inputNewPassword2">{lang key='confirmnewpassword'}</label>
        <div class="snbd-password">
            <input type="password" name="confirmpw" id="inputNewPassword2" class="form-control" autocomplete="new-password" required>
            <button type="button" class="snbd-password__toggle" data-snbd-password-toggle="#inputNewPassword2" aria-label="Show password"><i class="ti ti-eye" aria-hidden="true"></i></button>
        </div>
        <p class="snbd-hint" id="prPwMatch" role="status" aria-live="polite"></p>
    </div>

    {include file="$template/includes/pwstrength.tpl" maximumPasswordLength=$maximumPasswordLength}

    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block">{lang key='clientareasavechanges'}</button>
</form>

<script>
{literal}
(function () {
    var pw1 = document.getElementById('inputNewPassword1');
    var pw2 = document.getElementById('inputNewPassword2');
    var match = document.getElementById('prPwMatch');
    if (!pw1 || !pw2 || !match) return;
    function checkMatch() {
        if (!pw2.value) { match.textContent = ''; match.className = 'snbd-hint'; return; }
        if (pw1.value === pw2.value) {
            match.className = 'snbd-hint snbd-hint--ok';
            match.innerHTML = '<i class="ti ti-circle-check"></i> Passwords match';
        } else {
            match.className = 'snbd-hint snbd-hint--bad';
            match.innerHTML = '<i class="ti ti-alert-circle"></i> Passwords do not match';
        }
    }
    pw1.addEventListener('input', checkMatch);
    pw2.addEventListener('input', checkMatch);
})();
{/literal}
</script>
