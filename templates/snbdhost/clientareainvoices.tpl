{assign var="unpaidCount" value=0}
{assign var="paidCount" value=0}
{assign var="cancelledCount" value=0}

{foreach item=invoice from=$invoices}
    {if $invoice.status eq "Unpaid" || $invoice.status eq "Overdue"}
        {assign var="unpaidCount" value=$unpaidCount+1}
    {elseif $invoice.status eq "Paid"}
        {assign var="paidCount" value=$paidCount+1}
    {elseif $invoice.status eq "Cancelled"}
        {assign var="cancelledCount" value=$cancelledCount+1}
    {/if}
{/foreach}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">Invoices</h1>
        <p class="snbd-page-sub">Review billing history, download invoices and settle anything outstanding.</p>
    </div>
    {if $unpaidCount > 0}
    <div class="snbd-page-actions">
        <a href="clientarea.php?action=masspay&all=true" class="snbd-btn snbd-btn--primary"><i class="ti ti-credit-card" aria-hidden="true"></i>Pay all unpaid</a>
    </div>
    {/if}
</div>

<div class="snbd-stats snbd-stats--three">
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Unpaid invoices</span>
            <span class="snbd-stat__value">{$unpaidCount}</span>
            {if $unpaidCount > 0}
                <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Needs attention</span>
            {else}
                <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>All settled</span>
            {/if}
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--warn"><i class="ti ti-alert-circle" aria-hidden="true"></i></span>
    </div>
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Paid invoices</span>
            <span class="snbd-stat__value">{$paidCount}</span>
            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Cleared</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--ok"><i class="ti ti-circle-check" aria-hidden="true"></i></span>
    </div>
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Total records</span>
            <span class="snbd-stat__value">{$invoices|@count}</span>
            {if $cancelledCount > 0}
                <span class="snbd-chip snbd-chip--neutral">{$cancelledCount} cancelled</span>
            {else}
                <span class="snbd-chip snbd-chip--neutral">All statuses</span>
            {/if}
        </span>
        <span class="snbd-stat__icon"><i class="ti ti-file-text" aria-hidden="true"></i></span>
    </div>
</div>

<div class="snbd-toolbar">
    <div class="snbd-seg" role="group" aria-label="Filter invoices by status">
        <button type="button" class="snbd-seg__item active" data-snbd-filter="all" aria-pressed="true">All</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="unpaid" aria-pressed="false">Unpaid</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="paid" aria-pressed="false">Paid</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="cancelled" aria-pressed="false">Cancelled</button>
    </div>
</div>

<section class="snbd-card mb-5" aria-labelledby="invoice-records-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="invoice-records-title"><i class="ti ti-receipt" aria-hidden="true"></i>Invoice records</h2>
    </div>
    <div class="snbd-table-wrap" data-snbd-filter-target>
        <table class="snbd-table">
            <caption class="snbd-visually-hidden">All invoices on your account</caption>
            <thead>
                <tr>
                    <th scope="col">Invoice</th>
                    <th scope="col">Issued</th>
                    <th scope="col">Due</th>
                    <th scope="col" class="snbd-table__num">Total</th>
                    <th scope="col">Status</th>
                    <th scope="col" class="snbd-table__actions">Action</th>
                </tr>
            </thead>
            <tbody>
                {foreach key=num item=invoice from=$invoices}
                <tr class="snbd-filter-row">
                    <td data-label="Invoice">
                        <a href="viewinvoice.php?id={$invoice.id}" class="fw-semibold">#{$invoice.invoicenum|replace:"#":""}</a>
                    </td>
                    <td data-label="Issued" class="snbd-muted">{$invoice.datecreated}</td>
                    <td data-label="Due" class="snbd-muted">{$invoice.datedue}</td>
                    <td data-label="Total" class="snbd-table__num snbd-price fw-semibold">{$invoice.total}</td>
                    <td data-label="Status">
                        {if $invoice.status eq "Paid"}
                            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Paid</span>
                        {elseif $invoice.status eq "Unpaid"}
                            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Unpaid</span>
                        {elseif $invoice.status eq "Overdue"}
                            <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Overdue</span>
                        {elseif $invoice.status eq "Cancelled"}
                            <span class="snbd-chip snbd-chip--neutral">Cancelled</span>
                        {elseif $invoice.status eq "Refunded"}
                            <span class="snbd-chip snbd-chip--info">Refunded</span>
                        {else}
                            <span class="snbd-chip snbd-chip--neutral">{$invoice.status}</span>
                        {/if}
                    </td>
                    <td class="snbd-table__actions" data-label="Action">
                        {if $invoice.status eq "Unpaid" || $invoice.status eq "Overdue"}
                            <a href="viewinvoice.php?id={$invoice.id}" class="snbd-btn snbd-btn--sm snbd-btn--primary">Pay</a>
                        {else}
                            <a href="viewinvoice.php?id={$invoice.id}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View</a>
                        {/if}
                    </td>
                </tr>
                {foreachelse}
                <tr>
                    <td colspan="6">
                        <div class="snbd-empty">
                            <span class="snbd-empty__icon"><i class="ti ti-receipt" aria-hidden="true"></i></span>
                            <p class="snbd-empty__title">No invoices yet</p>
                            <p class="snbd-empty__text">Your invoices will appear here after your first order.</p>
                            <a href="cart.php" class="snbd-btn snbd-btn--primary snbd-btn--sm">Browse services</a>
                        </div>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</section>

{if $prevpage || $nextpage}
<nav class="snbd-pagination" aria-label="Invoice pages">
    {if $prevpage}
        <a href="?action=invoices&page={$prevpage}" class="snbd-btn snbd-btn--sm snbd-btn--secondary"><i class="ti ti-arrow-left" aria-hidden="true"></i>Previous</a>
    {else}
        <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true"><i class="ti ti-arrow-left" aria-hidden="true"></i>Previous</span>
    {/if}
    {if $nextpage}
        <a href="?action=invoices&page={$nextpage}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">Next<i class="ti ti-arrow-right" aria-hidden="true"></i></a>
    {else}
        <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true">Next<i class="ti ti-arrow-right" aria-hidden="true"></i></span>
    {/if}
</nav>
{/if}
