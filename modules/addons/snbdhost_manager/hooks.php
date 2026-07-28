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

        // Fetch n8n Masterclass Promo Config
        $promoEnabled = true;
        $promoUrl = 'https://snbdhost.com/learn/n8n-basic-to-advanced-in-bangla';
        $promoTitle = 'বাংলায় n8n ফ্রি মাস্টারক্লাস! (Free n8n Masterclass)';
        $promoImage = '';

        try {
            $settingsRows = Capsule::table('tbladdonmodules')
                ->where('module', 'snbdhost_manager')
                ->whereIn('setting', ['n8n_promo_enabled', 'n8n_promo_url', 'n8n_promo_title', 'n8n_promo_image'])
                ->get();
            foreach ($settingsRows as $row) {
                if ($row->setting === 'n8n_promo_enabled' && ($row->value === 'off' || strtolower($row->value) === 'no')) {
                    $promoEnabled = false;
                } elseif ($row->setting === 'n8n_promo_url' && !empty($row->value)) {
                    $promoUrl = $row->value;
                } elseif ($row->setting === 'n8n_promo_title' && !empty($row->value)) {
                    $promoTitle = $row->value;
                } elseif ($row->setting === 'n8n_promo_image' && !empty($row->value)) {
                    $promoImage = $row->value;
                }
            }
        } catch (\Exception $e) {
            // Use defaults if settings table is inaccessible
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
                background: linear-gradient(135deg, #CC0000 0%, #aa0000 100%) !important;
                color: #ffffff !important;
                border: none !important;
                border-radius: 12px !important;
                font-weight: 700 !important;
                padding: 0.6rem 1.5rem !important;
                transition: all 0.25s ease !important;
                box-shadow: 0 4px 15px rgba(204,0,0,0.3) !important;
                display: inline-flex !important;
                align-items: center !important;
                justify-content: center !important;
                cursor: pointer;
            }
            .btn-n8n-accent:hover {
                transform: translateY(-2px) !important;
                box-shadow: 0 8px 25px rgba(204,0,0,0.4) !important;
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
            .n8n-masterclass-banner {
                background: linear-gradient(135deg, #1e0505 0%, #3a0808 50%, #200404 100%);
                border: 1px solid rgba(255, 68, 68, 0.3);
                border-radius: 16px;
                padding: 1.25rem 1.5rem;
                margin-bottom: 1.5rem;
                color: #ffffff;
                box-shadow: 0 10px 30px rgba(204, 0, 0, 0.15);
                position: relative;
                overflow: hidden;
            }
            .n8n-masterclass-banner::before {
                content: "";
                position: absolute;
                top: -50%;
                right: -10%;
                width: 250px;
                height: 250px;
                background: radial-gradient(circle, rgba(204,0,0,0.25) 0%, rgba(0,0,0,0) 70%);
                pointer-events: none;
            }
            .n8n-modal-overlay {
                display: none;
                position: fixed;
                top: 0; left: 0; width: 100vw; height: 100vh;
                background: rgba(0, 0, 0, 0.65);
                backdrop-filter: blur(6px);
                z-index: 99999;
                align-items: center;
                justify-content: center;
                padding: 1rem;
            }
            .n8n-modal-card {
                background: #ffffff;
                border-radius: 20px;
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
            ' . ($promoEnabled ? '
            <div class="n8n-masterclass-banner d-none align-items-center justify-content-between flex-wrap gap-3" id="secret-masterclass-banner">
                <div class="d-flex align-items-center gap-3">
                    <div style="background: rgba(255,255,255,0.1); width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <i class="ti ti-school" style="font-size: 1.8rem; color: #ff6666;"></i>
                    </div>
                    <div>
                        <div class="d-flex align-items-center gap-2 mb-1">
                            <span class="badge" style="background: #CC0000; color: white; font-size: 0.7rem; letter-spacing: 0.5px;">100% FREE</span>
                            <span class="text-white-50 small" style="font-size: 0.75rem;"><i class="ti ti-language me-1"></i>বাংলায় কোর্স</span>
                        </div>
                        <h5 class="fw-bold mb-0 text-white" style="font-size: 1.05rem;">' . htmlspecialchars($promoTitle) . '</h5>
                        <p class="mb-0 text-white-50 small" style="font-size: 0.82rem;">n8n Workflow Automation, API Integration & AI Agent তৈরি শিখুন ফ্রিতে।</p>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2 ms-auto">
                    <button type="button" class="btn btn-sm btn-outline-light rounded-pill px-3" onclick="openN8nMasterclassModal()"><i class="ti ti-info-circle me-1"></i> বিস্তারিত</button>
                    <a href="' . htmlspecialchars($promoUrl) . '" target="_blank" class="btn btn-sm text-white fw-bold px-4 py-2" style="background: #CC0000; border-radius: 10px; box-shadow: 0 4px 15px rgba(204,0,0,0.4); border: none;">
                        ক্লাসে জয়েন করুন <i class="ti ti-arrow-up-right ms-1"></i>
                    </a>
                </div>
            </div>

            <div class="n8n-modal-overlay" id="n8nMasterclassModal">
                <div class="n8n-modal-card">
                    <div class="n8n-modal-header">
                        <button class="n8n-modal-close" onclick="closeN8nMasterclassModal()">&times;</button>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/N8n-logo-new.svg" style="height: 1.4rem; filter: brightness(0) invert(1);" alt="n8n">
                            <span class="badge" style="background: rgba(255,255,255,0.25); color: white; font-size: 0.75rem;">বাংলা ফ্রি মাস্টারক্লাস</span>
                        </div>
                        <h4 class="fw-bold mb-1 text-white" style="font-size: 1.35rem;">' . htmlspecialchars($promoTitle) . '</h4>
                        <p class="mb-0 text-white-50 small">SNBD HOST এর শিক্ষার্থীদের জন্য সম্পূর্ণ ফ্রি n8n টিউটোরিয়াল ও মাস্টারক্লাস!</p>
                    </div>
                    <div class="p-4" style="background: #ffffff;">
                        ' . (!empty($promoImage) ? '<div class="mb-3 text-center"><img src="' . htmlspecialchars($promoImage) . '" class="img-fluid rounded-3 border" style="max-height: 200px; width: 100%; object-fit: cover;" alt="n8n Course Banner"></div>' : '') . '
                        <div class="mb-3 p-3 rounded-3" style="background: #FFF5F5; border: 1px solid #FFE0E0;">
                            <h6 class="fw-bold text-dark mb-2" style="font-size: 0.92rem;"><i class="ti ti-sparkles text-danger me-1"></i> এই মাস্টারক্লাসে আপনি কী কী শিখবেন:</h6>
                            <ul class="mb-0 text-secondary small ps-3" style="line-height: 1.7; font-size: 0.85rem;">
                                <li>⚡ <strong>Automate Everything:</strong> কোনো কোডিং ছাড়াই n8n দিয়ে পাওয়ারফুল ওয়ার্কফ্লো অটোমেশন তৈরি।</li>
                                <li>🔗 <strong>Webhooks & APIs:</strong> Facebook, WhatsApp, Telegram, Google Sheets ও CRM এর সাথে n8n কানেক্ট করা।</li>
                                <li>🤖 <strong>AI Agent Integration:</strong> n8n-এ OpenAI / Gemini যুক্ত করে অটোমেটিক AI Agent তৈরি।</li>
                                <li>🇧🇩 <strong>১০০% বাংলায় সহজ ব্যাখ্যা:</strong> নতুনদের জন্য স্টেপ-বাই-স্টেপ প্র্যাকটিক্যাল গাইড।</li>
                            </ul>
                        </div>
                        
                        <div class="d-flex align-items-center justify-content-between gap-2 pt-2 flex-wrap">
                            <button type="button" class="btn btn-link text-muted p-0 text-decoration-none small" id="n8n-dismiss-masterclass-btn" style="font-size: 0.78rem;">
                                <i class="ti ti-eye-off me-1"></i> পরবর্তীতে আর দেখাবেন না (Don\'t show again)
                            </button>
                            <div class="d-flex gap-2 ms-auto">
                                <button type="button" class="btn btn-light btn-sm px-3 border fw-semibold" onclick="closeN8nMasterclassModal()">পরে দেখবো</button>
                                <a href="' . htmlspecialchars($promoUrl) . '" target="_blank" class="btn btn-danger btn-sm px-4 fw-bold text-white shadow-sm" style="background: linear-gradient(135deg, #CC0000 0%, #aa0000 100%); border-radius: 8px; border: none;">
                                    <i class="ti ti-rocket me-1"></i> ফ্রী মাস্টারক্লাস শুরু করুন
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            ' : '') . '
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="n8n-card h-100">
                        <div class="n8n-card-title" ondblclick="var b=document.getElementById('secret-masterclass-banner');if(b){b.classList.remove('d-none');b.classList.add('d-flex');}" style="cursor:default;">
                            <i class="ti ti-server" style="color: #CC0000; font-size: 1.4rem;"></i> Resource Monitor
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
                                    <i class="ti ti-info-circle" style="color: #CC0000; font-size: 1.4rem;"></i> Instance Overview
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
                                        <a href="#" id="n8n-val-url" target="_blank" style="color: #CC0000; text-decoration: none; font-weight: 700;">
                                            Open Instance <i class="ti ti-external-link"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="n8n-info-grid">
                                <div class="n8n-info-item">
                                    <div class="n8n-info-label">CPU Limit</div>
                                    <div class="n8n-info-value" id="n8n-val-owner">N/A</div>
                                </div>
                                <div class="n8n-info-item">
                                    <div class="n8n-info-label">Memory Limit</div>
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

            // ── 1. Get serviceId from the page URL (?id=XXXX) ────────────────────
            // WHMCS strips <script> tags from moduleclientarea, so we cannot
            // extract serviceId from the module HTML — use the URL instead.
            var rawHtml = orig.innerHTML;
            var mId = window.location.href.match(/[?&]id=(\d+)/i);
            var serviceId = mId ? mId[1] : null;
            var apiUrl = "modules/servers/dockern8n/ajax.php";

            // ── 2. Parse the rendered DOM for static fields ──────────────────────
            // innerHTML parsed via a temp container gives us real DOM queries.
            var tmp = document.createElement("div");
            tmp.innerHTML = rawHtml;

            var domainEl  = tmp.querySelector("#service-domain");
            var versionEl = tmp.querySelector("#service-version");
            // The header bar external link is the instance URL
            var extLink   = tmp.querySelector(".header-bar a[target=\'_blank\']")
                         || tmp.querySelector("a[target=\'_blank\'][href*=\'http\']");

            if (versionEl && versionEl.textContent.trim()) {
                document.getElementById("n8n-val-version").innerText = versionEl.textContent.trim();
            }

            var instanceUrl = null;
            if (extLink && extLink.href) {
                instanceUrl = extLink.href;
                var urlEl = document.getElementById("n8n-val-url");
                urlEl.href = instanceUrl;
            } else if (domainEl && domainEl.textContent.trim()) {
                var rawDomain = domainEl.textContent.trim();
                instanceUrl = rawDomain.startsWith("http") ? rawDomain : "https://" + rawDomain;
                document.getElementById("n8n-val-url").href = instanceUrl;
            }

            // ── 3. Fetch live data via the module\'s own AJAX endpoint ────────────
            if (serviceId) {
                fetch(apiUrl + "?action=getAllData&serviceId=" + serviceId)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    // Status
                    if (data.status && data.status.status) {
                        var s = data.status.status;
                        var badge = document.getElementById("n8n-val-status");
                        badge.innerText = s.charAt(0).toUpperCase() + s.slice(1);
                        badge.classList.remove("stopped");
                        if (s !== "running") badge.classList.add("stopped");
                    }

                    // Resource stats
                    var rs = data.resourcestats;
                    if (rs && rs.success) {
                        // CPU: "0.50%"
                        var cpuStr = (rs.cpu || "").replace(/\s/g, "");
                        document.getElementById("n8n-val-cpu-text").innerText = cpuStr || "N/A";
                        var cpuPct = parseFloat(cpuStr);
                        if (!isNaN(cpuPct)) document.getElementById("n8n-bar-cpu").style.width = Math.min(cpuPct, 100) + "%";

                        // Memory: "256MiB / 1GiB"
                        var memStr = rs.memory || "";
                        document.getElementById("n8n-val-mem-text").innerText = memStr || "N/A";
                        // Parse used/limit to get percentage
                        var memM = memStr.match(/([\d.]+)\s*(\w+)\s*\/\s*([\d.]+)\s*(\w+)/);
                        if (memM) {
                            function toMiB(val, unit) {
                                val = parseFloat(val);
                                unit = unit.toLowerCase();
                                if (unit === "gib" || unit === "gb") return val * 1024;
                                if (unit === "kib" || unit === "kb") return val / 1024;
                                return val; // MiB default
                            }
                            var used  = toMiB(memM[1], memM[2]);
                            var limit = toMiB(memM[3], memM[4]);
                            if (limit > 0) document.getElementById("n8n-bar-mem").style.width = Math.min((used/limit)*100, 100) + "%";
                        }

                        // Disk / storage
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

                    // CPU limit & memory limit from module vars (already in rendered HTML)
                    var cpuLimitEl = tmp.querySelector("td:not([id])");
                    // Use owner field for CPU limit, users field for memory limit
                    var cpuLimitNode  = tmp.querySelector("tr td strong");
                    // Find the CPU Limit row value
                    tmp.querySelectorAll("tr").forEach(function(tr) {
                        var cells = tr.querySelectorAll("td");
                        if (cells.length >= 2) {
                            var label = cells[0].textContent.trim().replace(/:$/, "");
                            var value = cells[1].textContent.trim();
                            if (label === "CPU Limit")  document.getElementById("n8n-val-owner").innerText = value;
                            if (label === "Memory")     document.getElementById("n8n-val-users").innerText  = value;
                        }
                    });
                })
                .catch(function(e) {
                    console.error("[n8n-dashboard] AJAX error:", e);
                });
            } else {
                console.warn("[n8n-dashboard] Could not extract serviceId from module HTML");
            }

            // ── 4. In-page password notice ───────────────────────────────────────
            function showPwNotice(pw) {
                var existing = document.getElementById("n8n-pw-notice");
                if (existing) existing.remove();

                // Build with DOM methods to avoid quote-escaping issues
                var notice = document.createElement("div");
                notice.id = "n8n-pw-notice";
                notice.style.cssText = "background:#fff8f0;border:1.5px solid #f5a623;border-radius:12px;padding:1rem 1.25rem;margin-bottom:1rem;font-size:0.85rem;";

                var warn = document.createElement("div");
                warn.style.cssText = "font-weight:700;color:#b45309;margin-bottom:0.6rem;";
                warn.innerHTML = "<i class=\"ti ti-alert-triangle\" style=\"margin-right:6px;\"></i>Save your new password — it will disappear after you refresh this page.";

                var row = document.createElement("div");
                row.style.cssText = "display:flex;align-items:center;gap:0.6rem;flex-wrap:wrap;";

                var code = document.createElement("code");
                code.id = "n8n-new-pw-text";
                code.style.cssText = "background:#fef3c7;border:1px solid #fcd34d;border-radius:8px;padding:0.4rem 0.8rem;font-size:1rem;font-weight:700;color:#92400e;letter-spacing:0.05em;flex:1;word-break:break-all;";
                code.textContent = pw;

                var copyBtn = document.createElement("button");
                copyBtn.id = "n8n-copy-btn";
                copyBtn.style.cssText = "background:#f5a623;border:none;border-radius:8px;color:#fff;font-weight:700;padding:0.4rem 0.9rem;cursor:pointer;white-space:nowrap;";
                copyBtn.innerHTML = "<i class=\"ti ti-copy\"></i> Copy";
                copyBtn.addEventListener("click", function() {
                    navigator.clipboard.writeText(pw).then(function() {
                        copyBtn.innerHTML = "<i class=\"ti ti-check\"></i> Copied!";
                        setTimeout(function() { copyBtn.innerHTML = "<i class=\"ti ti-copy\"></i> Copy"; }, 2000);
                    });
                });

                var closeBtn = document.createElement("button");
                closeBtn.style.cssText = "background:transparent;border:none;color:#b45309;cursor:pointer;font-size:1.2rem;padding:0 0.3rem;line-height:1;";
                closeBtn.title = "Dismiss";
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

            // ── 5. Button handlers ───────────────────────────────────────────────
            var resetPasswordHandler = function(e) {
                e.preventDefault();
                if (!serviceId) { alert("Service ID not found."); return; }
                var btn = document.getElementById("n8n-btn-changepw");
                if (!confirm("Reset your n8n password? A new random password will be generated.")) return;
                if (btn) { btn.disabled = true; btn.innerHTML = \'<i class="ti ti-loader-2 ti-spin me-2"></i> Resetting…\'; }
                fetch(apiUrl + "?action=resetPassword&serviceId=" + serviceId)
                .then(function(r) { return r.json(); })
                .then(function(d) {
                    if (btn) { btn.disabled = false; btn.innerHTML = \'<i class="ti ti-key me-2"></i> Change Password\'; }
                    if (d.success) {
                        showPwNotice(d.password || "(check your email)");
                    } else {
                        alert("Reset failed: " + (d.message || "Unknown error"));
                    }
                })
                .catch(function() {
                    if (btn) { btn.disabled = false; btn.innerHTML = \'<i class="ti ti-key me-2"></i> Change Password\'; }
                    alert("Request failed. Please try again.");
                });
            };

            var autoLoginHandler = function(e) {
                e.preventDefault();
                if (instanceUrl) {
                    window.open(instanceUrl, "_blank");
                } else {
                    alert("Instance URL not found.");
                }
            };

            document.getElementById("n8n-btn-changepw").addEventListener("click", resetPasswordHandler);
            document.getElementById("n8n-btn-autologin").addEventListener("click", autoLoginHandler);

            // ── 6. n8n Masterclass Promo Modal Handlers ───────────────────────
            window.openN8nMasterclassModal = function() {
                var modal = document.getElementById("n8nMasterclassModal");
                if (modal) modal.style.display = "flex";
            };
            window.closeN8nMasterclassModal = function() {
                var modal = document.getElementById("n8nMasterclassModal");
                if (modal) modal.style.display = "none";
            };

            var modalEl = document.getElementById("n8nMasterclassModal");
            if (modalEl) {
                modalEl.addEventListener("click", function(e) {
                    if (e.target === modalEl) {
                        window.closeN8nMasterclassModal();
                    }
                });
                // Auto open popup removed for privacy
                /*
                if (!localStorage.getItem("snbd_n8n_masterclass_dismissed")) {
                    setTimeout(function() {
                        modalEl.style.display = "flex";
                    }, 600);
                }
                */
            }

            var dismissBtn = document.getElementById("n8n-dismiss-masterclass-btn");
            if (dismissBtn) {
                dismissBtn.addEventListener("click", function() {
                    localStorage.setItem("snbd_n8n_masterclass_dismissed", "true");
                    window.closeN8nMasterclassModal();
                });
            }
        });
        </script>';
        
        return [$overrideKey => $newHtml];
    }
});

