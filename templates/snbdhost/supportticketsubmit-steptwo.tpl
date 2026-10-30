<!-- ====== SUPPORT TICKET: STEP TWO — TICKET FORM ====== -->

<div class="snbd-stack snbd-form">

    {if $errormessage}
        {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
    {/if}

    <header class="snbd-page-head">
        <div class="snbd-page-head__text">
            <p class="snbd-eyebrow"><a href="{$smarty.server.PHP_SELF}" class="snbd-eyebrow-link"><i class="ti ti-arrow-left" aria-hidden="true"></i> Departments</a></p>
            <h1 class="snbd-page-title">New ticket</h1>
            <p class="snbd-page-sub">
                <span class="snbd-chip snbd-chip--brand">
                    <i class="ti ti-tag" aria-hidden="true"></i>
                    {foreach from=$departments item=d}{if $d.id eq $deptid}{$d.name}{/if}{/foreach}
                </span>
            </p>
        </div>
    </header>

    <form method="post" action="{$smarty.server.PHP_SELF}?step=3" enctype="multipart/form-data" class="snbd-stack">
        <input type="hidden" name="token" value="{$token}">

        <section class="snbd-card">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title"><i class="ti ti-user" aria-hidden="true"></i> Contact</h2>
            </div>
            <div class="snbd-card__body">
                <div class="snbd-grid snbd-grid--2">
                    <div>
                        <label class="snbd-label" for="ticketName">{$LANG.supportticketsclientname}</label>
                        <input type="text" name="name" id="ticketName" class="form-control" value="{$name}"{if $loggedin} disabled="disabled"{/if}>
                    </div>
                    <div>
                        <label class="snbd-label" for="ticketEmail">{$LANG.supportticketsclientemail}</label>
                        <input type="email" name="email" id="ticketEmail" class="form-control" value="{$email}"{if $loggedin} disabled="disabled"{/if}>
                    </div>
                </div>
            </div>
        </section>

        <section class="snbd-card">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title"><i class="ti ti-ticket" aria-hidden="true"></i> Ticket details</h2>
            </div>
            <div class="snbd-card__body snbd-stack">
                <div>
                    <label class="snbd-label" for="ticketSubject">{$LANG.supportticketsticketsubject}</label>
                    <input type="text" name="subject" id="ticketSubject" class="form-control" value="{$subject}" placeholder="Summarise the issue in a few words">
                </div>

                <div class="snbd-grid {if $relatedservices}snbd-grid--3{else}snbd-grid--2{/if}">
                    <div>
                        <label class="snbd-label" for="ticketDept">{$LANG.supportticketsdepartment}</label>
                        <select name="deptid" id="ticketDept" class="form-select" onchange="refreshCustomFields(this)">
                            {foreach from=$departments item=department}
                                <option value="{$department.id}"{if $department.id eq $deptid} selected{/if}>{$department.name}</option>
                            {/foreach}
                        </select>
                    </div>
                    {if $relatedservices}
                        <div>
                            <label class="snbd-label" for="ticketService">{$LANG.relatedservice}</label>
                            <select name="relatedservice" id="ticketService" class="form-select">
                                <option value="">{$LANG.none}</option>
                                {foreach from=$relatedservices item=rs}
                                    <option value="{$rs.id}"{if $rs.id eq $selectedservice} selected{/if}>{$rs.name} ({$rs.status})</option>
                                {/foreach}
                            </select>
                        </div>
                    {/if}
                    <div>
                        <span class="snbd-label d-block">{$LANG.supportticketspriority}</span>
                        <div class="snbd-choice-group">
                            <input type="radio" name="urgency" id="priHigh" value="High" class="snbd-choice__input"{if $urgency eq "High"} checked{/if}>
                            <label for="priHigh" class="snbd-choice__label snbd-choice__label--high"><i class="ti ti-flame" aria-hidden="true"></i> {$LANG.supportticketsticketurgencyhigh}</label>

                            <input type="radio" name="urgency" id="priMed" value="Medium" class="snbd-choice__input"{if $urgency eq "Medium" || !$urgency} checked{/if}>
                            <label for="priMed" class="snbd-choice__label snbd-choice__label--warn"><i class="ti ti-minus" aria-hidden="true"></i> {$LANG.supportticketsticketurgencymedium}</label>

                            <input type="radio" name="urgency" id="priLow" value="Low" class="snbd-choice__input"{if $urgency eq "Low"} checked{/if}>
                            <label for="priLow" class="snbd-choice__label snbd-choice__label--info"><i class="ti ti-arrow-down" aria-hidden="true"></i> {$LANG.supportticketsticketurgencylow}</label>
                        </div>
                    </div>
                </div>

                <div>
                    <label class="snbd-label" for="ticketMessage">{$LANG.contactmessage}</label>
                    <textarea name="message" id="ticketMessage" class="form-control markdown-editor" rows="12" data-auto-save-name="client_ticket_open">{$message}</textarea>
                </div>
            </div>
        </section>

        <div id="customFieldsContainer">
            {include file="$template/supportticketsubmit-customfields.tpl"}
        </div>

        <section class="snbd-card">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title"><i class="ti ti-paperclip" aria-hidden="true"></i> {$LANG.supportticketsticketattachments}</h2>
                <span class="snbd-caption">Optional</span>
            </div>
            <div class="snbd-card__body">
                <div class="snbd-dropzone">
                    <i class="ti ti-cloud-upload snbd-dropzone__icon" aria-hidden="true"></i>
                    <input type="file" name="attachments[]" id="inputAttachments" class="form-control snbd-dropzone__input">
                    <div id="fileUploadsContainer"></div>
                    <p class="snbd-caption mb-0">{$LANG.supportticketsallowedextensions}: {$allowedfiletypes} &nbsp;·&nbsp; {lang key="maxFileSize" fileSize="$uploadMaxFileSize"}</p>
                </div>
                <button type="button" class="snbd-btn snbd-btn--secondary snbd-btn--sm mt-3" onclick="extraTicketAttachment()">
                    <i class="ti ti-plus" aria-hidden="true"></i> {$LANG.addmore}
                </button>
            </div>
        </section>

        <div class="text-center">
            {include file="$template/includes/captcha.tpl"}
        </div>

        <div id="autoAnswerSuggestions" class="hidden"></div>

        <div class="snbd-form-actions">
            <a href="supporttickets.php" class="snbd-btn snbd-btn--ghost">Cancel</a>
            <button type="submit" id="openTicketSubmit" class="snbd-btn snbd-btn--primary disable-on-click{$captcha->getButtonClass($captchaForm)}">
                <i class="ti ti-send" aria-hidden="true"></i> {$LANG.supportticketsticketsubmit}
            </button>
        </div>

    </form>

</div>

{if $kbsuggestions}
<script>
    jQuery(document).ready(function() { getTicketSuggestions(); });
</script>
{/if}
