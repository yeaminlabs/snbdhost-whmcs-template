<?php
/**
 * SNBDHost Theme Manager Hooks
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

// Require the widget class
require_once __DIR__ . '/lib/SnbdhostThemeWidget.php';

add_hook('AdminHomeWidgets', 1, function() {
    return new \SNBDHostManager\SnbdhostThemeWidget();
});
