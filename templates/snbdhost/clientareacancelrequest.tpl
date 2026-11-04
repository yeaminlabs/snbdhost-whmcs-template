{if $invalid}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='clientareacancelinvalid'}</p></div>
</div>
<div class="snbd-page-actions">
    <a href="clientarea.php?action=productdetails&amp;id={$id}" class="snbd-btn snbd-btn--primary">{lang key='clientareabacklink'}</a>
</div>

{elseif $requested}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='clientareacancelconfirmation'}</p></div>
</div>
<div class="snbd-page-actions">
    <a href="clientarea.php?action=productdetails&amp;id={$id}" class="snbd-btn snbd-btn--primary">{lang key='clientareabacklink'}</a>
</div>

{else}
<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Service</p>
        <h1 class="snbd-page-title">{lang key='clientareacancelrequest'}</h1>
        <p class="snbd-page-sub">{lang key='clientareacancelproduct'}: <strong>{$groupname} - {$productname}</strong>{if $domain} ({$domain}){/if}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="clientarea.php?action=productdetails&amp;id={$id}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
        </a>
    </div>
</div>

{if $error}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__text">{lang key='clientareaerrors'}</p>
        <ul class="mb-0">{lang key='clientareacancelreasonrequired'}</ul>
    </div>
</div>
{/if}

<form method="post" action="{$smarty.server.PHP_SELF}?action=cancel&amp;id={$id}" class="snbd-form">
    <input type="hidden" name="token" value="{$token}">
    <input type="hidden" name="sub" value="submit" />

    <section class="snbd-card" aria-labelledby="snbd-cancel-title">
        <div class="snbd-card__head">
            <h2 class="snbd-card__title" id="snbd-cancel-title"><i class="ti ti-circle-minus" aria-hidden="true"></i>{lang key='clientareacancelrequest'}</h2>
        </div>

        <div class="snbd-card__body">
            <div>
                <label class="snbd-label" for="cancellationreason">{lang key='clientareacancelreason'}</label>
                <textarea name="cancellationreason" id="cancellationreason" class="snbd-input form-control" rows="6"></textarea>
            </div>

            {if $domainid}
            <div class="snbd-alert snbd-alert--warn" role="alert">
                <i class="ti ti-world snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body">
                    <p class="snbd-alert__text"><strong>{lang key='cancelrequestdomain'}</strong></p>
                    <p class="snbd-alert__text">{"{lang key='cancelrequestdomaindesc'}"|sprintf2:$domainnextduedate:$domainprice:$domainregperiod}</p>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" name="canceldomain" id="canceldomain" />
                        <label class="form-check-label" for="canceldomain">{lang key='cancelrequestdomainconfirm'}</label>
                    </div>
                </div>
            </div>
            {/if}

            <div>
                <label class="snbd-label" for="type">{lang key='clientareacancellationtype'}</label>
                <select name="type" id="type" class="snbd-input form-select">
                    <option value="Immediate">{lang key='clientareacancellationimmediate'}</option>
                    <option value="End of Billing Period">{lang key='clientareacancellationendofbillingperiod'}</option>
                </select>
            </div>
        </div>

        <div class="snbd-card__foot">
            <button type="submit" class="snbd-btn snbd-btn--danger">{lang key='clientareacancelrequestbutton'}</button>
            <a href="clientarea.php?action=productdetails&amp;id={$id}" class="snbd-btn snbd-btn--ghost">{lang key='cancel'}</a>
        </div>
    </section>
</form>
{/if}
