{if $overdueinvoice}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='upgradeerroroverdueinvoice'}</p></div>
</div>
{elseif $existingupgradeinvoice}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='upgradeexistingupgradeinvoice'}</p></div>
</div>
{elseif $upgradenotavailable}
<div class="snbd-alert snbd-alert--info" role="status">
    <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='upgradeNotPossible'}</p></div>
</div>
{elseif $upgradeinvalid}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$upgradeinvaliderror}</p></div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{lang key='clientareaproductdetails'}</p>
        <h1 class="snbd-page-title">{lang key='upgrade'}</h1>
        <p class="snbd-page-sub">{if $type eq "package"}{lang key='upgradechoosepackage'}{else}{lang key='upgradechooseconfigoptions'}{/if}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="clientarea.php?action=productdetails&id={$id}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
        </a>
    </div>
</div>

{if $overdueinvoice || $existingupgradeinvoice || $upgradenotavailable || $upgradeinvalid}

<section class="snbd-card">
    <div class="snbd-card__foot">
        <a href="clientarea.php?action=productdetails&id={$id}" class="snbd-btn snbd-btn--primary">{lang key='clientareabacklink'}</a>
        {if $existingupgradeinvoice || $upgradenotavailable}
        <a href="submitticket.php" class="snbd-btn snbd-btn--secondary">{lang key='submitticketdescription'}</a>
        {/if}
    </div>
</section>

{else}

<div class="snbd-card snbd-card--muted mb-4">
    <div class="snbd-card__body">
        <dl class="snbd-kv">
            <div class="snbd-kv__row">
                <dt class="snbd-kv__k">{lang key='upgradecurrentconfig'}</dt>
                <dd class="snbd-kv__v">
                    <span class="fw-semibold">{$groupname} - {$productname}</span>
                    {if $domain}<span class="snbd-muted">({$domain})</span>{/if}
                </dd>
            </div>
        </dl>
    </div>
</div>

{if $type eq "package"}

<section class="snbd-card" aria-labelledby="snbd-upgrade-packages">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-upgrade-packages"><i class="ti ti-arrow-up-circle" aria-hidden="true"></i>{lang key='upgradenewconfig'}</h2>
    </div>
    <div class="snbd-card__body snbd-card__body--flush">
        <table class="snbd-table">
            <caption class="snbd-visually-hidden">{lang key='upgradenewconfig'}</caption>
            <thead>
                <tr>
                    <th scope="col">{lang key='orderdesc'}</th>
                    <th scope="col">{lang key='orderprice'}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $upgradepackages as $upgradepackage}
                <tr>
                    <td data-label="{lang key='orderdesc'}">
                        <span class="fw-semibold">{$upgradepackage.groupname} - {$upgradepackage.name}</span>
                        {if $upgradepackage.description}<span class="snbd-caption d-block">{$upgradepackage.description}</span>{/if}
                    </td>
                    <td data-label="{lang key='orderprice'}">
                        <form method="post" action="{$smarty.server.PHP_SELF}" class="snbd-form">
                            <input type="hidden" name="step" value="2">
                            <input type="hidden" name="token" value="{$token}">
                            <input type="hidden" name="type" value="{$type}">
                            <input type="hidden" name="id" value="{$id}">
                            <input type="hidden" name="pid" value="{$upgradepackage.pid}">
                            {if $upgradepackage.pricing.type eq "free"}
                                <p class="snbd-caption mb-2">{lang key='orderfree'}</p>
                                <input type="hidden" name="billingcycle" value="free">
                            {elseif $upgradepackage.pricing.type eq "onetime"}
                                <p class="snbd-caption mb-2">{$upgradepackage.pricing.onetime} {lang key='orderpaymenttermonetime'}</p>
                                <input type="hidden" name="billingcycle" value="onetime">
                            {elseif $upgradepackage.pricing.type eq "recurring"}
                                <label class="snbd-visually-hidden" for="billing-cycle-{$upgradepackage.pid}">{lang key='billingcycle'}</label>
                                <select name="billingcycle" id="billing-cycle-{$upgradepackage.pid}" class="snbd-input form-select mb-2">
                                    {if $upgradepackage.pricing.monthly}<option value="monthly">{$upgradepackage.pricing.monthly}</option>{/if}
                                    {if $upgradepackage.pricing.quarterly}<option value="quarterly">{$upgradepackage.pricing.quarterly}</option>{/if}
                                    {if $upgradepackage.pricing.semiannually}<option value="semiannually">{$upgradepackage.pricing.semiannually}</option>{/if}
                                    {if $upgradepackage.pricing.annually}<option value="annually">{$upgradepackage.pricing.annually}</option>{/if}
                                    {if $upgradepackage.pricing.biennially}<option value="biennially">{$upgradepackage.pricing.biennially}</option>{/if}
                                    {if $upgradepackage.pricing.triennially}<option value="triennially">{$upgradepackage.pricing.triennially}</option>{/if}
                                </select>
                            {/if}
                            <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block" id="btnUpgradeDowngradeChooseProduct">
                                {lang key='upgradedowngradechooseproduct'}
                            </button>
                        </form>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</section>

