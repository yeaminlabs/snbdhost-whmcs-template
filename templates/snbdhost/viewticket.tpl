{assign var="replyCount" value=$replies|@count}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Ticket #{$tid}</p>
        <h1 class="snbd-page-title snbd-ticket__subject">{$subject}</h1>
        <div class="snbd-cluster mt-2">
            <span class="snbd-chip snbd-chip--neutral"><i class="ti ti-tag" aria-hidden="true"></i>{$department}</span>
            {if $status eq "Open"}
                <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>Open</span>
            {elseif $status eq "Answered"}
                <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Answered</span>
            {elseif $status eq "Customer-Reply" || $status eq "Awaiting Reply"}
                <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Awaiting reply</span>
            {elseif $status eq "Closed"}
                <span class="snbd-chip snbd-chip--neutral">Closed</span>
            {else}
                <span class="snbd-chip snbd-chip--neutral">{$status}</span>
            {/if}
            <span class="snbd-chip snbd-chip--neutral"><i class="ti ti-clock" aria-hidden="true"></i>Opened {$date}</span>
        </div>
    </div>
    <div class="snbd-page-actions">
        <a href="supporttickets.php" class="snbd-btn snbd-btn--secondary snbd-btn--sm"><i class="ti ti-arrow-left" aria-hidden="true"></i>All tickets</a>
    </div>
</div>

<div class="row g-4 mb-4">
    <div class="col-xl-8">
        <section class="snbd-card" aria-labelledby="ticket-thread-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="ticket-thread-title"><i class="ti ti-messages" aria-hidden="true"></i>Conversation</h2>
                <span class="snbd-caption">{$replyCount+1} message{if $replyCount != 0}s{/if}</span>
            </div>
            <div class="snbd-card__body snbd-thread">
                <article class="snbd-msg snbd-msg--client">
                    <div class="snbd-msg__meta">
                        <span class="snbd-avatar snbd-avatar--sm" aria-hidden="true">{if $clientname}{$clientname|truncate:1:""}{else}Y{/if}</span>
                        <span class="snbd-msg__author">You</span>
                        <time class="snbd-msg__time">{$date}</time>
                    </div>
                    <div class="snbd-msg__body">{$message}</div>
                    {if $attachments}
                    <div class="snbd-msg__files">
                        {foreach from=$attachments key=num item=attachment}
                        {assign var="attId" value=$attachment.id|default:$num}
                        {assign var="attLabel" value=$attachment.name|default:$attachment}
                        <a href="dl.php?type=a&amp;id={$id}&amp;i={$attId}" target="_blank" rel="noopener" class="snbd-file"><i class="ti ti-paperclip" aria-hidden="true"></i>{$attLabel}</a>
                        {/foreach}
                    </div>
                    {/if}
                </article>

                {foreach $replies as $reply}
                <article class="snbd-msg {if $reply.admin}snbd-msg--staff{else}snbd-msg--client{/if}">
                    <div class="snbd-msg__meta">
                        <span class="snbd-avatar snbd-avatar--sm {if $reply.admin}snbd-avatar--muted{/if}" aria-hidden="true">{if $reply.admin}{$reply.admin|truncate:1:""}{else}{if $clientname}{$clientname|truncate:1:""}{else}Y{/if}{/if}</span>
                        <span class="snbd-msg__author">
                            {if $reply.admin}{$reply.admin} <span class="snbd-chip snbd-chip--neutral snbd-msg__staff">Staff</span>{else}You{/if}
                        </span>
                        <time class="snbd-msg__time">{$reply.date}</time>
                    </div>
                    <div class="snbd-msg__body">{$reply.message}</div>
                    {if $reply.attachments}
                    <div class="snbd-msg__files">
                        {foreach from=$reply.attachments key=num item=attachment}
                        {assign var="attId" value=$attachment.id|default:$num}
                        {assign var="attLabel" value=$attachment.name|default:$attachment}
                        <a href="dl.php?type=ar&amp;id={$reply.id}&amp;i={$attId}" target="_blank" rel="noopener" class="snbd-file"><i class="ti ti-paperclip" aria-hidden="true"></i>{$attLabel}</a>
                        {/foreach}
                    </div>
                    {/if}
                </article>
                {/foreach}
            </div>
        </section>

        {if $status neq "Closed"}
        <section class="snbd-card mt-4" aria-labelledby="ticket-reply-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="ticket-reply-title"><i class="ti ti-edit" aria-hidden="true"></i>Reply</h2>
            </div>
            <div class="snbd-card__body">
                <form method="post" action="viewticket.php?tid={$tid}&amp;c={$c}" enctype="multipart/form-data" class="snbd-form needs-validation">
                    <input type="hidden" name="token" value="{$csrfToken}">
                    <input type="hidden" name="postreply" value="true">
                    <label class="snbd-label" for="replymessage">Your message</label>
                    <textarea id="replymessage" name="replymessage" rows="6" class="form-control" placeholder="Describe your reply or add more detail..." required></textarea>
                    <div class="snbd-spread mt-3 flex-wrap">
                        <div>
                            <label class="snbd-btn snbd-btn--secondary snbd-btn--sm snbd-upload" for="ticket-attachments">
                                <i class="ti ti-paperclip" aria-hidden="true"></i>Attach files
                            </label>
                            <input type="file" id="ticket-attachments" name="attachments[]" multiple class="snbd-visually-hidden">
                            <p class="snbd-hint mb-0">Allowed: {$allowedexts|default:'jpg,gif,jpeg,png,pdf'} · Max {$uploadmaxsize|default:'8'}MB</p>
                        </div>
                        <button type="submit" class="snbd-btn snbd-btn--primary"><i class="ti ti-send" aria-hidden="true"></i>Send reply</button>
                    </div>
                </form>
            </div>
        </section>
        {else}
        <div class="snbd-alert snbd-alert--info mt-4">
            <i class="ti ti-lock snbd-alert__icon" aria-hidden="true"></i>
            <div class="snbd-alert__body">
                <p class="snbd-alert__title">This ticket is closed</p>
                <p class="snbd-alert__text">If you need more help, <a href="submitticket.php">open a new ticket</a> and we will pick it up from there.</p>
            </div>
        </div>
        {/if}
    </div>

    <div class="col-xl-4">
        <aside class="snbd-card snbd-card--rail" aria-labelledby="ticket-properties-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="ticket-properties-title"><i class="ti ti-info-circle" aria-hidden="true"></i>Ticket details</h2>
            </div>
            <div class="snbd-card__body">
                <dl class="snbd-kv">
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Ticket ID</dt>
                        <dd class="snbd-kv__v">#{$tid}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Department</dt>
                        <dd class="snbd-kv__v">{$department}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Opened</dt>
                        <dd class="snbd-kv__v">{$date}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Status</dt>
                        <dd class="snbd-kv__v">{$status}</dd>
                    </div>
                </dl>
            </div>
            <div class="snbd-card__foot">
                <div class="snbd-stack snbd-stack--sm">
                    <a href="submitticket.php" class="d-inline-flex align-items-center gap-1"><i class="ti ti-plus" aria-hidden="true"></i>Open a new ticket</a>
                    <a href="https://snbdhost.com/kb" target="_blank" rel="noopener" class="d-inline-flex align-items-center gap-1"><i class="ti ti-book" aria-hidden="true"></i>Search the knowledge base</a>
                </div>
            </div>
        </aside>
    </div>
</div>
