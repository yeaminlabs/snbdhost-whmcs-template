{if $kbarticle.voted}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key="knowledgebaseArticleRatingThanks"}</p></div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Knowledge base</p>
        <h1 class="snbd-page-title">{$kbarticle.title}</h1>
        {if $kbarticle.tags}
        <p class="snbd-page-sub"><i class="ti ti-tag" aria-hidden="true"></i>{$kbarticle.tags}</p>
        {/if}
    </div>
    <div class="snbd-page-actions">
        <span class="snbd-chip snbd-chip--neutral"><i class="ti ti-thumb-up" aria-hidden="true"></i>{$kbarticle.useful} found this useful</span>
        <button type="button" class="snbd-btn snbd-btn--secondary snbd-btn--sm" onclick="window.print()">
            <i class="ti ti-printer" aria-hidden="true"></i>{lang key='print'}
        </button>
    </div>
</div>

<div class="row g-4">
    <div class="col-xl-8">
        <article class="snbd-card snbd-article" aria-labelledby="snbd-article-body">
            <h2 class="snbd-visually-hidden" id="snbd-article-body">{$kbarticle.title}</h2>
            <div class="snbd-card__body snbd-article__body">
                {$kbarticle.text}
            </div>

            {if !$kbarticle.voted}
            <div class="snbd-card__foot snbd-article__vote">
                <form action="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}" method="post" class="snbd-cluster">
                    <input type="hidden" name="useful" value="vote">
                    <span class="snbd-caption mb-0">{lang key='knowledgebasehelpful'}</span>
                    <button class="snbd-btn snbd-btn--secondary snbd-btn--sm" type="submit" name="vote" value="yes">
                        <i class="ti ti-thumb-up" aria-hidden="true"></i>{lang key='knowledgebaseyes'}
                    </button>
                    <button class="snbd-btn snbd-btn--secondary snbd-btn--sm" type="submit" name="vote" value="no">
                        <i class="ti ti-thumb-down" aria-hidden="true"></i>{lang key='knowledgebaseno'}
                    </button>
                </form>
            </div>
            {/if}
        </article>
    </div>

    <div class="col-xl-4">
        <aside class="snbd-card snbd-card--rail" aria-labelledby="snbd-article-help">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-article-help"><i class="ti ti-lifebuoy" aria-hidden="true"></i>Still stuck?</h2>
            </div>
            <div class="snbd-card__body">
                <p class="snbd-caption">If this article did not solve it, the support team can look at your account directly.</p>
            </div>
            <div class="snbd-card__foot snbd-cluster">
                <a href="submitticket.php" class="snbd-btn snbd-btn--primary snbd-btn--sm">Open a ticket</a>
                <a href="{$WEB_ROOT}/knowledgebase.php" class="snbd-btn snbd-btn--secondary snbd-btn--sm">Browse guides</a>
            </div>
        </aside>
    </div>
</div>

{if $kbarticles}
<section class="snbd-card mt-4" aria-labelledby="snbd-article-related">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-article-related"><i class="ti ti-file-text" aria-hidden="true"></i>{lang key='knowledgebaserelated'}</h2>
    </div>
    <div class="snbd-card__body snbd-card__body--flush">
        <ul class="snbd-list">
            {foreach $kbarticles as $kbarticle}
            <li>
                <a href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}" class="snbd-list__item" data-id="{$kbarticle.id}">
                    <span class="snbd-list__title">{$kbarticle.title}</span>
                    <span class="snbd-list__text">{$kbarticle.article|truncate:100:'...'}</span>
                </a>
            </li>
            {/foreach}
        </ul>
    </div>
</section>
{/if}

<div class="snbd-cluster mt-4">
    <a href="{$WEB_ROOT}/knowledgebase.php" class="snbd-btn snbd-btn--secondary">
        <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
    </a>
    {if $kbarticle.editLink}
    <a href="{$kbarticle.editLink}" class="snbd-btn snbd-btn--ghost">
        <i class="ti ti-pencil" aria-hidden="true"></i>{lang key='edit'}
    </a>
    {/if}
</div>
