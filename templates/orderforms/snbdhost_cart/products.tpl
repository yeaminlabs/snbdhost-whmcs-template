{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
/* ---- Classic Sidebar & Pricing Grid Layout Styling ---- */
.service-card {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.service-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0,0,0,0.06);
}
.list-group-item-action.active {
    background-color: var(--brand-primary) !important;
    border-color: var(--brand-primary) !important;
    color: #ffffff !important;
}
.list-group-item-action.active .badge {
    background-color: #ffffff !important;
    color: var(--brand-primary) !important;
}

/* Dark mode styling overrides for products page */
html[data-theme="dark"] .service-card,
html[data-theme="dark"] .list-group-item {
    background-color: var(--bg-surface) !important;
    border-color: var(--border-color) !important;
    color: var(--text-primary) !important;
}
html[data-theme="dark"] .list-group-item-action:hover {
    background-color: var(--bg-elevated) !important;
    color: var(--text-primary) !important;
}
html[data-theme="dark"] .service-card .text-dark,
html[data-theme="dark"] .service-card h3 {
    color: var(--text-primary) !important;
}
html[data-theme="dark"] .service-card .text-secondary {
    color: var(--text-secondary) !important;
}
html[data-theme="dark"] .list-group-item-action.active {
    background-color: var(--brand-primary) !important;
    border-color: var(--brand-primary) !important;
    color: #ffffff !important;
}
</style>

