<?php
namespace SNBDHostManager;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

/**
 * Keeps the GitHub token out of plaintext addon configuration after the
 * first authenticated admin request. SNBD_GITHUB_TOKEN takes precedence so
 * installations can keep the secret entirely outside the database.
 */
final class GitHubTokenStore
{
    private const PREFIX = 'snbd-whmcs-encrypted-v1:';

    public static function resolve($storedToken, bool $allowEnvironment = true): string
    {
        if ($allowEnvironment) {
            $environmentToken = getenv('SNBD_GITHUB_TOKEN');
            if (is_string($environmentToken) && $environmentToken !== '') {
                return trim($environmentToken);
            }
        }

        $storedToken = trim((string)$storedToken);
        if ($storedToken === '' || strpos($storedToken, self::PREFIX) !== 0) {
            return $storedToken;
        }

        if (!function_exists('decrypt')) {
            return '';
        }

        try {
            $decrypted = decrypt(substr($storedToken, strlen(self::PREFIX)));
            return is_string($decrypted) ? trim($decrypted) : '';
        } catch (\Throwable $e) {
            return '';
        }
    }

    public static function protect($plainToken): ?string
    {
        $plainToken = trim((string)$plainToken);
        if ($plainToken === '' || !function_exists('encrypt')) {
            return null;
        }

        try {
            $encrypted = encrypt($plainToken);
            if (!is_string($encrypted) || $encrypted === '') {
                return null;
            }
            return self::PREFIX . $encrypted;
        } catch (\Throwable $e) {
            return null;
        }
    }

    public static function isProtected($storedToken): bool
    {
        return strpos((string)$storedToken, self::PREFIX) === 0;
    }
}
