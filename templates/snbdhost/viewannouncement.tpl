<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{lang key='announcementstitle'}</p>
        <h1 class="snbd-page-title">{$title}</h1>
        <p class="snbd-page-sub">
            <i class="ti ti-calendar" aria-hidden="true"></i>
            {$carbon->createFromTimestamp($timestamp)->format('l, jS F, Y')}
            <span aria-hidden="true">·</span>
            {$carbon->createFromTimestamp($timestamp)->format('H:ia')}
        </p>
    </div>
    <div class="snbd-page-actions">
        {if $twittertweet}
            <a href="https://twitter.com/share" class="twitter-share-button snbd-btn snbd-btn--secondary snbd-btn--sm" data-count="vertical" data-size="large" data-via="{$twitterusername}">Tweet</a>
            <script src="https://platform.twitter.com/widgets.js"></script>
        {/if}
        <a href="{routePath('announcement-index')}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
        </a>
    </div>
</div>

<article class="snbd-card" aria-labelledby="snbd-announcement-body">
    <h2 class="snbd-visually-hidden" id="snbd-announcement-body">{$title}</h2>
    <div class="snbd-card__body snbd-article__body">
        {$text}
    </div>

    {if $facebookrecommend || $facebookcomments}
    <div class="snbd-card__foot">
        {if $facebookrecommend}
            <div id="fb-root"></div>
            <script>
                (function (d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) { return; }
                    js = d.createElement(s); js.id = id;
                    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
                    fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));
            </script>
            <div class="fb-like" data-href="{fqdnRoutePath('announcement-view', $id, $urlfriendlytitle)}" data-send="true" data-width="450" data-show-faces="true" data-action="recommend"></div>
        {/if}
        {if $facebookcomments}
            <div id="fb-root"></div>
            <script>
                (function (d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) { return; }
                    js = d.createElement(s); js.id = id;
                    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
                    fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));
            </script>
            <fb:comments href="{fqdnRoutePath('announcement-view', $id, $urlfriendlytitle)}" num_posts="5" width="100%"></fb:comments>
        {/if}
    </div>
    {/if}
</article>

{if $editLink}
<div class="snbd-cluster mt-4">
    <a href="{$editLink}" class="snbd-btn snbd-btn--ghost">
        <i class="ti ti-pencil" aria-hidden="true"></i>{lang key='edit'}
    </a>
</div>
{/if}
