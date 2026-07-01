<?php
namespace SNBDHostManager;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

/**
 * ModuleManager — handles install, update, and CRUD for externally managed WHMCS modules.
 */
class ModuleManager
{
    private $dataFile;
    private $whmcsRoot;

    public function __construct()
    {
        $this->dataFile  = __DIR__ . '/../managed_modules.json';
        $this->whmcsRoot = realpath(__DIR__ . '/../../../../') ?: '';
    }

    /* ------------------------------------------------------------------ */
    /*  CRUD                                                                 */
    /* ------------------------------------------------------------------ */

    public function loadModules(): array
    {
        if (!file_exists($this->dataFile)) {
            return [];
        }
        $data = json_decode(file_get_contents($this->dataFile), true);
        return is_array($data) ? $data : [];
    }

    public function saveModules(array $modules): void
    {
        file_put_contents($this->dataFile, json_encode(array_values($modules), JSON_PRETTY_PRINT));
    }

    public function addModule(array $entry): array
    {
        $modules = $this->loadModules();
        $entry['id']           = uniqid('mod_', true);
        $entry['installed_at'] = '';
        $entry['last_updated'] = '';
        $entry['status']       = 'not_installed';
        $modules[]             = $entry;
        $this->saveModules($modules);
        return $entry;
    }

    public function updateModuleEntry(string $id, array $data): void
    {
        $modules = $this->loadModules();
        foreach ($modules as &$m) {
            if ($m['id'] === $id) {
                foreach ($data as $k => $v) {
                    $m[$k] = $v;
                }
                break;
            }
        }
        unset($m);
        $this->saveModules($modules);
    }

    public function deleteModule(string $id): void
    {
        $modules = $this->loadModules();
        $modules = array_filter($modules, fn($m) => $m['id'] !== $id);
        $this->saveModules($modules);
    }

    public function getModule(string $id): ?array
    {
        foreach ($this->loadModules() as $m) {
            if ($m['id'] === $id) {
                return $m;
            }
        }
        return null;
    }

    /* ------------------------------------------------------------------ */
    /*  Install / Update                                                      */
    /* ------------------------------------------------------------------ */

    /**
     * Downloads the latest release (or main-branch zip) from GitHub and extracts
     * it to the configured install_path relative to WHMCS root.
     */
    public function installOrUpdate(string $id): string
    {
        $module = $this->getModule($id);
        if (!$module) {
            throw new \Exception("Module with ID '{$id}' not found.");
        }

        $repo         = trim($module['repo'] ?? '');
        $token        = trim($module['token'] ?? '');
        $installPath  = trim($module['install_path'] ?? '');
        $branch       = trim($module['branch'] ?? 'main');

        if (empty($repo)) {
            throw new \Exception("GitHub repository is not configured for this module.");
        }

        if (empty($installPath)) {
            throw new \Exception("Install path is not configured for this module.");
        }

        if (empty($this->whmcsRoot)) {
            throw new \Exception("Could not locate the WHMCS root directory.");
        }

        // Resolve destination
        $destination = $this->whmcsRoot . '/' . ltrim($installPath, '/');

        // 1. Get download URL — try latest release, fall back to branch zip
        $downloadUrl = $this->resolveDownloadUrl($repo, $token, $branch);

        // 2. Download to temp file
        $tmpZip = sys_get_temp_dir() . '/snbdmod_' . $id . '_' . time() . '.zip';
        $this->downloadFile($downloadUrl, $tmpZip, $token);

        // 3. Extract to destination
        $this->extractModule($tmpZip, $destination, $module['extract_mode'] ?? 'contents');

        // 4. Cleanup
        if (file_exists($tmpZip)) {
            unlink($tmpZip);
        }

        // 5. Persist status
        $now = date('Y-m-d H:i:s');
        $this->updateModuleEntry($id, [
            'status'       => 'installed',
            'last_updated' => $now,
            'installed_at' => $module['installed_at'] ?: $now,
        ]);

        return "Module '{$module['name']}' installed/updated successfully.";
    }

    /* ------------------------------------------------------------------ */
    /*  Helpers                                                               */
    /* ------------------------------------------------------------------ */

