<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#BA1114">
    <title>{$companyname} - {$pagetitle}</title>

    <script>
        {literal}
        var csrfToken = '{/literal}{$token}{literal}',
            markdownGuide = '{/literal}{lang key="markdown.title"}{literal}',
            locale = '{/literal}{if !empty($mdeLocale)}{$mdeLocale}{else}en{/if}{literal}',
            saved = '{/literal}{lang key="markdown.saved"}{literal}',
            saving = '{/literal}{lang key="markdown.saving"}{literal}',
            whmcsBaseUrl = "{/literal}{$WEB_ROOT}{literal}";
        {/literal}
        {if $requiredVariables}
            {foreach from=$requiredVariables key="variable" item="value"}
                var {$variable} = "{$value}";
            {/foreach}
        {/if}
    </script>

    {* Apply the persisted sidebar rail state before first paint (desktop only). *}
    <script>
        {literal}
        try {
            if (localStorage.getItem('snbd-sidebar-rail') === '1' && window.innerWidth >= 1200) {
                document.documentElement.classList.add('snbd-rail');
            }
        } catch (e) {}
        {/literal}
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet">
    <!-- Tabler icon set (pinned) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@3.50.0/dist/tabler-icons.min.css">

    {*
       $snbdAuthPage comes from the ClientAreaPage hook so the footer, which is
       rendered separately, closes the shell only when the header opened it.
       The fallback below covers a theme uploaded without the matching copy of
       includes/hooks: without it the login page renders inside the client-area
       shell and the Google button loses its script. It is assigned globally
       because the footer reads it in a separate template scope.
    *}
    {if !$snbdAuthPage && $templatefile && ($templatefile == 'login' || $templatefile == 'clientregister'
        || $templatefile == 'pwreset' || $templatefile == 'two-factor-challenge'
        || $templatefile|substr:0:15 == 'password-reset-')}
        {assign scope="global" var="snbdAuthPage" value=true}
    {/if}
    {*
       One Bootstrap per page. $snbdCustomTemplate is set by the theme hook when
       this page has its own template file, so a page is styled by the SNBD system
       automatically and a page without one falls back to the parent's Bootstrap 4
       stack plus snbd-legacy.css. Adding a template is all it takes to opt in.
    *}
    {if !$snbdCustomTemplate}
        {* Parent Twenty-One stylesheet: only for WHMCS pages the theme has not rebuilt. *}
        <link href="{$WEB_ROOT}/templates/{$template}/css/all.min.css?v={$versionHash}" rel="stylesheet">
        <link href="{$WEB_ROOT}/templates/{$template}/css/theme.css?v={$versionHash}" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    {else}
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    {/if}

    <!-- SNBD Host design system -->
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbd-system.css?v={$smarty.now}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbd-shell.css?v={$smarty.now}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbd-pages.css?v={$smarty.now}" rel="stylesheet">
    {if !$snbdCustomTemplate}
        <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbd-legacy.css?v={$smarty.now}" rel="stylesheet">
    {/if}

    {*
       Rebuilt pages run on Bootstrap 5 markup and vanilla JS, so the only script
       they need is jQuery, for WHMCS's own inline page scripts and module output.
       The parent bundle (jQuery + Bootstrap 4 + DataTables + editor and widget
       libraries, ~670KB) is 97% unused there, so it stays on unbuilt pages only.
    *}
    {if $snbdCustomTemplate}
        <script src="{$WEB_ROOT}/templates/{$template}/assets/js/jquery-1.12.4.min.js?v={$smarty.now}"></script>
    {else}
        <script src="{$WEB_ROOT}/templates/{$template}/js/scripts.min.js?v={$versionHash}"></script>
    {/if}

    {$headoutput}

    {*
       Google Identity Services loads wherever a button can be shown, not only on
       the auth pages: $googleClientId is the real condition, so a stale or
       missing $snbdAuthPage can no longer leave the button markup without its
       script. Pages without a client id pay nothing.
    *}
    {if $snbdAuthPage || $googleClientId}
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <script src="{$WEB_ROOT}/templates/{$template}/assets/js/google-signin.js?v={$smarty.now}"></script>
    {/if}

    <!-- Google Tag Manager -->
    {literal}
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-N675SJK');</script>
    {/literal}
    <!-- End Google Tag Manager -->
</head>
<body data-phone-cc-input="{$phoneNumberInputStyle}"{if $snbdAuthPage} class="snbd-auth-body"{/if}>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-N675SJK"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

{$headeroutput}

{if $snbdAuthPage}

    {* Authentication pages render their own split-panel layout. *}

