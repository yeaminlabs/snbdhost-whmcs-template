<!DOCTYPE html>
<!-- SNBD HOST CUSTOM THEME -->
<html lang="en" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <script>
        {literal}
        var csrfToken = '{/literal}{$token}{literal}',
            markdownGuide = '{/literal}{lang key="markdown.title"}{literal}',
            locale = '{/literal}{if !empty($mdeLocale)}{$mdeLocale}{else}en{/if}{literal}',
            saved = '{/literal}{lang key="markdown.saved"}{literal}',
            saving = '{/literal}{lang key="markdown.saving"}{literal}',
            whmcsBaseUrl = "{/literal}{$WEB_ROOT}{literal}";
            
        // Check and apply saved theme preference instantly to prevent flash
        (function() {
            var savedTheme = localStorage.getItem('snbd-theme');
            if (savedTheme === 'dark') {
                document.documentElement.setAttribute('data-theme', 'dark');
            } else if (savedTheme === 'light') {
                document.documentElement.setAttribute('data-theme', 'light');
            } else {
                var prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                document.documentElement.setAttribute('data-theme', prefersDark ? 'dark' : 'light');
            }
        })();
        {/literal}
    </script>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts Preconnect & Combined Load -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- FontAwesome (Asynchronous) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></noscript>
    <!-- Tabler Icons CSS (Asynchronous) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css"></noscript>

    <!-- Parent Twenty-One Theme CSS (required for cart/store/fallback pages) -->
    <link href="{$WEB_ROOT}/templates/{$template}/css/all.min.css?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/theme.css?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v={$versionHash}" rel="stylesheet">

    <!-- Custom SNBD Host Theme (loaded AFTER parent to override) -->
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbdhost-theme.css?v={$smarty.now}" rel="stylesheet">

    <!-- Parent Theme JS (Moved from footer to provide jQuery to orderforms in body) -->
    <script src="{$WEB_ROOT}/templates/{$template}/js/scripts.min.js?v={$versionHash}"></script>
    
    {$headoutput}
    
    {if $templatefile == 'login' || $templatefile == 'clientregister'}
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
<body data-phone-cc-input="{$phoneNumberInputStyle}">
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-N675SJK"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

{$headeroutput}

