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
        'description' => 'Manages the SNBDHost WHMCS Theme, displays changelog on the admin dashboard, and provides one-click updates from GitHub.',
        'author' => 'SNBDHost',
        'language' => 'english',
        'version' => '1.0',
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
        ]
    ];
}

function snbdhost_manager_activate()
{
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
    
    // Process update action
    $action = isset($_GET['action']) ? $_GET['action'] : '';
    $updateType = isset($_GET['type']) ? $_GET['type'] : 'all';
    $message = '';
    
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
        .snbd-info-box {
            background: #f9f9f9;
            border-left: 4px solid #111;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
    </style>
    
    <div class="snbd-panel">
        <div class="snbd-panel-heading">
            <i class="fas fa-paint-brush"></i> SNBDHost Theme Management
        </div>
        <div class="snbd-panel-body">
            <div class="snbd-info-box">
                <p style="margin: 0 0 5px 0;"><strong>Welcome to the SNBDHost Theme Manager.</strong></p>
                <p style="margin: 0; color: #555;">From here, you can pull the latest updates directly from your configured GitHub repository. You can choose to update just the theme files or just the manager module itself.</p>
            </div>
            
            <p><strong>Configured Repository:</strong> <code><?php echo htmlspecialchars($githubRepo); ?></code></p>
            <hr style="border-top: 1px solid #eee;">
            
            <h4 style="color: #CC0000; font-weight: 600;">Available Updates</h4>
            <p>Select which component you would like to update from GitHub:</p>
            
            <div class="snbd-btn-group">
                <a href="<?php echo $modulelink; ?>&action=update_theme&type=theme" class="snbd-btn snbd-btn-theme" onclick="return confirm('Are you sure you want to update the Theme? This will overwrite your current theme files in templates/snbdhost.');">
                    <i class="fas fa-download"></i> Update Theme Only
                </a>
                
                <a href="<?php echo $modulelink; ?>&action=update_theme&type=module" class="snbd-btn snbd-btn-module" onclick="return confirm('Are you sure you want to update the Manager Module? This will overwrite the module files.');">
                    <i class="fas fa-sync"></i> Update Manager Module Only
                </a>
            </div>
        </div>
    </div>
    <?php
}
