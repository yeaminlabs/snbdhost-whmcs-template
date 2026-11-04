<?php
/**
 * Hermes Agent Hosting Provisioning Module
 *
 * @copyright Copyright (c) snbdhost 2026
 * @license MIT
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use Illuminate\Database\Capsule\Manager as Capsule;

/**
 * Define module metadata.
 */
function hermesagent_MetaData() {
    return [
        'DisplayName' => 'Hermes Agent Hosting',
        'APIVersion' => '1.1',
        'RequiresServer' => true,
        'DefaultNonSSLPort' => '22',
        'DefaultSSLPort' => '22',
        'ServiceSingleSignOnLabel' => 'Open Hermes Dashboard',
        'AdminSingleSignOnLabel' => 'Open Hermes Dashboard (Admin)',
        'ListAccountsUniqueIdentifierDisplayName' => 'Domain',
        'ListAccountsUniqueIdentifierField' => 'domain',
        'ListAccountsProductField' => 'configoption1',
    ];
}

/**
 * Define product configuration options.
 */
function hermesagent_ConfigOptions() {
    return [
        'llm_provider' => [
            'FriendlyName' => 'LLM Provider',
            'Type' => 'dropdown',
            'Options' => 'free-tier|SNBD API (NO API NEEDED)',
            'Default' => 'free-tier',
            'Description' => 'Powered by api-proxy.snbdhost.com. You can add your own provider API keys later from the Client Area.',
        ],

        'model_name' => [
            'FriendlyName' => 'Model',
            'Type' => 'text',
            'Size' => '32',
            'Default' => 'hermes-4-405b',
            'Description' => 'Model identifier to configure Hermes with.',
        ],
        'messaging_platform' => [
            'FriendlyName' => 'Messaging Platform',
            'Type' => 'dropdown',
            'Options' => 'None,Telegram,Discord,Slack',
            'Default' => 'None',
            'Description' => 'Optional: chat with Hermes from a messaging platform in addition to the dashboard.',
        ],
        'messaging_token' => [
            'FriendlyName' => 'Bot Token',
            'Type' => 'password',
            'Size' => '48',
            'Description' => 'Bot token for the selected messaging platform (leave blank if None).',
        ],
        'dashboard_username' => [
            'FriendlyName' => 'Dashboard Username',
            'Type' => 'text',
            'Size' => '25',
            'Default' => 'admin',
            'Description' => 'Login username for the Hermes web dashboard / Desktop Remote Gateway.',
        ],
        'enable_api_server' => [
            'FriendlyName' => 'Enable OpenAI-Compatible API',
            'Type' => 'yesno',
            'Description' => 'Expose /v1/chat/completions for third-party frontends (Open WebUI, etc.).',
        ],
        'resource_tier' => [
            'FriendlyName' => 'Resource Tier',
            'Type' => 'dropdown',
            'Options' => 'Starter (1 vCPU / 1GB),Standard (2 vCPU / 2GB),Pro (4 vCPU / 4GB)',
            'Default' => 'Standard (2 vCPU / 2GB)',
            'Description' => 'Container CPU/memory limits.',
        ],
        'docker_image_tag' => [
            'FriendlyName' => 'Image Version',
            'Type' => 'text',
            'Size' => '15',
            'Default' => 'latest',
            'Description' => 'nousresearch/hermes-agent tag to deploy. Leave as latest unless pinning.',
        ],
        'litellm_gateway_url' => [
            'FriendlyName' => 'LiteLLM Gateway URL',
            'Type' => 'text',
            'Size' => '48',
            'Default' => 'http://46.62.205.66:4000',
            'Description' => 'Base URL of the central LiteLLM proxy. Used when LLM Provider is "Free Tier".',
        ],
        'litellm_master_key' => [
            'FriendlyName' => 'LiteLLM Master Key',
            'Type' => 'password',
            'Size' => '48',
            'Default' => '',
            'Description' => 'LiteLLM master key for creating/deleting virtual customer keys.',
        ],
        'free_tier_model' => [
            'FriendlyName' => 'Free Tier Default Model',
            'Type' => 'text',
            'Size' => '32',
            'Default' => 'zai.glm-5',
            'Description' => 'Model name as configured in LiteLLM config.yaml (e.g. zai.glm-5).',
        ],
    ];
}

/**
 * Setup custom database table for storing service credentials and port mappings.
 */
function hermesagent_setup_database() {
    try {
        if (!Capsule::schema()->hasTable('mod_hermesagent_onboarding')) {
            Capsule::schema()->create('mod_hermesagent_onboarding', function ($table) {
                $table->integer('serviceid')->unique();
                $table->string('agent_name', 60)->nullable();
                $table->string('use_case', 30)->nullable();
                $table->string('tone', 30)->nullable();
                $table->text('custom_instructions')->nullable();
                $table->string('status', 20)->default('pending');
                $table->timestamp('created_at')->nullable();
                $table->timestamp('completed_at')->nullable();
            });
        }
        
        if (!Capsule::schema()->hasTable('mod_hermesagent_instances')) {
            Capsule::schema()->create(
                'mod_hermesagent_instances',
                function ($table) {
                    $table->integer('serviceid')->unique();
                    $table->integer('dash_port');
                    $table->integer('api_port');
                    $table->integer('host_port')->default(0);
                    $table->string('dashboard_username');
                    $table->string('dashboard_password');
                    $table->string('dashboard_secret');
                    $table->string('api_key');
                    $table->string('status')->default('Pending');
                    $table->string('litellm_key_id', 64)->nullable();
                    $table->string('litellm_key_value', 128)->nullable();
                    $table->timestamps();
                }
            );
        } else {
            // Migration: add LiteLLM columns if missing
            if (!Capsule::schema()->hasColumn('mod_hermesagent_instances', 'litellm_key_id')) {
                Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                    $table->string('litellm_key_id', 64)->nullable();
                });
            }
            if (!Capsule::schema()->hasColumn('mod_hermesagent_instances', 'litellm_key_value')) {
                Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                    $table->string('litellm_key_value', 128)->nullable();
                });
            }
            if (!Capsule::schema()->hasColumn('mod_hermesagent_instances', 'host_port')) {
                Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                    $table->integer('host_port')->default(0);
                });
            }
            if (!Capsule::schema()->hasColumn('mod_hermesagent_instances', 'current_model')) {
                // Model the instance is currently pinned to. CreateAccount writes this on
                // every deploy, so the column has to exist even when the admin addon (which
                // also declares it) has never been opened on this install.
                Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                    $table->string('current_model', 100)->nullable();
                });
            }
            if (!Capsule::schema()->hasColumn('mod_hermesagent_instances', 'custom_env')) {
                // JSON map of env vars the customer set via self-service "Manage LLM
                // Providers" (Telegram/Discord/Slack tokens, custom API keys). CreateAccount
                // re-applies these on every redeploy so they never get silently wiped when
                // .env is rebuilt from WHMCS configurable options.
                Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                    $table->text('custom_env')->nullable();
                });
            }
        }
    } catch (\Exception $e) {
        logActivity("HermesAgent database setup failed: " . $e->getMessage());
    }
}

/**
 * Allocate dashboard, API, and hosting ports deterministically with collision detection.
 */
function hermesagent_allocate_ports($serviceid) {
    $dashBase = 9119;
    $apiBase  = 8642;
    $hostBase = 7300; // port for Hermes-hosted projects (mapped to container :3000)

    $dashPort = $dashBase + ($serviceid % 1000);
    $apiPort  = $apiBase  + ($serviceid % 1000);
    $hostPort = $hostBase + ($serviceid % 1000);

    $attempts = 0;
    while ($attempts < 500) {
        $exists = Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', '!=', $serviceid)
            ->where(function($query) use ($dashPort, $apiPort, $hostPort) {
                $query->where('dash_port', $dashPort)
                      ->orWhere('api_port', $apiPort)
                      ->orWhere('dash_port', $apiPort)
                      ->orWhere('api_port', $dashPort)
                      ->orWhere('host_port', $hostPort)
                      ->orWhere('dash_port', $hostPort)
                      ->orWhere('api_port',  $hostPort);
            })->exists();

        if (!$exists) {
            return [$dashPort, $apiPort, $hostPort];
        }

        $dashPort++;
        $apiPort++;
        $hostPort++;
        $attempts++;
    }

    return [rand(10000, 20000), rand(20001, 30000), rand(7000, 7999)];
}

/**
 * Helper to generate a secure random password.
 */
function hermesagent_generate_random_password($length = 16) {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    $password = '';
    $max = strlen($chars) - 1;
    for ($i = 0; $i < $length; $i++) {
        $password .= $chars[random_int(0, $max)];
    }
    return $password;
}

// ═══════════════════════════════════════════════════════════════
//  LiteLLM Gateway Helpers
//  Creates/manages virtual API keys on the central LiteLLM proxy
//  so AWS Bedrock credentials NEVER enter customer containers.
// ═══════════════════════════════════════════════════════════════

/**
 * Get LiteLLM gateway URL and master key.
 *
 * Prefers the actively-managed Brain (mod_hermesagent_brain_config, edited from
 * the admin Brain Management panel) since that's the single source of truth
 * CreateAccount itself uses to provision customer keys. Product Module Setting
 * config options (configoption11-13) are only a fallback for installs that
 * never set up Brain Management — without this, the two sources can silently
 * disagree (e.g. an empty product field) and break usage tracking even though
 * provisioning, which only reads the Brain, works fine.
 */
function hermesagent_litellm_config($params) {
    if (function_exists('hermesagent_get_active_brain')) {
        $brain = hermesagent_get_active_brain();
        if (!empty($brain['base_url']) && !empty($brain['api_key'])) {
            return [
                'url'   => rtrim(preg_replace('|/v1/?$|', '', rtrim($brain['base_url'], '/')), '/'),
                'key'   => $brain['api_key'],
                'model' => $brain['model_name'] ?? 'zai.glm-5',
            ];
        }
    }

    $url = hermesagent_resolve_param($params, 'configoption9', 'LiteLLM Gateway URL', 'https://ai-proxy.snbdhost.com');
    $key = hermesagent_resolve_param($params, 'configoption10', 'LiteLLM Master Key', 'sk-snbdhost-master-key-2026');
    $model = hermesagent_resolve_param($params, 'configoption11', 'Free Tier Default Model', 'zai.glm-5');
    
    return [
        'url'   => rtrim($url, '/'),
        'key'   => $key,
        'model' => $model,
    ];
}

/**
 * Create a LiteLLM virtual API key for a customer.
 * Returns ['key_id' => ..., 'key_value' => ...] or throws.
 */
function hermesagent_litellm_create_key($gatewayUrl, $masterKey, $serviceId, $model, $maxBudget = 1.0) {
    $payload = json_encode([
        'key_alias'     => 'hermes-' . $serviceId,
        'user_id'       => 'hermes-' . $serviceId,
        'models'        => [$model],
        'max_budget'    => $maxBudget,
        'metadata'      => [
            'service_id' => (string)$serviceId,
            'created_by' => 'whmcs-hermesagent',
        ],
        'max_parallel_requests' => 10,
        'tpm_limit'     => 100000,
        'rpm_limit'     => 60,
        'duration'      => null,
    ]);

    $ch = curl_init($gatewayUrl . '/key/generate');
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $payload,
        CURLOPT_HTTPHEADER     => [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $masterKey,
        ],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 10,
        CURLOPT_CONNECTTIMEOUT => 3,
        CURLOPT_IPRESOLVE      => CURL_IPRESOLVE_V4,
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);

    if ($error) {
        throw new \Exception("LiteLLM connection failed: $error");
    }
    if ($httpCode !== 200) {
        throw new \Exception("LiteLLM /key/generate returned HTTP $httpCode: " . substr($response, 0, 500));
    }

    $data = json_decode($response, true);
    if (!$data || empty($data['key'])) {
        throw new \Exception("LiteLLM /key/generate returned unexpected response: " . substr($response, 0, 500));
    }

    // LiteLLM v1.93+ returns 'token' or 'token_id' instead of 'key_id'
    $keyId = $data['key_id'] ?? $data['token_id'] ?? $data['token'] ?? '';

    return [
        'key_id'    => $keyId,
        'key_value' => $data['key'],
    ];
}