{else}

    {capture assign="snbdCrumb"}
        {if $filename eq 'clientarea' && $action eq ''}Dashboard
        {elseif $filename eq 'clientarea' && $action eq 'products'}Services
        {elseif $filename eq 'clientarea' && $action eq 'productdetails'}Service
        {elseif $filename eq 'clientarea' && $action eq 'domains'}Domains
        {elseif $filename eq 'clientarea' && $action eq 'domaindetails'}Domain
        {elseif $filename eq 'clientarea' && ($action eq 'invoices' || $action eq 'quotes' || $action eq 'transactions')}Billing
        {elseif $filename eq 'clientarea' && $action eq 'details'}My details
        {elseif $filename eq 'clientarea' && $action eq 'creditcard'}Payment methods
        {elseif $filename eq 'clientarea' && $action eq 'emails'}Email history
        {elseif $filename eq 'clientarea' && $action eq 'addfunds'}Add funds
        {elseif $filename eq 'clientarea' && $action eq 'masspay'}Pay invoices
        {elseif $filename eq 'clientarea' && $action eq 'devupdates'}Developer updates
        {elseif $filename eq 'clientarea'}Account
        {elseif $filename eq 'viewinvoice'}Invoice
        {elseif $filename eq 'supporttickets'}Tickets
        {elseif $filename eq 'submitticket'}New ticket
        {elseif $filename eq 'viewticket'}Ticket
        {elseif $filename eq 'affiliates'}Affiliates
        {elseif $filename eq 'serverstatus'}Network status
        {elseif $filename eq 'knowledgebase'}Knowledge base
        {elseif $filename eq 'announcements'}Announcements
        {elseif $filename eq 'migration'}Migration
        {elseif $filename eq 'cart' || $templatefile eq 'viewcart' || $templatefile eq 'checkout' || $templatefile eq 'complete' || $templatefile eq 'products' || $templatefile eq 'configureproduct' || $templatefile eq 'configuredomains' || $templatefile eq 'domainregister' || $templatefile eq 'domaintransfer' || $templatefile eq 'domainoptions'}Order
        {else}{$pagetitle|truncate:38:''|default:'Client area'}
        {/if}
    {/capture}

    <a class="snbd-skip-link" href="#snbd-content">Skip to content</a>

    <div id="snbd-wrapper">
        <aside id="snbd-sidebar" aria-label="Main navigation">
            <div class="snbd-brand">
                <a href="{$WEB_ROOT}/clientarea.php" class="snbd-brand__link" aria-label="{$companyname} home">
                    <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" class="snbd-brand__logo">
                    <span class="snbd-brand__mark" aria-hidden="true">S</span>
                </a>
                <button type="button" class="snbd-rail-toggle" aria-controls="snbd-sidebar" aria-expanded="true" aria-label="Collapse sidebar">
                    <i class="ti ti-layout-sidebar-left-collapse" aria-hidden="true"></i>
                </button>
            </div>

            <nav class="snbd-nav" aria-label="Client area">
                <div class="snbd-nav__group">
                    <div class="snbd-nav__divider" aria-hidden="true"></div>
                    <div class="snbd-nav__label">Manage</div>
                    <a href="{$WEB_ROOT}/clientarea.php" class="snbd-nav__item {if $filename eq 'clientarea' && $action eq ''}active{/if}" data-label="Dashboard" {if $filename eq 'clientarea' && $action eq ''}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-layout-dashboard" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Dashboard</span>
                    </a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=products" class="snbd-nav__item {if $filename eq 'clientarea' && ($action eq 'products' || $action eq 'productdetails')}active{/if}" data-label="Services" {if $filename eq 'clientarea' && ($action eq 'products' || $action eq 'productdetails')}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-server" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Services</span>
                    </a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=domains" class="snbd-nav__item {if $filename eq 'clientarea' && ($action eq 'domains' || $action eq 'domaindetails')}active{/if}" data-label="Domains" {if $filename eq 'clientarea' && ($action eq 'domains' || $action eq 'domaindetails')}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-world" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Domains</span>
                    </a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="snbd-nav__item {if ($filename eq 'clientarea' && ($action eq 'invoices' || $action eq 'quotes' || $action eq 'transactions' || $action eq 'masspay')) || $filename eq 'viewinvoice'}active{/if}" data-label="Billing" {if ($filename eq 'clientarea' && ($action eq 'invoices' || $action eq 'quotes' || $action eq 'transactions' || $action eq 'masspay')) || $filename eq 'viewinvoice'}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-receipt" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Billing</span>
                    </a>
                    <a href="{$WEB_ROOT}/affiliates.php" class="snbd-nav__item {if $filename eq 'affiliates'}active{/if}" data-label="Affiliates" {if $filename eq 'affiliates'}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-users" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Affiliates</span>
                    </a>
                </div>

                <div class="snbd-nav__group">
                    <div class="snbd-nav__divider" aria-hidden="true"></div>
                    <div class="snbd-nav__label">Support</div>
                    <a href="{$WEB_ROOT}/supporttickets.php" class="snbd-nav__item {if $filename eq 'supporttickets' || $filename eq 'viewticket' || $filename eq 'submitticket'}active{/if}" data-label="Tickets" {if $filename eq 'supporttickets' || $filename eq 'viewticket' || $filename eq 'submitticket'}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-lifebuoy" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Tickets</span>
                        {if $snbdNotifications && $snbdNotifications.openTickets > 0}
                            <span class="snbd-nav__badge">{$snbdNotifications.openTickets}</span>
                        {/if}
                    </a>
                    <a href="https://snbdhost.com/kb" target="_blank" rel="noopener" class="snbd-nav__item" data-label="Knowledge Base">
                        <span class="snbd-nav__icon"><i class="ti ti-book" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Knowledge Base</span>
                        <span class="snbd-visually-hidden">(opens in a new tab)</span>
                    </a>
                    <a href="{$WEB_ROOT}/serverstatus.php" class="snbd-nav__item {if $filename eq 'serverstatus'}active{/if}" data-label="Network Status" {if $filename eq 'serverstatus'}aria-current="page"{/if}>
                        <span class="snbd-nav__icon"><i class="ti ti-activity" aria-hidden="true"></i></span>
                        <span class="snbd-nav__label-text">Network Status</span>
                    </a>
                </div>
            </nav>

            <div class="snbd-sidebar__foot">
                {if $loggedin}
                    <button type="button" class="snbd-user" data-snbd-popover="accountMenu" aria-expanded="false" aria-haspopup="true" aria-controls="accountMenu">
                        <span class="snbd-avatar{if $snbdAvatarUrl} snbd-avatar--img{/if}" aria-hidden="true">{if $snbdAvatarUrl}<img src="{$snbdAvatarUrl}" alt="" loading="lazy" referrerpolicy="no-referrer">{else}{if $clientsdetails.firstname}{$clientsdetails.firstname|truncate:1:''}{else}U{/if}{/if}</span>
                        <span class="snbd-user__meta">
                            <span class="snbd-user__name">{$clientsdetails.firstname} {$clientsdetails.lastname}</span>
                            <span class="snbd-user__email">{$clientsdetails.email}</span>
                        </span>
                        <i class="ti ti-chevron-up snbd-user__chevron" aria-hidden="true"></i>
                    </button>
                    <div class="snbd-popover" id="accountMenu" role="menu" aria-label="Account">
                        <ul class="snbd-menu">
                            <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="ti ti-user" aria-hidden="true"></i>My details</a></li>
                            <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=creditcard"><i class="ti ti-credit-card" aria-hidden="true"></i>Payment methods</a></li>
                            <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=emails"><i class="ti ti-mail" aria-hidden="true"></i>Email history</a></li>
                            <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=addfunds"><i class="ti ti-wallet" aria-hidden="true"></i>Add funds</a></li>
                            <li><hr class="snbd-menu__divider"></li>
                            <li><a class="snbd-menu__item snbd-menu__item--danger" role="menuitem" href="{$WEB_ROOT}/logout.php"><i class="ti ti-logout" aria-hidden="true"></i>Sign out</a></li>
                        </ul>
                    </div>
                {else}
                    <a href="{$WEB_ROOT}/login.php" class="snbd-user">
                        <span class="snbd-avatar snbd-avatar--muted" aria-hidden="true"><i class="ti ti-user"></i></span>
                        <span class="snbd-user__meta">
                            <span class="snbd-user__name">Sign in</span>
                            <span class="snbd-user__email">Access your account</span>
                        </span>
                        <i class="ti ti-arrow-right snbd-user__chevron" aria-hidden="true"></i>
                    </a>
                {/if}
            </div>
        </aside>

        <div class="snbd-backdrop" id="sidebarBackdrop" aria-hidden="true"></div>

        <main id="snbd-main">
            <header id="snbd-topbar">
                <div class="snbd-topbar__left">
                    <button type="button" class="snbd-icon-btn snbd-menu-btn" aria-label="Open navigation" aria-controls="snbd-sidebar" aria-expanded="false">
                        <i class="ti ti-menu-2" aria-hidden="true"></i>
                    </button>
                    <nav class="snbd-crumbs" aria-label="Breadcrumb">
                        <a href="{$WEB_ROOT}/clientarea.php">Client area</a>
                        <span class="snbd-crumbs__sep" aria-hidden="true">/</span>
                        <span class="snbd-crumbs__current">{$snbdCrumb|trim}</span>
                    </nav>
                </div>

                <form class="snbd-search" action="{$WEB_ROOT}/knowledgebase.php" method="get" role="search">
                    <input type="hidden" name="action" value="search">
                    <i class="ti ti-search snbd-search__icon" aria-hidden="true"></i>
                    <input type="text" name="search" placeholder="Search guides and services" aria-label="Search the knowledge base" autocomplete="off" data-snbd-search>
                    <kbd aria-hidden="true">/</kbd>
                </form>

                <div class="snbd-topbar__right">
                    {if $loggedin}
                        <a href="{$WEB_ROOT}/cart.php" class="snbd-btn snbd-btn--primary snbd-btn--sm snbd-order-btn">
                            <i class="ti ti-plus" aria-hidden="true"></i><span>Order service</span>
                        </a>
                    {/if}

                    {if $loggedin}
                        <button type="button" class="snbd-icon-btn" data-snbd-popover="notifMenu" aria-expanded="false" aria-haspopup="true" aria-controls="notifMenu" aria-label="Notifications{if $snbdNotifications} ({$snbdNotifications.total} unread){/if}">
                            <i class="ti ti-bell" aria-hidden="true"></i>
                            {if $snbdNotifications && $snbdNotifications.total > 0}
                                <span class="snbd-icon-btn__badge" aria-hidden="true">{$snbdNotifications.total}</span>
                            {/if}
                        </button>
                        <div class="snbd-popover" id="notifMenu" aria-label="Notifications">
                            <div class="snbd-popover__head">
                                <span>Notifications</span>
                                {if $snbdNotifications && $snbdNotifications.total > 0}
                                    <span class="snbd-chip snbd-chip--warn">{$snbdNotifications.total} need attention</span>
                                {/if}
                            </div>
                            <div class="snbd-popover__body">
                                {if $snbdNotifications}
                                    {foreach from=$snbdNotifications.items item=note}
                                        <a class="snbd-notif-item snbd-notif-item--{$note.severity}" href="{$note.url}">
                                            <span class="snbd-notif-item__icon"><i class="ti {$note.icon}" aria-hidden="true"></i></span>
                                            <span>
                                                <span class="snbd-notif-item__title">{$note.title}</span>
                                                <span class="snbd-notif-item__meta">{$note.meta}</span>
                                            </span>
                                        </a>
                                    {foreachelse}
                                        <div class="snbd-notif-empty">You're all caught up.</div>
                                    {/foreach}
                                {else}
                                    <div class="snbd-notif-empty">You're all caught up.</div>
                                {/if}
                            </div>
                            <a class="snbd-popover__foot" href="{$WEB_ROOT}/clientarea.php?action=invoices">View billing overview</a>
                        </div>

                        <div class="snbd-account">
                            <button type="button" class="snbd-account__btn" data-snbd-popover="accountMenuTop" aria-expanded="false" aria-haspopup="true" aria-controls="accountMenuTop" aria-label="Account menu for {$clientsdetails.firstname}">
                                <span class="snbd-avatar snbd-avatar--sm{if $snbdAvatarUrl} snbd-avatar--img{/if}" aria-hidden="true">{if $snbdAvatarUrl}<img src="{$snbdAvatarUrl}" alt="" loading="lazy" referrerpolicy="no-referrer">{else}{if $clientsdetails.firstname}{$clientsdetails.firstname|truncate:1:''}{else}U{/if}{/if}</span>
                                <span class="snbd-account__name">{$clientsdetails.firstname}</span>
                                <i class="ti ti-chevron-down snbd-account__chevron" aria-hidden="true"></i>
                            </button>
                            <div class="snbd-popover" id="accountMenuTop" role="menu" aria-label="Account">
                                <ul class="snbd-menu">
                                    <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="ti ti-user" aria-hidden="true"></i>My details</a></li>
                                    <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=creditcard"><i class="ti ti-credit-card" aria-hidden="true"></i>Payment methods</a></li>
                                    <li><a class="snbd-menu__item" role="menuitem" href="{$WEB_ROOT}/clientarea.php?action=emails"><i class="ti ti-mail" aria-hidden="true"></i>Email history</a></li>
                                    <li><hr class="snbd-menu__divider"></li>
                                    <li><a class="snbd-menu__item snbd-menu__item--danger" role="menuitem" href="{$WEB_ROOT}/logout.php"><i class="ti ti-logout" aria-hidden="true"></i>Sign out</a></li>
                                </ul>
                            </div>
                        </div>
                    {else}
                        <a href="{$WEB_ROOT}/login.php" class="snbd-btn snbd-btn--primary snbd-btn--sm">Sign in</a>
                    {/if}
                </div>
            </header>

            <div class="snbd-content" id="snbd-content">
{/if}
