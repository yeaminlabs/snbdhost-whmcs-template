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
