<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='clientareaemails'}</h1>
        <p class="snbd-page-sub">Every notification we have emailed you, kept here for your records.</p>
    </div>
</div>

<div class="snbd-card">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title"><i class="ti ti-mail" aria-hidden="true"></i>{lang key='clientareaemails'}</h2>
    </div>
    <div class="snbd-table-wrap">
        <table id="tableEmailsList" class="snbd-table d-none">
            <caption class="snbd-visually-hidden">{lang key='clientareaemails'}</caption>
            <thead>
                <tr>
                    <th scope="col">{lang key='clientareaemailsdate'}</th>
                    <th scope="col">{lang key='clientareaemailssubject'}</th>
                    <th scope="col" class="snbd-table__actions"><span class="snbd-visually-hidden">{lang key='emailviewmessage'}</span></th>
                </tr>
            </thead>
            <tbody>
                {foreach $emails as $email}
                <tr onclick="popupWindow('viewemail.php?id={$email.id}', 'emailWin', '800', '600')">
                    <td data-label="{lang key='clientareaemailsdate'}" class="snbd-muted snbd-nowrap">
                        <span class="d-none">{$email.normalisedDate}</span>{$email.date}
                    </td>
                    <td data-label="{lang key='clientareaemailssubject'}">
                        {$email.subject}
                        {if $email.attachmentCount > 0}
                            <span class="snbd-chip snbd-chip--neutral"><i class="ti ti-paperclip" aria-hidden="true"></i>{$email.attachmentCount}</span>
                        {/if}
                    </td>
                    <td class="snbd-table__actions" data-label="{lang key='emailviewmessage'}">
                        <button type="button" class="snbd-btn snbd-btn--sm snbd-btn--secondary" onclick="popupWindow('viewemail.php?id={$email.id}', 'emailWin', '800', '600', 'scrollbars=1,')">
                            <i class="ti ti-eye" aria-hidden="true"></i>{lang key='emailviewmessage'}
                        </button>
                    </td>
                </tr>
                {foreachelse}
                <tr>
                    <td colspan="3">
                        <div class="snbd-empty">
                            <span class="snbd-empty__icon"><i class="ti ti-mail" aria-hidden="true"></i></span>
                            <p class="snbd-empty__title">No emails yet</p>
                            <p class="snbd-empty__text">Invoices, receipts and service notices will be listed here once we send them.</p>
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
        var table = jQuery('#tableEmailsList').removeClass('d-none').DataTable({
            columnDefs: [{literal}{orderable: false, targets: 2}{/literal}],
            order: []
        });

        {if $orderby == 'date'}
            table.order(0, '{$sort}');
        {elseif $orderby == 'subject'}
            table.order(1, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').hide();
    });
</script>
