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
    $message = '';
    
    if ($action === 'update_theme') {
        require_once __DIR__ . '/lib/Updater.php';
        $updater = new \SNBDHostManager\Updater($githubRepo, $githubToken);
        
        try {
            $result = $updater->updateTheme();
            $message = '<div class="alert alert-success"><strong>Success!</strong> Theme successfully updated to the latest version.</div>';
        } catch (\Exception $e) {
            $message = '<div class="alert alert-danger"><strong>Error!</strong> Failed to update theme: ' . $e->getMessage() . '</div>';
        }
    }
    
    // Output HTML
    echo $message;
    ?>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">SNBDHost Theme Management</h3>
        </div>
        <div class="panel-body">
            <p>Welcome to the SNBDHost Theme Manager. From here, you can pull the latest theme updates directly from your configured GitHub repository.</p>
            <p><strong>Configured Repository:</strong> <?php echo htmlspecialchars($githubRepo); ?></p>
            <hr>
            <h4>Update Theme</h4>
            <p>Click the button below to download the latest theme release/commits from GitHub and apply them to your WHMCS templates directory.</p>
            <a href="<?php echo $modulelink; ?>&action=update_theme" class="btn btn-primary" onclick="return confirm('Are you sure you want to update the theme? This will overwrite the current theme files in templates/snbdhost.');">
                <i class="fa fa-download"></i> Update Theme from GitHub
            </a>
        </div>
    </div>
    <?php
}
