<?php
namespace SNBDHostManager;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

class DashboardTopNotice
{
    private $githubRepo;
    private $githubToken;

    public function __construct()
    {
        // Try to fetch settings from module configuration
        try {
            $moduleConfig = Capsule::table('tbladdonmodules')
                ->where('module', 'snbdhost_manager')
                ->get();
                
            foreach ($moduleConfig as $setting) {
                if ($setting->setting === 'github_repo') {
                    $this->githubRepo = $setting->value;
                } elseif ($setting->setting === 'github_token') {
                    $this->githubToken = $setting->value;
                }
            }
        } catch (\Exception $e) {
            // DB error
        }
    }

    public function render()
    {
        if (empty($this->githubRepo)) {
            return '<script>console.error("SNBDHost Manager: githubRepo is empty in DB query.");</script>';
        }

        $latestVersion = 'Unknown';
        $latestFix = 'No recent fixes found.';
        $latestBuild = 'Unknown';
        $lastReportedBug = null;

        // 1. Fetch Latest Commit/Build from GitHub API
        $apiUrl = "https://api.github.com/repos/" . $this->githubRepo . "/commits/main";
        $ch = curl_init($apiUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_USERAGENT, 'SNBDHost-Theme-Manager');
        if (!empty($this->githubToken)) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Authorization: token ' . $this->githubToken
            ]);
        }
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode === 200 && $response) {
            $data = json_decode($response, true);
            if (isset($data['sha'])) {
                $latestBuild = substr($data['sha'], 0, 7);
            }
        }

        // 2. Fetch Changelog from GitHub Raw
        $rawUrl = "https://raw.githubusercontent.com/" . $this->githubRepo . "/main/CHANGELOG.md";
        $chRaw = curl_init($rawUrl);
        curl_setopt($chRaw, CURLOPT_RETURNTRANSFER, true);
        if (!empty($this->githubToken)) {
            curl_setopt($chRaw, CURLOPT_HTTPHEADER, [
                'Authorization: token ' . $this->githubToken
            ]);
        }
        $changelogContent = curl_exec($chRaw);
        $httpCodeRaw = curl_getinfo($chRaw, CURLINFO_HTTP_CODE);
        curl_close($chRaw);

        if ($httpCodeRaw === 200 && $changelogContent) {
            // Parse version number (e.g., ## [1.0.3])
            if (preg_match('/## \[([^\]]+)\]/', $changelogContent, $matches)) {
                $latestVersion = $matches[1];
            }
            
            // Parse latest fixed bug
            // Find the first block of text under "### Fixed" before the next heading
            if (preg_match('/### Fixed\s*\n(.*?)(?:\n##|\n###|\Z)/s', $changelogContent, $fixMatches)) {
                $fixes = array_filter(explode("\n", trim($fixMatches[1])));
                if (count($fixes) > 0) {
                    $latestFix = ltrim(reset($fixes), '- ');
                }
            }
        }

        // 3. Fetch Last Bug Reported from local theme_changes.json
        $logFilePath = defined('ROOTDIR') ? ROOTDIR . '/templates/snbdhost/theme_changes.json' : __DIR__ . '/../../../../templates/snbdhost/theme_changes.json';
        if (file_exists($logFilePath)) {
            $logs = json_decode(file_get_contents($logFilePath), true);
            if (is_array($logs) && count($logs) > 0) {
                $lastReportedBug = $logs[0]; // Gets the most recent entry
            }
        }

        // 4. Override with Custom Bugs from the Manager Module if set
        $customBugsFile = __DIR__ . '/../custom_bugs.json';
        if (file_exists($customBugsFile)) {
            $customBugs = json_decode(file_get_contents($customBugsFile), true);
            if (!empty($customBugs['fixed_bug'])) {
                $latestFix = $customBugs['fixed_bug'];
            }
            if (!empty($customBugs['reported_bug'])) {
                $lastReportedBug = [
                    'reason' => $customBugs['reported_bug'],
                    'admin_username' => !empty($customBugs['reporter']) ? $customBugs['reporter'] : 'Admin',
                    'timestamp' => date('Y-m-d H:i:s')
                ];
            }
        }

        // Render the HTML
        $html = '
        <div style="margin: 15px 0 25px 0;">
            <div class="panel panel-info" style="border: 1px solid #111; box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden;">
                <div class="panel-heading" style="background-color: #CC0000; color: #fff; padding: 15px; font-size: 16px; border-bottom: none; border-radius: 8px 8px 0 0;">
                    <i class="fas fa-bullhorn" style="margin-right: 8px;"></i> <strong>Important SNBDHost Theme Updates</strong>
                </div>
                <div class="panel-body" style="background-color: #fff; padding: 20px;">
                    <div class="row">
                        <div class="col-md-3" style="border-right: 1px solid #eee;">
                            <h5 style="color: #666; font-size: 13px; text-transform: uppercase; font-weight: bold; margin-top: 0;">Theme Details</h5>
                            <p style="font-size: 15px;"><strong>SNBDHost Portal Template</strong></p>
                            <p style="margin: 0; color: #555;">Version: <span class="label label-primary" style="background-color: #111;">v' . htmlspecialchars($latestVersion) . '</span></p>
                            <p style="margin: 5px 0 0 0; color: #555;">Build: <span style="font-family: monospace;">' . htmlspecialchars($latestBuild) . '</span></p>
                        </div>
                        <div class="col-md-9">';
        
        if ($lastReportedBug) {
            $html .= '
                            <div class="alert alert-warning" style="margin-bottom: 15px; border-left: 4px solid #f39c12; background-color: #fdfaf2;">
                                <i class="fas fa-bug" style="color: #f39c12; margin-right: 5px;"></i> 
                                <strong>Last Reported Bug:</strong> ' . htmlspecialchars($lastReportedBug['reason']) . '
                                <div style="margin-top: 5px; font-size: 12px; color: #888;">
                                    Reported by <strong style="color: #333;">' . htmlspecialchars($lastReportedBug['admin_username']) . '</strong> on ' . date('M jS, Y h:i A', strtotime($lastReportedBug['timestamp'])) . '
                                </div>
                            </div>';
        } else {
            $html .= '
                            <div class="alert alert-success" style="margin-bottom: 15px; border-left: 4px solid #2ecc71;">
                                <i class="fas fa-check-circle" style="color: #2ecc71; margin-right: 5px;"></i> 
                                <strong>System Status:</strong> No recent bugs reported.
                            </div>';
        }

        $html .= '
                            <div class="alert alert-success" style="margin-bottom: 0; border-left: 4px solid #2ecc71; background-color: #f4fdf8;">
                                <i class="fas fa-wrench" style="color: #2ecc71; margin-right: 5px;"></i> 
                                <strong>Most Recent Fix:</strong> ' . htmlspecialchars($latestFix) . '
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>';

        // Escape the HTML for JS injection
        $htmlEscaped = json_encode($html);

        $js = '
        <script>
        jQuery(document).ready(function($) {
            var noticeHtml = ' . $htmlEscaped . ';
            // Try to find the dashboard widgets row, otherwise fallback to main content area
            var widgetContainer = $(\'.row.dashboard-widgets, #widgetRow, .widgets-container\').first();
            if (widgetContainer.length > 0) {
                widgetContainer.before(noticeHtml);
            } else {
                var mainContent = $(\'#contentarea, .contentarea, .main-content\').first();
                if (mainContent.length > 0) {
                    mainContent.prepend(noticeHtml);
                } else {
                    $(\'body\').prepend(noticeHtml);
                }
            }
        });
        </script>
        ';

        return $js;
    }
}
