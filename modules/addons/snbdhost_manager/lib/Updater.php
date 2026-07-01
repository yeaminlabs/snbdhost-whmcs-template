<?php
namespace SNBDHostManager;

class Updater
{
    private $githubRepo;
    private $githubToken;
    private $apiBase = 'https://api.github.com/repos/';
    private $downloadPath;

    public function __construct($githubRepo, $githubToken = '')
    {
        $this->githubRepo = $githubRepo;
        $this->githubToken = $githubToken;
        $this->downloadPath = sys_get_temp_dir() . '/snbdhost_theme_update.zip';
    }

    public function updateTheme($type = 'all')
    {
        if (empty($this->githubRepo) || $this->githubRepo === 'username/repo') {
            throw new \Exception("GitHub repository is not configured correctly.");
        }

        // 1. Fetch latest release from GitHub
        $releaseUrl = $this->apiBase . $this->githubRepo . '/releases/latest';
        
        $downloadUrl = '';
        try {
            $releaseData = $this->makeRequest($releaseUrl);
            $downloadUrl = $releaseData['zipball_url'] ?? '';
        } catch (\Exception $e) {
            // Fallback: Download from main branch if releases endpoint fails (e.g. 404 Not Found)
            $downloadUrl = "https://github.com/{$this->githubRepo}/archive/refs/heads/main.zip";
        }

        if (empty($downloadUrl)) {
            throw new \Exception("Could not determine the download URL for the theme update.");
        }

        // 2. Download the zip file
        $this->downloadFile($downloadUrl, $this->downloadPath);

        // 3. Extract and overwrite the theme files
        // The theme directory is expected to be WHMCS_ROOT/templates/snbdhost
        // Since this script runs from WHMCS_ROOT/modules/addons/snbdhost_manager/lib, we go up 4 levels
        $targetDir = realpath(__DIR__ . '/../../../../templates/');
        if (!$targetDir) {
            throw new \Exception("Could not locate the templates directory at " . __DIR__ . '/../../../../templates/');
        }
        
        $this->extractTheme($this->downloadPath, $targetDir, $type);

        // Cleanup
        if (file_exists($this->downloadPath)) {
            unlink($this->downloadPath);
        }

        return true;
    }

