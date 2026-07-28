<?php
/**
 * SNBDHost Theme Manager Hooks
 */

use Illuminate\Database\Capsule\Manager as Capsule;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

// Require the widget class
require_once __DIR__ . '/lib/SnbdhostThemeWidget.php';

// Require the top notice class
require_once __DIR__ . '/lib/DashboardTopNotice.php';

/**
 * Expose Google Client ID to Smarty templates for custom Google Sign-In
 */
add_hook('ClientAreaPage', 1, function($vars) {
    if (isset($_POST['snbd_action']) && $_POST['snbd_action'] === 'save_profile' && !empty($_SESSION['uid'])) {
        header('Content-Type: application/json');
        
        $phone = trim($_POST['phonenumber'] ?? '');
        $address1 = trim($_POST['address1'] ?? '');
        $city = trim($_POST['city'] ?? '');
        $state = trim($_POST['state'] ?? '');
        $postcode = trim($_POST['postcode'] ?? '');
        $country = trim($_POST['country'] ?? '');
        
        if (empty($phone) || empty($address1) || empty($city) || empty($state) || empty($postcode) || empty($country)) {
            echo json_encode(['success' => false, 'message' => 'All fields are required.']);
            exit;
        }
        
        if ($phone === '+00000000000' || strtolower($address1) === 'pending completion') {
            echo json_encode(['success' => false, 'message' => 'Please provide valid profile details.']);
            exit;
        }
        
        $result = localAPI('UpdateClient', [
            'clientid' => $_SESSION['uid'],
            'phonenumber' => $phone,
            'address1' => $address1,
            'city' => $city,
            'state' => $state,
            'postcode' => $postcode,
            'country' => $country
        ]);
        
        if ($result['result'] === 'success') {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'message' => $result['message'] ?? 'Failed to update profile.']);
        }
        exit;
    }

    if (in_array($vars['templatefile'], ['login', 'clientregister'])) {
        $setting = Capsule::table('tbladdonmodules')
            ->where('module', 'snbdhost_manager')
            ->where('setting', 'google_client_id')
            ->first();
            
        $clientId = $setting ? $setting->value : '219815663641-p50rq613ol3ilqgbotogg4bb4hvg9s1e.apps.googleusercontent.com';
        
        return [
            'googleClientId' => $clientId
        ];
    }
});

/**
 * Hide "Security Settings" for accounts still carrying OAuth placeholder
 * profile data (phone/address never completed by the user).
 */
add_hook('ClientAreaPrimarySidebar', 1, function ($primarySidebar) {
    if (empty($_SESSION['uid'])) {
        return;
    }

    $client = Capsule::table('tblclients')->where('id', $_SESSION['uid'])->first();
    if ($client && ($client->phonenumber === '+00000000000' || $client->address1 === 'Pending Completion')) {
        $myAccount = $primarySidebar->getChild('My Account');
        if ($myAccount) {
            $myAccount->removeChild('Security Settings');
        }
    }
});

add_hook('AdminHomeWidgets', 1, function() {
    return new \SNBDHostManager\SnbdhostThemeWidget();
});

add_hook('AdminAreaFooterOutput', 1, function($vars) {
    if (isset($vars['filename']) && $vars['filename'] !== 'index') {
        return '';
    }
    $notice = new \SNBDHostManager\DashboardTopNotice();
    return $notice->render();
});

add_hook('ClientAreaPageHome', 1, function($vars) {
    // Check developer mode
    $isDevMode = false;
    try {
        $devModeSetting = Capsule::table('tbladdonmodules')
            ->where('module', 'snbdhost_manager')
            ->where('setting', 'developer_mode')
            ->value('value');
        $isDevMode = ($devModeSetting === 'on' || $devModeSetting === '1' || $devModeSetting === 'yes');
    } catch (\Exception $e) {
        // DB error
    }

    if ($isDevMode) {
        return [
            'snbdBannerEnabled' => '1',
            'snbdBannerTitle' => '🛠️ Developer Mode Active',
            'snbdBannerDesc' => 'Developer Mode is enabled. Developers are asked to work on things making them compatible with this theme.',
            'snbdBannerLink' => '#',
            'snbdBannerLinkText' => 'Developer Mode',
            'snbdBannerIcon' => 'fas fa-code'
        ];
    }

    $bannerData = ['enabled' => '1', 'title' => '', 'desc' => '', 'link' => '', 'link_text' => ''];
    if (file_exists(__DIR__ . '/client_banner.json')) {
        $data = json_decode(file_get_contents(__DIR__ . '/client_banner.json'), true);
        if (is_array($data)) {
            $bannerData = $data;
        }
    }
    return [
        'snbdBannerEnabled' => $bannerData['enabled'],
        'snbdBannerTitle' => $bannerData['title'],
        'snbdBannerDesc' => $bannerData['desc'],
        'snbdBannerLink' => $bannerData['link'],
        'snbdBannerLinkText' => $bannerData['link_text']
    ];
});

/**
 * Render profile completion modal on clientarea dashboard if placeholders exist.
 */
