<?php
/**
 * Hermes Agent — WHMCS Server Module
 *
 * Provisions Hermes Agent Docker containers on the shared VPS (46.62.205.66).
 * Each service gets:
 *   - Container: hermes-{serviceId}
 *   - Default URL: {serviceId}.hermes.deltadns.xyz
 *   - Port scheme: main=7300+id, dashboard=9119+id, api=8642+id
 *
 * Domain management (add/verify/remove) is handled via ajax.php.
 */

if (!defined("WHMCS")) die("This file cannot be accessed directly");

use WHMCS\Database\Capsule;

// ─── Module metadata ────────────────────────────────────────────────────────

function hermesagent_MetaData() {
    return [
        'DisplayName'  => 'Hermes Agent',
        'APIVersion'   => '1.1',
        'RequiresServer' => true,
    ];
}

function hermesagent_ConfigOptions() {
    return [
        'Memory Limit' => ['Type' => 'text', 'Size' => '6', 'Default' => '4g', 'Description' => 'e.g. 2g, 4g, 8g'],
        'CPU Limit'    => ['Type' => 'text', 'Size' => '4', 'Default' => '2',  'Description' => 'Number of vCPUs'],
    ];
}

// ─── Helpers ────────────────────────────────────────────────────────────────

function hermesagent_initDB() {
    if (!Capsule::schema()->hasTable('mod_hermesagent_domains')) {
        Capsule::schema()->create('mod_hermesagent_domains', function ($t) {
            $t->increments('id');
            $t->integer('service_id')->unsigned()->index();
            $t->string('domain', 255)->unique();
            $t->enum('type', ['hermes', 'custom'])->default('hermes');
            $t->enum('status', ['active', 'pending', 'failed'])->default('pending');
            $t->timestamps();
        });
    }
}

function hermesagent_ssh($host, $password, $cmd) {
    $safePass = escapeshellarg($password);
    $safeHost = escapeshellarg($host);
    $safeCmd  = escapeshellarg($cmd);
    return shell_exec("sshpass -p $safePass ssh -o StrictHostKeyChecking=no -o ConnectTimeout=15 root@$safeHost $safeCmd 2>&1");
}

function hermesagent_mainPort($serviceId)  { return 7300 + (int)$serviceId; }
function hermesagent_dashPort($serviceId)  { return 9119 + (int)$serviceId; }
function hermesagent_apiPort($serviceId)   { return 8642 + (int)$serviceId; }
function hermesagent_defaultDomain($serviceId) { return $serviceId . '.hermes.deltadns.xyz'; }
function hermesagent_confFile($domain) {
    return '/etc/caddy/conf.d/' . preg_replace('/[^a-zA-Z0-9._-]/', '_', $domain) . '.conf';
}

function hermesagent_writeCaddy($host, $password, $serviceId, $domain) {
    $port = hermesagent_mainPort($serviceId);
    $file = hermesagent_confFile($domain);
    $conf = "{$domain} {\n    reverse_proxy 127.0.0.1:{$port}\n}\n";
    $b64  = base64_encode($conf);
    $cmd  = "echo '{$b64}' | base64 -d > " . escapeshellarg($file) . " && systemctl reload caddy";
    return hermesagent_ssh($host, $password, $cmd);
}

function hermesagent_removeCaddy($host, $password, $domain) {
    $file = hermesagent_confFile($domain);
    return hermesagent_ssh($host, $password, "rm -f " . escapeshellarg($file) . " && systemctl reload caddy");
}

// ─── Provisioning ───────────────────────────────────────────────────────────

