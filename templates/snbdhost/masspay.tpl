<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='masspaytitle'}</h1>
        <p class="snbd-page-sub">{lang key='masspaydescription'}</p>
    </div>
</div>

<form method="post" action="clientarea.php?action=masspay">
    <input type="hidden" name="geninvoice" value="true">

    <div class="row g-4">
        <div class="col-xl-8">
            <section class="snbd-card" aria-labelledby="snbd-masspay-lines">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-masspay-lines"><i class="ti ti-receipt" aria-hidden="true"></i>{lang key='invoicesdescription'}</h2>
                </div>
                <div class="snbd-table-wrap">
                    <table class="snbd-table">
                        <caption class="snbd-visually-hidden">{lang key='masspaytitle'}</caption>
                        <thead>
                            <tr>
                                <th scope="col">{lang key='invoicesdescription'}</th>
                                <th scope="col" class="snbd-table__num">{lang key='invoicesamount'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $invoiceitems as $invid => $invoiceitem}
                            <tr class="snbd-table__group">
                                <th colspan="2" scope="colgroup">
                                    {lang key='invoicenumber'} {if $invoiceitem.0.invoicenum}{$invoiceitem.0.invoicenum}{else}{$invid}{/if}
                                    <input type="hidden" name="invoiceids[]" value="{$invid}">
                                </th>
                            </tr>
                                {foreach from=$invoiceitem item=item}
                                <tr>
                                    <td data-label="{lang key='invoicesdescription'}">{$item.description}</td>
                                    <td data-label="{lang key='invoicesamount'}" class="snbd-table__num snbd-price">{$item.amount}</td>
                                </tr>
                                {/foreach}
                            {foreachelse}
                            <tr>
                                <td colspan="2">
                                    <div class="snbd-empty">
                                        <span class="snbd-empty__icon"><i class="ti ti-receipt-off" aria-hidden="true"></i></span>
                                        <p class="snbd-empty__title">{lang key='norecordsfound'}</p>
                                        <p class="snbd-empty__text">Nothing is outstanding on this account.</p>
                                    </div>
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                        <tfoot>
                            <tr>
                                <th scope="row">{lang key='invoicessubtotal'}</th>
                                <td class="snbd-table__num snbd-price">{$subtotal}</td>
                            </tr>
                            {if $tax}
                            <tr>
                                <th scope="row">{$taxrate1}% {$taxname1}</th>
                                <td class="snbd-table__num snbd-price">{$tax}</td>
                            </tr>
                            {/if}
                            {if $tax2}
                            <tr>
                                <th scope="row">{$taxrate2}% {$taxname2}</th>
                                <td class="snbd-table__num snbd-price">{$tax2}</td>
                            </tr>
                            {/if}
                            {if $credit}
                            <tr>
                                <th scope="row">{lang key='invoicescredit'}</th>
                                <td class="snbd-table__num snbd-price">-{$credit}</td>
                            </tr>
                            {/if}
                            {if $partialpayments}
                            <tr>
                                <th scope="row">{lang key='invoicespartialpayments'}</th>
                                <td class="snbd-table__num snbd-price">-{$partialpayments}</td>
                            </tr>
                            {/if}
                            {if $invoiceadjustments}
                            <tr>
                                <th scope="row">{lang key='invoicesadjustments'}</th>
                                <td class="snbd-table__num snbd-price">{$invoiceadjustments}</td>
                            </tr>
                            {/if}
                            <tr class="snbd-table__total">
                                <th scope="row">{lang key='invoicestotaldue'}</th>
                                <td class="snbd-table__num snbd-price">{$total}</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="snbd-card snbd-card--rail" aria-labelledby="snbd-masspay-gateway">
                <div class="snbd-card__head">
                    <h2 class="snbd-card__title" id="snbd-masspay-gateway"><i class="ti ti-credit-card" aria-hidden="true"></i>{lang key='masspaymentselectgateway'}</h2>
                </div>
                <div class="snbd-card__body snbd-form">
                    <label class="snbd-label" for="paymentmethod">{lang key='orderpaymentmethod'}</label>
                    <select name="paymentmethod" id="paymentmethod" class="form-select">
                        {foreach $gateways as $gateway}
                        <option value="{$gateway.sysname}">{$gateway.name}</option>
                        {/foreach}
                    </select>
                    <p class="snbd-hint">One payment covers every invoice listed here.</p>
                </div>
                <div class="snbd-card__foot">
                    <button type="submit" class="snbd-btn snbd-btn--primary snbd-btn--block" id="btnMassPayMakePayment">
                        <i class="ti ti-lock" aria-hidden="true"></i>{lang key='masspaymakepayment'}
                    </button>
                </div>
            </section>
        </div>
    </div>
</form>