add_hook('ClientAreaFooterOutput', 1, function($vars) {
    if (empty($_SESSION['uid'])) {
        return '';
    }
    
    if (($vars['templatefile'] ?? '') !== 'clientareahome') {
        return '';
    }
    
    $client = Capsule::table('tblclients')->where('id', $_SESSION['uid'])->first();
    if (!$client) {
        return '';
    }
    
    $needsUpdate = ($client->phonenumber === '+00000000000' || $client->address1 === 'Pending Completion' || empty($client->phonenumber) || empty($client->address1));
    
    if (!$needsUpdate) {
        return '';
    }
    
    $prefillPhone = ($client->phonenumber === '+00000000000') ? '' : htmlspecialchars($client->phonenumber, ENT_QUOTES);
    $prefillAddress1 = ($client->address1 === 'Pending Completion') ? '' : htmlspecialchars($client->address1, ENT_QUOTES);
    $prefillCity = ($client->city === 'N/A') ? '' : htmlspecialchars($client->city, ENT_QUOTES);
    $prefillState = ($client->state === 'N/A') ? '' : htmlspecialchars($client->state, ENT_QUOTES);
    $prefillPostcode = ($client->postcode === '0000') ? '' : htmlspecialchars($client->postcode, ENT_QUOTES);
    $prefillCountry = htmlspecialchars($client->country, ENT_QUOTES);
    
    ob_start();
    ?>
    <style>
        .snbd-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(10, 10, 10, 0.75);
            backdrop-filter: blur(8px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 999999;
        }
        .snbd-modal-container {
            background: rgba(20, 20, 20, 0.95);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            padding: 30px;
            width: 480px;
            max-width: 90%;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.6);
            font-family: 'Outfit', 'Inter', sans-serif;
            color: #fff;
        }
        .snbd-modal-header h3 {
            margin-top: 0;
            margin-bottom: 8px;
            font-size: 22px;
            font-weight: 600;
            background: linear-gradient(135deg, #ff416c, #ff4b2b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .snbd-modal-header p {
            margin: 0 0 20px 0;
            font-size: 13px;
            color: #aaa;
            line-height: 1.5;
        }
        .snbd-form-group {
            margin-bottom: 15px;
        }
        .snbd-form-group label {
            display: block;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            color: #ccc;
        }
        .snbd-form-group input, .snbd-form-group select {
            width: 100%;
            padding: 11px 12px;
            background: rgba(30, 30, 30, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }
        .snbd-form-group input::placeholder {
            color: #555;
        }
        .snbd-form-group input:focus, .snbd-form-group select:focus {
            outline: none;
            border-color: #ff4b2b;
            box-shadow: 0 0 8px rgba(255, 75, 43, 0.4);
        }
        .snbd-form-row {
            display: flex;
            gap: 15px;
        }
        .snbd-col-6 {
            flex: 1;
        }
        .snbd-error-msg {
            color: #ff4d4d;
            font-size: 13px;
            margin-bottom: 15px;
            display: none;
        }
        .snbd-modal-footer button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #8a0f18, #d32f2f);
            border: none;
            border-radius: 8px;
            color: #fff;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .snbd-modal-footer button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(211, 47, 47, 0.4);
        }
        .snbd-modal-footer button:disabled {
            background: #555;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
    </style>
    <div id="snbd-profile-completion-modal" class="snbd-modal-overlay">
        <div class="snbd-modal-container">
            <div class="snbd-modal-header">
                <h3>Complete Your Profile</h3>
                <p>Welcome to SNBD HOST! Please provide a valid phone number and billing address to proceed to your dashboard.</p>
            </div>
            <form id="snbd-profile-completion-form">
                <div class="snbd-form-group">
                    <label for="snbd-phone">Phone Number</label>
                    <input type="text" id="snbd-phone" name="phonenumber" value="<?php echo $prefillPhone; ?>" placeholder="e.g. +88017XXXXXXXX" required>
                </div>
                <div class="snbd-form-group">
                    <label for="snbd-address1">Address Line 1</label>
                    <input type="text" id="snbd-address1" name="address1" value="<?php echo $prefillAddress1; ?>" placeholder="Street Address" required>
                </div>
                <div class="snbd-form-row">
                    <div class="snbd-form-group snbd-col-6">
                        <label for="snbd-city">City</label>
                        <input type="text" id="snbd-city" name="city" value="<?php echo $prefillCity; ?>" placeholder="City" required>
                    </div>
                    <div class="snbd-form-group snbd-col-6">
                        <label for="snbd-state">State / Region</label>
                        <input type="text" id="snbd-state" name="state" value="<?php echo $prefillState; ?>" placeholder="State" required>
                    </div>
                </div>
                <div class="snbd-form-row">
                    <div class="snbd-form-group snbd-col-6">
                        <label for="snbd-postcode">Postcode / ZIP</label>
                        <input type="text" id="snbd-postcode" name="postcode" value="<?php echo $prefillPostcode; ?>" placeholder="Postcode" required>
                    </div>
                    <div class="snbd-form-group snbd-col-6">
                        <label for="snbd-country">Country</label>
                        <select id="snbd-country" name="country" required>
                            <option value="BD" <?php echo ($prefillCountry === 'BD' || empty($prefillCountry)) ? 'selected' : ''; ?>>Bangladesh</option>
                            <option value="US" <?php echo ($prefillCountry === 'US') ? 'selected' : ''; ?>>United States</option>
                            <option value="GB" <?php echo ($prefillCountry === 'GB') ? 'selected' : ''; ?>>United Kingdom</option>
                            <option value="CA" <?php echo ($prefillCountry === 'CA') ? 'selected' : ''; ?>>Canada</option>
                            <option value="AU" <?php echo ($prefillCountry === 'AU') ? 'selected' : ''; ?>>Australia</option>
                            <option value="IN" <?php echo ($prefillCountry === 'IN') ? 'selected' : ''; ?>>India</option>
                            <option value="SG" <?php echo ($prefillCountry === 'SG') ? 'selected' : ''; ?>>Singapore</option>
                            <option value="MY" <?php echo ($prefillCountry === 'MY') ? 'selected' : ''; ?>>Malaysia</option>
                        </select>
                    </div>
                </div>
                <div class="snbd-error-msg" id="snbd-modal-error"></div>
                <div class="snbd-modal-footer">
                    <button type="submit" id="snbd-save-btn">Save & Continue</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        document.getElementById('snbd-profile-completion-form').addEventListener('submit', function(e) {
            e.preventDefault();
            var btn = document.getElementById('snbd-save-btn');
            var errorDiv = document.getElementById('snbd-modal-error');
            
            btn.disabled = true;
            btn.innerText = 'Saving...';
            errorDiv.style.display = 'none';
            
            var formData = new FormData(this);
            formData.append('snbd_action', 'save_profile');
            
            fetch('index.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.reload();
                } else {
                    btn.disabled = false;
                    btn.innerText = 'Save & Continue';
                    errorDiv.innerText = data.message;
                    errorDiv.style.display = 'block';
                }
            })
            .catch(error => {
                btn.disabled = false;
                btn.innerText = 'Save & Continue';
                errorDiv.innerText = 'An error occurred. Please try again.';
                errorDiv.style.display = 'block';
            });
        });
    </script>
    <?php
    return ob_get_clean();
});

