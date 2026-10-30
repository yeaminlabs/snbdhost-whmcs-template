<!-- ====== SUPPORT TICKET: STEP ONE — DEPARTMENT SELECTION ====== -->

<div class="snbd-stack">

    <header class="snbd-page-head">
        <div class="snbd-page-head__text">
            <p class="snbd-eyebrow">Support</p>
            <h1 class="snbd-page-title">Open a ticket</h1>
            <p class="snbd-page-sub">Pick the department that fits your issue and we will route it to the right team.</p>
        </div>
    </header>

    <div class="snbd-dept-grid">
        {foreach from=$departments key=num item=department}
            {* Icon by department name, with a safe fallback *}
            {assign var="deptNameLower" value=$department.name|lower}
            {assign var="deptIcon" value="ti-mail"}
            {if $deptNameLower == 'general enquiries' || $deptNameLower == 'general'}
                {assign var="deptIcon" value="ti-messages"}
            {elseif $deptNameLower == 'billing'}
                {assign var="deptIcon" value="ti-receipt"}
            {elseif $deptNameLower == 'hosting'}
                {assign var="deptIcon" value="ti-server"}
            {elseif $deptNameLower == 'managed hosting'}
                {assign var="deptIcon" value="ti-robot"}
            {elseif $deptNameLower == 'domain'}
                {assign var="deptIcon" value="ti-world"}
            {elseif $deptNameLower == 'vps' || $deptNameLower == 'cloud vps'}
                {assign var="deptIcon" value="ti-cloud"}
            {elseif $deptNameLower == 'abuse'}
                {assign var="deptIcon" value="ti-shield-exclamation"}
            {/if}

            <a href="{$smarty.server.PHP_SELF}?step=2&amp;deptid={$department.id}" class="snbd-dept">
                <span class="snbd-dept__icon"><i class="ti {$deptIcon}" aria-hidden="true"></i></span>
                <span class="snbd-dept__body">
                    <span class="snbd-dept__name">{$department.name}</span>
                    {if $department.description}
                        <span class="snbd-dept__desc">{$department.description}</span>
                    {/if}
                </span>
                <i class="ti ti-arrow-right snbd-dept__arrow" aria-hidden="true"></i>
            </a>
        {foreachelse}
            {include file="$template/includes/alert.tpl" type="info" msg=$LANG.nosupportdepartments textcenter=true}
        {/foreach}
    </div>

    <div class="snbd-card snbd-card--muted">
        <div class="snbd-card__body snbd-card__body--tight">
            <div class="snbd-cluster snbd-cluster--loose">
                <span class="snbd-cluster snbd-small snbd-muted"><i class="ti ti-clock" aria-hidden="true"></i> First reply in under 2 hours</span>
                <span class="snbd-cluster snbd-small snbd-muted"><i class="ti ti-headset" aria-hidden="true"></i> Support 7 days a week</span>
                <a class="snbd-cluster snbd-small snbd-nowrap" href="knowledgebase.php"><i class="ti ti-book" aria-hidden="true"></i> Check the knowledgebase first</a>
            </div>
        </div>
    </div>

</div>
