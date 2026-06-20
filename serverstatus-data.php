<?php
/**
 * SNBD Host Network Status Proxy
 *
 * This endpoint fetches live monitor data from UptimeRobot server-side,
 * avoiding browser CORS restrictions on the portal page.
 */

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');

$apiKey = 'ur2339866-94b2971de5cdd1408685a563';
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
