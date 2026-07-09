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
add_hook('ClientAreaPageProductDetails', 1, function($vars) {
    // Check if this is an n8n product
    $isN8n = false;
    $productName = strtolower($vars['product'] ?? '');
    
    if (strpos($productName, 'n8n') !== false || ($vars['module'] ?? '') === 'n8n') {
        $isN8n = true;
    }
    
    $html = '';
    $overrideKey = '';
    
    if ($isN8n) {
        if (!empty($vars['tplOverviewTabOutput'])) {
            $html = $vars['tplOverviewTabOutput'];
            $overrideKey = 'tplOverviewTabOutput';
        } elseif (!empty($vars['moduleclientarea'])) {
            $html = $vars['moduleclientarea'];
            $overrideKey = 'moduleclientarea';
        }
    }
    
    if ($html) {
        // If the HTML already contains our custom class, it was already processed.
        if (strpos($html, 'n8n-modern-dashboard') !== false) {
            return;
        }

        // Instead of parsing via fragile PHP regex, we output the original HTML in a hidden container
        // and use a robust Javascript approach to parse and populate the beautiful new UI.
        
        $newHtml = '
        <div id="n8n-original-module-data" style="display:none;">' . $html . '</div>
        
        <style>
            .n8n-modern-dashboard {
                font-family: "Outfit", "Inter", sans-serif;
                margin-top: 0.5rem;
            }
            .n8n-card {
                background: #ffffff;
                border-radius: 16px;
                border: 1px solid #eeeeee;
                padding: 1.5rem;
                box-shadow: 0 4px 20px rgba(0,0,0,0.015);
                margin-bottom: 1.5rem;
                transition: all 0.3s ease;
            }
            .n8n-card:hover {
                box-shadow: 0 8px 30px rgba(0,0,0,0.04);
            }
            .n8n-card-title {
                font-size: 1.15rem;
                font-weight: 700;
                color: #111;
                margin-bottom: 1.25rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .n8n-metric-row {
                display: flex;
                flex-direction: column;
                margin-bottom: 1.2rem;
            }
            .n8n-metric-header {
                display: flex;
                justify-content: space-between;
                font-size: 0.85rem;
                font-weight: 600;
                color: #555;
                margin-bottom: 0.5rem;
            }
            .n8n-progress-bar {
                height: 8px;
                background: #f0f0f0;
                border-radius: 10px;
                overflow: hidden;
                display: flex;
            }
            .n8n-progress-fill-success { background: #10B981; }
            .n8n-progress-fill-danger { background: #EF4444; }
            .n8n-progress-fill-warning { background: #F59E0B; }
            
            .n8n-status-badge {
                padding: 4px 12px;
                border-radius: 50rem;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                background: rgba(16, 185, 129, 0.1);
                color: #10B981;
                border: 1px solid rgba(16, 185, 129, 0.2);
            }
            .n8n-status-badge.stopped {
                background: rgba(239, 68, 68, 0.1);
                color: #EF4444;
                border: 1px solid rgba(239, 68, 68, 0.2);
            }
            
            .btn-n8n-accent {
                background: linear-gradient(135deg, #EA4B71 0%, #D63C60 100%) !important;
                color: #ffffff !important;
                border: none !important;
                border-radius: 12px !important;
                font-weight: 700 !important;
                padding: 0.6rem 1.5rem !important;
                transition: all 0.25s ease !important;
                box-shadow: 0 4px 15px rgba(234,75,113,0.3) !important;
                display: inline-flex !important;
                align-items: center !important;
                justify-content: center !important;
                cursor: pointer;
            }
            .btn-n8n-accent:hover {
                transform: translateY(-2px) !important;
                box-shadow: 0 8px 25px rgba(234,75,113,0.4) !important;
            }
            
            .n8n-info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 1rem;
            }
            .n8n-info-item {
                background: #fdfdfd;
                padding: 1rem;
                border-radius: 12px;
                border: 1px solid #eeeeee;
            }
            .n8n-info-label {
                font-size: 0.7rem;
                color: #888;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 4px;
            }
            .n8n-info-value {
                font-size: 0.95rem;
                font-weight: 700;
                color: #222;
            }
        </style>
        
        <div class="n8n-modern-dashboard" id="n8n-modern-dashboard">
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="n8n-card h-100">
                        <div class="n8n-card-title">
                            <i class="ti ti-server" style="color: #EA4B71; font-size: 1.4rem;"></i> Resource Monitor
                        </div>
                        
                        <div class="n8n-metric-row mt-3">
                            <div class="n8n-metric-header">
                                <span><i class="ti ti-cpu me-1 text-secondary"></i> CPU Usage</span>
                                <span id="n8n-val-cpu-text">N/A</span>
                            </div>
                            <div class="n8n-progress-bar">
                                <div class="n8n-progress-fill-success" id="n8n-bar-cpu" style="width: 0%;"></div>
                            </div>
                        </div>
                        
                        <div class="n8n-metric-row">
                            <div class="n8n-metric-header">
                                <span><i class="ti ti-device-sd-micro me-1 text-secondary"></i> Memory Usage</span>
                                <span id="n8n-val-mem-text">N/A</span>
                            </div>
                            <div class="n8n-progress-bar">
                                <div class="n8n-progress-fill-danger" id="n8n-bar-mem" style="width: 0%;"></div>
                            </div>
                        </div>
                        
                        <div class="n8n-metric-row mb-0">
                            <div class="n8n-metric-header">
                                <span><i class="ti ti-database me-1 text-secondary"></i> Disk Usage</span>
                                <span id="n8n-val-disk-text">N/A</span>
                            </div>
                            <div class="n8n-progress-bar">
                                <div class="n8n-progress-fill-success" id="n8n-bar-disk" style="width: 0%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-6">
                    <div class="n8n-card h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                                <div class="n8n-card-title mb-0">
                                    <i class="ti ti-info-circle" style="color: #EA4B71; font-size: 1.4rem;"></i> Instance Overview
                                </div>
                                <span class="n8n-status-badge" id="n8n-val-status">Unknown</span>
                            </div>
                            
                            <div class="n8n-info-grid mb-3">
                                <div class="n8n-info-item">
                                    <div class="n8n-info-label">Version</div>
                                    <div class="n8n-info-value" id="n8n-val-version">N/A</div>
                                </div>
                                <div class="n8n-info-item">
                                    <div class="n8n-info-label">URL</div>
                                    <div class="n8n-info-value">
                                        <a href="#" id="n8n-val-url" target="_blank" style="color: #EA4B71; text-decoration: none; font-weight: 700;">
                                            Open Instance <i class="ti ti-external-link"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="n8n-info-grid">
                                <div class="n8n-info-item">
                                    <div class="n8n-info-label">Owner</div>
                                    <div class="n8n-info-value" id="n8n-val-owner">N/A</div>
                                </div>
                                <div class="n8n-info-item">
                                    <div class="n8n-info-label">Users</div>
                                    <div class="n8n-info-value" id="n8n-val-users">N/A</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                            <button class="btn btn-n8n-accent" id="n8n-btn-changepw"><i class="ti ti-key me-2"></i> Change Password</button>
                            <button class="btn btn-n8n-accent" id="n8n-btn-autologin"><i class="ti ti-login me-2"></i> Auto Login</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
        document.addEventListener("DOMContentLoaded", function() {
            var orig = document.getElementById("n8n-original-module-data");
            if (!orig) return;
            
            // Clean out any scripts from the HTML so we don\'t accidentally match JS code
            var cleanHtml = orig.innerHTML.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, "");
            
            // Helper to safely extract values from divs or spans
            var extractDiv = function(label) {
                var regex = new RegExp(label + ".*?<div[^>]*>\\s*([^<]+)\\s*<", "i");
                var m = cleanHtml.match(regex);
                return m && m[1] ? m[1].trim() : null;
            };
            
            var extractTd = function(label) {
                var regex = new RegExp(label + ".*?<td[^>]*>\\s*([^<]+)\\s*<", "i");
                var m = cleanHtml.match(regex);
                return m && m[1] ? m[1].trim() : null;
            };
            
            // Status
            var mStatus = cleanHtml.match(/Status:.*?<span[^>]*>\\s*([^<]+)\\s*</i) || cleanHtml.match(/Status:\\s*([a-zA-Z]+)/i);
            if (mStatus) {
                var s = mStatus[1].trim();
                var badge = document.getElementById("n8n-val-status");
                badge.innerText = s;
                if (s.toLowerCase() !== "running") {
                    badge.classList.add("stopped");
                }
            }
            
            // CPU
            var cpu = extractDiv("CPU usage:");
            if (cpu) document.getElementById("n8n-val-cpu-text").innerText = cpu;
            var mCpuPct = cleanHtml.match(/CPU usage:.*?(\\d+(?:\\.\\d+)?%)/i);
            if (mCpuPct) document.getElementById("n8n-bar-cpu").style.width = mCpuPct[1];
            
            // Memory
            var mem = extractDiv("Memory usage:");
            if (mem) document.getElementById("n8n-val-mem-text").innerText = mem;
            var mMemPct = cleanHtml.match(/Memory usage:.*?width:\\s*(\\d+(?:\\.\\d+)?)%/i);
            if (mMemPct) document.getElementById("n8n-bar-mem").style.width = mMemPct[1] + "%";
            
            // Disk
            var disk = extractDiv("Disk usage:");
            if (disk) document.getElementById("n8n-val-disk-text").innerText = disk;
            var mDiskPct = cleanHtml.match(/Disk usage:.*?width:\\s*(\\d+(?:\\.\\d+)?)%/i);
            if (mDiskPct) document.getElementById("n8n-bar-disk").style.width = mDiskPct[1] + "%";
            
            // Version, Owner, Users
            var ver = extractTd("Version:");
            if (ver) document.getElementById("n8n-val-version").innerText = ver;
            
            var own = extractTd("Owner:");
            if (own) document.getElementById("n8n-val-owner").innerText = own;
            
            var usr = extractTd("Users:");
            if (usr) document.getElementById("n8n-val-users").innerText = usr;
            
            // URL
            var mUrl = cleanHtml.match(/href=["\'](https?:\\/\\/[^\'"]+n8nbysnbd\\.top[^\'"]*)["\']/i);
            if (mUrl) {
                document.getElementById("n8n-val-url").href = mUrl[1];
            }
            
            // Buttons logic
            var forms = orig.getElementsByTagName("form");
            
            document.getElementById("n8n-btn-changepw").addEventListener("click", function(e) {
                e.preventDefault();
                for (var i=0; i<forms.length; i++) {
                    if (forms[i].innerHTML.indexOf("Change Owner Password") !== -1 || forms[i].innerHTML.indexOf("Change Password") !== -1) {
                        forms[i].submit();
                        return;
                    }
                }
                alert("Change Password action not found.");
            });
            
            var autoLoginHandler = function(e) {
                e.preventDefault();
                for (var i=0; i<forms.length; i++) {
                    if (forms[i].innerHTML.indexOf("Go to n8n") !== -1 || forms[i].innerHTML.indexOf("Auto Login") !== -1 || forms[i].innerHTML.indexOf("Login") !== -1 || forms[i].action.indexOf("login") !== -1) {
                        forms[i].submit();
                        return;
                    }
                }
                // fallback if it\'s a link
                if (mUrl) window.open(mUrl[1], "_blank");
                else alert("Auto Login action not found.");
            };
            
            document.getElementById("n8n-btn-autologin").addEventListener("click", autoLoginHandler);
            
            // Bind the main top button (n8nMainBtn) to auto-login as well
            var whmcsN8nBtn = document.getElementById("n8nMainBtn");
            if (whmcsN8nBtn) {
                whmcsN8nBtn.addEventListener("click", autoLoginHandler);
                var whmcsN8nBtnContainer = document.getElementById("n8nButtonContainer");
                if (whmcsN8nBtnContainer) {
                    whmcsN8nBtnContainer.style.display = "block";
                }
            }
        });
        </script>';
        
        return [$overrideKey => $newHtml];
    }
});

