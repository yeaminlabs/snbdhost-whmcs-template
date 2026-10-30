<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Account</p>
        <h1 class="snbd-page-title">{lang key="navUserManagement"}</h1>
        <p class="snbd-page-sub">{lang key="userManagement.usersFound" count=$users->count()}</p>
    </div>
</div>

<section class="snbd-card" aria-labelledby="snbd-users-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-users-title"><i class="ti ti-users" aria-hidden="true"></i>{lang key="navUserManagement"}</h2>
        <span class="snbd-chip snbd-chip--neutral">{$users->count()}</span>
    </div>
    <div class="snbd-table-wrap">
        <table class="snbd-table">
            <caption class="snbd-visually-hidden">{lang key="navUserManagement"}</caption>
            <thead>
                <tr>
                    <th scope="col">{lang key="userManagement.emailAddress"} / {lang key="userManagement.lastLogin"}</th>
                    <th scope="col" class="snbd-table__actions">{lang key="userManagement.actions"}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $users as $user}
                <tr>
                    <td data-label="{lang key="userManagement.emailAddress"}">
                        <span class="d-flex align-items-center gap-2 fw-semibold">
                            {$user->email}
                            {if $user->pivot->owner}
                            <span class="snbd-chip snbd-chip--brand">{lang key="clientOwner"}</span>
                            {/if}
                            {if $user->hasTwoFactorAuthEnabled()}
                            <i class="ti ti-shield-check text-success" title="{lang key='twoFactor.enabled'}" aria-label="{lang key='twoFactor.enabled'}"></i>
                            {else}
                            <i class="ti ti-shield-off snbd-muted" title="{lang key='twoFactor.disabled'}" aria-label="{lang key='twoFactor.disabled'}"></i>
                            {/if}
                        </span>
                        <span class="snbd-caption">
                            {lang key="userManagement.lastLogin"}:
                            {if $user->pivot->hasLastLogin()}
                                {$user->pivot->getLastLogin()->diffForHumans()}
                            {else}
                                {lang key='never'}
                            {/if}
                        </span>
                    </td>
                    <td class="snbd-table__actions" data-label="{lang key="userManagement.actions"}">
                        <div class="snbd-cluster snbd-cluster--loose justify-content-end">
                            <a href="{routePath('account-users-permissions', $user->id)}" class="snbd-btn snbd-btn--sm snbd-btn--secondary{if $user->pivot->owner} disabled{/if}"{if $user->pivot->owner} aria-disabled="true" tabindex="-1"{/if}>
                                <i class="ti ti-key" aria-hidden="true"></i>{lang key="userManagement.managePermissions"}
                            </a>
                            <button type="button" class="snbd-btn snbd-btn--sm snbd-btn--ghost btn-remove-user{if $user->pivot->owner} disabled{/if}" data-user-id="{$user->id}" data-bs-toggle="modal" data-bs-target="#modalRemoveUser"{if $user->pivot->owner} disabled{/if}>
                                <i class="ti ti-user-minus" aria-hidden="true"></i>{lang key="userManagement.removeAccess"}
                            </button>
                        </div>
                    </td>
                </tr>
                {/foreach}

                {if $invites->count() > 0}
                {foreach $invites as $invite}
                <tr>
                    <td data-label="{lang key="userManagement.emailAddress"}">
                        <span class="fw-semibold">{$invite->email}</span>
                        <span class="snbd-chip snbd-chip--warn ms-1"><span class="snbd-chip__dot" aria-hidden="true"></span>{lang key="userManagement.pendingInvites"}</span>
                        <span class="snbd-caption">
                            {lang key="userManagement.inviteSent"}:
                            {$invite->created_at->diffForHumans()}
                        </span>
                    </td>
                    <td class="snbd-table__actions" data-label="{lang key="userManagement.actions"}">
                        <div class="snbd-cluster snbd-cluster--loose justify-content-end">
                            <form method="post" action="{routePath('account-users-invite-resend')}" class="d-inline">
                                <input type="hidden" name="inviteid" value="{$invite->id}">
                                <button type="submit" class="snbd-btn snbd-btn--sm snbd-btn--secondary">
                                    <i class="ti ti-send" aria-hidden="true"></i>{lang key="userManagement.resendInvite"}
                                </button>
                            </form>
                            <button type="button" class="snbd-btn snbd-btn--sm snbd-btn--ghost btn-cancel-invite" data-invite-id="{$invite->id}" data-bs-toggle="modal" data-bs-target="#modalCancelInvite">
                                <i class="ti ti-x" aria-hidden="true"></i>{lang key="userManagement.cancelInvite"}
                            </button>
                        </div>
                    </td>
                </tr>
                {/foreach}
                {/if}
            </tbody>
        </table>
    </div>
    <div class="snbd-card__foot">
        <p class="snbd-hint mb-0">* {lang key="userManagement.accountOwnerPermissionsInfo"}</p>
    </div>