    private function resolveDownloadUrl(string $repo, string $token, string $branch): string
    {
        $apiUrl = "https://api.github.com/repos/{$repo}/releases/latest";
        try {
            $data = $this->apiRequest($apiUrl, $token);
            if (!empty($data['zipball_url'])) {
                return $data['zipball_url'];
            }
        } catch (\Exception $e) {
            // fall through to branch zip
        }
        return "https://github.com/{$repo}/archive/refs/heads/{$branch}.zip";
    }

    private function apiRequest(string $url, string $token = ''): array
    {
        $ch = curl_init($url);
        $headers = ['User-Agent: WHMCS-SNBDHost-Manager', 'Accept: application/vnd.github.v3+json'];
        if ($token) {
            $headers[] = "Authorization: token {$token}";
        }
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER     => $headers,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_TIMEOUT        => 20,
        ]);
        $resp     = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $err      = curl_error($ch);
        curl_close($ch);

        if ($err) {
            throw new \Exception("cURL error: {$err}");
        }
        if ($httpCode >= 400) {
            throw new \Exception("GitHub API returned HTTP {$httpCode}");
        }
        $decoded = json_decode($resp, true);
        if (!is_array($decoded)) {
            throw new \Exception("Invalid JSON response from GitHub API.");
        }
        return $decoded;
    }

    private function downloadFile(string $url, string $dest, string $token = ''): void
    {
        $ch = curl_init($url);
        $headers = ['User-Agent: WHMCS-SNBDHost-Manager'];
        if ($token) {
            $headers[] = "Authorization: token {$token}";
        }
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTPHEADER     => $headers,
            CURLOPT_TIMEOUT        => 120,
        ]);
        $data = curl_exec($ch);
        $err  = curl_error($ch);
        curl_close($ch);

        if ($err || $data === false) {
            throw new \Exception("Failed to download module zip: {$err}");
        }
        file_put_contents($dest, $data);
    }

    /**
     * extract_mode:
     *   'contents' — extracts the inner contents of the root folder in the zip (GitHub default)
     *   'root'     — extracts the zip root folder itself as a subfolder
     */
    private function extractModule(string $zipPath, string $destination, string $extractMode = 'contents'): void
    {
        $zip = new \ZipArchive();
        if ($zip->open($zipPath) !== true) {
            throw new \Exception("Failed to open the downloaded zip file.");
        }

        $tmpDir = sys_get_temp_dir() . '/snbdmod_extract_' . time();
        mkdir($tmpDir, 0755, true);
        $zip->extractTo($tmpDir);
        $zip->close();

        // Find the root folder inside the zip (GitHub wraps everything in a subfolder)
        $entries = array_diff(scandir($tmpDir), ['..', '.']);
        $rootFolder = reset($entries);
        $sourceDir  = $tmpDir . '/' . $rootFolder;

        if (!is_dir($sourceDir)) {
            $this->recurseRmdir($tmpDir);
            throw new \Exception("Unexpected zip structure — could not find root folder inside archive.");
        }

        if ($extractMode === 'root') {
            // Install the root folder as-is into the destination
            @mkdir($destination, 0755, true);
            $this->recurseCopy($sourceDir, $destination);
        } else {
            // 'contents' mode — copy the inner contents of the root folder
            @mkdir($destination, 0755, true);
            $this->recurseCopy($sourceDir, $destination);
        }

        $this->recurseRmdir($tmpDir);
    }

    private function recurseCopy(string $src, string $dst): void
    {
        $dir = opendir($src);
        @mkdir($dst, 0755, true);
        while (false !== ($file = readdir($dir))) {
            if ($file === '.' || $file === '..') {
                continue;
            }
            if (is_dir("{$src}/{$file}")) {
                $this->recurseCopy("{$src}/{$file}", "{$dst}/{$file}");
            } else {
                copy("{$src}/{$file}", "{$dst}/{$file}");
            }
        }
        closedir($dir);
    }

    private function recurseRmdir(string $dir): void
    {
        if (!is_dir($dir)) {
            return;
        }
        foreach (scandir($dir) as $object) {
            if ($object === '.' || $object === '..') {
                continue;
            }
            $path = $dir . DIRECTORY_SEPARATOR . $object;
            if (is_dir($path) && !is_link($path)) {
                $this->recurseRmdir($path);
            } else {
                unlink($path);
            }
        }
        rmdir($dir);
    }
}
