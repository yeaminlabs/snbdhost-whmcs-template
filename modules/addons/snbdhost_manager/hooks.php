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

add_hook('AdminHomepage', 1, function($vars) {
    $notice = new \SNBDHostManager\DashboardTopNotice();
    return $notice->render();
});
