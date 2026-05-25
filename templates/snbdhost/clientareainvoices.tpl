<!-- Dynamic Invoice Summary Stats -->
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

<!-- Invoices Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline" style="font-size: 2.25rem; margin-bottom: 0.25rem;">My <span class="dash-headline-accent">Invoices.</span></h1>
        <p class="text-secondary small mb-0">View, manage, and pay your pending or historical hosting invoices.</p>
    </div>
</div>

<!-- Invoices Stats Grid -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card border-0" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
            <div class="card-body d-flex align-items-center justify-content-between p-4">
                <div>
                    <div class="text-secondary small font-monospace text-uppercase" style="letter-spacing: 0.5px; font-weight: 700; font-size: 0.72rem;">Unpaid Invoices</div>
                    <h3 class="fw-bold mt-1 mb-0" style="font-size: 1.85rem; color: #111111;">{$unpaidCount}</h3>
                </div>
                <div class="stat-card-icon d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; border-radius: 12px; background: rgba(220, 53, 69, 0.08); color: #dc3545; font-size: 1.25rem;">
                    <i class="ti ti-alert-circle"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card border-0" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
            <div class="card-body d-flex align-items-center justify-content-between p-4">
                <div>
                    <div class="text-secondary small font-monospace text-uppercase" style="letter-spacing: 0.5px; font-weight: 700; font-size: 0.72rem;">Paid Invoices</div>
                    <h3 class="fw-bold mt-1 mb-0" style="font-size: 1.85rem; color: #111111;">{$paidCount}</h3>
                </div>
                <div class="stat-card-icon d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; border-radius: 12px; background: rgba(46, 125, 50, 0.08); color: #2e7d32; font-size: 1.25rem;">
                    <i class="ti ti-circle-check"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card border-0" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
            <div class="card-body d-flex align-items-center justify-content-between p-4">
                <div>
                    <div class="text-secondary small font-monospace text-uppercase" style="letter-spacing: 0.5px; font-weight: 700; font-size: 0.72rem;">Total Records</div>
                    <h3 class="fw-bold mt-1 mb-0" style="font-size: 1.85rem; color: #111111;">{count($invoices)}</h3>
                </div>
                <div class="stat-card-icon d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; border-radius: 12px; background: rgba(186, 17, 20, 0.06); color: #BA1114; font-size: 1.25rem;">
                    <i class="ti ti-file-text"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Invoices Table Card -->
<div class="card border-0 mb-5" style="border-radius: 16px; box-shadow: 0 4px 25px rgba(0,0,0,0.02); overflow: hidden; border: 1px solid #eeeeee !important;">
    <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid #eeeeee;">
        <span class="fw-bold text-dark d-flex align-items-center gap-2" style="font-family: 'Plus Jakarta Sans', sans-serif;"><i class="ti ti-receipt" style="font-size: 1.2rem; color: var(--brand-primary);"></i> Invoice Records</span>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" style="border-collapse: collapse; border: none;">
                <thead>
                    <tr style="background: #fafafa; border-bottom: 1px solid #eeeeee;">
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Invoice #</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Invoice Date</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Due Date</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Total</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Status</th>
                        <th class="py-3 px-4 text-end" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach key=num item=invoice from=$invoices}
                    <tr onclick="window.location='viewinvoice.php?id={$invoice.id}'" style="cursor: pointer; transition: all 0.15s ease;">
                        <td class="py-3 px-4">
                            <span class="fw-bold text-danger">#{$invoice.invoicenum}</span>
                        </td>
                        <td class="py-3 px-4 text-secondary small">{$invoice.datecreated}</td>
                        <td class="py-3 px-4 text-secondary small">{$invoice.datedue}</td>
                        <td class="py-3 px-4 fw-bold text-dark">{$invoice.total}</td>
                        <td class="py-3 px-4">
                            {if $invoice.status eq "Paid"}
                                <span class="badge-clean badge-clean-success">Paid</span>
                            {elseif $invoice.status eq "Unpaid"}
                                <span class="badge-clean badge-clean-danger">Unpaid</span>
                            {elseif $invoice.status eq "Overdue"}
                                <span class="badge-clean badge-clean-danger" style="background: rgba(220, 53, 69, 0.12) !important; color: #dc3545 !important;">Overdue</span>
                            {elseif $invoice.status eq "Cancelled"}
                                <span class="badge-clean badge-clean-secondary">Cancelled</span>
                            {elseif $invoice.status eq "Refunded"}
                                <span class="badge-clean badge-clean-info">Refunded</span>
                            {elseif strtolower($invoice.status) eq "collections"}
                                <span class="badge-clean badge-clean-secondary" style="background: rgba(108, 117, 125, 0.12) !important; color: #6c757d !important;">Collections</span>
                            {else}
                                <span class="badge-clean badge-clean-secondary">{$invoice.status}</span>
                            {/if}
                        </td>
                        <td class="py-3 px-4 text-end" onclick="event.stopPropagation();">
                            <a href="viewinvoice.php?id={$invoice.id}" class="topbar-icon-btn me-1" style="width: 32px; height: 32px;" title="View Invoice">
                                <i class="ti ti-eye" style="font-size: 1.05rem;"></i>
                            </a>
                            {if $invoice.status eq "Unpaid"}
                            <a href="viewinvoice.php?id={$invoice.id}" class="btn btn-brand-clean py-1 px-3" style="font-size: 0.75rem !important; padding: 0.35rem 1rem !important; box-shadow: none !important;" title="Pay Now">
                                <i class="ti ti-credit-card me-1"></i> Pay
                            </a>
                            {/if}
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="6" class="py-5">
                            <div class="text-center text-muted">
                                <i class="ti ti-receipt d-block mb-3" style="font-size: 2.5rem; opacity: 0.3;"></i>
                                <p class="mb-0">No invoices found.</p>
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
<div class="d-flex justify-content-between mt-4 mb-5">
    <a href="?action=invoices&page={$prevpage}" class="btn btn-outline-custom px-4 py-2 {if !$prevpage}disabled{/if}"><i class="ti ti-arrow-left me-2"></i>Previous</a>
    <a href="?action=invoices&page={$nextpage}" class="btn btn-outline-custom px-4 py-2 {if !$nextpage}disabled{/if}">Next<i class="ti ti-arrow-right ms-2"></i></a>
</div>
{/if}
