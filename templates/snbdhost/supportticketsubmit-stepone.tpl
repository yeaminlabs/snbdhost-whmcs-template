<!-- ====== SUPPORT TICKET: STEP ONE — DEPARTMENT SELECTION ====== -->
<style>
.st1-wrap {
    max-width: 860px;
    margin: 0 auto;
    padding: 0 0 4rem;
}
.st1-title-row {
    margin-bottom: 2.25rem;
}
.st1-page-title {
    font-size: 1.9rem;
    font-weight: 900;
    letter-spacing: -0.04em;
    color: #111;
    line-height: 1;
    margin: 0 0 0.4rem;
}
.st1-page-sub {
    font-size: 0.9rem;
    color: #888;
    margin: 0;
    font-weight: 500;
}

/* ── Department Card Grid ── */
.st1-dept-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-bottom: 2rem;
}
.st1-dept-card {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    background: #fff;
    border: 1.5px solid #eee;
    border-radius: 16px;
    padding: 1.4rem 1.5rem;
    text-decoration: none !important;
    color: inherit;
    transition: all 0.2s cubic-bezier(0.4,0,0.2,1);
    position: relative;
    overflow: hidden;
}
.st1-dept-card::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, rgba(204,0,0,0.03) 0%, transparent 60%);
    opacity: 0;
    transition: opacity 0.2s;
    pointer-events: none;
}
.st1-dept-card:hover {
    border-color: #CC0000;
    transform: translateY(-2px);
    box-shadow: 0 8px 28px rgba(204,0,0,0.1);
    color: inherit;
    text-decoration: none;
}
.st1-dept-card:hover::after { opacity: 1; }
.st1-dept-card:hover .st1-dept-icon { background: #CC0000; color: #fff; }
.st1-dept-card:hover .st1-dept-arrow { color: #CC0000; opacity: 1; }

.st1-dept-icon {
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: #FFF0F0;
    color: #CC0000;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
    flex-shrink: 0;
    transition: all 0.2s;
}
.st1-dept-body {
    flex: 1;
    min-width: 0;
}
.st1-dept-name {
    font-size: 0.975rem;
    font-weight: 700;
    color: #111;
    margin: 0 0 0.3rem;
    line-height: 1.2;
}
.st1-dept-desc {
    font-size: 0.8rem;
    color: #999;
    margin: 0;
    line-height: 1.45;
}
.st1-dept-arrow {
    flex-shrink: 0;
    color: #ccc;
    font-size: 0.8rem;
    opacity: 0;
    transition: all 0.2s;
    align-self: center;
}

/* ── Icon map per dept name ── */
/* fallback handled in Smarty via generic envelope */

/* ── Bottom info strip ── */
.st1-info-strip {
    display: flex;
    align-items: center;
    gap: 2rem;
    background: #fafafa;
    border: 1px solid #f0f0f0;
    border-radius: 14px;
    padding: 1.1rem 1.5rem;
    flex-wrap: wrap;
}
.st1-info-item {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    font-size: 0.82rem;
    color: #888;
    font-weight: 500;
}
.st1-info-item i { color: #CC0000; font-size: 0.85rem; }

@media (max-width: 640px) {
    .st1-dept-grid { grid-template-columns: 1fr; }
    .st1-dept-arrow { display: none; }
    .st1-info-strip { gap: 1rem; flex-direction: column; align-items: flex-start; }
}
</style>

<div class="st1-wrap mt-3">

    <div class="st1-title-row">
        <h1 class="st1-page-title">Create Support Request</h1>
        <p class="st1-page-sub">Choose the department that best matches your issue — we'll route it to the right team.</p>
    </div>

    <div class="st1-dept-grid">
        {foreach from=$departments key=num item=department}
            {* Assign icon by exact department name match *}
            {assign var="deptNameLower" value=$department.name|lower}
            {assign var="deptIcon" value="fa-envelope"}
            {if $deptNameLower == 'general enquiries' || $deptNameLower == 'general'}
                {assign var="deptIcon" value="fa-comments"}
            {elseif $deptNameLower == 'billing'}
                {assign var="deptIcon" value="fa-receipt"}
            {elseif $deptNameLower == 'hosting'}
                {assign var="deptIcon" value="fa-server"}
            {elseif $deptNameLower == 'managed hosting'}
                {assign var="deptIcon" value="fa-robot"}
            {elseif $deptNameLower == 'domain'}
                {assign var="deptIcon" value="fa-globe"}
            {elseif $deptNameLower == 'vps' || $deptNameLower == 'cloud vps'}
                {assign var="deptIcon" value="fa-cloud"}
            {elseif $deptNameLower == 'abuse'}
                {assign var="deptIcon" value="fa-shield-alt"}
            {/if}

            <a href="{$smarty.server.PHP_SELF}?step=2&amp;deptid={$department.id}" class="st1-dept-card">
                <div class="st1-dept-icon">
                    <i class="fas {$deptIcon}"></i>
                </div>
                <div class="st1-dept-body">
                    <p class="st1-dept-name">{$department.name}</p>
                    {if $department.description}
                        <p class="st1-dept-desc">{$department.description}</p>
                    {/if}
                </div>
                <div class="st1-dept-arrow">
                    <i class="fas fa-arrow-right"></i>
                </div>
            </a>
        {foreachelse}
            {include file="$template/includes/alert.tpl" type="info" msg=$LANG.nosupportdepartments textcenter=true}
        {/foreach}
    </div>

    <div class="st1-info-strip">
        <div class="st1-info-item">
            <i class="fas fa-clock"></i>
            Average response: under 2 hours
        </div>
        <div class="st1-info-item">
            <i class="fas fa-headset"></i>
            Support available 7 days a week
        </div>
        <div class="st1-info-item">
            <i class="fas fa-book-open"></i>
            <a href="knowledgebase.php" style="color: #CC0000; font-weight: 600; text-decoration: none;">Check the Knowledgebase first</a>
        </div>
    </div>

</div>
