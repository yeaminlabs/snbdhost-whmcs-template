<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{if $kbcurrentcat.name}{$kbcurrentcat.name}{else}Knowledge base{/if}</h1>
        <p class="snbd-page-sub">{if $tag}{lang key='kbviewingarticlestagged'} '{$tag}'{else}Guides, fixes and answers written by the team that runs your hosting.{/if}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="{$WEB_ROOT}/knowledgebase.php" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>All categories
        </a>
    </div>
</div>

<form role="search" method="post" action="{routePath('knowledgebase-search')}" class="snbd-form snbd-searchbar">
    <label class="snbd-visually-hidden" for="inputKnowledgebaseSearch">{lang key='clientHomeSearchKb'}</label>
    <div class="snbd-searchbar__row">
        <input type="text" id="inputKnowledgebaseSearch" name="search" class="form-control" placeholder="{lang key='clientHomeSearchKb'}" value="{$searchterm|escape}" autocomplete="off">
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
{/if}

{if $kbarticles || !$kbcats}
<section class="snbd-card" aria-labelledby="snbd-kb-articles">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-kb-articles">
            <i class="ti ti-file-text" aria-hidden="true"></i>{if $tag}{lang key='kbviewingarticlestagged'} '{$tag}'{else}{lang key='knowledgebasearticles'}{/if}
        </h2>
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
            {foreachelse}
            <li class="snbd-list__empty">{lang key='knowledgebasenoarticles'}</li>
            {/foreach}
        </ul>
    </div>
</section>
{/if}

<div class="snbd-cluster mt-4">
    <a href="{$WEB_ROOT}/knowledgebase.php" class="snbd-btn snbd-btn--secondary">
        <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
    </a>
    {if $kbcurrentcat.editLink}
    <a href="{$kbcurrentcat.editLink}" class="snbd-btn snbd-btn--ghost">
        <i class="ti ti-pencil" aria-hidden="true"></i>{lang key='edit'}
    </a>
    {/if}
</div>