</section>

<section class="snbd-card" aria-labelledby="snbd-invite-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-invite-title"><i class="ti ti-user-plus" aria-hidden="true"></i>{lang key="userManagement.inviteNewUser"}</h2>
    </div>
    <form method="post" action="{routePath('account-users-invite')}" class="snbd-form">
        <div class="snbd-card__body">
            <p class="snbd-caption">{lang key="userManagement.inviteNewUserDescription"}</p>

            <label class="snbd-label" for="inputInviteEmail">{lang key="userManagement.emailAddress"}</label>
            <input type="email" name="inviteemail" id="inputInviteEmail" placeholder="name@example.com" class="snbd-input form-control" value="{$formdata.inviteemail}">

            <fieldset class="mt-3">
                <legend class="snbd-label">{lang key="userManagement.permissions"}</legend>
                <div class="snbd-choice">
                    <label class="snbd-choice__option">
                        <input type="radio" class="form-check-input" name="permissions" value="all" checked="checked">
                        <span>{lang key="userManagement.allPermissions"}</span>
                    </label>
                    <label class="snbd-choice__option">
                        <input type="radio" class="form-check-input" name="permissions" value="choose">
                        <span>{lang key="userManagement.choosePermissions"}</span>
                    </label>
                </div>
            </fieldset>

            <div class="snbd-card snbd-card--muted mt-3 d-none" id="invitePermissions">
                <div class="snbd-card__body">
                    {foreach $permissions as $permission}
                    <div class="form-check mb-2">
                        <input type="checkbox" class="form-check-input" name="perms[{$permission.key}]" id="perm-{$permission.key}" value="1">
                        <label class="form-check-label" for="perm-{$permission.key}">
                            <span class="fw-semibold">{$permission.title}</span>
                            <span class="snbd-caption d-block">{$permission.description}</span>
                        </label>
                    </div>
                    {/foreach}
                </div>
            </div>
        </div>
        <div class="snbd-card__foot">
            <button type="submit" class="snbd-btn snbd-btn--primary">{lang key="userManagement.sendInvite"}</button>
        </div>
    </form>
</section>

<form method="post" action="{routePath('user-accounts')}">
    <input type="hidden" name="id" value="" id="inputSwitchAcctId">
</form>

<form method="post" action="{routePath('account-users-remove')}" id="frmRemoveUser">
    <input type="hidden" name="userid" id="inputRemoveUserId">
    <div class="modal fade" id="modalRemoveUser" tabindex="-1" role="dialog" aria-labelledby="modalRemoveUserLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title" id="modalRemoveUserLabel">{lang key="userManagement.removeAccess"}</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{lang key='cancel'}"></button>
                </div>
                <div class="modal-body">
                    <p>{lang key="userManagement.removeAccessSure"}</p>
                    <p class="snbd-caption mb-0">{lang key="userManagement.removeAccessInfo"}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="snbd-btn snbd-btn--ghost" data-bs-dismiss="modal">{lang key="cancel"}</button>
                    <button type="submit" class="snbd-btn snbd-btn--danger" id="btnRemoveUserConfirm">{lang key="confirm"}</button>
                </div>
            </div>
        </div>
    </div>
</form>

<form method="post" action="{routePath('account-users-invite-cancel')}" id="frmCancelInvite">
    <input type="hidden" name="inviteid" id="inputCancelInviteId">
    <div class="modal fade" id="modalCancelInvite" tabindex="-1" role="dialog" aria-labelledby="modalCancelInviteLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title" id="modalCancelInviteLabel">{lang key="userManagement.cancelInvite"}</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{lang key='cancel'}"></button>
                </div>
                <div class="modal-body">
                    <p>{lang key="userManagement.cancelInviteSure"}</p>
                    <p class="snbd-caption mb-0">{lang key="userManagement.cancelInviteInfo"}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="snbd-btn snbd-btn--ghost" data-bs-dismiss="modal">{lang key="cancel"}</button>
                    <button type="submit" class="snbd-btn snbd-btn--danger" id="btnCancelInviteConfirm">{lang key="confirm"}</button>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    jQuery(document).ready(function() {
        jQuery('input:radio[name=permissions]').on('change', function () {
            jQuery('#invitePermissions').toggleClass('d-none', this.value !== 'choose');
        });

        jQuery('.btn-remove-user').on('click', function () {
            jQuery('#inputRemoveUserId').val(jQuery(this).data('user-id'));
        });

        jQuery('.btn-cancel-invite').on('click', function () {
            jQuery('#inputCancelInviteId').val(jQuery(this).data('invite-id'));
        });
    });
</script>