/**
 * ─────────────────────────────────────────────────────────────────────────────
 * CLOUDFLARE TURNSTILE CAPTCHA INTEGRATION
 * ─────────────────────────────────────────────────────────────────────────────
 */

/**
 * Retrieve Cloudflare Turnstile Settings from Database
 */
function getSnbdhostTurnstileSettings() {
    static $settings = null;
    if ($settings === null) {
        try {
            $rows = Capsule::table('tbladdonmodules')
                ->where('module', 'snbdhost_manager')
                ->whereIn('setting', ['turnstile_enabled', 'turnstile_site_key', 'turnstile_secret_key'])
                ->get();
            
            $settings = [
                'enabled' => false,
                'site_key' => '',
                'secret_key' => ''
            ];
            
            foreach ($rows as $row) {
                if ($row->setting === 'turnstile_enabled') {
                    $settings['enabled'] = ($row->value === 'on' || $row->value === '1' || $row->value === 'yes');
                } elseif ($row->setting === 'turnstile_site_key') {
                    $settings['site_key'] = trim($row->value);
                } elseif ($row->setting === 'turnstile_secret_key') {
                    $settings['secret_key'] = trim($row->value);
                }
            }
        } catch (\Exception $e) {
            $settings = [
                'enabled' => false,
                'site_key' => '',
                'secret_key' => ''
            ];
        }
    }
    return $settings;
}

/**
 * Verify Cloudflare Turnstile Token
 */
function verifySnbdhostTurnstileToken($token, $secretKey) {
    if (empty($token) || empty($secretKey)) {
        return false;
    }
    
    $url = 'https://challenges.cloudflare.com/turnstile/v0/siteverify';
    $postData = [
        'secret' => $secretKey,
        'response' => $token,
        'remoteip' => $_SERVER['REMOTE_ADDR'] ?? ''
    ];
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($postData));
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    
    $response = curl_exec($ch);
    curl_close($ch);
    
    if ($response) {
        $result = json_decode($response, true);
        return isset($result['success']) && $result['success'] === true;
    }
    
    return false;
}

/**
 * Expose Turnstile variables to Smarty templates & handle session errors
 */
add_hook('ClientAreaPage', 1, function($vars) {
    $settings = getSnbdhostTurnstileSettings();
    
    $extraVars = [];
    if ($settings['enabled']) {
        $extraVars['turnstileEnabled'] = true;
        $extraVars['turnstileSiteKey'] = $settings['site_key'];
        
        if (isset($_SESSION['turnstile_error'])) {
            $extraVars['turnstileError'] = $_SESSION['turnstile_error'];
            
            // Set error variables based on template context
            if (isset($vars['templatefile']) && in_array($vars['templatefile'], ['login', 'pwreset'])) {
                $extraVars['errormessage'] = $_SESSION['turnstile_error'];
                if ($vars['templatefile'] === 'login') {
                    $extraVars['incorrect'] = false;
                }
            }
            unset($_SESSION['turnstile_error']);
        }
    }
    
    return $extraVars;
});

/**
 * Early request intercept validation (for Login, Contact Form, Password Reset)
 */
add_hook('init', 1, function() {
    $settings = getSnbdhostTurnstileSettings();
    if (!$settings['enabled']) {
        return;
    }
    
    $scriptName = basename($_SERVER['SCRIPT_NAME']);
    $requestMethod = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    
    // A. Intercept Login form submissions (POST dologin.php)
    if ($scriptName === 'dologin.php' && $requestMethod === 'POST') {
        $token = $_POST['cf-turnstile-response'] ?? '';
        if (!verifySnbdhostTurnstileToken($token, $settings['secret_key'])) {
            $_SESSION['turnstile_error'] = 'Turnstile verification failed. Please try again.';
            header('Location: login.php');
            exit;
        }
    }
    
    // B. Intercept Pre-sales Contact form submissions (POST contact.php with action=send)
    if ($scriptName === 'contact.php' && $requestMethod === 'POST' && ($_POST['action'] ?? '') === 'send') {
        $token = $_POST['cf-turnstile-response'] ?? '';
        if (!verifySnbdhostTurnstileToken($token, $settings['secret_key'])) {
            exit('Cloudflare Turnstile verification failed. Please return and try again.');
        }
    }
    
    // C. Intercept Password Reset submissions (POST pwreset.php with action=reset)
    if ($scriptName === 'pwreset.php' && $requestMethod === 'POST' && ($_POST['action'] ?? '') === 'reset') {
        $token = $_POST['cf-turnstile-response'] ?? '';
        if (!verifySnbdhostTurnstileToken($token, $settings['secret_key'])) {
            $_SESSION['turnstile_error'] = 'Turnstile verification failed. Please try again.';
            header('Location: pwreset.php');
            exit;
        }
    }
});

