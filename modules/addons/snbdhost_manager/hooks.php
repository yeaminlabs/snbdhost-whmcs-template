<?php
/**
 * SNBDHost Theme Manager Hooks
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

// Require the widget class
require_once __DIR__ . '/lib/SnbdhostThemeWidget.php';

// Require the top notice class
require_once __DIR__ . '/lib/DashboardTopNotice.php';

add_hook('AdminHomeWidgets', 1, function() {
    return new \SNBDHostManager\SnbdhostThemeWidget();
});

add_hook('AdminAreaFooterOutput', 1, function($vars) {
    // Debug: output the filename to console
    $debug = '<script>console.log("SNBDHost Hook Fired on: ' . (isset($vars['filename']) ? $vars['filename'] : 'unknown') . '");</script>';
    $notice = new \SNBDHostManager\DashboardTopNotice();
    return $debug . "\n" . $notice->render();
});
