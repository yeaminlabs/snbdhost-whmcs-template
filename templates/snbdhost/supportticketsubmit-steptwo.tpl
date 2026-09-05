<!-- ====== SUPPORT TICKET: STEP TWO — TICKET FORM ====== -->
<style>
.st2-wrap {
    max-width: 820px;
    margin: 0 auto;
    padding: 0 0 4rem;
}
.st2-title-row {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 2rem;
    flex-wrap: wrap;
}
.st2-back-btn {
    width: 36px; height: 36px;
    border-radius: 10px;
    border: 1.5px solid #e8e8e8;
    background: #fff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: #555;
    font-size: 0.85rem;
    text-decoration: none;
    flex-shrink: 0;
    transition: all 0.15s;
}
.st2-back-btn:hover { border-color: #CC0000; color: #CC0000; background: #FFF0F0; }
.st2-page-title {
    font-size: 1.75rem;
    font-weight: 900;
    letter-spacing: -0.04em;
    color: #111;
    margin: 0 0 0.2rem;
    line-height: 1;
}
.st2-dept-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    background: #FFF0F0;
    color: #CC0000;
    font-size: 0.75rem;
    font-weight: 700;
    border-radius: 6px;
    padding: 0.25rem 0.65rem;
}

/* ── Form Card ── */
.st2-card {
    background: #fff;
    border: 1.5px solid #eee;
    border-radius: 18px;
    overflow: hidden;
    margin-bottom: 1rem;
}
.st2-card-head {
    padding: 1.1rem 1.5rem;
    border-bottom: 1px solid #f0f0f0;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    background: #fafafa;
}
.st2-card-head-icon {
    width: 30px; height: 30px;
    border-radius: 8px;
    background: #FFF0F0;
    color: #CC0000;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.75rem;
    flex-shrink: 0;
}
.st2-card-head-title {
    font-size: 0.9rem;
    font-weight: 700;
    color: #111;
    margin: 0;
}
.st2-card-body { padding: 1.5rem; }

