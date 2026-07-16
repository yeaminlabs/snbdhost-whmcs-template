<!-- Dynamic Ticket Summary Stats -->
{assign var="openCount" value=0}
{assign var="answeredCount" value=0}
{assign var="waitingCount" value=0}

{foreach item=ticket from=$tickets}
    {if $ticket.status eq "Open"}
        {assign var="openCount" value=$openCount+1}
    {elseif $ticket.status eq "Answered"}
        {assign var="answeredCount" value=$answeredCount+1}
    {elseif $ticket.status eq "Customer-Reply" || $ticket.status eq "Awaiting Reply"}
        {assign var="waitingCount" value=$waitingCount+1}
    {/if}
{/foreach}

<!-- Support Tickets Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline" style="font-size: 2.25rem; margin-bottom: 0.25rem;">Support <span class="dash-headline-accent">Tickets.</span></h1>
        <p class="text-secondary small mb-0">View your ticket history or open a new enquiry with our support team.</p>
    </div>
    <a href="submitticket.php" class="btn btn-brand-clean"><i class="ti ti-plus me-2"></i>New Ticket</a>
</div>

<!-- Support Stats Grid -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card border-0" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
            <div class="card-body d-flex align-items-center justify-content-between p-4">
                <div>
                    <div class="text-secondary small font-monospace text-uppercase" style="letter-spacing: 0.5px; font-weight: 700; font-size: 0.72rem;">Open Tickets</div>
                    <h3 class="fw-bold mt-1 mb-0" style="font-size: 1.85rem; color: #111111;">{$openCount}</h3>
                </div>
                <div class="stat-card-icon d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; border-radius: 12px; background: rgba(220, 53, 69, 0.08); color: #dc3545; font-size: 1.25rem;">
                    <i class="ti ti-circle-dot"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card border-0" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
            <div class="card-body d-flex align-items-center justify-content-between p-4">
                <div>
                    <div class="text-secondary small font-monospace text-uppercase" style="letter-spacing: 0.5px; font-weight: 700; font-size: 0.72rem;">Awaiting Reply</div>
                    <h3 class="fw-bold mt-1 mb-0" style="font-size: 1.85rem; color: #111111;">{$waitingCount}</h3>
                </div>
                <div class="stat-card-icon d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; border-radius: 12px; background: rgba(230, 81, 0, 0.08); color: #e65100; font-size: 1.25rem;">
                    <i class="ti ti-hourglass-low"></i>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-4">
        <div class="card border-0" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
            <div class="card-body d-flex align-items-center justify-content-between p-4">
                <div>
                    <div class="text-secondary small font-monospace text-uppercase" style="letter-spacing: 0.5px; font-weight: 700; font-size: 0.72rem;">Answered</div>
                    <h3 class="fw-bold mt-1 mb-0" style="font-size: 1.85rem; color: #111111;">{$answeredCount}</h3>
                </div>
                <div class="stat-card-icon d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; border-radius: 12px; background: rgba(46, 125, 50, 0.08); color: #2e7d32; font-size: 1.25rem;">
                    <i class="ti ti-messages"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Tickets Table Card -->
<div class="card border-0 mb-5" style="border-radius: 16px; box-shadow: 0 4px 25px rgba(0,0,0,0.02); overflow: hidden; border: 1px solid #eeeeee !important;">
    <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center" style="border-bottom: 1px solid #eeeeee;">
        <span class="fw-bold text-dark d-flex align-items-center gap-2" style="font-family: 'Plus Jakarta Sans', sans-serif;"><i class="ti ti-headset" style="font-size: 1.2rem; color: var(--brand-primary);"></i> Support Enquiry List</span>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" style="border-collapse: collapse; border: none;">
                <thead>
                    <tr style="background: #fafafa; border-bottom: 1px solid #eeeeee;">
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Ticket #</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Subject</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Department</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Status</th>
                        <th class="py-3 px-4" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Last Reply</th>
                        <th class="py-3 px-4 text-end" style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #777777; border-bottom: none;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach item=ticket from=$tickets}
                    <tr onclick="window.location='viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}'" style="cursor: pointer; transition: all 0.15s ease;">
                        <td class="py-3 px-4">
                            <span class="fw-bold text-danger">#{$ticket.tid}</span>
                        </td>
                        <td class="py-3 px-4">
                            <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="fw-bold text-dark text-decoration-none text-truncate d-inline-block" style="max-width: 280px;" onclick="event.stopPropagation();">
                                {$ticket.subject}
                            </a>
                        </td>
                        <td class="py-3 px-4 text-secondary small">{$ticket.department}</td>
                        <td class="py-3 px-4">
                            {if $ticket.status eq "Open"}
                                <span class="badge-clean badge-clean-danger">Open</span>
                            {elseif $ticket.status eq "Answered"}
                                <span class="badge-clean badge-clean-success">Answered</span>
                            {elseif $ticket.status eq "Customer-Reply" || $ticket.status eq "Awaiting Reply"}
                                <span class="badge-clean badge-clean-warning">Awaiting Reply</span>
                            {elseif $ticket.status eq "Closed"}
                                <span class="badge-clean badge-clean-secondary">Closed</span>
                            {else}
                                <span class="badge-clean badge-clean-secondary">{$ticket.status}</span>
                            {/if}
                        </td>
                        <td class="py-3 px-4 text-secondary small">{$ticket.lastreply}</td>
                        <td class="py-3 px-4 text-end" onclick="event.stopPropagation();">
                            <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="topbar-icon-btn d-inline-flex align-items-center justify-content-center" style="width: 44px; height: 44px;" title="View Ticket" aria-label="View Ticket #{$ticket.tid}">
                                <i class="ti ti-eye" style="font-size: 1.05rem;"></i>
                            </a>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="6" class="py-5">
                            <div class="text-center text-muted">
                                <i class="ti ti-lifebuoy d-block mb-3" style="font-size: 2.5rem; opacity: 0.3;"></i>
                                <p class="mb-0">No support tickets found. <a href="submitticket.php" class="text-danger fw-bold text-decoration-none">Open a new ticket</a></p>
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
    <a href="?page={$prevpage}" class="btn btn-outline-custom px-4 py-2 {if !$prevpage}disabled{/if}"><i class="ti ti-arrow-left me-2"></i>Previous</a>
    <a href="?page={$nextpage}" class="btn btn-outline-custom px-4 py-2 {if !$nextpage}disabled{/if}">Next<i class="ti ti-arrow-right ms-2"></i></a>
</div>
{/if}
