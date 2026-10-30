{if $promoerror}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$promoerror}</p></div>
</div>
{/if}

{if $promorecurring}
<div class="snbd-alert snbd-alert--info" role="status">
    <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{"{lang key='recurringpromodesc'}"|sprintf2:$promorecurring}</p></div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{lang key='orderForm.orderSummary'}</p>
        <h1 class="snbd-page-title">{lang key='upgrade'}</h1>
        <p class="snbd-page-sub">{lang key='upgradecurrentconfig'}: <strong>{$groupname} - {$productname}</strong>{if $domain} ({$domain}){/if}</p>
    </div>
</div>

<div class="row g-4">
    <div class="col-xl-8">
        <section class="snbd-card" aria-labelledby="snbd-upgrade-summary">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-upgrade-summary"><i class="ti ti-receipt" aria-hidden="true"></i>{lang key='orderForm.orderSummary'}</h2>
            </div>
            <div class="snbd-card__body snbd-card__body--flush">
                <table class="snbd-table">
                    <caption class="snbd-visually-hidden">{lang key='orderForm.orderSummary'}</caption>
                    <thead>
                        <tr>
                            <th scope="col">{lang key='orderdesc'}</th>
                            <th scope="col" class="snbd-table__num">{lang key='orderprice'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $upgrades as $upgrade}
                            {if $type eq "package"}
                            <tr>
                                <td data-label="{lang key='orderdesc'}">
                                    <input type="hidden" name="pid" value="{$upgrade.newproductid}" />
                                    <input type="hidden" name="billingcycle" value="{$upgrade.newproductbillingcycle}" />
                                    {$upgrade.oldproductname} &rarr; {$upgrade.newproductname}
                                </td>
                                <td data-label="{lang key='orderprice'}" class="snbd-table__num">{$upgrade.price}</td>
                            </tr>
                            {elseif $type eq "configoptions"}
                            <tr>
                                <td data-label="{lang key='orderdesc'}">{$upgrade.configname}: {$upgrade.originalvalue} &rarr; {$upgrade.newvalue}</td>
                                <td data-label="{lang key='orderprice'}" class="snbd-table__num">{$upgrade.price}</td>
                            </tr>
                            {/if}
                        {/foreach}

                        <tr>
                            <th scope="row">{lang key='ordersubtotal'}</th>
                            <td class="snbd-table__num">{$subtotal}</td>
                        </tr>
                        {if $promodesc}
                        <tr>
                            <th scope="row">{$promodesc}</th>
                            <td class="snbd-table__num">{$discount}</td>
                        </tr>
                        {/if}
                        {if $taxrate}
                        <tr>
                            <th scope="row">{$taxname} @ {$taxrate}%</th>
                            <td class="snbd-table__num">{$tax}</td>
                        </tr>
                        {/if}
                        {if $taxrate2}
                        <tr>
                            <th scope="row">{$taxname2} @ {$taxrate2}%</th>
                            <td class="snbd-table__num">{$tax2}</td>
                        </tr>
                        {/if}
                        <tr class="snbd-table__total">
                            <th scope="row">{lang key='ordertotalduetoday'}</th>
                            <td class="snbd-table__num snbd-price">{$total}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            {if $type eq "package"}
            <div class="snbd-card__foot">
                <p class="snbd-hint mb-0">
                    {lang key='upgradeproductlogic'} ({(string)$upgrade.daysuntilrenewal} {lang key='days'})
                </p>
            </div>
            {/if}
        </section>
    </div>

    <div class="col-xl-4">
        <section class="snbd-card" aria-labelledby="snbd-upgrade-promo">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-upgrade-promo"><i class="ti ti-ticket" aria-hidden="true"></i>{lang key='orderpromotioncode'}</h2>
            </div>
            <form method="post" action="{$smarty.server.PHP_SELF}" role="form" class="snbd-form">
                <input type="hidden" name="step" value="2" />
                <input type="hidden" name="type" value="{$type}" />
                <input type="hidden" name="id" value="{$id}" />
                {if $type eq "package"}
                    <input type="hidden" name="pid" value="{$upgrades.0.newproductid}" />
                    <input type="hidden" name="billingcycle" value="{$upgrades.0.newproductbillingcycle}" />
                {/if}
                {foreach $configoptions as $cid => $value}
                    <input type="hidden" name="configoption[{$cid}]" value="{$value}" />
                {/foreach}

                <div class="snbd-card__body">
                    <label class="snbd-visually-hidden" for="inputPromoCode">{lang key='orderpromotioncode'}</label>
                    <input class="snbd-input form-control" type="text" name="promocode" id="inputPromoCode" placeholder="{lang key='orderpromotioncode'}"
                           {if $promocode}value="{$promocode} - {$promodesc}" disabled="disabled"{/if}>
                    {if $promocode}
                        <button type="submit" name="removepromo" class="snbd-btn snbd-btn--danger snbd-btn--sm mt-2">{lang key='orderdontusepromo'}</button>
                    {else}
                        <button type="submit" class="snbd-btn snbd-btn--secondary snbd-btn--sm mt-2">{lang key='orderpromovalidatebutton'}</button>
                    {/if}
                </div>
            </form>
        </section>

        <form method="post" action="{$smarty.server.PHP_SELF}" class="snbd-form">
            <input type="hidden" name="step" value="3" />
            <input type="hidden" name="type" value="{$type}" />
            <input type="hidden" name="id" value="{$id}" />
            {if $type eq "package"}
                <input type="hidden" name="pid" value="{$upgrades.0.newproductid}" />
                <input type="hidden" name="billingcycle" value="{$upgrades.0.newproductbillingcycle}" />
            {/if}
            {foreach $configoptions as $cid => $value}
                <input type="hidden" name="configoption[{$cid}]" value="{$value}" />
            {/foreach}
            {if $promocode}<input type="hidden" name="promocode" value="{$promocode}">{/if}

            <section class="snbd-card mt-4" aria-labelledby="snbd-upgrade-payment">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-upgrade-payment"><i class="ti ti-credit-card" aria-hidden="true"></i>{lang key='orderpaymentmethod'}</h2>
                </div>
                <div class="snbd-card__body">
                    <label class="snbd-visually-hidden" for="inputPaymentMethod">{lang key='orderpaymentmethod'}</label>
                    <select name="paymentmethod" id="inputPaymentMethod" class="snbd-input form-select">
                        {if $allowgatewayselection}
                        <option value="none">{lang key='paymentmethoddefault'}</option>
                        {/if}
                        {foreach $gateways as $gateway}
                        <option value="{$gateway.sysname}"{if $gateway.sysname eq $selectedgateway} selected="selected"{/if}>{$gateway.name}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="snbd-card__foot">
                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block" id="btnOrderContinue">
                        {lang key='continue'} <i class="ti ti-arrow-right" aria-hidden="true"></i>
                    </button>
                </div>
            </section>
        </form>
    </div>
</div>
