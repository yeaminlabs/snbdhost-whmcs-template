<?php
namespace SNBDHostManager;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Module\AbstractWidget;
use WHMCS\Database\Capsule;

class SnbdhostThemeWidget extends AbstractWidget
{
    protected $title = 'SNBDHost Theme Updates & Bugs';
    protected $description = 'Displays recent theme bug fixes and provides a quick link to report new bugs.';
    protected $weight = 150;
    protected $columns = 1;
    protected $cache = false; // Disable cache for real-time updates while testing

    public function getData()
    {
        // Fetch module configuration from the database
        $config = Capsule::table('tbladdonmodules')
            ->where('module', 'snbdhost_manager')
            ->pluck('value', 'setting');

        $isDevMode = (($config['developer_mode'] ?? '') === 'on' || ($config['developer_mode'] ?? '') === '1' || ($config['developer_mode'] ?? '') === 'yes');
        if ($isDevMode) {
            return [
                'isDevMode' => true,
                'moduleLink' => 'addonmodules.php?module=snbdhost_manager'
            ];
        }

        $githubRepo = $config['github_repo'] ?? 'username/repo';
        $reportUrl = $config['bug_report_url'] ?? 'https://github.com/username/repo/issues';

        // Fetch recent releases/commits from GitHub API
        $recentFixes = [];
        
        if ($githubRepo && $githubRepo !== 'username/repo') {
            $apiUrl = "https://api.github.com/repos/{$githubRepo}/releases?per_page=3";
            
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $apiUrl);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch, CURLOPT_USERAGENT, 'WHMCS-SNBDHost-Manager');
            
            if (!empty($config['github_token'])) {
                curl_setopt($ch, CURLOPT_HTTPHEADER, [
                    'Authorization: token ' . $config['github_token']
                ]);
            }
            
            $response = curl_exec($ch);
            curl_close($ch);
            
            $releases = json_decode($response, true);
            
            if (is_array($releases) && !isset($releases['message'])) {
                foreach ($releases as $release) {
                    $recentFixes[] = [
                        'version' => $release['tag_name'] ?? 'Unknown',
                        'date' => date('M j, Y', strtotime($release['published_at'] ?? 'now')),
                        'description' => substr($release['body'] ?? 'No description provided.', 0, 100) . '...'
                    ];
                }
            } else {
                $recentFixes = [
                    ['version' => 'Error', 'date' => '', 'description' => 'Could not fetch releases. Check GitHub repo configuration.']
                ];
            }
        } else {
            // Placeholder data if not configured
            $recentFixes = [
                ['version' => 'v1.0.1', 'date' => date('M j, Y'), 'description' => 'Fixed alignment issue on the order form.'],
                ['version' => 'v1.0.0', 'date' => date('M j, Y', strtotime('-2 days')), 'description' => 'Initial theme release.']
            ];
        }

        return [
            'fixes' => $recentFixes,
            'reportUrl' => $reportUrl,
            'moduleLink' => 'addonmodules.php?module=snbdhost_manager'
        ];
    }

    public function generateOutput($data)
    {
        if (!empty($data['isDevMode'])) {
            $html = '<div class="widget-content-padded text-center">';
            $html .= '<div style="font-size: 3rem; color: #f39c12; margin-bottom: 10px;"><i class="fas fa-code"></i></div>';
            $html .= '<h4>Developer Mode Active</h4>';
            $html .= '<p class="text-muted" style="font-size: 13px; line-height: 1.5;">All theme updates, release histories, and bug logs are hidden. Developers are asked to make custom additions compatible with the theme layout.</p>';
            $html .= '<div style="margin-top: 15px;">';
            $html .= '<a href="' . htmlspecialchars($data['moduleLink']) . '" class="btn btn-warning btn-sm btn-block"><i class="fas fa-tools"></i> Manage Module Settings</a>';
            $html .= '</div>';
            $html .= '</div>';
            return $html;
        }

        $html = '<div class="widget-content-padded">';
        
        $html .= '<h5>Recent Bug Fixes</h5>';
        $html .= '<ul style="list-style-type: none; padding-left: 0;">';
        
        foreach ($data['fixes'] as $fix) {
            $html .= '<li style="margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 5px;">';
            $html .= '<strong>' . htmlspecialchars($fix['version']) . '</strong> - <small class="text-muted">' . htmlspecialchars($fix['date']) . '</small><br>';
            $html .= '<span>' . htmlspecialchars($fix['description']) . '</span>';
            $html .= '</li>';
        }
        $html .= '</ul>';

        $html .= '<div style="margin-top: 15px; display: flex; justify-content: space-between;">';
        $html .= '<a href="' . htmlspecialchars($data['reportUrl']) . '" target="_blank" class="btn btn-danger btn-sm"><i class="fas fa-bug"></i> Report a Bug</a>';
        $html .= '<a href="' . htmlspecialchars($data['moduleLink']) . '" class="btn btn-primary btn-sm"><i class="fas fa-sync"></i> Theme Manager</a>';
        $html .= '</div>';

        $html .= '</div>';

        return $html;
    }
}
