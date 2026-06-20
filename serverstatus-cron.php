<?php
/**
 * SNBD Host Network Status Cron Generator
 *
 * This script is intended to be run hourly via a cron job:
 * php -q /path/to/your/whmcs/serverstatus-cron.php
 *
 * It fetches the monitor data from UptimeRobot and writes it to a static
 * JSON file (network-status.json) in the WHMCS root directory.
 */

// Define absolute path to output JSON
$outputPath = __DIR__ . '/network-status.json';

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

// Attempt 2: Read from local config file
if (empty($apiKey)) {
    $configFile = __DIR__ . '/modules/addons/snbdhost_manager/uptimerobot_config.json';
    if (file_exists($configFile)) {
        $config = json_decode(file_get_contents($configFile), true);
        if (!empty($config['api_key'])) {
            $apiKey = $config['api_key'];
        }
    }
}

// Attempt 3: Fallback hardcoded key
if (empty($apiKey)) {
    $apiKey = 'u2339866-3ab3be785151b426419bea0b';
}

$apiEndpoint = 'https://api.uptimerobot.com/v2/getMonitors';

$postData = http_build_query([
    'api_key' => $apiKey,
    'format' => 'json',
    'logs' => '0',
    'response_times' => '1',
    'response_times_limit' => '10', // Let's get up to 10 response times for a nice sparkline
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
    $errorMsg = 'cURL error: ' . $curlErr;
    echo "Error: " . $errorMsg . "\n";
    exit(1);
}

$decoded = json_decode($response, true);
if (!is_array($decoded) || !isset($decoded['stat'])) {
    echo "Error: Invalid response from UptimeRobot API\n";
    exit(1);
}

// Add a timestamp of the last generation/fetch so the client can display the actual cache age
$decoded['last_updated_timestamp'] = time();

$jsonContent = json_encode($decoded, JSON_PRETTY_PRINT);

if (file_put_contents($outputPath, $jsonContent) === false) {
    echo "Error: Failed to write to " . $outputPath . "\n";
    exit(1);
}

echo "Success: UptimeRobot cache file generated successfully at " . date('Y-m-d H:i:s') . "\n";
exit(0);