/**
 * Update a LiteLLM virtual key (suspend/unsuspend/change limits).
 */
function hermesagent_litellm_update_key($gatewayUrl, $masterKey, $keyId, $isActive) {
    $payload = json_encode(['key_id' => $keyId, 'is_active' => $isActive]);

    $ch = curl_init($gatewayUrl . '/key/update');
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $payload,
        CURLOPT_HTTPHEADER     => [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $masterKey,
        ],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 10,
        CURLOPT_CONNECTTIMEOUT => 5,
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode !== 200) {
        logModuleCall('hermesagent', 'litellm_update_key', $keyId, "HTTP $httpCode: " . substr($response, 0, 500));
    }
}

/**
 * Delete a LiteLLM virtual key.
 */
function hermesagent_litellm_delete_key($gatewayUrl, $masterKey, $keyId) {
    $payload = json_encode(['keys' => [$keyId]]);

    $ch = curl_init($gatewayUrl . '/key/delete');
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $payload,
        CURLOPT_HTTPHEADER     => [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $masterKey,
        ],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 10,
        CURLOPT_CONNECTTIMEOUT => 5,
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode !== 200) {
        logModuleCall('hermesagent', 'litellm_delete_key', $keyId, "HTTP $httpCode: " . substr($response, 0, 500));
    }
}

/**
 * Fetch token usage and spend for a LiteLLM virtual key.
 * Returns ['total_tokens' => int, 'spend' => float, 'model' => string] or null on failure.
 */
function hermesagent_litellm_get_usage($gatewayUrl, $masterKey, $keyValue) {
    $ch = curl_init($gatewayUrl . '/key/info?key=' . urlencode($keyValue));
    curl_setopt_array($ch, [
        CURLOPT_HTTPHEADER     => [
            'Authorization: Bearer ' . $masterKey,
        ],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 8,
        CURLOPT_CONNECTTIMEOUT => 3,
        CURLOPT_IPRESOLVE      => CURL_IPRESOLVE_V4,
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $promptTokens = 0;
    $completionTokens = 0;
    $totalTokens = 0;
    $spend = 0.0;
    $model = '';

    if ($httpCode === 200 && !empty($response)) {
        $data = json_decode($response, true);
        if ($data && isset($data['info'])) {
            $info = $data['info'];
            $totalTokens      = (int) ($info['total_tokens'] ?? 0);
            $promptTokens     = (int) ($info['prompt_tokens'] ?? 0);
            $completionTokens = (int) ($info['completion_tokens'] ?? 0);
            $spend            = (float) ($info['spend'] ?? 0);
            $model            = $info['models'][0] ?? '';
        }
    }

    // /key/info does not reliably return per-key token counts on all LiteLLM
    // versions (it's primarily budget/spend metadata) — fall back to summing
    // /spend/logs for this key, which always carries prompt/completion tokens
    // per request.
    if ($totalTokens === 0 && $promptTokens === 0 && $completionTokens === 0) {
        $ch2 = curl_init($gatewayUrl . '/spend/logs?api_key=' . urlencode($keyValue));
        curl_setopt_array($ch2, [
            CURLOPT_HTTPHEADER     => [
                'Authorization: Bearer ' . $masterKey,
            ],
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 8,
            CURLOPT_CONNECTTIMEOUT => 3,
            CURLOPT_IPRESOLVE      => CURL_IPRESOLVE_V4,
        ]);
        $logsResponse = curl_exec($ch2);
        $logsHttpCode = curl_getinfo($ch2, CURLINFO_HTTP_CODE);
        curl_close($ch2);

        if ($logsHttpCode === 200 && !empty($logsResponse)) {
            $logs = json_decode($logsResponse, true);
            if (is_array($logs)) {
                foreach ($logs as $entry) {
                    $promptTokens     += (int) ($entry['prompt_tokens'] ?? 0);
                    $completionTokens += (int) ($entry['completion_tokens'] ?? 0);
                    $spend            += (float) ($entry['spend'] ?? 0);
                    if (empty($model)) $model = $entry['model'] ?? '';
                }
                $totalTokens = $promptTokens + $completionTokens;
            }
        }
    }

    if ($totalTokens === 0 && $promptTokens === 0 && $completionTokens === 0 && $httpCode !== 200) {
        return null;
    }

    return [
        'total_tokens'      => (int) $totalTokens,
        'prompt_tokens'     => (int) $promptTokens,
        'completion_tokens' => (int) $completionTokens,
        'spend'             => (float) $spend,
        'model'             => $model,
    ];
}

/**
 * Resolves configuration parameters with case-insensitive checks against customer-defined
 * Configurable Options and Custom Fields in WHMCS. Falls back to admin default settings.
 */
function hermesagent_resolve_param($params, $configKey, $name, $defaultVal = '') {
    $sanitize = function($str) {
        return strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $str));
    };

    // Configurable-option sub-options are stored as the literal string the admin
    // typed, so a "value|Display Label" entry arrives whole (e.g.
    // "free-tier|SNBD API (NO API NEEDED)"). Keep only the value half. Secrets and
    // URLs are exempt — a token or password may legitimately contain a pipe.
    $literalFields = ['bottoken', 'litellmmasterkey', 'litellmgatewayurl'];
    $normalize = function($val) use ($name, $sanitize, $literalFields) {
        if (!is_string($val) || strpos($val, '|') === false) {
            return $val;
        }
        if (in_array($sanitize($name), $literalFields, true)) {
            return $val;
        }
        return substr($val, 0, strpos($val, '|'));
    };

    $search = $sanitize($name);
    
    // A matching key whose value is blank must not win: WHMCS hands us every
    // configurable option and custom field defined on the product, filled in or
    // not, so returning '' here would shadow both the admin-set module setting
    // and $defaultVal. Same reasoning as the !empty() check in step 3.
    $blank = function($val) {
        return $val === null || $val === '' || (is_string($val) && trim($val) === '');
    };

    // 1. Search in Customer Configurable Options
    if (!empty($params['configoptions'])) {
        foreach ($params['configoptions'] as $key => $val) {
            if ($sanitize($key) === $search && !$blank($val)) {
                return $normalize($val);
            }
        }
    }
    
    // 2. Search in Customer Custom Fields
    if (!empty($params['customfields'])) {
        foreach ($params['customfields'] as $key => $val) {
            if ($sanitize($key) === $search && !$blank($val)) {
                return $normalize($val);
            }
        }
    }
    
    // 3. Fallback to Admin Module Config Options — WHMCS always populates
    // configoptionN slots even when the admin left the field blank, so an
    // isset() check here would return '' instead of falling through to a
    // sane default. Use empty() so a blank product Module Setting behaves
    // the same as an unset one.
    if (!empty($params[$configKey])) {
        return $normalize($params[$configKey]);
    }

    return $defaultVal;
}

/**
 * Establish SSH connection using phpseclib compatibility layer.
 */
function hermesagent_get_ssh_client($params, $timeout = 30) {
    $host = $params['serverip'];
    $port = empty($params['serverport']) ? 22 : intval($params['serverport']);
    $username = $params['serverusername'];
    $password = $params['serverpassword'];
    $accesshash = trim($params['serveraccesshash']);

    if (empty($host) || empty($username)) {
        throw new \Exception("Server IP/Username not configured in WHMCS Server settings");
    }

    // Try phpseclib 3
    if (class_exists('\phpseclib3\Net\SSH2')) {
        $ssh = new \phpseclib3\Net\SSH2($host, $port);
        $ssh->setTimeout($timeout);
        if (!empty($accesshash)) {
            try {
                $key = \phpseclib3\Crypt\PublicKeyLoader::load($accesshash, $password ?: false);
                if ($ssh->login($username, $key)) {
                    return $ssh;
                }
            } catch (\Exception $e) {
                // fall back to password
            }
        }
        if ($ssh->login($username, $password)) {
            return $ssh;
        }
        throw new \Exception("SSH connection failed (phpseclib3)");
    } 
    // Try phpseclib 2
    elseif (class_exists('\phpseclib\Net\SSH2')) {
        $ssh = new \phpseclib\Net\SSH2($host, $port);
        $ssh->setTimeout($timeout);
        if (!empty($accesshash) && class_exists('\phpseclib\Crypt\RSA')) {
            $key = new \phpseclib\Crypt\RSA();
            if (!empty($password)) {
                $key->setPassword($password);
            }
            if ($key->loadKey($accesshash)) {
                if ($ssh->login($username, $key)) {
                    return $ssh;
                }
            }
        }
        if ($ssh->login($username, $password)) {
            return $ssh;
        }
        throw new \Exception("SSH connection failed (phpseclib2)");
    }
    // Try legacy phpseclib 1
    elseif (class_exists('Net_SSH2')) {
        $ssh = new \Net_SSH2($host, $port);
        $ssh->setTimeout($timeout);
        if (!empty($accesshash) && class_exists('Crypt_RSA')) {
            $key = new \Crypt_RSA();
            if (!empty($password)) {
                $key->setPassword($password);
            }
            if ($key->loadKey($accesshash)) {
                if ($ssh->login($username, $key)) {
                    return $ssh;
                }
            }
        }
        if ($ssh->login($username, $password)) {
            return $ssh;
        }
        throw new \Exception("SSH connection failed (legacy Net_SSH2)");
    }

    throw new \Exception("phpseclib classes not found. Please ensure phpseclib is available.");
}

/**
 * Get the currently active brain (AI endpoint) from the brain_config table.
 * Falls back to hardcoded SNBD proxy defaults if the table doesn't exist yet.
 */
if (!function_exists('hermesagent_get_active_brain')) {
    function hermesagent_get_active_brain() {
        $defaults = [
            'id'            => 0,
            'display_name'  => 'SNBD Proxy (ZAI GLM-5)',
            'provider_type' => 'proxy',
            'base_url'      => 'https://ai-proxy.snbdhost.com/v1',
            'model_name'    => 'zai.glm-5',
            'api_key'       => 'sk-snbdhost-master-key-2026',
            'is_active'     => 1,
        ];
        try {
            $row = Capsule::table('mod_hermesagent_brain_config')->where('is_active', 1)->first();
            return $row ? (array) $row : $defaults;
        } catch (\Exception $e) {
            return $defaults;
        }
    }
}

/**
 * Core Account Provisioning
 */
