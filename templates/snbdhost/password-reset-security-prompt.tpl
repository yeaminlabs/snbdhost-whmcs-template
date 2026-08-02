{* Overrides templates/twenty-one/password-reset-security-prompt.tpl *}
<form method="post" action="{routePath('password-reset-security-verify')}" novalidate>
    <div class="mb-3">
        <label class="pr-label">{$securityQuestion}</label>
        <input type="text" name="answer" class="pr-field" autofocus required>
    </div>
    <button type="submit" class="pr-btn">{lang key='pwresetsubmit'} <i class="fas fa-arrow-right ms-2"></i></button>
</form>
