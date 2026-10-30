{if $createSuccess}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.addedSuccess'}</p></div>
</div>
{elseif $createFailed}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.addFailed'}</p></div>
</div>
{elseif $saveSuccess}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.updateSuccess'}</p></div>
</div>
{elseif $saveFailed}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.saveFailed'}</p></div>
</div>
{elseif $setDefaultResult === true}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.defaultUpdateSuccess'}</p></div>
</div>
{elseif $setDefaultResult === false}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.defaultUpdateFailed'}</p></div>
</div>
{elseif $deleteResult === true}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.deleteSuccess'}</p></div>
</div>
{elseif $deleteResult === false}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='paymentMethods.deleteFailed'}</p></div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='paymentMethods.title'}</h1>
        <p class="snbd-page-sub">{lang key='paymentMethods.intro'}</p>
    </div>
    <div class="snbd-page-actions">
        {if $allowCreditCard}
            <a href="{routePath('account-paymentmethods-add')}" class="snbd-btn snbd-btn--primary">
                <i class="ti ti-credit-card" aria-hidden="true"></i>{lang key='paymentMethods.addNewCC'}
            </a>
        {/if}
        {if $allowBankDetails}
            <a href="{routePathWithQuery('account-paymentmethods-add', null, 'type=bankacct')}" class="snbd-btn snbd-btn--secondary">
                <i class="ti ti-building-bank" aria-hidden="true"></i>{lang key='paymentMethods.addNewBank'}
            </a>
        {/if}
    </div>
</div>

<section class="snbd-card" aria-labelledby="snbd-paymethods-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-paymethods-title"><i class="ti ti-credit-card" aria-hidden="true"></i>{lang key='paymentMethods.title'}</h2>
    </div>
    <div class="snbd-table-wrap">
        <table class="snbd-table" id="payMethodList">
            <caption class="snbd-visually-hidden">{lang key='paymentMethods.title'}</caption>
            <thead>
                <tr>
                    <th scope="col"><span class="snbd-visually-hidden">{lang key='paymentMethods.name'}</span></th>
                    <th scope="col">{lang key='paymentMethods.name'}</th>
                    <th scope="col">{lang key='paymentMethods.description'}</th>
                    <th scope="col">{lang key='paymentMethods.status'}</th>
                    <th scope="col" class="snbd-table__actions"><span class="snbd-visually-hidden">{lang key='paymentMethods.actions'}</span></th>
                </tr>
            </thead>
            <tbody>
                {foreach $client->payMethods->validateGateways() as $payMethod}
                <tr>
                    <td data-label="{lang key='paymentMethods.name'}">
                        <span class="snbd-stat__icon">
                            <i class="ti {if $payMethod->isCreditCard()}ti-credit-card{else}ti-building-bank{/if}" aria-hidden="true"></i>
                        </span>
                    </td>
                    <td data-label="{lang key='paymentMethods.name'}" class="fw-semibold">
                        {$payMethod->payment->getDisplayName()}
                        {if $payMethod->isDefaultPayMethod()}
                            <span class="snbd-chip snbd-chip--brand">{lang key='paymentMethods.default'}</span>
                        {/if}
                    </td>
                    <td data-label="{lang key='paymentMethods.description'}" class="snbd-muted">
                        {if $payMethod->description}{$payMethod->description}{else}&ndash;{/if}
                    </td>
                    <td data-label="{lang key='paymentMethods.status'}">
                        {if $payMethod->isExpired()}
                            <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>{$payMethod->getStatus()}</span>
                        {else}
                            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>{$payMethod->getStatus()}</span>
                        {/if}
                    </td>
                    <td class="snbd-table__actions" data-label="{lang key='paymentMethods.actions'}">
                        <div class="snbd-cluster snbd-cluster--loose justify-content-end">
                            {if !$payMethod->isDefaultPayMethod() && !$payMethod->isExpired()}
                                <a href="{routePath('account-paymentmethods-setdefault', $payMethod->id)}" class="snbd-btn snbd-btn--sm snbd-btn--secondary" data-snbd-set-default>
                                    {lang key='paymentMethods.setAsDefault'}
                                </a>
                            {/if}
                            <a href="{routePath('account-paymentmethods-view', $payMethod->id)}" class="snbd-btn snbd-btn--sm snbd-btn--secondary{if $payMethod->getType() == 'RemoteBankAccount'} disabled{/if}"{if $payMethod->getType() == 'RemoteBankAccount'} aria-disabled="true" tabindex="-1"{/if}>
                                <i class="ti ti-pencil" aria-hidden="true"></i>{lang key='paymentMethods.edit'}
                            </a>
                            {if $allowDelete}
                                <a href="{routePath('account-paymentmethods-delete', $payMethod->id)}" class="snbd-btn snbd-btn--sm snbd-btn--ghost" data-snbd-delete-method>
                                    <i class="ti ti-trash" aria-hidden="true"></i>{lang key='paymentMethods.delete'}
                                </a>
                            {/if}
                        </div>
                    </td>
                </tr>
                {foreachelse}
                <tr>
                    <td colspan="5">
                        <div class="snbd-empty">
                            <span class="snbd-empty__icon"><i class="ti ti-credit-card-off" aria-hidden="true"></i></span>
                            <p class="snbd-empty__title">{lang key='paymentMethods.noPaymentMethodsCreated'}</p>
                            <p class="snbd-empty__text">Add a card or bank account once and every future invoice can be paid with it.</p>
                        </div>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</section>

<form method="post" action="" id="frmSetDefaultPaymentMethod"></form>

<form method="post" action="" id="frmDeletePaymentMethod">
    <div class="snbd-modal" id="modalPaymentMethodDeleteConfirmation" aria-hidden="true" role="dialog" aria-modal="true" aria-labelledby="snbdDeletePayMethodTitle">
        <div class="snbd-modal__backdrop" aria-hidden="true"></div>
        <div class="snbd-modal__dialog">
            <div class="snbd-modal__head">
                <h2 class="snbd-modal__title" id="snbdDeletePayMethodTitle">{lang key='paymentMethods.areYouSure'}</h2>
                <button type="button" class="snbd-modal__close" data-snbd-modal-close aria-label="Close">
                    <i class="ti ti-x" aria-hidden="true"></i>
                </button>
            </div>
            <div class="snbd-modal__body">
                <p class="mb-0">{lang key='paymentMethods.deletePaymentMethodConfirm'}</p>
            </div>
            <div class="snbd-modal__foot">
                <button type="button" class="snbd-btn snbd-btn--secondary" data-snbd-modal-close>{lang key='no'}</button>
                <button type="submit" class="snbd-btn snbd-btn--danger">{lang key='yes'}</button>
            </div>
        </div>
    </div>
</form>

<script>
    jQuery(document).ready(function ($) {
        $('[data-snbd-set-default]').on('click', function (e) {
            e.preventDefault();
            $('#frmSetDefaultPaymentMethod').attr('action', $(this).attr('href')).trigger('submit');
        });

        $('[data-snbd-delete-method]').on('click', function (e) {
            e.preventDefault();
            $('#frmDeletePaymentMethod').attr('action', $(this).attr('href'));
            if (window.snbdOpenModal) {
                window.snbdOpenModal(document.getElementById('modalPaymentMethodDeleteConfirmation'));
            }
        });
    });
</script>
