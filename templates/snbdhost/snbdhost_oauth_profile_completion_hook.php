<?php
/**
 * SNBD Host OAuth Profile Completion Hook
 * Prompts Google Sign-In users to provide missing phone number and address
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

        if (!empty($address1) && !empty($phonenumber)) {
            // Update using local API
            $command = 'UpdateClient';
            $postData = array(
                'clientid' => $userId,
                'address1' => $address1,
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
                }
                .oauth-modal-content {
                    background: #ffffff;
                    padding: 3rem 2.5rem;
                    border-radius: 12px;
                    max-width: 480px;
                    width: 90%;
                    box-shadow: 0 10px 50px rgba(0,0,0,0.25);
                    border: 1px solid #e0e0e0;
                    text-align: left;
                    animation: oauthSlideUp 0.5s cubic-bezier(0.22,1,0.36,1);
                }
                @keyframes oauthSlideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
                .oauth-modal-title { font-size: 1.8rem; font-weight: 800; color: #1a1a1a; margin-bottom: 0.5rem; letter-spacing: -0.03em; }
                .oauth-modal-title span { color: #BA1114; }
                .oauth-modal-desc { font-size: 0.95rem; color: #555555; margin-bottom: 2rem; line-height: 1.6; }
                .oauth-input-label { display: block; font-size: 0.78rem; font-weight: 600; color: #666666; margin-bottom: 0.4rem; text-transform: uppercase; letter-spacing: 0.5px; }
                .oauth-input { width: 100%; padding: 0.9rem 1rem; border: 1px solid #cccccc; border-radius: 6px; margin-bottom: 1.25rem; font-size: 0.95rem; transition: all 0.2s; }
                .oauth-input:focus { outline: none; border-color: #BA1114; box-shadow: 0 0 0 3px rgba(186,17,20,0.1); }
                .oauth-btn { background: #BA1114; color: #fff; border: none; width: 100%; padding: 1.1rem; font-size: 1rem; font-weight: 600; border-radius: 50rem; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 15px rgba(186,17,20,0.25); }
                .oauth-btn:hover { background: #9E0D10; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(186,17,20,0.3); }
            </style>
            <div id="oauth-completion-modal">
                <div class="oauth-modal-content">
                    <h2 class="oauth-modal-title">Welcome to <span>SNBD HOST</span></h2>
                    <p class="oauth-modal-desc">You have successfully signed in with Google. To secure your account and unlock purchasing, please provide your billing address and phone number.</p>
                    <form method="post" action="">
                        <input type="hidden" name="action" value="oauth_profile_complete" />
                        
                        <label class="oauth-input-label" for="oauth_address1">Billing Address *</label>
                        <input type="text" name="address1" id="oauth_address1" class="oauth-input" placeholder="e.g. 123 Main Street" required>
                        
                        <label class="oauth-input-label" for="oauth_phonenumber">Phone Number *</label>
                        <input type="tel" name="phonenumber" id="oauth_phonenumber" class="oauth-input" placeholder="e.g. +1 555-0123" required>
                        
                        <button type="submit" class="oauth-btn">Complete Profile &amp; Unlock Dashboard <i class="fas fa-arrow-right"></i></button>
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
