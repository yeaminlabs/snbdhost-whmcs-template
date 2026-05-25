<!-- Ticket Header -->
<div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline" style="font-size: 2rem; margin-bottom: 0.25rem;">Ticket <span class="dash-headline-accent">#{$tid}</span></h1>
        <p class="text-secondary fw-semibold mb-0" style="font-size: 1.1rem; letter-spacing: -0.01em;">{$subject}</p>
        
        <div class="d-flex align-items-center gap-2 mt-3 flex-wrap">
            <span class="ticket-dept-badge"><i class="ti ti-tag me-1"></i>{$department}</span>
            {if $status eq "Open"}
                <span class="ticket-status-badge status-open"><i class="ti ti-circle-filled me-1" style="font-size:7px; vertical-align:middle;"></i>Open</span>
            {elseif $status eq "Answered"}
                <span class="ticket-status-badge status-answered"><i class="ti ti-circle-filled me-1" style="font-size:7px; vertical-align:middle;"></i>Answered</span>
            {elseif $status eq "Customer-Reply" || $status eq "Awaiting Reply"}
                <span class="ticket-status-badge status-waiting"><i class="ti ti-circle-filled me-1" style="font-size:7px; vertical-align:middle;"></i>Awaiting Reply</span>
            {elseif $status eq "Closed"}
                <span class="ticket-status-badge status-closed"><i class="ti ti-circle-filled me-1" style="font-size:7px; vertical-align:middle;"></i>Closed</span>
            {else}
                <span class="ticket-status-badge status-closed">{$status}</span>
            {/if}
        </div>
    </div>
    <a href="supporttickets.php" class="btn btn-outline-custom py-2 px-3"><i class="ti ti-arrow-left me-2"></i>Back to Tickets</a>
</div>

<!-- Ticket Conversation Thread -->
<div class="ticket-thread-card border-0 mb-4" style="border-radius: 16px; box-shadow: 0 4px 25px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important;">
    <div class="ticket-thread-header bg-white py-3 px-4 d-flex align-items-center" style="border-bottom: 1px solid #eeeeee;">
        <i class="ti ti-messages me-2 text-danger" style="font-size: 1.2rem;"></i> <span class="fw-bold" style="font-family: 'Plus Jakarta Sans', sans-serif;">Conversation Thread</span>
    </div>
    <div class="ticket-replies-wrap p-4 d-flex flex-column gap-4">

        <!-- Original Message -->
        <div class="ticket-msg-row ticket-msg-client">
            <div class="ticket-msg-meta">
                <div class="ticket-avatar ticket-avatar-client">
                    {if $clientsdetails.firstname}{$clientsdetails.firstname|truncate:1:""}{else}Y{/if}
                </div>
                <div>
                    <span class="ticket-sender-name text-end">You</span>
                    <span class="ticket-msg-time"><i class="ti ti-clock me-1"></i>{$date}</span>
                </div>
            </div>
            <div class="ticket-bubble ticket-bubble-client mt-2">
                {$message}
            </div>
            {if $attachments}
            <div class="ticket-attachments mt-2">
                {foreach $attachments as $attachment}
                <a href="{$attachment.url}" target="_blank" class="ticket-attachment-pill"><i class="ti ti-paperclip me-1"></i>{$attachment.filename}</a>
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
                        <span class="ticket-sender-name text-start">{$reply.admin} <span class="ticket-staff-label"><i class="ti ti-shield-check"></i> Staff</span></span>
                    {else}
                        <span class="ticket-sender-name text-end">You</span>
                    {/if}
                    <span class="ticket-msg-time"><i class="ti ti-clock me-1"></i>{$reply.date}</span>
                </div>
            </div>
            <div class="ticket-bubble {if $reply.admin}ticket-bubble-staff{else}ticket-bubble-client{/if} mt-2">
                {$reply.message}
            </div>
            {if $reply.attachments}
            <div class="ticket-attachments mt-2 {if $reply.admin}attachments-staff{/if}">
                {foreach $reply.attachments as $attachment}
                <a href="{$attachment.url}" target="_blank" class="ticket-attachment-pill"><i class="ti ti-paperclip me-1"></i>{$attachment.filename}</a>
                {/foreach}
            </div>
            {/if}
        </div>
        {/foreach}

    </div>
</div>

<!-- Reply Form -->
{if $status neq "Closed"}
<div class="ticket-reply-card border-0 mb-5" style="border-radius: 16px; box-shadow: 0 4px 25px rgba(0,0,0,0.02); border: 1px solid #eeeeee !important; overflow: hidden;">
    <div class="ticket-thread-header bg-white py-3 px-4 d-flex align-items-center" style="border-bottom: 1px solid #eeeeee;">
        <i class="ti ti-edit me-2 text-danger" style="font-size: 1.2rem;"></i> <span class="fw-bold" style="font-family: 'Plus Jakarta Sans', sans-serif;">Reply to Ticket</span>
    </div>
    <div class="ticket-reply-body p-4">
        <form method="post" action="viewticket.php?tid={$tid}&amp;c={$c}" enctype="multipart/form-data">
            <input type="hidden" name="postreply" value="true" />
            <div class="mb-4">
                <textarea name="replymessage" rows="6" class="ticket-textarea" placeholder="Type your response message here..."></textarea>
            </div>
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <label class="ticket-upload-label px-3 py-2" style="background: #fafafa; border-radius: 50rem; border: 1px dashed #d0d0d0; cursor: pointer; transition: all 0.2s;">
                        <i class="ti ti-paperclip me-1 text-danger"></i> <span class="small fw-semibold text-secondary">Attach Files</span>
                        <input type="file" name="attachments[]" multiple class="d-none">
                    </label>
                    <div class="small text-secondary mt-2" style="font-size:0.72rem;">Allowed extensions: <strong>{$allowedexts|default:'jpg,gif,jpeg,png,pdf'}</strong> (Max size: {$uploadmaxsize|default:'8'}MB)</div>
                </div>
                <button type="submit" class="btn btn-brand-clean px-4 py-2" style="font-size: 0.85rem !important;"><i class="ti ti-send me-2"></i>Send Reply</button>
            </div>
        </form>
    </div>
</div>
{else}
<div class="ticket-closed-notice d-flex align-items-center gap-3 p-4 mb-5 border-0" style="border-radius: 12px; background: rgba(100, 100, 100, 0.04); border: 1px solid #eeeeee !important;">
    <i class="ti ti-lock" style="font-size: 1.5rem; color: #666;"></i>
    <span class="text-secondary fw-semibold">This support ticket is closed. If you require further help, please <a href="submitticket.php" class="text-danger text-decoration-none fw-bold">open a new ticket</a>.</span>
</div>
{/if}