/**
 * Validate Client Registration
 */
add_hook('ClientDetailsValidation', 1, function($vars) {
    if (defined('ADMINAREA')) {
        return;
    }
    
    $settings = getSnbdhostTurnstileSettings();
    if (!$settings['enabled']) {
        return;
    }
    
    $token = $_POST['cf-turnstile-response'] ?? '';
    if (!verifySnbdhostTurnstileToken($token, $settings['secret_key'])) {
        return [
            'Please complete the Cloudflare Turnstile verification.'
        ];
    }
});

/**
 * Validate Shopping Cart Checkout
 */
add_hook('ShoppingCartValidateCheckout', 1, function($vars) {
    $settings = getSnbdhostTurnstileSettings();
    if (!$settings['enabled']) {
        return;
    }
    
    $token = $_POST['cf-turnstile-response'] ?? '';
    if (!verifySnbdhostTurnstileToken($token, $settings['secret_key'])) {
        return [
            'Please complete the Cloudflare Turnstile verification.'
        ];
    }
});

/**
 * Validate Support Ticket Submission
 */
add_hook('TicketOpenValidation', 1, function($vars) {
    if (defined('ADMINAREA')) {
        return;
    }
    
    $settings = getSnbdhostTurnstileSettings();
    if (!$settings['enabled']) {
        return;
    }
    
    $token = $_POST['cf-turnstile-response'] ?? '';
    if (!verifySnbdhostTurnstileToken($token, $settings['secret_key'])) {
        return 'Please complete the Cloudflare Turnstile verification.';
    }
});

/**
 * ─────────────────────────────────────────────────────────────────────────────
 * N8N MODULE CLIENT AREA REDESIGN
 * ─────────────────────────────────────────────────────────────────────────────
 */
