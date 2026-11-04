<?php
/**
 * SNBD Host — n8n Version Update Button
 *
 * Adds a client-facing "Update n8n" control to the product details page of any
 * service provisioned by the PUQ Docker n8n module (puqDockerN8N).
 *
 * The PUQ module ships ionCube-encoded, so none of its PHP can be extended and
 * anything written into modules/servers/puqDockerN8N is destroyed on the next
 * module update. This hook therefore lives outside the module and talks to the
 * same n8n control workflow the module itself uses:
 *
 *   POST {tblservers.accesshash}  (Basic Auth: tblservers.username / password)
 *   body: {"command": "update", "domain": "...", "version": "x.y.z"}
 *
 * That "update" command does not exist in the stock puq-docker-n8n-deploy
 * workflow — see n8n-workflow-update-branch.md for the branch that must be
 * added to the control n8n instance before this hook will do anything.
 *
 * INSTALLATION: Copy this file to your WHMCS installation under:
 *               /includes/hooks/snbdhost_n8n_update_hook.php
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

/**
 * The n8n release clients are moved to. Bump this once you have validated a
 * release; every client who presses the button lands on exactly this version.
 * Must be a plain x.y.z tag that exists on docker.io/n8nio/n8n.
 */
const SNBD_N8N_TARGET_VERSION = '2.31.6';

/** Minimum gap between two updates of the same service, in seconds. */
const SNBD_N8N_UPDATE_COOLDOWN = 1800;

/** How long to wait on the workflow. A pull + recreate runs well over a minute. */
const SNBD_N8N_REQUEST_TIMEOUT = 300;

/** Server type of the provisioning module we attach to. */
const SNBD_N8N_MODULE = 'puqDockerN8N';

/**
 * Service ids allowed to see and use the button. An empty array means every
 * eligible service — that is the setting for production once this is proven.
 *
 * While testing, keep your test service id in here and nothing else. The dev
 * install runs on a copy of the production database (devproductioncopy), so
 * its service rows are real clients pointing at real containers; without this
 * allowlist a click on dev would restart a paying customer's n8n.
 */
const SNBD_N8N_ALLOWED_SERVICES = [1593]; // Testing: own service only. Set to [] to open to all clients.


/**
 * The domain is what selects the container to act on — the workflow derives
 * both the compose directory and the container name from it, and nothing else.
 * It is always read from tblhosting.domain, never from the request. This check
 * makes sure a malformed row (empty, "..", a stray path fragment) can never
 * reach a shell on the Docker host.
 */
function snbdN8nValidDomain($domain)
{
    return (bool) preg_match(
        '/^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+$/i',
        (string) $domain
    );
}

/**
 * Load the service, but only if it belongs to the logged-in client and is
 * actually a puqDockerN8N service. Returns null in every other case.
 *
 * The service id arrives from the browser, so this ownership check is the only
 * thing standing between a client and someone else's container.
 */
function snbdN8nResolveService($serviceId)
{
    $serviceId = (int) $serviceId;
    $clientId = (int) ($_SESSION['uid'] ?? 0);

    if ($serviceId <= 0 || $clientId <= 0) {
        return null;
    }

    if (SNBD_N8N_ALLOWED_SERVICES && !in_array($serviceId, SNBD_N8N_ALLOWED_SERVICES, true)) {
        return null;
    }

    $service = Capsule::table('tblhosting')
        ->join('tblproducts', 'tblproducts.id', '=', 'tblhosting.packageid')
        ->where('tblhosting.id', $serviceId)
        ->where('tblhosting.userid', $clientId)
        ->where('tblproducts.servertype', SNBD_N8N_MODULE)
        ->select(
            'tblhosting.id',
            'tblhosting.userid',
            'tblhosting.server',
            'tblhosting.domain',
            'tblhosting.domainstatus'
        )
        ->first();

    if (!$service || !snbdN8nValidDomain($service->domain)) {
        return null;
    }

    return $service;
}

/**
 * Create the audit/rate-limit table on first use.
 *
 * Doubles as the record of who updated what and when, which is the first thing
 * you will want when a client says their instance broke this morning.
 */
function snbdN8nEnsureTable()
{
    if (Capsule::schema()->hasTable('mod_snbd_n8n_updates')) {
        return;
    }

    Capsule::schema()->create('mod_snbd_n8n_updates', function ($table) {
        $table->increments('id');
        $table->integer('serviceid')->index();
        $table->integer('userid');
        $table->string('version_from', 32)->nullable();
        $table->string('version_to', 32)->nullable();
        $table->string('status', 16);
        $table->text('message')->nullable();
        $table->timestamp('created_at')->useCurrent();
    });
}

/**
 * Seconds remaining before this service may be updated again, 0 if it may go now.
 */
