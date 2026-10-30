{include file="$template/header.tpl"}

{if $invalidQuoteIdRequested}

    <div class="snbd-alert snbd-alert--bad" role="alert">
        <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
        <div class="snbd-alert__body">
            <p class="snbd-alert__title">{lang key='error'}</p>
            <p class="snbd-alert__text">{lang key='invoiceserror'}</p>
        </div>
    </div>

    <a href="clientarea.php?action=quotes" class="snbd-btn snbd-btn--secondary">
        <i class="ti ti-arrow-left" aria-hidden="true"></i>All quotes
    </a>

{else}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Quote</p>
        <h1 class="snbd-page-title">{lang key='quotenumber'}{$id}</h1>
        <p class="snbd-page-sub">{lang key='quotedatecreated'} {$datecreated} · {lang key='quotevaliduntil'} {$validuntil}</p>
    </div>
    <div class="snbd-page-actions">
        {if $stage eq "Accepted"}
            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>{lang key='quotestageaccepted'}</span>
        {elseif $stage eq "Delivered"}
            <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>{lang key='quotestagedelivered'}</span>
        {elseif $stage eq "On Hold"}
            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>{lang key='quotestageonhold'}</span>
        {elseif $stage eq "Lost"}
            <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>{lang key='quotestagelost'}</span>
        {elseif $stage eq "Dead"}
            <span class="snbd-chip snbd-chip--neutral">{lang key='quotestagedead'}</span>
        {/if}

        {if $stage eq "Delivered" || $stage eq "On Hold"}
            <button type="button" class="snbd-btn snbd-btn--primary snbd-btn--sm" data-snbd-modal-open="acceptQuoteModal">
                <i class="ti ti-circle-check" aria-hidden="true"></i>{lang key='quoteacceptbtn'}
            </button>
        {/if}
        <a href="javascript:window.print()" class="snbd-btn snbd-btn--secondary snbd-btn--sm snbd-no-print">
            <i class="ti ti-printer" aria-hidden="true"></i>{lang key='print'}
        </a>
        <a href="dl.php?type=q&amp;id={$quoteid}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-download" aria-hidden="true"></i>{lang key='invoicesdownload'}
        </a>
    </div>
</div>

{if $agreetosrequired}
<div class="snbd-alert snbd-alert--bad" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='ordererroraccepttos'}</p></div>
</div>
{/if}

{if $proposal}
<div class="snbd-alert snbd-alert--warn" role="status">
    <i class="ti ti-file-description snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__title">{lang key='quoteproposal'}</p>
        <div class="snbd-alert__text">{$proposal}</div>
    </div>
</div>
{/if}

