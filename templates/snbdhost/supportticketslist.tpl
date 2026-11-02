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

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">Support tickets</h1>
        <p class="snbd-page-sub">Track your conversations with our support team, or start a new one.</p>
    </div>
    <div class="snbd-page-actions">
        <a href="submitticket.php" class="snbd-btn snbd-btn--primary"><i class="ti ti-plus" aria-hidden="true"></i>New ticket</a>
    </div>
</div>

<div class="snbd-stats snbd-stats--three">
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Open tickets</span>
            <span class="snbd-stat__value">{$openCount}</span>
            <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>In progress</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--info"><i class="ti ti-lifebuoy" aria-hidden="true"></i></span>
    </div>
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Awaiting your reply</span>
            <span class="snbd-stat__value">{$waitingCount}</span>
            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Needs attention</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--warn"><i class="ti ti-hourglass-low" aria-hidden="true"></i></span>
    </div>
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Answered</span>
            <span class="snbd-stat__value">{$answeredCount}</span>
            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Reply ready</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--ok"><i class="ti ti-messages" aria-hidden="true"></i></span>
    </div>
</div>

<div class="snbd-toolbar">
    <div class="snbd-seg" role="group" aria-label="Filter tickets by status">
        <button type="button" class="snbd-seg__item active" data-snbd-filter="all" aria-pressed="true">All</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="open" aria-pressed="false">Open</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="answered" aria-pressed="false">Answered</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="customer-reply" aria-pressed="false">Awaiting reply</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="closed" aria-pressed="false">Closed</button>
    </div>
</div>

<section class="snbd-card mb-5" aria-labelledby="ticket-list-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="ticket-list-title"><i class="ti ti-headset" aria-hidden="true"></i>Enquiry list</h2>
    </div>
    <div class="snbd-table-wrap" data-snbd-filter-target>
        <table class="snbd-table">
            <caption class="snbd-visually-hidden">Your support tickets</caption>
            <thead>
                <tr>
                    <th scope="col">Ticket</th>
                    <th scope="col">Subject</th>
                    <th scope="col">Department</th>
                    <th scope="col">Status</th>
                    <th scope="col">Last reply</th>
                    <th scope="col" class="snbd-table__actions">Action</th>
                </tr>
            </thead>
            <tbody>
                {foreach item=ticket from=$tickets}
                <tr class="snbd-filter-row">
                    <td data-label="Ticket" class="fw-semibold">#{$ticket.tid}</td>
                    <td data-label="Subject">
                        <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="d-inline-block snbd-truncate snbd-ticket-subject-link">{$ticket.subject}</a>
                    </td>
                    <td data-label="Department" class="snbd-muted">{$ticket.department}</td>
                    <td data-label="Status">
                        {if $ticket.status eq "Open"}
                            <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>Open</span>
                        {elseif $ticket.status eq "Answered"}
                            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Answered</span>
                        {elseif $ticket.status eq "Customer-Reply" || $ticket.status eq "Awaiting Reply"}
                            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Awaiting reply</span>
                        {elseif $ticket.status eq "Closed"}
                            <span class="snbd-chip snbd-chip--neutral">Closed</span>
                        {else}
                            <span class="snbd-chip snbd-chip--neutral">{$ticket.status}</span>
                        {/if}
                    </td>
                    <td data-label="Last reply" class="snbd-muted">{$ticket.lastreply}</td>
                    <td class="snbd-table__actions" data-label="Action">
                        <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View</a>
                    </td>
                </tr>
                {foreachelse}
                <tr>
                    <td colspan="6">
                        <div class="snbd-empty">
                            <span class="snbd-empty__icon"><i class="ti ti-lifebuoy" aria-hidden="true"></i></span>
                            <p class="snbd-empty__title">No tickets yet</p>
                            <p class="snbd-empty__text">When you contact support, the conversation will appear here.</p>
                            <a href="submitticket.php" class="snbd-btn snbd-btn--primary snbd-btn--sm">Open a ticket</a>
                        </div>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</section>

{if $prevpage || $nextpage}
<nav class="snbd-pagination" aria-label="Ticket pages">
    {if $prevpage}
        <a href="?page={$prevpage}" class="snbd-btn snbd-btn--sm snbd-btn--secondary"><i class="ti ti-arrow-left" aria-hidden="true"></i>Previous</a>
    {else}
        <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true"><i class="ti ti-arrow-left" aria-hidden="true"></i>Previous</span>
    {/if}
    {if $nextpage}
        <a href="?page={$nextpage}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">Next<i class="ti ti-arrow-right" aria-hidden="true"></i></a>
    {else}
        <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true">Next<i class="ti ti-arrow-right" aria-hidden="true"></i></span>
    {/if}
</nav>
{/if}
