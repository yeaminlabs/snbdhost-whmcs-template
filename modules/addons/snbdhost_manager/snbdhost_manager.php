<?php
/**
 * SNBDHost Theme Manager Addon Module
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

function snbdhost_manager_config()
{
    return [
        'name' => 'SNBDHost Theme Manager',
        'description' => 'Manages the SNBDHost WHMCS Theme, displays changelog on the admin dashboard, provides one-click updates from GitHub, and configures UptimeRobot API integration.',
        'author' => 'SNBDHost',
        'language' => 'english',
        'version' => '1.1',
        'fields' => [
            'github_repo' => [
                'FriendlyName' => 'GitHub Repository',
                'Type' => 'text',
                'Size' => '50',
                'Default' => 'username/repo',
                'Description' => 'The GitHub repository in the format "username/repo" (e.g., "snbdhost/theme").',
            ],
            'github_token' => [
                'FriendlyName' => 'GitHub Token (Optional)',
                'Type' => 'password',
                'Size' => '50',
                'Default' => '',
                'Description' => 'Required if the repository is private. Create a Personal Access Token with repo access.',
            ],
            'bug_report_url' => [
                'FriendlyName' => 'Report Bug URL',
                'Type' => 'text',
                'Size' => '50',
                'Default' => 'https://github.com/username/repo/issues',
                'Description' => 'The URL where users will be redirected to report a bug from the admin dashboard.',
            ],
            'uptimerobot_api_key' => [
                'FriendlyName' => 'UptimeRobot API Key',
                'Type' => 'text',
                'Size' => '50',
                'Default' => '',
                'Description' => 'Your UptimeRobot Read-Only API key. Used to display server status on the client portal Network Status page. Get it from https://uptimerobot.com/dashboard -> My Settings -> API Settings.',
            ],
            'google_client_id' => [
                'FriendlyName' => 'Google Client ID',
                'Type' => 'text',
                'Size' => '80',
                'Default' => '219815663641-p50rq613ol3ilqgbotogg4bb4hvg9s1e.apps.googleusercontent.com',
                'Description' => 'Your Google OAuth 2.0 Client ID for enabling "Sign in with Google" on the login/register pages.',
            ],
            'developer_mode' => [
                'FriendlyName' => 'Developer Mode',
                'Type' => 'yesno',
                'Description' => 'Tick to enable Developer Mode. This hides reports, shows a developer alert message on the dashboards, and disables the theme modification check.',
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
            'status' => 'error',
            'description' => 'Could not activate module. Database table creation failed: ' . $e->getMessage()
        ];
    }

    return [
        'status' => 'success',
        'description' => 'SNBDHost Theme Manager has been successfully activated.'
    ];
}

function snbdhost_manager_deactivate()
{
    return [
        'status' => 'success',
        'description' => 'SNBDHost Theme Manager has been successfully deactivated.'
    ];
}

function snbdhost_manager_output($vars)
{
    $modulelink = $vars['modulelink'];
    $githubRepo = $vars['github_repo'];
    $githubToken = $vars['github_token'];
    $uptimerobotApiKey = $vars['uptimerobot_api_key'] ?? '';

    // Sync UptimeRobot API key to local config file so the proxy can read it
    // without bootstrapping WHMCS every request
    $configFile = __DIR__ . '/uptimerobot_config.json';
    $currentConfig = [];
    if (file_exists($configFile)) {
        $currentConfig = json_decode(file_get_contents($configFile), true) ?: [];
    }
    if (($currentConfig['api_key'] ?? '') !== $uptimerobotApiKey || !file_exists(__DIR__ . '/../../../network-status.json')) {
        file_put_contents($configFile, json_encode(['api_key' => $uptimerobotApiKey], JSON_PRETTY_PRINT));
        
        // Force refresh / write the cache file right then and there
        if (!empty($uptimerobotApiKey)) {
            $ch = curl_init('https://api.uptimerobot.com/v2/getMonitors');
            curl_setopt_array($ch, [
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => http_build_query([
                    'api_key' => $uptimerobotApiKey,
                    'format' => 'json',
                    'logs' => '0',
                    'response_times' => '1',
                    'response_times_limit' => '10',
                    'custom_uptime_ratios' => '30',
                    'all_time_uptime_ratio' => '1',
                ]),
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT => 15,
                CURLOPT_CONNECTTIMEOUT => 10,
                CURLOPT_HTTPHEADER => ['Content-Type: application/x-www-form-urlencoded', 'Accept: application/json'],
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

    // Process update action
    $action = isset($_GET['action']) ? $_GET['action'] : '';
    $updateType = isset($_GET['type']) ? $_GET['type'] : 'all';
    $message = '';

    if ($action === 'save_client_banner') {
        $bannerData = [
            'enabled' => isset($_POST['banner_enabled']) ? '1' : '0',
            'title' => isset($_POST['banner_title']) ? strip_tags($_POST['banner_title']) : '',
            'desc' => isset($_POST['banner_desc']) ? strip_tags($_POST['banner_desc']) : '',
            'link' => isset($_POST['banner_link']) ? strip_tags($_POST['banner_link']) : '',
            'link_text' => isset($_POST['banner_link_text']) ? strip_tags($_POST['banner_link_text']) : '',
        ];
        file_put_contents(__DIR__ . '/client_banner.json', json_encode($bannerData));
        $message = '<div class="alert alert-success" style="border-left: 4px solid #CC0000; border-radius: 4px;"><strong>Success!</strong> Client Area Dashboard Banner settings updated.</div>';
    }

    if ($action === 'save_bugs') {
        $customData = [
            'reported_bug' => isset($_POST['reported_bug']) ? strip_tags($_POST['reported_bug']) : '',
            'fixed_bug' => isset($_POST['fixed_bug']) ? strip_tags($_POST['fixed_bug']) : '',
            'reporter' => isset($_POST['reporter']) ? strip_tags($_POST['reporter']) : ''
        ];
        file_put_contents(__DIR__ . '/custom_bugs.json', json_encode($customData));
        $message = '<div class="alert alert-success" style="border-left: 4px solid #CC0000; border-radius: 4px;"><strong>Success!</strong> Dashboard notifications updated manually.</div>';
    }

    if ($action === 'update_theme') {
        require_once __DIR__ . '/lib/Updater.php';
        $updater = new \SNBDHostManager\Updater($githubRepo, $githubToken);

        try {
            $updater->updateTheme($updateType);
            $targetName = $updateType === 'theme' ? 'Theme' : ($updateType === 'module' ? 'Manager Module' : 'Theme and Module');
            $message = '<div class="alert alert-success" style="border-left: 4px solid #CC0000; border-radius: 4px;"><strong>Success!</strong> ' . $targetName . ' successfully updated to the latest version.</div>';
        } catch (\Exception $e) {
            $message = '<div class="alert alert-danger" style="border-left: 4px solid #CC0000; border-radius: 4px;"><strong>Error!</strong> Failed to update: ' . $e->getMessage() . '</div>';
        }
    }

    if ($action === 'test_uptimerobot') {
        $testKey = trim($_POST['api_key'] ?? $uptimerobotApiKey);
        $testResult = [];
        if (empty($testKey)) {
            $testResult = ['success' => false, 'message' => 'No API key provided. Please configure the UptimeRobot API Key in the module settings first.'];
        } else {
            $ch = curl_init('https://api.uptimerobot.com/v2/getMonitors');
            curl_setopt_array($ch, [
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => http_build_query([
                    'api_key' => $testKey,
                    'format' => 'json',
                    'logs' => '0',
                    'response_times' => '1',
                    'response_times_limit' => '10',
                    'custom_uptime_ratios' => '30',
                    'all_time_uptime_ratio' => '1',
                ]),
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT => 15,
                CURLOPT_CONNECTTIMEOUT => 10,
                CURLOPT_SSL_VERIFYPEER => true,
                CURLOPT_SSL_VERIFYHOST => 2,
                CURLOPT_HTTPHEADER => ['Content-Type: application/x-www-form-urlencoded', 'Accept: application/json'],
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_MAXREDIRS => 3,
            ]);
            $resp = curl_exec($ch);
            $err = curl_error($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if ($resp === false) {
                $testResult = ['success' => false, 'message' => 'cURL error: ' . $err];
            } elseif ($httpCode !== 200) {
                $preview = strip_tags(substr($resp, 0, 300));
                $testResult = [
                    'success' => false,
                    'message' => 'UptimeRobot returned HTTP ' . $httpCode . '. Usually caused by rate limiting (10 req/min on free plan) or an invalid API key.',
                    'debug' => $preview
                ];
            } else {
                $data = json_decode($resp, true);
                if ($data === null && json_last_error() !== JSON_ERROR_NONE) {
                    $preview = strip_tags(substr($resp, 0, 300));
                    $testResult = [
                        'success' => false,
                        'message' => 'Invalid response from UptimeRobot (not valid JSON).',
                        'debug' => 'First 300 chars: ' . $preview
                    ];
                } elseif (isset($data['stat']) && $data['stat'] === 'ok') {
                    $count = isset($data['monitors']) ? count($data['monitors']) : 0;
                    
                    // Force generate / update the network-status.json cache file right then and there
                    $data['last_updated_timestamp'] = time();
                    @file_put_contents(__DIR__ . '/../../../network-status.json', json_encode($data));
                    
                    $testResult = ['success' => true, 'message' => 'Connection successful and cache updated! Found ' . $count . ' monitor(s).'];
                } else {
                    $msg = isset($data['error']['message']) ? $data['error']['message'] : 'Unknown error from UptimeRobot.';
                    $testResult = [
                        'success' => false,
                        'message' => $msg,
                        'debug' => isset($data['error']['type']) ? 'Error type: ' . $data['error']['type'] : null
                    ];
                }
            }
        }
        echo json_encode($testResult);
        exit;
    }

    // Load custom bug data
    $customBugs = ['reported_bug' => '', 'fixed_bug' => '', 'reporter' => ''];
    if (file_exists(__DIR__ . '/custom_bugs.json')) {
        $customBugs = json_decode(file_get_contents(__DIR__ . '/custom_bugs.json'), true);
    }

    // Load client banner data
    $bannerData = ['enabled' => '1', 'title' => '', 'desc' => '', 'link' => '', 'link_text' => ''];
    if (file_exists(__DIR__ . '/client_banner.json')) {
        $bannerData = json_decode(file_get_contents(__DIR__ . '/client_banner.json'), true);
        if (!is_array($bannerData)) $bannerData = ['enabled' => '1', 'title' => '', 'desc' => '', 'link' => '', 'link_text' => ''];
    }

    // Output HTML
    echo $message;
    ?>
    <style>
        .snbd-panel {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            background: #fff;
            margin-bottom: 20px;
        }
        .snbd-panel-heading {
            background-color: #CC0000;
            color: #ffffff;
            padding: 15px 20px;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
            font-size: 18px;
            font-weight: 600;
        }
        .snbd-panel-body {
            padding: 20px;
            font-size: 14px;
            color: #333;
        }
        .snbd-btn-group {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .snbd-btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
            border: none;
            color: #fff;
        }
        .snbd-btn:hover {
            opacity: 0.9;
            color: #fff;
            text-decoration: none;
        }
        .snbd-btn-theme {
            background-color: #CC0000;
            box-shadow: 0 4px 6px rgba(204, 0, 0, 0.2);
        }
        .snbd-btn-module {
            background-color: #111111;
            box-shadow: 0 4px 6px rgba(17, 17, 17, 0.2);
        }
        .snbd-btn-save {
            background-color: #2ecc71;
            color: #fff;
        }
        .snbd-btn-test {
            background-color: #BA1114;
            color: #fff;
        }
        .snbd-info-box {
            background: #f9f9f9;
            border-left: 4px solid #111;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .snbd-form-group {
            margin-bottom: 15px;
        }
        .snbd-form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 5px;
            color: #444;
        }
        .snbd-form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        .snbd-form-control:focus {
            border-color: #CC0000;
            outline: none;
        }
        .snbd-api-status { display: inline-block; margin-left: 10px; font-size: 13px; }
        .snbd-api-status.success { color: #2ecc71; }
        .snbd-api-status.error { color: #c62828; }
        .snbd-api-status.loading { color: #888; }
    </style>

    <div class="row">
        <div class="col-md-6">
            <div class="snbd-panel">
                <div class="snbd-panel-heading">
                    <i class="fas fa-paint-brush"></i> SNBDHost Theme Management
                </div>
                <div class="snbd-panel-body">
                    <div class="snbd-info-box">
                        <p style="margin: 0 0 5px 0;"><strong>Welcome to the SNBDHost Theme Manager.</strong></p>
                        <p style="margin: 0; color: #555;">Pull the latest updates directly from your configured GitHub repository. Choose to update just the theme files or the manager module itself.</p>
                    </div>

                    <p><strong>Configured Repository:</strong> <code><?php echo htmlspecialchars($githubRepo); ?></code></p>
                    <hr style="border-top: 1px solid #eee;">

                    <h4 style="color: #CC0000; font-weight: 600;">Available Updates</h4>

                    <div class="snbd-btn-group" style="flex-direction: column;">
                        <a href="<?php echo $modulelink; ?>&action=update_theme&type=theme" class="snbd-btn snbd-btn-theme" onclick="return confirm('Are you sure you want to update the Theme?');">
                            <i class="fas fa-download"></i> Update Theme Only
                        </a>

                        <a href="<?php echo $modulelink; ?>&action=update_theme&type=module" class="snbd-btn snbd-btn-module" onclick="return confirm('Are you sure you want to update the Manager Module?');">
                            <i class="fas fa-sync"></i> Update Manager Module Only
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="snbd-panel">
                <div class="snbd-panel-heading" style="background-color: #111;">
                    <i class="fas fa-bullhorn"></i> Dashboard Notification Override
                </div>
                <div class="snbd-panel-body">
                    <p style="color: #666; margin-bottom: 15px;">Use this form to manually override the "Last Reported Bug" and "Most Recent Fix" shown on the WHMCS dashboard. Leave fields blank to pull data automatically from GitHub and Theme Logs.</p>

                    <form method="post" action="<?php echo $modulelink; ?>&action=save_bugs">
                        <div class="snbd-form-group">
                            <label>Most Recent Fix</label>
                            <input type="text" name="fixed_bug" class="snbd-form-control" placeholder="e.g., Fixed alignment on order form..." value="<?php echo htmlspecialchars($customBugs['fixed_bug']); ?>">
                        </div>

                        <div class="snbd-form-group">
                            <label>Last Reported Bug</label>
                            <input type="text" name="reported_bug" class="snbd-form-control" placeholder="e.g., Client area login button broken..." value="<?php echo htmlspecialchars($customBugs['reported_bug']); ?>">
                        </div>

                        <div class="snbd-form-group">
                            <label>Reported By (Username/Name)</label>
                            <input type="text" name="reporter" class="snbd-form-control" placeholder="e.g., admin or John Doe..." value="<?php echo htmlspecialchars($customBugs['reporter']); ?>">
                        </div>

                        <button type="submit" class="snbd-btn snbd-btn-save" style="width: 100%; border: none; margin-top: 10px;">
                            <i class="fas fa-save"></i> Save Dashboard Notification Data
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="snbd-panel">
                <div class="snbd-panel-heading" style="background-color: #2980b9;">
                    <i class="fas fa-pager"></i> Client Area Dashboard Banner
                </div>
                <div class="snbd-panel-body">
                    <p style="color: #666; margin-bottom: 15px;">Configure the UX banner that appears at the top of the client dashboard. Toggle it off to hide it completely.</p>
                    <form method="post" action="<?php echo $modulelink; ?>&action=save_client_banner">
                        <div class="snbd-form-group">
                            <label><input type="checkbox" name="banner_enabled" value="1" <?php echo ($bannerData['enabled'] == '1') ? 'checked' : ''; ?>> Enable Banner</label>
                        </div>
                        <div class="snbd-form-group">
                            <label>Banner Title</label>
                            <input type="text" name="banner_title" class="snbd-form-control" placeholder="🚀 SNBD HOST Version 3.5 released..." value="<?php echo htmlspecialchars($bannerData['title']); ?>">
                        </div>
                        <div class="snbd-form-group">
                            <label>Banner Description</label>
                            <input type="text" name="banner_desc" class="snbd-form-control" placeholder="New layouts, fixes, and more..." value="<?php echo htmlspecialchars($bannerData['desc']); ?>">
                        </div>
                        <div class="snbd-form-group">
                            <label>Call to Action Link (URL)</label>
                            <input type="text" name="banner_link" class="snbd-form-control" placeholder="clientarea.php?action=devupdates" value="<?php echo htmlspecialchars($bannerData['link']); ?>">
                        </div>
                        <div class="snbd-form-group">
                            <label>Call to Action Text</label>
                            <input type="text" name="banner_link_text" class="snbd-form-control" placeholder="See More" value="<?php echo htmlspecialchars($bannerData['link_text']); ?>">
                        </div>
                        <button type="submit" class="snbd-btn" style="background-color:#2980b9; color:#fff; width: 100%; border: none; margin-top: 10px;">
                            <i class="fas fa-save"></i> Save Client Banner
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="snbd-panel">
                <div class="snbd-panel-heading" style="background: linear-gradient(135deg, #CC0000, #ff4444);">
                    <i class="fas fa-satellite-dish"></i> UptimeRobot Network Status Integration
                </div>
                <div class="snbd-panel-body">
                    <div class="snbd-info-box" style="border-left-color: #CC0000;">
                        <p style="margin: 0 0 5px 0;"><strong>UptimeRobot API Configuration</strong></p>
                        <p style="margin: 0; color: #555;">Configure your UptimeRobot Read-Only API key to power the client-facing Network Status page. The key is stored securely and used server-side to fetch monitor data.</p>
                    </div>

                    <div class="snbd-form-group">
                        <label>Current API Key</label>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <input type="text" id="ur-api-key" class="snbd-form-control" style="flex: 1; font-family: monospace;" value="<?php echo htmlspecialchars($uptimerobotApiKey); ?>" placeholder="Enter your UptimeRobot Read-Only API key...">
                            <button type="button" class="snbd-btn snbd-btn-test" id="ur-test-btn" onclick="testUptimeRobotKey()">
                                <i class="fas fa-vial"></i> Test
                            </button>
                        </div>
                        <p class="text-muted" style="font-size: 12px; margin-top: 5px;">
                            <i class="fas fa-info-circle"></i>
                            To get your key: <a href="https://uptimerobot.com/dashboard" target="_blank">UptimeRobot Dashboard</a> → My Settings → API Settings → Create read-only API key.
                        </p>
                    </div>

                    <div id="ur-test-result" class="snbd-api-status"></div>

                    <div class="alert alert-info" style="margin-top: 15px; font-size: 13px;">
                        <i class="fas fa-lightbulb"></i> <strong>Tip:</strong> To update the API key, edit it in the <a href="configaddonmods.php">Module Configuration</a> page (Add-on Modules → SNBDHost Theme Manager → Configure), then come back here to test it.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    function escapeHtml(str) {
        return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }
    function testUptimeRobotKey() {
        const key = document.getElementById('ur-api-key').value.trim();
        const resultDiv = document.getElementById('ur-test-result');
        const btn = document.getElementById('ur-test-btn');
        const originalText = btn.innerHTML;

        if (!key) {
            resultDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> Please enter an API key first.';
            resultDiv.className = 'snbd-api-status error';
            return;
        }

        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testing...';
        btn.disabled = true;
        resultDiv.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testing connection to UptimeRobot...';
        resultDiv.className = 'snbd-api-status loading';

        fetch('<?php echo $modulelink; ?>&action=test_uptimerobot', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'api_key=' + encodeURIComponent(key)
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                resultDiv.innerHTML = '<i class="fas fa-check-circle"></i> ' + data.message;
                resultDiv.className = 'snbd-api-status success';
            } else {
                let html = '<i class="fas fa-times-circle"></i> ' + data.message;
                if (data.debug) {
                    html += '<br><code style="display:block;margin-top:6px;padding:8px;background:#f5f5f5;border-radius:4px;font-size:11px;word-break:break-all;">' + escapeHtml(data.debug) + '</code>';
                }
                resultDiv.innerHTML = html;
                resultDiv.className = 'snbd-api-status error';
            }
        })
        .catch(err => {
            resultDiv.innerHTML = '<i class="fas fa-times-circle"></i> Request failed: ' + err.message;
            resultDiv.className = 'snbd-api-status error';
        })
        .finally(() => {
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    }
    </script>
    <?php
}
