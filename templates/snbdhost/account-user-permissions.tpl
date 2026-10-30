{include file="$template/includes/flashmessage.tpl"}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{lang key="navUserManagement"}</p>
        <h1 class="snbd-page-title">{lang key="userManagement.managePermissions"}</h1>
        <p class="snbd-page-sub">{$user->email}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="{routePath('account-users')}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key="clientareacancel"}
        </a>
    </div>
</div>

<section class="snbd-card" aria-labelledby="snbd-permissions-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-permissions-title"><i class="ti ti-key" aria-hidden="true"></i>{lang key="userManagement.permissions"}</h2>
    </div>
    <form method="post" action="{routePath('account-users-permissions-save', $user->id)}" class="snbd-form">
        <div class="snbd-card__body">
            {foreach $permissions as $permission}
            <div class="form-check mb-2">
                <input type="checkbox" class="form-check-input" name="perms[{$permission.key}]" id="perm-{$permission.key}" value="1"{if $userPermissions->hasPermission($permission.key)} checked{/if}>
                <label class="form-check-label" for="perm-{$permission.key}">
                    <span class="fw-semibold">{$permission.title}</span>
                    <span class="snbd-caption d-block">{$permission.description}</span>
                </label>
            </div>
            {/foreach}
        </div>
        <div class="snbd-card__foot">
            <button type="submit" class="snbd-btn snbd-btn--primary">{lang key="clientareasavechanges"}</button>
            <a href="{routePath('account-users')}" class="snbd-btn snbd-btn--ghost">{lang key="clientareacancel"}</a>
        </div>
    </form>
</section>
