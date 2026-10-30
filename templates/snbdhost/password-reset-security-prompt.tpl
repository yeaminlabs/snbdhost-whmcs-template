{* Overrides templates/twenty-one/password-reset-security-prompt.tpl *}
<form method="post" action="{routePath('password-reset-security-verify')}" class="snbd-form" novalidate>
    <div class="mb-4">
        <label class="snbd-label" for="securityAnswer">{$securityQuestion}</label>
        <input type="text" name="answer" id="securityAnswer" class="form-control" autofocus required>
    </div>
    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block">{lang key='pwresetsubmit'}<i class="ti ti-arrow-right" aria-hidden="true"></i></button>
</form>
