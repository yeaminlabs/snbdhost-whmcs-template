<?php
/**
 * Hermes Agent — Domain Management AJAX endpoint
 * Actions: add_domain | verify_domain | remove_domain
 */

define('WHMCS', true);
$whmcsRoot = dirname(dirname(dirname(dirname(__DIR__))));
require $whmcsRoot . '/init.php';

use Illuminate\Database\Capsule\Manager as Capsule;

header('Content-Type: application/json');

// ─── Auth ────────────────────────────────────────────────────────────────────

$serviceId = (int)($_POST['serviceId'] ?? $_GET['serviceId'] ?? 0);
if (!$serviceId) { echo json_encode(['success' => false, 'error' => 'Missing serviceId']); exit; }

$uid = $_SESSION['uid'] ?? 0;
if (!$uid) { echo json_encode(['success' => false, 'error' => 'Not logged in']); exit; }

$svc = Capsule::table('tblhosting')->where('id', $serviceId)->where('userid', $uid)->first();
if (!$svc) { echo json_encode(['success' => false, 'error' => 'Unauthorized']); exit; }

// ─── Server credentials ──────────────────────────────────────────────────────

$server = Capsule::table('tblservers')->where('id', $svc->serverid)->first();
if (!$server) { echo json_encode(['success' => false, 'error' => 'Server config not found']); exit; }

$serverParams = [
    'serverip'          => $server->ipaddress,
    'serverhostname'    => $server->hostname,
    'serverport'        => $server->port ?: 22,
    'serverusername'    => $server->username,
    'serverpassword'    => decrypt($server->password),
    'serveraccesshash'  => $server->accesshash,
];

// ─── Instance record ─────────────────────────────────────────────────────────

$instance = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceId)->first();
if (!$instance) { echo json_encode(['success' => false, 'error' => 'Instance not found']); exit; }

$hostPort = $instance->host_port ?: (7300 + ($serviceId % 1000));
$dashPort = $instance->dash_port;
$serverIp = '46.62.205.66';

// ─── Helpers ─────────────────────────────────────────────────────────────────

require_once __DIR__ . '/hermesagent.php';

function ha_get_ssh() {
    global $serverParams;
    return hermesagent_get_ssh_client($serverParams, 15);
}

function ha_conf_file($domain) {
    return '/etc/caddy/conf.d/' . preg_replace('/[^a-zA-Z0-9._-]/', '_', $domain) . '.conf';
}

function ha_write_caddy($ssh, $domain, $hostPort, $dashPort) {
    hermesagent_domain_write_caddy($ssh, 0, $domain, $hostPort, $dashPort);
}

function ha_remove_caddy($ssh, $domain) {
    hermesagent_domain_remove_caddy($ssh, $domain);
}

// ─── Actions ─────────────────────────────────────────────────────────────────

$action = $_POST['action'] ?? '';

if ($action === 'add_domain') {
    $domain = strtolower(trim($_POST['domain'] ?? ''));
    $type   = ($_POST['type'] ?? '') === 'custom' ? 'custom' : 'hermes';

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
        try {
            $ssh = ha_get_ssh();
            hermesagent_domain_write_caddy($ssh, $serviceId, $domain, $hostPort, $dashPort);
        } catch (\Exception $e) {
            echo json_encode(['success' => false, 'error' => 'SSH failed: ' . $e->getMessage()]); exit;
        }
        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $serviceId, 'domain' => $domain,
            'type' => 'hermes', 'status' => 'active',
            'created_at' => date('Y-m-d H:i:s'), 'updated_at' => date('Y-m-d H:i:s'),
        ]);
        echo json_encode(['success' => true, 'status' => 'active', 'domain' => $domain]);

    } else {
        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $serviceId, 'domain' => $domain,
            'type' => 'custom', 'status' => 'pending',
            'created_at' => date('Y-m-d H:i:s'), 'updated_at' => date('Y-m-d H:i:s'),
        ]);
        echo json_encode(['success' => true, 'status' => 'pending', 'domain' => $domain, 'a_record' => $serverIp]);
    }
    exit;
}

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
        $hint = $foundIp ? " (currently points to {$foundIp})" : " (no A record found yet)";
        echo json_encode(['success' => false, 'error' => "DNS not yet pointing to {$serverIp}{$hint}"]); exit;
    }

    try {
        $ssh = ha_get_ssh();
        hermesagent_domain_write_caddy($ssh, $serviceId, $domain, $hostPort, $dashPort);
    } catch (\Exception $e) {
        echo json_encode(['success' => false, 'error' => 'SSH failed: ' . $e->getMessage()]); exit;
    }
    Capsule::table('mod_hermesagent_domains')
        ->where('domain', $domain)->where('service_id', $serviceId)
        ->update(['status' => 'active', 'updated_at' => date('Y-m-d H:i:s')]);
    echo json_encode(['success' => true, 'status' => 'active']);
    exit;
}

if ($action === 'remove_domain') {
    $domainId = (int)($_POST['domain_id'] ?? 0);
    $row = Capsule::table('mod_hermesagent_domains')
        ->where('id', $domainId)->where('service_id', $serviceId)->first();
    if (!$row) { echo json_encode(['success' => false, 'error' => 'Domain not found']); exit; }
    if ($row->domain === $serviceId . '.hermes.deltadns.xyz') {
        echo json_encode(['success' => false, 'error' => 'Cannot remove default domain']); exit;
    }
    if ($row->status === 'active') {
        try {
            $ssh = ha_get_ssh();
            hermesagent_domain_remove_caddy($ssh, $row->domain);
        } catch (\Exception $e) { /* log but continue */ }
    }
    Capsule::table('mod_hermesagent_domains')->where('id', $domainId)->delete();
    echo json_encode(['success' => true]);
    exit;
}

echo json_encode(['success' => false, 'error' => 'Unknown action']);
