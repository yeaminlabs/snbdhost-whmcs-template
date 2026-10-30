<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='announcementstitle'}</h1>
        <p class="snbd-page-sub">Service notices, new features and scheduled maintenance windows.</p>
    </div>
</div>

<div class="row g-4">
    {foreach $announcements as $announcement}
    <div class="col-lg-6">
        <article class="snbd-card h-100">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">
                    <a href="{routePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}">{$announcement.title}</a>
                </h2>
            </div>
            <div class="snbd-card__body">
                <p class="snbd-announce__date mb-3">
                    <i class="ti ti-calendar" aria-hidden="true"></i>
                    {$carbon->createFromTimestamp($announcement.timestamp)->format('jS F Y')}
                </p>
                <div class="snbd-announce__text">
                    {if $announcement.text|strip_tags|strlen < 350}
                        {$announcement.text}
                    {else}
                        {$announcement.summary}
                    {/if}
                </div>
            </div>
            <div class="snbd-card__foot">
                <a href="{routePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
                    {lang key='announcementscontinue'}<i class="ti ti-arrow-right" aria-hidden="true"></i>
                </a>
                {if $announcement.editLink}
                <a href="{$announcement.editLink}" class="snbd-btn snbd-btn--ghost snbd-btn--sm">
                    <i class="ti ti-pencil" aria-hidden="true"></i>{lang key='edit'}
                </a>
                {/if}
            </div>
        </article>
    </div>
    {foreachelse}
    <div class="col-12">
        <div class="snbd-card">
            <div class="snbd-empty">
                <span class="snbd-empty__icon"><i class="ti ti-speakerphone" aria-hidden="true"></i></span>
                <p class="snbd-empty__title">{lang key='noannouncements'}</p>
                <p class="snbd-empty__text">There is nothing new right now. Service notices will appear here.</p>
            </div>
        </div>
    </div>
    {/foreach}
</div>

{if $prevpage || $nextpage}
<nav class="snbd-pagination mt-4" aria-label="Announcements pages">
    {foreach $pagination as $item}
        {if $item.active}
            <span class="snbd-btn snbd-btn--sm snbd-btn--primary" aria-current="page">{$item.text}</span>
        {elseif $item.disabled}
            <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true">{$item.text}</span>
        {else}
            <a href="{$item.link}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">{$item.text}</a>
        {/if}
    {/foreach}
</nav>
{/if}
