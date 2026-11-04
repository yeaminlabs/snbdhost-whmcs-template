<?php
/**
 * SNBD Host — Developer Updates Page Hook
 *
 * Registers a custom client area page accessible at:
 *   clientarea.php?action=devupdates
 *
 * Works by intercepting the ClientAreaPage hook for unknown actions and
 * overriding the Smarty $templatefile variable so WHMCS loads
 * templates/{template}/clientareadevupdates.tpl instead of the default.
 *
 * INSTALLATION: Copy this file to your WHMCS installation under:
 *               /includes/hooks/snbdhost_updates_page_hook.php
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

/**
 * Intercept any client area page load and, when action=devupdates,
 * swap the template file to our custom changelog template.
 *
 * The return array of ClientAreaPage is merged into Smarty template vars
 * before WHMCS renders the page, so returning 'templatefile' here will
 * override whichever template WHMCS would have loaded by default for the
 * unrecognised action.
 */
add_hook('ClientAreaPage', 1, function(array $vars) {

    $action = isset($_GET['action']) ? (string)$_GET['action'] : '';

    if ($action !== 'devupdates') {
        return [];
    }

    // Only serve this page to logged-in clients
    if (empty($vars['clientsdetails']['userid'])) {
        header('Location: login.php');
        exit;
    }

    return [
        'pagetitle'    => 'Developer Updates — SNBD HOST',
        'templatefile' => 'clientareadevupdates',
    ];
});
