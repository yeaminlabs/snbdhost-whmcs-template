{* Overrides templates/twenty-one/password-reset-change-prompt.tpl *}
<form class="using-password-strength" method="post" action="{routePath('password-reset-change-perform')}" novalidate id="frmPasswordReset">
    <input type="hidden" name="answer" id="answer" value="{$securityAnswer}" />

    <div class="mb-3">
        <label class="pr-label" for="inputNewPassword1">{lang key='newpassword'}</label>
        <div class="pr-pw-wrap">
            <input type="password" name="newpw" id="inputNewPassword1" class="pr-field" autocomplete="off" required>
            <button type="button" class="pr-eye" onclick="var f=document.getElementById('inputNewPassword1');f.type=f.type=='password'?'text':'password'"><i class="fas fa-eye"></i></button>
        </div>
    </div>

    <div class="mb-3">
        <label class="pr-label" for="inputNewPassword2">{lang key='confirmnewpassword'}</label>
        <div class="pr-pw-wrap">
            <input type="password" name="confirmpw" id="inputNewPassword2" class="pr-field" autocomplete="off" required>
            <button type="button" class="pr-eye" onclick="var f=document.getElementById('inputNewPassword2');f.type=f.type=='password'?'text':'password'"><i class="fas fa-eye"></i></button>
        </div>
        <div class="pr-pw-hint" id="prPwMatch"></div>
    </div>

    {include file="$template/includes/pwstrength.tpl" maximumPasswordLength=$maximumPasswordLength}

    <button type="submit" class="pr-btn">{lang key='clientareasavechanges'}</button>
</form>

<script>{literal}
(function() {
    var pw1 = document.getElementById('inputNewPassword1');
    var pw2 = document.getElementById('inputNewPassword2');
    var match = document.getElementById('prPwMatch');
    if (!pw1 || !pw2 || !match) return;
    function checkMatch() {
        if (!pw2.value) { match.textContent = ''; match.className = 'pr-pw-hint'; return; }
        if (pw1.value === pw2.value) {
            match.className = 'pr-pw-hint is-ok';
            match.innerHTML = '<i class="fas fa-circle-check"></i><span>Passwords match</span>';
        } else {
            match.className = 'pr-pw-hint is-bad';
            match.innerHTML = '<i class="fas fa-circle-exclamation"></i><span>Passwords do not match</span>';
        }
    }
    pw1.addEventListener('input', checkMatch);
    pw2.addEventListener('input', checkMatch);
})();
{/literal}</script>
