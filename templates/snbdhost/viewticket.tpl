<!-- Ticket Header -->
<div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-2">
    <div>
        <h2 class="mb-1 fw-bold">Ticket #{$tid} - {$subject}</h2>
        <div class="d-flex align-items-center gap-2 mt-2 flex-wrap">
            <span class="ticket-dept-badge"><i class="fas fa-tag me-1"></i>{$department}</span>
            {if $status eq "Open"}
                <span class="ticket-status-badge status-open"><i class="fas fa-circle me-1" style="font-size:7px; vertical-align:middle;"></i>Open</span>
            {elseif $status eq "Answered"}
                <span class="ticket-status-badge status-answered"><i class="fas fa-circle me-1" style="font-size:7px; vertical-align:middle;"></i>Answered</span>
            {elseif $status eq "Customer-Reply"}
                <span class="ticket-status-badge status-waiting"><i class="fas fa-circle me-1" style="font-size:7px; vertical-align:middle;"></i>Awaiting Reply</span>
            {elseif $status eq "Closed"}
                <span class="ticket-status-badge status-closed"><i class="fas fa-circle me-1" style="font-size:7px; vertical-align:middle;"></i>Closed</span>
            {else}
                <span class="ticket-status-badge status-closed">{$status}</span>
            {/if}
        </div>
    </div>
    <a href="supporttickets.php" class="btn btn-brand"><i class="fas fa-arrow-left me-2"></i>Back to Tickets</a>
</div>

<!-- Ticket Thread -->
<div class="ticket-thread-card mb-4">
    <div class="ticket-thread-header">
        <i class="fas fa-comments me-2"></i>Conversation Thread
    </div>
    <div class="ticket-replies-wrap">

        <!-- Original Message -->
        <div class="ticket-msg-row ticket-msg-client">
            <div class="ticket-msg-meta">
                <div class="ticket-avatar ticket-avatar-client">
                    {if $clientsdetails.firstname}{$clientsdetails.firstname|truncate:1:""}{else}Y{/if}
                </div>
                <div>
                    <span class="ticket-sender-name">You</span>
                    <span class="ticket-msg-time"><i class="far fa-clock me-1"></i>{$date}</span>
                </div>
            </div>
            <div class="ticket-bubble ticket-bubble-client">
                {$message}
            </div>
            {if $attachments}
            <div class="ticket-attachments">
                {foreach $attachments as $attachment}
                <a href="{$attachment.url}" class="ticket-attachment-pill"><i class="fas fa-paperclip me-1"></i>{$attachment.filename}</a>
                {/foreach}
            </div>
            {/if}
        </div>

        <!-- Replies -->
        {foreach $replies as $reply}
        <div class="ticket-msg-row {if $reply.admin}ticket-msg-staff{else}ticket-msg-client{/if}">
            <div class="ticket-msg-meta">
                <div class="ticket-avatar {if $reply.admin}ticket-avatar-staff{else}ticket-avatar-client{/if}">
                    {if $reply.admin}{$reply.admin|truncate:1:""}{else}{if $clientsdetails.firstname}{$clientsdetails.firstname|truncate:1:""}{else}Y{/if}{/if}
                </div>
                <div>
                    {if $reply.admin}
                        <span class="ticket-sender-name">{$reply.admin}</span>
                        <span class="ticket-staff-label"><i class="fas fa-shield-alt me-1"></i>Support Staff</span>
                    {else}
                        <span class="ticket-sender-name">You</span>
                    {/if}
                    <span class="ticket-msg-time"><i class="far fa-clock me-1"></i>{$reply.date}</span>
                </div>
            </div>
            <div class="ticket-bubble {if $reply.admin}ticket-bubble-staff{else}ticket-bubble-client{/if}">
                {$reply.message}
            </div>
            {if $reply.attachments}
            <div class="ticket-attachments {if $reply.admin}attachments-staff{/if}">
                {foreach $reply.attachments as $attachment}
                <a href="{$attachment.url}" class="ticket-attachment-pill"><i class="fas fa-paperclip me-1"></i>{$attachment.filename}</a>
                {/foreach}
            </div>
            {/if}
        </div>
        {/foreach}

    </div>
</div>

<!-- Reply Form -->
{if $status neq "Closed"}
<div class="ticket-reply-card">
    <div class="ticket-thread-header">
        <i class="fas fa-reply me-2"></i>Reply to Ticket
    </div>
    <div class="ticket-reply-body">
        <form method="post" action="viewticket.php?tid={$tid}&c={$c}" enctype="multipart/form-data">
            <input type="hidden" name="postreply" value="true" />
            <div class="mb-3">
                <textarea name="replymessage" rows="5" class="ticket-textarea" placeholder="Type your message here..."></textarea>
            </div>
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <label class="ticket-upload-label">
                        <i class="fas fa-paperclip me-1"></i>Attach Files
                        <input type="file" name="attachments[]" multiple class="d-none">
                    </label>
                    <div class="small text-secondary mt-1" style="font-size:0.75rem;">Allowed: {$allowedexts|default:'jpg,gif,jpeg,png,pdf'} (Max: {$uploadmaxsize|default:'8'}MB)</div>
                </div>
                <button type="submit" class="btn btn-brand px-5 fw-semibold"><i class="fas fa-paper-plane me-2"></i>Send Reply</button>
            </div>
        </form>
    </div>
</div>
{else}
<div class="ticket-closed-notice">
    <i class="fas fa-lock me-2"></i>This ticket is closed. <a href="submitticket.php" class="ticket-link">Open a new ticket</a> if you need further assistance.
</div>
{/if}