function hermesagent_CreateAccount($params) {
    hermesagent_setup_database();
    
    $serviceid = intval($params['serviceid']);
    
    // -- Onboarding Gate --
    $onb = Capsule::table('mod_hermesagent_onboarding')->where('serviceid', $serviceid)->first();
    if (!$onb) {
        Capsule::table('mod_hermesagent_onboarding')->insert([
            'serviceid' => $serviceid, 'status' => 'pending', 'created_at' => date('Y-m-d H:i:s')
        ]);
        logModuleCall('hermesagent', 'CreateAccount_Deferred', $serviceid, 'Provisioning deferred — awaiting customer onboarding');
        return 'success'; // WHMCS marks service Active; container not yet created
    }
    if ($onb->status === 'pending') {
        return 'success'; // still waiting; idempotent re-entry guard
    }
    // -- End Gate --

    // Resolve values with customer custom inputs and configurable option overrides
    $llmProvider = 'free-tier'; // SNBD API is the only provider — always use proxy
    $providerApiKey = '';
    $customEndpointUrl = '';
    $modelName = hermesagent_resolve_param($params, 'configoption2', 'Model', 'zai.glm-5');
    $messagingPlatform = hermesagent_resolve_param($params, 'configoption3', 'Messaging Platform', 'None');
    $messagingToken = hermesagent_resolve_param($params, 'configoption4', 'Bot Token', '');
    $dashboardUsername = hermesagent_resolve_param($params, 'configoption5', 'Dashboard Username', 'admin');
    $enableApiServer = hermesagent_resolve_param($params, 'configoption6', 'Enable OpenAI-Compatible API', 'no');
    $resourceTier = hermesagent_resolve_param($params, 'configoption7', 'Resource Tier', 'Starter (1 vCPU / 1GB)');
    $dockerImageTag = hermesagent_resolve_param($params, 'configoption8', 'Image Version', 'latest');
    // Pull active brain config — admin-controlled from the Brain Management panel
    $brain         = hermesagent_get_active_brain();
    $brainBaseUrl  = rtrim($brain['base_url'], '/');   // e.g. https://ai-proxy.snbdhost.com/v1
    $brainApiKey   = $brain['api_key'] ?? 'sk-snbdhost-master-key-2026';
    $brainModel    = $brain['model_name'] ?? 'zai.glm-5';
    // LiteLLM management API URL (without /v1 suffix)
    $litellmApiUrl = rtrim(preg_replace('|/v1/?$|', '', $brainBaseUrl), '/');
    $litellmCfg = [
        'url'   => $litellmApiUrl,
        'key'   => $brainApiKey,
        'model' => $brainModel,
    ];
    $litellmModel = $brainModel;
    
    // Check if record exists
    $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
    if ($record) {
        $dashPort = $record->dash_port;
        $apiPort = $record->api_port;
        $hostPort = $record->host_port ?: (7300 + ($serviceid % 1000));
        $dashboardPassword = $record->dashboard_password;
        $dashboardSecret = $record->dashboard_secret ?: bin2hex(random_bytes(16));
        $apiKey = $record->api_key;
    } else {
        list($dashPort, $apiPort, $hostPort) = hermesagent_allocate_ports($serviceid);
        $dashboardPassword = hermesagent_generate_random_password(16);
        $dashboardSecret = bin2hex(random_bytes(16));
        $apiKey = bin2hex(random_bytes(16));

        $insertData = [
            'serviceid' => $serviceid,
            'dash_port' => $dashPort,
            'api_port'  => $apiPort,
            'host_port' => $hostPort,
            'dashboard_username' => $dashboardUsername,
            'dashboard_password' => $dashboardPassword,
            'dashboard_secret' => $dashboardSecret,
            'api_key' => $apiKey,
            'status' => 'Pending',
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
        ];
        
        // If Free Tier, create LiteLLM virtual key now and store it
        $isFreeTier = ($llmProvider === 'free-tier' || $llmProvider === 'bedrock');
        if ($isFreeTier && !empty($litellmCfg['key'])) {
            try {
                $ltKey = hermesagent_litellm_create_key($litellmCfg['url'], $litellmCfg['key'], $serviceid, $litellmModel);
                $insertData['litellm_key_id'] = $ltKey['key_id'];
                $insertData['litellm_key_value'] = $ltKey['key_value'];
                logModuleCall('hermesagent', 'CreateAccount_LiteLLM_Key', $serviceid, "LiteLLM key created: {$ltKey['key_id']}");
            } catch (\Exception $e) {
                logModuleCall('hermesagent', 'CreateAccount_LiteLLM_Key_Failed', $serviceid, $e->getMessage());
                // Non-fatal: provisioning continues; admin can investigate
            }
        }
        
        Capsule::table('mod_hermesagent_instances')->insert($insertData);
    }
    
    // Existing records: only generate a LiteLLM key if this instance genuinely
    // doesn't have one yet (e.g. first key-gen attempt failed and this redeploy
    // is retrying it). NEVER rotate an existing key on redeploy — the customer's
    // token usage, budget, and rate limits are tracked against that exact key
    // value, and regenerating it on every Force Redeploy / ChangePackage
    // orphans all historical usage and resets tracking to zero silently.
    $isFreeTier = ($llmProvider === 'free-tier' || $llmProvider === 'bedrock');
    if ($isFreeTier && $record && empty($record->litellm_key_id) && !empty($litellmCfg['key'])) {
        try {
            $ltKey = hermesagent_litellm_create_key($litellmCfg['url'], $litellmCfg['key'], $serviceid, $litellmModel);
            Capsule::table('mod_hermesagent_instances')
                ->where('serviceid', $serviceid)
                ->update([
                    'litellm_key_id' => $ltKey['key_id'],
                    'litellm_key_value' => $ltKey['key_value'],
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            $record->litellm_key_id = $ltKey['key_id'];
            $record->litellm_key_value = $ltKey['key_value'];
            logModuleCall('hermesagent', 'Redeploy_LiteLLM_Key', $serviceid, "LiteLLM key created for existing record (had none): {$ltKey['key_id']}");
        } catch (\Exception $e) {
            logModuleCall('hermesagent', 'Redeploy_LiteLLM_Key_Failed', $serviceid, $e->getMessage());
        }
    }
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        // Define resource tier limits
        $cpus = '2.0';
        $memory = '2g';
        if (stripos($resourceTier, 'Starter') !== false) {
            $cpus = '1.0';
            $memory = '1g';
        } elseif (stripos($resourceTier, 'Pro') !== false) {
            $cpus = '4.0';
            $memory = '4g';
        }
        
        // Generate Env
        $envLines = [
            "# Generated by WHMCS hermesagent module",
            "HERMES_DASHBOARD=1",
            "HERMES_DASHBOARD_HOST=0.0.0.0",
            "HERMES_DASHBOARD_PORT=9119",
            "HERMES_DASHBOARD_BASIC_AUTH_USERNAME=" . $dashboardUsername,
            "HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=" . $dashboardPassword,
            "HERMES_DASHBOARD_BASIC_AUTH_SECRET=" . $dashboardSecret,
        ];
        
        $isFreeTier = ($llmProvider === 'free-tier' || $llmProvider === 'bedrock');
        
        if ($isFreeTier) {
            // LiteLLM Gateway path: no raw API keys in container
            // Customer agent points to central LiteLLM proxy
            $litellmKey = $record->litellm_key_value ?? $insertData['litellm_key_value'] ?? '';
            
            // If no key stored yet, generate one now (handles edge cases where earlier key gen failed)
            if (empty($litellmKey) && !empty($litellmCfg['key']) && !empty($litellmCfg['url'])) {
                try {
                    $ltKey = hermesagent_litellm_create_key($litellmCfg['url'], $litellmCfg['key'], $serviceid, $litellmModel);
                    $litellmKey = $ltKey['key_value'];
                    // Save it back to DB so next deploy uses it
                    Capsule::table('mod_hermesagent_instances')
                        ->where('serviceid', $serviceid)
                        ->update([
                            'litellm_key_id'    => $ltKey['key_id'],
                            'litellm_key_value' => $ltKey['key_value'],
                            'updated_at'        => date('Y-m-d H:i:s'),
                        ]);
                    logModuleCall('hermesagent', 'CreateAccount_LiteLLM_Key_Fallback', $serviceid, "LiteLLM key created at env-write time: {$ltKey['key_id']}");
                } catch (\Exception $e) {
                    logModuleCall('hermesagent', 'CreateAccount_LiteLLM_Key_Fallback_Failed', $serviceid, $e->getMessage());
                }
            }

            if (!empty($litellmKey) && !empty($litellmCfg['url'])) {
                $envLines[] = "OPENAI_API_BASE=" . $brainBaseUrl;
                $envLines[] = "OPENAI_BASE_URL=" . $brainBaseUrl;
                $envLines[] = "OPENAI_API_KEY=" . $litellmKey;
            } else {
                // Last resort fallback — master key so agent at least boots
                $envLines[] = "OPENAI_API_BASE=" . $brainBaseUrl;
                $envLines[] = "OPENAI_BASE_URL=" . $brainBaseUrl;
                $envLines[] = "OPENAI_API_KEY=" . $brainApiKey;
                logModuleCall('hermesagent', 'CreateAccount_LiteLLM_Fallback_MasterKey', $serviceid, "Used master key as fallback for service $serviceid");
            }
        } elseif ($llmProvider === 'openrouter') {
            $envLines[] = "OPENROUTER_API_KEY=" . $providerApiKey;
        } elseif ($llmProvider === 'openai') {
            $envLines[] = "OPENAI_API_KEY=" . $providerApiKey;
        } elseif ($llmProvider === 'anthropic') {
            $envLines[] = "ANTHROPIC_API_KEY=" . $providerApiKey;
        } elseif ($llmProvider === 'custom') {
            $envLines[] = "OPENAI_API_KEY=" . $providerApiKey;
            $envLines[] = "OPENAI_API_BASE=" . $customEndpointUrl;
        } elseif ($llmProvider === 'nous_portal' && !empty($providerApiKey)) {
            $envLines[] = "NOUS_PORTAL_API_KEY=" . $providerApiKey;
        }
        
        $apiEnabledVal = (strtolower($enableApiServer) === 'yes' || $enableApiServer === '1' || $enableApiServer === true || $enableApiServer === 'on');
        if ($apiEnabledVal) {
            $envLines[] = "API_SERVER_ENABLED=true";
            $envLines[] = "API_SERVER_HOST=0.0.0.0";
            $envLines[] = "API_SERVER_PORT=8642";
            $envLines[] = "API_SERVER_KEY=" . $apiKey;
            $envLines[] = "API_SERVER_CORS_ORIGINS=*";
        } else {
            $envLines[] = "API_SERVER_ENABLED=false";
        }
        
        if ($messagingPlatform !== 'None' && !empty($messagingToken)) {
            if ($messagingPlatform === 'Telegram') {
                $envLines[] = "TELEGRAM_BOT_TOKEN=" . $messagingToken;
            } elseif ($messagingPlatform === 'Discord') {
                $envLines[] = "DISCORD_BOT_TOKEN=" . $messagingToken;
            } elseif ($messagingPlatform === 'Slack') {
                $envLines[] = "SLACK_BOT_TOKEN=" . $messagingToken;
            }
        }

        // Re-apply any self-service overrides (Telegram/Discord/Slack tokens, custom
        // API keys) saved by the "Manage LLM Providers" client-area page. Without this,
        // every redeploy rebuilds .env purely from WHMCS configurable options and
        // silently wipes anything the customer configured after checkout.
        if ($record && !empty($record->custom_env)) {
            $customEnvOverrides = json_decode($record->custom_env, true);
            if (is_array($customEnvOverrides)) {
                foreach ($customEnvOverrides as $ceKey => $ceVal) {
                    $ceKey = preg_replace('/[^A-Z0-9_]/', '', strtoupper($ceKey));
                    if ($ceKey === '') continue;
                    // Drop any line already set for this key so the override wins outright
                    $envLines = array_values(array_filter($envLines, function ($line) use ($ceKey) {
                        return strpos($line, $ceKey . '=') !== 0;
                    }));
                    $envLines[] = "{$ceKey}=" . $ceVal;
                }
            }
        }

        $envContent = implode("\n", $envLines) . "\n";
        
        // Hosting subdomain for self-hosted projects
        $hostname = "hermes.deltadns.xyz";
        $hostingUrl = "https://{$serviceid}.{$hostname}";

        // System prompt: replace mode so our rules come first.
        // A persistent HTTP server is pre-started on port 3000 serving /opt/data/.
        // Caddy on the host routes /artifacts/* on the dashboard domain to that server.
        $artifactsUrl = "https://{$serviceid}.{$hostname}/artifacts";
        
        // Build Persona Preamble based on Onboarding
        $personaPreamble = "";
        $agentName = "Hermes"; // default
        if (isset($onb) && $onb && $onb->status === 'completed') {
            $agentName = $onb->agent_name ?: "Hermes";
            $personaPreamble .= "Your name is {$agentName}.\n\n";
            
            if ($onb->use_case === 'coding') {
                $personaPreamble .= "You are an expert coding assistant. Your goal is to write clean, maintainable, and bug-free code. Focus on best practices, performance, and architecture.\n";
            } elseif ($onb->use_case === 'support') {
                $personaPreamble .= "You are a dedicated customer support agent. Your goal is to help users resolve issues patiently, clearly, and effectively.\n";
            } elseif ($onb->use_case === 'content') {
                $personaPreamble .= "You are a creative content creator. Your goal is to produce engaging, high-quality content tailored to the audience.\n";
            } elseif ($onb->use_case === 'automation') {
                $personaPreamble .= "You are an automation and Ops specialist. Focus on streamlining workflows, writing scripts, and managing infrastructure efficiently.\n";
            } else {
                $personaPreamble .= "You are a versatile, general-purpose AI assistant. Your goal is to be universally helpful across a variety of tasks.\n";
            }
            
            if ($onb->tone) {
                $personaPreamble .= "Your tone should be {$onb->tone}.\n";
            }
            
            if (!empty($onb->custom_instructions)) {
                $personaPreamble .= "\nOwner's instructions:\n" . $onb->custom_instructions . "\n";
            }
            $personaPreamble .= "\n---\n\n";
        }

        $systemPrompt = $personaPreamble . "# YOUR ENVIRONMENT\n"
            . "You are Hermes, an AI agent running on a REAL dedicated server — not a sandbox. "
            . "You have your own isolated space with persistent storage and a live public URL.\n\n"
            . "# HOSTING FILES PUBLICLY\n"
            . "A web server is ALREADY running and your files are publicly accessible at:\n"
            . "  {$artifactsUrl}/filename\n\n"
            . "To publish any file:\n"
            . "1. Write it to /opt/data/artifacts/ using write_file (e.g. /opt/data/artifacts/index.html)\n"
            . "2. Tell the user the live URL: {$artifactsUrl}/index.html\n\n"
            . "You can confirm it is live: terminal(command=\"curl -s http://localhost:3000/artifacts/ | head -5\")\n\n"
            . "# HANDLING ZIP / ARCHIVE / BINARY FILES\n"
            . "The 'unzip' binary is NOT installed and you cannot apt/apk install anything. "
            . "NEVER attempt to install packages. Instead extract archives with Python, which is always available:\n"
            . "  terminal(command=\"python3 -m zipfile -e /opt/data/upload.zip /opt/data/artifacts/\")\n"
            . "For tar archives: terminal(command=\"python3 -c \\\"import tarfile; tarfile.open('/opt/data/upload.tar.gz').extractall('/opt/data/artifacts/')\\\"\")\n"
            . "- NEVER read_file, cat, or print the raw contents of a .zip/.tar/.gz/image/binary file — this dumps "
            . "garbled binary data into your own context, burning huge amounts of tokens on every subsequent turn "
            . "of the conversation. Only ever list archive contents with 'python3 -m zipfile -l file.zip' if you "
            . "need to inspect them, never print the raw bytes.\n"
            . "- If a task isn't working after 2-3 different approaches, STOP and tell the user what's blocking you "
            . "instead of continuing to retry — repeated retries with growing tool output compound token usage fast.\n\n"
            . "# STRICT RULES\n"
            . "- NEVER say you cannot host — you CAN, the URL above is publicly accessible right now\n"
            . "- NEVER start any web server — one is already running on port 3000\n"
            . "- NEVER use any port other than 3000\n"
            . "- NEVER use docker commands — no socket available\n"
            . "- NEVER suggest ngrok, SSH port forwarding, localhost servers, VSCode Live Server, or asking the "
            . "user to run anything on their own machine — you already have a real public URL, use it\n"
            . "- NEVER say a system dependency is missing and stop — work around it with Python (zipfile, tarfile, "
            . "http.server modules are all built in and require no install)\n"
            . "- ALWAYS write hosted files to /opt/data/artifacts/\n\n"
            . "# YOUR TOOLS\n"
            . "terminal (run shell commands), write_file, read_file, search_files, and more. "
            . "Working directory: /opt/data. Python3, node, curl, wget are available.\n\n"
            . "# YOUR ROLE\n"
            . "Complete tasks fully. When asked to host something, write the file to /opt/data/artifacts/ "
            . "and immediately give the user the public URL.";

        // Generate config.yaml
        if ($isFreeTier) {
            // For the SNBD proxy tier, use a proper model dict so Hermes routes
            // through our custom OpenAI-compatible proxy (provider: custom).
            // The api_key must be in model.api_key so Hermes reads it as
            // cfg_api_key in _resolve_openrouter_runtime — OPENAI_API_KEY env var
            // is only read for openai.com endpoints, causing "no-key-required" otherwise.
            $proxyBaseUrl = rtrim($litellmCfg['url'] ?? 'https://ai-proxy.snbdhost.com', '/') . '/v1';
            $proxyApiKey = !empty($litellmKey) ? $litellmKey : ($litellmCfg['key'] ?? 'sk-snbdhost-master-key-2026');
            $yamlContent = <<<YAML
model:
  default: "{$litellmModel}"
  provider: custom
  base_url: "{$proxyBaseUrl}"
  api_key: "{$proxyApiKey}"
dashboard:
  show_token_analytics: true
tool_loop_guardrails:
  warnings_enabled: true
  hard_stop_enabled: true
  hard_stop_after:
    exact_failure: 5
    idempotent_no_progress: 5
terminal:
  backend: local
YAML;
        } elseif ($llmProvider === 'custom') {
            $yamlContent = <<<YAML
model: "{$modelName}"
model_list:
  - model_name: "{$modelName}"
    litellm_params:
      model: "bedrock/{$modelName}"
dashboard:
  show_token_analytics: true
tool_loop_guardrails:
  warnings_enabled: true
  hard_stop_enabled: true
  hard_stop_after:
    exact_failure: 5
    idempotent_no_progress: 5
terminal:
  backend: local
YAML;
        } else {
            $yamlContent = <<<YAML
model: "{$llmProvider}/{$modelName}"
dashboard:
  show_token_analytics: true
tool_loop_guardrails:
  warnings_enabled: true
  hard_stop_enabled: true
  hard_stop_after:
    exact_failure: 5
    idempotent_no_progress: 5
terminal:
  backend: local
YAML;
        }

        // Build installation commands
        $dataDir = "/srv/hermes/{$serviceid}/data";
        $setupCmds = "mkdir -p \"{$dataDir}\"\n";
        
        // Write .env
        $setupCmds .= "cat << 'EOF' > \"{$dataDir}/.env\"\n{$envContent}EOF\n";
        $setupCmds .= "chmod 600 \"{$dataDir}/.env\"\n";
        
        // Write config.yaml
        $setupCmds .= "cat << 'EOF' > \"{$dataDir}/config.yaml\"\n{$yamlContent}\nEOF\n";
        
        // Check if WHMCS Server requires secure connection (uses reverse proxy caddy)
        $isSecure = !empty($params['serversecure']) && ($params['serversecure'] === true || $params['serversecure'] === 'on' || $params['serversecure'] === '1');
        $bindIp = $isSecure ? "127.0.0.1" : "0.0.0.0";
        
        // Remove existing container and its dedicated network
        $setupCmds .= "docker rm -f \"hermes-{$serviceid}\" 2>/dev/null || true\n";
        $setupCmds .= "docker network rm \"hermes-net-{$serviceid}\" 2>/dev/null || true\n";
        // Per-customer isolated bridge — containers cannot reach each other's networks
        $setupCmds .= "docker network create --driver bridge \"hermes-net-{$serviceid}\" >/dev/null\n";

        // Run container with hardened security flags:
        // --network hermes-net-{id}   : isolated per-customer network, no inter-container routing
        // --cap-drop ALL              : strip all Linux capabilities (no raw sockets, no mounts, etc.)
        // --security-opt no-new-privileges : prevent setuid/sudo privilege escalation inside container
        // --pids-limit 200            : block fork bombs
        // --ipc=none                  : disable shared memory IPC between containers
        // Port 3000 is the user project hosting port, always localhost-only so Caddy is the only entry point
        $setupCmds .= "docker run -d \\
  --name \"hermes-{$serviceid}\" \\
  --network \"hermes-net-{$serviceid}\" \\
  --restart unless-stopped \\
  --cpus=\"{$cpus}\" --memory=\"{$memory}\" \\
  --pids-limit 200 \\
  --cap-drop ALL \\
  --cap-add SETUID \\
  --cap-add SETGID \\
  --cap-add DAC_OVERRIDE \\
  --cap-add CHOWN \\
  --security-opt no-new-privileges \\
  --ipc=none \\
  --env-file \"{$dataDir}/.env\" \\
  -v \"{$dataDir}:/opt/data\" \\
  -p \"{$bindIp}:{$dashPort}:9119\" \\
  -p \"{$bindIp}:{$apiPort}:8642\" \\
  -p \"127.0.0.1:{$hostPort}:3000\" \\
  nousresearch/hermes-agent:{$dockerImageTag} gateway run\n";
        
        // Inject SNBD HOST branding and GTM into the compiled web dashboard
        $brandingHtml = <<<HTML
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-N675SJK');</script>
<!-- End Google Tag Manager -->
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-N675SJK"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

<style>
  /* ── reset old topbar padding ── */
  body { padding-top: 34px !important; }

  /* ── Top Beta Bar ── */
  #snbd-beta-bar {
    position: fixed;
    top: 0; left: 0; right: 0;
    height: 34px;
    background: rgba(9, 9, 9, 0.97);
    border-bottom: 1px solid rgba(255, 122, 32, 0.18);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    z-index: 999999;
    font-family: system-ui, -apple-system, 'Segoe UI', sans-serif;
    font-size: 12px;
    letter-spacing: 0.01em;
    -webkit-backdrop-filter: blur(10px);
    backdrop-filter: blur(10px);
    overflow: hidden;
  }

  /* animated orange hairline at the very top edge */
  #snbd-beta-bar::before {
    content: '';
    position: absolute;
    top: 0; left: -100%; right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, #FF7A20 40%, #FFB347 60%, transparent 100%);
    animation: snbd-slide 4s ease-in-out infinite;
  }

  @keyframes snbd-slide {
    0%   { left: -100%; }
    50%  { left: 0%; }
    100% { left: 100%; }
  }

  /* BETA pill */
  .snbd-b-pill {
    background: linear-gradient(130deg, #FF7A20 0%, #FFB347 100%);
    color: #0A0A0A;
    font-size: 9.5px;
    font-weight: 800;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    padding: 2.5px 8px 2px;
    border-radius: 100px;
    line-height: 1.5;
    flex-shrink: 0;
  }

  .snbd-b-msg {
    color: rgba(255, 255, 255, 0.52);
    white-space: nowrap;
  }

  .snbd-b-msg strong {
    color: rgba(255, 255, 255, 0.82);
    font-weight: 600;
  }

  /* brand lockup */
  .snbd-b-brand {
    display: flex;
    align-items: center;
    gap: 8px;
    padding-left: 12px;
    margin-left: 2px;
    border-left: 1px solid rgba(255, 255, 255, 0.09);
    flex-shrink: 0;
  }

  .snbd-b-brand-name {
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.06em;
    color: rgba(255, 255, 255, 0.7);
    text-transform: uppercase;
  }

  .snbd-b-brand-sub {
    font-size: 10px;
    font-weight: 400;
    letter-spacing: 0.04em;
    color: rgba(255, 255, 255, 0.28);
    text-transform: none;
    margin-left: -2px;
  }

  /* ── Floating Beta Badge ── */
  #snbd-beta-float {
    position: fixed;
    bottom: 22px;
    right: 18px;
    z-index: 999999;
    font-family: system-ui, -apple-system, 'Segoe UI', sans-serif;
    pointer-events: none;
  }

  .snbd-f-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(10, 10, 10, 0.88);
    border: 1px solid rgba(255, 122, 32, 0.35);
    border-radius: 100px;
    padding: 7px 14px 7px 9px;
    -webkit-backdrop-filter: blur(14px);
    backdrop-filter: blur(14px);
    box-shadow:
      0 0 0 1px rgba(255, 122, 32, 0.08),
      0 8px 32px rgba(0, 0, 0, 0.6),
      0 0 28px rgba(255, 122, 32, 0.07);
    animation: snbd-breathe 3.5s ease-in-out infinite;
  }

  @keyframes snbd-breathe {
    0%, 100% {
      box-shadow:
        0 0 0 1px rgba(255,122,32,0.08),
        0 8px 32px rgba(0,0,0,0.6),
        0 0 22px rgba(255,122,32,0.06);
      border-color: rgba(255,122,32,0.30);
    }
    50% {
      box-shadow:
        0 0 0 1px rgba(255,122,32,0.16),
        0 8px 32px rgba(0,0,0,0.6),
        0 0 36px rgba(255,122,32,0.16);
      border-color: rgba(255,122,32,0.55);
    }
  }

  .snbd-f-dot {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: #FF7A20;
    flex-shrink: 0;
    animation: snbd-dot 3.5s ease-in-out infinite;
  }

  @keyframes snbd-dot {
    0%, 100% { opacity: 1; box-shadow: 0 0 5px #FF7A20; }
    50%       { opacity: 0.45; box-shadow: 0 0 2px #FF7A20; }
  }

  .snbd-f-inner {
    display: flex;
    flex-direction: column;
    gap: 1px;
    line-height: 1;
  }

  .snbd-f-label {
    font-size: 10.5px;
    font-weight: 800;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: #FF9A50;
  }

  .snbd-f-sub {
    font-size: 9.5px;
    font-weight: 400;
    letter-spacing: 0.03em;
    color: rgba(255, 255, 255, 0.3);
  }

  @media (prefers-reduced-motion: reduce) {
    #snbd-beta-bar::before,
    .snbd-f-badge,
    .snbd-f-dot { animation: none; }
  }
</style>

<!-- Beta Banner -->
<div id="snbd-beta-bar">
  <span class="snbd-b-pill">Beta</span>
  <span class="snbd-b-msg">We're actively building this — <strong>your feedback shapes what comes next.</strong></span>
  <div class="snbd-b-brand">
    <span class="snbd-b-brand-name">SNBD HOST <span class="snbd-b-brand-sub">&thinsp;·&thinsp; DeltaDNS</span></span>
  </div>
</div>

<!-- Persistent Floating Beta Badge -->
<div id="snbd-beta-float">
  <div class="snbd-f-badge">
    <div class="snbd-f-dot"></div>
    <div class="snbd-f-inner">
      <span class="snbd-f-label">Beta</span>
      <span class="snbd-f-sub">SNBD HOST</span>
    </div>
  </div>
</div>
HTML;
        
        $setupCmds .= "sleep 5\n"; // wait for container filesystem and hermes init to settle

        // Patch config.yaml via Python to inject system_prompt and terminal backend.
        // Hermes expands the initial config.yaml on first boot and may drop fields we wrote —
        // this step runs AFTER the container is up to ensure the values survive the expansion.
        $escapedSystemPrompt = addslashes($systemPrompt);
        $escapedHostingUrl   = addslashes($hostingUrl);
        $setupCmds .= "python3 - << 'PYEOF'\n";
        $setupCmds .= "import yaml\n";
        $setupCmds .= "cfg_path = '{$dataDir}/config.yaml'\n";
        $setupCmds .= "try:\n";
        $setupCmds .= "    with open(cfg_path) as f:\n";
        $setupCmds .= "        cfg = yaml.safe_load(f) or {}\n";
        $setupCmds .= "except Exception:\n";
        $setupCmds .= "    cfg = {}\n";
        $setupCmds .= "cfg['system_prompt'] = {'replace': '{$escapedSystemPrompt}'}\n";
        $escapedBrainUrl   = addslashes($brainBaseUrl);
        // Use the per-container virtual key so LiteLLM tracks usage per service
        $escapedTrackingKey = addslashes(!empty($litellmKey) ? $litellmKey : $brainApiKey);
        $escapedBrainModel = addslashes($brainModel);
        $setupCmds .= "if isinstance(cfg.get('model'), dict):\n";
        $setupCmds .= "    cfg['model']['base_url'] = '{$escapedBrainUrl}'\n";
        $setupCmds .= "    cfg['model']['api_key']  = '{$escapedTrackingKey}'\n";
        $setupCmds .= "    cfg['model']['provider'] = 'custom'\n";
        $setupCmds .= "    cfg['model']['default']  = '{$escapedBrainModel}'\n";
        $setupCmds .= "cfg['terminal'] = {'backend': 'local', 'timeout': 180, 'cwd': '/opt/data'}\n";
        $setupCmds .= "with open(cfg_path, 'w') as f:\n";
        $setupCmds .= "    yaml.dump(cfg, f, default_flow_style=False, allow_unicode=True)\n";
        $setupCmds .= "print('config patched')\n";
        $setupCmds .= "PYEOF\n";

        // Hermes loads config.yaml at boot and does not hot-reload it, so the
        // patched terminal backend ('local') must be picked up via restart —
        // otherwise the container keeps running with whatever backend was
        // baked into the config.yaml written before `docker run`.
        $setupCmds .= "docker restart \"hermes-{$serviceid}\" >/dev/null\n";
        $setupCmds .= "sleep 3\n";

        // Public HTTP server on port 3000 serving /opt/data/ — Caddy routes /artifacts/*
        // here. This has to come AFTER the restart above: it is a `docker exec` process,
        // not a supervised service, so restarting the container kills it and /artifacts/*
        // would 502 while the dashboard looked perfectly healthy.
        // -d (detached) is also required — with a plain `... &` the shell exits and the
        // exec session is torn down with its process group before the server serves
        // anything.
        $setupCmds .= "docker exec hermes-{$serviceid} sh -c 'mkdir -p /opt/data/artifacts'\n";
        $setupCmds .= "docker exec hermes-{$serviceid} sh -c 'pkill -f \"http.server\" 2>/dev/null || true'\n";
        $setupCmds .= "docker exec -d hermes-{$serviceid} sh -c 'python3 -m http.server 3000 --directory /opt/data > /tmp/srv.log 2>&1'\n";
        $setupCmds .= "sleep 2\n";
        $setupCmds .= "docker exec hermes-{$serviceid} sh -c 'curl -sf http://localhost:3000 > /dev/null && echo \"HTTP:3000 OK\" || echo \"HTTP:3000 FAILED\"'\n";

        $setupCmds .= "docker exec \"hermes-{$serviceid}\" sh -c \"sed -i 's/<title>Hermes Agent - Dashboard<\\/title>/<title>{$agentName} — Powered by SNBD Host<\\/title>/g' /opt/hermes/hermes_cli/web_dist/index.html\"\n";
        
        // Write branding to host first to avoid escaping issues, then pipe to container
        $setupCmds .= "cat << 'BRANDING_EOF' > \"{$dataDir}/branding.html\"\n{$brandingHtml}\nBRANDING_EOF\n";
        $setupCmds .= "docker exec -i \"hermes-{$serviceid}\" sh -c \"cat >> /opt/hermes/hermes_cli/web_dist/index.html\" < \"{$dataDir}/branding.html\"\n";
        
        // {id}.hermes.deltadns.xyz is the primary domain: /artifacts/* → file server, rest → dashboard.
        $artifactsUrl = "https://{$serviceid}.{$hostname}/artifacts";
        $caddyConfig = <<<CADDY
{$serviceid}.{$hostname} {
    handle /artifacts/* {
        reverse_proxy 127.0.0.1:{$hostPort}
    }
    handle {
        reverse_proxy 127.0.0.1:{$dashPort}
    }
}
CADDY;
        if ($apiEnabledVal) {
            $caddyConfig .= "\n{$serviceid}-api.{$hostname} {\n    reverse_proxy 127.0.0.1:{$apiPort}\n}";
        }

        $setupCmds .= "if which caddy >/dev/null 2>&1; then\n";
        $setupCmds .= "  mkdir -p /etc/caddy/conf.d\n";
        $setupCmds .= "  cat << 'EOF' > \"/etc/caddy/conf.d/{$serviceid}.conf\"\n{$caddyConfig}\nEOF\n";
        $setupCmds .= "  if ! grep -q \"import conf.d/\*.conf\" /etc/caddy/Caddyfile; then\n";
        $setupCmds .= "    echo \"import conf.d/*.conf\" >> /etc/caddy/Caddyfile\n";
        $setupCmds .= "  fi\n";
        $setupCmds .= "  systemctl reload caddy || caddy reload --config /etc/caddy/Caddyfile || true\n";
        $setupCmds .= "fi\n";
        
        $setupCmds .= "echo \"HEALTHY\"\n";

        // Execute commands
        $sshResponse = $ssh->exec($setupCmds);
        
        // Redact secrets in logs
        $redactedCmds = $setupCmds;
        if (!empty($providerApiKey)) {
            $redactedCmds = str_replace($providerApiKey, '[REDACTED_API_KEY]', $redactedCmds);
        }
        if (!empty($messagingToken)) {
            $redactedCmds = str_replace($messagingToken, '[REDACTED_MSG_TOKEN]', $redactedCmds);
        }
        $redactedCmds = str_replace($dashboardPassword, '[REDACTED_DASH_PASSWORD]', $redactedCmds);
        $redactedCmds = str_replace($dashboardSecret, '[REDACTED_DASH_SECRET]', $redactedCmds);
        $redactedCmds = str_replace($apiKey, '[REDACTED_API_KEY]', $redactedCmds);

        logModuleCall(
            'hermesagent',
            'CreateAccount',
            $redactedCmds,
            $sshResponse,
            null,
            [$providerApiKey, $messagingToken, $dashboardPassword, $apiKey]
        );

        if (strpos($sshResponse, 'HEALTHY') === false) {
            Capsule::table('mod_hermesagent_instances')
                ->where('serviceid', $serviceid)
                ->update(['status' => 'Error', 'updated_at' => date('Y-m-d H:i:s')]);
            return "Deployment completed but health check failed: " . strip_tags(trim($sshResponse));
        }

        Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', $serviceid)
            ->update([
                'status'        => 'Active',
                'current_model' => $brainModel,
                'updated_at'    => date('Y-m-d H:i:s'),
            ]);

        return "success";
    } catch (\Exception $e) {
        logModuleCall('hermesagent', 'CreateAccount_Failed', $e->getMessage(), $e->getTraceAsString());
        return "SSH Provisioning failed: " . $e->getMessage();
    }
}

/**
 * Account Suspension
 */
function hermesagent_SuspendAccount($params) {
    $serviceid = intval($params['serviceid']);
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        // Also suspend LiteLLM virtual key if present
        $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
        if ($record && !empty($record->litellm_key_id)) {
            try {
                $ltCfg = hermesagent_litellm_config($params);
                if (!empty($ltCfg['key'])) {
                    hermesagent_litellm_update_key($ltCfg['url'], $ltCfg['key'], $record->litellm_key_id, false);
                }
            } catch (\Exception $e) {
                logModuleCall('hermesagent', 'SuspendAccount_LiteLLM', $serviceid, $e->getMessage());
            }
        }
        
        $hostname = "hermes.deltadns.xyz";
        $enableApiServer = hermesagent_resolve_param($params, 'configoption6', 'Enable OpenAI-Compatible API', 'no');
        $apiEnabledVal = ($enableApiServer === 'yes' || $enableApiServer === 'on' || $enableApiServer === '1');

        $suspendedHtml = "<!DOCTYPE html><html><head><title>Account Suspended</title><style>body{font-family:sans-serif;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;background:#f9fafb;color:#111827;} .box{text-align:center;padding:40px;background:white;border-radius:8px;box-shadow:0 4px 6px rgba(0,0,0,0.1);max-width:500px;} h1{color:#dc2626;margin-top:0;} p{color:#4b5563;line-height:1.5;}</style></head><body><div class=\"box\"><h1>Account Suspended</h1><p>Your Hermes Agent account has been suspended.</p><p>Please check your billing status or contact support to reactivate your service.</p></div></body></html>";

        $caddySuspended = <<<CADDY
{$serviceid}.{$hostname} {
    respond `{$suspendedHtml}` 403 {
        close
    }
}
CADDY;
        if ($apiEnabledVal) {
            $caddySuspended .= "\n{$serviceid}-api.{$hostname} {\n    respond `{\"error\":\"Account Suspended\"}` 403 {\n        close\n    }\n}";
        }

        $cmd = "docker stop \"hermes-{$serviceid}\"";
        $cmd .= " && if [ -d \"/etc/caddy/conf.d\" ]; then\n";
        $cmd .= "  cat << 'EOF' > \"/etc/caddy/conf.d/{$serviceid}.conf\"\n{$caddySuspended}\nEOF\n";
        $cmd .= "  systemctl reload caddy || caddy reload --config /etc/caddy/Caddyfile || true\n";
        $cmd .= "fi";
        
        $result = $ssh->exec($cmd);
        
        logModuleCall('hermesagent', 'SuspendAccount', $cmd, $result);
        
        Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', $serviceid)
            ->update(['status' => 'Suspended', 'updated_at' => date('Y-m-d H:i:s')]);
            
        return "success";
    } catch (\Exception $e) {
        return "Suspension failed: " . $e->getMessage();
    }
}

/**
 * Account Unsuspension
 */
function hermesagent_UnsuspendAccount($params) {
    $serviceid = intval($params['serviceid']);
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
        if (!$record) {
            return "Deployment record not found in database.";
        }
        
        // Also reactivate LiteLLM virtual key if present
        if (!empty($record->litellm_key_id)) {
            try {
                $ltCfg = hermesagent_litellm_config($params);
                if (!empty($ltCfg['key'])) {
                    hermesagent_litellm_update_key($ltCfg['url'], $ltCfg['key'], $record->litellm_key_id, true);
                }
            } catch (\Exception $e) {
                logModuleCall('hermesagent', 'UnsuspendAccount_LiteLLM', $serviceid, $e->getMessage());
            }
        }
        
        $dashPort = $record->dash_port;
        $apiPort  = $record->api_port;
        $hostPort = $record->host_port ?: (7300 + ($serviceid % 1000));
        $hostname = "hermes.deltadns.xyz";

        $enableApiServer = hermesagent_resolve_param($params, 'configoption6', 'Enable OpenAI-Compatible API', 'no');
        $apiEnabledVal = ($enableApiServer === 'yes' || $enableApiServer === 'on' || $enableApiServer === '1');

        $caddyConfig = <<<CADDY
{$serviceid}.{$hostname} {
    handle /artifacts/* {
        reverse_proxy 127.0.0.1:{$hostPort}
    }
    handle {
        reverse_proxy 127.0.0.1:{$dashPort}
    }
}
CADDY;
        if ($apiEnabledVal) {
            $caddyConfig .= "\n{$serviceid}-api.{$hostname} {\n    reverse_proxy 127.0.0.1:{$apiPort}\n}";
        }

        $cmd = "docker start \"hermes-{$serviceid}\"";
        $cmd .= " && if [ -d \"/etc/caddy/conf.d\" ]; then\n";
        $cmd .= "  cat << 'EOF' > \"/etc/caddy/conf.d/{$serviceid}.conf\"\n{$caddyConfig}\nEOF\n";
        $cmd .= "  systemctl reload caddy || caddy reload --config /etc/caddy/Caddyfile || true\n";
        $cmd .= "fi";
        
        $result = $ssh->exec($cmd);
        
        logModuleCall('hermesagent', 'UnsuspendAccount', $cmd, $result);
        
        Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', $serviceid)
            ->update(['status' => 'Active', 'updated_at' => date('Y-m-d H:i:s')]);
            
        return "success";
    } catch (\Exception $e) {
        return "Unsuspension failed: " . $e->getMessage();
    }
}

/**
 * Account Termination
 */
function hermesagent_TerminateAccount($params) {
    $serviceid = intval($params['serviceid']);
    
    try {
        // First: delete LiteLLM virtual key if present (before SSH, in case VPS is gone)
        $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
        if ($record && !empty($record->litellm_key_id)) {
            try {
                $ltCfg = hermesagent_litellm_config($params);
                if (!empty($ltCfg['key'])) {
                    hermesagent_litellm_delete_key($ltCfg['url'], $ltCfg['key'], $record->litellm_key_id);
                }
            } catch (\Exception $e) {
                logModuleCall('hermesagent', 'TerminateAccount_LiteLLM', $serviceid, $e->getMessage());
            }
        }
        
        $ssh = hermesagent_get_ssh_client($params);
        
        // Steps: 
        // 1. Create a timestamped backup archive of data
        // 2. Remove container
        // 3. Remove client files
        // 4. Remove Caddy reverse proxy config if present
        $cmd = "mkdir -p /srv/hermes/archive && \\\n";
        $cmd .= "tar -czf \"/srv/hermes/archive/hermes-{$serviceid}-\$(date +%Y%m%d%H%M%S).tar.gz\" -C /srv/hermes/{$serviceid} data 2>/dev/null || true && \\\n";
        $cmd .= "docker rm -fv \"hermes-{$serviceid}\" 2>/dev/null || true && \\\n";
        $cmd .= "docker network rm \"hermes-net-{$serviceid}\" 2>/dev/null || true && \\\n";
        $cmd .= "rm -rf \"/srv/hermes/{$serviceid}\" && \\\n";
        $cmd .= "if [ -f \"/etc/caddy/conf.d/{$serviceid}.conf\" ]; then\n";
        $cmd .= "  rm -f \"/etc/caddy/conf.d/{$serviceid}.conf\"\n";
        $cmd .= "  systemctl reload caddy || caddy reload --config /etc/caddy/Caddyfile || true\n";
        $cmd .= "fi";

        $result = $ssh->exec($cmd);
        logModuleCall('hermesagent', 'TerminateAccount', $cmd, $result);
        
        Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', $serviceid)
            ->delete();
            
        return "success";
    } catch (\Exception $e) {
        return "Termination failed: " . $e->getMessage();
    }
}

/**
 * Change Service Password (rotates Dashboard Authentication Password)
 */
function hermesagent_ChangePassword($params) {
    hermesagent_setup_database();
    $serviceid = intval($params['serviceid']);
    $newPassword = $params['password'] ?: hermesagent_generate_random_password(16);
    
    $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
    if (!$record) {
        return "Hermes deployment record not found in WHMCS database.";
    }
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        $dataDir = "/srv/hermes/{$serviceid}/data";
        
        // Read existing .env, update basic auth password line, write it back
        $cmd = "if [ -f \"{$dataDir}/.env\" ]; then\n";
        // sed inline replace password
        $cmd .= "  sed -i 's/^HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=.*/HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=" . escapeshellarg($newPassword) . "/' \"{$dataDir}/.env\"\n";
        $cmd .= "  docker restart \"hermes-{$serviceid}\"\n";
        $cmd .= "  echo \"SUCCESS\"\n";
        $cmd .= "else\n";
        $cmd .= "  echo \"ENV_FILE_NOT_FOUND\"\n";
        $cmd .= "fi";
        
        $result = trim($ssh->exec($cmd));
        logModuleCall('hermesagent', 'ChangePassword', $cmd, $result, null, [$newPassword]);
        
        if ($result !== 'SUCCESS') {
            return "Failed to update env file on host: " . $result;
        }
        
        Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', $serviceid)
            ->update([
                'dashboard_password' => $newPassword,
                'updated_at' => date('Y-m-d H:i:s')
            ]);
            
        return "success";
    } catch (\Exception $e) {
        return "Password change failed: " . $e->getMessage();
    }
}

/**
 * Change Package Resources (CPU/Memory update)
 */
function hermesagent_ChangePackage($params) {
    $serviceid = intval($params['serviceid']);
    $resourceTier = hermesagent_resolve_param($params, 'configoption7', 'Resource Tier', 'Standard (2 vCPU / 2GB)');
    
    $cpus = '2.0';
    $memory = '2g';
    if (stripos($resourceTier, 'Starter') !== false) {
        $cpus = '1.0';
        $memory = '1g';
    } elseif (stripos($resourceTier, 'Pro') !== false) {
        $cpus = '4.0';
        $memory = '4g';
    }
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        // Update resource limits on the container
        $cmd = "docker update --cpus=\"{$cpus}\" --memory=\"{$memory}\" \"hermes-{$serviceid}\"";
        $result = $ssh->exec($cmd);
        logModuleCall('hermesagent', 'ChangePackage', $cmd, $result);
        
        return "success";
    } catch (\Exception $e) {
        return "Package change failed: " . $e->getMessage();
    }
}

/**
 * Define action buttons visible in Client Area.
 */
function hermesagent_ClientAreaCustomButtonArray() {
    return [
        'Chat with Agent' => 'manage_chat',
        'Manage LLM Providers' => 'manage_llm',
        'MCP Servers' => 'manage_mcp',
        'Terminal' => 'manage_terminal',
        'Restart Agent' => 'restart',
        'View Logs' => 'viewlogs',
        'Regenerate Password' => 'regenpassword',
        'Download Agent Brain' => 'downloadbackup',
        'Kill Switch' => 'killswitch',
    ];
}

/**
 * Define action buttons visible in Admin Area.
 */
function hermesagent_AdminCustomButtonArray() {
    return [
        'Restart Agent' => 'restart',
        'View Logs' => 'viewlogs',
        'Regenerate Password' => 'regenpassword',
        'Force Redeploy' => 'redeploy',
        'SSH Health Check' => 'healthcheck',
    ];
}

/**
 * Custom action: Restart Container
 */
function hermesagent_restart($params) {
    $serviceid = intval($params['serviceid']);
    try {
        $ssh = hermesagent_get_ssh_client($params);
        $cmd = "docker restart \"hermes-{$serviceid}\"";
        $result = $ssh->exec($cmd);
        logModuleCall('hermesagent', 'restart', $cmd, $result);
        return "success";
    } catch (\Exception $e) {
        return "Restart failed: " . $e->getMessage();
    }
}

/**
 * Custom action: View Logs (returns raw HTML format)
 */
function hermesagent_viewlogs($params) {
    $serviceid = intval($params['serviceid']);
    try {
        $ssh = hermesagent_get_ssh_client($params);
        $cmd = "docker logs --tail 100 \"hermes-{$serviceid}\" 2>&1";
        $result = $ssh->exec($cmd);
        logModuleCall('hermesagent', 'viewlogs', $cmd, '[truncated logs]');
        
        if (empty($result)) {
            $result = "No logs returned from container.";
        }
        
        return "<pre style='text-align: left; max-height: 400px; overflow-y: auto; color: #a9b7c6; background: #2b2b2b; padding: 15px; border-radius: 6px; font-family: monospace; font-size: 12px; line-height: 1.4; border: 1px solid #3c3f41;'>" . htmlspecialchars($result) . "</pre>";
    } catch (\Exception $e) {
        return "Failed to fetch logs: " . $e->getMessage();
    }
}

/**
 * Custom action: Regenerate Dashboard Password
 */
function hermesagent_regenpassword($params) {
    $newPass = hermesagent_generate_random_password(16);
    $params['password'] = $newPass;
    $res = hermesagent_ChangePassword($params);
    if ($res === 'success') {
        return "Dashboard Password regenerated successfully! New Password: " . $newPass;
    }
    return "Failed to regenerate password: " . $res;
}

/**
 * Custom action: Download Agent Brain Backup
 */
function hermesagent_downloadbackup($params) {
    $serviceid = intval($params['serviceid']);
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        $tmpFile = "/tmp/hermes_brain_{$serviceid}_" . time() . ".tar.gz";
        $dataDir = "/srv/hermes/{$serviceid}/data";
        
        // Check if data directory exists
        $check = trim($ssh->exec("if [ -d \"{$dataDir}\" ]; then echo 'EXISTS'; else echo 'NOT_FOUND'; fi"));
        if ($check !== 'EXISTS') {
            return "Agent data directory not found on host.";
        }
        
        // Compress the directory and base64 encode it so it can safely cross the SSH output stream
        $cmd = "tar -czf \"{$tmpFile}\" -C \"/srv/hermes/{$serviceid}\" data && base64 \"{$tmpFile}\" && rm -f \"{$tmpFile}\"";
        $b64 = $ssh->exec($cmd);
        
        $binary = base64_decode(trim($b64));
        if (empty($binary)) {
            return "Failed to generate or download the backup archive.";
        }
        
        // Force file download in browser
        ob_clean();
        header('Content-Description: File Transfer');
        header('Content-Type: application/x-gzip');
        header('Content-Disposition: attachment; filename="hermes_brain_'.$serviceid.'_'.date('Ymd').'.tar.gz"');
        header('Content-Length: ' . strlen($binary));
        echo $binary;
        exit;
    } catch (\Exception $e) {
        return "Backup failed: " . $e->getMessage();
    }
}

/**
 * Custom action: Kill Switch (Wipe Agent and Data forever)
 */
function hermesagent_killswitch($params) {
    $serviceid = intval($params['serviceid']);
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        // Hard wipe container and data directory
        $cmd = "docker rm -fv \"hermes-{$serviceid}\" 2>/dev/null || true && \\\n";
        $cmd .= "rm -rf \"/srv/hermes/{$serviceid}\" && \\\n";
        $cmd .= "if [ -f \"/etc/caddy/conf.d/{$serviceid}.conf\" ]; then\n";
        $cmd .= "  rm -f \"/etc/caddy/conf.d/{$serviceid}.conf\"\n";
        $cmd .= "  systemctl reload caddy || caddy reload --config /etc/caddy/Caddyfile || true\n";
        $cmd .= "fi";
        
        $result = $ssh->exec($cmd);
        logModuleCall('hermesagent', 'KillSwitch', $cmd, $result);
        
        Capsule::table('mod_hermesagent_instances')
            ->where('serviceid', $serviceid)
            ->update(['status' => 'Terminated', 'updated_at' => date('Y-m-d H:i:s')]);
            
        return "success";
    } catch (\Exception $e) {
        return "Kill Switch failed: " . $e->getMessage();
    }
}

