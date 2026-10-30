<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">Quotes</h1>
        <p class="snbd-page-sub">Proposals we have sent you, with their validity and current stage.</p>
    </div>
</div>

<div class="snbd-card">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title"><i class="ti ti-file-invoice" aria-hidden="true"></i>Quotes</h2>
    </div>
    <div class="snbd-table-wrap">
        <table id="tableQuotesList" class="snbd-table d-none">
            <caption class="snbd-visually-hidden">Quotes</caption>
            <thead>
                <tr>
                    <th scope="col">{lang key='quotenumber'}</th>
                    <th scope="col">{lang key='quotesubject'}</th>
                    <th scope="col">{lang key='quotedatecreated'}</th>
                    <th scope="col">{lang key='quotevaliduntil'}</th>
                    <th scope="col">{lang key='quotestage'}</th>
                    <th scope="col" class="snbd-table__actions"><span class="snbd-visually-hidden">{lang key='quotedownload'}</span></th>
                </tr>
            </thead>
            <tbody>
                {foreach $quotes as $quote}
                <tr onclick="clickableSafeRedirect(event, 'viewquote.php?id={$quote.id}', true)">
                    <td data-label="{lang key='quotenumber'}" class="fw-semibold snbd-mono">#{$quote.id}</td>
                    <td data-label="{lang key='quotesubject'}">
                        <a href="viewquote.php?id={$quote.id}" class="d-inline-block snbd-truncate">{$quote.subject}</a>
                    </td>
                    <td data-label="{lang key='quotedatecreated'}" class="snbd-muted">
                        <span class="d-none">{$quote.normalisedDateCreated}</span>{$quote.datecreated}
                    </td>
                    <td data-label="{lang key='quotevaliduntil'}" class="snbd-muted">
                        <span class="d-none">{$quote.normalisedValidUntil}</span>{$quote.validuntil}
                    </td>
                    <td data-label="{lang key='quotestage'}">
                        {if $quote.stage eq "Accepted"}
                            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>{$quote.stage}</span>
                        {elseif $quote.stage eq "Delivered"}
                            <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>{$quote.stage}</span>
                        {elseif $quote.stage eq "On Hold"}
                            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>{$quote.stage}</span>
                        {elseif $quote.stage eq "Lost"}
                            <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>{$quote.stage}</span>
                        {elseif $quote.stage eq "Dead"}
                            <span class="snbd-chip snbd-chip--neutral">{$quote.stage}</span>
                        {else}
                            <span class="snbd-chip snbd-chip--neutral">{$quote.stage}</span>
                        {/if}
                    </td>
                    <td class="snbd-table__actions" data-label="{lang key='quotedownload'}">
                        <form method="post" action="dl.php">
                            <input type="hidden" name="type" value="q">
                            <input type="hidden" name="id" value="{$quote.id}">
                            <button type="submit" class="snbd-btn snbd-btn--sm snbd-btn--secondary">
                                <i class="ti ti-download" aria-hidden="true"></i>{lang key='quotedownload'}
                            </button>
                        </form>
                    </td>
                </tr>
                {foreachelse}
                <tr>
                    <td colspan="6">
                        <div class="snbd-empty">
                            <span class="snbd-empty__icon"><i class="ti ti-file-invoice" aria-hidden="true"></i></span>
                            <p class="snbd-empty__title">No quotes yet</p>
                            <p class="snbd-empty__text">When we send you a proposal, it will appear here with a download link.</p>
                        </div>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
    <div class="text-center py-4" id="tableLoading">
        <p class="snbd-caption mb-0"><i class="ti ti-loader-2" aria-hidden="true"></i>{lang key='loading'}</p>
    </div>
</div>

<script>
    jQuery(document).ready(function () {
        var table = jQuery('#tableQuotesList').removeClass('d-none').DataTable({
            columnDefs: [{literal}{orderable: false, targets: 5}{/literal}],
            order: []
        });

        {if $orderby == 'id'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'date'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'validuntil'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'stage'}
            table.order(4, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>
