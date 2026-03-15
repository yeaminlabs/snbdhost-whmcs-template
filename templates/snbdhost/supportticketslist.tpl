<!-- Support Tickets Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="h4 fw-bold mb-0">Support Tickets</h2>
    <a href="submitticket.php" class="btn btn-brand"><i class="fas fa-plus me-2"></i>New Ticket</a>
</div>

<!-- Tickets Table Card -->
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span><i class="fas fa-life-ring me-2"></i>All Tickets</span>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover table-sm align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th>Ticket #</th>
                        <th>Subject</th>
                        <th>Department</th>
                        <th>Status</th>
                        <th>Last Reply</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach item=ticket from=$tickets}
                    <tr>
                        <td class="fw-semibold">#{$ticket.tid}</td>
                        <td>
                            <a href="viewticket.php?tid={$ticket.tid}&c={$ticket.c}" class="text-decoration-none text-truncate d-inline-block" style="max-width: 280px;">
                                {$ticket.subject}
                            </a>
                        </td>
                        <td class="text-secondary">{$ticket.department}</td>
                        <td>
                            {if $ticket.status eq "Open"}
                                <span class="badge bg-danger">Open</span>
                            {elseif $ticket.status eq "Answered"}
                                <span class="badge bg-info">Answered</span>
                            {elseif $ticket.status eq "Customer-Reply"}
                                <span class="badge bg-warning">Awaiting Reply</span>
                            {elseif $ticket.status eq "Closed"}
                                <span class="badge bg-secondary">Closed</span>
                            {else}
                                <span class="badge bg-secondary">{$ticket.status}</span>
                            {/if}
                        </td>
                        <td class="text-secondary small">{$ticket.lastreply}</td>
                        <td class="text-end">
                            <a href="viewticket.php?tid={$ticket.tid}&c={$ticket.c}" class="btn btn-sm btn-outline-custom py-0 px-2" title="View Ticket">
                                <i class="fas fa-eye"></i>
                            </a>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="6">
                            <div class="empty-state">
                                <i class="fas fa-life-ring d-block"></i>
                                <p>No support tickets found. <a href="submitticket.php">Open a new ticket</a></p>
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
    <a href="?page={$prevpage}" class="btn btn-outline-custom {if !$prevpage}disabled{/if}"><i class="fas fa-arrow-left me-2"></i>Previous</a>
    <a href="?page={$nextpage}" class="btn btn-outline-custom {if !$nextpage}disabled{/if}">Next<i class="fas fa-arrow-right ms-2"></i></a>
</div>
{/if}
