<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='sso.title'}</h1>
        <p class="snbd-page-sub">Control how you sign in to the client area and which linked accounts can reach it.</p>
    </div>
</div>

{if $showSsoSetting}
<section class="snbd-card" aria-labelledby="snbd-security-sso">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-security-sso"><i class="ti ti-key" aria-hidden="true"></i>{lang key='sso.title'}</h2>
        <span class="snbd-chip {if $isSsoEnabled}snbd-chip--ok{else}snbd-chip--neutral{/if}">
            <span class="snbd-chip__dot" aria-hidden="true"></span>
            {if $isSsoEnabled}{lang key='sso.enabled'}{else}{lang key='sso.disabled'}{/if}
        </span>
    </div>
    <form id="frmSingleSignOn" method="post" action="clientarea.php?action=security" class="snbd-form">
        <input type="hidden" name="token" value="{$token}">
        <input type="hidden" name="action" value="security">
        <input type="hidden" name="toggle_sso" value="1">
        <div class="snbd-card__body">
            <div class="form-check">
                <input type="checkbox" name="allow_sso" class="form-check-input" id="inputAllowSso" value="1"{if $isSsoEnabled} checked{/if}>
                <label class="form-check-label" for="inputAllowSso">{lang key='sso.summary'}</label>
            </div>
            <p class="snbd-hint">{lang key='sso.disablenotice'}</p>
        </div>
        <div class="snbd-card__foot">
            <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='clientareasavechanges'}</button>
        </div>
    </form>
</section>
{else}
<section class="snbd-card">
    <div class="snbd-empty">
        <span class="snbd-empty__icon"><i class="ti ti-shield-check" aria-hidden="true"></i></span>
        <p class="snbd-empty__title">Nothing to configure here</p>
        <p class="snbd-empty__text">Single sign-on is not enabled on this account. Password and two-factor settings live in your profile.</p>
        <a href="clientarea.php?action=details" class="snbd-btn snbd-btn--secondary snbd-btn--sm">Review my details</a>
    </div>
</section>
{/if}
