{if $producttotals}
    <div class="summary-header" style="border-bottom: 2px solid #f1f5f9; padding-bottom: 1rem; margin-bottom: 1rem;">
        <span class="product-name" style="display: block; font-size: 1.25rem; font-weight: 800; color: #0f172a; margin-bottom: 0.25rem;">{if $producttotals.allowqty && $producttotals.qty > 1}{$producttotals.qty} x {/if}{$producttotals.productinfo.name}</span>
        <span class="product-group" style="display: block; font-size: 0.9rem; color: #64748b; font-weight: 500;">{$producttotals.productinfo.groupname}</span>
    </div>

    {assign var="cartIndex" value=$smarty.post.i|default:$smarty.get.i|default:0}
    {assign var="selectedDomain" value=""}
    {if isset($smarty.session.cart.products[$cartIndex].domain)}
        {assign var="selectedDomain" value=$smarty.session.cart.products[$cartIndex].domain}
    {/if}

    {if $selectedDomain}
    <div class="clearfix" style="margin: 0 0 1rem 0; padding: 0.75rem 1rem; background: #f8fafc; border-radius: 8px; border: 1px dashed #cbd5e1; display: flex; justify-content: space-between; align-items: center;">
        <span class="pull-left float-left" style="font-weight:600; font-size:0.85rem; color:#64748b; text-transform:uppercase; letter-spacing:0.5px;">Domain</span>
        <span class="pull-right float-right" style="font-weight:700; color:#0f172a; font-size:1rem;">{$selectedDomain}</span>
    </div>
    {/if}

    <div class="summary-line-items" style="display: flex; flex-direction: column; gap: 0.75rem;">
        <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #475569; font-weight: 500;">
            <span class="pull-left float-left">{$producttotals.productinfo.name}</span>
            <span class="pull-right float-right" style="font-weight: 700; color: #1e293b;">{$producttotals.pricing.baseprice}</span>
        </div>

        {foreach $producttotals.configoptions as $configoption}
            {if $configoption}
                <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #64748b; font-size: 0.95rem;">
                    <span class="pull-left float-left">&nbsp;&raquo; {$configoption.name}: {$configoption.optionname}</span>
                    <span class="pull-right float-right" style="font-weight: 600; color: #1e293b;">{$configoption.recurring}{if $configoption.setup} + {$configoption.setup} {$LANG.ordersetupfee}{/if}</span>
                </div>
            {/if}
        {/foreach}

        {foreach $producttotals.addons as $addon}
            <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #64748b; font-size: 0.95rem;">
                <span class="pull-left float-left">+ {$addon.name}</span>
                <span class="pull-right float-right" style="font-weight: 600; color: #1e293b;">{$addon.recurring}</span>
            </div>
        {/foreach}
    </div>

    {if $producttotals.pricing.setup || $producttotals.pricing.recurring || $producttotals.pricing.addons}
        <div class="summary-totals" style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid #e2e8f0; display: flex; flex-direction: column; gap: 0.5rem;">
            {if $producttotals.pricing.setup}
                <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #64748b;">
                    <span class="pull-left float-left">{$LANG.cartsetupfees}:</span>
                    <span class="pull-right float-right" style="font-weight: 600; color: #1e293b;">{$producttotals.pricing.setup}</span>
                </div>
            {/if}
            {foreach from=$producttotals.pricing.recurringexcltax key=cycle item=recurring}
                <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #64748b;">
                    <span class="pull-left float-left">{$cycle}:</span>
                    <span class="pull-right float-right" style="font-weight: 600; color: #1e293b;">{$recurring}</span>
                </div>
            {/foreach}
            {if $producttotals.pricing.tax1}
                <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #64748b;">
                    <span class="pull-left float-left">{$carttotals.taxname} @ {$carttotals.taxrate}%:</span>
                    <span class="pull-right float-right" style="font-weight: 600; color: #1e293b;">{$producttotals.pricing.tax1}</span>
                </div>
            {/if}
            {if $producttotals.pricing.tax2}
                <div class="clearfix" style="display: flex; justify-content: space-between; align-items: center; color: #64748b;">
                    <span class="pull-left float-left">{$carttotals.taxname2} @ {$carttotals.taxrate2}%:</span>
                    <span class="pull-right float-right" style="font-weight: 600; color: #1e293b;">{$producttotals.pricing.tax2}</span>
                </div>
            {/if}
        </div>
    {/if}

    <div class="total-due-today" style="margin-top: 1.5rem; background: var(--snbd-red, #d32f2f); color: white; padding: 1.5rem; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(211, 47, 47, 0.2);">
        <span class="amt" style="display: block; font-size: 2rem; font-weight: 800; line-height: 1.1; margin-bottom: 0.25rem;">{$producttotals.pricing.totaltoday}</span>
        <span style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 600; opacity: 0.9;">{$LANG.ordertotalduetoday}</span>
    </div>
{elseif !empty($renewals) || !empty($serviceRenewals)}
    {* Renewals block preserved unchanged *}
    {if !empty($serviceRenewals)}
        {if !empty($carttotals.renewalsByType.services)}
            <span class="product-name">{lang key='renewService.titleAltPlural'}</span>
            {foreach $carttotals.renewalsByType.services as $serviceId => $serviceRenewal}
                <div class="clearfix" id="cartServiceRenewal{$serviceId}">
                    <div class="pull-left float-left">
                        <div>
                            {$serviceRenewal.name}
                        </div>
                        <div>
                            {$serviceRenewal.domainName}
                        </div>
                    </div>
                    <div class="pull-right float-right">
                        <div>
                            {$serviceRenewal.billingCycle}
                        </div>
                        <div>
                            {$serviceRenewal.recurringBeforeTax}
                            <a onclick="removeItem('r','{$serviceId}','service'); return false;" href="#" id="linkCartRemoveServiceRenewal{$serviceId}">
                                <i class="fas fa-fw ti ti-trash"></i>
                            </a>
                        </div>
                    </div>
                </div>
            {/foreach}
        {/if}
        {if !empty($carttotals.renewalsByType.addons)}
            <span class="product-name">{lang key='renewServiceAddon.titleAltPlural'}</span>
            {foreach $carttotals.renewalsByType.addons as $serviceAddonId => $serviceAddonRenewal}
                <div class="clearfix" id="cartServiceAddonRenewal{$serviceAddonId}">
                    <div class="pull-left float-left">
                        <div>
                            {$serviceAddonRenewal.name}
                        </div>
                        <div>
                            {$serviceAddonRenewal.domainName}
                        </div>
                    </div>
                    <div class="pull-right float-right">
                        <div>
                            {$serviceAddonRenewal.billingCycle}
                        </div>
                        <div>
                            {$serviceAddonRenewal.recurringBeforeTax}
                            <a onclick="removeItem('r','{$serviceAddonId}','addon'); return false;" href="#" id="linkCartRemoveServiceAddonRenewal{$serviceAddonId}">
                                <i class="fas fa-fw ti ti-trash"></i>
                            </a>
                        </div>
                    </div>
                </div>
            {/foreach}
        {/if}
    {elseif !empty($renewals) && !empty($carttotals.renewalsByType.domains)}
        <span class="product-name">{lang key='domainrenewals'}</span>
        {foreach $carttotals.renewalsByType.domains as $domainId => $renewal}
            <div class="clearfix" id="cartDomainRenewal{$domainId}">
                <span class="pull-left float-left">
                    {$renewal.domain} - {$renewal.regperiod} {if $renewal.regperiod == 1}{lang key='orderForm.year'}{else}{lang key='orderForm.years'}{/if}
                </span>
                <span class="pull-right float-right">
                    {$renewal.priceBeforeTax}
                    <a onclick="removeItem('r','{$domainId}','domain'); return false;" href="#" id="linkCartRemoveDomainRenewal{$domainId}">
                        <i class="fas fa-fw ti ti-trash"></i>
                    </a>
                </span>
            </div>
            {if $renewal.dnsmanagement}
                <div class="clearfix">
                    <span class="pull-left float-left">+ {lang key='domaindnsmanagement'}</span>
                </div>
            {/if}
            {if $renewal.emailforwarding}
                <div class="clearfix">
                    <span class="pull-left float-left">+ {lang key='domainemailforwarding'}</span>
                </div>
            {/if}
            {if $renewal.idprotection}
                <div class="clearfix">
                    <span class="pull-left float-left">+ {lang key='domainidprotection'}</span>
                </div>
            {/if}
            {if $renewal.hasGracePeriodFee}
                <div class="clearfix">
                    <span class="pull-left float-left">+ {lang key='domainRenewal.graceFee'}</span>
                </div>
            {/if}
            {if $renewal.hasRedemptionGracePeriodFee}
                <div class="clearfix">
                    <span class="pull-left float-left">+ {lang key='domainRenewal.redemptionFee'}</span>
                </div>
            {/if}

        {/foreach}
    {/if}
    <div class="summary-totals">
        <div class="clearfix">
            <span class="pull-left float-left">{lang key='ordersubtotal'}:</span>
            <span class="pull-right float-right">{$carttotals.subtotal}</span>
        </div>
        {if ($carttotals.taxrate && $carttotals.taxtotal) || ($carttotals.taxrate2 && $carttotals.taxtotal2)}
            {if $carttotals.taxrate}
                <div class="clearfix">
                    <span class="pull-left float-left">{$carttotals.taxname} @ {$carttotals.taxrate}%:</span>
                    <span class="pull-right float-right">{$carttotals.taxtotal}</span>
                </div>
            {/if}
            {if $carttotals.taxrate2}
                <div class="clearfix">
                    <span class="pull-left float-left">{$carttotals.taxname2} @ {$carttotals.taxrate2}%:</span>
                    <span class="pull-right float-right">{$carttotals.taxtotal2}</span>
                </div>
            {/if}
        {/if}
    </div>
    <div class="total-due-today">
        <span class="amt">{$carttotals.total}</span>
        <span>{lang key='ordertotalduetoday'}</span>
    </div>
{/if}
