{if $addfundsdisabled}
<div class="snbd-alert snbd-alert--info" role="status">
    <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='clientareaaddfundsdisabled'}</p></div>
</div>
{elseif $notallowed}
<div class="snbd-alert snbd-alert--bad" role="alert">
    <i class="ti ti-lock snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='clientareaaddfundsnotallowed'}</p></div>
</div>
{elseif $errormessage}
<div class="snbd-alert snbd-alert--bad" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">{$errormessage}</div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='addfunds'}</h1>
        <p class="snbd-page-sub">Top up your account balance and use it to settle future invoices automatically.</p>
    </div>
</div>

{if !$addfundsdisabled}
<div class="row g-4">
    <div class="col-lg-5">
        <section class="snbd-card" aria-labelledby="snbd-addfunds-limits">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-addfunds-limits"><i class="ti ti-scale" aria-hidden="true"></i>Limits</h2>
            </div>
            <div class="snbd-card__body">
                <dl class="snbd-kv">
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">{lang key='addfundsminimum'}</dt>
                        <dd class="snbd-kv__v snbd-price">{$minimumamount}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">{lang key='addfundsmaximum'}</dt>
                        <dd class="snbd-kv__v snbd-price">{$maximumamount}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">{lang key='addfundsmaximumbalance'}</dt>
                        <dd class="snbd-kv__v snbd-price">{$maximumbalance}</dd>
                    </div>
                </dl>
            </div>
        </section>
    </div>

    <div class="col-lg-7">
        <section class="snbd-card" aria-labelledby="snbd-addfunds-form">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-addfunds-form"><i class="ti ti-wallet" aria-hidden="true"></i>{lang key='addfunds'}</h2>
            </div>
            <form method="post" action="{$smarty.server.PHP_SELF}?action=addfunds" class="snbd-form">
    <input type="hidden" name="token" value="{$token}">
                <div class="snbd-card__body">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="snbd-label" for="amount">{lang key='addfundsamount'}</label>
                            <input type="text" name="amount" id="amount" value="{$amount}" class="form-control" inputmode="decimal" required>
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="paymentmethod">{lang key='orderpaymentmethod'}</label>
                            <select name="paymentmethod" id="paymentmethod" class="form-select">
                                {foreach $gateways as $gateway}
                                <option value="{$gateway.sysname}">{$gateway.name}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="snbd-card__foot">
                    <button type="submit" class="snbd-btn snbd-btn--primary"><i class="ti ti-plus" aria-hidden="true"></i>{lang key='addfunds'}</button>
                    <p class="snbd-hint mb-0">{lang key='addfundsnonrefundable'}</p>
                </div>
            </form>
        </section>
    </div>
</div>
{/if}
