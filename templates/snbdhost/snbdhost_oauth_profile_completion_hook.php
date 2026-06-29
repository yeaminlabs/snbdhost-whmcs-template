<?php
use Illuminate\Database\Capsule\Manager as Capsule;

// ── PURE SERVER-SIDE INTERCEPTOR FOR GOOGLE IDENTITY SERVICES ──
add_hook('AfterSetup', 1, function($vars) {
    if (strpos($_SERVER['REQUEST_URI'], 'google_signin/finalize') !== false && $_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['id_token'])) {
        $tokenParts = explode('.', $_POST['id_token']);
        if (count($tokenParts) === 3) {
            $payload = json_decode(base64_decode(str_replace(['-', '_'], ['+', '/'], $tokenParts[1])), true);
            if ($payload && isset($payload['email'])) {
                $email = $payload['email'];
                
                try {
                    $client = Capsule::table('tblclients')->where('email', $email)->first();
                    
                    if (!$client) {
                        // NEW USER! Bypass WHMCS logic completely and create them.
                        $command = 'AddClient';
                        $postData = array(
                            'firstname' => $payload['given_name'] ?: 'Unknown',
                            'lastname' => $payload['family_name'] ?: 'Unknown',
                            'email' => $email,
                            'phonenumber' => '+00000000000',
                            'address1' => 'Pending Completion',
                            'city' => 'N/A',
                            'state' => 'N/A',
                            'postcode' => '0000',
                            'country' => 'BD',
                            'password' => 'G00gleAuth!2026_' . substr(md5(uniqid()), 0, 8),
                            'customfields' => base64_encode(serialize(array(
                                '9' => 'Google' // Pre-fill "How did you find us" with Google for these users
                            ))),
                        );
                        $result = localAPI($command, $postData);
                        
                        if ($result['result'] == 'success') {
                            $newClientId = $result['clientid'];
                            
                            // Link the Google account in the database
                            Capsule::table('tblauthn_account_links')->insert([
                                'client_id' => $newClientId,
                                'provider_id' => 'google_signin', 
                                'remote_user_id' => $payload['sub'],
                                'date_linked' => date('Y-m-d H:i:s'),
                            ]);
                            
                            // Log them in immediately
                            $newClient = Capsule::table('tblclients')->where('id', $newClientId)->first();
                            $_SESSION['uid'] = $newClient->id;
                            $_SESSION['upw'] = $newClient->password;
                            
                            // Send success response back to Google JS so it redirects them to dashboard!
                            header('Content-Type: application/json');
                            echo json_encode(['redirectUrl' => '/clientarea.php']);
                            exit;
                        } else {
                            // If AddClient fails, return the error to the console
                            header('Content-Type: application/json');
                            echo json_encode(['error' => 'Auto-registration failed: ' . $result['message']]);
                            exit;
                        }
                    }
                } catch (Exception $e) {
                    // Ignore DB errors, let normal WHMCS logic proceed
                }
            }
        }
    }
});

// ── Existing Hooks ──
add_hook('ClientAreaPrimarySidebar', 1, function($primarySidebar) {
    if (isset($_SESSION['uid'])) {
        $client = Capsule::table('tblclients')->where('id', $_SESSION['uid'])->first();
        if ($client && ($client->phonenumber === '+00000000000' || $client->address1 === 'Pending Completion')) {
            $myAccount = $primarySidebar->getChild('My Account');
            if ($myAccount) {
                $myAccount->removeChild('Security Settings');
            }
        }
    }
});