<div class="row g-4 mb-4">
    <div class="col-xl-8">
        <article class="snbd-card snbd-invoice" aria-labelledby="quote-document-title">
            <div class="snbd-invoice__head">
                <div class="snbd-invoice__brand">
                    {if $logo}
                        <img src="{$logo}" alt="{$companyname}" class="snbd-invoice__logo">
                    {/if}
                    <span class="snbd-invoice__company">{$companyname}</span>
                </div>
                <div class="snbd-invoice__identity">
                    <h2 class="snbd-invoice__number" id="quote-document-title">{lang key='quotenumber'}{$id}</h2>
                    <dl class="snbd-invoice__dates">
                        <div><dt>{lang key='quotedatecreated'}</dt><dd>{$datecreated}</dd></div>
                        <div><dt>{lang key='quotevaliduntil'}</dt><dd>{$validuntil}</dd></div>
                    </dl>
                </div>
            </div>

            <div class="snbd-invoice__parties">
                <div>
                    <p class="snbd-eyebrow">{lang key='invoicespayto'}</p>
                    <address class="snbd-invoice__address">{$payto}</address>
                </div>
                <div>
                    <p class="snbd-eyebrow">{lang key='quoterecipient'}</p>
                    <p class="snbd-invoice__party-name">{$clientsdetails.firstname} {$clientsdetails.lastname}</p>
                    <address class="snbd-invoice__address">
                        {if $clientsdetails.companyname}{$clientsdetails.companyname}<br>{/if}
                        {$clientsdetails.address1}{if $clientsdetails.address2}, {$clientsdetails.address2}{/if}<br>
                        {$clientsdetails.city}{if $clientsdetails.state}, {$clientsdetails.state}{/if} {$clientsdetails.postcode}<br>
                        {$clientsdetails.country}
                        {if $customfields}
                            {foreach $customfields as $customfield}
                            <br>{$customfield.fieldname}: {$customfield.value}
                            {/foreach}
                        {/if}
                    </address>
                </div>
            </div>

            <div class="snbd-invoice__lines">
                <table class="snbd-table snbd-invoice__table">
                    <caption class="snbd-visually-hidden">{lang key='quotelineitems'}</caption>
                    <thead>
                        <tr>
                            <th scope="col">{lang key='invoicesdescription'}</th>
                            <th scope="col" class="snbd-table__num">{lang key='quotediscountheading'}</th>
                            <th scope="col" class="snbd-table__num">{lang key='invoicesamount'}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $quoteitems as $item}
                        <tr>
                            <td data-label="{lang key='invoicesdescription'}">{$item.description}{if $item.taxed} *{/if}</td>
                            <td data-label="{lang key='quotediscountheading'}" class="snbd-table__num">
                                {if $item.discountpc > 0}{$item.discount} ({$item.discountpc}%){else}&ndash;{/if}
                            </td>
                            <td data-label="{lang key='invoicesamount'}" class="snbd-table__num snbd-price">{$item.amount}</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>

            <div class="snbd-invoice__totals">
                <table class="snbd-table snbd-invoice__totals-table">
                    <caption class="snbd-visually-hidden">{lang key='quotelinetotal'}</caption>
                    <tbody>
                        <tr>
                            <th scope="row">{lang key='invoicessubtotal'}</th>
                            <td class="snbd-table__num snbd-price">{$subtotal}</td>
                        </tr>
                        {if $taxrate}
                        <tr>
                            <th scope="row">{$taxrate}% {$taxname}</th>
                            <td class="snbd-table__num snbd-price">{$tax}</td>
                        </tr>
                        {/if}
                        {if $taxrate2}
                        <tr>
                            <th scope="row">{$taxrate2}% {$taxname2}</th>
                            <td class="snbd-table__num snbd-price">{$tax2}</td>
                        </tr>
                        {/if}
                        <tr class="snbd-invoice__grand-total">
                            <th scope="row">{lang key='quotelinetotal'}</th>
                            <td class="snbd-table__num snbd-price">{$total}</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            {if $notes}
            <div class="snbd-invoice__notes">
                <p class="snbd-eyebrow">{lang key='invoicesnotes'}</p>
                <p class="mb-0">{$notes}</p>
            </div>
            {/if}

            {if $taxrate}
            <p class="snbd-hint mt-3">* {lang key='invoicestaxindicator'}</p>
            {/if}
        </article>
    </div>

    <div class="col-xl-4">
        <aside class="snbd-card snbd-card--rail snbd-no-print" aria-labelledby="quote-actions-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="quote-actions-title"><i class="ti ti-file-invoice" aria-hidden="true"></i>Quote</h2>
            </div>
            <div class="snbd-card__body">
                <dl class="snbd-kv">
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">{lang key='quotestage'}</dt>
                        <dd class="snbd-kv__v">{$stage}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">{lang key='quotevaliduntil'}</dt>
                        <dd class="snbd-kv__v">{$validuntil}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">{lang key='quotelinetotal'}</dt>
                        <dd class="snbd-kv__v snbd-price">{if $total}{$total}{else}{$subtotal}{/if}</dd>
                    </div>
                </dl>
            </div>
            <div class="snbd-card__foot">
                <a href="clientarea.php?action=quotes" class="d-inline-flex align-items-center gap-1">
                    <i class="ti ti-arrow-left" aria-hidden="true"></i>All quotes
                </a>
            </div>
        </aside>
    </div>
</div>

<form method="post" action="viewquote.php?id={$quoteid}&amp;action=accept">
    <div class="snbd-modal" id="acceptQuoteModal" aria-hidden="true" role="dialog" aria-modal="true" aria-labelledby="acceptQuoteTitle">
        <div class="snbd-modal__backdrop" aria-hidden="true"></div>
        <div class="snbd-modal__dialog">
            <div class="snbd-modal__head">
                <h2 class="snbd-modal__title" id="acceptQuoteTitle">{lang key='quoteacceptbtn'}</h2>
                <button type="button" class="snbd-modal__close" data-snbd-modal-close aria-label="Close">
                    <i class="ti ti-x" aria-hidden="true"></i>
                </button>
            </div>
            <div class="snbd-modal__body snbd-form">
                <p>{lang key='quoteacceptagreetos'}</p>
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" name="agreetos" id="quoteAcceptAgreeTos">
                    <label class="form-check-label" for="quoteAcceptAgreeTos">
                        {lang key='ordertosagreement'} <a href="{$tosurl}" target="_blank" rel="noopener">{lang key='ordertos'}</a>
                    </label>
                </div>
                <p class="snbd-hint mt-2">{lang key='quoteacceptcontractwarning'}</p>
            </div>
            <div class="snbd-modal__foot">
                <button type="button" class="snbd-btn snbd-btn--secondary" data-snbd-modal-close>{lang key='cancel'}</button>
                <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='quoteacceptbtn'}</button>
            </div>
        </div>
    </div>
</form>

{/if}

{include file="$template/footer.tpl"}