function snbdN8nCooldownRemaining($serviceId)
{
    snbdN8nEnsureTable();

    $last = Capsule::table('mod_snbd_n8n_updates')
        ->where('serviceid', (int) $serviceId)
        ->where('status', '!=', 'error')
        ->orderBy('id', 'desc')
        ->first();

    if (!$last) {
        return 0;
    }

    $elapsed = time() - strtotime($last->created_at);

    return $elapsed >= SNBD_N8N_UPDATE_COOLDOWN ? 0 : SNBD_N8N_UPDATE_COOLDOWN - $elapsed;
}

/**
 * Send a command to the n8n control workflow that provisions this service.
 *
 * Credentials come off the server row the service is assigned to, exactly as
 * the PUQ module reads them: accesshash is the webhook URL, username/password
 * are the webhook's Basic Auth pair.
 */
function snbdN8nCallWorkflow($service, array $body)
{
    $server = Capsule::table('tblservers')->find($service->server);

    if (!$server || empty($server->accesshash)) {
        throw new Exception('n8n API endpoint is not configured on the assigned server.');
    }

    $client = new \GuzzleHttp\Client([
        'timeout'         => SNBD_N8N_REQUEST_TIMEOUT,
        'connect_timeout' => 15,
    ]);

    $response = $client->post($server->accesshash, [
        'auth'        => [$server->username, decrypt($server->password)],
        'json'        => $body,
        'http_errors' => false,
    ]);

    $decoded = json_decode((string) $response->getBody(), true);

    if (!is_array($decoded)) {
        throw new Exception('Unexpected response from the n8n workflow.');
    }

    return $decoded;
}

/**
 * Read the version currently running inside the client's container.
 */
function snbdN8nCurrentVersion($service)
{
    try {
        $result = snbdN8nCallWorkflow($service, [
            'command' => 'version',
            'domain'  => $service->domain,
        ]);
    } catch (Exception $e) {
        return null;
    }

    return $result['version'] ?? null;
}

/**
 * Small JSON endpoints, hung off the product details URL so they inherit the
 * client area session and its login check:
 *
 *   clientarea.php?action=productdetails&id=N&snbd_n8n=status
 *   clientarea.php?action=productdetails&id=N&snbd_n8n=update  (POST + nonce)
 */
add_hook('ClientAreaPage', 1, function ($vars) {
    if (empty($_REQUEST['snbd_n8n'])) {
        return;
    }

    header('Content-Type: application/json');

    $service = snbdN8nResolveService($_REQUEST['id'] ?? 0);

    if (!$service) {
        http_response_code(403);
        echo json_encode(['status' => 'error', 'message' => 'Service not found.']);
        exit;
    }

    if ($_REQUEST['snbd_n8n'] === 'status') {
        echo json_encode([
            'status'    => 'success',
            'current'   => snbdN8nCurrentVersion($service),
            'target'    => SNBD_N8N_TARGET_VERSION,
            'cooldown'  => snbdN8nCooldownRemaining($service->id),
        ]);
        exit;
    }

    if ($_REQUEST['snbd_n8n'] !== 'update') {
        http_response_code(404);
        echo json_encode(['status' => 'error', 'message' => 'Unknown action.']);
        exit;
    }

    // --- everything below mutates the client's container ---

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['status' => 'error', 'message' => 'POST required.']);
        exit;
    }

    $nonce = $_SESSION['snbd_n8n_nonce'] ?? '';
    if (!$nonce || !hash_equals($nonce, (string) ($_POST['nonce'] ?? ''))) {
        http_response_code(403);
        echo json_encode(['status' => 'error', 'message' => 'Session expired. Reload the page and try again.']);
        exit;
    }
    unset($_SESSION['snbd_n8n_nonce']);

    if ($service->domainstatus !== 'Active') {
        http_response_code(409);
        echo json_encode(['status' => 'error', 'message' => 'This service is not active.']);
        exit;
    }

    $cooldown = snbdN8nCooldownRemaining($service->id);
    if ($cooldown > 0) {
        http_response_code(429);
        echo json_encode([
            'status'  => 'error',
            'message' => 'An update ran recently. Please wait ' . ceil($cooldown / 60) . ' more minute(s).',
        ]);
        exit;
    }

    snbdN8nEnsureTable();
    $versionFrom = snbdN8nCurrentVersion($service);

    try {
        $result = snbdN8nCallWorkflow($service, [
            'command' => 'update',
            'domain'  => $service->domain,
            'version' => SNBD_N8N_TARGET_VERSION,
        ]);
    } catch (Exception $e) {
        $result = ['status' => 'error', 'message' => $e->getMessage()];
    }

    $ok = ($result['status'] ?? 'error') === 'success';

    Capsule::table('mod_snbd_n8n_updates')->insert([
        'serviceid'    => $service->id,
        'userid'       => $service->userid,
        'version_from' => $versionFrom,
        'version_to'   => $ok ? ($result['version_to'] ?? SNBD_N8N_TARGET_VERSION) : null,
        'status'       => $ok ? 'success' : 'error',
        'message'      => $result['message'] ?? null,
        'created_at'   => date('Y-m-d H:i:s'),
    ]);

    logActivity(sprintf(
        'n8n update for service %d (%s): %s %s -> %s. %s',
        $service->id,
        $service->domain,
        $ok ? 'success' : 'FAILED',
        $versionFrom ?: 'unknown',
        SNBD_N8N_TARGET_VERSION,
        $result['message'] ?? ''
    ));

    echo json_encode($result);
    exit;
});

