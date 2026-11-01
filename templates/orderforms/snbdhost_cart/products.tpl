{include file="orderforms/snbdhost_cart/common.tpl"}

{*
   Catalogue page. The two columns are a CSS grid owned by the theme (see
   `.store` in css/custom.css) rather than Bootstrap columns: the cart is served
   the parent theme's Bootstrap 4 while the rest of the portal runs Bootstrap 5,
   and the framework columns disagreed about gutters between the two. The markup
   keeps the ids and classes WHMCS's cart JavaScript and the recommendation modal
   bind to.
*}

<div id="order-standard_cart">
    <div class="store">

        <aside class="store__aside">
            {foreach $secondarySidebar as $panel}
                {if $panel->getName() eq 'Categories' && $panel->hasChildren()}
                    <nav class="store-nav" aria-label="Product categories">
                        <div class="store-nav__title">
                            <i class="ti ti-layout-grid" aria-hidden="true"></i>
                            {if $panel->getLabel()}{$panel->getLabel()}{else}Categories{/if}
                        </div>
                        <ul class="store-nav__list">
                            {foreach $panel->getChildren() as $child}
                                {if $child->getUri()}
                                    <li>
                                        <a href="{$child->getUri()}"
                                           class="store-nav__item{if $child->isCurrent()} is-active{/if}"
                                           id="sidebar-{$child->getId()}"
                                           {if $child->isCurrent()}aria-current="page"{/if}>
                                            <i class="{if $child->hasIcon()}{$child->getIcon()}{else}ti ti-chevron-right{/if}" aria-hidden="true"></i>
                                            <span>{$child->getLabel()}</span>
                                            {if $child->hasBadge()}<span class="store-nav__count">{$child->getBadge()}</span>{/if}
                                        </a>
                                    </li>
                                {/if}
                            {/foreach}
                        </ul>
                    </nav>
                {/if}
            {/foreach}

            {foreach $secondarySidebar as $panel}
                {if $panel->getName() neq 'Categories' && $panel->hasChildren()}
                    <nav class="store-nav" aria-label="{$panel->getLabel()}">
                        <div class="store-nav__title">
                            <i class="{if $panel->hasIcon()}{$panel->getIcon()}{else}ti ti-settings{/if}" aria-hidden="true"></i>
                            {$panel->getLabel()}
                        </div>
                        <ul class="store-nav__list">
                            {foreach $panel->getChildren() as $child}
                                {if $child->getUri()}
                                    <li>
                                        <a href="{$child->getUri()}"
                                           class="store-nav__item{if $child->isCurrent()} is-active{/if}"
                                           id="sidebar-{$child->getId()}"
                                           {if $child->isCurrent()}aria-current="page"{/if}>
                                            <i class="{if $child->hasIcon()}{$child->getIcon()}{else}ti ti-chevron-right{/if}" aria-hidden="true"></i>
                                            <span>{$child->getLabel()}</span>
                                        </a>
                                    </li>
                                {/if}
                            {/foreach}
                        </ul>
                    </nav>
                {/if}
            {/foreach}
        </aside>

        <div class="store__main">
            <header class="store-hero">
                <div>
                    <span class="store-hero__eyebrow">Product catalogue</span>
                    <h1 class="store-hero__title">
                        {if $productGroup.headline}{$productGroup.headline}{elseif $productGroup.name}{$productGroup.name}{else}{$LANG.orderForm.selectCategory}{/if}
                    </h1>
                    {if $productGroup.tagline}
                        <p class="store-hero__sub">{$productGroup.tagline}</p>
                    {/if}
                </div>
                {if $products}
                    <span class="store-hero__count">
                        <i class="ti ti-package" aria-hidden="true"></i>
                        {count($products)} {if count($products) == 1}plan{else}plans{/if} available
                    </span>
                {/if}
            </header>

            {if $errormessage}
                <div class="alert alert-danger" role="alert">{$errormessage}</div>
            {elseif !$productGroup}
                <div class="alert alert-info" role="status">
                    {lang key='orderForm.selectCategory'}
                </div>
            {/if}

            <div class="store-grid" id="products">
                {foreach $products as $key => $product}
                    {$idPrefix = ($product.bid) ? ("bundle"|cat:$product.bid) : ("product"|cat:$product.pid)}
                    <article class="plan" id="{$idPrefix}">
                        <div class="plan__head">
                            <h2 class="plan__name" id="{$idPrefix}-name">{$product.name}</h2>
                            {if $product.stockControlEnabled}
                                <span class="plan__stock">{$product.qty} {$LANG.orderavailable}</span>
                            {/if}
                        </div>

                        {if $product.featuresdesc}
                            <p class="plan__lede" id="{$idPrefix}-description">{$product.featuresdesc}</p>
                        {/if}

                        {if $product.features}
                            <ul class="plan__specs">
                                {foreach $product.features as $feature => $value}
                                    <li id="{$idPrefix}-feature{$value@iteration}">
                                        <i class="ti ti-circle-check" aria-hidden="true"></i>
                                        <span><strong>{$value}</strong> {$feature}</span>
                                    </li>
                                {/foreach}
                            </ul>
                        {/if}

                        <div class="plan__foot">
                            <div class="plan__price" id="{$idPrefix}-price">
                                {if $product.bid}
                                    <span class="plan__cycle">{$LANG.bundledeal}</span>
                                    {if $product.displayprice}
                                        <span class="plan__amount">{$product.displayprice}</span>
                                    {/if}
                                {else}
                                    {if $product.pricing.hasconfigoptions}
                                        <span class="plan__note">{$LANG.startingfrom}</span>
                                    {/if}
                                    <span class="plan__amount">{$product.pricing.minprice.price}</span>
                                    <span class="plan__cycle">
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
                                    </span>
                                    {if $product.pricing.minprice.setupFee}
                                        <span class="plan__note">+ {$product.pricing.minprice.setupFee->toPrefixed()} {$LANG.ordersetupfee}</span>
                                    {/if}
                                {/if}
                            </div>

                            <a href="{$product.productUrl}" class="plan__cta" id="{$idPrefix}-order-button"{if $product.hasRecommendations} data-has-recommendations="1"{/if}>
                                <span>{$LANG.ordernowbutton}</span>
                                <i class="ti ti-arrow-right" aria-hidden="true"></i>
                            </a>
                        </div>
                    </article>
                {/foreach}
            </div>
        </div>
    </div>
</div>

{include file="orderforms/snbdhost_cart/recommendations-modal.tpl"}
