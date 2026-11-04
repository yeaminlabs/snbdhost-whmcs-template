<?php
/**
 * Hermes Agent Manager Addon Module
 *
 * @copyright Copyright (c) snbdhost 2026
 * @license MIT
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use Illuminate\Database\Capsule\Manager as Capsule;

/**
 * Configure the addon module.
 */
function hermesagent_config() {
    return [
        'name' => 'Hermes Agent Manager',
        'description' => 'Admin tools to automate product configurations (Custom Fields & Configurable Options) and manage active dockerized client deployments.',
        'author' => 'snbdhost',
        'language' => 'english',
        'version' => '1.0',
        'fields' => []
    ];
}

/**
 * Activate the addon module - setup database structure.
 */
function hermesagent_activate() {
    try {
        // Ensure our instances mapping table exists
        if (!Capsule::schema()->hasTable('mod_hermesagent_instances')) {
            Capsule::schema()->create(
                'mod_hermesagent_instances',
                function ($table) {
                    $table->integer('serviceid')->unique();
                    $table->integer('dash_port');
                    $table->integer('api_port');
                    $table->string('dashboard_username');
                    $table->string('dashboard_password');
                    $table->string('dashboard_secret');
                    $table->string('api_key');
                    $table->string('status')->default('Pending');
                    $table->timestamps();
                }
            );
        }
        // Quiz leads capture table
        if (!Capsule::schema()->hasTable('mod_hermesagent_quiz_leads')) {
            Capsule::schema()->create(
                'mod_hermesagent_quiz_leads',
                function ($table) {
                    $table->increments('id');
                    $table->string('name', 120)->default('');
                    $table->string('email', 200);
                    $table->string('whatsapp', 30)->default('');
                    $table->string('profile', 30)->default('');
                    $table->text('answers')->nullable();
                    $table->string('status', 20)->default('new');
                    $table->text('notes')->nullable();
                    $table->timestamps();
                    $table->index('email');
                    $table->index('status');
                    $table->index('profile');
                }
            );
        }

        // Onboarding tracking table
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

        // Brain config table — stores admin-defined AI endpoint presets
        if (!Capsule::schema()->hasTable('mod_hermesagent_brain_config')) {
            Capsule::schema()->create('mod_hermesagent_brain_config', function ($table) {
                $table->increments('id');
                $table->string('display_name', 100);
                $table->string('provider_type', 20)->default('proxy');
                $table->string('base_url', 255);
                $table->string('model_name', 100);
                $table->text('api_key')->nullable();
                $table->tinyInteger('is_active')->default(0);
                $table->timestamps();
            });
            // Seed default entry
            Capsule::table('mod_hermesagent_brain_config')->insert([
                'display_name'  => 'SNBD Proxy (ZAI GLM-5)',
                'provider_type' => 'proxy',
                'base_url'      => 'https://ai-proxy.snbdhost.com/v1',
                'model_name'    => 'zai.glm-5',
                'api_key'       => 'sk-snbdhost-master-key-2026',
                'is_active'     => 1,
                'created_at'    => date('Y-m-d H:i:s'),
                'updated_at'    => date('Y-m-d H:i:s'),
            ]);
        }

        // Add current_model column to instances table if missing
        if (Capsule::schema()->hasTable('mod_hermesagent_instances')) {
            if (!Capsule::schema()->hasColumn('mod_hermesagent_instances', 'current_model')) {
                Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                    $table->string('current_model', 100)->nullable()->after('status');
                });
            }
        }

        return [
            'status' => 'success',
            'description' => 'Hermes Agent Manager activated and database tables configured successfully.'
        ];
    } catch (\Exception $e) {
        return [
            'status' => 'error',
            'description' => 'Activation failed: ' . $e->getMessage()
        ];
    }
}

/**
 * Deactivate the addon module.
 */
function hermesagent_deactivate() {
    return [
        'status' => 'success',
        'description' => 'Hermes Agent Manager deactivated.'
    ];
}

/**
 * Get the currently active brain config. Falls back to SNBD proxy defaults.
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
 * Open an SSH connection using phpseclib, given a WHMCS tblservers record.
 */
function hermesagent_addon_ssh_connect($server, $timeout = 60) {
    $host     = $server->ipaddress ?: $server->hostname;
    $port     = intval($server->port) ?: 22;
    $username = $server->username;
    $password = function_exists('decrypt') ? decrypt($server->password) : $server->password;
    $accesshash = trim($server->accesshash ?? '');

    if (class_exists('\phpseclib3\Net\SSH2')) {
        $ssh = new \phpseclib3\Net\SSH2($host, $port);
        $ssh->setTimeout($timeout);
        if (!empty($accesshash)) {
            try {
                $key = \phpseclib3\Crypt\PublicKeyLoader::load($accesshash, $password ?: false);
                if ($ssh->login($username, $key)) return $ssh;
            } catch (\Exception $e) {}
        }
        if ($ssh->login($username, $password)) return $ssh;
        throw new \Exception("SSH connection failed (phpseclib3) to $host");
    }
    if (class_exists('\phpseclib\Net\SSH2')) {
        $ssh = new \phpseclib\Net\SSH2($host, $port);
        $ssh->setTimeout($timeout);
        if (!empty($accesshash) && class_exists('\phpseclib\Crypt\RSA')) {
            $key = new \phpseclib\Crypt\RSA();
            if (!empty($password)) $key->setPassword($password);
            if ($key->loadKey($accesshash) && $ssh->login($username, $key)) return $ssh;
        }
        if ($ssh->login($username, $password)) return $ssh;
        throw new \Exception("SSH connection failed (phpseclib2) to $host");
    }
    throw new \Exception("phpseclib not available");
}

/**
 * Helper to check and insert custom field for product.
 */
function hermesagent_addon_create_custom_field($productId, $name, $type, $desc, $showOrder = true, $required = true) {
    $field = Capsule::table('tblcustomfields')
        ->where('type', 'product')
        ->where('relid', $productId)
        ->where('fieldname', $name)
        ->first();
        
    if (!$field) {
        Capsule::table('tblcustomfields')->insert([
            'type' => 'product',
            'relid' => $productId,
            'fieldname' => $name,
            'fieldtype' => $type,
            'description' => $desc,
            'fieldoptions' => '',
            'regexpr' => '',
            'adminonly' => '',
            'required' => $required ? 'on' : '',
            'showorder' => $showOrder ? 'on' : '',
            'showinvoice' => '',
            'sortorder' => 0
        ]);
    } else {
        Capsule::table('tblcustomfields')
            ->where('id', $field->id)
            ->update([
                'required' => $required ? 'on' : ''
            ]);
    }
}

/**
 * Helper to setup Configurable Option Group, Options, Subs, and default pricing.
 */
