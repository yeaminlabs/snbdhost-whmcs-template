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
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbdhost-theme.css?v={$versionHash}" rel="stylesheet">

    <!-- Parent Theme JS (Moved from footer to provide jQuery to orderforms in body) -->
    <script src="{$WEB_ROOT}/templates/{$template}/js/scripts.min.js?v={$versionHash}"></script>
    
    {$headoutput}
    
    {if $templatefile == 'login' || $templatefile == 'clientregister' || $templatefile == 'pwreset' || strpos($templatefile|default:'', 'password-reset') !== false}
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <script src="{$WEB_ROOT}/templates/{$template}/assets/js/google-signin.js?v={$versionHash}"></script>
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

<!-- Skip to main content accessibility landmark -->
<a href="#snbd-main" class="visually-hidden-focusable btn btn-sm btn-brand position-absolute top-0 start-0 m-2" style="z-index: 9999;">Skip to main content</a>

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
                {if $loggedin}
                    <div class="nav-section-label">Main</div>
                    <a href="{$WEB_ROOT}/clientarea.php" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq ''}active{/if}" aria-label="Dashboard">
                        <i class="ti ti-layout-dashboard"></i>
                        <span class="snbd-nav-text">Dashboard</span>
                    </a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=products" class="snbd-nav-item {if $filename eq 'clientarea' && ($action eq 'products' || $action eq 'productdetails' || $action eq 'services')}active{/if}" aria-label="Services">
                        <i class="ti ti-server"></i>
                        <span class="snbd-nav-text">Services</span>
                    </a>
                    {* Collapsible Domains Group *}
                    {assign var="isDomainActive" value=($filename eq 'clientarea' && ($action eq 'domains' || $action eq 'domaindetails')) || ($filename eq 'cart' && ($domain eq 'register' || $domain eq 'transfer' || $action eq 'renew'))}
                    <div class="snbd-nav-group">
                        <a href="#sidebarDomainsCollapse" class="snbd-nav-item d-flex justify-content-between align-items-center {if $isDomainActive}active{/if}" data-bs-toggle="collapse" role="button" aria-expanded="{if $isDomainActive}true{else}false{/if}" aria-controls="sidebarDomainsCollapse" aria-label="Domains">
                            <span class="d-flex align-items-center gap-2">
                                <i class="ti ti-world"></i>
                                <span class="snbd-nav-text">Domains</span>
                            </span>
                            <i class="ti ti-chevron-down snbd-nav-collapse-icon me-2" style="font-size: 0.75rem;"></i>
                        </a>
                        <div class="collapse {if $isDomainActive}show{/if}" id="sidebarDomainsCollapse">
                            <div class="snbd-nav-submenu">
                                <a href="{$WEB_ROOT}/clientarea.php?action=domains" class="snbd-nav-subitem {if $filename eq 'clientarea' && ($action eq 'domains' || $action eq 'domaindetails')}active{/if}">
                                    <i class="ti ti-list"></i> My Domains
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register" class="snbd-nav-subitem {if $filename eq 'cart' && $domain eq 'register'}active{/if}">
                                    <i class="ti ti-plus"></i> Register Domain
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=transfer" class="snbd-nav-subitem {if $filename eq 'cart' && $domain eq 'transfer'}active{/if}">
                                    <i class="ti ti-arrows-left-right"></i> Transfer Domain
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=renew" class="snbd-nav-subitem {if $filename eq 'cart' && $action eq 'renew'}active{/if}">
                                    <i class="ti ti-refresh"></i> Renew Domains
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register#pricing" class="snbd-nav-subitem">
                                    <i class="ti ti-tag"></i> Domain Pricing
                                </a>
                            </div>
                        </div>
                    </div>
                    <a href="{$WEB_ROOT}/affiliates.php" class="snbd-nav-item {if $filename eq 'affiliates'}active{/if}" aria-label="Affiliates">
                        <i class="ti ti-users"></i>
                        <span class="snbd-nav-text">Affiliates</span>
                    </a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="snbd-nav-item {if $filename eq 'clientarea' && ($action eq 'invoices' || $action eq 'quotes')}active{/if}" aria-label="Billing">
                        <i class="ti ti-credit-card"></i>
                        <span class="snbd-nav-text">Billing</span>
                    </a>
     
                    <div class="nav-section-label">Support</div>
                    <a href="{$WEB_ROOT}/supporttickets.php" class="snbd-nav-item {if $filename eq 'supporttickets'}active{/if}" aria-label="Tickets">
                        <i class="ti ti-lifebuoy"></i>
                        <span class="snbd-nav-text">Tickets</span>
                    </a>
                    <a href="https://snbdhost.com/kb" target="_blank" class="snbd-nav-item {if $filename eq 'knowledgebase'}active{/if}" aria-label="Knowledge Base">
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
                    <a href="{$WEB_ROOT}/clientarea.php?action=creditcard" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'creditcard'}active{/if}" aria-label="Payment Methods">
                        <i class="ti ti-credit-card"></i>
                        <span class="snbd-nav-text">Payment Methods</span>
                    </a>
                    <a href="{$WEB_ROOT}/clientarea.php?action=emails" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'emails'}active{/if}" aria-label="Emails">
                        <i class="ti ti-mail"></i>
                        <span class="snbd-nav-text">Emails</span>
                    </a>
                    <a href="{$WEB_ROOT}/logout.php" class="snbd-nav-item text-danger" aria-label="Logout">
                        <i class="ti ti-logout"></i>
                        <span class="snbd-nav-text">Logout</span>
                    </a>
                {else}
                    <div class="nav-section-label">Explore</div>
                    <a href="{$WEB_ROOT}/index.php" class="snbd-nav-item {if $filename eq 'index'}active{/if}" aria-label="Home">
                        <i class="ti ti-home"></i>
                        <span class="snbd-nav-text">Home</span>
                    </a>
                    <a href="{$WEB_ROOT}/cart.php" class="snbd-nav-item {if $filename eq 'cart' && $domain eq ''}active{/if}" aria-label="Store & Services">
                        <i class="ti ti-shopping-cart"></i>
                        <span class="snbd-nav-text">Store &amp; Services</span>
                    </a>
                    {* Collapsible Domains Group (Guest) *}
                    {assign var="isGuestDomainActive" value=($filename eq 'cart' && ($domain eq 'register' || $domain eq 'transfer'))}
                    <div class="snbd-nav-group">
                        <a href="#sidebarGuestDomainsCollapse" class="snbd-nav-item d-flex justify-content-between align-items-center {if $isGuestDomainActive}active{/if}" data-bs-toggle="collapse" role="button" aria-expanded="{if $isGuestDomainActive}true{else}false{/if}" aria-controls="sidebarGuestDomainsCollapse" aria-label="Domains">
                            <span class="d-flex align-items-center gap-2">
                                <i class="ti ti-world"></i>
                                <span class="snbd-nav-text">Domains</span>
                            </span>
                            <i class="ti ti-chevron-down snbd-nav-collapse-icon me-2" style="font-size: 0.75rem;"></i>
                        </a>
                        <div class="collapse {if $isGuestDomainActive}show{/if}" id="sidebarGuestDomainsCollapse">
                            <div class="snbd-nav-submenu">
                                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register" class="snbd-nav-subitem {if $filename eq 'cart' && $domain eq 'register'}active{/if}">
                                    <i class="ti ti-plus"></i> Register Domain
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=transfer" class="snbd-nav-subitem {if $filename eq 'cart' && $domain eq 'transfer'}active{/if}">
                                    <i class="ti ti-arrows-left-right"></i> Transfer Domain
                                </a>
                                <a href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register#pricing" class="snbd-nav-subitem">
                                    <i class="ti ti-tag"></i> Domain Pricing
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="nav-section-label">Support</div>
                    <a href="https://snbdhost.com/kb" target="_blank" class="snbd-nav-item" aria-label="Knowledge Base">
                        <i class="ti ti-book"></i>
                        <span class="snbd-nav-text">Knowledge Base</span>
                    </a>
                    <a href="{$WEB_ROOT}/submitticket.php" class="snbd-nav-item {if $filename eq 'submitticket'}active{/if}" aria-label="Submit Ticket">
                        <i class="ti ti-lifebuoy"></i>
                        <span class="snbd-nav-text">Submit Ticket</span>
                    </a>
                    <a href="{$WEB_ROOT}/serverstatus.php" class="snbd-nav-item {if $filename eq 'serverstatus'}active{/if}" aria-label="Network Status">
                        <i class="ti ti-activity"></i>
                        <span class="snbd-nav-text">Network Status</span>
                    </a>
                    <a href="{$WEB_ROOT}/affiliates.php" class="snbd-nav-item {if $filename eq 'affiliates'}active{/if}" aria-label="Affiliates">
                        <i class="ti ti-users"></i>
                        <span class="snbd-nav-text">Affiliates</span>
                    </a>
                    <div class="nav-section-label">Account</div>
                    <a href="{$WEB_ROOT}/login.php" class="snbd-nav-item" aria-label="Login">
                        <i class="ti ti-login"></i>
                        <span class="snbd-nav-text">Login</span>
                    </a>
                    <a href="{$WEB_ROOT}/register.php" class="snbd-nav-item" aria-label="Register">
                        <i class="ti ti-user-plus"></i>
                        <span class="snbd-nav-text">Register</span>
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
                    <button id="sidebar-toggle-btn" class="toggle-sidebar-btn" aria-label="Toggle Sidebar" aria-expanded="false" aria-controls="snbd-sidebar"><i class="ti ti-menu-2"></i></button>
                    <a href="{if $loggedin}{$WEB_ROOT}/clientarea.php{else}{$WEB_ROOT}/index.php{/if}" class="topbar-logo-link">
                        <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" class="topbar-logo">
                    </a>
                </div>

                <nav class="topbar-nav d-none d-xl-flex">
                    {if $loggedin}
                        <a href="{$WEB_ROOT}/clientarea.php" class="topbar-nav-link {if $filename eq 'clientarea' && $action eq ''}active{/if}">Dashboard</a>
                        <a href="{$WEB_ROOT}/clientarea.php?action=products" class="topbar-nav-link {if $filename eq 'clientarea' && ($action eq 'products' || $action eq 'productdetails' || $action eq 'services')}active{/if}">Services</a>
                        
                        <!-- Logged-in Domains Dropdown -->
                        <div class="topbar-nav-item dropdown">
                            <a href="#" class="topbar-nav-link dropdown-toggle {if $filename eq 'clientarea' && ($action eq 'domains' || $action eq 'domaindetails')}active{/if}" data-bs-toggle="dropdown" aria-expanded="false">
                                Domains <i class="ti ti-chevron-down ms-1" style="font-size: 0.75rem;"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/clientarea.php?action=domains"><i class="ti ti-world text-danger"></i> My Domains</a></li>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register"><i class="ti ti-plus text-secondary"></i> Register a Domain</a></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=transfer"><i class="ti ti-arrows-left-right text-secondary"></i> Transfer a Domain</a></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=renew"><i class="ti ti-refresh text-secondary"></i> Renew Domains</a></li>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register#pricing"><i class="ti ti-tag text-secondary"></i> Domain Pricing</a></li>
                            </ul>
                        </div>

                        <a href="{$WEB_ROOT}/affiliates.php" class="topbar-nav-link {if $filename eq 'affiliates'}active{/if}">Affiliates</a>
                        <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="topbar-nav-link {if $filename eq 'clientarea' && ($action eq 'invoices' || $action eq 'quotes' || $action eq 'transactions')}active{/if}">Billing</a>
                        
                        <div class="topbar-nav-item dropdown">
                            <a href="#" class="topbar-nav-link dropdown-toggle {if $filename eq 'supporttickets' || $filename eq 'knowledgebase' || $filename eq 'serverstatus' || $filename eq 'submitticket'}active{/if}" data-bs-toggle="dropdown" aria-expanded="false">
                                Support <i class="ti ti-chevron-down ms-1" style="font-size: 0.75rem;"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/supporttickets.php"><i class="ti ti-lifebuoy text-danger"></i> Tickets</a></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="https://snbdhost.com/kb" target="_blank"><i class="ti ti-book text-secondary"></i> Knowledge Base</a></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/serverstatus.php"><i class="ti ti-activity text-secondary"></i> Network Status</a></li>
                            </ul>
                        </div>
                    {else}
                        <!-- Logged-Out Topbar Navigation -->
                        <a href="{$WEB_ROOT}/index.php" class="topbar-nav-link {if $filename eq 'index'}active{/if}">Home</a>
                        <a href="{$WEB_ROOT}/cart.php" class="topbar-nav-link {if $filename eq 'cart' && $domain eq ''}active{/if}">Store &amp; Services</a>

                        <!-- Logged-out Domains Dropdown -->
                        <div class="topbar-nav-item dropdown">
                            <a href="#" class="topbar-nav-link dropdown-toggle {if $filename eq 'cart' && ($domain eq 'register' || $domain eq 'transfer')}active{/if}" data-bs-toggle="dropdown" aria-expanded="false">
                                Domains <i class="ti ti-chevron-down ms-1" style="font-size: 0.75rem;"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register"><i class="ti ti-plus text-danger"></i> Register a Domain</a></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=transfer"><i class="ti ti-arrows-left-right text-secondary"></i> Transfer a Domain</a></li>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/cart.php?a=add&amp;domain=register#pricing"><i class="ti ti-tag text-secondary"></i> Domain Pricing</a></li>
                            </ul>
                        </div>

                        <a href="{$WEB_ROOT}/affiliates.php" class="topbar-nav-link {if $filename eq 'affiliates'}active{/if}">Affiliates</a>
                        <a href="{$WEB_ROOT}/serverstatus.php" class="topbar-nav-link {if $filename eq 'serverstatus'}active{/if}">Network Status</a>

                        <div class="topbar-nav-item dropdown">
                            <a href="#" class="topbar-nav-link dropdown-toggle {if $filename eq 'knowledgebase' || $filename eq 'submitticket'}active{/if}" data-bs-toggle="dropdown" aria-expanded="false">
                                Support <i class="ti ti-chevron-down ms-1" style="font-size: 0.75rem;"></i>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="https://snbdhost.com/kb" target="_blank"><i class="ti ti-book text-secondary"></i> Knowledge Base</a></li>
                                <li><a class="dropdown-item d-flex align-items-center gap-2" href="{$WEB_ROOT}/submitticket.php"><i class="ti ti-lifebuoy text-danger"></i> Submit Ticket</a></li>
                            </ul>
                        </div>
                    {/if}
                </nav>

                <div class="topbar-right">
                    <!-- Search Bar (Compact) -->
                    <form class="topbar-search-compact d-none d-md-flex" action="{$WEB_ROOT}/knowledgebase.php" method="get" role="search">
                        <input type="hidden" name="action" value="knowledgebase">
                        <div class="search-input-group position-relative d-flex align-items-center">
                            <i class="ti ti-search"></i>
                            <input type="text" name="search" id="topbarSearchInput" placeholder="Search..." aria-label="Search" autocomplete="off">
                            <kbd class="topbar-search-kbd d-none d-lg-inline-block" style="position: absolute; right: 8px; font-size: 0.68rem; padding: 2px 6px; border-radius: 4px; background: rgba(0,0,0,0.06); color: #777; border: 1px solid rgba(0,0,0,0.1); pointer-events: none;">/</kbd>
                        </div>
                    </form>

                    <!-- Currency selector (Guest only) -->
                    {if !$loggedin && $currencies && $currencies|@count > 1}
                    <div class="topbar-currency dropdown">
                        <button class="btn btn-currency dropdown-toggle" type="button" id="currencyMenu" data-bs-toggle="dropdown" aria-expanded="false" title="Change Currency">
                            <i class="ti ti-coin"></i>
                            <span class="d-none d-sm-inline">{$activeCurrency.code}</span>
                            <i class="ti ti-chevron-down" style="font-size: 0.7rem; opacity: 0.7;"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="currencyMenu">
                            <li class="dropdown-header text-uppercase text-muted" style="font-size: 0.68rem; font-weight: 700; letter-spacing: 0.5px; padding: 0.25rem 1rem;">Select Currency</li>
                            {foreach from=$currencies item=listcurr}
                                <li>
                                    <form method="post" action="{$currentpagelinkback}" class="m-0 p-0">
                                        <input type="hidden" name="currency" value="{$listcurr.id}" />
                                        <button type="submit" class="dropdown-item d-flex align-items-center justify-content-between gap-3 {if $listcurr.id eq $activeCurrency.id}active{/if}" style="cursor:pointer; font-size: 0.8125rem;">
                                            <span>{$listcurr.prefix} {$listcurr.code}</span>
                                            {if $listcurr.id eq $activeCurrency.id}<i class="ti ti-check text-danger" style="font-size: 0.75rem;"></i>{/if}
                                        </button>
                                    </form>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                    {/if}

                    {if $loggedin}
                    <a href="{$WEB_ROOT}/cart.php" class="btn btn-brand btn-topbar-dashboard d-none d-sm-inline-flex align-items-center gap-1.5" aria-label="Order Service">
                        <i class="ti ti-plus" style="font-size: 0.9rem; vertical-align: middle;"></i>
                        <span class="d-none d-md-inline">Order Service</span>
                        <span class="d-inline d-md-none">Order</span>
                    </a>
                    {/if}
                    
                    <button class="topbar-icon-btn position-relative d-none d-md-inline-flex" aria-label="Notifications">
                        <i class="ti ti-bell"></i>
                    </button>

                    <script>
                    {literal}
                    document.addEventListener("DOMContentLoaded", function() {
                        var topbar = document.getElementById('snbd-topbar');
                        if (topbar) {
                            function handleScroll() {
                                if (window.scrollY > 38) {
                                    topbar.style.top = '0px';
                                } else {
                                    topbar.style.top = '38px';
                                }
                            }
                            window.addEventListener('scroll', handleScroll);
                            handleScroll();
                        }
                    });
                    {/literal}
                    </script>

                    {if $loggedin}
                    <div class="topbar-user dropdown">
                        <button class="btn btn-brand dropdown-toggle px-3 py-1 text-white" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="ti ti-user-circle"></i> <span>{$clientsdetails.firstname}</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="userMenu">
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=details"><i class="ti ti-settings me-2"></i>My Details</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=creditcard"><i class="ti ti-credit-card me-2"></i>Payment Methods</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/clientarea.php?action=emails"><i class="ti ti-mail me-2"></i>Email History</a></li>
                            {if $currencies && $currencies|@count > 1}
                            <li><hr class="dropdown-divider"></li>
                            <li class="dropdown-header text-uppercase text-muted" style="font-size: 0.68rem; font-weight: 700; letter-spacing: 0.5px; padding: 0.25rem 1rem;">Currency ({$activeCurrency.code})</li>
                            {foreach from=$currencies item=listcurr}
                                {if $listcurr.id neq $activeCurrency.id}
                                <li>
                                    <form method="post" action="{$currentpagelinkback}" class="m-0 p-0">
                                        <input type="hidden" name="currency" value="{$listcurr.id}" />
                                        <button type="submit" class="dropdown-item d-flex align-items-center gap-2" style="cursor:pointer; font-size: 0.8125rem;">
                                            <i class="ti ti-coin text-secondary"></i> Switch to {$listcurr.prefix} {$listcurr.code}
                                        </button>
                                    </form>
                                </li>
                                {/if}
                            {/foreach}
                            {/if}
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="{$WEB_ROOT}/logout.php"><i class="ti ti-logout me-2"></i>Logout</a></li>
                        </ul>
                    </div>
                    {else}
                    <div class="d-flex align-items-center gap-2">
                        <a href="{$WEB_ROOT}/login.php" class="btn btn-outline-secondary btn-sm px-3 py-1.5 fw-semibold" style="border-radius: 8px;">Login</a>
                        <a href="{$WEB_ROOT}/register.php" class="btn btn-brand btn-sm px-3 py-1.5 fw-semibold" style="border-radius: 8px;">Register</a>
                    </div>
                    {/if}
                </div>
            </header>

            <div class="snbd-content">
{/if}
