<?php
use WHMCS\Database\Capsule;

define('CLIENTAREA', true);

// Bootstrap WHMCS
require __DIR__ . '/init.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST['id_token'])) {
    echo json_encode(['error' => 'Invalid request']);
    exit;
}

// Validate CSRF token (WHMCS core helper)
try {
    check_token();
} catch (\Exception $e) {
    echo json_encode(['error' => 'Invalid CSRF token']);
    exit;
}

$idToken = $_POST['id_token'];
$tokenParts = explode('.', $idToken);
if (count($tokenParts) !== 3) {
    echo json_encode(['error' => 'Invalid token format']);
    exit;
}

$header = json_decode(base64_decode(strtr($tokenParts[0], '-_', '+/')), true);
$payload = json_decode(base64_decode(strtr($tokenParts[1], '-_', '+/')), true);

if (!$header || !$payload || empty($payload['email']) || empty($payload['sub'])) {
    echo json_encode(['error' => 'Invalid token payload']);
    exit;
}

// Get Google Client ID from settings
$setting = Capsule::table('tbladdonmodules')
    ->where('module', 'snbdhost_manager')
    ->where('setting', 'google_client_id')
    ->first();
$googleClientId = $setting ? $setting->value : '219815663641-p50rq613ol3ilqgbotogg4bb4hvg9s1e.apps.googleusercontent.com';

// Verify JWT
$isValid = false;
$verifyError = '';

$jwksCacheFile = __DIR__ . '/modules/addons/snbdhost_manager/google_jwks.json';
$jwks = null;

if (file_exists($jwksCacheFile) && filemtime($jwksCacheFile) > time() - 3600) {
    $jwks = json_decode(file_get_contents($jwksCacheFile), true);
} else {
    $ch = curl_init('https://www.googleapis.com/oauth2/v3/certs');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    $response = curl_exec($ch);
    curl_close($ch);
    if ($response) {
        $jwks = json_decode($response, true);
        if ($jwks) {
            file_put_contents($jwksCacheFile, json_encode($jwks));
        }
    }
}

if (!$jwks || !isset($jwks['keys'])) {
    echo json_encode(['error' => 'Failed to fetch Google certificates']);
    exit;
}

if (class_exists('Firebase\JWT\JWT') && class_exists('Firebase\JWT\JWK')) {
    try {
        $keys = \Firebase\JWT\JWK::parseKeySet($jwks);
        
        // Handle different versions of firebase/php-jwt dynamically
        $ref = new \ReflectionMethod('Firebase\JWT\JWT', 'decode');
        $params = $ref->getParameters();
        if (count($params) >= 3) {
            // Older versions (v5) require the allowed algorithms array
            $decoded = \Firebase\JWT\JWT::decode($idToken, $keys, ['RS256']);
        } else {
            // Newer versions (v6+) expect Key objects and no algorithms array
            $decoded = \Firebase\JWT\JWT::decode($idToken, $keys);
        }
        $isValid = true;
    } catch (\Exception $e) {
        $verifyError = $e->getMessage();
    }
} else {
    // Fallback: Verify via Google's tokeninfo endpoint if local JWT libraries are unavailable/incompatible
    $ch = curl_init('https://oauth2.googleapis.com/tokeninfo?id_token=' . urlencode($idToken));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    $resp = curl_exec($ch);
    curl_close($ch);
    
    $tokenInfo = json_decode($resp, true);
    if ($tokenInfo && isset($tokenInfo['aud']) && $tokenInfo['aud'] === $googleClientId && isset($tokenInfo['sub']) && $tokenInfo['sub'] === $payload['sub']) {
        $isValid = true;
    } else {
        $verifyError = 'Google tokeninfo verification failed: ' . ($tokenInfo['error_description'] ?? 'Unknown error');
    }
}

if (!$isValid) {
    echo json_encode(['error' => 'Invalid token signature. ' . $verifyError]);
    exit;
}

