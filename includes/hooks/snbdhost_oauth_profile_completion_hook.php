<?php
defined('WHMCS') or die('Access Denied');

use Illuminate\Database\Capsule\Manager as Capsule;

/**
 * The legacy Google finalization token consumer was removed.
 *
 * It decoded an untrusted JWT payload and used its email/sub claims to create
 * a client and assign an authenticated session, which allowed account takeover
 * with a forged token. Google sign-in is handled only by /google-signin.php, whose
 * verifier checks Google's signature, issuer, audience, and expiry before any
 * account lookup or session creation. Keep this file free of alternate token
 * consumers so a future route cannot accidentally bypass that verifier.
 */

// Existing profile-completion UI hook.
add_hook('ClientAreaPrimarySidebar', 1, function($primarySidebar) {
    if (isset($_SESSION['uid'])) {
        $client = Capsule::table('tblclients')->where('id', $_SESSION['uid'])->first();
        if ($client && ($client->phonenumber === '+00000000000' || $client->address1 === 'Pending Completion')) {
            $myAccount = $primarySidebar->getChild('My Account');
            if ($myAccount) {
                $myAccount->removeChild('Security Settings');
            }
        }
    }
});