/**
 * Custom action: Force Redeploy (Admin-only)
 */
function hermesagent_redeploy($params) {
    return hermesagent_CreateAccount($params);
}

/**
 * Custom action: SSH Health Check
 */
function hermesagent_healthcheck($params) {
    $serviceid = intval($params['serviceid']);
    
    $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
    if (!$record) {
        return "No instance mapping found in WHMCS database.";
    }
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        
        $cmd = "docker inspect --format='{{.State.Status}}' \"hermes-{$serviceid}\" 2>/dev/null || echo \"NOT_FOUND\"";
        $containerStatus = trim($ssh->exec($cmd));
        
        $cmdCheck = "STATUS=\$(curl -s -o /dev/null -w \"%{http_code}\" \"http://127.0.0.1:{$record->dash_port}/\" || echo \"000\")\n";
        $cmdCheck .= "echo \$STATUS";
        $httpStatus = trim($ssh->exec($cmdCheck));
        
        logModuleCall('hermesagent', 'healthcheck', $cmd . "\n" . $cmdCheck, "Docker: {$containerStatus}, HTTP: {$httpStatus}");
        
        $message = "Hermes Host Connection: SUCCESS\n";
        $message .= "Container Status: " . strtoupper($containerStatus) . "\n";
        $message .= "Dashboard Port Status (HTTP Code): " . $httpStatus . " (" . ($httpStatus == '401' || $httpStatus == '200' ? 'Operational' : 'Failed') . ")";
        
        return nl2br(htmlspecialchars($message));
    } catch (\Exception $e) {
        return "SSH Connection failed: " . $e->getMessage();
    }
}