function hermesagent_addon_setup_config_options($productId) {
    $groupName = "Hermes Agent Options (Product #" . $productId . ")";
    
    // 1. Create or fetch group
    $groupId = Capsule::table('tblproductconfiggroups')
        ->where('name', $groupName)
        ->value('id');
        
    if (!$groupId) {
        $groupId = Capsule::table('tblproductconfiggroups')->insertGetId([
            'name' => $groupName,
            'description' => 'Auto-generated configurable options for Hermes Agent provisioning',
        ]);
    }
    
    // Link group to product
    $linkExists = Capsule::table('tblproductconfiglinks')
        ->where('gid', $groupId)
        ->where('pid', $productId)
        ->exists();
    if (!$linkExists) {
        Capsule::table('tblproductconfiglinks')->insert([
            'gid' => $groupId,
            'pid' => $productId
        ]);
    }
    
    // Fetch OpenRouter Models dynamically
    $openRouterModels = [];
    
    $modelSubs = [
        'mistral.voxtral-mini-3b-2507|Mistral Voxtral Mini 3B (Free)',
        'claude-haiku|Claude 3.5 Haiku (LiteLLM Free Tier)',
        'llama-3-8b|Llama 3.2 8B (LiteLLM Free Tier)',
        'mistral-7b|Mistral 7B (LiteLLM Free Tier)',
        'claude-sonnet|Claude 3.5 Sonnet (LiteLLM — Paid)'
    ];


    // 2. Define Options
    $options = [
        [
            'name' => 'LLM Provider',
            'type' => 1, // Dropdown
            'subs' => [
                'free-tier|SNBD API (NO API NEEDED)'
            ]
        ],
        [
            'name' => 'Resource Tier',
            'type' => 1, // Dropdown
            'subs' => [
                'Starter (1 vCPU / 1GB)|Starter (1 vCPU / 1GB)',
                'Standard (2 vCPU / 2GB)|Standard (2 vCPU / 2GB)',
                'Pro (4 vCPU / 4GB)|Pro (4 vCPU / 4GB)'
            ]
        ],
        [
            'name' => 'Enable OpenAI-Compatible API',
            'type' => 1, // Dropdown
            'subs' => [
                'no|No',
                'yes|Yes'
            ]
        ],
        [
            'name' => 'Model',
            'type' => 1, // Dropdown
            'subs' => $modelSubs
        ],
        [
            'name' => 'Messaging Platform',
            'type' => 1, // Dropdown
            'subs' => [
                'None|None',
                'Telegram|Telegram',
                'Discord|Discord',
                'Slack|Slack'
            ]
        ]
    ];
    
    $currencies = Capsule::table('tblcurrencies')->pluck('id');
    
    foreach ($options as $opt) {
        $optionId = Capsule::table('tblproductconfigoptions')
            ->where('gid', $groupId)
            ->where('optionname', 'like', $opt['name'] . '%')
            ->value('id');
            
        if (!$optionId) {
            $optionId = Capsule::table('tblproductconfigoptions')->insertGetId([
                'gid' => $groupId,
                'optionname' => $opt['name'],
                'optiontype' => $opt['type'],
                'qtyminimum' => 0,
                'qtymaximum' => 0,
                'order' => 0
            ]);
        }
        
        // Add Sub options (dropdown items) and pricing
        foreach ($opt['subs'] as $subName) {
            $subId = Capsule::table('tblproductconfigoptionssub')
                ->where('configid', $optionId)
                ->where('optionname', 'like', $subName . '%')
                ->value('id');
                
            if (!$subId) {
                $subId = Capsule::table('tblproductconfigoptionssub')->insertGetId([
                    'configid' => $optionId,
                    'optionname' => $subName,
                    'sortorder' => 0,
                    'hidden' => 0
                ]);
            }
            
            // Create $0.00 pricing records for each currency
            foreach ($currencies as $currId) {
                $priceExists = Capsule::table('tblpricing')
                    ->where('type', 'configoptions')
                    ->where('currency', $currId)
                    ->where('relid', $subId)
                    ->exists();
                if (!$priceExists) {
                    Capsule::table('tblpricing')->insert([
                        'type' => 'configoptions',
                        'currency' => $currId,
                        'relid' => $subId,
                        'msetupfee' => 0, 'qsetupfee' => 0, 'ssetupfee' => 0, 'asetupfee' => 0, 'bsetupfee' => 0, 'tsetupfee' => 0,
                        'monthly' => 0, 'quarterly' => 0, 'semiannually' => 0, 'annually' => 0, 'biennially' => 0, 'triennially' => 0
                    ]);
                }
            }
        }
    }
}

/**
 * Output admin UI for the addon module.
 */
