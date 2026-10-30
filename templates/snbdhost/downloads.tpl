<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">Downloads</h1>
        <p class="snbd-page-sub">Scripts, tools and resources available with your account.</p>
    </div>
</div>

<form role="search" method="post" action="{routePath('download-search')}" class="snbd-form snbd-searchbar">
    <label class="snbd-visually-hidden" for="inputDownloadsSearch">{lang key='downloadssearch'}</label>
    <div class="snbd-searchbar__row">
        <input type="text" name="search" id="inputDownloadsSearch" class="form-control" placeholder="{lang key='downloadssearch'}" autocomplete="off">
        <button type="submit" id="btnDownloadsSearch" class="snbd-btn snbd-btn--primary">
            <i class="ti ti-search" aria-hidden="true"></i>{lang key='search'}
        </button>
    </div>
</form>

{if $dlcats}
<div class="row g-4 mb-4">
    {foreach $dlcats as $category}
    <div class="col-md-6">
        <a class="snbd-card snbd-cat-card h-100" href="{routePath('download-by-cat', {$category.id}, {$category.urlfriendlyname})}">
            <span class="snbd-card__body">
                <span class="snbd-cluster justify-content-between align-items-start mb-2">
                    <span class="snbd-cluster gap-2">
                        <span class="snbd-stat__icon"><i class="ti ti-folder-download" aria-hidden="true"></i></span>
                        <span class="snbd-cat-card__name">{$category.name}</span>
                    </span>
                    <span class="snbd-chip snbd-chip--neutral">{lang key="downloads.numDownload{if $category.numarticles != 1}s{/if}" num=$category.numarticles}</span>
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
        <span class="snbd-empty__icon"><i class="ti ti-download" aria-hidden="true"></i></span>
        <p class="snbd-empty__title">{lang key='downloadsnone'}</p>
        <p class="snbd-empty__text">No files are published for download yet.</p>
    </div>
</div>
{/if}

{if $mostdownloads}
<section class="snbd-card" aria-labelledby="snbd-downloads-popular">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="snbd-downloads-popular"><i class="ti ti-star" aria-hidden="true"></i>{lang key='downloadspopular'}</h2>
    </div>
    <div class="snbd-card__body snbd-card__body--flush">
        <ul class="snbd-list">
            {foreach $mostdownloads as $download}
            <li>
                <a href="{$download.link}" class="snbd-list__item">
                    <span class="snbd-list__title">
                        {$download.type|replace:'alt':' class="snbd-list__thumb" alt'}
                        {$download.title}
                        {if $download.clientsonly}
                            <span class="snbd-chip snbd-chip--warn"><i class="ti ti-lock" aria-hidden="true"></i>{lang key='restricted'}</span>
                        {/if}
                    </span>
                    <span class="snbd-list__text">
                        {$download.description}
                        {if $download.description}<br>{/if}
                        <strong>{lang key='downloadsfilesize'}: {$download.filesize}</strong>
                    </span>
                </a>
            </li>
            {/foreach}
        </ul>
    </div>
</section>
{/if}
