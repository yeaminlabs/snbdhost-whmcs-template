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
    if (isset($vars['filename']) && $vars['filename'] !== 'index') {
        return '';
    }
    $notice = new \SNBDHostManager\DashboardTopNotice();
    return $notice->render();
});

add_hook('ClientAreaPageHome', 1, function($vars) {
    $bannerData = ['enabled' => '1', 'title' => '', 'desc' => '', 'link' => '', 'link_text' => ''];
    if (file_exists(__DIR__ . '/client_banner.json')) {
        $data = json_decode(file_get_contents(__DIR__ . '/client_banner.json'), true);
        if (is_array($data)) {
            $bannerData = $data;
        }
    }
    return [
        'snbdBannerEnabled' => $bannerData['enabled'],
        'snbdBannerTitle' => $bannerData['title'],
        'snbdBannerDesc' => $bannerData['desc'],
        'snbdBannerLink' => $bannerData['link'],
        'snbdBannerLinkText' => $bannerData['link_text']
    ];
});
