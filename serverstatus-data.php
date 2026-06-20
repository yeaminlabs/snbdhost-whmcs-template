<?php
/**
 * SNBD Host Network Status Proxy
 *
 * This endpoint fetches live monitor data from UptimeRobot server-side,
 * avoiding browser CORS restrictions on the portal page.
 * The API key is read from the WHMCS SNBDHost Theme Manager addon module config.
 */

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Access-Control-Allow-Origin: *');

// ─── Read API key from WHMCS addon module config ─────────────────────────
$apiKey = null;

// Attempt 1: Bootstrap WHMCS and read from database
if (file_exists(__DIR__ . '/init.php')) {
    try {
        require_once __DIR__ . '/init.php';
        if (class_exists('WHMCS\Database\Capsule')) {
            $apiKey = \WHMCS\Database\Capsule::table('tbladdonmodules')
                ->where('module', 'snbdhost_manager')
                ->where('setting', 'uptimerobot_api_key')
                ->value('value');
        }
    } catch (\Exception $e) {
        // WHMCS bootstrap failed — fall through to next attempt
    }
}

// Attempt 2: Read from a local config file (module writes this on save)
if (empty($apiKey)) {
    $configFile = __DIR__ . '/modules/addons/snbdhost_manager/uptimerobot_config.json';
    if (file_exists($configFile)) {
        $config = json_decode(file_get_contents($configFile), true);
        if (!empty($config['api_key'])) {
            $apiKey = $config['api_key'];
        }
    }
}

// Attempt 3: Legacy hardcoded fallback (for backwards compatibility)
if (empty($apiKey)) {
    $apiKey = 'ur2339866-94b2971de5cdd1408685a563';
}

$apiEndpoint = 'https://api.uptimerobot.com/v3/getMonitors';

$postData = http_build_query([
    'api_key' => $apiKey,
    'format' => 'json',
    'logs' => '0',
    'response_times' => '1',
    'response_times_limit' => '1',
    'uptime_ratio' => '30',
    'all_time_uptime_ratio' => '1',
]);

$ch = curl_init($apiEndpoint);
curl_setopt_array($ch, [
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $postData,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 20,
    CURLOPT_CONNECTTIMEOUT => 10,
    CURLOPT_HTTPHEADER => [
        'Content-Type: application/x-www-form-urlencoded',
        'Accept: application/json',
    ],
]);

$response = curl_exec($ch);
$curlErr = curl_error($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($response === false) {
    http_response_code(500);
    echo json_encode([
        'stat' => 'fail',
        'error' => [
            'message' => 'cURL error: ' . $curlErr,
        ],
    ]);
    exit;
}

$decoded = json_decode($response, true);
if (!is_array($decoded)) {
    http_response_code(500);
    echo json_encode([
        'stat' => 'fail',
        'error' => [
            'message' => 'Invalid JSON returned from UptimeRobot',
            'http_code' => $httpCode,
        ],
        'raw' => $response,
    ]);
    exit;
}

http_response_code($httpCode >= 200 && $httpCode < 300 ? 200 : 502);
echo json_encode($decoded);