    private function makeRequest($url, $isDownload = false)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_USERAGENT, 'WHMCS-SNBDHost-Manager');
        curl_setopt($ch, CURLOPT_TIMEOUT, 120);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

        $headers = [];
        if (!empty($this->githubToken)) {
            $headers[] = 'Authorization: token ' . $this->githubToken;
        }

        if (!$isDownload) {
            $headers[] = 'Accept: application/vnd.github.v3+json';
            curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
            curl_setopt($ch, CURLOPT_MAXREDIRS, 10);
            if (!empty($headers)) curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            
            $response = curl_exec($ch);
            $error = curl_error($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $finalUrl = curl_getinfo($ch, CURLINFO_EFFECTIVE_URL);
            curl_close($ch);
            
            if ($error || $response === false) throw new \Exception("cURL Error: " . $error);
            if ($httpCode >= 400) throw new \Exception("GitHub returned HTTP {$httpCode} for URL: {$finalUrl}. Response: " . substr(strip_tags($response), 0, 200));
            return json_decode($response, true);
        }

        // For downloads, handle redirect manually to strip token
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 0);
        curl_setopt($ch, CURLOPT_HEADER, 1);
        if (!empty($headers)) curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        curl_close($ch);
        
        if ($response === false) throw new \Exception("cURL Error getting download link.");
        
        $finalUrl = $url;
        if (in_array($httpCode, [301, 302, 307, 308])) {
            $headerStr = substr($response, 0, $headerSize);
            if (preg_match('/^Location:\s*(.+)$/im', $headerStr, $matches)) {
                $finalUrl = trim($matches[1]);
            }
        } elseif ($httpCode >= 400) {
            throw new \Exception("GitHub returned HTTP {$httpCode} for URL: {$url}. Check repo, branch, and token.");
        }
        
        $ch2 = curl_init($finalUrl);
        curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch2, CURLOPT_USERAGENT, 'WHMCS-SNBDHost-Manager');
        curl_setopt($ch2, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch2, CURLOPT_MAXREDIRS, 5);
        curl_setopt($ch2, CURLOPT_TIMEOUT, 120);
        curl_setopt($ch2, CURLOPT_CONNECTTIMEOUT, 15);
        curl_setopt($ch2, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch2, CURLOPT_SSL_VERIFYHOST, 0);
        
        $data = curl_exec($ch2);
        $error = curl_error($ch2);
        $httpCode = curl_getinfo($ch2, CURLINFO_HTTP_CODE);
        $finalUrl = curl_getinfo($ch2, CURLINFO_EFFECTIVE_URL);
        curl_close($ch2);
        
        if ($error || $data === false) throw new \Exception("cURL Error downloading zip: " . $error);
        if ($httpCode >= 400) throw new \Exception("GitHub returned HTTP {$httpCode} for URL: {$finalUrl}. Check token.");
        
        return $data;
    }

    private function downloadFile($url, $destination)
    {
        $data = $this->makeRequest($url, true);
        if ($data === false) {
            throw new \Exception("Failed to download the theme zip file.");
        }
        
        // Validate it is actually a zip file (magic bytes PK = 0x50 0x4B)
        if (strlen($data) < 4 || substr($data, 0, 2) !== 'PK') {
            $preview = substr(strip_tags($data), 0, 300);
            throw new \Exception("Downloaded theme file is not a valid zip archive. GitHub may have returned an error page. Response preview: " . $preview);
        }
        
        file_put_contents($destination, $data);
    }

    private function extractTheme($zipPath, $targetDir, $type = 'all')
    {
        if (!file_exists($zipPath) || filesize($zipPath) < 4) {
            throw new \Exception("Zip file is missing or empty at: {$zipPath}");
        }

        $zip = new \ZipArchive;
        $openResult = $zip->open($zipPath);
        if ($openResult === true) {
            // Usually GitHub zips contain a root folder (e.g. repo-name-1.0.0/)
            // We need to extract its contents, particularly the 'templates/snbdhost' directory if structured that way.
            // For simplicity, we extract to a temp directory and then move the theme folder.
            
            $tempExtractDir = sys_get_temp_dir() . '/snbdhost_extract_' . time();
            mkdir($tempExtractDir);
            
            $zip->extractTo($tempExtractDir);
            $zip->close();
            
            // Find the extracted root folder (GitHub puts everything in a root folder inside the zip)
            $scanned = array_diff(scandir($tempExtractDir), ['..', '.']);
            $rootFolder = reset($scanned);
            
            $whmcsRootDir = realpath(__DIR__ . '/../../../../');
            if (!$whmcsRootDir) {
                throw new \Exception("Could not locate the WHMCS root directory.");
            }
            
            // 1. Update templates/snbdhost and related packages
            if ($type === 'all' || $type === 'theme') {
                $sourceThemeDir = $tempExtractDir . '/' . $rootFolder . '/templates/snbdhost';
                if (is_dir($sourceThemeDir)) {
                    $finalDest = $targetDir . '/snbdhost';
                    $this->recurseCopy($sourceThemeDir, $finalDest);
                    
                    // 1a. Copy any WHMCS hook files (snbdhost_*_hook.php) from templates/snbdhost/ to includes/hooks/
                    $hooksDestDir = $whmcsRootDir . '/includes/hooks';
                    @mkdir($hooksDestDir, 0755, true);
                    if (is_dir($hooksDestDir)) {
                        $files = scandir($sourceThemeDir);
                        foreach ($files as $file) {
                            if (strpos($file, 'snbdhost_') === 0 && substr($file, -9) === '_hook.php') {
                                copy($sourceThemeDir . '/' . $file, $hooksDestDir . '/' . $file);
                            }
                        }
                    }
                } elseif (is_dir($tempExtractDir . '/' . $rootFolder)) {
                    // Fallback: If the repo doesn't have a templates folder, assume the whole repo is the theme
                    $this->recurseCopy($tempExtractDir . '/' . $rootFolder, $targetDir . '/snbdhost');
                } else {
                     throw new \Exception("Could not find the theme files inside the extracted archive.");
                }
                
                // 1b. Update templates/orderforms/snbdhost_cart
                $sourceCartDir = $tempExtractDir . '/' . $rootFolder . '/templates/orderforms/snbdhost_cart';
                if (is_dir($sourceCartDir)) {
                    $cartDestDir = $whmcsRootDir . '/templates/orderforms';
                    @mkdir($cartDestDir, 0755, true);
                    $this->recurseCopy($sourceCartDir, $cartDestDir . '/snbdhost_cart');
                }
                
                // 1c. Copy root utility scripts
                $rootFiles = ['google-signin.php', 'serverstatus-cron.php', 'serverstatus-data.php', 'migration.php'];
                foreach ($rootFiles as $file) {
                    $sourceFile = $tempExtractDir . '/' . $rootFolder . '/' . $file;
                    if (file_exists($sourceFile)) {
                        copy($sourceFile, $whmcsRootDir . '/' . $file);
                    }
                }
            }
            
            // 2. Update modules/addons/snbdhost_manager
            if ($type === 'all' || $type === 'module') {
                $sourceModuleDir = $tempExtractDir . '/' . $rootFolder . '/modules/addons/snbdhost_manager';
                if (is_dir($sourceModuleDir)) {
                    $moduleTargetDir = realpath(__DIR__ . '/../../'); // points to modules/addons/
                    if ($moduleTargetDir) {
                        $this->recurseCopy($sourceModuleDir, $moduleTargetDir . '/snbdhost_manager');
                    }
                }
            }

            // Cleanup temp dir
            $this->recurseRmdir($tempExtractDir);
            
        } else {
            $zipErrors = [
                \ZipArchive::ER_NOZIP  => 'Not a zip file',
                \ZipArchive::ER_INCONS => 'Zip archive inconsistent',
                \ZipArchive::ER_CRC    => 'CRC error',
                \ZipArchive::ER_NOENT  => 'No such file',
                \ZipArchive::ER_OPEN   => 'Cannot open file',
                \ZipArchive::ER_READ   => 'Read error',
                \ZipArchive::ER_SEEK   => 'Seek error',
            ];
            $reason = isset($zipErrors[$openResult]) ? $zipErrors[$openResult] : "error code {$openResult}";
            throw new \Exception("Failed to open the downloaded zip file: {$reason}. The file may be corrupted.");
        }
    }

    private function recurseCopy($src, $dst) {
        $dir = opendir($src);
        @mkdir($dst, 0755, true);
        while(false !== ( $file = readdir($dir)) ) {
            if (( $file != '.' ) && ( $file != '..' )) {
                if ( is_dir($src . '/' . $file) ) {
                    $this->recurseCopy($src . '/' . $file, $dst . '/' . $file);
                } else {
                    copy($src . '/' . $file, $dst . '/' . $file);
                }
            }
        }
        closedir($dir);
    }

    private function recurseRmdir($dir) {
        if (is_dir($dir)) {
            $objects = scandir($dir);
            foreach ($objects as $object) {
                if ($object != "." && $object != "..") {
                    if (is_dir($dir. DIRECTORY_SEPARATOR .$object) && !is_link($dir."/".$object))
                        $this->recurseRmdir($dir. DIRECTORY_SEPARATOR .$object);
                    else
                        unlink($dir. DIRECTORY_SEPARATOR .$object);
                }
            }
            rmdir($dir);
        }
    }
}
