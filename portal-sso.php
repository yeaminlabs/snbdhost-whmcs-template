<?php
declare(strict_types=1);

define('CLIENTAREA', true);
require __DIR__ . '/init.php';

if (empty($_SESSION['uid'])) {
    header('Location: login.php?redirect=portal-sso.php', true, 303);
    exit;
}

$secretPath = '/home/snbdhost-portal/.snbd-app-sso-secret';
$secret = is_readable($secretPath) ? trim((string) file_get_contents($secretPath)) : '';
$clientId = (int) $_SESSION['uid'];

if ($secret === '' || $clientId < 1) {
    http_response_code(503);
    exit('Single sign-on is temporarily unavailable.');
}

$payload = json_encode([
    'client_id' => $clientId,
    'iat' => time(),
    'exp' => time() + 60,
    'nonce' => bin2hex(random_bytes(16)),
], JSON_UNESCAPED_SLASHES);

$encoded = rtrim(strtr(base64_encode($payload), '+/', '-_'), '=');
$signature = hash_hmac('sha256', $encoded, $secret);
$token = $encoded . '.' . $signature;

header('Location: https://app.snbdhost.com/sso/portal?token=' . rawurlencode($token), true, 303);
exit;
