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
 * Google Sign-In account provisioning.
 *
 * WHMCS's own JS (WHMCS.authn.provider) posts the Google id_token to
 * /auth/provider/google_signin/finalize and expects native WHMCS to reply
 * with {result:"logged_in", redirect_url:...}. This hook runs ahead of that
 * native finalize logic and only ensures the WHMCS account + the Google
 * authn link exist; it never echoes a response or exits, so native WHMCS
 * always produces the real login + redirect afterward. This is what lets
 * both new and existing users land on the dashboard regardless of which
 * page/button they used, without any client-side redirect/auto-submit logic.
 */
add_hook('AfterSetup', 1, function ($vars) {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST'
        || strpos($_SERVER['REQUEST_URI'], 'google_signin/finalize') === false
        || empty($_POST['id_token'])
    ) {
        return;
    }

    try {
        $tokenParts = explode('.', $_POST['id_token']);
        if (count($tokenParts) !== 3) {
            return;
        }

        $payload = json_decode(base64_decode(strtr($tokenParts[1], '-_', '+/')), true);
        if (!$payload || empty($payload['email']) || empty($payload['sub'])) {
            return;
        }

        $email = $payload['email'];
        $googleSub = $payload['sub'];

        $client = Capsule::table('tblclients')->where('email', $email)->first();

        if (!$client) {
            $result = localAPI('AddClient', [
                'firstname' => $payload['given_name'] ?: 'Unknown',
                'lastname' => $payload['family_name'] ?: 'Unknown',
                'email' => $email,
                'phonenumber' => '+00000000000',
                'address1' => 'Pending Completion',
                'city' => 'N/A',
                'state' => 'N/A',
                'postcode' => '0000',
                'country' => 'BD',
                'password' => 'G00gleAuth!' . bin2hex(random_bytes(8)),
                'customfields' => base64_encode(serialize([
                    '9' => 'Google',
                ])),
            ]);

            if ($result['result'] !== 'success') {
                return;
            }

            $client = Capsule::table('tblclients')->where('id', $result['clientid'])->first();
            if (!$client) {
                return;
            }
        }

        if (!Capsule::schema()->hasTable('tblauthn_account_links')) {
            return;
        }

        $existingLink = Capsule::table('tblauthn_account_links')
            ->where('provider_id', 'google_signin')
            ->where('remote_user_id', $googleSub)
            ->first();

        if (!$existingLink) {
            $columns = Capsule::schema()->getColumnListing('tblauthn_account_links');
            $insertRow = [
                'provider_id' => 'google_signin',
                'remote_user_id' => $googleSub,
            ];

            if (in_array('client_id', $columns, true)) {
                $insertRow['client_id'] = $client->id;
            }

            if (in_array('user_id', $columns, true)) {
                $userClientLink = Capsule::table('tblusers_clients')
                    ->where('client_id', $client->id)
                    ->first();
                if ($userClientLink) {
                    $insertRow['user_id'] = $userClientLink->user_id;
                }
            }

            if (in_array('remote_email', $columns, true)) {
                $insertRow['remote_email'] = $email;
            }

            if (in_array('date_linked', $columns, true)) {
                $insertRow['date_linked'] = date('Y-m-d H:i:s');
            }

            Capsule::table('tblauthn_account_links')->insert($insertRow);
        }

        // Intentionally no echo/exit here — control returns to native WHMCS
        // finalize logic, which now finds the link and logs the user in.
        return;
    } catch (\Throwable $e) {
        // Swallow and let native WHMCS handle/display its own error response.
        return;
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