{if $templatefile == 'login' || $templatefile == 'clientregister' || $templatefile == 'pwreset' || strpos($templatefile|default:'', 'password-reset') !== false}
    <div id="particles-js"></div>
    <div class="auth-page">
{else}
    <!-- Mobile sidebar backdrop -->
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <div id="snbd-wrapper">
        <aside id="snbd-sidebar">
            <script>
                if (localStorage.getItem('snbd-sidebar-collapsed') === 'true' && window.innerWidth > 768) {
                    document.getElementById('snbd-sidebar').classList.add('collapsed');
                }
            </script>
            <div class="snbd-brand-logo-container">
                <a href="{$WEB_ROOT}/clientarea.php" class="d-flex align-items-center text-decoration-none">
                    <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" class="snbd-brand-logo">
                </a>
            </div>
            <nav class="snbd-nav-menu">
                <div class="nav-section-label">Main</div>
                <a href="{$WEB_ROOT}/clientarea.php" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq ''}active{/if}" aria-label="Dashboard">
                    <i class="ti ti-layout-dashboard"></i>
                    <span class="snbd-nav-text">Dashboard</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=products" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'products'}active{/if}" aria-label="Services">
                    <i class="ti ti-server"></i>
                    <span class="snbd-nav-text">Services</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=domains" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'domains'}active{/if}" aria-label="Domains">
                    <i class="ti ti-world"></i>
                    <span class="snbd-nav-text">Domains</span>
                </a>
                <a href="{$WEB_ROOT}/affiliates.php" class="snbd-nav-item {if $filename eq 'affiliates'}active{/if}" aria-label="Affiliates">
                    <i class="ti ti-users"></i>
                    <span class="snbd-nav-text">Affiliates</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'invoices'}active{/if}" aria-label="Billing">
                    <i class="ti ti-credit-card"></i>
                    <span class="snbd-nav-text">Billing</span>
                </a>
 
                <div class="nav-section-label">Support</div>
                <a href="{$WEB_ROOT}/supporttickets.php" class="snbd-nav-item {if $filename eq 'supporttickets'}active{/if}" aria-label="Tickets">
                    <i class="ti ti-lifebuoy"></i>
                    <span class="snbd-nav-text">Tickets</span>
                </a>
                <a href="{$WEB_ROOT}/knowledgebase.php" class="snbd-nav-item {if $filename eq 'knowledgebase'}active{/if}" aria-label="Knowledge Base">
                    <i class="ti ti-book"></i>
                    <span class="snbd-nav-text">Knowledge Base</span>
                </a>
                <a href="{$WEB_ROOT}/serverstatus.php" class="snbd-nav-item {if $filename eq 'serverstatus'}active{/if}" aria-label="Network Status">
                    <i class="ti ti-activity"></i>
                    <span class="snbd-nav-text">Network Status</span>
                </a>
 
                <div class="nav-section-label">Account</div>
                <a href="{$WEB_ROOT}/clientarea.php?action=details" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'details'}active{/if}" aria-label="My Details">
                    <i class="ti ti-settings"></i>
                    <span class="snbd-nav-text">My Details</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=emails" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'emails'}active{/if}" aria-label="Emails">
                    <i class="ti ti-mail"></i>
                    <span class="snbd-nav-text">Emails</span>
                </a>
                {if $loggedin}
                <a href="{$WEB_ROOT}/logout.php" class="snbd-nav-item" aria-label="Logout">
                    <i class="ti ti-logout"></i>
                    <span class="snbd-nav-text">Logout</span>
                </a>
                {/if}
            </nav>
            {if $loggedin}
            <div class="snbd-user-profile">
                <div class="user-avatar">{if $clientsdetails.firstname}{$clientsdetails.firstname|truncate:1:""}{else}U{/if}</div>
                <div class="user-info">
                    <span class="user-name">{$clientsdetails.firstname} {$clientsdetails.lastname}</span>
                    <span class="user-email">{$clientsdetails.email}</span>
                </div>
            </div>
            {/if}
        </aside>

        <main id="snbd-main">

            <header id="snbd-topbar">
                <div class="topbar-left-wrap">
                    <button id="sidebar-toggle-btn" class="toggle-sidebar-btn" aria-label="Toggle Sidebar"><i class="ti ti-menu-2"></i></button>
                    <a href="{$WEB_ROOT}/clientarea.php" class="topbar-logo-link">
                        <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" class="topbar-logo">
                    </a>
                </div>

                <nav class="topbar-nav d-none d-xl-flex">
                    <a href="{$WEB_ROOT}/clientarea.php" class="topbar-nav-link {if $filename eq 'clientarea' && $action eq ''}active{/if}">Dashboard</a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=products" class="topbar-nav-link {if $filename eq 'clientarea' && ($action eq 'products' || $action eq 'productdetails' || $action eq 'services')}active{/if}">Services</a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=domains" class="topbar-nav-link {if $filename eq 'clientarea' && ($action eq 'domains' || $action eq 'domaindetails')}active{/if}">Domains</a>
                    <a href="{$WEB_ROOT}/affiliates.php" class="topbar-nav-link {if $filename eq 'affiliates'}active{/if}">Affiliates</a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="topbar-nav-link {if $filename eq 'clientarea' && ($action eq 'invoices' || $action eq 'quotes' || $action eq 'transactions')}active{/if}">Billing</a>
                    
                    <div class="topbar-nav-item dropdown">
                        <a href="#" class="topbar-nav-link dropdown-toggle {if $filename eq 'supporttickets' || $filename eq 'knowledgebase' || $filename eq 'serverstatus'}active{/if}" data-bs-toggle="dropdown" aria-expanded="false">Support <i class="ti ti-chevron-down"></i></a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/supporttickets.php"><i class="ti ti-lifebuoy me-2"></i>Tickets</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/knowledgebase.php"><i class="ti ti-book me-2"></i>Knowledge Base</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/serverstatus.php"><i class="ti ti-activity me-2"></i>Network Status</a></li>
                        </ul>
                    </div>
                </nav>

                <div class="topbar-right">
                    <!-- Search Bar (Compact) -->
                    <form class="topbar-search-compact d-none d-md-flex" action="{$WEB_ROOT}/knowledgebase.php" method="get" role="search">
                        <input type="hidden" name="action" value="knowledgebase">
                        <div class="search-input-group">
                            <i class="ti ti-search"></i>
                            <input type="text" name="search" placeholder="Search..." aria-label="Search" autocomplete="off">
                        </div>
                    </form>

                    <!-- Currency selector -->
                    {if !$loggedin && $currencies}
                    <div class="topbar-currency dropdown">
                        <button class="btn btn-currency dropdown-toggle px-3 py-1" type="button" id="currencyMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            {$activeCurrency.prefix} {$activeCurrency.code}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="currencyMenu">
                            {foreach from=$currencies item=listcurr}
                                <li>
                                    <form method="post" action="{$currentpagelinkback}" class="m-0 p-0">
                                        <input type="hidden" name="currency" value="{$listcurr.id}" />
                                        <button type="submit" class="dropdown-item" style="cursor:pointer;">{$listcurr.prefix} {$listcurr.code}</button>
                                    </form>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                    {/if}

                    {if $loggedin}
                    <a href="{$WEB_ROOT}/cart.php" class="btn btn-brand btn-topbar-dashboard d-none d-sm-inline-flex align-items-center gap-1" style="font-size: 0.8rem; padding: 0.4rem 1rem; border-radius: 8px; font-weight: 600; text-decoration: none; margin-right: 0.5rem;">
                        <i class="ti ti-plus" style="font-size: 0.9rem; vertical-align: middle;"></i> Order Service
                    </a>
                    <a href="clientarea.php?action=details" class="topbar-icon-btn d-none d-md-inline-flex" aria-label="Settings" title="Account Settings">
                        <i class="ti ti-settings"></i>
                    </a>
                    {/if}
                    
                    <button class="topbar-icon-btn position-relative d-none d-md-inline-flex" aria-label="Notifications">
                        <i class="ti ti-bell"></i>
                    </button>

                    <button id="theme-toggle-btn" class="topbar-icon-btn ms-2" aria-label="Toggle Color Theme" title="Toggle Light/Dark Mode">
                        <i class="ti ti-sun d-none-theme-dark"></i>
                        <i class="ti ti-moon d-none-theme-light"></i>
                    </button>
                    <script>
                    {literal}
                    document.addEventListener("DOMContentLoaded", function() {
                        var btn = document.getElementById('theme-toggle-btn');
                        if (btn) {
                            btn.addEventListener('click', function() {
                                var current = document.documentElement.getAttribute('data-theme') || 'light';
                                var target = current === 'dark' ? 'light' : 'dark';
                                document.documentElement.setAttribute('data-theme', target);
                                localStorage.setItem('snbd-theme', target);
                            });
                        }
                    });
                    {/literal}
                    </script>

                    {if $loggedin}
                    <div class="topbar-user dropdown ms-2">
                        <button class="btn btn-brand dropdown-toggle px-3 py-1 text-white" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="ti ti-user-circle"></i> {$clientsdetails.firstname}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="ti ti-settings me-2"></i>My Details</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=emails"><i class="ti ti-mail me-2"></i>Email History</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="{$WEB_ROOT}/logout.php"><i class="ti ti-logout me-2"></i>Logout</a></li>
                        </ul>
                    </div>
                    {else}
                    <a href="{$WEB_ROOT}/login.php" class="btn btn-brand btn-topbar-dashboard ms-2">Login</a>
                    {/if}
                </div>
            </header>

            <div class="snbd-content">
{/if}
