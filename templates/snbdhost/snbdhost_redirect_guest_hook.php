<?php
/**
 * SNBD Host Redirect Guest Hook
 *
 * Redirects guest (logged-out) users attempting to access the portal home page (index.php)
 * to the login page (login.php).
 *
 * INSTALLATION: Copy this file to your WHMCS installation under:
 *               /includes/hooks/snbdhost_redirect_guest_hook.php
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

add_hook('ClientAreaPage', 1, function($vars) {
    // Check if the user is logged in using both WHMCS template variables and session data
    $isLoggedIn = !empty($vars['clientsdetails']['userid']) || (isset($_SESSION['uid']) && $_SESSION['uid'] > 0);

    if (!$isLoggedIn) {
        $filename = isset($vars['filename']) ? $vars['filename'] : '';
        $templatefile = isset($vars['templatefile']) ? $vars['templatefile'] : '';

        // If the guest user is trying to access the index page (portal home)
        if ($filename === 'index' || $templatefile === 'homepage') {
            header("Location: login.php");
            exit;
        }
    }
});
