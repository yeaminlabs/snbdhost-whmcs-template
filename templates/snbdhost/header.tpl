<!DOCTYPE html>
<!-- SNBD HOST CUSTOM THEME -->
<html lang="en" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    <script>
        var csrfToken = '{$token}',
            markdownGuide = '{lang|addslashes key="markdown.title"}',
            locale = '{if !empty($mdeLocale)}{$mdeLocale}{else}en{/if}',
            saved = '{lang|addslashes key="markdown.saved"}',
            saving = '{lang|addslashes key="markdown.saving"}',
            whmcsBaseUrl = "{$WEB_ROOT}";
        // Force light theme — clear any leftover dark mode preference
        try { localStorage.removeItem('snbd-theme'); } catch(e) {}
    </script>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Tabler Icons CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css">
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Parent Twenty-One Theme CSS (required for cart/store/fallback pages) -->
    <link href="{$WEB_ROOT}/templates/{$template}/css/all.min.css?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/theme.css?v={$versionHash}" rel="stylesheet">
    <link href="{$WEB_ROOT}/templates/{$template}/css/custom.css?v={$versionHash}" rel="stylesheet">

    <!-- Custom SNBD Host Theme (loaded AFTER parent to override) -->
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbdhost-theme.css?v={$smarty.now}" rel="stylesheet">

    <!-- Parent Theme JS (Moved from footer to provide jQuery to orderforms in body) -->
    <script src="{$WEB_ROOT}/templates/{$template}/js/scripts.min.js?v={$versionHash}"></script>
    
    {$headoutput}
</head>
<body data-phone-cc-input="{$phoneNumberInputStyle}">

{$headeroutput}

