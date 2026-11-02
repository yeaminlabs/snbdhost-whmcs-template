<?php
/**
 * SNBD Host — Google sign-in client id
 *
 * The button in login / register / password-reset only needs a client id. It used
 * to arrive solely from snbdhost_manager's hooks.php, which WHMCS loads only while
 * that addon is active — so deactivating it, or deploying a theme without the
 * matching addon files, silently removed sign-in with Google. This hook reads the
 * same addon setting from core hooks, which always run, and does it for the auth
 * pages only so no other page pays for the query.
 */

if (!defined('WHMCS')) {
    die('This file cannot be accessed directly');
}

add_hook('ClientAreaPage', 1, function ($vars) {
    $template = ltrim(str_replace(['..', '\\\\', "\0"], '', (string) ($vars['templatefile'] ?? '')), '/');

    $isAuthPage = in_array($template, ['login', 'clientregister', 'pwreset', 'two-factor-challenge'], true)
        || str_starts_with($template, 'password-reset');

    if (!$isAuthPage) {
        return [];
    }

    try {
        $clientId = WHMCS\Database\Capsule::table('tbladdonmodules')
            ->where('module', 'snbdhost_manager')
            ->where('setting', 'google_client_id')
            ->value('value');
    } catch (\Exception $e) {
        return [];
    }

    return $clientId ? ['googleClientId' => $clientId] : [];
});

/**
 * ClientAreaPage Hook — Google profile picture
 *
 * Sign-in with Google stores the account's picture against the client in
 * mod_snbd_google_links, so the shell can show a real avatar instead of an
 * initial. The URL is re-validated here rather than trusted from the database:
 * it is rendered into an <img src>, so a stored value that is not an https URL
 * is ignored instead of printed.
 *
 * Logged-out requests return immediately, so anonymous traffic pays nothing.
 *
 * The picture Google sent at the most recent sign-in takes precedence: it is
 * re-stored on every successful Google login, so the avatar always reflects the
 * account's current picture. The local mirror is only a fallback for when the
 * stored Google URL is missing or no longer valid.
 */
add_hook('ClientAreaPage', 1, function ($vars) {
    if (empty($vars['loggedin'])) {
        return [];
    }

    $clientId = (int) ($vars['clientsdetails']['id'] ?? 0);

    if ($clientId <= 0) {
        // clientsdetails is not present on every page module, but the session
        // uid always is while someone is signed in.
        try {
            $clientId = (int) WHMCS\Session::get('uid');
        } catch (\Throwable $e) {
            $clientId = 0;
        }
    }

    if ($clientId <= 0) {
        return [];
    }

    $url = snbd_avatar_url(
        $clientId,
        (string) ($vars['WEB_ROOT'] ?? ''),
        (string) ($vars['template'] ?? 'snbdhost')
    );

    return $url ? ['snbdAvatarUrl' => $url] : [];
});

/**
 * Resolve the avatar to render for a client.
 */
function snbd_avatar_url(int $clientId, string $webRoot, string $template): ?string
{
    $theme = preg_replace('/[^a-z0-9_-]/i', '', $template) ?: 'snbdhost';

    // Prefer the picture Google returned at the most recent sign-in so the
    // avatar tracks whatever the account currently has.
    try {
        $picture = WHMCS\Database\Capsule::table('mod_snbd_google_links')
            ->where('client_id', $clientId)
            ->whereNotNull('picture')
            ->orderBy('updated_at', 'desc')
            ->value('picture');

        if ($picture && preg_match('#^https://[a-z0-9.-]+\.[a-z]{2,}/#i', (string) $picture)) {
            return (string) $picture;
        }
    } catch (\Throwable $e) {
        // Fall through to the local mirror.
    }

    // Local mirror written at sign-in (fallback when Google's URL is missing
    // or expired).
    $dir = __DIR__ . '/../../templates/' . $theme . '/assets/avatars';

    foreach (['jpg', 'png'] as $ext) {
        $file = $dir . '/c' . $clientId . '.' . $ext;

        if (!is_file($file)) {
            continue;
        }

        return rtrim($webRoot, '/')
            . '/templates/' . $theme . '/assets/avatars/c' . $clientId . '.' . $ext
            . '?v=' . (int) @filemtime($file);
    }

    return null;
}
