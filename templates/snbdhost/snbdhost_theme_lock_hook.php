<?php
/**
 * SNBD Host Theme Lock and Auditing Hook
 * 
 * Intercepts theme/template changes in the WHMCS admin panel (General Settings tab),
 * requiring a verification popup for the admin to provide a reason for the change.
 * Saves the reason to the System Activity Log and locks direct backend POST bypasses.
 * 
 * INSTALLATION: Copy this file to your WHMCS directory: /includes/hooks/snbdhost_theme_lock_hook.php
 *
 * @package    WHMCS
 * @author     SNBD Host Team
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

// Make sure session is initialized
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// Check for Developer Mode in database (bypasses theme lock verification)
try {
    $devModeSetting = Capsule::table('tbladdonmodules')
        ->where('module', 'snbdhost_manager')
        ->where('setting', 'developer_mode')
        ->value('value');
    $isDevMode = ($devModeSetting === 'on' || $devModeSetting === '1' || $devModeSetting === 'yes');
    if ($isDevMode) {
        return; // Exit file execution, no hooks will be registered
    }
} catch (\Exception $e) {
    // Fail silent
}

/**
 * Hook 1: Intercept AJAX requests and enforce Server-side validation on Page Load
 */
add_hook('AdminAreaPage', 1, function($vars) {
    
    // 1. Handle AJAX authorization requests from our popup modal
    if (isset($_REQUEST['snbd_theme_lock_action']) && $_REQUEST['snbd_theme_lock_action'] === 'authorize') {
        // Clear any previous output buffers
        if (ob_get_level()) {
            ob_clean();
        }
        header('Content-Type: application/json');
        
        $reason = isset($_POST['reason']) ? trim($_POST['reason']) : '';
        $oldTheme = isset($_POST['old_theme']) ? trim($_POST['old_theme']) : '';
        $newTheme = isset($_POST['new_theme']) ? trim($_POST['new_theme']) : '';
        
        if (empty($reason)) {
            echo json_encode(['status' => 'error', 'message' => 'A reason is required to change the theme.']);
            exit;
        }
        
        // Fetch logged-in admin username
        $adminId = isset($_SESSION['adminid']) ? (int)$_SESSION['adminid'] : 0;
        $adminUsername = 'Unknown Admin';
        $adminEmail = '';
        if ($adminId > 0) {
            try {
                $admin = Capsule::table('tbladmins')->where('id', $adminId)->first();
                if ($admin) {
                    $adminUsername = $admin->username;
                    $adminEmail = $admin->email;
                }
            } catch (\Exception $e) {
                // Fail-safe default
            }
        }
        
        // Log the activity to the WHMCS System Activity Log
        $logMessage = sprintf(
            "Theme Change Authorized: Admin '%s' changed client area template from '%s' to '%s'. Reason: %s",
            $adminUsername,
            $oldTheme,
            $newTheme,
            $reason
        );
        logActivity($logMessage);

        // Get Admin IP Address safely (resolves Cloudflare/Proxy IPs)
        $ipAddress = 'Unknown IP';
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            $ipAddress = $_SERVER['HTTP_CLIENT_IP'];
        } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ipAddress = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR'])[0];
        } elseif (!empty($_SERVER['REMOTE_ADDR'])) {
            $ipAddress = $_SERVER['REMOTE_ADDR'];
        }
        $ipAddress = trim($ipAddress);

        // Log to external JSON file for React Dashboard API consumption
        try {
            $logFilePath = defined('ROOTDIR') ? ROOTDIR . '/templates/snbdhost/theme_changes.json' : __DIR__ . '/theme_changes.json';
            
            $logEntry = [
                'timestamp'      => date('c'), // ISO 8601 format
                'admin_id'       => $adminId,
                'admin_username' => $adminUsername,
                'admin_email'    => $adminEmail,
                'ip_address'     => $ipAddress,
                'old_theme'      => $oldTheme,
                'new_theme'      => $newTheme,
                'reason'         => $reason
            ];
            
            $existingLogs = [];
            if (file_exists($logFilePath)) {
                $fileContent = file_get_contents($logFilePath);
                $existingLogs = json_decode($fileContent, true) ?: [];
            }
            
            // Prepend new logs to put latest changes at the top
            array_unshift($existingLogs, $logEntry);
            
            // Limit log entries to top 100 to prevent file bloat
            if (count($existingLogs) > 100) {
                $existingLogs = array_slice($existingLogs, 0, 100);
            }
            
            file_put_contents($logFilePath, json_encode($existingLogs, JSON_PRETTY_PRINT), LOCK_EX);
        } catch (\Exception $e) {
            // Fail silent to prevent blocking page save if filesystem writes fail
        }
        
        // Set session authorization flag
        $_SESSION['snbd_theme_change_authorized'] = true;
        $_SESSION['snbd_theme_change_reason'] = $reason;
        
        echo json_encode(['status' => 'success']);
        exit;
    }
    
    // 2. Server-side Enforcement: Block POST requests to change theme if unauthorized (bypassed JS)
    $requestUri = $_SERVER['REQUEST_URI'];
    $isSaveAction = (strpos($requestUri, 'action=save') !== false || (isset($_GET['action']) && $_GET['action'] === 'save'));
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && $isSaveAction && isset($_POST['template'])) {
        $newTemplate = trim($_POST['template']);
        
        try {
            // Fetch the currently active template from database
            $currentTemplate = Capsule::table('tblconfiguration')->where('setting', 'Template')->value('value');
            
            if ($newTemplate !== $currentTemplate) {
                // An admin is attempting to change the theme! Check for session authorization token.
                if (!isset($_SESSION['snbd_theme_change_authorized']) || $_SESSION['snbd_theme_change_authorized'] !== true) {
                    // Block the change and redirect back to General Settings with a warning flag
                    $_SESSION['snbd_theme_change_blocked'] = true;
                    header('Location: configgeneral.php?theme_change_blocked=1');
                    exit;
                } else {
                    // Authorized! Clear the token so it cannot be reused in subsequent requests
                    unset($_SESSION['snbd_theme_change_authorized']);
                }
            }
        } catch (\Exception $e) {
            // Database fail-safe
        }
    }
});