/**
 * Custom action: Manage LLM Providers
 */
function hermesagent_manage_llm($params) {
    $serviceid = intval($params['serviceid']);

    $llmProvider = hermesagent_resolve_param($params, 'configoption1', 'LLM Provider', 'nous_portal');
    $isFreeTier = ($llmProvider === 'free-tier' || $llmProvider === 'bedrock');

    // Default values if we can't parse them
    $vars = [
        'active_model' => '',
        'openrouter_key' => '',
        'openai_key' => '',
        'anthropic_key' => '',
        'nous_key' => '',
        'custom_url' => '',
        'custom_key' => '',
        'telegram_token' => '',
        'discord_token' => '',
        'slack_token' => '',
        'serviceid' => $serviceid,
        'success' => isset($_GET['success']) ? true : false,
        'error' => '',
        'deployment_status' => $params['status'],
        'is_free_tier' => $isFreeTier
    ];
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        $dataDir = "/srv/hermes/{$serviceid}/data";
        
        // Read .env
        $envData = $ssh->exec("cat \"{$dataDir}/.env\" 2>/dev/null || echo ''");
        if ($envData) {
            $lines = explode("\n", $envData);
            foreach ($lines as $line) {
                if (strpos($line, '=') !== false && strpos(trim($line), '#') !== 0) {
                    list($key, $val) = explode('=', $line, 2);
                    $key = trim($key);
                    $val = trim($val);
                    if ($key === 'OPENROUTER_API_KEY') $vars['openrouter_key'] = $val;
                    if ($key === 'OPENAI_API_KEY') $vars['openai_key'] = $val; // Might be custom key too, we'll disambiguate later
                    if ($key === 'ANTHROPIC_API_KEY') $vars['anthropic_key'] = $val;
                    if ($key === 'NOUS_PORTAL_API_KEY') $vars['nous_key'] = $val;
                    if ($key === 'OPENAI_API_BASE') $vars['custom_url'] = $val;
                    if ($key === 'TELEGRAM_BOT_TOKEN') $vars['telegram_token'] = $val;
                    if ($key === 'DISCORD_BOT_TOKEN') $vars['discord_token'] = $val;
                    if ($key === 'SLACK_BOT_TOKEN') $vars['slack_token'] = $val;
                }
            }
        }
        
        // Disambiguate OpenAI key vs Custom endpoint key
        if (!empty($vars['custom_url']) && !empty($vars['openai_key'])) {
            $vars['custom_key'] = $vars['openai_key'];
            $vars['openai_key'] = ''; // It was used for custom
        }
        
        // Read config.yaml
        $yamlData = $ssh->exec("cat \"{$dataDir}/config.yaml\" 2>/dev/null || echo ''");
        if ($yamlData) {
            preg_match('/^model:\s*"?([^"\n\r]+)"?/m', $yamlData, $matches);
            if (!empty($matches[1])) {
                $vars['active_model'] = $matches[1];
            }
        }
        
        // If model is still empty and we're on free tier, show the configured default
        if (empty($vars['active_model']) && $isFreeTier) {
            $ltCfg = hermesagent_litellm_config($params);
            if (!empty($ltCfg['model'])) {
                $vars['active_model'] = $ltCfg['model'] . ' (auto)';
            }
        }
    } catch (\Exception $e) {
        $vars['error'] = "Could not fetch live configuration: " . $e->getMessage();
    }
    
    return [
        'templatefile' => 'templates/manage_llm',
        'vars' => $vars
    ];
}

