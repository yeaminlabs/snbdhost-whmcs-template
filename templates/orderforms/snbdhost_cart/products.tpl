{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* ---- Top Navigation Bar for Categories & Actions ---- */
.cart-top-nav {
    background: #fff;
    border: 1px solid rgba(0,0,0,.08);
    border-radius: 1rem;
    padding: 0.75rem 1.25rem;
    margin-bottom: 1.5rem;
    box-shadow: 0 2px 12px rgba(0,0,0,.04);
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 0.5rem;
}
.cart-top-nav .nav-section-label {
    font-size: 0.7rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.08em;
    color: #aaa;
    margin-right: 0.25rem;
    white-space: nowrap;
}
.cart-top-nav .nav-divider {
    width: 1px;
    height: 1.5rem;
    background: #e0e0e0;
    margin: 0 0.5rem;
}
.cart-top-nav .nav-pill {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.4rem 0.9rem;
    border-radius: 2rem;
    font-size: 0.82rem;
    font-weight: 600;
    color: #555;
    text-decoration: none;
    background: transparent;
    border: none;
    transition: all 0.2s ease;
    white-space: nowrap;
    cursor: pointer;
}
.cart-top-nav .nav-pill:hover {
    background: #f5f5f5;
    color: #d32f2f;
}
.cart-top-nav .nav-pill.active {
    background: #d32f2f;
    color: #fff;
}
.cart-top-nav .nav-pill i {
    font-size: 0.75rem;
}

/* ---- Product Cards ---- */
.hover-elevate {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.hover-elevate:hover {
    transform: translateY(-5px);
    box-shadow: 0 1rem 3rem rgba(0,0,0,.12) !important;
}
.product-card .list-unstyled li {
    font-size: 0.95rem;
}
.product-card .price {
    letter-spacing: -0.05rem;
}
.btn-order-now:hover {
    transform: scale(1.05);
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

            <div class="header-lined mb-4">
                <h1 class="fw-bold" style="font-size:1.75rem">
                    {if $productGroup.headline}
                        {$productGroup.headline}
                    {else}
                        {$productGroup.name}
                    {/if}
                </h1>
                {if $productGroup.tagline}
                    <p class="text-muted mb-0">{$productGroup.tagline}</p>
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
                <div class="row row-eq-height">
                    {foreach $products as $key => $product}
                        {$idPrefix = ($product.bid) ? ("bundle"|cat:$product.bid) : ("product"|cat:$product.pid)}
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card h-100 border-0 shadow-sm rounded-4 product-card hover-elevate" id="{$idPrefix}">
                            <div class="card-body p-4 d-flex flex-column">
                                <header class="mb-3 border-bottom pb-3">
                                    <h3 class="fw-bold text-dark fs-5 mb-0" id="{$idPrefix}-name">{$product.name}</h3>
                                    {if $product.stockControlEnabled}
                                        <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3 py-2 mt-2">
                                            {$product.qty} {$LANG.orderavailable}
                                        </span>
                                    {/if}
                                </header>
                                
                                <div class="product-desc flex-grow-1 mb-3">
                                    {if $product.featuresdesc}
                                        <p class="text-muted small mb-3" id="{$idPrefix}-description">
                                            {$product.featuresdesc}
                                        </p>
                                    {/if}
                                    <ul class="list-unstyled mb-0">
                                        {foreach $product.features as $feature => $value}
                                            <li class="py-1 text-secondary d-flex align-items-start" id="{$idPrefix}-feature{$value@iteration}" style="font-size:0.88rem">
                                                <i class="fas fa-check-circle text-success me-2 mt-1 opacity-75" style="font-size:0.7rem"></i>
                                                <span><strong class="text-dark feature-value fw-semibold">{$value}</strong> {$feature}</span>
                                            </li>
                                        {/foreach}
                                    </ul>
                                </div>
                                
                                <footer class="mt-auto pt-3 border-top">
                                    <div class="d-flex align-items-end justify-content-between flex-wrap gap-2 mb-3">
                                        <div class="product-pricing" id="{$idPrefix}-price">
                                            {if $product.bid}
                                                <div class="text-muted small text-uppercase fw-semibold">{$LANG.bundledeal}</div>
                                                {if $product.displayprice}
                                                    <div class="price fs-3 fw-bolder text-danger lh-1 mt-1">{$product.displayprice}</div>
                                                {/if}
                                            {else}
                                                {if $product.pricing.hasconfigoptions}
                                                    <div class="text-muted" style="font-size:0.7rem">{$LANG.startingfrom}</div>
                                                {/if}
                                                <div class="price fs-3 fw-bolder text-danger lh-1">{$product.pricing.minprice.price}</div>
                                                <div class="text-muted text-uppercase fw-semibold" style="font-size:0.7rem;letter-spacing:0.04em">
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
                                    <a href="{$product.productUrl}" class="btn btn-danger btn-order-now rounded-pill w-100 py-2 shadow-sm d-inline-flex align-items-center justify-content-center" id="{$idPrefix}-order-button"{if $product.hasRecommendations} data-has-recommendations="1"{/if}>
                                        <i class="fas fa-shopping-cart me-2"></i>
                                        <span class="fw-bold">{$LANG.ordernowbutton}</span>
                                    </a>
                                </footer>
                            </div>
                        </div>
                    </div>
                    {if $product@iteration % 3 == 0}
                </div>
                <div class="row row-eq-height">
                    {/if}
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
</div>

{include file="orderforms/snbdhost_cart/recommendations-modal.tpl"}
