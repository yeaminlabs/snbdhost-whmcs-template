<?php
/**
 * SNBD Host Network Status Proxy & Cache Fallback
 *
 * Serves cached network-status.json if it exists and is fresh (less than 1 hour old).
 * Otherwise, fetches fresh data, updates the cache, and serves the response.
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');

$cacheFile = __DIR__ . '/network-status.json';
$cacheLifetime = 3600; // 1 hour in seconds

// If cache exists and is fresh, serve it directly
if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheLifetime) {
    header('X-Cache: HIT');
    echo file_get_contents($cacheFile);
    exit;
}

header('X-Cache: MISS');

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
        // WHMCS bootstrap failed
    }
}

// Attempt 2: Read from local config
if (empty($apiKey)) {
    $configFile = __DIR__ . '/modules/addons/snbdhost_manager/uptimerobot_config.json';
    if (file_exists($configFile)) {
        $config = json_decode(file_get_contents($configFile), true);
        if (!empty($config['api_key'])) {
            $apiKey = $config['api_key'];
        }
    }
}

// Attempt 3: Legacy hardcoded fallback
if (empty($apiKey)) {
    $apiKey = 'ur2339866-94b2971de5cdd1408685a563';
}

$apiEndpoint = 'https://api.uptimerobot.com/v2/getMonitors';

$postData = http_build_query([
    'api_key' => $apiKey,
    'format' => 'json',
    'logs' => '0',
    'response_times' => '1',
    'response_times_limit' => '10',
    'custom_uptime_ratios' => '30',
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
if (!is_array($decoded) || !isset($decoded['stat'])) {
    // If the API returned invalid data, serve stale cache if we have it
    if (file_exists($cacheFile)) {
        header('X-Cache: STALE-FALLBACK');
        echo file_get_contents($cacheFile);
        exit;
    }
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

// Add metadata timestamp
$decoded['last_updated_timestamp'] = time();
$jsonContent = json_encode($decoded);

// Save to cache file
@file_put_contents($cacheFile, $jsonContent);

http_response_code(200);
echo $jsonContent;