function hermesagent_CreateAccount($params) {
    try {
        hermesagent_initDB();

        $sid      = $params['serviceid'];
        $host     = $params['serverhostname'] ?: $params['serverip'];
        $pass     = $params['serverpassword'];
        $mem      = $params['configoptions']['Memory Limit'] ?: '4g';
        $cpu      = $params['configoptions']['CPU Limit'] ?: '2';
        $mainPort = hermesagent_mainPort($sid);
        $dashPort = hermesagent_dashPort($sid);
        $apiPort  = hermesagent_apiPort($sid);
        $name     = 'hermes-' . $sid;

        // Pull image & start container
        hermesagent_ssh($host, $pass, "docker pull nousresearch/hermes-agent:latest 2>&1 | tail -1");

        $run = "docker run -d --name {$name} --restart unless-stopped " .
               "-p 127.0.0.1:{$mainPort}:3000 " .
               "-p 127.0.0.1:{$apiPort}:8642 " .
               "-p 127.0.0.1:{$dashPort}:9119 " .
               "--memory={$mem} --cpus={$cpu} " .
               "-e HERMES_DASHBOARD=1 -e HERMES_DASHBOARD_HOST=0.0.0.0 " .
               "-e HERMES_DASHBOARD_PORT=9119 " .
               "-e OPENAI_API_BASE=https://ai-proxy.snbdhost.com/v1 " .
               "-e OPENAI_BASE_URL=https://ai-proxy.snbdhost.com/v1 " .
               "-e OPENAI_API_KEY=sk-snbdhost-master-key-2026 " .
               "nousresearch/hermes-agent:latest";
        hermesagent_ssh($host, $pass, $run);

        // Default subdomain
        $defaultDomain = hermesagent_defaultDomain($sid);
        hermesagent_writeCaddy($host, $pass, $sid, $defaultDomain);

        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $sid,
            'domain'     => $defaultDomain,
            'type'       => 'hermes',
            'status'     => 'active',
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        return 'success';
    } catch (Exception $e) {
        return $e->getMessage();
    }
}

function hermesagent_SuspendAccount($params) {
    $sid  = $params['serviceid'];
    $host = $params['serverhostname'] ?: $params['serverip'];
    $pass = $params['serverpassword'];
    hermesagent_ssh($host, $pass, "docker stop hermes-{$sid} 2>&1");
    return 'success';
}

function hermesagent_UnsuspendAccount($params) {
    $sid  = $params['serviceid'];
    $host = $params['serverhostname'] ?: $params['serverip'];
    $pass = $params['serverpassword'];
    hermesagent_ssh($host, $pass, "docker start hermes-{$sid} 2>&1");
    return 'success';
}

function hermesagent_TerminateAccount($params) {
    try {
        hermesagent_initDB();
        $sid  = $params['serviceid'];
        $host = $params['serverhostname'] ?: $params['serverip'];
        $pass = $params['serverpassword'];

        // Remove all Caddy configs for this service
        $domains = Capsule::table('mod_hermesagent_domains')->where('service_id', $sid)->get();
        foreach ($domains as $d) {
            hermesagent_removeCaddy($host, $pass, $d->domain);
        }
        Capsule::table('mod_hermesagent_domains')->where('service_id', $sid)->delete();

        // Stop & remove container
        hermesagent_ssh($host, $pass, "docker rm -f hermes-{$sid} 2>&1");

        return 'success';
    } catch (Exception $e) {
        return $e->getMessage();
    }
}

// ─── Client Area ────────────────────────────────────────────────────────────

function hermesagent_ClientArea($params) {
    hermesagent_initDB();

    $sid      = $params['serviceid'];
    $host     = $params['serverhostname'] ?: $params['serverip'];
    $pass     = $params['serverpassword'];
    $serverIp = '46.62.205.66';

    // Ensure default domain row exists (for services provisioned before this module)
    $defaultDomain = hermesagent_defaultDomain($sid);
    $hasDefault = Capsule::table('mod_hermesagent_domains')
        ->where('service_id', $sid)->where('domain', $defaultDomain)->exists();
    if (!$hasDefault) {
        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $sid,
            'domain'     => $defaultDomain,
            'type'       => 'hermes',
            'status'     => 'active',
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);
        hermesagent_writeCaddy($host, $pass, $sid, $defaultDomain);
    }

    $domains = Capsule::table('mod_hermesagent_domains')
        ->where('service_id', $sid)
        ->orderBy('created_at')
        ->get();

    return [
        'templatefile' => 'clientarea',
        'vars' => [
            'serviceId'     => $sid,
            'domains'       => $domains,
            'defaultDomain' => $defaultDomain,
            'serverIp'      => $serverIp,
        ],
    ];
}
