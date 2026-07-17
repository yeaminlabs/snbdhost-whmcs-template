<?php
/**
 * Hermes Agent — AJAX domain management endpoint
 * Called from clientarea.tpl via fetch()
 *
 * Actions: add_domain | verify_domain | remove_domain
 */

define('WHMCS', true);
require dirname(dirname(dirname(dirname(__DIR__)))) . '/init.php';

use WHMCS\Database\Capsule;

header('Content-Type: application/json');

// ─── Auth: must be logged-in client owning this service ─────────────────────

$serviceId = (int)($_POST['serviceId'] ?? $_GET['serviceId'] ?? 0);
if (!$serviceId) { echo json_encode(['success' => false, 'error' => 'Missing serviceId']); exit; }

$authService = Capsule::table('tblhosting')
    ->where('id', $serviceId)
    ->where('userid', $_SESSION['uid'] ?? 0)
    ->first();

if (!$authService) { echo json_encode(['success' => false, 'error' => 'Unauthorized']); exit; }

// ─── Load server credentials ─────────────────────────────────────────────────

$server = Capsule::table('tblservers')->where('id', $authService->serverid)->first();
$host   = $server->hostname ?: $server->ipaddress;
$pass   = decrypt($server->password);

$serverIp = '46.62.205.66';

// ─── Helpers ─────────────────────────────────────────────────────────────────

function ha_ssh($host, $pass, $cmd) {
    $safePass = escapeshellarg($pass);
    $safeHost = escapeshellarg($host);
    $safeCmd  = escapeshellarg($cmd);
    return shell_exec("sshpass -p $safePass ssh -o StrictHostKeyChecking=no -o ConnectTimeout=15 root@$safeHost $safeCmd 2>&1");
}

function ha_mainPort($sid) { return 7300 + (int)$sid; }

function ha_confFile($domain) {
    return '/etc/caddy/conf.d/' . preg_replace('/[^a-zA-Z0-9._-]/', '_', $domain) . '.conf';
}

function ha_writeCaddy($host, $pass, $sid, $domain) {
    $port = ha_mainPort($sid);
    $conf = "{$domain} {\n    reverse_proxy 127.0.0.1:{$port}\n}\n";
    $b64  = base64_encode($conf);
    $file = ha_confFile($domain);
    $cmd  = "echo '" . $b64 . "' | base64 -d > " . escapeshellarg($file) . " && systemctl reload caddy";
    ha_ssh($host, $pass, $cmd);
}

function ha_removeCaddy($host, $pass, $domain) {
    $file = ha_confFile($domain);
    ha_ssh($host, $pass, "rm -f " . escapeshellarg($file) . " && systemctl reload caddy");
}

// ─── Actions ─────────────────────────────────────────────────────────────────

$action = $_POST['action'] ?? '';

// ── Add domain ──────────────────────────────────────────────────────────────
if ($action === 'add_domain') {
    $domain = strtolower(trim($_POST['domain'] ?? ''));
    $type   = $_POST['type'] === 'custom' ? 'custom' : 'hermes';

    if (!preg_match('/^[a-z0-9]([a-z0-9\-]{0,61}[a-z0-9])?(\.[a-z0-9]([a-z0-9\-]{0,61}[a-z0-9])?)+$/', $domain)) {
        echo json_encode(['success' => false, 'error' => 'Invalid domain format']); exit;
    }

    if (Capsule::table('mod_hermesagent_domains')->where('domain', $domain)->exists()) {
        echo json_encode(['success' => false, 'error' => 'Domain already in use']); exit;
    }

    if ($type === 'hermes') {
        if (!preg_match('/^[a-z0-9\-]+\.hermes\.deltadns\.xyz$/', $domain)) {
            echo json_encode(['success' => false, 'error' => 'Hermes subdomains must end in .hermes.deltadns.xyz']); exit;
        }
        ha_writeCaddy($host, $pass, $serviceId, $domain);
        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $serviceId, 'domain' => $domain,
            'type' => 'hermes', 'status' => 'active',
            'created_at' => date('Y-m-d H:i:s'), 'updated_at' => date('Y-m-d H:i:s'),
        ]);
        echo json_encode(['success' => true, 'status' => 'active', 'domain' => $domain]);

    } else {
        // Custom domain — save as pending, client must set A record
        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $serviceId, 'domain' => $domain,
            'type' => 'custom', 'status' => 'pending',
            'created_at' => date('Y-m-d H:i:s'), 'updated_at' => date('Y-m-d H:i:s'),
        ]);
        echo json_encode([
            'success'  => true,
            'status'   => 'pending',
            'domain'   => $domain,
            'a_record' => $serverIp,
        ]);
    }
    exit;
}

// ── Verify DNS for custom domain ─────────────────────────────────────────────
if ($action === 'verify_domain') {
    $domain = strtolower(trim($_POST['domain'] ?? ''));

    $row = Capsule::table('mod_hermesagent_domains')
        ->where('domain', $domain)->where('service_id', $serviceId)->first();
    if (!$row) { echo json_encode(['success' => false, 'error' => 'Domain not found']); exit; }

    $records = @dns_get_record($domain, DNS_A);
    $resolved = false;
    $foundIp  = '';
    foreach ((array)$records as $r) {
        if (($r['ip'] ?? '') === $serverIp) { $resolved = true; break; }
        $foundIp = $r['ip'] ?? '';
    }

    if (!$resolved) {
        $hint = $foundIp ? " (currently points to {$foundIp})" : " (no A record found)";
        echo json_encode(['success' => false, 'error' => "DNS not yet pointing to {$serverIp}{$hint}"]); exit;
    }

    ha_writeCaddy($host, $pass, $serviceId, $domain);
    Capsule::table('mod_hermesagent_domains')
        ->where('domain', $domain)->where('service_id', $serviceId)
        ->update(['status' => 'active', 'updated_at' => date('Y-m-d H:i:s')]);

    echo json_encode(['success' => true, 'status' => 'active']);
    exit;
}

// ── Remove domain ─────────────────────────────────────────────────────────────
if ($action === 'remove_domain') {
    $domainId = (int)($_POST['domain_id'] ?? 0);

    $row = Capsule::table('mod_hermesagent_domains')
        ->where('id', $domainId)->where('service_id', $serviceId)->first();
    if (!$row) { echo json_encode(['success' => false, 'error' => 'Domain not found']); exit; }

    // Default domain cannot be removed
    if ($row->domain === $serviceId . '.hermes.deltadns.xyz') {
        echo json_encode(['success' => false, 'error' => 'Cannot remove the default domain']); exit;
    }

    if ($row->status === 'active') {
        ha_removeCaddy($host, $pass, $row->domain);
    }
    Capsule::table('mod_hermesagent_domains')->where('id', $domainId)->delete();
    echo json_encode(['success' => true]);
    exit;
}

echo json_encode(['success' => false, 'error' => 'Unknown action']);
