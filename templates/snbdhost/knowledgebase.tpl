<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">Knowledge base</h1>
        <p class="snbd-page-sub">Guides, fixes and answers written by the team that runs your hosting.</p>
    </div>
</div>

<form role="search" method="post" action="{routePath('knowledgebase-search')}" class="snbd-form snbd-searchbar">
    <label class="snbd-visually-hidden" for="inputKnowledgebaseSearch">{lang key='clientHomeSearchKb'}</label>
    <div class="snbd-searchbar__row">
        <input type="text" id="inputKnowledgebaseSearch" name="search" class="form-control" placeholder="{lang key='clientHomeSearchKb'}" autocomplete="off">
        <button type="submit" id="btnKnowledgebaseSearch" class="snbd-btn snbd-btn--primary">
            <i class="ti ti-search" aria-hidden="true"></i>{lang key='search'}
        </button>
    </div>
</form>

{if $kbcats}
<div class="row g-4 mb-4">
    {foreach $kbcats as $category}
    <div class="col-md-6">
        <a class="snbd-card snbd-cat-card h-100" href="{routePath('knowledgebase-category-view', {$category.id}, {$category.urlfriendlyname})}" data-id="{$category.id}">
            <span class="snbd-card__body">
                <span class="snbd-cluster justify-content-between align-items-start mb-2">
                    <span class="snbd-cluster gap-2">
                        <span class="snbd-stat__icon"><i class="ti ti-folder" aria-hidden="true"></i></span>
                        <span class="snbd-cat-card__name">{$category.name}</span>
                    </span>
                    <span class="snbd-chip snbd-chip--neutral">{lang key="knowledgebase.numArticle{if $category.numarticles != 1}s{/if}" num=$category.numarticles}</span>
                </span>
                {if $category.description}<span class="snbd-caption d-block mb-0">{$category.description}</span>{/if}
            </span>
        </a>
    </div>
    {/foreach}
</div>
{else}
<div class="snbd-card mb-4">
    <div class="snbd-empty">
        <span class="snbd-empty__icon"><i class="ti ti-book" aria-hidden="true"></i></span>
        <p class="snbd-empty__title">{lang key='knowledgebasenoarticles'}</p>
        <p class="snbd-empty__text">Try a different search term, or open a ticket and we will help directly.</p>
        <a href="submitticket.php" class="snbd-btn snbd-btn--primary snbd-btn--sm">Open a ticket</a>
    </div>
</div>
{/if}

{if $kbmostviews}
<section class="snbd-card" aria-labelledby="snbd-kb-popular">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-kb-popular"><i class="ti ti-star" aria-hidden="true"></i>{lang key='knowledgebasepopular'}</h2>
    </div>
    <div class="snbd-card__body snbd-card__body--flush">
        <ul class="snbd-list">
            {foreach $kbmostviews as $kbarticle}
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