function hermesagent_output($vars) {
    // Automatically fix 'required' flag for optional fields across all products
    try {
        Capsule::table('tblcustomfields')
            ->where('type', 'product')
            ->whereIn('fieldname', ['Bot Token', 'Custom Endpoint URL'])
            ->update(['required' => '']);
    } catch (\Exception $e) {
        // ignore
    }

    // 0. Ensure brain_config table exists (safe to run on every page load)
    try {
        if (!Capsule::schema()->hasTable('mod_hermesagent_brain_config')) {
            Capsule::schema()->create('mod_hermesagent_brain_config', function ($table) {
                $table->increments('id');
                $table->string('display_name', 100);
                $table->string('provider_type', 20)->default('proxy');
                $table->string('base_url', 255);
                $table->string('model_name', 100);
                $table->text('api_key')->nullable();
                $table->tinyInteger('is_active')->default(0);
                $table->timestamps();
            });
            Capsule::table('mod_hermesagent_brain_config')->insert([
                'display_name'  => 'SNBD Proxy (ZAI GLM-5)',
                'provider_type' => 'proxy',
                'base_url'      => 'https://ai-proxy.snbdhost.com/v1',
                'model_name'    => 'zai.glm-5',
                'api_key'       => 'sk-snbdhost-master-key-2026',
                'is_active'     => 1,
                'created_at'    => date('Y-m-d H:i:s'),
                'updated_at'    => date('Y-m-d H:i:s'),
            ]);
        }
        if (Capsule::schema()->hasTable('mod_hermesagent_instances') &&
            !Capsule::schema()->hasColumn('mod_hermesagent_instances', 'current_model')) {
            Capsule::schema()->table('mod_hermesagent_instances', function ($table) {
                $table->string('current_model', 100)->nullable()->after('status');
            });
        }
    } catch (\Exception $e) { /* already exists */ }

    // 0a. Handle brain POST actions
    $brainMessage = '';
    
    // Handle provision with defaults
    if (isset($_POST['provision_default'])) {
        $svcId = intval($_POST['provision_service_id']);
        if ($svcId > 0) {
            try {
                Capsule::table('mod_hermesagent_onboarding')
                    ->where('serviceid', $svcId)
                    ->update(['status' => 'skipped', 'completed_at' => date('Y-m-d H:i:s')]);
                
                $command = 'ModuleCreate';
                $postData = array(
                    'accountid' => $svcId,
                );
                $results = localAPI($command, $postData);
                
                if ($results['result'] === 'success') {
                    $message = '<div class="alert alert-success" style="padding:15px; border-radius:8px; margin-bottom:20px; font-weight:600;"><i class="fas fa-check-circle"></i> Service #' . $svcId . ' has been provisioned with default settings.</div>';
                } else {
                    $message = '<div class="alert alert-danger" style="padding:15px; border-radius:8px; margin-bottom:20px; font-weight:600;"><i class="fas fa-exclamation-triangle"></i> Failed to provision service #' . $svcId . ': ' . ($results['message'] ?? 'Unknown error') . '</div>';
                }
            } catch (\Exception $e) {
                $message = '<div class="alert alert-danger" style="padding:15px; border-radius:8px; margin-bottom:20px; font-weight:600;"><i class="fas fa-exclamation-triangle"></i> Failed to provision service #' . $svcId . ': ' . $e->getMessage() . '</div>';
            }
        }
    }
    if (isset($_POST['add_brain'])) {
        $bName     = htmlspecialchars(trim($_POST['brain_display_name'] ?? ''), ENT_QUOTES, 'UTF-8');
        $bType     = in_array($_POST['brain_provider_type'] ?? '', ['proxy','bedrock','openai','custom'])
                     ? $_POST['brain_provider_type'] : 'proxy';
        $bUrl      = trim($_POST['brain_base_url'] ?? '');
        $bModel    = trim($_POST['brain_model_name'] ?? '');
        $bKey      = trim($_POST['brain_api_key'] ?? '');
        $bSetActive = !empty($_POST['brain_set_active']);
        if ($bName && $bUrl && $bModel) {
            if ($bSetActive) {
                Capsule::table('mod_hermesagent_brain_config')->update(['is_active' => 0]);
            }
            Capsule::table('mod_hermesagent_brain_config')->insert([
                'display_name'  => $bName,
                'provider_type' => $bType,
                'base_url'      => $bUrl,
                'model_name'    => $bModel,
                'api_key'       => $bKey,
                'is_active'     => $bSetActive ? 1 : 0,
                'created_at'    => date('Y-m-d H:i:s'),
                'updated_at'    => date('Y-m-d H:i:s'),
            ]);
            $brainMessage = '<div class="alert alert-success" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;"><i class="fas fa-check-circle"></i> Brain endpoint "<strong>' . $bName . '</strong>" added.</div>';
        } else {
            $brainMessage = '<div class="alert alert-danger" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;"><i class="fas fa-exclamation-triangle"></i> Please fill in Name, Base URL, and Model.</div>';
        }
    } elseif (isset($_POST['set_active_brain'])) {
        $bId = intval($_POST['brain_id']);
        if ($bId > 0) {
            Capsule::table('mod_hermesagent_brain_config')->update(['is_active' => 0, 'updated_at' => date('Y-m-d H:i:s')]);
            Capsule::table('mod_hermesagent_brain_config')->where('id', $bId)->update(['is_active' => 1, 'updated_at' => date('Y-m-d H:i:s')]);
            $b = Capsule::table('mod_hermesagent_brain_config')->where('id', $bId)->first();
            $brainMessage = '<div class="alert alert-success" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;"><i class="fas fa-brain"></i> Active brain set to <strong>' . htmlspecialchars($b->display_name ?? '') . '</strong> · <code>' . htmlspecialchars($b->model_name ?? '') . '</code>. Push to containers to apply.</div>';
        }
    } elseif (isset($_POST['delete_brain'])) {
        $bId = intval($_POST['brain_id']);
        $bRow = $bId > 0 ? Capsule::table('mod_hermesagent_brain_config')->where('id', $bId)->first() : null;
        if ($bRow && !$bRow->is_active) {
            Capsule::table('mod_hermesagent_brain_config')->where('id', $bId)->delete();
            $brainMessage = '<div class="alert alert-warning" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;"><i class="fas fa-trash"></i> Brain endpoint deleted.</div>';
        } elseif ($bRow && $bRow->is_active) {
            $brainMessage = '<div class="alert alert-danger" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;"><i class="fas fa-ban"></i> Cannot delete the active brain. Set another as active first.</div>';
        }
    } elseif (isset($_POST['push_brain'])) {
        $activeBrainRow = hermesagent_get_active_brain();
        $pushBaseUrl    = rtrim($activeBrainRow['base_url'], '/');
        $pushApiKey     = $activeBrainRow['api_key'] ?? '';
        $pushModel      = $activeBrainRow['model_name'] ?? '';
        $escapedUrl     = addslashes($pushBaseUrl);
        $escapedKey     = addslashes($pushApiKey);
        $escapedModel   = addslashes($pushModel);

        $instances = Capsule::table('mod_hermesagent_instances')
            ->join('tblhosting', 'mod_hermesagent_instances.serviceid', '=', 'tblhosting.id')
            ->where('mod_hermesagent_instances.status', 'Active')
            ->select('mod_hermesagent_instances.serviceid', 'tblhosting.server as serverid')
            ->get();

        $pushResults = ['updated' => [], 'failed' => []];

        // Group by server — typically all instances share one VPS
        $byServer = [];
        foreach ($instances as $inst) {
            $byServer[$inst->serverid][] = $inst->serviceid;
        }

        foreach ($byServer as $serverid => $serviceids) {
            $serverRecord = Capsule::table('tblservers')->where('id', $serverid)->first();
            if (!$serverRecord) {
                foreach ($serviceids as $sid) $pushResults['failed'][] = $sid;
                continue;
            }
            try {
                $ssh = hermesagent_addon_ssh_connect($serverRecord, 90);
                $cmds = '';
                foreach ($serviceids as $sid) {
                    $dataDir = "/srv/hermes/{$sid}/data";
                    $cmds .= "python3 - << 'PYEOF_PUSH'\n";
                    $cmds .= "import yaml, sys\n";
                    $cmds .= "p = '{$dataDir}/config.yaml'\n";
                    $cmds .= "try:\n";
                    $cmds .= "    with open(p) as f: cfg = yaml.safe_load(f) or {}\n";
                    $cmds .= "except: cfg = {}\n";
                    $cmds .= "if not isinstance(cfg.get('model'), dict): cfg['model'] = {}\n";
                    $cmds .= "cfg['model']['base_url'] = '{$escapedUrl}'\n";
                    $cmds .= "cfg['model']['api_key']  = '{$escapedKey}'\n";
                    $cmds .= "cfg['model']['provider'] = 'custom'\n";
                    $cmds .= "cfg['model']['default']  = '{$escapedModel}'\n";
                    $cmds .= "with open(p, 'w') as f: yaml.dump(cfg, f, default_flow_style=False, allow_unicode=True)\n";
                    $cmds .= "PYEOF_PUSH\n";
                    $cmds .= "docker restart hermes-{$sid} >/dev/null 2>&1 && echo 'PUSHED_{$sid}' || echo 'PUSH_FAILED_{$sid}'\n";
                }
                $output = $ssh->exec($cmds);
                foreach ($serviceids as $sid) {
                    if (strpos($output, "PUSHED_{$sid}") !== false) {
                        $pushResults['updated'][] = $sid;
                        Capsule::table('mod_hermesagent_instances')->where('serviceid', $sid)
                            ->update(['current_model' => $pushModel, 'updated_at' => date('Y-m-d H:i:s')]);
                    } else {
                        $pushResults['failed'][] = $sid;
                    }
                }
            } catch (\Exception $e) {
                foreach ($serviceids as $sid) $pushResults['failed'][] = $sid;
                logModuleCall('hermesagent_addon', 'PushBrain_SSH_Failed', $serverid, $e->getMessage());
            }
        }

        $nUp = count($pushResults['updated']);
        $nFail = count($pushResults['failed']);
        $brainMessage = '<div class="alert alert-' . ($nFail === 0 ? 'success' : 'warning') . '" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;">'
            . '<i class="fas fa-broadcast-tower"></i> Push complete: <strong>' . $nUp . ' updated</strong>'
            . ($nFail > 0 ? ', <strong>' . $nFail . ' failed</strong> (#' . implode(', #', $pushResults['failed']) . ')' : '')
            . '. Model: <code>' . htmlspecialchars($pushModel) . '</code></div>';
    } elseif (isset($_POST['fix_terminal_backend'])) {
        // One-off remediation: older CreateAccount runs booted containers with
        // terminal.backend: docker (no Docker socket available inside the
        // customer container, so every terminal() tool call fails). This
        // forces every active instance's config.yaml to backend: local and
        // restarts the container so the fix actually takes effect.
        $instances = Capsule::table('mod_hermesagent_instances')
            ->join('tblhosting', 'mod_hermesagent_instances.serviceid', '=', 'tblhosting.id')
            ->where('mod_hermesagent_instances.status', 'Active')
            ->select('mod_hermesagent_instances.serviceid', 'tblhosting.server as serverid')
            ->get();

        $fixResults = ['updated' => [], 'failed' => []];

        $byServer = [];
        foreach ($instances as $inst) {
            $byServer[$inst->serverid][] = $inst->serviceid;
        }

        foreach ($byServer as $serverid => $serviceids) {
            $serverRecord = Capsule::table('tblservers')->where('id', $serverid)->first();
            if (!$serverRecord) {
                foreach ($serviceids as $sid) $fixResults['failed'][] = $sid;
                continue;
            }
            try {
                $ssh = hermesagent_addon_ssh_connect($serverRecord, 90);
                $cmds = '';
                foreach ($serviceids as $sid) {
                    $dataDir = "/srv/hermes/{$sid}/data";
                    $cmds .= "python3 - << 'PYEOF_FIXTERM'\n";
                    $cmds .= "import yaml\n";
                    $cmds .= "p = '{$dataDir}/config.yaml'\n";
                    $cmds .= "try:\n";
                    $cmds .= "    with open(p) as f: cfg = yaml.safe_load(f) or {}\n";
                    $cmds .= "except: cfg = {}\n";
                    $cmds .= "cfg['terminal'] = {'backend': 'local', 'timeout': 180, 'cwd': '/opt/data'}\n";
                    $cmds .= "with open(p, 'w') as f: yaml.dump(cfg, f, default_flow_style=False, allow_unicode=True)\n";
                    $cmds .= "PYEOF_FIXTERM\n";
                    $cmds .= "docker restart hermes-{$sid} >/dev/null 2>&1 && echo 'FIXED_{$sid}' || echo 'FIX_FAILED_{$sid}'\n";
                }
                $output = $ssh->exec($cmds);
                foreach ($serviceids as $sid) {
                    if (strpos($output, "FIXED_{$sid}") !== false) {
                        $fixResults['updated'][] = $sid;
                    } else {
                        $fixResults['failed'][] = $sid;
                    }
                }
            } catch (\Exception $e) {
                foreach ($serviceids as $sid) $fixResults['failed'][] = $sid;
                logModuleCall('hermesagent_addon', 'FixTerminalBackend_SSH_Failed', $serverid, $e->getMessage());
            }
        }

        $nUp = count($fixResults['updated']);
        $nFail = count($fixResults['failed']);
        $brainMessage = '<div class="alert alert-' . ($nFail === 0 ? 'success' : 'warning') . '" style="padding:12px 16px;border-radius:6px;margin-bottom:15px;font-weight:600;">'
            . '<i class="fas fa-terminal"></i> Terminal backend fix complete: <strong>' . $nUp . ' fixed</strong>'
            . ($nFail > 0 ? ', <strong>' . $nFail . ' failed</strong> (#' . implode(', #', $fixResults['failed']) . ')' : '')
            . '.</div>';
    }

    // 0. Ensure quiz leads table exists (safe to run on every page load)
    try {
        if (!Capsule::schema()->hasTable('mod_hermesagent_quiz_leads')) {
            Capsule::schema()->create('mod_hermesagent_quiz_leads', function ($table) {
                $table->increments('id');
                $table->string('name', 120)->default('');
                $table->string('email', 200);
                $table->string('whatsapp', 30)->default('');
                $table->string('profile', 30)->default('');
                $table->text('answers')->nullable();
                $table->string('status', 20)->default('new');
                $table->text('notes')->nullable();
                $table->timestamps();
            });
        }
    } catch (\Exception $e) { /* already exists or harmless */ }

    // 0b. Handle quiz lead status update
    $leadMessage = '';
    if (isset($_POST['update_lead_status'])) {
        $leadId     = intval($_POST['lead_id']);
        $leadStatus = in_array($_POST['lead_status'], ['new','contacted','converted','rejected'])
                      ? $_POST['lead_status'] : 'new';
        $leadNotes  = htmlspecialchars($_POST['lead_notes'] ?? '', ENT_QUOTES, 'UTF-8');
        if ($leadId > 0) {
            Capsule::table('mod_hermesagent_quiz_leads')
                ->where('id', $leadId)
                ->update(['status' => $leadStatus, 'notes' => $leadNotes, 'updated_at' => now()]);
            $leadMessage = '<div class="alert alert-success" style="padding:12px 16px;border-radius:6px;margin-bottom:20px;font-weight:600;"><i class="fas fa-check-circle"></i> Lead #' . $leadId . ' updated.</div>';
        }
    }

    // 1. Handle One-Click config submit
    $message = '';
    if (isset($_POST['configure_product'])) {
        $pid = intval($_POST['product_id']);
        if ($pid > 0) {
            try {
                // Add Custom fields
                hermesagent_addon_create_custom_field($pid, 'Dashboard Username', 'text', 'Login username for the Hermes web dashboard / Desktop Remote Gateway.', true, true);
                
                // Add Config options
                hermesagent_addon_setup_config_options($pid);
                
                $message = '<div class="alert alert-success" style="padding:15px; border-radius:8px; margin-bottom:20px; font-weight:600;"><i class="fas fa-check-circle"></i> Success! Product #' . $pid . ' has been fully configured with Hermes Agent options and custom fields. Customers will now see these options during checkout.</div>';
            } catch (\Exception $e) {
                $message = '<div class="alert alert-danger" style="padding:15px; border-radius:8px; margin-bottom:20px; font-weight:600;"><i class="fas fa-exclamation-triangle"></i> Failed: ' . $e->getMessage() . '</div>';
            }
        }
    }

    // 2. Fetch list of products configured with our module
    $products = Capsule::table('tblproducts')
        ->where('servertype', 'hermesagent')
        ->select('id', 'name', 'type')
        ->get();

    // 2b. Fetch brain endpoints
    $brains = [];
    $activeBrain = null;
    try {
        $brains = Capsule::table('mod_hermesagent_brain_config')->orderBy('is_active', 'desc')->orderBy('id')->get();
        foreach ($brains as $b) { if ($b->is_active) { $activeBrain = $b; break; } }
    } catch (\Exception $e) { /* table not yet created */ }

    // 2c. Fetch per-service token usage from LiteLLM (parallel curl_multi)
    $usageMap = [];
    try {
        $brain = hermesagent_get_active_brain();
        $litellmApiUrl = rtrim(preg_replace('|/v1/?$|', '', rtrim($brain['base_url'], '/')), '/');
        $masterKey = $brain['api_key'] ?? 'sk-snbdhost-master-key-2026';
        $keyed = Capsule::table('mod_hermesagent_instances')
            ->whereNotNull('litellm_key_value')
            ->where('litellm_key_value', '!=', '')
            ->select('serviceid', 'litellm_key_value')
            ->get();
        if ($keyed->count() > 0) {
            $mh = curl_multi_init();
            $handles = [];
            foreach ($keyed as $row) {
                $ch = curl_init($litellmApiUrl . '/key/info?key=' . urlencode($row->litellm_key_value));
                curl_setopt_array($ch, [
                    CURLOPT_HTTPHEADER     => ['Authorization: Bearer ' . $masterKey],
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_TIMEOUT        => 6,
                    CURLOPT_CONNECTTIMEOUT => 3,
                    CURLOPT_IPRESOLVE      => CURL_IPRESOLVE_V4,
                ]);
                curl_multi_add_handle($mh, $ch);
                $handles[(int)$row->serviceid] = $ch;
            }
            do {
                $status = curl_multi_exec($mh, $running);
                if ($running) curl_multi_select($mh, 0.5);
            } while ($running && $status === CURLM_OK);
            $needsLogsFallback = [];
            foreach ($handles as $sid => $ch) {
                $resp = curl_multi_getcontent($ch);
                $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                curl_multi_remove_handle($mh, $ch);
                curl_close($ch);
                if ($code === 200 && $resp) {
                    $d = json_decode($resp, true);
                    if ($d && isset($d['info'])) {
                        $info = $d['info'];
                        $pt = (int)($info['prompt_tokens'] ?? 0);
                        $ct = (int)($info['completion_tokens'] ?? 0);
                        $tt = (int)($info['total_tokens'] ?? ($pt + $ct));
                        $usageMap[$sid] = [
                            'total_tokens'      => $tt ?: ($pt + $ct),
                            'prompt_tokens'     => $pt,
                            'completion_tokens' => $ct,
                            'spend'             => (float)($info['spend'] ?? 0),
                        ];
                    }
                }
                // /key/info is budget/spend metadata on most LiteLLM versions and often
                // doesn't carry per-key token counts — fall back to /spend/logs for any
                // key that came back with nothing.
                if (empty($usageMap[$sid]) || (!$usageMap[$sid]['total_tokens'] && !$usageMap[$sid]['spend'])) {
                    $needsLogsFallback[$sid] = true;
                }
            }
            curl_multi_close($mh);

            if (!empty($needsLogsFallback)) {
                $keyBySid = [];
                foreach ($keyed as $row) {
                    if (isset($needsLogsFallback[(int)$row->serviceid])) {
                        $keyBySid[(int)$row->serviceid] = $row->litellm_key_value;
                    }
                }
                $mh2 = curl_multi_init();
                $handles2 = [];
                foreach ($keyBySid as $sid => $keyVal) {
                    $ch = curl_init($litellmApiUrl . '/spend/logs?api_key=' . urlencode($keyVal));
                    curl_setopt_array($ch, [
                        CURLOPT_HTTPHEADER     => ['Authorization: Bearer ' . $masterKey],
                        CURLOPT_RETURNTRANSFER => true,
                        CURLOPT_TIMEOUT        => 6,
                        CURLOPT_CONNECTTIMEOUT => 3,
                        CURLOPT_IPRESOLVE      => CURL_IPRESOLVE_V4,
                    ]);
                    curl_multi_add_handle($mh2, $ch);
                    $handles2[$sid] = $ch;
                }
                do {
                    $status2 = curl_multi_exec($mh2, $running2);
                    if ($running2) curl_multi_select($mh2, 0.5);
                } while ($running2 && $status2 === CURLM_OK);
                foreach ($handles2 as $sid => $ch) {
                    $resp = curl_multi_getcontent($ch);
                    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
                    curl_multi_remove_handle($mh2, $ch);
                    curl_close($ch);
                    if ($code === 200 && $resp) {
                        $logs = json_decode($resp, true);
                        if (is_array($logs)) {
                            $pt = 0; $ct = 0; $spend = 0.0;
                            foreach ($logs as $entry) {
                                $pt    += (int)($entry['prompt_tokens'] ?? 0);
                                $ct    += (int)($entry['completion_tokens'] ?? 0);
                                $spend += (float)($entry['spend'] ?? 0);
                            }
                            if ($pt || $ct || $spend) {
                                $usageMap[$sid] = [
                                    'total_tokens'      => $pt + $ct,
                                    'prompt_tokens'     => $pt,
                                    'completion_tokens' => $ct,
                                    'spend'             => $spend,
                                ];
                            }
                        }
                    }
                }
                curl_multi_close($mh2);
            }
        }
    } catch (\Exception $e) { /* LiteLLM unreachable — skip */ }

    // 3. Fetch deployed instances
    $deployments = Capsule::table('mod_hermesagent_instances')
        ->join('tblhosting', 'mod_hermesagent_instances.serviceid', '=', 'tblhosting.id')
        ->join('tblclients', 'tblhosting.userid', '=', 'tblclients.id')
        ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
        ->join('tblservers', 'tblhosting.server', '=', 'tblservers.id')
        ->select(
            'mod_hermesagent_instances.*',
            'tblhosting.domain',
            'tblhosting.id as hosting_id',
            'tblclients.firstname',
            'tblclients.lastname',
            'tblclients.companyname',
            'tblproducts.name as product_name',
            'tblservers.ipaddress as server_ip',
            'tblservers.hostname as server_hostname',
            'tblservers.secure as server_secure'
        )
        ->get();

    // 3a. Fetch pending onboarding
    $pendingOnboarding = [];
    try {
        $pendingOnboarding = Capsule::table('mod_hermesagent_onboarding')
            ->join('tblhosting', 'mod_hermesagent_onboarding.serviceid', '=', 'tblhosting.id')
            ->join('tblclients', 'tblhosting.userid', '=', 'tblclients.id')
            ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
            ->where('mod_hermesagent_onboarding.status', 'pending')
            ->select(
                'mod_hermesagent_onboarding.*',
                'tblclients.firstname',
                'tblclients.lastname',
                'tblclients.companyname',
                'tblproducts.name as product_name'
            )
            ->get();
    } catch (\Exception $e) { /* table might not exist yet */ }

    // 3b. Fetch quiz leads
    $leads = [];
    $leadsTotal = $leadsNew = $leadsContacted = $leadsConverted = 0;
    try {
        $leads = Capsule::table('mod_hermesagent_quiz_leads')
            ->orderBy('created_at', 'desc')
            ->get();
        foreach ($leads as $l) {
            $leadsTotal++;
            if ($l->status === 'new')       $leadsNew++;
            elseif ($l->status === 'contacted')  $leadsContacted++;
            elseif ($l->status === 'converted')  $leadsConverted++;
        }
    } catch (\Exception $e) { /* table may not exist yet */ }

    // 4. Calculate Stats
    $total = count($deployments);
    $active = 0;
    $suspended = 0;
    $error = 0;
    foreach ($deployments as $d) {
        if ($d->status === 'Active') $active++;
        elseif ($d->status === 'Suspended') $suspended++;
        else $error++;
    }

    // Render interface with beautiful custom dark-mode styled cards
    echo $message;
    echo $brainMessage;
    ?>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .ha-wrapper {
            font-family: 'Outfit', sans-serif;
            color: #333;
            margin-top: 15px;
        }
        .ha-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #ddd;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        .ha-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            color: #2b3e50;
        }
        .ha-subtitle {
            font-size: 13px;
            color: #666;
            margin: 3px 0 0 0;
        }
        .ha-stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 30px;
        }
        .ha-stat-card {
            background: #fff;
            border: 1px solid #e3e6f0;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.03);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .ha-stat-info h5 {
            margin: 0 0 5px 0;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #858796;
        }
        .ha-stat-info h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
            color: #2e3d49;
        }
        .ha-stat-icon {
            font-size: 32px;
            color: #dddfeb;
        }
        .stat-blue { border-left: 4px solid #4e73df; }
        .stat-green { border-left: 4px solid #1cc88a; }
        .stat-yellow { border-left: 4px solid #f6c23e; }
        .stat-red { border-left: 4px solid #e74a3b; }
        
        .ha-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 25px;
        }
        @media (max-width: 992px) {
            .ha-grid { grid-template-columns: 1fr; }
        }
        .ha-panel {
            background: #fff;
            border: 1px solid #e3e6f0;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.03);
            margin-bottom: 25px;
        }
        .ha-panel-header {
            padding: 15px 20px;
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .ha-panel-title {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: #4e73df;
        }
        .ha-panel-body {
            padding: 20px;
        }
        .btn-ha-primary {
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            border: none;
            color: #fff;
            padding: 10px 20px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-ha-primary:hover {
            opacity: 0.9;
            color: #fff;
        }
        .table-ha {
            width: 100%;
            border-collapse: collapse;
        }
        .table-ha th {
            background: #f8f9fc;
            border-bottom: 2px solid #e3e6f0;
            padding: 12px;
            font-size: 13px;
            font-weight: 600;
            text-align: left;
            color: #4e73df;
        }
        .table-ha td {
            border-bottom: 1px solid #e3e6f0;
            padding: 12px;
            font-size: 13.5px;
        }
        .ha-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .badge-active { background: #d4edda; color: #155724; }
        .badge-suspended { background: #fff3cd; color: #856404; }
        .badge-error { background: #f8d7da; color: #721c24; }
        .badge-pending { background: #e2e3e5; color: #383d41; }
    </style>

    <div class="ha-wrapper">
        <div class="ha-header">
            <div>
                <h2 class="ha-title">Hermes Agent Manager Dashboard</h2>
                <p class="ha-subtitle">Automate product configuration and monitor deployments</p>
            </div>
            <div>
                <span class="ha-badge badge-active" style="padding: 6px 12px; font-size:12px;">Hermes Module Active</span>
            </div>
        </div>

        <!-- Stat Widgets -->
        <div class="ha-stats-row">
            <div class="ha-stat-card stat-blue">
                <div class="ha-stat-info">
                    <h5>Total Agents</h5>
                    <h2><?php echo $total; ?></h2>
                </div>
                <div class="ha-stat-icon"><i class="fas fa-server"></i></div>
            </div>
            <div class="ha-stat-card stat-green">
                <div class="ha-stat-info">
                    <h5>Healthy / Active</h5>
                    <h2><?php echo $active; ?></h2>
                </div>
                <div class="ha-stat-icon"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="ha-stat-card stat-yellow">
                <div class="ha-stat-info">
                    <h5>Suspended</h5>
                    <h2><?php echo $suspended; ?></h2>
                </div>
                <div class="ha-stat-icon"><i class="fas fa-pause-circle"></i></div>
            </div>
            <div class="ha-stat-card stat-red">
                <div class="ha-stat-info">
                    <h5>Failed / Error</h5>
                    <h2><?php echo $error; ?></h2>
                </div>
                <div class="ha-stat-icon"><i class="fas fa-exclamation-triangle"></i></div>
            </div>
        </div>

        <!-- Brain Management Panel -->
        <div class="ha-panel" style="margin-bottom:25px;">
            <div class="ha-panel-header" style="background:#f0fff4;border-color:#c3e6cb;">
                <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
                    <h4 class="ha-panel-title" style="color:#155724;margin:0;"><i class="fas fa-brain"></i> Brain Management</h4>
                    <?php if ($activeBrain): ?>
                    <span class="ha-badge badge-active" style="padding:5px 12px;font-size:12px;">
                        Active: <?php echo htmlspecialchars($activeBrain->display_name); ?>
                        &nbsp;·&nbsp; <code style="background:rgba(0,0,0,0.1);padding:2px 5px;border-radius:3px;font-size:11px;"><?php echo htmlspecialchars($activeBrain->model_name); ?></code>
                    </span>
                    <?php endif; ?>
                </div>
                <div style="display:flex;gap:8px;align-items:center;">
                    <button type="button" onclick="document.getElementById('brain-add-form').style.display=document.getElementById('brain-add-form').style.display==='none'?'block':'none'" class="btn-ha-primary" style="padding:7px 14px;font-size:13px;">
                        <i class="fas fa-plus"></i> Add Endpoint
                    </button>
                    <form method="post" style="margin:0;" onsubmit="return confirm('Push active brain to ALL running containers and restart them?')">
                        <button type="submit" name="push_brain" style="background:linear-gradient(135deg,#f6c23e,#d4a017);border:none;color:#fff;padding:7px 14px;font-weight:600;border-radius:6px;cursor:pointer;font-size:13px;">
                            <i class="fas fa-broadcast-tower"></i> Push to All
                        </button>
                    </form>
                    <form method="post" style="margin:0;" onsubmit="return confirm('Force terminal.backend to local on ALL active containers and restart them? This fixes agents that cannot run terminal commands.')">
                        <button type="submit" name="fix_terminal_backend" style="background:linear-gradient(135deg,#2563eb,#1d4ed8);border:none;color:#fff;padding:7px 14px;font-weight:600;border-radius:6px;cursor:pointer;font-size:13px;">
                            <i class="fas fa-terminal"></i> Fix Terminal Backend (All)
                        </button>
                    </form>
                </div>
            </div>
            <div style="overflow-x:auto;">
                <?php if (count($brains) > 0): ?>
                <table class="table-ha">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Provider</th>
                            <th>Base URL</th>
                            <th>Model</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php foreach ($brains as $b): ?>
                        <tr style="<?php echo $b->is_active ? 'background:#f0fff4;' : ''; ?>">
                            <td><strong><?php echo htmlspecialchars($b->display_name); ?></strong></td>
                            <td><span style="font-size:12px;background:#e8f0fe;color:#2b5be8;padding:3px 8px;border-radius:4px;font-weight:600;"><?php echo ucfirst($b->provider_type); ?></span></td>
                            <td><code style="font-size:12px;color:#555;"><?php echo htmlspecialchars($b->base_url); ?></code></td>
                            <td><code style="font-size:12px;color:#2b5be8;"><?php echo htmlspecialchars($b->model_name); ?></code></td>
                            <td>
                                <?php if ($b->is_active): ?>
                                <span class="ha-badge badge-active"><i class="fas fa-check"></i> Active</span>
                                <?php else: ?>
                                <span class="ha-badge badge-pending">Inactive</span>
                                <?php endif; ?>
                            </td>
                            <td style="white-space:nowrap;">
                                <?php if (!$b->is_active): ?>
                                <form method="post" style="display:inline;margin-right:4px;">
                                    <input type="hidden" name="brain_id" value="<?php echo $b->id; ?>">
                                    <button type="submit" name="set_active_brain" class="btn-ha-primary" style="padding:5px 10px;font-size:12px;">
                                        <i class="fas fa-check-circle"></i> Set Active
                                    </button>
                                </form>
                                <form method="post" style="display:inline;" onsubmit="return confirm('Delete this endpoint?')">
                                    <input type="hidden" name="brain_id" value="<?php echo $b->id; ?>">
                                    <button type="submit" name="delete_brain" style="background:#e74a3b;border:none;color:#fff;padding:5px 10px;font-weight:600;border-radius:6px;cursor:pointer;font-size:12px;">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                                <?php else: ?>
                                <span style="font-size:12px;color:#888;">—</span>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
                <?php else: ?>
                <div style="padding:20px;text-align:center;color:#777;font-size:13px;">No brain endpoints configured yet.</div>
                <?php endif; ?>
            </div>
            <!-- Add Endpoint Form (hidden by default) -->
            <div id="brain-add-form" style="display:none;padding:20px;border-top:1px solid #c3e6cb;background:#f9fffe;">
                <form method="post">
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:15px;margin-bottom:15px;">
                        <div>
                            <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#666;display:block;margin-bottom:5px;">Display Name</label>
                            <input type="text" name="brain_display_name" class="form-control" placeholder="e.g. Mistral via ZAI" required style="height:38px;border-radius:6px;">
                        </div>
                        <div>
                            <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#666;display:block;margin-bottom:5px;">Provider Type</label>
                            <select name="brain_provider_type" class="form-control" style="height:38px;border-radius:6px;">
                                <option value="proxy">Proxy (LiteLLM / OpenAI-compatible)</option>
                                <option value="bedrock">Amazon Bedrock</option>
                                <option value="openai">OpenAI</option>
                                <option value="custom">Custom</option>
                            </select>
                        </div>
                        <div>
                            <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#666;display:block;margin-bottom:5px;">Base URL (with /v1)</label>
                            <input type="text" name="brain_base_url" class="form-control" placeholder="https://ai-proxy.snbdhost.com/v1" required style="height:38px;border-radius:6px;">
                        </div>
                        <div>
                            <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#666;display:block;margin-bottom:5px;">Model Name</label>
                            <input type="text" name="brain_model_name" class="form-control" placeholder="zai.glm-5" required style="height:38px;border-radius:6px;">
                        </div>
                        <div style="grid-column:1/-1;">
                            <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:#666;display:block;margin-bottom:5px;">API Key</label>
                            <input type="password" name="brain_api_key" class="form-control" placeholder="sk-..." style="height:38px;border-radius:6px;">
                        </div>
                    </div>
                    <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;">
                        <button type="submit" name="add_brain" class="btn-ha-primary">
                            <i class="fas fa-plus-circle"></i> Add Endpoint
                        </button>
                        <label style="font-size:13px;font-weight:600;cursor:pointer;margin:0;">
                            <input type="checkbox" name="brain_set_active" style="margin-right:5px;">
                            Set as active immediately
                        </label>
                        <button type="button" onclick="document.getElementById('brain-add-form').style.display='none'" style="background:none;border:1px solid #ccc;padding:7px 14px;border-radius:6px;cursor:pointer;font-size:13px;">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="ha-grid">
            <!-- Left Side: Product Configuration Auto-Setup -->
            <div class="ha-panel">
                <div class="ha-panel-header">
                    <h4 class="ha-panel-title">One-Click Product Setup</h4>
                </div>
                <div class="ha-panel-body">
                    <p style="font-size: 13.5px; color:#555; line-height: 1.5; margin-bottom:15px;">
                        Select a Hermes hosting product. This tool automatically configures the necessary **Custom Fields** and **Configurable Options** so customers can input their API keys, messaging platforms, and resource limits during checkout.
                    </p>
                    
                    <?php if (count($products) > 0): ?>
                        <form method="post" action="">
                            <div class="form-group" style="margin-bottom:15px;">
                                <label style="font-size:13px; font-weight:600; margin-bottom:5px; display:block;">Select Product:</label>
                                <select name="product_id" class="form-control" style="height:40px; border-radius:6px;">
                                    <?php foreach ($products as $p): ?>
                                        <option value="<?php echo $p->id; ?>"><?php echo htmlspecialchars($p->name); ?> (ID: <?php echo $p->id; ?>)</option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <button type="submit" name="configure_product" class="btn-ha-primary" style="width:100%;">
                                <i class="fas fa-cog"></i> Run Setup Configuration
                            </button>
                        </form>
                    <?php else: ?>
                        <div class="alert alert-warning" style="font-size:13px; padding:10px; border-radius:6px; margin:0;">
                            <i class="fas fa-info-circle"></i> No products found using the <strong>hermesagent</strong> server module. Create a product first!
                        </div>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Right Side: Active Deployments List -->
            <div class="ha-panel">
                <div class="ha-panel-header">
                    <h4 class="ha-panel-title">Active client Deployments</h4>
                </div>
                <div class="ha-panel-body" style="padding:0; overflow-x:auto;">
                    <?php if (count($deployments) > 0): ?>
                        <table class="table-ha">
                            <thead>
                                <tr>
                                    <th>Service ID</th>
                                    <th>Client</th>
                                    <th>Product</th>
                                    <th>VPS Server IP</th>
                                    <th>Dashboard URL</th>
                                    <th>Brain</th>
                                    <th>Tokens Used</th>
                                    <th>Spend</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($deployments as $d): ?>
                                    <?php
                                    $clientName = htmlspecialchars($d->firstname . ' ' . $d->lastname);
                                    if ($d->companyname) {
                                        $clientName .= ' (' . htmlspecialchars($d->companyname) . ')';
                                    }
                                    
                                    // Resolve dashboard URL
                                    $dashUrl = '';
                                    if ($d->server_secure) {
                                        $dashUrl = "https://{$d->serviceid}.hermes.deltadns.xyz";
                                    } else {
                                        $dashUrl = "http://{$d->server_ip}:{$d->dash_port}";
                                    }
                                    
                                    $statusClass = 'badge-pending';
                                    if ($d->status === 'Active') $statusClass = 'badge-active';
                                    elseif ($d->status === 'Suspended') $statusClass = 'badge-suspended';
                                    elseif ($d->status === 'Error') $statusClass = 'badge-error';
                                    ?>
                                    <tr>
                                        <td><strong>#<?php echo $d->serviceid; ?></strong></td>
                                        <td><?php echo $clientName; ?></td>
                                        <td><?php echo htmlspecialchars($d->product_name); ?></td>
                                        <td><code><?php echo htmlspecialchars($d->server_ip); ?></code></td>
                                        <td>
                                            <a href="<?php echo $dashUrl; ?>" target="_blank" style="text-decoration:none; font-weight:600;">
                                                Port: <?php echo $d->dash_port; ?> <i class="fas fa-external-link-alt" style="font-size:10px;"></i>
                                            </a>
                                        </td>
                                        <td>
                                            <?php if (!empty($d->current_model)): ?>
                                            <code style="font-size:11px;background:#e8f0fe;color:#2b5be8;padding:3px 7px;border-radius:4px;"><?php echo htmlspecialchars($d->current_model); ?></code>
                                            <?php else: ?>
                                            <span style="font-size:11px;color:#aaa;">—</span>
                                            <?php endif; ?>
                                        </td>
                                        <?php
                                        $usage = $usageMap[$d->serviceid] ?? null;
                                        ?>
                                        <td style="text-align:right;">
                                            <?php if ($usage): ?>
                                            <span style="font-size:12px;font-weight:600;color:#2e3d49;"><?php echo number_format($usage['total_tokens']); ?></span>
                                            <?php if ($usage['prompt_tokens'] || $usage['completion_tokens']): ?>
                                            <br><span style="font-size:10px;color:#888;">↑<?php echo number_format($usage['prompt_tokens']); ?> ↓<?php echo number_format($usage['completion_tokens']); ?></span>
                                            <?php endif; ?>
                                            <?php else: ?>
                                            <span style="font-size:11px;color:#ccc;">—</span>
                                            <?php endif; ?>
                                        </td>
                                        <td style="text-align:right;">
                                            <?php if ($usage && $usage['spend'] > 0): ?>
                                            <span style="font-size:12px;font-weight:600;color:#1cc88a;">$<?php echo number_format($usage['spend'], 4); ?></span>
                                            <?php else: ?>
                                            <span style="font-size:11px;color:#ccc;">—</span>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <span class="ha-badge <?php echo $statusClass; ?>"><?php echo $d->status; ?></span>
                                            <?php if (empty($d->litellm_key_id)): ?>
                                            <br><span class="ha-badge" style="background:#dc3545;color:#fff;font-size:9px;margin-top:4px;display:inline-block;" title="No per-customer LiteLLM key on record — this instance is running on the shared master key. Usage/tokens are NOT tracked and NOT billable for this customer until a redeploy successfully generates one.">
                                                <i class="fas fa-exclamation-triangle"></i> MASTER KEY
                                            </span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    <?php else: ?>
                        <div style="text-align:center; padding: 40px 20px; color:#777;">
                            <i class="fas fa-server" style="font-size:40px; margin-bottom:10px; color:#ccc;"></i>
                            <p style="margin:0; font-size:14px;">No active Hermes Agent deployments found.</p>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        
        <!-- Awaiting Onboarding Section -->
        <div class="ha-panel">
            <div class="ha-panel-header" style="background:#fff3cd; border-color:#ffeeba;">
                <h4 class="ha-panel-title" style="color:#856404;"><i class="fas fa-hourglass-half"></i> Awaiting Customer Onboarding</h4>
                <span class="ha-badge" style="background:#856404;color:#fff;padding:5px 10px;"><?php echo count($pendingOnboarding); ?> Pending</span>
            </div>
            <div class="ha-panel-body" style="padding:0; overflow-x:auto;">
                <?php if (count($pendingOnboarding) > 0): ?>
                    <table class="table-ha">
                        <thead>
                            <tr>
                                <th>Service ID</th>
                                <th>Client</th>
                                <th>Product</th>
                                <th>Order Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($pendingOnboarding as $po): ?>
                                <?php
                                $clientName = htmlspecialchars($po->firstname . ' ' . $po->lastname);
                                if ($po->companyname) {
                                    $clientName .= ' (' . htmlspecialchars($po->companyname) . ')';
                                }
                                ?>
                                <tr>
                                    <td><strong>#<?php echo $po->serviceid; ?></strong></td>
                                    <td><?php echo $clientName; ?></td>
                                    <td><?php echo htmlspecialchars($po->product_name); ?></td>
                                    <td><?php echo htmlspecialchars($po->created_at); ?></td>
                                    <td><span class="ha-badge badge-suspended">Pending Wizard</span></td>
                                    <td>
                                        <form method="post" onsubmit="return confirm('Force provision this service using default generic settings?');">
                                            <input type="hidden" name="provision_service_id" value="<?php echo $po->serviceid; ?>">
                                            <button type="submit" name="provision_default" class="btn-ha-primary" style="padding:5px 10px;font-size:12px;">
                                                <i class="fas fa-rocket"></i> Provision with defaults
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                <?php else: ?>
                    <div style="text-align:center; padding: 30px 20px; color:#777;">
                        <i class="fas fa-check-circle" style="font-size:30px; margin-bottom:10px; color:#1cc88a; display:block;"></i>
                        <p style="margin:0; font-size:14px;">No services waiting for onboarding.</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>

        <!-- Quiz Leads Section -->
        <?php echo $leadMessage; ?>
        <div class="ha-panel" style="margin-top:0;">
            <div class="ha-panel-header" style="background:#f0f4ff; border-color:#c8d4f8;">
                <h4 class="ha-panel-title" style="color:#2b5be8;">
                    <i class="fas fa-poll"></i> Quiz Leads — Beta Program Applicants
                </h4>
                <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;">
                    <span class="ha-badge" style="background:#e8f0fe;color:#2b5be8;padding:5px 10px;">Total: <?php echo $leadsTotal; ?></span>
                    <span class="ha-badge" style="background:#fff3cd;color:#856404;padding:5px 10px;">New: <?php echo $leadsNew; ?></span>
                    <span class="ha-badge" style="background:#d1ecf1;color:#0c5460;padding:5px 10px;">Contacted: <?php echo $leadsContacted; ?></span>
                    <span class="ha-badge badge-active" style="padding:5px 10px;">Converted: <?php echo $leadsConverted; ?></span>
                </div>
            </div>

            <?php if (count($leads) > 0): ?>
            <div style="overflow-x:auto;">
                <table class="table-ha">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>WhatsApp</th>
                            <th>Profile Type</th>
                            <th>Answers</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $profileLabels = [
                            'architect' => ['🎯 Architect', '#e8f0fe', '#2b5be8'],
                            'sprinter'  => ['⚡ Sprinter',  '#fff8e1', '#b7750a'],
                            'craftsman' => ['🔥 Craftsman', '#fff0f0', '#b71c1c'],
                            'explorer'  => ['🚀 Explorer',  '#e8f5e9', '#1b5e20'],
                        ];
                        $statusOptions = ['new' => 'New', 'contacted' => 'Contacted', 'converted' => 'Converted', 'rejected' => 'Rejected'];
                        $statusBadge   = ['new' => 'badge-pending', 'contacted' => 'badge-suspended', 'converted' => 'badge-active', 'rejected' => 'badge-error'];
                        foreach ($leads as $lead):
                            $pLabel = $profileLabels[$lead->profile] ?? [$lead->profile, '#f5f5f5', '#555'];
                            $answersDecoded = json_decode($lead->answers ?? '{}', true);
                            $answerStr = '';
                            if (is_array($answersDecoded)) {
                                $parts = [];
                                for ($qi = 1; $qi <= 5; $qi++) {
                                    if (isset($answersDecoded[$qi])) $parts[] = 'Q' . $qi . ':' . $answersDecoded[$qi]['letter'];
                                }
                                $answerStr = implode(' ', $parts);
                            }
                        ?>
                        <tr>
                            <td style="color:#888;font-size:12px;">#<?php echo $lead->id; ?></td>
                            <td><strong><?php echo htmlspecialchars($lead->name ?: '—'); ?></strong></td>
                            <td>
                                <a href="mailto:<?php echo htmlspecialchars($lead->email); ?>" style="color:#4e73df;font-weight:600;">
                                    <?php echo htmlspecialchars($lead->email); ?>
                                </a>
                            </td>
                            <td>
                                <a href="https://wa.me/<?php echo preg_replace('/\D/', '', $lead->whatsapp); ?>" target="_blank" style="color:#1cc88a;font-weight:600;">
                                    <?php echo htmlspecialchars($lead->whatsapp ?: '—'); ?>
                                </a>
                            </td>
                            <td>
                                <span style="background:<?php echo $pLabel[1]; ?>;color:<?php echo $pLabel[2]; ?>;padding:4px 10px;border-radius:4px;font-size:12px;font-weight:700;white-space:nowrap;">
                                    <?php echo $pLabel[0]; ?>
                                </span>
                            </td>
                            <td>
                                <code style="font-size:11px;color:#777;background:#f8f9fc;padding:3px 6px;border-radius:3px;">
                                    <?php echo htmlspecialchars($answerStr ?: '—'); ?>
                                </code>
                            </td>
                            <td style="white-space:nowrap;font-size:12px;color:#888;"><?php echo date('M j, Y', strtotime($lead->created_at)); ?></td>
                            <td>
                                <span class="ha-badge <?php echo $statusBadge[$lead->status] ?? 'badge-pending'; ?>">
                                    <?php echo $statusOptions[$lead->status] ?? $lead->status; ?>
                                </span>
                            </td>
                            <td>
                                <button class="btn-ha-primary" style="padding:6px 12px;font-size:12px;"
                                    onclick="openLeadModal(<?php echo $lead->id; ?>,'<?php echo htmlspecialchars($lead->name); ?>','<?php echo htmlspecialchars($lead->status); ?>','<?php echo htmlspecialchars(addslashes($lead->notes ?? '')); ?>')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
            <?php else: ?>
            <div style="text-align:center;padding:40px 20px;color:#777;">
                <i class="fas fa-poll" style="font-size:40px;margin-bottom:10px;color:#ccc;display:block;"></i>
                <p style="margin:0;font-size:14px;">No quiz submissions yet. Share your quiz link to start collecting leads.</p>
            </div>
            <?php endif; ?>
        </div>

    </div><!-- /.ha-wrapper -->

    <!-- Lead Edit Modal -->
    <div id="leadModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:#fff;border-radius:10px;padding:28px;max-width:440px;width:90%;box-shadow:0 20px 60px rgba(0,0,0,0.3);">
            <h4 style="margin:0 0 20px;font-size:17px;font-weight:700;color:#2b3e50;">
                Update Lead — <span id="modal-name"></span>
            </h4>
            <form method="post" action="">
                <input type="hidden" name="lead_id" id="modal-lead-id">
                <div style="margin-bottom:14px;">
                    <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.05em;color:#666;display:block;margin-bottom:5px;">Status</label>
                    <select name="lead_status" id="modal-status" class="form-control" style="height:38px;border-radius:6px;">
                        <option value="new">New</option>
                        <option value="contacted">Contacted</option>
                        <option value="converted">Converted</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>
                <div style="margin-bottom:20px;">
                    <label style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.05em;color:#666;display:block;margin-bottom:5px;">Notes</label>
                    <textarea name="lead_notes" id="modal-notes" rows="3" class="form-control" style="border-radius:6px;resize:vertical;" placeholder="Any notes about this lead..."></textarea>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="submit" name="update_lead_status" class="btn-ha-primary" style="flex:1;">
                        <i class="fas fa-save"></i> Save
                    </button>
                    <button type="button" onclick="closeLeadModal()" style="flex:1;padding:10px;border:1px solid #ddd;background:#fff;border-radius:6px;cursor:pointer;font-weight:600;">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
    function openLeadModal(id, name, status, notes) {
        document.getElementById('modal-lead-id').value = id;
        document.getElementById('modal-name').textContent = name || ('#' + id);
        document.getElementById('modal-status').value = status;
        document.getElementById('modal-notes').value = notes;
        var m = document.getElementById('leadModal');
        m.style.display = 'flex';
    }
    function closeLeadModal() {
        document.getElementById('leadModal').style.display = 'none';
    }
    document.getElementById('leadModal').addEventListener('click', function(e) {
        if (e.target === this) closeLeadModal();
    });
    </script>

    <?php
}
