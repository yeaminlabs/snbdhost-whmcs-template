<?php
/**
 * SNBDHost Theme Manager Addon Module — Redesigned
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

function snbdhost_manager_config()
{
    return [
        'name'        => 'SNBDHost Theme Manager',
        'description' => 'Manages the SNBDHost WHMCS Theme, one-click updates from GitHub, managed external modules installer, and portal configuration tools.',
        'author'      => 'SNBDHost',
        'language'    => 'english',
        'version'     => '2.0',
        'fields'      => [
            'github_repo' => [
                'FriendlyName' => 'GitHub Repository',
                'Type'         => 'text',
                'Size'         => '50',
                'Default'      => 'username/repo',
                'Description'  => 'The GitHub repository in the format "username/repo" (e.g., "snbdhost/theme").',
            ],
            'github_token' => [
                'FriendlyName' => 'GitHub Token (Optional)',
                'Type'         => 'password',
                'Size'         => '50',
                'Default'      => '',
                'Description'  => 'Required if the repository is private. Create a Personal Access Token with repo access.',
            ],
            'bug_report_url' => [
                'FriendlyName' => 'Report Bug URL',
                'Type'         => 'text',
                'Size'         => '50',
                'Default'      => 'https://github.com/username/repo/issues',
                'Description'  => 'The URL where users will be redirected to report a bug from the admin dashboard.',
            ],
            'uptimerobot_api_key' => [
                'FriendlyName' => 'UptimeRobot API Key',
                'Type'         => 'text',
                'Size'         => '50',
                'Default'      => '',
                'Description'  => 'Your UptimeRobot Read-Only API key. Used to display server status on the client portal Network Status page.',
            ],
            'google_client_id' => [
                'FriendlyName' => 'Google Client ID',
                'Type'         => 'text',
                'Size'         => '80',
                'Default'      => '219815663641-p50rq613ol3ilqgbotogg4bb4hvg9s1e.apps.googleusercontent.com',
                'Description'  => 'Your Google OAuth 2.0 Client ID for enabling "Sign in with Google" on the login/register pages.',
            ],
            'developer_mode' => [
                'FriendlyName' => 'Developer Mode',
                'Type'         => 'yesno',
                'Description'  => 'Tick to enable Developer Mode. This hides reports, shows a developer alert message on the dashboards, and disables the theme modification check.',
            ],
        ]
    ];
}

function snbdhost_manager_activate()
{
    try {
        if (!Capsule::schema()->hasTable('mod_snbd_migrations')) {
            Capsule::schema()->create('mod_snbd_migrations', function ($table) {
                $table->increments('id');
                $table->integer('user_id')->default(0);
                $table->string('previous_provider', 255)->nullable();
                $table->string('website_url', 255)->nullable();
                $table->string('cms', 100)->nullable();
                $table->string('is_web_app', 100)->nullable();
                $table->string('hosting_required', 100)->nullable();
                $table->string('existing_username', 100)->nullable();
                $table->string('target_package', 255)->nullable();
                $table->timestamps();
            });
        }
    } catch (\Exception $e) {
        return [
            'status'      => 'error',
            'description' => 'Could not activate module. Database table creation failed: ' . $e->getMessage()
        ];
    }

    return [
        'status'      => 'success',
        'description' => 'SNBDHost Theme Manager has been successfully activated.'
    ];
}

function snbdhost_manager_deactivate()
{
    return [
        'status'      => 'success',
        'description' => 'SNBDHost Theme Manager has been successfully deactivated.'
    ];
}

function snbdhost_manager_output($vars)
{
    $modulelink        = $vars['modulelink'];
    $githubRepo        = $vars['github_repo'];
    $githubToken       = $vars['github_token'];
    $uptimerobotApiKey = $vars['uptimerobot_api_key'] ?? '';

    // ----------------------------------------------------------------
    //  Sync UptimeRobot config file
    // ----------------------------------------------------------------
    $configFile    = __DIR__ . '/uptimerobot_config.json';
    $currentConfig = [];
    if (file_exists($configFile)) {
        $currentConfig = json_decode(file_get_contents($configFile), true) ?: [];
    }
    if (($currentConfig['api_key'] ?? '') !== $uptimerobotApiKey || !file_exists(__DIR__ . '/../../../network-status.json')) {
        file_put_contents($configFile, json_encode(['api_key' => $uptimerobotApiKey], JSON_PRETTY_PRINT));
        if (!empty($uptimerobotApiKey)) {
            $ch = curl_init('https://api.uptimerobot.com/v2/getMonitors');
            curl_setopt_array($ch, [
                CURLOPT_POST           => true,
                CURLOPT_POSTFIELDS     => http_build_query([
                    'api_key'               => $uptimerobotApiKey,
                    'format'                => 'json',
                    'logs'                  => '0',
                    'response_times'        => '1',
                    'response_times_limit'  => '10',
                    'custom_uptime_ratios'  => '30',
                    'all_time_uptime_ratio' => '1',
                ]),
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT        => 15,
                CURLOPT_CONNECTTIMEOUT => 10,
                CURLOPT_HTTPHEADER     => ['Content-Type: application/x-www-form-urlencoded', 'Accept: application/json'],
            ]);
            $resp = curl_exec($ch);
            curl_close($ch);
            if ($resp !== false) {
                $decoded = json_decode($resp, true);
                if (isset($decoded['stat']) && $decoded['stat'] === 'ok') {
                    $decoded['last_updated_timestamp'] = time();
                    @file_put_contents(__DIR__ . '/../../../network-status.json', json_encode($decoded));
                }
            }
        }
    }

    // ----------------------------------------------------------------
    //  Load helpers
    // ----------------------------------------------------------------
    require_once __DIR__ . '/lib/ModuleManager.php';
    $moduleManager = new \SNBDHostManager\ModuleManager();

    // ----------------------------------------------------------------
    //  Action handling
    // ----------------------------------------------------------------
    $action     = isset($_GET['action']) ? $_GET['action'] : '';
    $updateType = isset($_GET['type'])   ? $_GET['type']   : 'all';
    $message    = '';

    // --- Theme / module update ---
    if ($action === 'update_theme') {
        require_once __DIR__ . '/lib/Updater.php';
        $updater = new \SNBDHostManager\Updater($githubRepo, $githubToken);
        try {
            $updater->updateTheme($updateType);
            $targetName = $updateType === 'theme' ? 'Theme' : ($updateType === 'module' ? 'Manager Module' : 'Theme and Module');
            $message = snbdmgr_alert('success', '<i class="fas fa-check-circle me-2"></i><strong>Updated!</strong> ' . $targetName . ' successfully updated to the latest version.');
        } catch (\Exception $e) {
            $message = snbdmgr_alert('danger', '<i class="fas fa-times-circle me-2"></i><strong>Error:</strong> ' . $e->getMessage());
        }
    }

    // --- Dashboard notification override ---
    if ($action === 'save_bugs') {
        $customData = [
            'reported_bug' => strip_tags($_POST['reported_bug'] ?? ''),
            'fixed_bug'    => strip_tags($_POST['fixed_bug']    ?? ''),
            'reporter'     => strip_tags($_POST['reporter']     ?? ''),
        ];
        file_put_contents(__DIR__ . '/custom_bugs.json', json_encode($customData));
        $message = snbdmgr_alert('success', '<i class="fas fa-check-circle me-2"></i> Dashboard notification data saved.');
    }

    // --- Client banner save ---
    if ($action === 'save_client_banner') {
        $bannerData = [
            'enabled'    => isset($_POST['banner_enabled']) ? '1' : '0',
            'title'      => strip_tags($_POST['banner_title']     ?? ''),
            'desc'       => strip_tags($_POST['banner_desc']      ?? ''),
            'link'       => strip_tags($_POST['banner_link']      ?? ''),
            'link_text'  => strip_tags($_POST['banner_link_text'] ?? ''),
        ];
        file_put_contents(__DIR__ . '/client_banner.json', json_encode($bannerData));
        $message = snbdmgr_alert('success', '<i class="fas fa-check-circle me-2"></i> Client banner settings saved.');
    }

    // --- UptimeRobot test (AJAX) ---
    if ($action === 'test_uptimerobot') {
        $testKey    = trim($_POST['api_key'] ?? $uptimerobotApiKey);
        $testResult = [];
        if (empty($testKey)) {
            $testResult = ['success' => false, 'message' => 'No API key provided.'];
        } else {
            $ch = curl_init('https://api.uptimerobot.com/v2/getMonitors');
            curl_setopt_array($ch, [
                CURLOPT_POST           => true,
                CURLOPT_POSTFIELDS     => http_build_query(['api_key' => $testKey, 'format' => 'json', 'logs' => '0']),
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT        => 15,
                CURLOPT_SSL_VERIFYPEER => true,
                CURLOPT_HTTPHEADER     => ['Content-Type: application/x-www-form-urlencoded'],
            ]);
            $resp     = curl_exec($ch);
            $err      = curl_error($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if ($resp === false) {
                $testResult = ['success' => false, 'message' => 'cURL error: ' . $err];
            } elseif ($httpCode !== 200) {
                $testResult = ['success' => false, 'message' => 'HTTP ' . $httpCode . ' from UptimeRobot.'];
            } else {
                $data = json_decode($resp, true);
                if (isset($data['stat']) && $data['stat'] === 'ok') {
                    $count = count($data['monitors'] ?? []);
                    $data['last_updated_timestamp'] = time();
                    @file_put_contents(__DIR__ . '/../../../network-status.json', json_encode($data));
                    $testResult = ['success' => true, 'message' => 'Connection successful! Found ' . $count . ' monitor(s). Cache updated.'];
                } else {
                    $testResult = ['success' => false, 'message' => $data['error']['message'] ?? 'Unknown error from UptimeRobot.'];
                }
            }
        }
        header('Content-Type: application/json');
        echo json_encode($testResult);
        exit;
    }

    // --- Add managed module ---
    if ($action === 'add_module') {
        $repo = trim($_POST['mod_repo'] ?? '');
        // Auto-derive install path: modules/addons/{repo-name}
        $repoName = basename($repo);
        $entry = [
            'name'         => strip_tags(trim($_POST['mod_name']        ?? '')),
            'repo'         => $repo,
            'token'        => trim($_POST['mod_token']       ?? ''),
            'branch'       => trim($_POST['mod_branch']      ?? 'main') ?: 'main',
            'install_path' => 'modules/addons/' . $repoName,
            'extract_mode' => 'contents',
            'description'  => strip_tags(trim($_POST['mod_description'] ?? '')),
        ];
        if (empty($entry['name']) || empty($repo)) {
            $message = snbdmgr_alert('danger', '<i class="fas fa-exclamation-circle me-2"></i> Module Name and GitHub Repo are required.');
        } else {
            $moduleManager->addModule($entry);
            $message = snbdmgr_alert('success', '<i class="fas fa-check-circle me-2"></i> Module <strong>' . htmlspecialchars($entry['name']) . '</strong> added — will install to <code>modules/addons/' . htmlspecialchars($repoName) . '</code>.');
        }
    }

    // --- Edit managed module ---
    if ($action === 'edit_module') {
        $id = trim($_POST['mod_id'] ?? '');
        if ($id) {
            $repo = trim($_POST['mod_repo'] ?? '');
            $repoName = basename($repo);
            $data = [
                'name'         => strip_tags(trim($_POST['mod_name']        ?? '')),
                'repo'         => $repo,
                'token'        => trim($_POST['mod_token']       ?? ''),
                'branch'       => trim($_POST['mod_branch']      ?? 'main') ?: 'main',
                'install_path' => 'modules/addons/' . $repoName,
                'extract_mode' => 'contents',
                'description'  => strip_tags(trim($_POST['mod_description'] ?? '')),
            ];
            $moduleManager->updateModuleEntry($id, $data);
            $message = snbdmgr_alert('success', '<i class="fas fa-check-circle me-2"></i> Module updated.');
        }
    }

    // --- Delete managed module ---
    if ($action === 'delete_module') {
        $id = trim($_GET['module_id'] ?? '');
        if ($id) {
            $mod = $moduleManager->getModule($id);
            $moduleManager->deleteModule($id);
            $message = snbdmgr_alert('warning', '<i class="fas fa-trash me-2"></i> Module <strong>' . htmlspecialchars($mod['name'] ?? $id) . '</strong> removed.');
        }
    }

    // --- Install / Update a managed module ---
    if ($action === 'install_module' || $action === 'update_module') {
        $id = trim($_GET['module_id'] ?? '');
        if ($id) {
            try {
                $result  = $moduleManager->installOrUpdate($id);
                $message = snbdmgr_alert('success', '<i class="fas fa-check-circle me-2"></i> ' . $result);
            } catch (\Exception $e) {
                $message = snbdmgr_alert('danger', '<i class="fas fa-times-circle me-2"></i><strong>Error:</strong> ' . $e->getMessage());
            }
        }
    }

    // ----------------------------------------------------------------
    //  Load view data
    // ----------------------------------------------------------------
    $customBugs = ['reported_bug' => '', 'fixed_bug' => '', 'reporter' => ''];
    if (file_exists(__DIR__ . '/custom_bugs.json')) {
        $cb = json_decode(file_get_contents(__DIR__ . '/custom_bugs.json'), true);
        if (is_array($cb)) $customBugs = $cb;
    }

    $bannerData = ['enabled' => '1', 'title' => '', 'desc' => '', 'link' => '', 'link_text' => ''];
    if (file_exists(__DIR__ . '/client_banner.json')) {
        $bd = json_decode(file_get_contents(__DIR__ . '/client_banner.json'), true);
        if (is_array($bd)) $bannerData = $bd;
    }

    $managedModules = $moduleManager->loadModules();

    // Determine active tab from GET param (preserve after post-redirect)
    $activeTab = isset($_GET['tab']) ? $_GET['tab'] : 'overview';
    $validTabs = ['overview', 'modules', 'notifications', 'banner', 'uptimerobot'];
    if (!in_array($activeTab, $validTabs)) $activeTab = 'overview';

    // ----------------------------------------------------------------
    //  Output HTML
    // ----------------------------------------------------------------
    echo $message;
    ?>
    <!-- ====================================================
         SNBDHost Manager — Premium Redesign
    ===================================================== -->
    <style>
        :root {
            --brand:       #CC0000;
            --brand-dark:  #990000;
            --brand-light: rgba(204,0,0,0.08);
            --card-bg:     #ffffff;
            --card-border: #eaeaea;
            --surface:     #f8f8f8;
            --text:        #1a1a1a;
            --muted:       #6b7280;
            --success:     #10b981;
            --warning:     #f59e0b;
            --info:        #3b82f6;
            --radius:      14px;
            --shadow:      0 4px 20px rgba(0,0,0,0.07);
            --transition:  all 0.22s cubic-bezier(0.4,0,0.2,1);
        }

        /* ---------- Layout ---------- */
        #snbdmgr-wrap {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            color: var(--text);
        }

        /* ---------- Top bar ---------- */
        .snbdmgr-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            padding: 18px 24px;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d1010 100%);
            border-radius: var(--radius);
            margin-bottom: 24px;
            color: #fff;
        }
        .snbdmgr-topbar .brand {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .snbdmgr-topbar .brand-icon {
            width: 46px; height: 46px;
            background: var(--brand);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            box-shadow: 0 4px 12px rgba(204,0,0,0.35);
        }
        .snbdmgr-topbar h1 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0;
            color: #fff;
        }
        .snbdmgr-topbar .sub {
            font-size: 0.78rem;
            color: rgba(255,255,255,0.55);
            margin-top: 2px;
        }
        .snbdmgr-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 50rem;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }
        .snbdmgr-badge.brand   { background: var(--brand);   color: #fff; }
        .snbdmgr-badge.dark    { background: rgba(255,255,255,0.12); color: #fff; }
        .snbdmgr-badge.warning { background: #f59e0b; color: #fff; }

        /* ---------- Tabs ---------- */
        .snbdmgr-tabs {
            display: flex;
            gap: 4px;
            background: #f0f0f0;
            border-radius: 12px;
            padding: 5px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .snbdmgr-tab {
            flex: 1;
            min-width: 110px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 10px 16px;
            border-radius: 9px;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--muted);
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            border: none;
            background: transparent;
            white-space: nowrap;
        }
        .snbdmgr-tab:hover {
            color: var(--text);
            background: rgba(0,0,0,0.04);
            text-decoration: none;
        }
        .snbdmgr-tab.active {
            background: #fff;
            color: var(--brand);
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .snbdmgr-tab.active i { color: var(--brand); }

        /* ---------- Tab panels ---------- */
        .snbdmgr-panel { display: none; }
        .snbdmgr-panel.active { display: block; }

        /* ---------- Cards ---------- */
        .snbdmgr-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 20px;
        }
        .snbdmgr-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 22px;
            border-bottom: 1px solid var(--card-border);
            font-weight: 700;
            font-size: 0.93rem;
            background: #fafafa;
        }
        .snbdmgr-card-header .header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .snbdmgr-card-header .header-icon {
            width: 32px; height: 32px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.9rem;
        }
        .snbdmgr-card-header .header-icon.red    { background: var(--brand-light); color: var(--brand); }
        .snbdmgr-card-header .header-icon.dark   { background: #1a1a1a; color: #fff; }
        .snbdmgr-card-header .header-icon.blue   { background: #eff6ff; color: var(--info); }
        .snbdmgr-card-header .header-icon.green  { background: #ecfdf5; color: var(--success); }
        .snbdmgr-card-header .header-icon.yellow { background: #fffbeb; color: var(--warning); }
        .snbdmgr-card-body { padding: 22px; }

        /* ---------- Buttons ---------- */
        .snbdmgr-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 9px 18px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.82rem;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            text-decoration: none;
            white-space: nowrap;
        }
        .snbdmgr-btn:hover { opacity: 0.88; text-decoration: none; }
        .snbdmgr-btn.primary     { background: var(--brand);   color: #fff; box-shadow: 0 4px 12px rgba(204,0,0,0.22); }
        .snbdmgr-btn.dark        { background: #1a1a1a;        color: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.2); }
        .snbdmgr-btn.success     { background: var(--success); color: #fff; box-shadow: 0 4px 12px rgba(16,185,129,0.22); }
        .snbdmgr-btn.warning     { background: var(--warning); color: #fff; box-shadow: 0 4px 12px rgba(245,158,11,0.22); }
        .snbdmgr-btn.info        { background: var(--info);    color: #fff; box-shadow: 0 4px 12px rgba(59,130,246,0.22); }
        .snbdmgr-btn.danger      { background: #ef4444;        color: #fff; }
        .snbdmgr-btn.ghost       { background: transparent; color: var(--muted); border: 1px solid var(--card-border); }
        .snbdmgr-btn.ghost:hover { background: var(--surface); color: var(--text); }
        .snbdmgr-btn.sm { padding: 6px 12px; font-size: 0.77rem; border-radius: 6px; }
        .snbdmgr-btn.w100 { width: 100%; }

        /* ---------- Form controls ---------- */
        .snbdmgr-form-group { margin-bottom: 18px; }
        .snbdmgr-label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        .snbdmgr-label .req { color: var(--brand); }
        .snbdmgr-input, .snbdmgr-select, .snbdmgr-textarea {
            width: 100%;
            padding: 10px 13px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.85rem;
            color: var(--text);
            background: #fff;
            transition: var(--transition);
            box-sizing: border-box;
        }
        .snbdmgr-input:focus, .snbdmgr-select:focus, .snbdmgr-textarea:focus {
            border-color: var(--brand);
            outline: none;
            box-shadow: 0 0 0 3px rgba(204,0,0,0.1);
        }
        .snbdmgr-textarea { resize: vertical; min-height: 90px; }

        /* ---------- Update action cards ---------- */
        .snbdmgr-update-card {
            border: 1px solid var(--card-border);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: var(--transition);
            background: #fff;
        }
        .snbdmgr-update-card:hover { border-color: var(--brand); box-shadow: 0 0 0 3px rgba(204,0,0,0.06); }
        .snbdmgr-update-card .update-icon {
            width: 48px; height: 48px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .snbdmgr-update-card .update-title  { font-size: 0.95rem; font-weight: 700; margin-bottom: 3px; }
        .snbdmgr-update-card .update-desc   { font-size: 0.78rem; color: var(--muted); }
        .snbdmgr-update-card .update-action { margin-left: auto; flex-shrink: 0; }

        /* ---------- Repo info strip ---------- */
        .snbdmgr-repo-strip {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            font-size: 0.82rem;
            color: var(--muted);
            margin-bottom: 20px;
        }
        .snbdmgr-repo-strip code {
            font-size: 0.82rem;
            color: var(--brand);
            background: var(--brand-light);
            padding: 2px 8px;
            border-radius: 5px;
        }

        /* ---------- Modules table ---------- */
        .snbdmgr-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.83rem;
        }
        .snbdmgr-table th {
            text-align: left;
            padding: 12px 14px;
            font-size: 0.73rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--muted);
            border-bottom: 1px solid var(--card-border);
            background: #fafafa;
        }
        .snbdmgr-table td {
            padding: 14px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }
        .snbdmgr-table tr:last-child td { border-bottom: none; }
        .snbdmgr-table tr:hover td { background: #fafafa; }
        .snbdmgr-table .mod-name { font-weight: 700; color: var(--text); }
        .snbdmgr-table .mod-repo { color: var(--brand); font-family: monospace; font-size: 0.8rem; }
        .snbdmgr-table .mod-path { color: var(--muted); font-family: monospace; font-size: 0.78rem; }

        .snbdmgr-status-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 9px;
            border-radius: 50rem;
            font-size: 0.72rem;
            font-weight: 700;
        }
        .snbdmgr-status-pill.installed    { background: #ecfdf5; color: #059669; }
        .snbdmgr-status-pill.not_installed{ background: #f3f4f6; color: #6b7280; }
        .snbdmgr-status-pill.error        { background: #fef2f2; color: #dc2626; }

        /* ---------- Empty state ---------- */
        .snbdmgr-empty {
            text-align: center;
            padding: 50px 20px;
            color: var(--muted);
        }
        .snbdmgr-empty .empty-icon { font-size: 2.5rem; margin-bottom: 12px; opacity: 0.3; }
        .snbdmgr-empty p { font-size: 0.88rem; margin: 8px 0 0 0; }

        /* ---------- Modal ---------- */
        .snbdmgr-modal-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            backdrop-filter: blur(4px);
            z-index: 99999;
            align-items: center;
            justify-content: center;
        }
        .snbdmgr-modal-backdrop.open { display: flex; }
        .snbdmgr-modal {
            background: #fff;
            border-radius: 16px;
            padding: 28px;
            width: 100%;
            max-width: 540px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.2);
            max-height: 90vh;
            overflow-y: auto;
        }
        .snbdmgr-modal h3 {
            font-size: 1.1rem;
            font-weight: 700;
            margin: 0 0 20px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .snbdmgr-modal h3 i { color: var(--brand); }
        .snbdmgr-modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid var(--card-border);
        }

        /* ---------- Grid helper ---------- */
        .snbdmgr-row { display: flex; gap: 20px; flex-wrap: wrap; }
        .snbdmgr-col { flex: 1; min-width: 260px; }
        .snbdmgr-col-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        /* ---------- Misc ---------- */
        .snbdmgr-divider { border: none; border-top: 1px solid var(--card-border); margin: 20px 0; }
        .snbdmgr-hint { font-size: 0.75rem; color: var(--muted); margin-top: 5px; }
        .snbdmgr-api-status { font-size: 0.82rem; margin-top: 8px; }
        .snbdmgr-api-status.success { color: var(--success); }
        .snbdmgr-api-status.error   { color: #ef4444; }
        .snbdmgr-api-status.loading { color: var(--muted); }
    </style>

    <div id="snbdmgr-wrap">

        <!-- ======================================================
             TOP BAR
        ====================================================== -->
        <div class="snbdmgr-topbar">
            <div class="brand">
                <div class="brand-icon"><i class="fas fa-paint-brush"></i></div>
                <div>
                    <div><h1>SNBDHost Theme Manager</h1></div>
                    <div class="sub">WHMCS Portal Theme &amp; Module Control Center</div>
                </div>
            </div>
            <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
                <span class="snbdmgr-badge dark"><i class="fas fa-code-branch"></i> v2.0</span>
                <?php if (!empty($githubRepo) && $githubRepo !== 'username/repo'): ?>
                    <span class="snbdmgr-badge dark"><i class="fab fa-github"></i> <?= htmlspecialchars($githubRepo) ?></span>
                <?php endif; ?>
                <?php
                    $devMode = false;
                    try {
                        $dv = Capsule::table('tbladdonmodules')->where('module','snbdhost_manager')->where('setting','developer_mode')->value('value');
                        $devMode = ($dv === 'on' || $dv === '1' || $dv === 'yes');
                    } catch(\Exception $e) {}
                    if ($devMode): ?>
                    <span class="snbdmgr-badge warning"><i class="fas fa-code"></i> Dev Mode ON</span>
                <?php endif; ?>
                <a href="<?= $modulelink ?>&action=update_theme&type=all" onclick="return confirm('Update both Theme and Manager Module now?')" class="snbdmgr-btn primary sm"><i class="fas fa-sync-alt"></i> Update All</a>
            </div>
        </div>

        <!-- ======================================================
             TABS
        ====================================================== -->
        <div class="snbdmgr-tabs" id="snbdmgr-tabs">
            <button class="snbdmgr-tab <?= $activeTab === 'overview'       ? 'active' : '' ?>" onclick="snbdmgrTab('overview')">       <i class="fas fa-home"></i>       Overview</button>
            <button class="snbdmgr-tab <?= $activeTab === 'modules'        ? 'active' : '' ?>" onclick="snbdmgrTab('modules')">        <i class="fas fa-puzzle-piece"></i> Managed Modules</button>
            <button class="snbdmgr-tab <?= $activeTab === 'notifications'  ? 'active' : '' ?>" onclick="snbdmgrTab('notifications')">  <i class="fas fa-bell"></i>        Notifications</button>
            <button class="snbdmgr-tab <?= $activeTab === 'banner'         ? 'active' : '' ?>" onclick="snbdmgrTab('banner')">         <i class="fas fa-pager"></i>       Client Banner</button>
            <button class="snbdmgr-tab <?= $activeTab === 'uptimerobot'   ? 'active' : '' ?>" onclick="snbdmgrTab('uptimerobot')">    <i class="fas fa-satellite-dish"></i> UptimeRobot</button>
        </div>

        <!-- ======================================================
             TAB: OVERVIEW
        ====================================================== -->
        <div class="snbdmgr-panel <?= $activeTab === 'overview' ? 'active' : '' ?>" id="snbdmgr-panel-overview">

            <?php if (!empty($githubRepo) && $githubRepo !== 'username/repo'): ?>
            <div class="snbdmgr-repo-strip">
                <i class="fab fa-github" style="font-size:1.1rem;color:#1a1a1a;"></i>
                <span>Connected repository:</span>
                <code><?= htmlspecialchars($githubRepo) ?></code>
                <a href="https://github.com/<?= htmlspecialchars($githubRepo) ?>" target="_blank" style="margin-left:auto;font-size:0.78rem;color:var(--brand);">
                    <i class="fas fa-external-link-alt"></i> View on GitHub
                </a>
            </div>
            <?php endif; ?>

            <div class="snbdmgr-row">
                <div class="snbdmgr-col">
                    <div class="snbdmgr-card">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon red"><i class="fas fa-paint-brush"></i></div>
                                <span>Theme Updates</span>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body">
                            <p style="font-size:0.83rem;color:var(--muted);margin:0 0 18px;">Pull the latest version of the SNBDHost portal theme from GitHub. This overwrites the template files on your server.</p>

                            <div style="display:flex;flex-direction:column;gap:12px;">
                                <!-- Update Theme -->
                                <div class="snbdmgr-update-card">
                                    <div class="update-icon" style="background:rgba(204,0,0,0.08);color:var(--brand);">
                                        <i class="fas fa-palette"></i>
                                    </div>
                                    <div>
                                        <div class="update-title">Theme Files</div>
                                        <div class="update-desc">templates/snbdhost, orderforms, hooks</div>
                                    </div>
                                    <div class="update-action">
                                        <a href="<?= $modulelink ?>&action=update_theme&type=theme"
                                           onclick="return confirm('Update Theme files now?')"
                                           class="snbdmgr-btn primary sm">
                                            <i class="fas fa-download"></i> Update Theme
                                        </a>
                                    </div>
                                </div>

                                <!-- Update Module -->
                                <div class="snbdmgr-update-card">
                                    <div class="update-icon" style="background:#1a1a1a;color:#fff;">
                                        <i class="fas fa-cog"></i>
                                    </div>
                                    <div>
                                        <div class="update-title">Manager Module</div>
                                        <div class="update-desc">modules/addons/snbdhost_manager</div>
                                    </div>
                                    <div class="update-action">
                                        <a href="<?= $modulelink ?>&action=update_theme&type=module"
                                           onclick="return confirm('Update the Manager Module now?')"
                                           class="snbdmgr-btn dark sm">
                                            <i class="fas fa-sync"></i> Update Module
                                        </a>
                                    </div>
                                </div>

                                <!-- Update Both -->
                                <div class="snbdmgr-update-card" style="background:linear-gradient(135deg,rgba(204,0,0,0.03),rgba(26,26,26,0.03));border-color:#ddd;">
                                    <div class="update-icon" style="background:linear-gradient(135deg,var(--brand),#1a1a1a);color:#fff;">
                                        <i class="fas fa-layer-group"></i>
                                    </div>
                                    <div>
                                        <div class="update-title">Update Everything</div>
                                        <div class="update-desc">Theme + Manager Module in one go</div>
                                    </div>
                                    <div class="update-action">
                                        <a href="<?= $modulelink ?>&action=update_theme&type=all"
                                           onclick="return confirm('Update Theme AND Manager Module together?')"
                                           class="snbdmgr-btn primary sm">
                                            <i class="fas fa-rocket"></i> Update All
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="snbdmgr-col">
                    <div class="snbdmgr-card" style="height:100%;">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon blue"><i class="fas fa-info-circle"></i></div>
                                <span>Quick Info</span>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body">
                            <table style="width:100%;font-size:0.83rem;border-collapse:collapse;">
                                <?php
                                $infoRows = [
                                    ['label' => 'Module Version',    'value' => 'v2.0'],
                                    ['label' => 'GitHub Repo',       'value' => !empty($githubRepo) && $githubRepo !== 'username/repo' ? '<code style="color:var(--brand);">' . htmlspecialchars($githubRepo) . '</code>' : '<span style="color:var(--muted);">Not configured</span>'],
                                    ['label' => 'Managed Modules',   'value' => count($managedModules) . ' module(s)'],
                                    ['label' => 'UptimeRobot Key',   'value' => !empty($uptimerobotApiKey) ? '<span style="color:var(--success);"><i class="fas fa-check-circle"></i> Configured</span>' : '<span style="color:var(--muted);">Not set</span>'],
                                    ['label' => 'Developer Mode',    'value' => $devMode ? '<span style="color:var(--warning);font-weight:700;"><i class="fas fa-code"></i> ON</span>' : '<span style="color:var(--muted);">Off</span>'],
                                ];
                                foreach ($infoRows as $row): ?>
                                <tr>
                                    <td style="padding:10px 0;color:var(--muted);border-bottom:1px solid #f3f4f6;width:45%;"><?= $row['label'] ?></td>
                                    <td style="padding:10px 0;font-weight:600;border-bottom:1px solid #f3f4f6;"><?= $row['value'] ?></td>
                                </tr>
                                <?php endforeach; ?>
                            </table>

                            <hr class="snbdmgr-divider">
                            <div style="display:flex;gap:10px;flex-wrap:wrap;">
                                <a href="<?= htmlspecialchars($vars['bug_report_url'] ?? '#') ?>" target="_blank" class="snbdmgr-btn ghost sm">
                                    <i class="fas fa-bug"></i> Report Bug
                                </a>
                                <a href="configaddonmods.php" class="snbdmgr-btn ghost sm">
                                    <i class="fas fa-sliders-h"></i> Module Settings
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- ======================================================
             TAB: MANAGED MODULES
        ====================================================== -->
        <div class="snbdmgr-panel <?= $activeTab === 'modules' ? 'active' : '' ?>" id="snbdmgr-panel-modules">

            <div class="snbdmgr-card">
                <div class="snbdmgr-card-header">
                    <div class="header-left">
                        <div class="header-icon red"><i class="fas fa-puzzle-piece"></i></div>
                        <div>
                            <div>Managed Modules</div>
                            <div style="font-size:0.72rem;font-weight:400;color:var(--muted);margin-top:1px;">Install and update custom WHMCS modules from GitHub repositories</div>
                        </div>
                    </div>
                    <button onclick="snbdmgrOpenAddModal()" class="snbdmgr-btn primary sm">
                        <i class="fas fa-plus"></i> Add Module
                    </button>
                </div>
                <div class="snbdmgr-card-body" style="padding:0;">
                    <?php if (empty($managedModules)): ?>
                        <div class="snbdmgr-empty">
                            <div class="empty-icon"><i class="fas fa-puzzle-piece"></i></div>
                            <p><strong>No managed modules yet.</strong></p>
                            <p>Click <strong>Add Module</strong> to connect a GitHub repository and install it directly on this server.</p>
                            <button onclick="snbdmgrOpenAddModal()" class="snbdmgr-btn primary" style="margin-top:16px;">
                                <i class="fas fa-plus"></i> Add Your First Module
                            </button>
                        </div>
                    <?php else: ?>
                        <div style="overflow-x:auto;">
                            <table class="snbdmgr-table">
                                <thead>
                                    <tr>
                                        <th>Module</th>
                                        <th>Status</th>
                                        <th>Last Updated</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <?php foreach ($managedModules as $mod): ?>
                                    <?php
                                    $autoPath = 'modules/addons/' . basename($mod['repo']);
                                    ?>
                                    <tr>
                                        <td>
                                            <div class="mod-name"><?= htmlspecialchars($mod['name']) ?></div>
                                            <div style="font-size:0.73rem;color:var(--muted);margin-top:2px;">
                                                <span class="mod-repo"><?= htmlspecialchars($mod['repo']) ?></span>
                                                &nbsp;·&nbsp; branch: <?= htmlspecialchars($mod['branch'] ?? 'main') ?>
                                            </div>
                                            <?php if (!empty($mod['description'])): ?>
                                                <div style="font-size:0.74rem;color:var(--muted);margin-top:1px;"><?= htmlspecialchars($mod['description']) ?></div>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <?php
                                            $status = $mod['status'] ?? 'not_installed';
                                            $statusLabel = $status === 'installed' ? 'Installed' : ($status === 'error' ? 'Error' : 'Not Installed');
                                            $statusIcon  = $status === 'installed' ? 'fa-check-circle' : ($status === 'error' ? 'fa-exclamation-circle' : 'fa-minus-circle');
                                            ?>
                                            <span class="snbdmgr-status-pill <?= $status ?>">
                                                <i class="fas <?= $statusIcon ?>"></i>
                                                <?= $statusLabel ?>
                                            </span>
                                        </td>
                                        <td style="font-size:0.78rem;color:var(--muted);">
                                            <?= !empty($mod['last_updated']) ? htmlspecialchars($mod['last_updated']) : '—' ?>
                                        </td>
                                        <td>
                                            <div style="display:flex;gap:6px;flex-wrap:wrap;">
                                                <?php if ($mod['status'] === 'installed'): ?>
                                                    <a href="<?= $modulelink ?>&action=update_module&module_id=<?= urlencode($mod['id']) ?>&tab=modules"
                                                       onclick="return confirm('Update <?= htmlspecialchars(addslashes($mod['name'])) ?> now?')"
                                                       class="snbdmgr-btn info sm">
                                                        <i class="fas fa-sync"></i> Update
                                                    </a>
                                                <?php else: ?>
                                                    <a href="<?= $modulelink ?>&action=install_module&module_id=<?= urlencode($mod['id']) ?>&tab=modules"
                                                       onclick="return confirm('Install <?= htmlspecialchars(addslashes($mod['name'])) ?> now?')"
                                                       class="snbdmgr-btn success sm">
                                                        <i class="fas fa-download"></i> Install
                                                    </a>
                                                <?php endif; ?>
                                                <button onclick="snbdmgrOpenEditModal(<?= htmlspecialchars(json_encode($mod)) ?>)"
                                                        class="snbdmgr-btn ghost sm">
                                                    <i class="fas fa-pencil-alt"></i>
                                                </button>
                                                <a href="<?= $modulelink ?>&action=delete_module&module_id=<?= urlencode($mod['id']) ?>&tab=modules"
                                                   onclick="return confirm('Remove this module from the list? Files on disk will NOT be deleted.')"
                                                   class="snbdmgr-btn danger sm">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                                </tbody>
                            </table>
                        </div>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Info box -->
            <div class="snbdmgr-card" style="background:linear-gradient(135deg,#eff6ff,#dbeafe);border-color:#93c5fd;">
                <div class="snbdmgr-card-body" style="display:flex;gap:14px;align-items:flex-start;">
                    <i class="fas fa-info-circle" style="color:#3b82f6;margin-top:2px;font-size:1.1rem;flex-shrink:0;"></i>
                    <div style="font-size:0.82rem;color:#1d4ed8;line-height:1.6;">
                        Modules are automatically installed to <code style="background:#dbeafe;padding:1px 6px;border-radius:4px;">modules/addons/{repo-name}</code> — the same directory where SNBDHost Theme Manager lives. Just enter the GitHub repo and click Install.
                    </div>
                </div>
            </div>
        </div>


        <!-- ======================================================
             TAB: NOTIFICATIONS
        ====================================================== -->
        <div class="snbdmgr-panel <?= $activeTab === 'notifications' ? 'active' : '' ?>" id="snbdmgr-panel-notifications">
            <div class="snbdmgr-row">
                <div class="snbdmgr-col">
                    <div class="snbdmgr-card">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon dark"><i class="fas fa-bullhorn"></i></div>
                                <div>
                                    <div>Dashboard Notification Override</div>
                                    <div style="font-size:0.72rem;font-weight:400;color:var(--muted);">Manually set what shows on the admin dashboard notice</div>
                                </div>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body">
                            <p style="font-size:0.83rem;color:var(--muted);margin:0 0 20px;">Override the auto-fetched GitHub data. Leave fields blank to let the system pull from the CHANGELOG.md automatically.</p>
                            <form method="post" action="<?= $modulelink ?>&action=save_bugs&tab=notifications">
                                <div class="snbdmgr-form-group">
                                    <label class="snbdmgr-label">Most Recent Fix</label>
                                    <input type="text" name="fixed_bug" class="snbdmgr-input"
                                           placeholder="e.g., Fixed alignment on order form..."
                                           value="<?= htmlspecialchars($customBugs['fixed_bug']) ?>">
                                </div>
                                <div class="snbdmgr-form-group">
                                    <label class="snbdmgr-label">Last Reported Bug</label>
                                    <input type="text" name="reported_bug" class="snbdmgr-input"
                                           placeholder="e.g., Client area login button broken..."
                                           value="<?= htmlspecialchars($customBugs['reported_bug']) ?>">
                                </div>
                                <div class="snbdmgr-form-group">
                                    <label class="snbdmgr-label">Reported By (Username/Name)</label>
                                    <input type="text" name="reporter" class="snbdmgr-input"
                                           placeholder="e.g., admin or John Doe"
                                           value="<?= htmlspecialchars($customBugs['reporter']) ?>">
                                </div>
                                <button type="submit" class="snbdmgr-btn success w100">
                                    <i class="fas fa-save"></i> Save Notification Data
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="snbdmgr-col">
                    <div class="snbdmgr-card" style="height:100%;">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon blue"><i class="fas fa-info-circle"></i></div>
                                <span>How it works</span>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body" style="font-size:0.83rem;color:var(--muted);line-height:1.7;">
                            <p><strong>Priority 1:</strong> Values you save in this form will be shown first.</p>
                            <p><strong>Priority 2:</strong> If fields are blank, the manager will read from <code>CHANGELOG.md</code> on the GitHub repo to find the latest fix.</p>
                            <p><strong>Priority 3:</strong> If GitHub is unreachable, a generic status message is shown.</p>
                            <hr class="snbdmgr-divider">
                            <p>These notifications appear in the admin dashboard top notice bar and in the SNBDHost Theme Widget.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- ======================================================
             TAB: CLIENT BANNER
        ====================================================== -->
        <div class="snbdmgr-panel <?= $activeTab === 'banner' ? 'active' : '' ?>" id="snbdmgr-panel-banner">
            <div class="snbdmgr-row">
                <div class="snbdmgr-col">
                    <div class="snbdmgr-card">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon blue"><i class="fas fa-pager"></i></div>
                                <div>
                                    <div>Client Area Dashboard Banner</div>
                                    <div style="font-size:0.72rem;font-weight:400;color:var(--muted);">The announcement bar at the top of the client portal dashboard</div>
                                </div>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body">
                            <form method="post" action="<?= $modulelink ?>&action=save_client_banner&tab=banner">
                                <div class="snbdmgr-form-group" style="display:flex;align-items:center;gap:12px;">
                                    <input type="checkbox" name="banner_enabled" id="banner_enabled_chk" value="1"
                                           <?= ($bannerData['enabled'] == '1') ? 'checked' : '' ?>
                                           style="width:18px;height:18px;accent-color:var(--brand);cursor:pointer;">
                                    <label for="banner_enabled_chk" style="font-size:0.88rem;font-weight:600;cursor:pointer;margin:0;">Enable Banner on Client Dashboard</label>
                                </div>

                                <div class="snbdmgr-form-group">
                                    <label class="snbdmgr-label">Banner Title</label>
                                    <input type="text" name="banner_title" class="snbdmgr-input"
                                           placeholder="🚀 SNBD HOST Version 3.5 released..."
                                           value="<?= htmlspecialchars($bannerData['title']) ?>">
                                </div>
                                <div class="snbdmgr-form-group">
                                    <label class="snbdmgr-label">Banner Description</label>
                                    <input type="text" name="banner_desc" class="snbdmgr-input"
                                           placeholder="New layouts, fixes, and more..."
                                           value="<?= htmlspecialchars($bannerData['desc']) ?>">
                                </div>
                                <div class="snbdmgr-col-2">
                                    <div class="snbdmgr-form-group">
                                        <label class="snbdmgr-label">Call to Action URL</label>
                                        <input type="text" name="banner_link" class="snbdmgr-input"
                                               placeholder="clientarea.php?action=devupdates"
                                               value="<?= htmlspecialchars($bannerData['link']) ?>">
                                    </div>
                                    <div class="snbdmgr-form-group">
                                        <label class="snbdmgr-label">Button Text</label>
                                        <input type="text" name="banner_link_text" class="snbdmgr-input"
                                               placeholder="See More"
                                               value="<?= htmlspecialchars($bannerData['link_text']) ?>">
                                    </div>
                                </div>
                                <button type="submit" class="snbdmgr-btn info w100">
                                    <i class="fas fa-save"></i> Save Client Banner
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="snbdmgr-col" style="max-width:340px;">
                    <div class="snbdmgr-card" style="background:#f9fafb;border-style:dashed;">
                        <div class="snbdmgr-card-body" style="font-size:0.82rem;color:var(--muted);line-height:1.7;">
                            <div style="font-weight:700;color:var(--text);margin-bottom:10px;"><i class="fas fa-eye me-1" style="color:var(--brand);"></i> Preview</div>
                            <p>The banner renders as a gradient red bar at the top of the client portal home page with:</p>
                            <ul style="padding-left:16px;margin:0;">
                                <li>An icon + title in white text</li>
                                <li>A subtitle/description line</li>
                                <li>A white CTA button on the right</li>
                                <li>A dismiss (×) button</li>
                            </ul>
                            <hr class="snbdmgr-divider">
                            <p>If <strong>Developer Mode</strong> is active, the banner is automatically replaced with the developer mode notice and your settings here are ignored.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- ======================================================
             TAB: UPTIMEROBOT
        ====================================================== -->
        <div class="snbdmgr-panel <?= $activeTab === 'uptimerobot' ? 'active' : '' ?>" id="snbdmgr-panel-uptimerobot">
            <div class="snbdmgr-row">
                <div class="snbdmgr-col">
                    <div class="snbdmgr-card">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon red"><i class="fas fa-satellite-dish"></i></div>
                                <div>
                                    <div>UptimeRobot Network Status</div>
                                    <div style="font-size:0.72rem;font-weight:400;color:var(--muted);">API key for the client-facing network status page</div>
                                </div>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body">
                            <p style="font-size:0.83rem;color:var(--muted);margin:0 0 20px;">
                                Configure your UptimeRobot Read-Only API key to power the <strong>Network Status</strong> page in the client portal.
                                The key is stored server-side in a local config file and used to fetch monitor data on demand.
                            </p>

                            <div class="snbdmgr-form-group">
                                <label class="snbdmgr-label">Read-Only API Key</label>
                                <div style="display:flex;gap:10px;align-items:center;">
                                    <input type="text" id="ur-api-key" class="snbdmgr-input"
                                           style="font-family:monospace;"
                                           value="<?= htmlspecialchars($uptimerobotApiKey) ?>"
                                           placeholder="Enter your UptimeRobot Read-Only API key...">
                                    <button type="button" class="snbdmgr-btn primary sm" id="ur-test-btn" onclick="snbdmgrTestUR()">
                                        <i class="fas fa-vial"></i> Test
                                    </button>
                                </div>
                                <div class="snbdmgr-hint">Get your key: UptimeRobot Dashboard → My Settings → API Settings → Create read-only API key.</div>
                            </div>

                            <div id="ur-test-result" class="snbdmgr-api-status" style="min-height:22px;"></div>

                            <div style="margin-top:18px;padding:14px;background:#eff6ff;border:1px solid #bfdbfe;border-radius:10px;font-size:0.8rem;color:#1d4ed8;line-height:1.6;">
                                <i class="fas fa-lightbulb me-1"></i>
                                <strong>Tip:</strong> To update the actual API key setting, edit it in the
                                <a href="configaddonmods.php" style="color:#1d4ed8;">Module Configuration</a>
                                page (Addon Modules → SNBDHost Theme Manager → Configure), then come back here to verify with the Test button.
                            </div>
                        </div>
                    </div>
                </div>
                <div class="snbdmgr-col" style="max-width:340px;">
                    <div class="snbdmgr-card">
                        <div class="snbdmgr-card-header">
                            <div class="header-left">
                                <div class="header-icon green"><i class="fas fa-chart-bar"></i></div>
                                <span>Cache Status</span>
                            </div>
                        </div>
                        <div class="snbdmgr-card-body" style="font-size:0.83rem;color:var(--muted);line-height:1.7;">
                            <?php
                                $cacheFile = __DIR__ . '/../../../network-status.json';
                                if (file_exists($cacheFile)):
                                    $cacheData = json_decode(file_get_contents($cacheFile), true);
                                    $lastUpdated = $cacheData['last_updated_timestamp'] ?? 0;
                                    $monitorCount = count($cacheData['monitors'] ?? []);
                            ?>
                                <div style="display:flex;gap:10px;align-items:center;margin-bottom:12px;">
                                    <i class="fas fa-check-circle" style="color:var(--success);font-size:1.3rem;"></i>
                                    <div>
                                        <div style="font-weight:700;color:var(--text);">Cache Available</div>
                                        <div><?= $monitorCount ?> monitor(s) cached</div>
                                    </div>
                                </div>
                                <div>Last updated: <strong><?= $lastUpdated ? date('M j, Y H:i', $lastUpdated) : 'Unknown' ?></strong></div>
                            <?php else: ?>
                                <div style="display:flex;gap:10px;align-items:center;">
                                    <i class="fas fa-exclamation-circle" style="color:var(--warning);font-size:1.3rem;"></i>
                                    <div>
                                        <div style="font-weight:700;color:var(--text);">No Cache Yet</div>
                                        <div>Run a test to populate the cache file.</div>
                                    </div>
                                </div>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div><!-- /snbdmgr-wrap -->


    <!-- ======================================================
         ADD MODULE MODAL
    ====================================================== -->
    <div class="snbdmgr-modal-backdrop" id="snbdmgr-add-modal">
        <div class="snbdmgr-modal">
            <h3><i class="fas fa-plus-circle"></i> Add Managed Module</h3>
            <form method="post" action="<?= $modulelink ?>&action=add_module&tab=modules">
                <div class="snbdmgr-form-group">
                    <label class="snbdmgr-label">Module Name <span class="req">*</span></label>
                    <input type="text" name="mod_name" class="snbdmgr-input" placeholder="e.g., OpenClaw Manager" required>
                </div>
                <div class="snbdmgr-form-group">
                    <label class="snbdmgr-label">GitHub Repository <span class="req">*</span></label>
                    <input type="text" name="mod_repo" class="snbdmgr-input" placeholder="owner/repository-name" required>
                    <div class="snbdmgr-hint">Format: <code>username/repo</code> — e.g., <code>openclaw/whmcs-module</code></div>
                </div>
                <div class="snbdmgr-col-2">
                    <div class="snbdmgr-form-group">
                        <label class="snbdmgr-label">Branch</label>
                        <input type="text" name="mod_branch" class="snbdmgr-input" placeholder="main" value="main">
                    </div>
                    <div class="snbdmgr-form-group">
                        <label class="snbdmgr-label">GitHub Token <em style="font-weight:400;">(if private)</em></label>
                        <input type="password" name="mod_token" class="snbdmgr-input" placeholder="ghp_xxxxxxxxxxxx">
                    </div>
                </div>
                <div class="snbdmgr-form-group">
                    <label class="snbdmgr-label">Description <em style="font-weight:400;">(optional)</em></label>
                    <input type="text" name="mod_description" class="snbdmgr-input" placeholder="Short description of what this module does...">
                </div>
                <div class="snbdmgr-modal-footer">
                    <button type="button" onclick="snbdmgrCloseModals()" class="snbdmgr-btn ghost">Cancel</button>
                    <button type="submit" class="snbdmgr-btn primary"><i class="fas fa-plus"></i> Add Module</button>
                </div>
            </form>
        </div>
    </div>


    <!-- ======================================================
         EDIT MODULE MODAL
    ====================================================== -->
    <div class="snbdmgr-modal-backdrop" id="snbdmgr-edit-modal">
        <div class="snbdmgr-modal">
            <h3><i class="fas fa-pencil-alt"></i> Edit Module</h3>
            <form method="post" action="<?= $modulelink ?>&action=edit_module&tab=modules" id="snbdmgr-edit-form">
                <input type="hidden" name="mod_id" id="edit_mod_id">
                <div class="snbdmgr-form-group">
                    <label class="snbdmgr-label">Module Name <span class="req">*</span></label>
                    <input type="text" name="mod_name" id="edit_mod_name" class="snbdmgr-input" required>
                </div>
                <div class="snbdmgr-form-group">
                    <label class="snbdmgr-label">GitHub Repository <span class="req">*</span></label>
                    <input type="text" name="mod_repo" id="edit_mod_repo" class="snbdmgr-input" required>
                </div>
                <div class="snbdmgr-col-2">
                    <div class="snbdmgr-form-group">
                        <label class="snbdmgr-label">Branch</label>
                        <input type="text" name="mod_branch" id="edit_mod_branch" class="snbdmgr-input">
                    </div>
                    <div class="snbdmgr-form-group">
                        <label class="snbdmgr-label">GitHub Token</label>
                        <input type="password" name="mod_token" id="edit_mod_token" class="snbdmgr-input" placeholder="(leave blank to keep existing)">
                    </div>
                </div>
                <div class="snbdmgr-form-group">
                    <label class="snbdmgr-label">Description</label>
                    <input type="text" name="mod_description" id="edit_mod_description" class="snbdmgr-input">
                </div>
                <div class="snbdmgr-modal-footer">
                    <button type="button" onclick="snbdmgrCloseModals()" class="snbdmgr-btn ghost">Cancel</button>
                    <button type="submit" class="snbdmgr-btn primary"><i class="fas fa-save"></i> Save Changes</button>
                </div>
            </form>
        </div>
    </div>


    <!-- ======================================================
         JAVASCRIPT
    ====================================================== -->
    <script>
    // Tab switching
    function snbdmgrTab(name) {
        document.querySelectorAll('.snbdmgr-panel').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.snbdmgr-tab').forEach(function(t) { t.classList.remove('active'); });
        var panel = document.getElementById('snbdmgr-panel-' + name);
        if (panel) panel.classList.add('active');
        event.currentTarget.classList.add('active');
    }

    // Modal helpers
    function snbdmgrOpenAddModal() {
        document.getElementById('snbdmgr-add-modal').classList.add('open');
    }
    function snbdmgrOpenEditModal(mod) {
        document.getElementById('edit_mod_id').value          = mod.id           || '';
        document.getElementById('edit_mod_name').value        = mod.name         || '';
        document.getElementById('edit_mod_repo').value        = mod.repo         || '';
        document.getElementById('edit_mod_branch').value      = mod.branch       || 'main';
        document.getElementById('edit_mod_token').value       = '';   // never pre-fill token
        document.getElementById('edit_mod_description').value = mod.description  || '';
        document.getElementById('snbdmgr-edit-modal').classList.add('open');
    }
    function snbdmgrCloseModals() {
        document.querySelectorAll('.snbdmgr-modal-backdrop').forEach(function(m) { m.classList.remove('open'); });
    }
    // Close on backdrop click
    document.querySelectorAll('.snbdmgr-modal-backdrop').forEach(function(backdrop) {
        backdrop.addEventListener('click', function(e) {
            if (e.target === backdrop) snbdmgrCloseModals();
        });
    });

    // UptimeRobot API test
    function snbdmgrTestUR() {
        var key       = document.getElementById('ur-api-key').value.trim();
        var resultDiv = document.getElementById('ur-test-result');
        var btn       = document.getElementById('ur-test-btn');
        var origHtml  = btn.innerHTML;

        if (!key) {
            resultDiv.innerHTML   = '<i class="fas fa-exclamation-circle"></i> Please enter an API key.';
            resultDiv.className   = 'snbdmgr-api-status error';
            return;
        }

        btn.innerHTML           = '<i class="fas fa-spinner fa-spin"></i> Testing...';
        btn.disabled            = true;
        resultDiv.innerHTML     = '<i class="fas fa-spinner fa-spin"></i> Connecting to UptimeRobot...';
        resultDiv.className     = 'snbdmgr-api-status loading';

        fetch('<?= $modulelink ?>&action=test_uptimerobot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'api_key=' + encodeURIComponent(key)
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                resultDiv.innerHTML = '<i class="fas fa-check-circle"></i> ' + data.message;
                resultDiv.className = 'snbdmgr-api-status success';
            } else {
                resultDiv.innerHTML = '<i class="fas fa-times-circle"></i> ' + data.message;
                resultDiv.className = 'snbdmgr-api-status error';
            }
        })
        .catch(function(err) {
            resultDiv.innerHTML = '<i class="fas fa-times-circle"></i> Request failed: ' + err.message;
            resultDiv.className = 'snbdmgr-api-status error';
        })
        .finally(function() {
            btn.innerHTML = origHtml;
            btn.disabled  = false;
        });
    }
    </script>
    <?php
}

/* ------------------------------------------------------------------ */
/*  Alert helper                                                         */
/* ------------------------------------------------------------------ */
function snbdmgr_alert(string $type, string $html): string
{
    $colors = [
        'success' => ['bg' => '#ecfdf5', 'border' => '#10b981', 'text' => '#065f46'],
        'danger'  => ['bg' => '#fef2f2', 'border' => '#ef4444', 'text' => '#7f1d1d'],
        'warning' => ['bg' => '#fffbeb', 'border' => '#f59e0b', 'text' => '#78350f'],
        'info'    => ['bg' => '#eff6ff', 'border' => '#3b82f6', 'text' => '#1d4ed8'],
    ];
    $c = $colors[$type] ?? $colors['info'];
    return sprintf(
        '<div style="background:%s;border:1px solid %s;border-left:4px solid %s;border-radius:10px;padding:14px 18px;margin-bottom:20px;font-size:0.85rem;color:%s;line-height:1.5;">%s</div>',
        $c['bg'], $c['border'], $c['border'], $c['text'], $html
    );
}