/* ── Form Controls ── */
.st2-label {
    font-size: 0.78rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #888;
    margin-bottom: 0.4rem;
    display: block;
}
.st2-input {
    width: 100%;
    border: 1.5px solid #e8e8e8;
    border-radius: 10px;
    padding: 0.65rem 0.9rem;
    font-size: 0.9rem;
    color: #111;
    background: #fff;
    outline: none;
    transition: border-color 0.2s;
    box-sizing: border-box;
}
.st2-input:focus { border-color: #CC0000; box-shadow: 0 0 0 3px rgba(204,0,0,0.06); }
.st2-input:disabled { background: #f8f8f8; color: #aaa; }
.st2-select { appearance: none; cursor: pointer; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23999' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 0.85rem center; padding-right: 2.5rem; }
.st2-textarea { resize: vertical; min-height: 220px; font-family: inherit; line-height: 1.6; }
.st2-row { display: grid; gap: 1rem; margin-bottom: 1rem; }
.st2-row-2 { grid-template-columns: 1fr 1fr; }
.st2-row-3 { grid-template-columns: 1fr 1fr 1fr; }

/* ── Priority chips ── */
.st2-priority-group {
    display: flex;
    gap: 0.6rem;
    flex-wrap: wrap;
}
.st2-priority-opt { display: none; }
.st2-priority-label {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    border-radius: 8px;
    border: 1.5px solid #e8e8e8;
    font-size: 0.82rem;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.15s;
    user-select: none;
}
.st2-priority-opt:checked + .st2-priority-label { border-color: currentColor; }
.st2-priority-label.high  { color: #c2410c; }
.st2-priority-label.med   { color: #b45309; }
.st2-priority-label.low   { color: #1d4ed8; }
.st2-priority-opt:checked + .st2-priority-label.high { background: #FFF7ED; border-color: #c2410c; }
.st2-priority-opt:checked + .st2-priority-label.med  { background: #FFFBEB; border-color: #b45309; }
.st2-priority-opt:checked + .st2-priority-label.low  { background: #EFF6FF; border-color: #1d4ed8; }

/* ── Attachment zone ── */
.st2-attach-zone {
    border: 1.5px dashed #e0e0e0;
    border-radius: 12px;
    padding: 1.25rem;
    text-align: center;
    background: #fafafa;
    transition: border-color 0.2s;
}
.st2-attach-zone:hover { border-color: #CC0000; }
.st2-attach-zone-icon { font-size: 1.5rem; color: #ccc; margin-bottom: 0.5rem; }
.st2-attach-note { font-size: 0.78rem; color: #aaa; margin-top: 0.4rem; }

/* ── Submit row ── */
.st2-submit-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    margin-top: 1.5rem;
    flex-wrap: wrap;
}
.st2-btn-submit {
    background: #CC0000;
    color: #fff;
    border: none;
    font-weight: 700;
    font-size: 0.9rem;
    border-radius: 10px;
    padding: 0.75rem 2rem;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.2s;
}
.st2-btn-submit:hover { background: #AA0000; transform: translateY(-1px); box-shadow: 0 6px 18px rgba(204,0,0,0.2); }
.st2-btn-cancel {
    font-size: 0.85rem;
    color: #888;
    text-decoration: none;
    font-weight: 600;
    padding: 0.5rem;
    transition: color 0.15s;
}
.st2-btn-cancel:hover { color: #CC0000; }

/* ── KB suggestions ── */
#autoAnswerSuggestions {
    background: #fafafa;
    border: 1.5px solid #f0f0f0;
    border-radius: 14px;
    padding: 1.25rem 1.5rem;
    margin-top: 1rem;
}

@media (max-width: 620px) {
    .st2-row-2, .st2-row-3 { grid-template-columns: 1fr; }
    .st2-submit-row { flex-direction: column-reverse; align-items: stretch; }
    .st2-btn-submit { justify-content: center; }
    .st2-btn-cancel { text-align: center; }
}
</style>

<div class="st2-wrap mt-3">

    {if $errormessage}
        {include file="$template/includes/alert.tpl" type="error" errorshtml=$errormessage}
    {/if}

    <!-- Title -->
    <div class="st2-title-row">
        <a href="{$smarty.server.PHP_SELF}" class="st2-back-btn" title="Back to departments">
            <i class="fas fa-arrow-left"></i>
        </a>
        <div>
            <h1 class="st2-page-title">New Support Ticket</h1>
            <span class="st2-dept-badge">
                <i class="fas fa-tag"></i>
                {foreach from=$departments item=d}{if $d.id eq $deptid}{$d.name}{/if}{/foreach}
            </span>
        </div>
    </div>

    <form method="post" action="{$smarty.server.PHP_SELF}?step=3" enctype="multipart/form-data">

        <!-- Contact Info -->
        <div class="st2-card">
            <div class="st2-card-head">
                <div class="st2-card-head-icon"><i class="fas fa-user"></i></div>
                <span class="st2-card-head-title">Contact Information</span>
            </div>
            <div class="st2-card-body">
                <div class="st2-row st2-row-2">
                    <div>
                        <label class="st2-label">{$LANG.supportticketsclientname}</label>
                        <input type="text" name="name" class="st2-input{if $loggedin} disabled{/if}" value="{$name}"{if $loggedin} disabled="disabled"{/if}>
                    </div>
                    <div>
                        <label class="st2-label">{$LANG.supportticketsclientemail}</label>
                        <input type="email" name="email" class="st2-input{if $loggedin} disabled{/if}" value="{$email}"{if $loggedin} disabled="disabled"{/if}>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket Details -->
        <div class="st2-card">
            <div class="st2-card-head">
                <div class="st2-card-head-icon"><i class="fas fa-ticket-alt"></i></div>
                <span class="st2-card-head-title">Ticket Details</span>
            </div>
            <div class="st2-card-body">

                <div class="mb-3">
                    <label class="st2-label">{$LANG.supportticketsticketsubject}</label>
                    <input type="text" name="subject" class="st2-input" value="{$subject}" placeholder="Summarise your issue in a few words">
                </div>

                <div class="st2-row {if $relatedservices}st2-row-3{else}st2-row-2{/if} mb-3">
                    <div>
                        <label class="st2-label">{$LANG.supportticketsdepartment}</label>
                        <select name="deptid" class="st2-input st2-select" onchange="refreshCustomFields(this)">
                            {foreach from=$departments item=department}
                                <option value="{$department.id}"{if $department.id eq $deptid} selected{/if}>{$department.name}</option>
                            {/foreach}
                        </select>
                    </div>
                    {if $relatedservices}
                        <div>
                            <label class="st2-label">{$LANG.relatedservice}</label>
                            <select name="relatedservice" class="st2-input st2-select">
                                <option value="">{$LANG.none}</option>
                                {foreach from=$relatedservices item=rs}
                                    <option value="{$rs.id}"{if $rs.id eq $selectedservice} selected{/if}>{$rs.name} ({$rs.status})</option>
                                {/foreach}
                            </select>
                        </div>
                    {/if}
                    <div>
                        <label class="st2-label">{$LANG.supportticketspriority}</label>
                        <div class="st2-priority-group mt-1">
                            <input type="radio" name="urgency" id="priHigh" value="High" class="st2-priority-opt"{if $urgency eq "High"} checked{/if}>
                            <label for="priHigh" class="st2-priority-label high"><i class="fas fa-fire-alt"></i> {$LANG.supportticketsticketurgencyhigh}</label>

                            <input type="radio" name="urgency" id="priMed" value="Medium" class="st2-priority-opt"{if $urgency eq "Medium" || !$urgency} checked{/if}>
                            <label for="priMed" class="st2-priority-label med"><i class="fas fa-minus-circle"></i> {$LANG.supportticketsticketurgencymedium}</label>

                            <input type="radio" name="urgency" id="priLow" value="Low" class="st2-priority-opt"{if $urgency eq "Low"} checked{/if}>
                            <label for="priLow" class="st2-priority-label low"><i class="fas fa-arrow-down"></i> {$LANG.supportticketsticketurgencylow}</label>
                        </div>
                    </div>
                </div>

                <div class="mb-1">
                    <label class="st2-label">{$LANG.contactmessage}</label>
                    <textarea name="message" class="st2-input st2-textarea markdown-editor" data-auto-save-name="client_ticket_open">{$message}</textarea>
                </div>

            </div>
        </div>

        <!-- Custom Fields -->
        <div id="customFieldsContainer">
            {include file="$template/supportticketsubmit-customfields.tpl"}
        </div>

        <!-- Attachment -->
        <div class="st2-card">
            <div class="st2-card-head">
                <div class="st2-card-head-icon"><i class="fas fa-paperclip"></i></div>
                <span class="st2-card-head-title">{$LANG.supportticketsticketattachments} <span style="font-weight:400;color:#aaa;font-size:0.8rem;">— optional</span></span>
            </div>
            <div class="st2-card-body">
                <div class="st2-attach-zone">
                    <div class="st2-attach-zone-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                    <input type="file" name="attachments[]" id="inputAttachments" class="st2-input" style="border:none;background:transparent;text-align:center;padding:0.25rem 0;">
                    <div id="fileUploadsContainer"></div>
                    <div class="st2-attach-note">{$LANG.supportticketsallowedextensions}: {$allowedfiletypes} &nbsp;·&nbsp; {lang key="maxFileSize" fileSize="$uploadMaxFileSize"}</div>
                </div>
                <button type="button" class="btn btn-sm mt-2" onclick="extraTicketAttachment()" style="border:1.5px solid #e8e8e8;border-radius:8px;font-size:0.8rem;font-weight:600;color:#666;background:#fff;">
                    <i class="fas fa-plus me-1"></i> {$LANG.addmore}
                </button>
            </div>
        </div>

        <!-- Captcha -->
        <div class="text-center mb-3">
            {include file="$template/includes/captcha.tpl"}
        </div>

        <!-- KB Suggestions -->
        <div id="autoAnswerSuggestions" class="hidden"></div>

        <!-- Submit -->
        <div class="st2-submit-row">
            <a href="supporttickets.php" class="st2-btn-cancel">
                <i class="fas fa-times me-1"></i> Cancel
            </a>
            <button type="submit" id="openTicketSubmit" class="st2-btn-submit disable-on-click{$captcha->getButtonClass($captchaForm)}">
                <i class="fas fa-paper-plane"></i> {$LANG.supportticketsticketsubmit}
            </button>
        </div>

    </form>

</div>

{if $kbsuggestions}
<script>
    jQuery(document).ready(function() { getTicketSuggestions(); });
</script>
{/if}
