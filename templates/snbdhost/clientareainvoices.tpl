<!-- Invoices Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="h4 fw-bold mb-0">My Invoices</h2>
</div>

<!-- Invoices Table Card -->
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span><i class="fas fa-file-invoice me-2"></i>All Invoices</span>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover table-sm align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Invoice #</th>
                        <th>Invoice Date</th>
                        <th>Due Date</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach key=num item=invoice from=$invoices}
                    <tr onclick="window.location='viewinvoice.php?id={$invoice.id}'" style="cursor: pointer;">
                        <td>
                            <a href="viewinvoice.php?id={$invoice.id}" class="fw-semibold text-decoration-none">
                                {$invoice.invoicenum}
                            </a>
                        </td>
                        <td class="text-secondary">{$invoice.datecreated}</td>
                        <td class="text-secondary">{$invoice.datedue}</td>
                        <td class="fw-semibold">{$invoice.total}</td>
                        <td>
                            {if $invoice.status eq "Paid"}
                                <span class="badge bg-success">Paid</span>
                            {elseif $invoice.status eq "Unpaid"}
                                <span class="badge bg-danger">Unpaid</span>
                            {elseif $invoice.status eq "Overdue"}
                                <span class="badge bg-danger">Overdue</span>
                            {elseif $invoice.status eq "Cancelled"}
                                <span class="badge bg-secondary">Cancelled</span>
                            {elseif $invoice.status eq "Refunded"}
                                <span class="badge bg-info">Refunded</span>
                            {elseif strtolower($invoice.status) eq "collections"}
                                <span class="badge text-bg-secondary text-white" style="background-color: #6c757d !important;">Collections</span>
                            {else}
                                <span class="badge bg-secondary">{$invoice.status}</span>
                            {/if}
                        </td>
                        <td class="text-end" onclick="event.stopPropagation();">
                            <a href="viewinvoice.php?id={$invoice.id}" class="btn btn-sm btn-outline-custom py-0 px-2" title="View Invoice">
                                <i class="fas fa-eye"></i>
                            </a>
                            {if $invoice.status eq "Unpaid"}
                            <a href="viewinvoice.php?id={$invoice.id}" class="btn btn-sm btn-brand py-0 px-2" title="Pay Now">
                                <i class="fas fa-credit-card"></i>
                            </a>
                            {/if}
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="6">
                            <div class="empty-state">
                                <i class="fas fa-file-invoice d-block"></i>
                                <p>No invoices found.</p>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>

{if $prevpage || $nextpage}
<div class="d-flex justify-content-between mt-3">
    <a href="?action=invoices&page={$prevpage}" class="btn btn-outline-custom {if !$prevpage}disabled{/if}"><i class="fas fa-arrow-left me-2"></i>Previous</a>
    <a href="?action=invoices&page={$nextpage}" class="btn btn-outline-custom {if !$nextpage}disabled{/if}">Next<i class="fas fa-arrow-right ms-2"></i></a>
</div>
{/if}
