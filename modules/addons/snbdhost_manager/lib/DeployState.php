<?php
namespace SNBDHostManager;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

/**
 * DeployState — records which branch/commit is currently live on this
 * install, so the admin UI can show an "Active" badge next to the branch
 * that was last actually deployed (as opposed to just the newest commit).
 */
class DeployState
{
    private $dataFile;

    public function __construct()
    {
        $this->dataFile = __DIR__ . '/../deploy_state.json';
    }

    public function load(): array
    {
        $default = [
            'theme'  => ['branch' => null, 'sha' => null, 'updated_at' => null],
            'module' => ['branch' => null, 'sha' => null, 'updated_at' => null],
        ];
        if (!file_exists($this->dataFile)) {
            return $default;
        }
        $data = json_decode(file_get_contents($this->dataFile), true);
        return is_array($data) ? array_replace_recursive($default, $data) : $default;
    }

    public function recordDeploy(string $type, string $branch, ?string $sha): void
    {
        $state = $this->load();
        $entry = [
            'branch'     => $branch,
            'sha'        => $sha,
            'updated_at' => date('c'),
        ];
        if ($type === 'all') {
            $state['theme']  = $entry;
            $state['module'] = $entry;
        } else {
            $state[$type] = $entry;
        }
        file_put_contents($this->dataFile, json_encode($state, JSON_PRETTY_PRINT));
    }
}