{elseif $type eq "configoptions"}

{if $errormessage}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">{$errormessage}</div>
</div>
{/if}

<form method="post" action="{$smarty.server.PHP_SELF}" class="snbd-form">
    <input type="hidden" name="step" value="2" />
    <input type="hidden" name="token" value="{$token}" />
    <input type="hidden" name="type" value="{$type}" />
    <input type="hidden" name="id" value="{$id}" />

    <section class="snbd-card" aria-labelledby="snbd-upgrade-options">
        <div class="snbd-card__head">
            <h2 class="snbd-card__title" id="snbd-upgrade-options"><i class="ti ti-adjustments" aria-hidden="true"></i>{lang key='upgradenewconfig'}</h2>
        </div>
        <div class="snbd-card__body snbd-card__body--flush">
            <table class="snbd-table">
                <caption class="snbd-visually-hidden">{lang key='upgradechooseconfigoptions'}</caption>
                <thead>
                    <tr>
                        <th scope="col">{lang key='upgradecurrentconfig'}</th>
                        <th scope="col">{lang key='upgradenewconfig'}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $configoptions as $configoption}
                    <tr>
                        <td data-label="{$configoption.optionname}">
                            <span class="fw-semibold d-block">{$configoption.optionname}</span>
                            {if $configoption.optiontype eq 1 || $configoption.optiontype eq 2}
                                {$configoption.selectedname}
                            {elseif $configoption.optiontype eq 3}
                                {if $configoption.selectedqty}{lang key='yes'}{else}{lang key='no'}{/if}
                            {elseif $configoption.optiontype eq 4}
                                {$configoption.selectedqty} x {$configoption.options.0.name}
                            {/if}
                        </td>
                        <td data-label="{lang key='upgradenewconfig'}">
                            {if $configoption.optiontype eq 1 || $configoption.optiontype eq 2}
                                <label class="snbd-visually-hidden" for="configoption-{$configoption.id}">{$configoption.optionname}</label>
                                <select name="configoption[{$configoption.id}]" id="configoption-{$configoption.id}" class="snbd-input form-select">
                                    {foreach $configoption.options as $option}
                                        {if !empty($option.selected)}
                                        <option value="{$option.id}" selected>{lang key='upgradenochange'}</option>
                                        {else}
                                        <option value="{$option.id}">{$option.nameonly} {$option.price}</option>
                                        {/if}
                                    {/foreach}
                                </select>
                            {elseif $configoption.optiontype eq 3}
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" name="configoption[{$configoption.id}]" id="configoption-{$configoption.id}" value="1"{if $configoption.selectedqty} checked{/if}>
                                    <label class="form-check-label" for="configoption-{$configoption.id}">{$configoption.options.0.name}</label>
                                </div>
                            {elseif $configoption.optiontype eq 4}
                                <div class="d-flex align-items-center gap-2">
                                    <input type="text" class="snbd-input form-control" name="configoption[{$configoption.id}]" value="{$configoption.selectedqty}" size="5" aria-label="{$configoption.optionname}">
                                    <span>x {$configoption.options.0.name}</span>
                                </div>
                            {/if}
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
        <div class="snbd-card__foot">
            <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='continue'} <i class="ti ti-arrow-right" aria-hidden="true"></i></button>
            <a href="clientarea.php?action=productdetails&id={$id}" class="snbd-btn snbd-btn--ghost">{lang key='cancel'}</a>
        </div>
    </section>
</form>

{/if}
{/if}
