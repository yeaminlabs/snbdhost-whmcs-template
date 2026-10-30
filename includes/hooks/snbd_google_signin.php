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
    $template = ltrim(str_replace(['..', '\\', "\0"], '', (string) ($vars['templatefile'] ?? '')), '/');

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
