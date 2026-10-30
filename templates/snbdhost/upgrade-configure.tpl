<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{lang key='upgradeService.serviceBeingUpgraded'}</p>
        <h1 class="snbd-page-title">{lang key='upgradeService.chooseNew'}</h1>
    </div>
    <div class="snbd-page-actions">
        <a href="{$WEB_ROOT}/clientarea.php?action=productdetails&id={if $serviceToBeUpgraded->isService()}{$serviceToBeUpgraded->id}{elseif $serviceToBeUpgraded->isAddon()}{$serviceToBeUpgraded->service->id}{/if}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key="manage"}
        </a>
    </div>
</div>

{if !$serviceToBeUpgraded && $errorMessage}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$errorMessage}</p></div>
</div>
{else}

<section class="snbd-card snbd-card--muted mb-4">
    <div class="snbd-card__body">
        <dl class="snbd-kv">
            <div class="snbd-kv__row">
                <dt class="snbd-kv__k">{lang key="upgradeService.serviceBeingUpgraded"}</dt>
                <dd class="snbd-kv__v">
                    <span class="fw-semibold">
                        {if $serviceToBeUpgraded->isService()}
                            {$serviceToBeUpgraded->product->productGroup->name} - {$serviceToBeUpgraded->product->name}
                        {else}
                            {$serviceToBeUpgraded->productAddon->name}
                        {/if}
                    </span>
                    <span class="snbd-muted d-block">
                        {if $serviceToBeUpgraded->domain}
                            {$serviceToBeUpgraded->domain}
                        {elseif $serviceToBeUpgraded->isAddon() && $serviceToBeUpgraded->service->domain}
                            {$serviceToBeUpgraded->service->domain}
                        {else}
                            {lang key="noDomain"}
                        {/if}
                    </span>
                </dd>
            </div>
        </dl>
    </div>
</section>

{if $errorMessage}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$errorMessage}</p></div>
</div>
{/if}

<div class="row g-4">
    {foreach $upgradeProducts as $key => $product}
    <div class="col-md-6 col-xl-4">
        <section class="snbd-card h-100" aria-labelledby="snbd-upgrade-product-{$product->productKey}">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-upgrade-product-{$product->productKey}">{$product->name}</h2>
                {if $product->id == $serviceToBeUpgraded->productId}
                <span class="snbd-chip snbd-chip--neutral">{lang key="upgradeService.currentProduct"}</span>
                {elseif $product->productKey == $recommendedProductKey}
                <span class="snbd-chip snbd-chip--brand">{lang key="upgradeService.recommended"}</span>
                {/if}
            </div>

            <div class="snbd-card__body">
                {if $product->description}<p class="snbd-caption">{$product->description}</p>{/if}
                <ul class="snbd-list">
                    {foreach $product->features as $label => $value}
                    <li>
                        <span class="snbd-list__item d-flex align-items-center justify-content-between gap-2">
                            <span>{$label}</span>
                            {if is_bool($value)}
                            <i class="ti ti-{if $value}check{else}x{/if}" aria-hidden="true"></i>
                            {else}
                            <span class="fw-semibold">{$value}</span>
                            {/if}
                        </span>
                    </li>
                    {/foreach}
                </ul>
            </div>

            <form method="post" action="{routePath('upgrade-add-to-cart')}" class="snbd-form">
                <input type="hidden" name="isproduct" value="{$isService}">
                <input type="hidden" name="serviceid" value="{$serviceToBeUpgraded->id}">
                <input type="hidden" name="productid" value="{$product->id}">

                <div class="snbd-card__body">
                    {if $allowMultipleQuantities}
                    <label class="snbd-label" for="upgrade-qty-{$product->productKey}">{lang key='orderForm.qty'}</label>
                    <input type="number" name="qty" id="upgrade-qty-{$product->productKey}" min="{$minimumQuantity}" value="{$currentQuantity}" class="snbd-input form-control mb-2">
                    {/if}

                    <label class="snbd-label" for="upgrade-cycle-{$product->productKey}">{lang key='billingcycle'}</label>
                    <select name="billingcycle" id="upgrade-cycle-{$product->productKey}" class="snbd-input form-select">
                        {foreach $product->pricing()->allAvailableCycles() as $cycle}
                            {if $permittedBillingCycles->showCycleForProduct($cycle->cycle())}
                            <option value="{$cycle->cycle()}"{if $permittedBillingCycles->isCycleDisabledForProduct($product->id, $cycle->cycle())} disabled{/if}>
                                {if $cycle->isRecurring()}
                                    {if $cycle->isYearly()}{$cycle->cycleInYears()}{else}{$cycle->cycleInMonths()}{/if} -
                                {/if}
                                {$cycle->toFullString()}
                            </option>
                            {/if}
                        {/foreach}
                    </select>
                </div>

                <div class="snbd-card__foot">
                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block" id="btnUpgradeSelect-{$product->productKey}"{if !$product->eligibleForUpgrade} disabled="disabled"{/if}>
                        {lang key="upgradeService.select"}
                    </button>
                </div>
            </form>
        </section>
    </div>
    {/foreach}
</div>
{/if}
