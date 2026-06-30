<?php
/**
 * SNBDHost Theme Manager Hooks
 */

use Illuminate\Database\Capsule\Manager as Capsule;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

// Require the widget class
require_once __DIR__ . '/lib/SnbdhostThemeWidget.php';

// Require the top notice class
require_once __DIR__ . '/lib/DashboardTopNotice.php';

/**
 * Expose Google Client ID to Smarty templates for custom Google Sign-In
 */
add_hook('ClientAreaPage', 1, function($vars) {
    if (in_array($vars['templatefile'], ['login', 'clientregister'])) {
        $setting = Capsule::table('tbladdonmodules')
            ->where('module', 'snbdhost_manager')
            ->where('setting', 'google_client_id')
            ->first();
            
        $clientId = $setting ? $setting->value : '219815663641-p50rq613ol3ilqgbotogg4bb4hvg9s1e.apps.googleusercontent.com';
        
        return [
            'googleClientId' => $clientId
        ];
    }
});

/**
 * Hide "Security Settings" for accounts still carrying OAuth placeholder
 * profile data (phone/address never completed by the user).
 */
add_hook('ClientAreaPrimarySidebar', 1, function ($primarySidebar) {
    if (empty($_SESSION['uid'])) {
        return;
    }

    $client = Capsule::table('tblclients')->where('id', $_SESSION['uid'])->first();
    if ($client && ($client->phonenumber === '+00000000000' || $client->address1 === 'Pending Completion')) {
        $myAccount = $primarySidebar->getChild('My Account');
        if ($myAccount) {
            $myAccount->removeChild('Security Settings');
        }
    }
});

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
