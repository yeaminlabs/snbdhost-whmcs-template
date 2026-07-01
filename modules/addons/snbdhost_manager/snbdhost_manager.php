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
    <div style="margin-bottom: 20px;">
        <h2 style="margin: 0 0 5px 0;">SNBDHost Theme Manager</h2>
        <p style="color: #666; margin: 0;">WHMCS Portal Theme & Module Control Center</p>
    </div>

    <!-- Theme Updates Section -->
    <div style="background: #fff; border: 1px solid #ccc; border-radius: 4px; margin-bottom: 20px; padding: 15px;">
        <h3 style="margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px;">Theme & Manager Updates</h3>
        <p>Pull the latest version of the SNBDHost portal theme or manager module from GitHub.</p>
        <div style="display: flex; gap: 10px;">
            <a href="<?= $modulelink ?>&action=update_theme&type=theme" onclick="return confirm('Update Theme files now?')" class="btn btn-primary">Update Theme</a>
            <a href="<?= $modulelink ?>&action=update_theme&type=module" onclick="return confirm('Update the Manager Module now?')" class="btn btn-default">Update Module</a>
            <a href="<?= $modulelink ?>&action=update_theme&type=all" onclick="return confirm('Update Theme AND Manager Module together?')" class="btn btn-success">Update All</a>
        </div>
    </div>

    <!-- Managed Modules Section -->
    <div style="background: #fff; border: 1px solid #ccc; border-radius: 4px; margin-bottom: 20px; padding: 15px;">
        <h3 style="margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px;">Managed Modules</h3>
        <p>Install and update custom WHMCS modules from GitHub repositories.</p>

        <?php if (empty($managedModules)): ?>
            <div style="padding: 20px; text-align: center; color: #666; background: #f9f9f9; border: 1px dashed #ccc; margin-bottom: 20px;">
                <p>No managed modules yet.</p>
            </div>
        <?php else: ?>
            <table class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr>
                    <th>Module</th>
                    <th>Status</th>
                    <th>Last Updated</th>
                    <th>Actions</th>
                </tr>
                <?php foreach ($managedModules as $mod): 
                    $status = $mod['status'] ?? 'not_installed';
                    $statusLabel = $status === 'installed' ? 'Installed' : ($status === 'error' ? 'Error' : 'Not Installed');
                ?>
                <tr>
                    <td>
                        <strong><?= htmlspecialchars($mod['name']) ?></strong><br>
                        <small style="color: #666;"><?= htmlspecialchars($mod['repo']) ?> · branch: <?= htmlspecialchars($mod['branch'] ?? 'main') ?></small>
                        <?php if (!empty($mod['description'])): ?><br><small><?= htmlspecialchars($mod['description']) ?></small><?php endif; ?>
                    </td>
                    <td><?= $statusLabel ?></td>
                    <td><?= !empty($mod['last_updated']) ? htmlspecialchars($mod['last_updated']) : '—' ?></td>
                    <td>
                        <?php if ($mod['status'] === 'installed'): ?>
                            <a href="<?= $modulelink ?>&action=update_module&module_id=<?= urlencode($mod['id']) ?>" onclick="return confirm('Update <?= htmlspecialchars(addslashes($mod['name'])) ?> now?')" class="btn btn-info btn-sm">Update</a>
                        <?php else: ?>
                            <a href="<?= $modulelink ?>&action=install_module&module_id=<?= urlencode($mod['id']) ?>" onclick="return confirm('Install <?= htmlspecialchars(addslashes($mod['name'])) ?> now?')" class="btn btn-success btn-sm">Install</a>
                        <?php endif; ?>
                        <a href="<?= $modulelink ?>&action=delete_module&module_id=<?= urlencode($mod['id']) ?>" onclick="return confirm('Remove this module? Files on disk will NOT be deleted.')" class="btn btn-danger btn-sm">Remove</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </table>
            <br>
        <?php endif; ?>

        <h4>Add New Module</h4>
        <form method="post" action="<?= $modulelink ?>&action=add_module">
            <table class="form" width="100%" border="0" cellspacing="2" cellpadding="3">
                <tr>
                    <td class="fieldlabel" width="20%">Module Name</td>
                    <td class="fieldarea"><input type="text" name="mod_name" size="40" required placeholder="e.g. OpenClaw Manager"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">GitHub Repository</td>
                    <td class="fieldarea"><input type="text" name="mod_repo" size="40" required placeholder="username/repo"> <span style="color:#666; font-size:11px;">Will auto-install to modules/addons/{repo-name}</span></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Branch</td>
                    <td class="fieldarea"><input type="text" name="mod_branch" size="20" value="main"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">GitHub Token</td>
                    <td class="fieldarea"><input type="password" name="mod_token" size="40" placeholder="(if private repo)"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Description</td>
                    <td class="fieldarea"><input type="text" name="mod_description" size="60"></td>
                </tr>
            </table>
            <p align="center"><input type="submit" value="Add Module" class="btn btn-primary"></p>
        </form>
    </div>

    <!-- Dashboard Notifications Section -->
    <div style="background: #fff; border: 1px solid #ccc; border-radius: 4px; margin-bottom: 20px; padding: 15px;">
        <h3 style="margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px;">Dashboard Notification Override</h3>
        <p>Override the auto-fetched GitHub data for the admin dashboard notice. Leave blank to pull from CHANGELOG.md.</p>
        <form method="post" action="<?= $modulelink ?>&action=save_bugs">
            <table class="form" width="100%" border="0" cellspacing="2" cellpadding="3">
                <tr>
                    <td class="fieldlabel" width="20%">Most Recent Fix</td>
                    <td class="fieldarea"><input type="text" name="fixed_bug" size="60" value="<?= htmlspecialchars($customBugs['fixed_bug']) ?>"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Last Reported Bug</td>
                    <td class="fieldarea"><input type="text" name="reported_bug" size="60" value="<?= htmlspecialchars($customBugs['reported_bug']) ?>"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Reported By</td>
                    <td class="fieldarea"><input type="text" name="reporter" size="40" value="<?= htmlspecialchars($customBugs['reporter']) ?>"></td>
                </tr>
            </table>
            <p align="center"><input type="submit" value="Save Notification Data" class="btn btn-primary"></p>
        </form>
    </div>

    <!-- Client Banner Section -->
    <div style="background: #fff; border: 1px solid #ccc; border-radius: 4px; margin-bottom: 20px; padding: 15px;">
        <h3 style="margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px;">Client Area Dashboard Banner</h3>
        <p>The announcement bar at the top of the client portal dashboard.</p>
        <form method="post" action="<?= $modulelink ?>&action=save_client_banner">
            <table class="form" width="100%" border="0" cellspacing="2" cellpadding="3">
                <tr>
                    <td class="fieldlabel" width="20%">Enable Banner</td>
                    <td class="fieldarea"><label><input type="checkbox" name="banner_enabled" value="1" <?= ($bannerData['enabled'] == '1') ? 'checked' : '' ?>> Show on Client Dashboard</label></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Banner Title</td>
                    <td class="fieldarea"><input type="text" name="banner_title" size="60" value="<?= htmlspecialchars($bannerData['title']) ?>"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Banner Description</td>
                    <td class="fieldarea"><input type="text" name="banner_desc" size="80" value="<?= htmlspecialchars($bannerData['desc']) ?>"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Call to Action URL</td>
                    <td class="fieldarea"><input type="text" name="banner_link" size="50" value="<?= htmlspecialchars($bannerData['link']) ?>"></td>
                </tr>
                <tr>
                    <td class="fieldlabel">Button Text</td>
                    <td class="fieldarea"><input type="text" name="banner_link_text" size="30" value="<?= htmlspecialchars($bannerData['link_text']) ?>"></td>
                </tr>
            </table>
            <p align="center"><input type="submit" value="Save Client Banner" class="btn btn-primary"></p>
        </form>
    </div>

    <!-- UptimeRobot Section -->
    <div style="background: #fff; border: 1px solid #ccc; border-radius: 4px; margin-bottom: 20px; padding: 15px;">
        <h3 style="margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px;">UptimeRobot Network Status</h3>
        <p>Configure your Read-Only API key to power the Network Status page in the client portal.</p>
        <form method="post" action="<?= $modulelink ?>&action=test_uptimerobot">
            <table class="form" width="100%" border="0" cellspacing="2" cellpadding="3">
                <tr>
                    <td class="fieldlabel" width="20%">API Key</td>
                    <td class="fieldarea"><input type="text" name="api_key" size="50" value="<?= htmlspecialchars($uptimerobotApiKey) ?>"></td>
                </tr>
            </table>
            <p align="center"><input type="submit" value="Test Connection & Update Cache" class="btn btn-primary"></p>
        </form>
        <?php
            $cacheFile = __DIR__ . '/../../../network-status.json';
            if (file_exists($cacheFile)) {
                $cacheData = json_decode(file_get_contents($cacheFile), true);
                $lastUpdated = $cacheData['last_updated_timestamp'] ?? 0;
                $monitorCount = count($cacheData['monitors'] ?? []);
                echo "<p style='text-align:center; color:green;'>Cache Available: {$monitorCount} monitors (Last updated: " . date('M j, Y H:i', $lastUpdated) . ")</p>";
            }
        ?>
    </div>
    <?php
}

function snbdmgr_alert(string $type, string $html): string
{
    $class = 'alert alert-info';
    if ($type === 'success') $class = 'alert alert-success';
    if ($type === 'danger') $class = 'alert alert-danger';
    if ($type === 'warning') $class = 'alert alert-warning';
    
    return "<div class="{$class}">{$html}</div>";
}
