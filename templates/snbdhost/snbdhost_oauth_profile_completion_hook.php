<?php
/**
 * SNBD Host OAuth Profile Completion Hook
 * Prompts Google Sign-In users to provide their full billing address and phone number
 * before allowing access to the dashboard.
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

// Handle the POST request from the modal
add_hook('ClientAreaPage', 1, function($vars) {
    if (isset($_POST['action']) && $_POST['action'] === 'oauth_profile_complete' && isset($_SESSION['uid'])) {
        $userId = (int)$_SESSION['uid'];
        
        $address1 = trim($_POST['address1']);
        $phonenumber = trim($_POST['phonenumber']);
        $companyname = trim($_POST['companyname']);
        $address2 = trim($_POST['address2']);
        $city = trim($_POST['city']);
        $state = trim($_POST['state']);
        $postcode = trim($_POST['postcode']);
        $country = trim($_POST['country']);

        if (!empty($address1) && !empty($phonenumber) && !empty($city) && !empty($state) && !empty($postcode) && !empty($country)) {
            // Update using local API
            $command = 'UpdateClient';
            $postData = array(
                'clientid' => $userId,
                'companyname' => $companyname,
                'address1' => $address1,
                'address2' => $address2,
                'city' => $city,
                'state' => $state,
                'postcode' => $postcode,
                'country' => $country,
                'phonenumber' => $phonenumber,
            );
            localAPI($command, $postData);
            
            // Redirect to dashboard to remove the POST payload and prevent resubmission
            header("Location: clientarea.php");
            exit;
        }
    }
});

// Display the Modal if required fields are missing
add_hook('ClientAreaFooterOutput', 1, function($vars) {
    // Only check if a client is logged in
    if (empty($_SESSION['uid'])) {
        return '';
    }

    $userId = (int)$_SESSION['uid'];
    
    try {
        // Fetch the client's current details
        $client = Capsule::table('tblclients')->where('id', $userId)->first();
        
        if (!$client) {
            return '';
        }
        
        // Check if phone or address1 is missing (Google OAuth doesn't provide these)
        $missingFields = false;
        $addr = trim($client->address1);
        $phone = trim($client->phonenumber);
        
        if (empty($addr) || $addr === 'Pending Completion' || empty($phone) || $phone === '+00000000000') {
            $missingFields = true;
        }
        
        if ($missingFields) {
            
            // Try to load WHMCS Country list, fallback to a basic list if it fails
            $countryOptions = '<option value="BD">Bangladesh</option><option value="US">United States</option><option value="GB">United Kingdom</option><option value="CA">Canada</option><option value="AU">Australia</option><option value="IN">India</option>';
            try {
                if (class_exists('\WHMCS\Utility\Country')) {
                    $countryClass = new \WHMCS\Utility\Country();
                    $countries = $countryClass->getCountryNameArray();
                    if (!empty($countries)) {
                        $countryOptions = '';
                        foreach ($countries as $code => $name) {
                            $selected = ($code == 'BD') ? ' selected' : '';
                            $countryOptions .= '<option value="' . htmlspecialchars($code) . '"' . $selected . '>' . htmlspecialchars($name) . '</option>';
                        }
                    }
                }
            } catch (\Throwable $e) {}

            // Return HTML/CSS/JS for the blocking modal
            $html = '
            <style>
                #oauth-completion-modal {
                    position: fixed;
                    top: 0; left: 0; right: 0; bottom: 0;
                    background: rgba(15, 15, 15, 0.95);
                    z-index: 9999999;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    backdrop-filter: blur(10px);
                    font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                    overflow-y: auto;
                    padding: 2rem 1rem;
                }
                .oauth-modal-content {
                    background: #ffffff;
                    padding: 2.5rem;
                    border-radius: 12px;
                    max-width: 650px;
                    width: 100%;
                    box-shadow: 0 10px 50px rgba(0,0,0,0.25);
                    border: 1px solid #e0e0e0;
                    text-align: left;
                    animation: oauthSlideUp 0.5s cubic-bezier(0.22,1,0.36,1);
                    margin: auto;
                }
                @keyframes oauthSlideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
                .oauth-modal-title { font-size: 1.8rem; font-weight: 800; color: #1a1a1a; margin-bottom: 0.5rem; letter-spacing: -0.03em; }
                .oauth-modal-title span { color: #BA1114; }
                .oauth-modal-desc { font-size: 0.95rem; color: #555555; margin-bottom: 2rem; line-height: 1.6; }
                
                .oauth-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 1.25rem 1rem;
                    margin-bottom: 2rem;
                }
                .col-span-2 { grid-column: span 2; }
                @media(max-width: 500px) {
                    .oauth-grid { grid-template-columns: 1fr; }
                    .col-span-2 { grid-column: span 1; }
                }

                .oauth-input-label { display: block; font-size: 0.78rem; font-weight: 600; color: #666666; margin-bottom: 0.4rem; text-transform: uppercase; letter-spacing: 0.5px; }
                .oauth-input-label span.opt { font-weight: 400; text-transform: none; color: #999; }
                .oauth-input, .oauth-select { width: 100%; padding: 0.85rem 1rem; border: 1px solid #cccccc; border-radius: 6px; font-size: 0.95rem; transition: all 0.2s; background: #fff; }
                .oauth-input:focus, .oauth-select:focus { outline: none; border-color: #BA1114; box-shadow: 0 0 0 3px rgba(186,17,20,0.1); }
                
                .oauth-btn { background: #BA1114; color: #fff; border: none; width: 100%; padding: 1.1rem; font-size: 1rem; font-weight: 600; border-radius: 50rem; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 15px rgba(186,17,20,0.25); display: flex; align-items: center; justify-content: center; gap: 0.5rem; }
                .oauth-btn:hover { background: #9E0D10; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(186,17,20,0.3); }
            </style>
            <div id="oauth-completion-modal">
                <div class="oauth-modal-content">
                    <h2 class="oauth-modal-title">Welcome to <span>SNBD HOST</span></h2>
                    <p class="oauth-modal-desc">You have successfully signed in with Google. To secure your account and unlock purchasing, please provide your full billing profile.</p>
                    <form method="post" action="">
                        <input type="hidden" name="action" value="oauth_profile_complete" />
                        
                        <div class="oauth-grid">
                            <div class="col-span-2">
                                <label class="oauth-input-label" for="oauth_company">Company Name <span class="opt">(Optional)</span></label>
                                <input type="text" name="companyname" id="oauth_company" class="oauth-input" placeholder="e.g. Your Company Ltd.">
                            </div>

                            <div class="col-span-2">
                                <label class="oauth-input-label" for="oauth_address1">Street Address *</label>
                                <input type="text" name="address1" id="oauth_address1" class="oauth-input" placeholder="e.g. House, Road, Area" required>
                            </div>

                            <div class="col-span-2">
                                <label class="oauth-input-label" for="oauth_address2">Address Line 2 <span class="opt">(Optional)</span></label>
                                <input type="text" name="address2" id="oauth_address2" class="oauth-input" placeholder="e.g. Apartment, Suite, etc.">
                            </div>

                            <div>
                                <label class="oauth-input-label" for="oauth_city">City *</label>
                                <input type="text" name="city" id="oauth_city" class="oauth-input" placeholder="e.g. Dhaka" required>
                            </div>

                            <div>
                                <label class="oauth-input-label" for="oauth_state">State / Division *</label>
                                <input type="text" name="state" id="oauth_state" class="oauth-input" placeholder="e.g. Dhaka" required>
                            </div>

                            <div>
                                <label class="oauth-input-label" for="oauth_postcode">Postcode *</label>
                                <input type="text" name="postcode" id="oauth_postcode" class="oauth-input" placeholder="e.g. 1207" required>
                            </div>

                            <div>
                                <label class="oauth-input-label" for="oauth_country">Country *</label>
                                <select name="country" id="oauth_country" class="oauth-select" required>
                                    ' . $countryOptions . '
                                </select>
                            </div>
                            
                            <div class="col-span-2">
                                <label class="oauth-input-label" for="oauth_phonenumber">Phone Number *</label>
                                <input type="tel" name="phonenumber" id="oauth_phonenumber" class="oauth-input" placeholder="e.g. +1 555-0123" required>
                            </div>
                        </div>
                        
                        <button type="submit" class="oauth-btn" onclick="this.innerHTML=\'<i class=&quot;fas fa-spinner fa-spin&quot;></i> Saving Profile...\'; this.style.opacity=\'0.8\'; this.style.pointerEvents=\'none\'; this.form.submit();">
                            Complete Profile &amp; Unlock Dashboard <i class="fas fa-arrow-right"></i>
                        </button>
                    </form>
                </div>
            </div>
            <script>
                // Prevent scrolling on the body while modal is active
                document.body.style.overflow = "hidden";
            </script>
            ';
            return $html;
        }
    } catch (\Throwable $e) {
        // Fallback silently on DB error
    }
    
    return '';
});