/**
 * Render the update panel underneath the module's own client area output.
 */
add_hook('ClientAreaProductDetailsOutput', 1, function ($vars) {
    $serviceId = 0;

    if (isset($vars['service']) && is_object($vars['service'])) {
        $serviceId = (int) $vars['service']->id;
    } elseif (isset($vars['id'])) {
        $serviceId = (int) $vars['id'];
    } elseif (isset($_REQUEST['id'])) {
        $serviceId = (int) $_REQUEST['id'];
    }

    $service = snbdN8nResolveService($serviceId);

    if (!$service || $service->domainstatus !== 'Active') {
        return '';
    }

    // Fresh nonce per render; consumed by the update endpoint.
    $nonce = bin2hex(random_bytes(16));
    $_SESSION['snbd_n8n_nonce'] = $nonce;

    $target = htmlspecialchars(SNBD_N8N_TARGET_VERSION, ENT_QUOTES, 'UTF-8');
    $base = 'clientarea.php?action=productdetails&id=' . $service->id;

    // Classes match the module's v2 client area (info-card / puq-btn-action) so
    // this reads as part of the same page rather than something bolted on.
    return <<<HTML
<div class="info-card" id="snbdN8nUpdateCard">
    <div class="info-card-title">
        <i class="fas fa-cloud-download-alt"></i> n8n version
    </div>

    <div class="info-row">
        <div class="info-label"><i class="fas fa-cogs"></i> Installed:</div>
        <div class="info-value"><b id="snbdN8nCurrent">checking…</b></div>
    </div>

    <div class="info-row">
        <div class="info-label"><i class="fas fa-arrow-up"></i> Available:</div>
        <div class="info-value"><b>{$target}</b></div>
    </div>

    <div id="snbdN8nMessage" style="display:none;margin-top:12px;"></div>

    <div style="text-align:center;padding-top:15px;">
        <button type="button" id="snbdN8nUpdateBtn" class="puq-btn-action" disabled>
            <i class="fas fa-cloud-download-alt"></i> Update n8n
        </button>
        <div style="font-size:12px;opacity:.75;margin-top:10px;">
            Your workflows, credentials and executions are kept.
            Your instance will be unavailable for roughly 2–3 minutes.
        </div>
    </div>
</div>

<script>
(function () {
    var base = '{$base}';
    var nonce = '{$nonce}';
    var btn = document.getElementById('snbdN8nUpdateBtn');
    var current = document.getElementById('snbdN8nCurrent');
    var msg = document.getElementById('snbdN8nMessage');

    function say(text, kind) {
        msg.className = 'alert alert-' + kind + ' text-center';
        msg.innerText = text;
        msg.style.display = 'block';
    }

    fetch(base + '&snbd_n8n=status')
        .then(function (r) { return r.json(); })
        .then(function (d) {
            current.innerText = d.current || 'unknown';

            if (d.current === d.target) {
                btn.innerHTML = '<i class="fas fa-check"></i> Up to date';
                return;
            }
            if (d.cooldown > 0) {
                btn.innerHTML = '<i class="fas fa-clock"></i> Try again in ' + Math.ceil(d.cooldown / 60) + ' min';
                return;
            }
            btn.disabled = false;
        })
        .catch(function () { current.innerText = 'unavailable'; });

    btn.addEventListener('click', function () {
        if (!confirm('Update n8n to {$target}? Your instance will restart and be briefly unavailable.')) {
            return;
        }

        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-sync fa-spin"></i> Updating…';
        say('Update in progress. Do not close this page.', 'info');

        var body = new FormData();
        body.append('nonce', nonce);

        fetch(base + '&snbd_n8n=update', { method: 'POST', body: body })
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (d.status === 'success') {
                    current.innerText = d.version_to || '{$target}';
                    btn.innerHTML = '<i class="fas fa-check"></i> Up to date';
                    say(d.message || 'Your n8n instance has been updated.', 'success');
                } else {
                    btn.innerHTML = '<i class="fas fa-cloud-download-alt"></i> Update n8n';
                    btn.disabled = false;
                    say(d.message || 'The update could not be completed.', 'danger');
                }
            })
            .catch(function () {
                btn.innerHTML = '<i class="fas fa-cloud-download-alt"></i> Update n8n';
                btn.disabled = false;
                say('The update timed out. Check your instance before retrying.', 'danger');
            });
    });
})();
</script>
HTML;
});