/**
 * Hook 2: Inject Modal HTML/CSS and Interceptor JavaScript into the page footer
 */
add_hook('AdminAreaFooterOutput', 1, function($vars) {
    // Only target the configgeneral settings page
    if ($vars['filename'] !== 'configgeneral') {
        return '';
    }
    
    // Generate JS/HTML/CSS payload
    $output = '';
    
    // Inject the Modal CSS
    $output .= '
    <style>
    .snbd-modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(15, 23, 42, 0.45);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        z-index: 999999;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.25s ease;
    }
    .snbd-modal-overlay.active {
        opacity: 1;
    }
    .snbd-modal-card {
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        width: 100%;
        max-width: 520px;
        padding: 30px;
        border: 1px solid rgba(229, 57, 53, 0.15);
        transform: scale(0.95);
        transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
        box-sizing: border-box;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    .snbd-modal-overlay.active .snbd-modal-card {
        transform: scale(1);
    }
    .snbd-modal-header {
        text-align: center;
        margin-bottom: 24px;
    }
    .snbd-modal-icon {
        width: 60px;
        height: 60px;
        background: rgba(229, 57, 53, 0.08);
        color: #e53935;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
        margin: 0 auto 16px auto;
        border: 2px solid rgba(229, 57, 53, 0.1);
    }
    .snbd-modal-header h3 {
        margin: 0 0 8px 0;
        color: #1a1a1a;
        font-size: 20px;
        font-weight: 700;
        line-height: 1.2;
    }
    .snbd-modal-header p {
        margin: 0;
        color: #64748b;
        font-size: 14px;
        line-height: 1.5;
    }
    .snbd-theme-diff {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: #f8fafc;
        border-radius: 12px;
        padding: 16px;
        margin-bottom: 20px;
        border: 1px solid #e2e8f0;
    }
    .theme-badge {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .badge-label {
        font-size: 10px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: #94a3b8;
        margin-bottom: 4px;
        font-weight: 600;
    }
    .theme-name {
        font-size: 14px;
        font-weight: 700;
        color: #1e293b;
    }
    .old-theme .theme-name {
        color: #64748b;
    }
    .new-theme .theme-name {
        color: #e53935;
    }
    .theme-arrow {
        padding: 0 10px;
        color: #94a3b8;
        font-size: 16px;
    }
    .snbd-input-label {
        display: block;
        font-size: 13px;
        font-weight: 600;
        color: #334155;
        margin-bottom: 8px;
    }
    .snbd-input-label .required {
        color: #e53935;
    }
    .snbd-textarea {
        width: 100%;
        height: 110px;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid #cbd5e1;
        font-size: 14px;
        line-height: 1.5;
        resize: none;
        box-sizing: border-box;
        transition: border-color 0.2s, box-shadow 0.2s;
        color: #1e293b;
        background-color: #ffffff;
    }
    .snbd-textarea:focus {
        outline: none;
        border-color: #e53935;
        box-shadow: 0 0 0 3px rgba(229, 57, 53, 0.15);
    }
    .snbd-error-msg {
        margin-top: 10px;
        color: #ef4444;
        background: #fef2f2;
        border: 1px solid #fee2e2;
        padding: 10px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
    }
    .snbd-modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 24px;
    }
    .snbd-btn {
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        border: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }
    .snbd-btn-secondary {
        background: #f1f5f9;
        color: #475569;
    }
    .snbd-btn-secondary:hover {
        background: #e2e8f0;
        color: #334155;
    }
    .snbd-btn-primary {
        background: #e53935;
        color: #ffffff;
    }
    .snbd-btn-primary:hover {
        background: #c62828;
    }
    .snbd-btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }
    </style>
    ';
    
    // Inject the Modal HTML Structure
    $output .= '
    <div id="snbdThemeLockModal" class="snbd-modal-overlay" style="display: none;">
        <div class="snbd-modal-card">
            <div class="snbd-modal-header">
                <div class="snbd-modal-icon">
                    <i class="fa fa-shield-alt"></i>
                </div>
                <h3>Theme Change Verification</h3>
                <p>You are changing the active client theme. Since template updates can impact live client operations, please provide a justification for this change.</p>
            </div>
            <div class="snbd-theme-diff">
                <div class="theme-badge old-theme">
                    <span class="badge-label">Active Theme</span>
                    <span class="theme-name" id="snbd-old-theme-lbl">—</span>
                </div>
                <div class="theme-arrow">
                    <i class="fa fa-arrow-right"></i>
                </div>
                <div class="theme-badge new-theme">
                    <span class="badge-label">New Theme</span>
                    <span class="theme-name" id="snbd-new-theme-lbl">—</span>
                </div>
            </div>
            
            <div class="snbd-modal-body">
                <label for="snbdThemeReason" class="snbd-input-label">Reason / Bug Reference <span class="required">*</span></label>
                <textarea id="snbdThemeReason" class="snbd-textarea" placeholder="e.g., Troubleshooting checkout bugs in snbdhost theme; reverting temporarily to standard twenty-one theme."></textarea>
                <div id="snbdModalError" class="snbd-error-msg" style="display: none;"></div>
            </div>
            <div class="snbd-modal-footer">
                <button type="button" id="snbdModalCancelBtn" class="snbd-btn snbd-btn-secondary">Cancel</button>
                <button type="button" id="snbdModalSubmitBtn" class="snbd-btn snbd-btn-primary">
                    <span class="btn-text">Confirm & Save</span>
                    <span class="btn-spinner" style="display: none;"><i class="fa fa-spinner fa-spin"></i></span>
                </button>
            </div>
        </div>
    </div>
    ';
    
    // Inject the Interception JavaScript
    $output .= '
    <script>
    jQuery(document).ready(function($) {
        var templateSelect = $(\'select[name="template"]\');
        if (templateSelect.length === 0) {
            return;
        }
        
        var initialTemplate = templateSelect.val();
        var isAuthorized = false;
        var modalOverlay = $(\'#snbdThemeLockModal\');
        var submitBtn = $(\'#snbdModalSubmitBtn\');
        var errorContainer = $(\'#snbdModalError\');
        
        // Intercept form submission
        var parentForm = templateSelect.closest(\'form\');
        
        parentForm.on(\'submit\', function(e) {
            var currentTemplate = templateSelect.val();
            
            if (currentTemplate !== initialTemplate) {
                if (isAuthorized) {
                    return true;
                }
                
                e.preventDefault();
                
                // Get display names
                var oldText = templateSelect.find(\'option[value="\' + initialTemplate + \'"]\').text().trim() || initialTemplate;
                var newText = templateSelect.find(\'option:selected\').text().trim() || currentTemplate;
                
                $(\'#snbd-old-theme-lbl\').text(oldText);
                $(\'#snbd-new-theme-lbl\').text(newText);
                
                // Show modal
                modalOverlay.show();
                setTimeout(function() {
                    modalOverlay.addClass(\'active\');
                    $(\'#snbdThemeReason\').focus();
                }, 10);
                
                return false;
            }
            return true;
        });
        
        // Cancel Action
        $(\'#snbdModalCancelBtn\').on(\'click\', function() {
            // Reset template select to original
            templateSelect.val(initialTemplate);
            if (typeof templateSelect.trigger === \'function\') {
                templateSelect.trigger(\'change\');
            }
            closeModal();
        });
        
        // Submit & Authorize Action
        submitBtn.on(\'click\', function() {
            var reason = $(\'#snbdThemeReason\').val().trim();
            var currentTemplate = templateSelect.val();
            
            if (!reason) {
                showError("Please enter a reason or bug reference details.");
                return;
            }
            
            // Disable buttons and show loading spinner
            submitBtn.prop(\'disabled\', true);
            $(\'#snbdModalCancelBtn\').prop(\'disabled\', true);
            submitBtn.find(\'.btn-text\').css(\'opacity\', \'0\');
            submitBtn.find(\'.btn-spinner\').show();
            errorContainer.hide();
            
            // Call authorize endpoint via AJAX
            $.ajax({
                url: \'configgeneral.php\',
                type: \'POST\',
                data: {
                    snbd_theme_lock_action: \'authorize\',
                    reason: reason,
                    old_theme: initialTemplate,
                    new_theme: currentTemplate
                },
                dataType: \'json\',
                success: function(response) {
                    if (response.status === \'success\') {
                        isAuthorized = true;
                        // Submit parent form
                        parentForm.submit();
                    } else {
                        showError(response.message || "An error occurred during verification.");
                        resetButtons();
                    }
                },
                error: function() {
                    showError("AJAX request failed. Make sure you are authenticated.");
                    resetButtons();
                }
            });
        });
        
        function closeModal() {
            modalOverlay.removeClass(\'active\');
            setTimeout(function() {
                modalOverlay.hide();
                $(\'#snbdThemeReason\').val(\'\');
                errorContainer.hide();
            }, 250);
        }
        
        function showError(msg) {
            errorContainer.text(msg).slideDown(200);
        }
        
        function resetButtons() {
            submitBtn.prop(\'disabled\', false);
            $(\'#snbdModalCancelBtn\').prop(\'disabled\', false);
            submitBtn.find(\'.btn-text\').css(\'opacity\', \'1\');
            submitBtn.find(\'.btn-spinner\').hide();
        }
    });
    </script>
    ';
    
    // Inject server-side bypass warning banner if active
    if (isset($_SESSION['snbd_theme_change_blocked'])) {
        unset($_SESSION['snbd_theme_change_blocked']);
        $output .= '
        <script>
        jQuery(document).ready(function($) {
            var errorHtml = \'<div class="alert alert-danger" style="margin: 20px 0; font-weight: bold; border-left: 5px solid #d9534f; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); font-family: sans-serif;">\' +
                            \'<i class="fa fa-exclamation-triangle" style="margin-right: 8px;"></i> Security Block: Theme change was rejected because a justification reason was not provided. Please use the popup dialog to confirm theme changes.\' +
                            \'</div>\';
            var mainContent = $(\'#contentarea, .contentarea, .main-content\').first();
            if (mainContent.length > 0) {
                mainContent.prepend(errorHtml);
            } else {
                $(\'body\').prepend(errorHtml);
            }
        });
        </script>
        ';
    }
    
    return $output;
});