{if $templatefile == 'login' || $templatefile == 'clientregister' || $templatefile == 'pwreset'}
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
                <a href="{$WEB_ROOT}/clientarea.php" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq ''}active{/if}">
                    <i class="ti ti-layout-dashboard"></i>
                    <span class="snbd-nav-text">Dashboard</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=products" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'products'}active{/if}">
                    <i class="ti ti-server"></i>
                    <span class="snbd-nav-text">Services</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=domains" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'domains'}active{/if}">
                    <i class="ti ti-world"></i>
                    <span class="snbd-nav-text">Domains</span>
                </a>
                <a href="{$WEB_ROOT}/affiliates.php" class="snbd-nav-item {if $filename eq 'affiliates'}active{/if}">
                    <i class="ti ti-users"></i>
                    <span class="snbd-nav-text">Affiliates</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'invoices'}active{/if}">
                    <i class="ti ti-credit-card"></i>
                    <span class="snbd-nav-text">Billing</span>
                </a>

                <div class="nav-section-label">Support</div>
                <a href="{$WEB_ROOT}/supporttickets.php" class="snbd-nav-item {if $filename eq 'supporttickets'}active{/if}">
                    <i class="ti ti-lifebuoy"></i>
                    <span class="snbd-nav-text">Tickets</span>
                </a>
                <a href="{$WEB_ROOT}/knowledgebase.php" class="snbd-nav-item {if $filename eq 'knowledgebase'}active{/if}">
                    <i class="ti ti-book"></i>
                    <span class="snbd-nav-text">Knowledge Base</span>
                </a>
                <a href="{$WEB_ROOT}/serverstatus.php" class="snbd-nav-item {if $filename eq 'serverstatus'}active{/if}">
                    <i class="ti ti-activity"></i>
                    <span class="snbd-nav-text">Network Status</span>
                </a>

                <div class="nav-section-label">Account</div>
                <a href="{$WEB_ROOT}/clientarea.php?action=details" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'details'}active{/if}">
                    <i class="ti ti-settings"></i>
                    <span class="snbd-nav-text">My Details</span>
                </a>
                <a href="{$WEB_ROOT}/clientarea.php?action=emails" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'emails'}active{/if}">
                    <i class="ti ti-mail"></i>
                    <span class="snbd-nav-text">Emails</span>
                </a>
                {if $loggedin}
                <a href="{$WEB_ROOT}/logout.php" class="snbd-nav-item">
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
            <!-- Announcement Bar -->
            <div class="snbd-announcement-bar">
                <div class="announcement-container">
                    <div class="announcement-left">
                        <span class="announcement-badge">NEW</span>
                        <span class="announcement-text">AI-Powered Hosting is here! Deploy, manage & scale smarter than ever.</span>
                    </div>
                    <div class="announcement-right">
                        <a href="{$WEB_ROOT}/index.php?rp=/store" class="announcement-link">View Offers <i class="ti ti-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <header id="snbd-topbar">
                <div class="topbar-left-wrap">
                    <button id="sidebar-toggle-btn" class="toggle-sidebar-btn" aria-label="Toggle Sidebar"><i class="ti ti-menu-2"></i></button>
                    <a href="{$WEB_ROOT}/clientarea.php" class="topbar-logo-link">
                        <img src="{$WEB_ROOT}/templates/{$template}/assets/snbdhost-logo.png" alt="{$companyname}" class="topbar-logo">
                    </a>
                </div>

                <nav class="topbar-nav d-none d-xl-flex">
                    <div class="topbar-nav-item dropdown">
                        <a href="#" class="topbar-nav-link dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Hosting <i class="ti ti-chevron-down"></i></a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/index.php?rp=/store/shared-hosting">Shared Hosting</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/index.php?rp=/store/wordpress-hosting">WordPress Hosting</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/index.php?rp=/store/vps-hosting">VPS Hosting</a></li>
                        </ul>
                    </div>
                    <a href="https://snbdhost.com/n8n-automation" class="topbar-nav-link">N8N Automation</a>
                    <a href="https://snbdhost.com/openclaw" class="topbar-nav-link">OpenClaw</a>
                    <a href="{$WEB_ROOT}/index.php?rp=/store/domain/registration" class="topbar-nav-link">Domain</a>
                    <div class="topbar-nav-item dropdown">
                        <a href="#" class="topbar-nav-link dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Servers <i class="ti ti-chevron-down"></i></a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/index.php?rp=/store/dedicated-servers">Dedicated Servers</a></li>
                            <li><a class="dropdown-item" href="{$WEB_ROOT}/index.php?rp=/store/cloud-servers">Cloud Servers</a></li>
                        </ul>
                    </div>
                    <a href="https://snbdhost.com/blog" class="topbar-nav-link">Blog</a>
                    <a href="{$WEB_ROOT}/submitticket.php" class="topbar-nav-link">Support</a>
                    <a href="https://snbdhost.com/offers" class="topbar-nav-link text-danger fw-bold d-flex align-items-center gap-1">Offers <i class="ti ti-flame text-danger"></i></a>
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

                    <!-- Currency selector (BDT / USD) -->
                    <div class="topbar-currency dropdown">
                        <button class="btn btn-currency dropdown-toggle px-3 py-1" type="button" id="currencyMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            ৳ BDT
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="currencyMenu">
                            <li><a class="dropdown-item" href="#">৳ BDT</a></li>
                            <li><a class="dropdown-item" href="#">$ USD</a></li>
                        </ul>
                    </div>

                    <a href="clientarea.php?action=details" class="topbar-icon-btn" aria-label="Settings" title="Account Settings">
                        <i class="ti ti-settings"></i>
                    </a>
                    
                    <button class="topbar-icon-btn position-relative" aria-label="Notifications">
                        <i class="ti ti-bell"></i>
                    </button>

                    <a href="{$WEB_ROOT}/clientarea.php" class="btn btn-brand btn-topbar-dashboard ms-2 d-none d-md-inline-block">My Dashboard</a>
                </div>
            </header>

            <div class="snbd-content">
{/if}