/**
 * Custom action: Update LLM Providers (POST handler)
 */
function hermesagent_update_llm($params) {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header("Location: clientarea.php?action=productdetails&id=" . intval($params['serviceid']) . "&modop=custom&a=manage_llm");
        exit;
    }
    
    $serviceid = intval($params['serviceid']);
    $model = trim($_POST['active_model'] ?? '');
    
    // Build new keys array
    $keysToUpdate = [];
    if (!empty($_POST['openrouter_key'])) $keysToUpdate['OPENROUTER_API_KEY'] = trim($_POST['openrouter_key']);
    if (!empty($_POST['openai_key'])) $keysToUpdate['OPENAI_API_KEY'] = trim($_POST['openai_key']);
    if (!empty($_POST['anthropic_key'])) $keysToUpdate['ANTHROPIC_API_KEY'] = trim($_POST['anthropic_key']);
    if (!empty($_POST['nous_key'])) $keysToUpdate['NOUS_PORTAL_API_KEY'] = trim($_POST['nous_key']);
    if (!empty($_POST['telegram_token'])) $keysToUpdate['TELEGRAM_BOT_TOKEN'] = trim($_POST['telegram_token']);
    if (!empty($_POST['discord_token'])) $keysToUpdate['DISCORD_BOT_TOKEN'] = trim($_POST['discord_token']);
    if (!empty($_POST['slack_token'])) $keysToUpdate['SLACK_BOT_TOKEN'] = trim($_POST['slack_token']);

    if (!empty($_POST['custom_url'])) {
        $keysToUpdate['OPENAI_API_BASE'] = trim($_POST['custom_url']);
        if (!empty($_POST['custom_key'])) {
            $keysToUpdate['OPENAI_API_KEY'] = trim($_POST['custom_key']); // Overrides standard openai if both submitted
        }
    }
    
    try {
        $ssh = hermesagent_get_ssh_client($params);
        $dataDir = "/srv/hermes/{$serviceid}/data";
        
        $cmd = "";
        
        // 1. Update config.yaml for the model
        if (!empty($model)) {
            // Escape slashes for sed
            $escModel = str_replace('/', '\/', $model);
            $cmd .= "sed -i 's/^model:.*/model: \"{$escModel}\"/' \"{$dataDir}/config.yaml\"\n";
        }
        
        // 2. Update .env for each key
        // We will remove existing occurrences of these keys, then append them
        $allPossibleKeys = ['OPENROUTER_API_KEY', 'OPENAI_API_KEY', 'ANTHROPIC_API_KEY', 'NOUS_PORTAL_API_KEY', 'OPENAI_API_BASE', 'TELEGRAM_BOT_TOKEN', 'DISCORD_BOT_TOKEN', 'SLACK_BOT_TOKEN'];
        foreach ($allPossibleKeys as $k) {
            $cmd .= "sed -i '/^{$k}=/d' \"{$dataDir}/.env\"\n";
        }
        foreach ($keysToUpdate as $k => $v) {
            // Escape value safely
            $safeV = escapeshellarg($v);
            $cmd .= "echo \"{$k}={$safeV}\" >> \"{$dataDir}/.env\"\n";
        }

        // 3. Restart container to apply
        $cmd .= "docker restart \"hermes-{$serviceid}\"\n";

        $ssh->exec($cmd);
        logModuleCall('hermesagent', 'update_llm', $cmd, 'Success');

        // Persist these overrides so a future redeploy (Force Redeploy, ChangePackage,
        // etc.) re-applies them instead of silently reverting to WHMCS configurable-option
        // defaults and wiping out whatever the customer configured here.
        if (!empty($keysToUpdate)) {
            hermesagent_setup_database();
            $existingRow = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
            $existingOverrides = [];
            if ($existingRow && !empty($existingRow->custom_env)) {
                $decoded = json_decode($existingRow->custom_env, true);
                if (is_array($decoded)) $existingOverrides = $decoded;
            }
            $mergedOverrides = array_merge($existingOverrides, $keysToUpdate);
            Capsule::table('mod_hermesagent_instances')
                ->where('serviceid', $serviceid)
                ->update([
                    'custom_env' => json_encode($mergedOverrides),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
        }

        header("Location: clientarea.php?action=productdetails&id={$serviceid}&modop=custom&a=manage_llm&success=1");
        exit;
        
    } catch (\Exception $e) {
        logModuleCall('hermesagent', 'update_llm', 'Failed', $e->getMessage());
        // Simple error redirect
        header("Location: clientarea.php?action=productdetails&id={$serviceid}&modop=custom&a=manage_llm&error=1");
        exit;
    }
}

/**
 * Custom action: Manage MCP Servers
 */
function hermesagent_manage_mcp($params) {
    $serviceid = intval($params['serviceid']);

    $installed = [];
    $error = '';

    try {
        $ssh     = hermesagent_get_ssh_client($params, 10);
        $dataDir = "/srv/hermes/{$serviceid}/data";

        // Read installed MCP servers from config.yaml
        $raw = $ssh->exec("cat \"{$dataDir}/config.yaml\" 2>/dev/null || echo ''");
        if ($raw) {
            // Parse mcp_servers section — look for keys under mcp_servers
            if (preg_match('/^mcp_servers\s*:(.*?)(?=^\S|\z)/ms', $raw, $m)) {
                preg_match_all('/^\s{2}(\w[\w\-]+)\s*:/m', $m[1], $keys);
                $installed = $keys[1] ?? [];
            }
        }
    } catch (\Exception $e) {
        $error = $e->getMessage();
    }

    return [
        'templatefile' => 'templates/manage_mcp',
        'vars' => [
            'serviceid'        => $serviceid,
            'installed'        => $installed,
            'error'            => $error,
            'deployment_status'=> $params['status'],
        ]
    ];
}

function hermesagent_manage_chat($params) {
    $serviceid = intval($params['serviceid']);
    $hostname  = 'hermes.deltadns.xyz';
    $chatUrl   = "https://{$serviceid}.{$hostname}/chat";

    // Hand straight off to the agent's own dashboard chat. Rendering a chat UI
    // inside WHMCS meant every visit paid for the whole clientarea page — Smarty,
    // hooks, the client template — before a single message could be typed. The
    // agent already ships a faster chat than anything worth rebuilding here, and
    // its session cookie lasts 30 days, so the customer signs in once.
    if (!headers_sent()) {
        header('Location: ' . $chatUrl, true, 302);
        exit;
    }

    return [
        'templatefile' => 'templates/manage_chat',
        'vars' => [
            'serviceid'         => $serviceid,
            'chat_url'          => $chatUrl,
            'deployment_status' => $params['status'],
        ]
    ];
}

function hermesagent_manage_terminal($params) {
    $serviceid = intval($params['serviceid']);
    return [
        'templatefile' => 'templates/manage_terminal',
        'vars' => [
            'serviceid'         => $serviceid,
            'deployment_status' => $params['status'],
        ]
    ];
}

// ═══════════════════════════════════════════════════════════════
//  Domain Management
// ═══════════════════════════════════════════════════════════════

function hermesagent_setup_domains_db() {
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

function hermesagent_domain_write_caddy($ssh, $serviceid, $domain, $hostPort, $dashPort) {
    // The instance's own hostname is already served by {$serviceid}.conf, written at
    // provision time. Writing it again under a second filename gives Caddy two blocks
    // for one site, which makes the whole Caddyfile fail to adapt ("ambiguous site
    // definition"). Caddy then keeps serving its last good in-memory config, so every
    // vhost added afterwards silently never loads.
    if (strcasecmp(trim($domain), $serviceid . '.hermes.deltadns.xyz') === 0) {
        return;
    }
    $conf = "{$domain} {\n    handle /artifacts/* {\n        reverse_proxy 127.0.0.1:{$hostPort}\n    }\n    handle {\n        reverse_proxy 127.0.0.1:{$dashPort}\n    }\n}\n";
    $file = '/etc/caddy/conf.d/' . preg_replace('/[^a-zA-Z0-9._-]/', '_', $domain) . '.conf';
    $b64  = base64_encode($conf);
    // Validate before reloading, and roll the file back if the result is not adaptable,
    // so one bad vhost cannot freeze Caddy on a stale config.
    $esc = escapeshellarg($file);
    $ssh->exec(
        "echo '" . $b64 . "' | base64 -d > {$esc} && " .
        "if caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null 2>&1; then " .
        "systemctl reload caddy 2>/dev/null || true; else rm -f {$esc}; fi"
    );
}

function hermesagent_domain_remove_caddy($ssh, $domain) {
    $file = '/etc/caddy/conf.d/' . preg_replace('/[^a-zA-Z0-9._-]/', '_', $domain) . '.conf';
    $ssh->exec("rm -f " . escapeshellarg($file) . " && systemctl reload caddy 2>/dev/null || true");
}

/**
 * Client Area Output page
 */
function hermesagent_ClientArea($params) {
    hermesagent_setup_database();
    hermesagent_setup_domains_db();
    $serviceid = intval($params['serviceid']);
    
    $record = Capsule::table('mod_hermesagent_instances')->where('serviceid', $serviceid)->first();
    if (!$record) {
        $onboarding = Capsule::table('mod_hermesagent_onboarding')->where('serviceid', $serviceid)->first();
        
        // If no onboarding record exists yet (e.g. CreateAccount wasn't triggered by WHMCS auto-setup), create it now.
        if (!$onboarding) {
            Capsule::table('mod_hermesagent_onboarding')->insert([
                'serviceid' => $serviceid, 'status' => 'pending', 'created_at' => date('Y-m-d H:i:s')
            ]);
            $onboarding = Capsule::table('mod_hermesagent_onboarding')->where('serviceid', $serviceid)->first();
        }

        if ($onboarding) {
            $onbStatus = is_array($onboarding) ? $onboarding['status'] : $onboarding->status;
            if (in_array($onbStatus, ['pending', 'completed'])) {
                // Load onboarding UI
                return [
                    'templatefile' => 'templates/onboarding',
                    'vars' => [
                        'serviceid' => $serviceid,
                        'status' => $onbStatus,
                        'agent_name' => is_array($onboarding) ? $onboarding['agent_name'] : $onboarding->agent_name,
                        'use_case' => is_array($onboarding) ? $onboarding['use_case'] : $onboarding->use_case,
                        'tone' => is_array($onboarding) ? $onboarding['tone'] : $onboarding->tone,
                        'custom_instructions' => is_array($onboarding) ? $onboarding['custom_instructions'] : $onboarding->custom_instructions
                    ]
                ];
            }
        }

        return [
            'templatefile' => 'templates/clientarea',
            'vars' => [
                'deployment_status' => 'Pending Provisioning (Onb Status: ' . ($onboarding ? $onboarding->status : 'NULL') . ')',
                'dashboard_url' => '',
                'api_url' => '',
                'api_enabled' => false,
                'username' => '',
                'password' => '',
                'api_key' => '',
                'error' => 'No active server deployment found.'
            ]
        ];
    }
    
    // Determine the IP/host address to use for connections
    $isSecure = !empty($params['serversecure']) && ($params['serversecure'] === true || $params['serversecure'] === 'on' || $params['serversecure'] === '1');
    $host = $params['serverip'];
    $serverHostname = $params['serverhostname'];
    
    $dashboardUrl = '';
    $apiUrl = '';
    
    if ($isSecure) {
        $dashboardUrl = "https://{$serviceid}.hermes.deltadns.xyz";
        $apiUrl = "https://{$serviceid}-api.hermes.deltadns.xyz/v1";
    } else {
        $dashboardUrl = "http://{$host}:{$record->dash_port}";
        $apiUrl = "http://{$host}:{$record->api_port}/v1";
    }
    
    $enableApiServer = hermesagent_resolve_param($params, 'configoption6', 'Enable OpenAI-Compatible API', 'no');
    $apiEnabledVal = (strtolower($enableApiServer) === 'yes' || $enableApiServer === '1' || $enableApiServer === true || $enableApiServer === 'on');
    
    // Fetch live stats via SSH to pass to the template
    $cpu = '--';
    $mem = '--';
    $promptTokens = 0;
    $completionTokens = 0;
    
    if ($record->status === 'Active') {
        // 1. Fetch CPU and Mem Usage via SSH — independent of the LiteLLM usage
        // fetch below so an SSH timeout can't blank out the token counter too.
        try {
            // Use a short 3-second timeout for ClientArea to prevent WHMCS hanging if server is down
            $ssh = hermesagent_get_ssh_client($params, 3);
            $statsCmd = "docker stats \"hermes-{$serviceid}\" --no-stream --format \"{{.CPUPerc}}|{{.MemUsage}}\" 2>/dev/null";
            $statsOutput = trim($ssh->exec($statsCmd));

            if (!empty($statsOutput)) {
                $parts = explode('|', $statsOutput);
                if (count($parts) >= 2) {
                    $cpu = trim($parts[0]);
                    $mem = trim($parts[1]);
                }
            }
        } catch (\Exception $e) {
            // Silently ignore SSH errors for stats so it doesn't break the client area
            $cpu = 'Error';
            $mem = 'Error';
        }

        // 2. Fetch Token Usage from LiteLLM (authoritative — tracks every token at proxy
        // level) — HTTP call to the gateway, no SSH involved, so it must not be gated
        // behind SSH success.
        if (!empty($record->litellm_key_value)) {
            try {
                $ltCfg = hermesagent_litellm_config($params);
                $usage = hermesagent_litellm_get_usage($ltCfg['url'], $ltCfg['key'], $record->litellm_key_value);
                if ($usage) {
                    $promptTokens     = $usage['prompt_tokens'];
                    $completionTokens = $usage['completion_tokens'];
                }
            } catch (\Exception $e) {
                logModuleCall('hermesagent', 'ClientArea_LiteLLM_Usage_Failed', $serviceid, $e->getMessage());
            }
        }
    }
    
    $createdAtTime = strtotime($record->created_at);
    $daysRemaining = 'Lifetime';

    $totalUsed = intval($promptTokens) + intval($completionTokens);
    $tokenLimit = 10000000;
    $percentUsed = min(100, ($totalUsed / $tokenLimit) * 100);

    // Enforce quota: block the LiteLLM key the moment 10M tokens is reached
    if ($totalUsed >= $tokenLimit && !empty($record->litellm_key_id)) {
        try {
            $ltCfg = hermesagent_litellm_config($params);
            hermesagent_litellm_update_key($ltCfg['url'], $ltCfg['key'], $record->litellm_key_id, false);
            logModuleCall('hermesagent', 'QuotaEnforcement', $serviceid,
                "Key blocked — {$totalUsed} tokens used (limit: {$tokenLimit})");
        } catch (\Exception $e) { /* non-fatal */ }
    }

    // Domain management
    $serverIp    = '46.62.205.66';
    $defaultDomain = $serviceid . '.hermes.deltadns.xyz';
    if (!Capsule::table('mod_hermesagent_domains')->where('domain', $defaultDomain)->exists()) {
        Capsule::table('mod_hermesagent_domains')->insert([
            'service_id' => $serviceid, 'domain' => $defaultDomain,
            'type' => 'hermes', 'status' => 'active',
            'created_at' => date('Y-m-d H:i:s'), 'updated_at' => date('Y-m-d H:i:s'),
        ]);
    }
    $domainsRows = Capsule::table('mod_hermesagent_domains')
        ->where('service_id', $serviceid)->orderBy('created_at')->get();
    $domains = [];
    foreach ($domainsRows as $d) {
        $domains[] = (array)$d;
    }

    return [
        'templatefile' => 'templates/clientarea',
        'vars' => [
            'deployment_status' => $record->status,
            'dashboard_url' => $dashboardUrl,
            'api_url' => $apiUrl,
            'api_enabled' => $apiEnabledVal,
            'username' => $record->dashboard_username,
            'password' => $record->dashboard_password,
            'api_key' => $record->api_key,
            'dash_port' => $record->dash_port,
            'api_port' => $record->api_port,
            'is_secure' => $isSecure,
            'stat_cpu' => $cpu,
            'stat_mem' => $mem,
            'stat_prompt_tokens' => $promptTokens,
            'stat_completion_tokens' => $completionTokens,
            'created_at' => $record->created_at,
            'days_remaining' => $daysRemaining,
            'total_used' => $totalUsed,
            'token_limit' => $tokenLimit,
            'percent_used' => $percentUsed,
            'domains' => $domains,
            'default_domain' => $defaultDomain,
            'server_ip' => $serverIp,
            'serviceid' => $serviceid,
        ]
    ];
}
