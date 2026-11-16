<?php
/**
 * Compatibility shim for the legacy Websavers Google Tag Manager addon.
 *
 * Ecommerce tracking is owned by includes/hooks/snbd_datalayer_hook.php and
 * the single GTM embed in templates/snbdhost/header.tpl. The old addon hooks
 * registered a second GTM container and emitted legacy ecommerce payloads,
 * which double-counted add_to_cart, begin_checkout, and purchase events.
 *
 * Keep the addon directory available for existing WHMCS installations, but
 * deliberately register no output hooks here. The addon configuration file
 * remains available for backwards compatibility.
 */

if (!defined('WHMCS')) {
    die('This file cannot be accessed directly');
}
