{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* ---- Top Navigation Bar for Categories & Actions ---- */
.cart-top-nav {
    background: #ffffff;
    border: 1px solid #eeeeee;
    border-radius: 12px;
    padding: 0.75rem 1.25rem;
    margin-bottom: 2rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.01);
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.5rem;
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.cart-top-nav .nav-section-label {
    font-size: 0.72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: #999999;
    margin-right: 0.25rem;
    white-space: nowrap;
}
.cart-top-nav .nav-divider {
    width: 1px;
    height: 1.5rem;
    background: #eeeeee;
    margin: 0 0.5rem;
}
.cart-top-nav .nav-pill {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.5rem 1rem;
    border-radius: 50rem;
    font-size: 0.82rem;
    font-weight: 700;
    color: #555555;
    text-decoration: none;
    background: transparent;
    border: none;
    transition: all 0.2s ease;
    white-space: nowrap;
    cursor: pointer;
}
.cart-top-nav .nav-pill:hover {
    background: rgba(204, 0, 0, 0.04);
    color: #CC0000;
}
.cart-top-nav .nav-pill.active {
    background: #CC0000;
    color: #ffffff;
}
.cart-top-nav .nav-pill i {
    font-size: 0.85rem;
}

/* ---- Product Cards Overrides ---- */
.service-card {
    display: flex;
    flex-direction: column;
}
.service-card .feature-value {
    color: #111111;
}

/* Hide the old sidebar so it doesn't render alongside new layout */
#order-standard_cart .cart-sidebar.sidebar { display: none !important; }
#order-standard_cart .cart-body { width: 100% !important; flex: 0 0 100% !important; max-width: 100% !important; }
#order-standard_cart .sidebar-collapsed { display: none !important; }

@media (max-width: 767.98px) {
    .cart-top-nav {
        flex-direction: column;
        align-items: stretch;
    }
    .cart-top-nav .nav-divider {
        width: 100%;
        height: 1px;
        margin: 0.4rem 0;
    }
    .cart-top-nav .nav-pills-row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.35rem;
    }
}
</style>

