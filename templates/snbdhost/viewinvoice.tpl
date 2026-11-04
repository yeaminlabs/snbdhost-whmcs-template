{include file="$template/header.tpl"}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Invoice</p>
        <h1 class="snbd-page-title">Invoice #{$invoiceid}</h1>
        <p class="snbd-page-sub">Issued {$date} · Due {$datedue}</p>
    </div>
    <div class="snbd-page-actions">
        {if $status eq "Unpaid"}
            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Unpaid</span>
        {elseif $status eq "Paid"}
            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Paid</span>
        {elseif $status eq "Cancelled"}
            <span class="snbd-chip snbd-chip--neutral">Cancelled</span>
        {else}
            <span class="snbd-chip snbd-chip--neutral">{$status}</span>
        {/if}
        <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>All invoices
        </a>
        <a href="javascript:window.print()" class="snbd-btn snbd-btn--secondary snbd-btn--sm snbd-no-print">
            <i class="ti ti-printer" aria-hidden="true"></i>Print
        </a>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-xl-8">
        <article class="snbd-card snbd-invoice" aria-labelledby="invoice-document-title">
            <div class="snbd-invoice__head">
                <div class="snbd-invoice__brand">
                    <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" class="snbd-invoice__logo">
                    <span class="snbd-invoice__company">{$companyname}</span>
                </div>
                <div class="snbd-invoice__identity">
                    <h2 class="snbd-invoice__number" id="invoice-document-title">Invoice #{$invoiceid}</h2>
                    <dl class="snbd-invoice__dates">
                        <div><dt>{$LANG.invoicesdatecreated}</dt><dd>{$date}</dd></div>
                        <div><dt>{$LANG.invoicesdatedue}</dt><dd>{$datedue}</dd></div>
                    </dl>
                </div>
            </div>

            <div class="snbd-invoice__parties">
                <div>
                    <p class="snbd-eyebrow">{$LANG.invoicespayto}</p>
                    <p class="snbd-invoice__party-name">{$companyname}</p>
                    <address class="snbd-invoice__address">{$payto}</address>
                </div>
                <div>
                    <p class="snbd-eyebrow">{$LANG.invoicesinvoicedto}</p>
                    <p class="snbd-invoice__party-name">{$clientsdetails.firstname} {$clientsdetails.lastname}</p>
                    <address class="snbd-invoice__address">
                        {if $clientsdetails.companyname}{$clientsdetails.companyname}<br>{/if}
                        {$clientsdetails.address1}<br>
                        {if $clientsdetails.address2}{$clientsdetails.address2}<br>{/if}
                        {$clientsdetails.city}{if $clientsdetails.state}, {$clientsdetails.state}{/if} {$clientsdetails.postcode}<br>
                        {$clientsdetails.country}
                    </address>
                </div>
            </div>

            <div class="snbd-invoice__lines">
                <table class="snbd-table snbd-invoice__table">
                    <caption class="snbd-visually-hidden">Invoice line items</caption>
                    <thead>
                        <tr>
                            <th scope="col">{$LANG.invoicesdescription}</th>
                            <th scope="col" class="snbd-table__num">{$LANG.invoicesamount}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$invoiceitems item=item}
                        <tr>
                            <td data-label="{$LANG.invoicesdescription}">{$item.description}</td>
                            <td data-label="{$LANG.invoicesamount}" class="snbd-table__num snbd-price">{$item.amount}</td>
                        </tr>
                        {foreachelse}
                        <tr>
                            <td colspan="2" class="snbd-faint text-center">No invoice items.</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>

            <div class="snbd-invoice__totals">
                <table class="snbd-table snbd-invoice__totals-table">
                    <caption class="snbd-visually-hidden">Invoice totals</caption>
                    <tbody>
                        <tr>
                            <th scope="row">{$LANG.invoicessubtotal}</th>
                            <td class="snbd-table__num snbd-price">{$subtotal}</td>
                        </tr>
                        {if $taxname}
                        <tr>
                            <th scope="row">{$taxname} {$taxrate}%</th>
                            <td class="snbd-table__num snbd-price">{$tax}</td>
                        </tr>
                        {/if}
                        {if $taxname2}
                        <tr>
                            <th scope="row">{$taxname2} {$taxrate2}%</th>
                            <td class="snbd-table__num snbd-price">{$tax2}</td>
                        </tr>
                        {/if}
                        {if $credit}
                        <tr>
                            <th scope="row">Credit applied</th>
                            <td class="snbd-table__num snbd-price">-{$credit}</td>
                        </tr>
                        {/if}
                        <tr class="snbd-invoice__grand-total">
                            <th scope="row">{$LANG.invoicestotal}</th>
                            <td class="snbd-table__num snbd-price">{$total}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </article>
    </div>

    <div class="col-xl-4">
        <aside class="snbd-card snbd-card--rail snbd-no-print" aria-labelledby="invoice-payment-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="invoice-payment-title"><i class="ti ti-credit-card" aria-hidden="true"></i>Payment</h2>
            </div>
            <div class="snbd-card__body">
                {if $status eq "Paid"}
                    <div class="snbd-invoice__paid">
                        <span class="snbd-empty__icon snbd-invoice__paid-icon"><i class="ti ti-circle-check" aria-hidden="true"></i></span>
                        <p class="fw-semibold mb-1">Paid in full</p>
                        <p class="snbd-caption mb-0">Thank you. A receipt can be printed for your records.</p>
                    </div>
                {elseif $status eq "Unpaid" || $status eq "Overdue" || $status eq "Payment Pending"}
                    <p class="snbd-caption mb-3">Amount due <span class="snbd-price fw-semibold text-dark">{$total}</span> by {$datedue}.</p>

                    {if $allowchangegateway && $gatewaydropdown}
                        <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" id="frmPaymentMethod" class="snbd-form mb-3">
                            <label class="snbd-label" for="snbd-gateway">Payment method</label>
                            {$gatewaydropdown|replace:'<select ':'<select id="snbd-gateway" class="form-select" aria-label="Payment method" '}
                            <noscript><button type="submit" class="snbd-btn snbd-btn--secondary snbd-btn--sm mt-2">Update method</button></noscript>
                        </form>
                    {elseif $paymentmethod}
                        <dl class="snbd-kv mb-3">
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Method</dt>
                                <dd class="snbd-kv__v">{$paymentmethod}</dd>
                            </div>
                        </dl>
                    {/if}

                    <div class="snbd-pay">
                        {$paymentbutton}
                    </div>
                {else}
                    <p class="snbd-caption mb-0">This invoice is {$status|lower} and cannot be paid online.</p>
                {/if}
            </div>
            <div class="snbd-card__foot">
                <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="d-inline-flex align-items-center gap-1">Back to billing</a>
            </div>
        </aside>
    </div>
</div>

{include file="$template/footer.tpl"}
