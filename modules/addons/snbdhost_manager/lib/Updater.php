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

    public function updateTheme()
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
        // Since this script runs from WHMCS_ROOT/modules/addons/snbdhost_manager/, we go up 3 levels
        $targetDir = realpath(__DIR__ . '/../../../templates/');
        if (!$targetDir) {
            throw new \Exception("Could not locate the templates directory.");
        }
        
        $this->extractTheme($this->downloadPath, $targetDir);

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
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1); // Follow redirects for downloads

        $headers = [];
        if (!empty($this->githubToken)) {
            $headers[] = 'Authorization: token ' . $this->githubToken;
        }

        if (!$isDownload) {
            $headers[] = 'Accept: application/vnd.github.v3+json';
        }

        if (!empty($headers)) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        }

        $response = curl_exec($ch);
        $error = curl_error($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($error) {
            throw new \Exception("cURL Error: " . $error);
        }

        if ($httpCode >= 400 && !$isDownload) {
            throw new \Exception("GitHub API Error (HTTP {$httpCode}): " . $response);
        }

        if ($isDownload) {
            return $response;
        }

        return json_decode($response, true);
    }

    private function downloadFile($url, $destination)
    {
        $data = $this->makeRequest($url, true);
        if ($data === false) {
            throw new \Exception("Failed to download the theme zip file.");
        }
        file_put_contents($destination, $data);
    }

    private function extractTheme($zipPath, $targetDir)
    {
        $zip = new \ZipArchive;
        if ($zip->open($zipPath) === true) {
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
            $sourceThemeDir = $tempExtractDir . '/' . $rootFolder . '/templates/snbdhost';
            
            // If the repo itself is the theme (no templates/snbdhost wrapper), then:
            // $sourceThemeDir = $tempExtractDir . '/' . $rootFolder;
            // Let's check which structure it is.
            if (!is_dir($sourceThemeDir)) {
                 $sourceThemeDir = $tempExtractDir . '/' . $rootFolder; // Assume the whole repo is the theme
            }

            if (is_dir($sourceThemeDir)) {
                $finalDest = $targetDir . '/snbdhost';
                // Recursively copy files to templates/snbdhost
                $this->recurseCopy($sourceThemeDir, $finalDest);
            } else {
                 throw new \Exception("Could not find the theme files inside the extracted archive.");
            }

            // Cleanup temp dir
            $this->recurseRmdir($tempExtractDir);
            
        } else {
            throw new \Exception("Failed to open the downloaded zip file.");
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
