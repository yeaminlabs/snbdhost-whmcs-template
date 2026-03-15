<!DOCTYPE html>
<!-- SNBD HOST CUSTOM THEME -->
<html lang="en" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>

    {$headoutput}

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
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Custom SNBD Host Theme -->
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/snbdhost-theme.css?v={$smarty.now}" rel="stylesheet">
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
            <div class="snbd-brand">
                <i class="fas fa-server"></i>
                <span class="snbd-nav-text">{$companyname}</span>
            </div>
            <nav class="snbd-nav-menu">
                <div class="nav-section-label">Main</div>
                <a href="clientarea.php" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq ''}active{/if}">
                    <i class="fas fa-gauge-high"></i>
                    <span class="snbd-nav-text">Dashboard</span>
                </a>
                <a href="clientarea.php?action=products" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'products'}active{/if}">
                    <i class="fas fa-cube"></i>
                    <span class="snbd-nav-text">Services</span>
                </a>
                <a href="clientarea.php?action=domains" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'domains'}active{/if}">
                    <i class="fas fa-globe"></i>
                    <span class="snbd-nav-text">Domains</span>
                </a>
                <a href="clientarea.php?action=invoices" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'invoices'}active{/if}">
                    <i class="fas fa-file-invoice-dollar"></i>
                    <span class="snbd-nav-text">Billing</span>
                </a>

                <div class="nav-section-label">Support</div>
                <a href="supporttickets.php" class="snbd-nav-item {if $filename eq 'supporttickets'}active{/if}">
                    <i class="fas fa-life-ring"></i>
                    <span class="snbd-nav-text">Tickets</span>
                </a>
                <a href="knowledgebase.php" class="snbd-nav-item {if $filename eq 'knowledgebase'}active{/if}">
                    <i class="fas fa-book"></i>
                    <span class="snbd-nav-text">Knowledge Base</span>
                </a>
                <a href="serverstatus.php" class="snbd-nav-item {if $filename eq 'serverstatus'}active{/if}">
                    <i class="fas fa-signal"></i>
                    <span class="snbd-nav-text">Network Status</span>
                </a>

                <div class="nav-section-label">Account</div>
                <a href="clientarea.php?action=details" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'details'}active{/if}">
                    <i class="fas fa-user-cog"></i>
                    <span class="snbd-nav-text">My Details</span>
                </a>
                <a href="clientarea.php?action=emails" class="snbd-nav-item {if $filename eq 'clientarea' && $action eq 'emails'}active{/if}">
                    <i class="fas fa-envelope"></i>
                    <span class="snbd-nav-text">Emails</span>
                </a>
                {if $loggedin}
                <a href="logout.php" class="snbd-nav-item">
                    <i class="fas fa-right-from-bracket"></i>
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
                <div class="topbar-left">
                    <button id="sidebar-toggle-btn" class="toggle-sidebar-btn" aria-label="Toggle Sidebar"><i class="fas fa-bars"></i></button>
                </div>
                <form class="topbar-search" action="{$WEB_ROOT}/knowledgebase.php" method="get" role="search">
                    <input type="hidden" name="action" value="knowledgebase">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" placeholder="Search services, tickets..." aria-label="Search" autocomplete="off">
                </form>
                <div class="topbar-right">
                    <a href="clientarea.php?action=details" class="topbar-icon-btn" aria-label="Settings" title="Account Settings">
                        <i class="fas fa-cog"></i>
                    </a>
                    <button class="topbar-icon-btn" aria-label="Notifications">
                        <i class="fas fa-bell"></i>
                    </button>
                </div>
            </header>

            <div class="snbd-content">
{/if}