// Claims validation
if ($payload['aud'] !== $googleClientId) {
    echo json_encode(['error' => 'Invalid audience']);
    exit;
}
if (!in_array($payload['iss'], ['accounts.google.com', 'https://accounts.google.com'])) {
    echo json_encode(['error' => 'Invalid issuer']);
    exit;
}
if (isset($payload['exp']) && $payload['exp'] < time()) {
    echo json_encode(['error' => 'Token has expired']);
    exit;
}

$email = $payload['email'];
$googleSub = $payload['sub'];

// Check tblclients
$client = Capsule::table('tblclients')->where('email', $email)->first();

if (!$client) {
    // Register new user placeholder
    $result = localAPI('AddClient', [
        'firstname' => $payload['given_name'] ?? 'Unknown',
        'lastname' => $payload['family_name'] ?? 'Unknown',
        'email' => $email,
        'phonenumber' => '+00000000000',
        'address1' => 'Pending Completion',
        'city' => 'N/A',
        'state' => 'N/A',
        'postcode' => '0000',
        'country' => 'BD',
        'password' => 'G00gleAuth!' . bin2hex(random_bytes(8)),
        'customfields' => base64_encode(serialize(['9' => 'Google'])),
    ]);
    
    if ($result['result'] !== 'success') {
        echo json_encode(['error' => 'Failed to create client account: ' . ($result['message'] ?? 'Unknown error')]);
        exit;
    }
    
    $client = Capsule::table('tblclients')->where('id', $result['clientid'])->first();
    if (!$client) {
        echo json_encode(['error' => 'Client created but not found']);
        exit;
    }
} else {
    // Check for 2FA on existing user (Fail safe: if 2faenabled is true, require password)
    $twoFaRequired = false;
    $userClientLink = Capsule::table('tblusers_clients')->where('client_id', $client->id)->first();
    if ($userClientLink) {
        $user = Capsule::table('tblusers')->where('id', $userClientLink->user_id)->first();
        if ($user && isset($user->twofaenabled) && $user->twofaenabled) {
            $twoFaRequired = true;
        }
    }
    
    // Also check tblclients.twofaenabled (legacy WHMCS or fallback)
    if (!$twoFaRequired && isset($client->twofaenabled) && $client->twofaenabled) {
        $twoFaRequired = true;
    }
    
    if ($twoFaRequired) {
        echo json_encode(['error' => 'twofa_required']);
        exit;
    }
}

// Upsert in mod_snbd_google_links
try {
    if (!Capsule::schema()->hasTable('mod_snbd_google_links')) {
        Capsule::schema()->create('mod_snbd_google_links', function ($table) {
            $table->increments('id');
            $table->integer('client_id')->default(0);
            $table->string('google_sub', 255)->unique();
            $table->string('email', 255);
            $table->timestamps();
        });
    }
    
    $existingLink = Capsule::table('mod_snbd_google_links')->where('google_sub', $googleSub)->first();
    if (!$existingLink) {
        Capsule::table('mod_snbd_google_links')->insert([
            'client_id' => $client->id,
            'google_sub' => $googleSub,
            'email' => $email,
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
        ]);
    } else if ($existingLink->client_id != $client->id) {
        // Update client_id if email was merged/changed
        Capsule::table('mod_snbd_google_links')->where('id', $existingLink->id)->update([
            'client_id' => $client->id,
            'email' => $email,
            'updated_at' => date('Y-m-d H:i:s')
        ]);
    }
} catch (\Exception $e) {
    // Ignore schema errors if table creation fails for some reason
}

// Generate SSO Token
$ssoResult = localAPI('CreateSsoToken', [
    'client_id' => $client->id,
    'destination' => 'clientarea:home'
]);

if ($ssoResult['result'] === 'success') {
    // Typically redirect_url or access_url or full_url
    $redirectUrl = $ssoResult['redirect_url'] ?? $ssoResult['access_url'] ?? $ssoResult['full_url'] ?? '/clientarea.php';
    echo json_encode(['redirect' => $redirectUrl]);
} else {
    echo json_encode(['error' => 'Failed to generate SSO token: ' . ($ssoResult['message'] ?? 'Unknown error')]);
}
exit;