<div id="order-standard_cart">

    {* ===== Horizontal Top Navigation: Categories + Actions ===== *}
    <div class="cart-top-nav">
        {foreach $secondarySidebar as $panel}
            <span class="nav-section-label">
                {if $panel->hasIcon()}<i class="{$panel->getIcon()}"></i>{/if}
                {$panel->getLabel()}
            </span>
            {if $panel->hasChildren()}
                <div class="nav-pills-row d-flex flex-wrap gap-1">
                    {foreach $panel->getChildren() as $child}
                        {if $child->getUri()}
                            <a href="{$child->getUri()}" class="nav-pill{if $child->isCurrent()} active{/if}" id="topnav-{$child->getId()}">
                                {if $child->hasIcon()}<i class="{$child->getIcon()}"></i>{/if}
                                {$child->getLabel()}
                                {if $child->hasBadge()}<span class="badge bg-danger rounded-pill ms-1" style="font-size:.65rem">{$child->getBadge()}</span>{/if}
                            </a>
                        {/if}
                    {/foreach}
                </div>
            {/if}
            {if !$panel@last}<div class="nav-divider"></div>{/if}
        {/foreach}

        {* Currency selector for guests *}
        {if !$loggedin && $currencies}
            <div class="nav-divider"></div>
            <form method="post" action="{$WEB_ROOT}/cart.php{if $action}?a={$action}{if $domain}&domain={$domain}{/if}{elseif $gid}?gid={$gid}{/if}" class="d-inline-flex align-items-center">
                <select name="currency" onchange="submit()" class="form-select form-select-sm rounded-pill border-0" style="background:#f5f5f5;font-size:.82rem;font-weight:600;padding:.4rem .9rem;">
                    <option value="">{$LANG.choosecurrency}</option>
                    {foreach from=$currencies item=listcurr}
                        <option value="{$listcurr.id}"{if $listcurr.id == $activeCurrency.id} selected{/if}>{$listcurr.code}</option>
                    {/foreach}
                </select>
            </form>
        {/if}
    </div>

    {* ===== Keep old sidebar markup hidden (CSS hides it) so WHMCS JS doesn't break ===== *}
    <div class="row">
        <div class="cart-sidebar sidebar">
            {include file="orderforms/snbdhost_cart/sidebar-categories.tpl"}
        </div>
        <div class="cart-body">

            <div class="header-lined mb-5 border-0 pb-0">
                <h1 class="dash-headline" style="font-size: 2rem;">
                    {if $productGroup.headline}
                        {$productGroup.headline}
                    {else}
                        {$productGroup.name}
                    {/if}
                </h1>
                {if $productGroup.tagline}
                    <p class="dash-subhead mb-0">{$productGroup.tagline}</p>
                {/if}
            </div>
            {if $errormessage}
                <div class="alert alert-danger">
                    {$errormessage}
                </div>
            {elseif !$productGroup}
                <div class="alert alert-info">
                    {lang key='orderForm.selectCategory'}
                </div>
            {/if}

            {include file="orderforms/snbdhost_cart/sidebar-categories-collapsed.tpl"}

            <div class="products" id="products">
                <div class="row g-4">
                    {foreach $products as $key => $product}
                        {$idPrefix = ($product.bid) ? ("bundle"|cat:$product.bid) : ("product"|cat:$product.pid)}
                    <div class="col-lg-4 col-md-6 d-flex">
                        <div class="card service-card h-100 w-100" id="{$idPrefix}">
                            <div class="card-body p-4 d-flex flex-column">
                                <header class="mb-3 border-bottom pb-3" style="background: transparent;">
                                    <h3 class="fw-bold text-dark fs-5 mb-0" id="{$idPrefix}-name" style="font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: -0.02em;">{$product.name}</h3>
                                    {if $product.stockControlEnabled}
                                        <span class="badge-clean badge-clean-danger mt-2">
                                            {$product.qty} {$LANG.orderavailable}
                                        </span>
                                    {/if}
                                </header>
                                
                                <div class="product-desc flex-grow-1 mb-4">
                                    {if $product.featuresdesc}
                                        <p class="text-secondary small mb-3" id="{$idPrefix}-description" style="line-height: 1.5;">
                                            {$product.featuresdesc}
                                        </p>
                                    {/if}
                                    <ul class="list-unstyled mb-0 d-flex flex-column gap-2">
                                        {foreach $product.features as $feature => $value}
                                            <li class="d-flex align-items-start text-secondary" id="{$idPrefix}-feature{$value@iteration}" style="font-size:0.85rem; line-height: 1.4;">
                                                <i class="ti ti-circle-check text-success me-2" style="font-size:1.15rem; flex-shrink: 0; margin-top: 1px;"></i>
                                                <span><strong class="text-dark fw-bold">{$value}</strong> {$feature}</span>
                                            </li>
                                        {/foreach}
                                    </ul>
                                </div>
                                
                                <footer class="mt-auto pt-3 border-top" style="background: transparent;">
                                    <div class="d-flex align-items-end justify-content-between flex-wrap gap-2 mb-3">
                                        <div class="product-pricing" id="{$idPrefix}-price">
                                            {if $product.bid}
                                                <div class="text-secondary small text-uppercase fw-bold" style="font-size: 0.65rem; letter-spacing: 0.05em;">{$LANG.bundledeal}</div>
                                                {if $product.displayprice}
                                                    <div class="price fs-3 fw-bold text-danger lh-1 mt-1" style="color: #CC0000 !important; font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: -0.03em;">{$product.displayprice}</div>
                                                {/if}
                                            {else}
                                                {if $product.pricing.hasconfigoptions}
                                                    <div class="text-secondary" style="font-size:0.75rem; font-weight: 500;">{$LANG.startingfrom}</div>
                                                {/if}
                                                <div class="price fs-3 fw-bold text-danger lh-1 my-1" style="color: #CC0000 !important; font-family: 'Plus Jakarta Sans', sans-serif; font-size: 1.65rem !important; letter-spacing: -0.03em;">{$product.pricing.minprice.price}</div>
                                                <div class="text-secondary text-uppercase fw-bold" style="font-size:0.65rem; letter-spacing:0.05em">
                                                    {if $product.pricing.minprice.cycle eq "monthly"}
                                                        {$LANG.orderpaymenttermmonthly}
                                                    {elseif $product.pricing.minprice.cycle eq "quarterly"}
                                                        {$LANG.orderpaymenttermquarterly}
                                                    {elseif $product.pricing.minprice.cycle eq "semiannually"}
                                                        {$LANG.orderpaymenttermsemiannually}
                                                    {elseif $product.pricing.minprice.cycle eq "annually"}
                                                        {$LANG.orderpaymenttermannually}
                                                    {elseif $product.pricing.minprice.cycle eq "biennially"}
                                                        {$LANG.orderpaymenttermbiennially}
                                                    {elseif $product.pricing.minprice.cycle eq "triennially"}
                                                        {$LANG.orderpaymenttermtriennially}
                                                    {/if}
                                                </div>
                                                {if $product.pricing.minprice.setupFee}
                                                    <div class="text-muted mt-1" style="font-size: 0.7rem;">+ {$product.pricing.minprice.setupFee->toPrefixed()} {$LANG.ordersetupfee}</div>
                                                {/if}
                                            {/if}
                                        </div>
                                    </div>
                                    <a href="{$product.productUrl}" class="btn btn-brand-clean w-100 justify-content-center py-2" id="{$idPrefix}-order-button"{if $product.hasRecommendations} data-has-recommendations="1"{/if}>
                                        <i class="ti ti-shopping-cart me-2" style="font-size: 1.15rem;"></i>
                                        <span>{$LANG.ordernowbutton}</span>
                                    </a>
                                </footer>
                            </div>
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
</div>

{include file="orderforms/snbdhost_cart/recommendations-modal.tpl"}