function renderSnbdhostN8nDashboardHtml($html) {
    if (empty($html) || strpos($html, 'n8n-modern-dashboard') !== false) {
        return $html;
    }

    $newHtml = '
    <div id="n8n-original-module-data" style="display:none !important;">' . $html . '</div>
    
    <style>
        .n8n-modern-dashboard {
            font-family: "Outfit", "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
            margin-top: 0.5rem;
        }
        .n8n-header-card {
            background: linear-gradient(135deg, #180808 0%, #2a0b0b 50%, #150606 100%);
            border: 1px solid rgba(239, 68, 68, 0.25);
            border-radius: 20px;
            padding: 1.75rem 2rem;
            color: #ffffff;
            box-shadow: 0 12px 35px rgba(204, 0, 0, 0.15);
            margin-bottom: 1.5rem;
            position: relative;
            overflow: hidden;
        }
        .n8n-header-card::after {
            content: "";
            position: absolute;
            top: -40%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(239, 68, 68, 0.2) 0%, transparent 70%);
            pointer-events: none;
        }
        .n8n-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid rgba(204, 0, 0, 0.1);
            padding: 1.75rem;
            box-shadow: 0 6px 24px rgba(204, 0, 0, 0.04);
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        .n8n-card:hover {
            box-shadow: 0 12px 35px rgba(204, 0, 0, 0.08);
            border-color: rgba(204, 0, 0, 0.2);
        }
        .n8n-card-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #111;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .n8n-metric-row {
            display: flex;
            flex-direction: column;
            margin-bottom: 1.25rem;
        }
        .n8n-metric-header {
            display: flex;
            justify-content: space-between;
            font-size: 0.88rem;
            font-weight: 600;
            color: #444;
            margin-bottom: 0.5rem;
        }
        .n8n-progress-bar {
            height: 10px;
            background: #f1f3f5;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
        }
        .n8n-progress-fill-success { background: linear-gradient(90deg, #10B981 0%, #059669 100%); }
        .n8n-progress-fill-danger { background: linear-gradient(90deg, #EF4444 0%, #DC2626 100%); }
        .n8n-progress-fill-warning { background: linear-gradient(90deg, #F59E0B 0%, #D97706 100%); }
        
        .n8n-status-badge {
            padding: 6px 14px;
            border-radius: 50rem;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: rgba(16, 185, 129, 0.12);
            color: #10B981;
            border: 1px solid rgba(16, 185, 129, 0.25);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .n8n-status-badge::before {
            content: "";
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10B981;
            box-shadow: 0 0 8px #10B981;
        }
        .n8n-status-badge.stopped {
            background: rgba(239, 68, 68, 0.12);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.25);
        }
        .n8n-status-badge.stopped::before {
            background: #EF4444;
            box-shadow: 0 0 8px #EF4444;
        }
        
        .btn-n8n-accent {
            background: linear-gradient(135deg, #CC0000 0%, #990000 100%) !important;
            color: #ffffff !important;
            border: none !important;
            border-radius: 12px !important;
            font-weight: 700 !important;
            padding: 0.7rem 1.6rem !important;
            transition: all 0.25s ease !important;
            box-shadow: 0 6px 20px rgba(204,0,0,0.35) !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            cursor: pointer;
            text-decoration: none !important;
        }
        .btn-n8n-accent:hover {
            transform: translateY(-2px) !important;
            box-shadow: 0 10px 28px rgba(204,0,0,0.45) !important;
            color: #ffffff !important;
        }
        
        .n8n-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
            gap: 1.25rem;
        }
        .n8n-info-item {
            background: #fffafa;
            padding: 1.15rem;
            border-radius: 14px;
            border: 1px solid rgba(204,0,0,0.08);
        }
        .n8n-info-label {
            font-size: 0.72rem;
            color: #777;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 6px;
        }
        .n8n-info-value {
            font-size: 1rem;
            font-weight: 800;
            color: #1a1a1a;
        }
        .n8n-masterclass-banner {
            background: linear-gradient(135deg, #1e0505 0%, #3a0808 50%, #200404 100%);
            border: 1px solid rgba(255, 68, 68, 0.3);
            border-radius: 18px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
            color: #ffffff;
            box-shadow: 0 10px 30px rgba(204, 0, 0, 0.15);
            position: relative;
            overflow: hidden;
        }
        .n8n-modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(8px);
            z-index: 99999;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        .n8n-modal-card {
            background: #ffffff;
            border-radius: 24px;
            max-width: 580px;
            width: 100%;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35);
            overflow: hidden;
            position: relative;
            animation: n8nPopIn 0.35s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        @keyframes n8nPopIn {
            from { opacity: 0; transform: scale(0.9) translateY(20px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        .n8n-modal-header {
            background: linear-gradient(135deg, #CC0000 0%, #990000 100%);
            padding: 1.5rem;
            color: #ffffff;
            position: relative;
        }
        .n8n-modal-close {
            position: absolute;
            top: 15px; right: 18px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            width: 32px; height: 32px;
            border-radius: 50%;
            font-size: 1.2rem;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: background 0.2s;
        }
        .n8n-modal-close:hover { background: rgba(255, 255, 255, 0.4); }
    </style>
    
    <div class="n8n-modern-dashboard" id="n8n-modern-dashboard">
        <!-- Header Banner -->
        <div class="n8n-header-card d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div class="d-flex align-items-center gap-3">
                <div style="background: rgba(255,255,255,0.12); padding: 10px 14px; border-radius: 14px; display: flex; align-items: center; justify-content: center;">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="#FF6D5A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 17L12 22L22 17" stroke="#FF6D5A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M2 12L12 17L22 12" stroke="#FF6D5A" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <h4 class="fw-bold text-white mb-0" style="font-size: 1.35rem;">n8n Workflow Instance</h4>
                        <span class="n8n-status-badge" id="n8n-val-status">Running</span>
                    </div>
                    <p class="text-white-50 mb-0 small" id="n8n-val-url-subtitle"><i class="ti ti-link me-1"></i>Loading instance endpoint...</p>
                </div>
            </div>
            
            <div class="d-flex align-items-center gap-2">
                <a href="#" id="n8n-btn-open-top" target="_blank" class="btn btn-n8n-accent">
                    <i class="ti ti-external-link me-2"></i> Launch n8n Dashboard
                </a>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left Side: Resource Usage -->
            <div class="col-lg-6">
                <div class="n8n-card h-100">
                    <div class="n8n-card-title" style="cursor:default;">
                        <i class="ti ti-activity" style="color: #CC0000; font-size: 1.4rem;"></i> Server Resource Usage
                    </div>
                    
                    <div class="n8n-metric-row mt-3">
                        <div class="n8n-metric-header">
                            <span><i class="ti ti-cpu me-1 text-danger"></i> CPU Utilization</span>
                            <span id="n8n-val-cpu-text" class="fw-bold">N/A</span>
                        </div>
                        <div class="n8n-progress-bar">
                            <div class="n8n-progress-fill-success" id="n8n-bar-cpu" style="width: 0%;"></div>
                        </div>
                    </div>
                    
                    <div class="n8n-metric-row">
                        <div class="n8n-metric-header">
                            <span><i class="ti ti-device-sd-micro me-1 text-danger"></i> RAM / Memory Usage</span>
                            <span id="n8n-val-mem-text" class="fw-bold">N/A</span>
                        </div>
                        <div class="n8n-progress-bar">
                            <div class="n8n-progress-fill-danger" id="n8n-bar-mem" style="width: 0%;"></div>
                        </div>
                    </div>
                    
                    <div class="n8n-metric-row mb-0">
                        <div class="n8n-metric-header">
                            <span><i class="ti ti-database me-1 text-danger"></i> Storage / Disk Usage</span>
                            <span id="n8n-val-disk-text" class="fw-bold">N/A</span>
                        </div>
                        <div class="n8n-progress-bar">
                            <div class="n8n-progress-fill-success" id="n8n-bar-disk" style="width: 0%;"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Right Side: Instance Info & Quick Actions -->
            <div class="col-lg-6">
                <div class="n8n-card h-100 d-flex flex-column justify-content-between">
                    <div>
                        <div class="n8n-card-title pb-2 border-bottom">
                            <i class="ti ti-server-2" style="color: #CC0000; font-size: 1.4rem;"></i> Instance Configuration
                        </div>
                        
                        <div class="n8n-info-grid my-3">
                            <div class="n8n-info-item">
                                <div class="n8n-info-label">n8n Version</div>
                                <div class="n8n-info-value text-danger" id="n8n-val-version">v2.31.6</div>
                            </div>
                            <div class="n8n-info-item">
                                <div class="n8n-info-label">CPU Cores</div>
                                <div class="n8n-info-value" id="n8n-val-owner">1 CPU</div>
                            </div>
                            <div class="n8n-info-item">
                                <div class="n8n-info-label">RAM Allocated</div>
                                <div class="n8n-info-value" id="n8n-val-users">1 GiB</div>
                            </div>
                            <div class="n8n-info-item">
                                <div class="n8n-info-label">Access Protocol</div>
                                <div class="n8n-info-value text-success">HTTPS Secured</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="pt-3 border-top d-flex justify-content-end gap-2 flex-wrap">
                        <button class="btn btn-n8n-accent" id="n8n-btn-changepw">
                            <i class="ti ti-key me-2"></i> Reset Owner Password
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
    (function() {
        function initN8nDashboard() {
            var orig = document.getElementById("n8n-original-module-data");
            if (!orig) return;

            var rawHtml = orig.innerHTML;
            var mId = window.location.href.match(/[?&]id=(\d+)/i);
            var serviceId = mId ? mId[1] : null;
            var apiUrl = "modules/servers/dockern8n/ajax.php";

            // Parse DOM from raw HTML container
            var tmp = document.createElement("div");
            tmp.innerHTML = rawHtml;

            // Extract instance URL
            var extLink = tmp.querySelector("a[href*=\'n8n\']") || tmp.querySelector("a[target=\'_blank\'][href*=\'http\']");
            var domainEl = tmp.querySelector("#service-domain");
            var versionEl = tmp.querySelector("#service-version");

            if (versionEl && versionEl.textContent.trim()) {
                document.getElementById("n8n-val-version").innerText = versionEl.textContent.trim();
            }

            var instanceUrl = null;
            if (extLink && extLink.href) {
                instanceUrl = extLink.href;
            } else if (domainEl && domainEl.textContent.trim()) {
                var rawDomain = domainEl.textContent.trim();
                instanceUrl = rawDomain.startsWith("http") ? rawDomain : "https://" + rawDomain;
            } else {
                // Try finding any url matching .n8n in rawHtml
                var match = rawHtml.match(/https?:\/\/[^\s"<>\']+/i);
                if (match) instanceUrl = match[0];
            }

            if (instanceUrl) {
                var topBtn = document.getElementById("n8n-btn-open-top");
                if (topBtn) topBtn.href = instanceUrl;
                var subEl = document.getElementById("n8n-val-url-subtitle");
                if (subEl) subEl.innerHTML = \'<i class="ti ti-link me-1"></i>\' + instanceUrl;
            }

            // Fetch live stats via module AJAX endpoint
            if (serviceId) {
                fetch(apiUrl + "?action=getAllData&serviceId=" + serviceId)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.status && data.status.status) {
                        var s = data.status.status;
                        var badge = document.getElementById("n8n-val-status");
                        badge.innerText = s.charAt(0).toUpperCase() + s.slice(1);
                        badge.classList.remove("stopped");
                        if (s !== "running") badge.classList.add("stopped");
                    }

                    var rs = data.resourcestats;
                    if (rs && rs.success) {
                        var cpuStr = (rs.cpu || "").replace(/\s/g, "");
                        document.getElementById("n8n-val-cpu-text").innerText = cpuStr || "N/A";
                        var cpuPct = parseFloat(cpuStr);
                        if (!isNaN(cpuPct)) document.getElementById("n8n-bar-cpu").style.width = Math.min(cpuPct, 100) + "%";

                        var memStr = rs.memory || "";
                        document.getElementById("n8n-val-mem-text").innerText = memStr || "N/A";
                        var memM = memStr.match(/([\d.]+)\s*(\w+)\s*\/\s*([\d.]+)\s*(\w+)/);
                        if (memM) {
                            function toMiB(val, unit) {
                                val = parseFloat(val);
                                unit = unit.toLowerCase();
                                if (unit === "gib" || unit === "gb") return val * 1024;
                                if (unit === "kib" || unit === "kb") return val / 1024;
                                return val;
                            }
                            var used  = toMiB(memM[1], memM[2]);
                            var limit = toMiB(memM[3], memM[4]);
                            if (limit > 0) document.getElementById("n8n-bar-mem").style.width = Math.min((used/limit)*100, 100) + "%";
                        }

                        var storage = rs.storage;
                        if (storage && typeof storage === "object") {
                            var diskStr = storage.used ? (storage.used + (storage.total ? " / " + storage.total : "")) : "N/A";
                            document.getElementById("n8n-val-disk-text").innerText = diskStr;
                            if (storage.percent) {
                                document.getElementById("n8n-bar-disk").style.width = Math.min(parseFloat(storage.percent), 100) + "%";
                            }
                        } else if (typeof storage === "string" && storage) {
                            document.getElementById("n8n-val-disk-text").innerText = storage;
                        }
                    }

                    tmp.querySelectorAll("tr").forEach(function(tr) {
                        var cells = tr.querySelectorAll("td");
                        if (cells.length >= 2) {
                            var label = cells[0].textContent.trim().replace(/:$/, "");
                            var value = cells[1].textContent.trim();
                            if (label === "CPU Limit" || label === "CPU")  document.getElementById("n8n-val-owner").innerText = value;
                            if (label === "Memory" || label === "Memory Limit") document.getElementById("n8n-val-users").innerText  = value;
                        }
                    });
                })
                .catch(function(e) { console.error("[n8n-dashboard] AJAX error:", e); });
            }

            // Password Notice
            function showPwNotice(pw) {
                var existing = document.getElementById("n8n-pw-notice");
                if (existing) existing.remove();

                var notice = document.createElement("div");
                notice.id = "n8n-pw-notice";
                notice.style.cssText = "background:#fff8f0;border:1.5px solid #f5a623;border-radius:14px;padding:1rem 1.25rem;margin-bottom:1rem;font-size:0.85rem;";

                var warn = document.createElement("div");
                warn.style.cssText = "font-weight:700;color:#b45309;margin-bottom:0.6rem;";
                warn.innerHTML = "<i class=\"ti ti-alert-triangle\" style=\"margin-right:6px;\"></i>Save your new password — it will disappear after page refresh.";

                var row = document.createElement("div");
                row.style.cssText = "display:flex;align-items:center;gap:0.6rem;flex-wrap:wrap;";

                var code = document.createElement("code");
                code.style.cssText = "background:#fef3c7;border:1px solid #fcd34d;border-radius:8px;padding:0.4rem 0.8rem;font-size:1rem;font-weight:700;color:#92400e;flex:1;";
                code.textContent = pw;

                var copyBtn = document.createElement("button");
                copyBtn.style.cssText = "background:#f5a623;border:none;border-radius:8px;color:#fff;font-weight:700;padding:0.4rem 0.9rem;cursor:pointer;";
                copyBtn.innerHTML = "<i class=\"ti ti-copy\"></i> Copy";
                copyBtn.addEventListener("click", function() {
                    navigator.clipboard.writeText(pw).then(function() {
                        copyBtn.innerHTML = "<i class=\"ti ti-check\"></i> Copied!";
                        setTimeout(function() { copyBtn.innerHTML = "<i class=\"ti ti-copy\"></i> Copy"; }, 2000);
                    });
                });

                var closeBtn = document.createElement("button");
                closeBtn.style.cssText = "background:transparent;border:none;color:#b45309;cursor:pointer;font-size:1.2rem;";
                closeBtn.textContent = "×";
                closeBtn.addEventListener("click", function() { notice.remove(); });

                row.appendChild(code);
                row.appendChild(copyBtn);
                row.appendChild(closeBtn);
                notice.appendChild(warn);
                notice.appendChild(row);

                var dashboard = document.getElementById("n8n-modern-dashboard");
                if (dashboard) {
                    dashboard.insertAdjacentElement("afterbegin", notice);
                    notice.scrollIntoView({ behavior: "smooth", block: "center" });
                }
            }

            var btnPw = document.getElementById("n8n-btn-changepw");
            if (btnPw) {
                btnPw.addEventListener("click", function(e) {
                    e.preventDefault();
                    if (!serviceId) { alert("Service ID not found."); return; }
                    if (!confirm("Reset your n8n owner password? A new random password will be generated.")) return;
                    btnPw.disabled = true;
                    btnPw.innerHTML = \'<i class="ti ti-loader-2 ti-spin me-2"></i> Resetting…\';
                    fetch(apiUrl + "?action=resetPassword&serviceId=" + serviceId)
                    .then(function(r) { return r.json(); })
                    .then(function(d) {
                        btnPw.disabled = false;
                        btnPw.innerHTML = \'<i class="ti ti-key me-2"></i> Reset Owner Password\';
                        if (d.success) showPwNotice(d.password || "(check your email)");
                        else alert("Reset failed: " + (d.message || "Unknown error"));
                    })
                    .catch(function() {
                        btnPw.disabled = false;
                        btnPw.innerHTML = \'<i class="ti ti-key me-2"></i> Reset Owner Password\';
                        alert("Request failed. Please try again.");
                    });
                });
            }

            window.openN8nMasterclassModal = function() {
                var modal = document.getElementById("n8nMasterclassModal");
                if (modal) modal.style.display = "flex";
            };
            window.closeN8nMasterclassModal = function() {
                var modal = document.getElementById("n8nMasterclassModal");
                if (modal) modal.style.display = "none";
            };
        }

        if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", initN8nDashboard);
        } else {
            initN8nDashboard();
        }
    })();
    </script>';

    return $newHtml;
}

/**
 * Hook for ClientAreaProductDetailsOutput (Runs specifically on Module HTML output)
 */
add_hook('ClientAreaProductDetailsOutput', 1, function($service) {
    $html = $service['html'] ?? '';
    $moduleName = strtolower($service['modulename'] ?? '');
    
    if (strpos($moduleName, 'n8n') !== false || stripos($html, 'n8n') !== false || stripos($html, 'dockern8n') !== false) {
        return renderSnbdhostN8nDashboardHtml($html);
    }
});

/**
 * Hook for ClientAreaPageProductDetails (Runs on Page Variables)
 */
add_hook('ClientAreaPageProductDetails', 1, function($vars) {
    $htmlContent = ($vars['tplOverviewTabOutput'] ?? '') . ($vars['moduleclientarea'] ?? '');
    $productName = strtolower($vars['product'] ?? '');
    $moduleName = strtolower($vars['modulename'] ?? $vars['module'] ?? '');
    
    if (
        strpos($productName, 'n8n') !== false || 
        strpos($moduleName, 'n8n') !== false || 
        stripos($htmlContent, 'n8n') !== false || 
        stripos($htmlContent, 'dockern8n') !== false
    ) {
        if (!empty($vars['tplOverviewTabOutput']) && strpos($vars['tplOverviewTabOutput'], 'n8n-modern-dashboard') === false) {
            $new = renderSnbdhostN8nDashboardHtml($vars['tplOverviewTabOutput']);
            return ['tplOverviewTabOutput' => $new];
        }
        if (!empty($vars['moduleclientarea']) && strpos($vars['moduleclientarea'], 'n8n-modern-dashboard') === false) {
            $new = renderSnbdhostN8nDashboardHtml($vars['moduleclientarea']);
            return ['moduleclientarea' => $new];
        }
    }
});

/**
 * Hook for ClientAreaFooterOutput (Frontend JS Transformer Fallback)
 */
add_hook('ClientAreaFooterOutput', 1, function($vars) {
    if (empty($vars['filename']) || $vars['filename'] !== 'clientareaproductdetails') {
        return;
    }
    
    return '
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        if (document.getElementById("n8n-modern-dashboard")) return;
        
        // Find raw dockern8n container if present on client side
        var moduleWrap = document.getElementById("moduleClientAreaWrap") || document.querySelector(".module-clientarea-wrap");
        if (!moduleWrap) return;
        
        var hasN8n = moduleWrap.innerText.indexOf("n8n") !== -1 || moduleWrap.innerHTML.indexOf("dockern8n") !== -1 || moduleWrap.querySelector("a[href*=\'n8n\']");
        if (!hasN8n) return;
        
        // Wrap original in hidden div
        var origHtml = moduleWrap.innerHTML;
        moduleWrap.innerHTML = "";
        
        var hiddenDiv = document.createElement("div");
        hiddenDiv.id = "n8n-original-module-data";
        hiddenDiv.style.cssText = "display:none !important;";
        hiddenDiv.innerHTML = origHtml;
        moduleWrap.appendChild(hiddenDiv);
        
        // Create modern container shell
        var dash = document.createElement("div");
        dash.id = "n8n-modern-dashboard-shell";
        moduleWrap.appendChild(dash);
        
        // Fetch instance URL
        var extLink = hiddenDiv.querySelector("a[href*=\'n8n\']") || hiddenDiv.querySelector("a[target=\'_blank\'][href*=\'http\']");
        var instanceUrl = extLink ? extLink.href : "#";
        
        dash.innerHTML = `
        <div class="n8n-modern-dashboard" id="n8n-modern-dashboard">
            <div class="n8n-header-card d-flex align-items-center justify-content-between flex-wrap gap-3" style="background: linear-gradient(135deg, #180808 0%, #2a0b0b 50%, #150606 100%); border: 1px solid rgba(239, 68, 68, 0.25); border-radius: 20px; padding: 1.75rem 2rem; color: #ffffff; box-shadow: 0 12px 35px rgba(204, 0, 0, 0.15); margin-bottom: 1.5rem;">
                <div class="d-flex align-items-center gap-3">
                    <div style="background: rgba(255,255,255,0.12); padding: 10px 14px; border-radius: 14px;">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none"><path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="#FF6D5A" stroke-width="2"/><path d="M2 17L12 22L22 17" stroke="#FF6D5A" stroke-width="2"/><path d="M2 12L12 17L22 12" stroke="#FF6D5A" stroke-width="2"/></svg>
                    </div>
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <h4 class="fw-bold text-white mb-0" style="font-size: 1.35rem;">n8n Workflow Instance</h4>
                            <span class="n8n-status-badge" id="n8n-val-status" style="padding: 6px 14px; border-radius: 50rem; font-size: 0.78rem; font-weight: 700; background: rgba(16, 185, 129, 0.12); color: #10B981; border: 1px solid rgba(16, 185, 129, 0.25);">Running</span>
                        </div>
                        <p class="text-white-50 mb-0 small" id="n8n-val-url-subtitle"><i class="ti ti-link me-1"></i>` + (instanceUrl !== "#" ? instanceUrl : "n8n Automation Engine") + `</p>
                    </div>
                </div>
                <div>
                    <a href="` + instanceUrl + `" target="_blank" class="btn btn-n8n-accent" style="background: linear-gradient(135deg, #CC0000 0%, #990000 100%) !important; color: #fff !important; border-radius: 12px; font-weight: 700; padding: 0.7rem 1.6rem; text-decoration: none;">
                        <i class="ti ti-external-link me-2"></i> Launch n8n Dashboard
                    </a>
                </div>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="card p-4 border-0 shadow-sm" style="border-radius: 20px; border: 1px solid rgba(204,0,0,0.1) !important;">
                        <h5 class="fw-bold mb-3 text-dark"><i class="ti ti-activity text-danger me-2"></i> Resource Monitor</h5>
                        <p class="text-muted small">Live server metrics are active.</p>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card p-4 border-0 shadow-sm" style="border-radius: 20px; border: 1px solid rgba(204,0,0,0.1) !important;">
                        <h5 class="fw-bold mb-3 text-dark"><i class="ti ti-server-2 text-danger me-2"></i> Instance Config</h5>
                        <p class="text-muted small">Access your n8n workflow manager via the launch button above.</p>
                    </div>
                </div>
            </div>
        </div>
        `;
    });
    </script>
    ';
});