<div id="order-standard_cart">
    <div class="row">
        
        <!-- Left Column: Sidebar Categories -->
        <div class="col-lg-3 col-md-4">
            <div class="card border-0 mb-4" style="border-radius: 12px; overflow: hidden; border: 1px solid var(--border-color, #e0e0e0) !important;">
                <div class="card-header bg-white py-3" style="border-bottom: 1px solid var(--border-subtle, #eeeeee);">
                    <h5 class="mb-0 fw-bold text-dark d-flex align-items-center gap-2" style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 0.95rem;">
                        <i class="ti ti-category" style="color: var(--brand-primary);"></i> Categories
                    </h5>
                </div>
                <div class="list-group list-group-flush">
                    {foreach $secondarySidebar as $panel}
                        {if $panel->getName() eq 'Categories' && $panel->hasChildren()}
                            {foreach $panel->getChildren() as $child}
                                {if $child->getUri()}
                                    <a href="{$child->getUri()}" class="list-group-item list-group-item-action py-3 px-3 d-flex align-items-center justify-content-between {if $child->isCurrent()}active{/if}" id="sidebar-{$child->getId()}" style="font-size: 0.85rem; font-weight: 600; border-bottom: 1px solid var(--border-subtle, #eeeeee);">
                                        <span>
                                            {if $child->hasIcon()}<i class="{$child->getIcon()} me-2"></i>{else}<i class="ti ti-chevron-right me-2"></i>{/if}
                                            {$child->getLabel()}
                                        </span>
                                        {if $child->hasBadge()}<span class="badge bg-danger rounded-pill">{$child->getBadge()}</span>{/if}
                                    </a>
                                {/if}
                            {/foreach}
                        {/if}
                    {/foreach}
                </div>
            </div>
            
            {foreach $secondarySidebar as $panel}
                {if $panel->getName() neq 'Categories' && $panel->hasChildren()}
                    <div class="card border-0 mb-4" style="border-radius: 12px; overflow: hidden; border: 1px solid var(--border-color, #e0e0e0) !important;">
                        <div class="card-header bg-white py-3" style="border-bottom: 1px solid var(--border-subtle, #eeeeee);">
                            <h5 class="mb-0 fw-bold text-dark d-flex align-items-center gap-2" style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 0.95rem;">
                                {if $panel->hasIcon()}<i class="{$panel->getIcon()}"></i>{else}<i class="ti ti-settings"></i>{/if}
                                {$panel->getLabel()}
                            </h5>
                        </div>
                        <div class="list-group list-group-flush">
                            {foreach $panel->getChildren() as $child}
                                {if $child->getUri()}
                                    <a href="{$child->getUri()}" class="list-group-item list-group-item-action py-3 px-3 d-flex align-items-center justify-content-between {if $child->isCurrent()}active{/if}" id="sidebar-{$child->getId()}" style="font-size: 0.85rem; font-weight: 600; border-bottom: 1px solid var(--border-subtle, #eeeeee);">
                                        <span>
                                            {if $child->hasIcon()}<i class="{$child->getIcon()} me-2"></i>{else}<i class="ti ti-chevron-right me-2"></i>{/if}
                                            {$child->getLabel()}
                                        </span>
                                    </a>
                                {/if}
                            {/foreach}
                        </div>
                    </div>
                {/if}
            {/foreach}
        </div>

        <!-- Right Column: Pricing Grid -->
        <div class="col-lg-9 col-md-8">
            <div class="header-lined mb-4 border-0 pb-0">
                <h1 class="dash-headline" style="font-size: 1.8rem; font-family: 'Plus Jakarta Sans', sans-serif; font-weight: 800;">
                    {if $productGroup.headline}
                        {$productGroup.headline}
                    {else}
                        {$productGroup.name}
                    {/if}
                </h1>
                {if $productGroup.tagline}
                    <p class="text-muted mb-0 font-size-14">{$productGroup.tagline}</p>
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

            <div class="products" id="products">
                <div class="row g-3">
                    {foreach $products as $key => $product}
                        {$idPrefix = ($product.bid) ? ("bundle"|cat:$product.bid) : ("product"|cat:$product.pid)}
                    <div class="col-xl-4 col-lg-6 col-md-12 d-flex">
                        <div class="card service-card h-100 w-100" id="{$idPrefix}" style="border: 1px solid var(--border-color, #e0e0e0); border-radius: 12px; overflow: hidden; display: flex; flex-direction: column; background-color: var(--bg-surface, #ffffff);">
                            <div class="card-body p-4 d-flex flex-column h-100">
                                <header class="mb-3 border-bottom pb-3" style="background: transparent;">
                                    <h3 class="fw-bold text-dark fs-5 mb-0" id="{$idPrefix}-name" style="font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: -0.02em;">{$product.name}</h3>
                                    {if $product.stockControlEnabled}
                                        <span class="badge bg-danger rounded-pill mt-2" style="font-size: 0.7rem;">
                                            {$product.qty} {$LANG.orderavailable}
                                        </span>
                                    {/if}
                                </header>
                                
                                <div class="product-desc flex-grow-1 mb-4">
                                    {if $product.featuresdesc}
                                        <p class="text-secondary small mb-3" id="{$idPrefix}-description" style="line-height: 1.5; font-size: 0.82rem;">
                                            {$product.featuresdesc}
                                        </p>
                                    {/if}
                                    <ul class="list-unstyled mb-0 d-flex flex-column gap-2">
                                        {foreach $product.features as $feature => $value}
                                            <li class="d-flex align-items-start text-secondary" id="{$idPrefix}-feature{$value@iteration}" style="font-size:0.82rem; line-height: 1.4;">
                                                <i class="ti ti-circle-check text-success me-2" style="font-size:1.1rem; flex-shrink: 0; margin-top: 1px;"></i>
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
                                                    <div class="price fs-3 fw-bold text-danger lh-1 mt-1" style="color: var(--brand-primary) !important; font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: -0.03em;">{$product.displayprice}</div>
                                                {/if}
                                            {else}
                                                {if $product.pricing.hasconfigoptions}
                                                    <div class="text-secondary" style="font-size:0.75rem; font-weight: 500;">{$LANG.startingfrom}</div>
                                                {/if}
                                                <div class="price fs-3 fw-bold text-danger lh-1 my-1" style="color: var(--brand-primary) !important; font-family: 'Plus Jakarta Sans', sans-serif; font-size: 1.5rem !important; letter-spacing: -0.03em;">{$product.pricing.minprice.price}</div>
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
                                    <a href="{$product.productUrl}" class="btn btn-brand-clean w-100 justify-content-center py-2" id="{$idPrefix}-order-button"{if $product.hasRecommendations} data-has-recommendations="1"{/if} style="border-radius: 8px;">
                                        <i class="ti ti-shopping-cart me-2" style="font-size: 1.1rem;"></i>
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
