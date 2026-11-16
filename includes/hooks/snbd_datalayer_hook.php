<?php
/**
 * SNBD DataLayer Hook for WHMCS
 * 
 * Standalone WHMCS hook that pushes structured dataLayer events to Google Tag Manager (GTM)
 * supporting GA4, Facebook Pixel, Google Ads, and other marketing/analytics platforms.
 * 
 * @package    SNBD_DataLayer
 * @author     SNBD Web Solutions
 * @version    1.0.0
 * @link       https://snbdhost.com
 */

defined("WHMCS") or die("Access Denied");

use Illuminate\Database\Capsule\Manager as Capsule;

/* ==========================================================================
   1. CONFIGURATION & CONSTANTS
   ========================================================================== */

if (!defined('SNBD_DL_SALT')) {
    define('SNBD_DL_SALT', 'snbd_datalayer_secure_salt_2026');
}

if (!defined('SNBD_DL_AFFILIATION')) {
    define('SNBD_DL_AFFILIATION', 'SNBD Host');
}

/* ==========================================================================
   2. HELPER FUNCTIONS
   ========================================================================== */

/**
 * Generate a SHA256 hashed user ID for privacy compliance (GDPR/GA4 user_id)
 *
 * @param int|string|null $userId
 * @return string|null
 */
function snbd_dl_hash_user_id($userId): ?string
{
    if (empty($userId)) {
        return null;
    }
    return hash('sha256', (string)$userId . SNBD_DL_SALT);
}

/**
 * Retrieve current user context and properties for dataLayer
 *
 * @return array
 */
function snbd_dl_get_user_context(): array
{
    $uid = $_SESSION['uid'] ?? null;
    if (!$uid) {
        return [
            'login_status'     => 'logged_out',
            'user_id'          => null,
            'loyalty_tier'     => null,
            'account_age_days' => null,
            'total_services'   => null,
            'total_domains'    => null,
            'country'          => null,
        ];
    }

    $hashedId = snbd_dl_hash_user_id($uid);
    $loyaltyTier = null;
    $accountAgeDays = null;
    $totalServices = 0;
    $totalDomains = 0;
    $country = null;

    try {
        $client = Capsule::table('tblclients')->where('id', $uid)->first();
        if ($client) {
            $country = $client->country ?? null;
            if (!empty($client->datecreated)) {
                $createdTimestamp = strtotime($client->datecreated);
                if ($createdTimestamp) {
                    $accountAgeDays = (int) floor((time() - $createdTimestamp) / 86400);
                }
            }
        }

        $totalServices = Capsule::table('tblhosting')
            ->where('userid', $uid)
            ->where('domainstatus', 'Active')
            ->count();

        $totalDomains = Capsule::table('tbldomains')
            ->where('userid', $uid)
            ->where('status', 'Active')
            ->count();

        $loyaltyClient = Capsule::table('mod_loyaltymatrix_client_tiers')
            ->join('mod_loyaltymatrix_tiers', 'mod_loyaltymatrix_client_tiers.tier_id', '=', 'mod_loyaltymatrix_tiers.id')
            ->where('mod_loyaltymatrix_client_tiers.client_id', $uid)
            ->select('mod_loyaltymatrix_tiers.name as tier_name')
            ->first();

        if ($loyaltyClient) {
            $loyaltyTier = ucfirst($loyaltyClient->tier_name);
        }
    } catch (\Throwable $e) {
        // Fail gracefully without breaking page render
    }

    return [
        'login_status'     => 'logged_in',
        'user_id'          => $hashedId,
        'loyalty_tier'     => $loyaltyTier,
        'account_age_days' => $accountAgeDays,
        'total_services'   => (int)$totalServices,
        'total_domains'    => (int)$totalDomains,
        'country'          => $country,
    ];
}

/**
 * Retrieve system or client currency code
 *
 * @param int|null $currencyId
 * @return string
 */
function snbd_dl_get_currency($currencyId = null): string
{
    try {
        if ($currencyId) {
            $curr = Capsule::table('tblcurrencies')->where('id', $currencyId)->first();
            if ($curr) {
                return $curr->code;
            }
        }

        $uid = $_SESSION['uid'] ?? null;
        if ($uid) {
            $client = Capsule::table('tblclients')->where('id', $uid)->first();
            if ($client && !empty($client->currency)) {
                $curr = Capsule::table('tblcurrencies')->where('id', $client->currency)->first();
                if ($curr) {
                    return $curr->code;
                }
            }
        }

        $defaultCurr = Capsule::table('tblcurrencies')->where('default', 1)->first();
        if ($defaultCurr) {
            return $defaultCurr->code;
        }
    } catch (\Throwable $e) { }

    return 'USD';
}

/**
 * Queue a dataLayer event to be rendered on the next page load
 *
 * @param array $eventPayload
 * @return void
 */
function snbd_dl_queue_event(array $eventPayload): void
{
    if (!isset($_SESSION['snbd_dl_queue']) || !is_array($_SESSION['snbd_dl_queue'])) {
        $_SESSION['snbd_dl_queue'] = [];
    }
    $_SESSION['snbd_dl_queue'][] = $eventPayload;
}

/**
 * Group raw WHMCS cart/order items by product_id + billing_cycle for GA4/Pixel compliance
 *
 * @param array $rawItems Array of raw item objects/arrays
 * @return array Grouped items array and total calculated value
 */
function snbd_dl_format_ecommerce_items(array $rawItems): array
{
    $grouped = [];
    $totalValue = 0.0;

    foreach ($rawItems as $item) {
        $itemId       = $item['item_id'] ?? 'PROD-0';
        $productId    = (int)($item['product_id'] ?? 0);
        $itemName     = $item['item_name'] ?? 'Item';
        $itemCategory = $item['item_category'] ?? 'General';
        $groupId      = (int)($item['group_id'] ?? 0);
        $itemVariant  = strtolower($item['item_variant'] ?? 'monthly');
        $price        = (float)($item['price'] ?? 0.0);
        $qty          = (int)($item['quantity'] ?? 1);

        $compositeKey = $itemId . '|' . $itemVariant;

        if (isset($grouped[$compositeKey])) {
            $grouped[$compositeKey]['quantity'] += $qty;
        } else {
            $grouped[$compositeKey] = [
                'item_id'       => $itemId,
                'product_id'    => $productId,
                'item_name'     => $itemName,
                'item_category' => $itemCategory,
                'group_id'      => $groupId,
                'item_variant'  => $itemVariant,
                'price'         => round($price, 2),
                'quantity'      => $qty,
            ];
        }

        $totalValue += ($price * $qty);
    }

    $finalItems = [];
    $idx = 0;
    foreach ($grouped as $gItem) {
        $gItem['index'] = $idx++;
        $finalItems[] = $gItem;
    }

    return [
        'items' => $finalItems,
        'value' => round($totalValue, 2),
    ];
}

/* ==========================================================================
   3. CLIENT AREA HEAD OUTPUT (EVERY PAGE RENDER & DISPATCHER)
   ========================================================================== */

add_hook('ClientAreaHeadOutput', 1, function ($vars) {
    $script = '';
    
    // Clear ecommerce object & set user properties on every page load
    $userContext = snbd_dl_get_user_context();
    $pageType = $vars['templatefile'] ?? 'unknown';

    $initialPayload = [
        'event'           => 'user_properties_set',
        'user_properties' => $userContext,
        'page_type'       => $pageType,
    ];

    $script .= "<script>\n";
    $script .= "window.dataLayer = window.dataLayer || [];\n";
    $script .= "dataLayer.push(" . json_encode($initialPayload, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . ");\n";

    // Handle logout cookie event if session was destroyed on logout
    if (!empty($_COOKIE['snbd_dl_logout'])) {
        $logoutUserId = $_COOKIE['snbd_dl_logout'];
        $logoutPayload = [
            'event'   => 'logout',
            'user_id' => $logoutUserId !== '1' ? $logoutUserId : null,
        ];
        $script .= "dataLayer.push(" . json_encode($logoutPayload, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . ");\n";
        setcookie('snbd_dl_logout', '', time() - 3600, '/');
    }

    // Handle login cookie fallback if session regenerated
    if (!empty($_COOKIE['snbd_dl_login'])) {
        $loginUserId = $_COOKIE['snbd_dl_login'];
        $loginPayload = [
            'event'   => 'login',
            'method'  => 'email',
            'user_id' => $loginUserId !== '1' ? $loginUserId : null,
        ];
        $script .= "dataLayer.push(" . json_encode($loginPayload, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . ");\n";
        setcookie('snbd_dl_login', '', time() - 3600, '/');
    }

    // Dequeue and output any queued events from server-side hooks
    $script .= snbd_dl_render_queue();

    $script .= "</script>\n";

    return $script;
});

/**
 * Drain the queued server-side events into dataLayer.push() statements.
 *
 * @return string Bare JS statements, to be wrapped in a <script> by the caller.
 */
function snbd_dl_render_queue(): string
{
    if (empty($_SESSION['snbd_dl_queue']) || !is_array($_SESSION['snbd_dl_queue'])) {
        return '';
    }

    $js = '';
    foreach ($_SESSION['snbd_dl_queue'] as $queuedEvent) {
        if (isset($queuedEvent['ecommerce'])) {
            $js .= "dataLayer.push({ ecommerce: null });\n";
        }
        $js .= "dataLayer.push(" . json_encode($queuedEvent, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . ");\n";
    }
    $_SESSION['snbd_dl_queue'] = [];

    return $js;
}

/**
 * Second drain point, at the end of the page.
 *
 * Hooks that run while the page is being built — the cart's complete page in
 * particular — queue their event after {$headoutput} has already been rendered.
 * Flushing again in the footer delivers those on the same page view instead of
 * deferring them to whatever page the buyer happens to open next.
 */
add_hook('ClientAreaFooterOutput', 1, function ($vars) {
    $js = snbd_dl_render_queue();
    if ($js === '') {
        return '';
    }

    return "<script>\nwindow.dataLayer = window.dataLayer || [];\n" . $js . "</script>\n";
});

/* ==========================================================================
   4. AUTHENTICATION EVENTS
   ========================================================================== */

add_hook('ClientLogin', 1, function ($vars) {
    $userId = $vars['userid'] ?? null;
    $hashedId = snbd_dl_hash_user_id($userId);

    // Set in session queue
    snbd_dl_queue_event([
        'event'   => 'login',
        'method'  => 'email',
        'user_id' => $hashedId,
    ]);

    // Set fallback cookie in case session ID regenerates on login redirect
    setcookie('snbd_dl_login', $hashedId ?? '1', time() + 60, '/');
});

add_hook('ClientLogout', 1, function ($vars) {
    $userId = $vars['userid'] ?? ($_SESSION['uid'] ?? null);
    $hashedId = snbd_dl_hash_user_id($userId);

    // Set cookie because session is destroyed during WHMCS logout process
    setcookie('snbd_dl_logout', $hashedId ?? '1', time() + 60, '/');
});

add_hook('ClientAdd', 1, function ($vars) {
    $userId = $vars['userid'] ?? null;
    if ($userId) {
        snbd_dl_queue_event([
            'event'   => 'sign_up',
            'method'  => 'email',
            'user_id' => snbd_dl_hash_user_id($userId),
        ]);
    }
});

add_hook('ClientChangePassword', 1, function ($vars) {
    $userId = $vars['userid'] ?? ($_SESSION['uid'] ?? null);
    if ($userId) {
        snbd_dl_queue_event([
            'event'   => 'password_reset',
            'user_id' => snbd_dl_hash_user_id($userId),
        ]);
    }
});

/* ==========================================================================
   5. E-COMMERCE & CART EVENTS
   ========================================================================== */

/**
 * Resolve the active currency id (explicit > client > system default).
 * Pricing lookups need the numeric id, not the code.
 *
 * @param int|null $currencyId
 * @return int|null
 */
function snbd_dl_get_currency_id($currencyId = null): ?int
{
    try {
        if ($currencyId) {
            $exists = Capsule::table('tblcurrencies')->where('id', $currencyId)->first();
            if ($exists) {
                return (int)$currencyId;
            }
        }

        $uid = $_SESSION['uid'] ?? null;
        if ($uid) {
            $client = Capsule::table('tblclients')->where('id', $uid)->first();
            if ($client && !empty($client->currency)) {
                return (int)$client->currency;
            }
        }

        $defaultCurr = Capsule::table('tblcurrencies')->where('default', 1)->first();
        if ($defaultCurr) {
            return (int)$defaultCurr->id;
        }

        $any = Capsule::table('tblcurrencies')->first();
        if ($any) {
            return (int)$any->id;
        }
    } catch (\Throwable $e) { }

    return null;
}

/**
 * Recurring price of a product in a currency for a billing cycle. Falls back
 * to the first cycle the product actually offers (-1 marks an unused cycle).
 *
 * @param int $pid
 * @param int $currencyId
 * @param string|null $billingCycle
 * @return array|null ['cycle' => string, 'price' => float]
 */
function snbd_dl_product_cycle_price(int $pid, int $currencyId, ?string $billingCycle = null): ?array
{
    try {
        $row = Capsule::table('tblpricing')
            ->where('type', 'product')
            ->where('relid', $pid)
            ->where('currency', $currencyId)
            ->first();

        if (!$row) {
            return null;
        }

        $cycleColumns = [
            'monthly'      => 'monthly',
            'quarterly'    => 'quarterly',
            'semiannually' => 'semiannually',
            'annually'     => 'annually',
            'biennially'   => 'biennially',
            'triennially'  => 'triennially',
        ];

        $cycle = $billingCycle ? strtolower($billingCycle) : null;

        if ($cycle === 'free') {
            return ['cycle' => 'free', 'price' => 0.0];
        }

        if ($cycle && isset($cycleColumns[$cycle]) && (float)$row->{$cycleColumns[$cycle]} >= 0) {
            return ['cycle' => $cycle, 'price' => (float)$row->{$cycleColumns[$cycle]}];
        }

        foreach ($cycleColumns as $name => $column) {
            if ((float)$row->{$column} >= 0) {
                return ['cycle' => $name, 'price' => (float)$row->{$column}];
            }
        }

        // One-time products keep their price in the setup column.
        if ((float)$row->msetupfee >= 0) {
            return ['cycle' => $cycle ?: 'onetime', 'price' => (float)$row->msetupfee];
        }
    } catch (\Throwable $e) { }

    return null;
}

/**
 * Registration or transfer price of a domain in a currency for a period.
 * tblpricing maps periods 1-6 years onto its six price columns.
 *
 * @param string $domain
 * @param int $period
 * @param int $currencyId
 * @param string $action 'register'|'transfer'
 * @return float|null Null when the TLD/cycle has no price configured.
 */
function snbd_dl_domain_period_price(string $domain, int $period, int $currencyId, string $action = 'register'): ?float
{
    try {
        $tld = strtolower(strrchr(trim($domain), '.'));
        if ($tld === '' || $tld === false) {
            return null;
        }

        $tldRow = Capsule::table('tbldomainpricing')->where('extension', $tld)->first();
        if (!$tldRow) {
            return null;
        }

        $pricingType = $action === 'transfer' ? 'domaintransfer' : 'domainregister';
        $row = Capsule::table('tblpricing')
            ->where('type', $pricingType)
            ->where('relid', $tldRow->id)
            ->where('currency', $currencyId)
            ->first();

        if (!$row) {
            return null;
        }

        $periodColumns = [
            1 => 'msetupfee',
            2 => 'qsetupfee',
            3 => 'ssetupfee',
            4 => 'asetupfee',
            5 => 'bsetupfee',
            6 => 'tsetupfee',
        ];

        $column = $periodColumns[min(max($period, 1), 6)] ?? 'tsetupfee';
        $price  = (float)$row->{$column};

        return $price >= 0 ? $price : null;
    } catch (\Throwable $e) { }

    return null;
}

/**
 * Flatten the WHMCS cart session into raw ecommerce items with real prices.
 *
 * Cart session entries carry no price, so prices are resolved from tblpricing
 * in the session's currency. Used by every ecommerce event so all of them
 * report the same currency and value.
 *
 * @param array $cartSession Contents of $_SESSION['cart'].
 * @param int|null $currencyId
 * @return array
 */
function snbd_dl_collect_cart_items(array $cartSession, ?int $currencyId = null): array
{
    $currencyId = $currencyId ?: snbd_dl_get_currency_id();
    $items = [];

    if (!empty($cartSession['products']) && is_array($cartSession['products'])) {
        foreach ($cartSession['products'] as $p) {
            $pid = (int)($p['pid'] ?? 0);
            if (!$pid) {
                continue;
            }
            $product = Capsule::table('tblproducts')->where('id', $pid)->first();
            $pGroup = $product ? Capsule::table('tblproductgroups')->where('id', $product->gid)->first() : null;

            $cycleInfo = snbd_dl_product_cycle_price($pid, $currencyId, $p['billingcycle'] ?? null);
            $variant   = $cycleInfo['cycle'] ?? strtolower($p['billingcycle'] ?? 'monthly');
            $price     = $cycleInfo['price'] ?? 0.0;

            $items[] = [
                'item_id'       => 'PROD-' . $pid,
                'product_id'    => $pid,
                'item_name'     => $product->name ?? 'Hosting Service',
                'item_category' => $pGroup->name ?? 'Hosting',
                'group_id'      => (int)($product->gid ?? 0),
                'item_variant'  => $variant,
                'price'         => round($price, 2),
                'quantity'      => 1,
            ];
        }
    }

    if (!empty($cartSession['domains']) && is_array($cartSession['domains'])) {
        foreach ($cartSession['domains'] as $d) {
            $domainName = $d['domain'] ?? '';
            if (!$domainName) {
                continue;
            }
            $action = ($d['type'] ?? 'register') === 'transfer' ? 'transfer' : 'register';
            $period = (int)($d['regperiod'] ?? 1);
            $price  = snbd_dl_domain_period_price($domainName, $period, $currencyId, $action);

            $items[] = [
                'item_id'       => 'DOMAIN-' . $domainName,
                'product_id'    => 0,
                'item_name'     => $domainName,
                'item_category' => $action === 'transfer' ? 'Domain Transfer' : 'Domain Registration',
                'group_id'      => 0,
                'item_variant'  => $period . 'year',
                'price'         => round($price ?? 0.0, 2),
                'quantity'      => 1,
            ];
        }
    }

    return $items;
}

/**
 * Detect items that entered or left the cart since the last page render and
 * queue add_to_cart / remove_from_cart for them.
 *
 * This runs on every client-area page render BEFORE the queue flush, and it is
 * the single source of add/remove events: the AJAX cart endpoint (a=addToCart)
 * never triggers ClientAreaPageCart, so per-request handlers miss exactly the
 * adds the store uses most. Item identity is the product id / domain name, so
 * a billing-cycle change does not re-fire add_to_cart.
 */
add_hook('ClientAreaHeadOutput', 0, function () {
    $cartSession = $_SESSION['cart'] ?? [];
    $currencyId  = snbd_dl_get_currency_id();
    $currency    = snbd_dl_get_currency();

    $currentItems = snbd_dl_collect_cart_items($cartSession, $currencyId);

    $current = [];
    foreach ($currentItems as $item) {
        $current[$item['item_id']] = $item;
    }

    $snapshot = $_SESSION['snbd_dl_item_snapshot'] ?? null;

    if (!is_array($snapshot)) {
        // First render of this session: record the starting cart, no events.
        $_SESSION['snbd_dl_item_snapshot'] = $current;
        return;
    }

    $added   = array_diff_key($current, $snapshot);
    $removed = array_diff_key($snapshot, $current);

    if (!empty($added)) {
        $formatted = snbd_dl_format_ecommerce_items(array_values($added));
        snbd_dl_queue_event([
            'event'     => 'add_to_cart',
            'ecommerce' => [
                'currency' => $currency,
                'value'    => $formatted['value'],
                'items'    => $formatted['items'],
            ],
        ]);
    }

    if (!empty($removed)) {
        $formatted = snbd_dl_format_ecommerce_items(array_values($removed));
        snbd_dl_queue_event([
            'event'     => 'remove_from_cart',
            'ecommerce' => [
                'currency' => $currency,
                'value'    => $formatted['value'],
                'items'    => $formatted['items'],
            ],
        ]);
    }

    $_SESSION['snbd_dl_item_snapshot'] = $current;
});

add_hook('ClientAreaPageCart', 1, function ($vars) {
    $cartSession = $_SESSION['cart'] ?? [];
    $currencyId  = snbd_dl_get_currency_id();
    $currency    = snbd_dl_get_currency();
    $action      = $_GET['a'] ?? 'view';

    $cartItems = snbd_dl_collect_cart_items($cartSession, $currencyId);
    if (empty($cartItems)) {
        return;
    }

    $formatted = snbd_dl_format_ecommerce_items($cartItems);

    if ($action === 'checkout') {
        snbd_dl_queue_event([
            'event'     => 'begin_checkout',
            'ecommerce' => [
                'currency' => $currency,
                'value'    => $formatted['value'],
                'coupon'   => $cartSession['promo'] ?? null,
                'items'    => $formatted['items'],
            ],
        ]);
        return;
    }

    if ($action === 'view') {
        snbd_dl_queue_event([
            'event'     => 'view_cart',
            'ecommerce' => [
                'currency' => $currency,
                'value'    => $formatted['value'],
                'items'    => $formatted['items'],
            ],
        ]);
    }
});

/* ==========================================================================
   6. PURCHASE / ORDER ACCEPTANCE (DEDICATED CONVERSION EVENT)
   ========================================================================== */

/**
 * Build the GA4 `purchase` ecommerce payload for a WHMCS order.
 *
 * Shared by the AcceptOrder hook (admin / automatic acceptance) and the cart
 * complete page hook, so both paths emit an identical transaction.
 *
 * @param int|string $orderId
 * @return array|null Null when the order cannot be resolved.
 */
function snbd_dl_build_purchase_payload($orderId): ?array
{
    if (!$orderId) {
        return null;
    }

    try {
        $order = Capsule::table('tblorders')->where('id', $orderId)->first();
        if (!$order) {
            return null;
        }

        // Price the order in the currency the order was placed in, not the
        // currency of whoever happens to own the current session (the gateway
        // callback and the admin area both run outside the buyer's session).
        $currency = snbd_dl_get_currency($order->currency ?? null);
        $rawItems = [];

        // Fetch products in order
        $hostingItems = Capsule::table('tblhosting')
            ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
            ->where('tblhosting.orderid', $orderId)
            ->select(
                'tblhosting.packageid as product_id',
                'tblproducts.name as item_name',
                'tblproducts.gid as group_id',
                'tblhosting.billingcycle as item_variant',
                'tblhosting.amount as price'
            )
            ->get();

        foreach ($hostingItems as $h) {
            $pGroup = Capsule::table('tblproductgroups')->where('id', $h->group_id)->first();
            $rawItems[] = [
                'item_id'       => 'PROD-' . $h->product_id,
                'product_id'    => (int)$h->product_id,
                'item_name'     => $h->item_name,
                'item_category' => $pGroup->name ?? 'Hosting',
                'group_id'      => (int)$h->group_id,
                'item_variant'  => strtolower($h->item_variant),
                'price'         => (float)$h->price,
                'quantity'      => 1,
            ];
        }

        // Fetch domains in order
        $domainItems = Capsule::table('tbldomains')
            ->where('orderid', $orderId)
            ->get();

        foreach ($domainItems as $d) {
            $rawItems[] = [
                'item_id'       => 'DOMAIN-' . $d->domain,
                'product_id'    => 0,
                'item_name'     => $d->domain,
                'item_category' => 'Domain Registration',
                'group_id'      => 0,
                'item_variant'  => ($d->registrationperiod ?? 1) . 'year',
                'price'         => (float)$d->firstpaymentamount,
                'quantity'      => 1,
            ];
        }

        $formatted = snbd_dl_format_ecommerce_items($rawItems);
        $paymentType = $order->paymentmethod ?? 'Unknown';
        $promoCode = $order->promocode ?? null;

        // Affiliate Tracking: Detect affiliate ID from order, cookie, or session
        $affiliateId = null;
        if (!empty($order->affiliateid) && (int)$order->affiliateid > 0) {
            $affiliateId = (int)$order->affiliateid;
        } elseif (!empty($_COOKIE['WHMCSAffiliate'])) {
            $affiliateId = (int)$_COOKIE['WHMCSAffiliate'];
        } elseif (!empty($_SESSION['affiliateid'])) {
            $affiliateId = (int)$_SESSION['affiliateid'];
        }

        $affiliateUserId = null;
        if ($affiliateId) {
            try {
                $affRecord = Capsule::table('tblaffiliates')->where('id', $affiliateId)->first();
                if ($affRecord && !empty($affRecord->clientid)) {
                    $affiliateUserId = snbd_dl_hash_user_id($affRecord->clientid);
                }
            } catch (\Throwable $e) { }
        }

        return [
            'event'     => 'purchase',
            'ecommerce' => [
                'transaction_id'    => 'ORD-' . $orderId,
                'affiliation'       => SNBD_DL_AFFILIATION,
                'affiliate_id'      => $affiliateId,
                'affiliate_user_id' => $affiliateUserId,
                'value'             => $formatted['value'],
                'tax'               => 0.00,
                'currency'          => $currency,
                'coupon'            => $promoCode,
                'payment_type'      => $paymentType,
                'items'             => $formatted['items'],
            ],
        ];
    } catch (\Throwable $e) {
        return null;
    }
}

/**
 * Queue a purchase exactly once per transaction id, whichever hook gets there
 * first. Without this, an order accepted while the buyer is still on the cart
 * would report the same revenue twice.
 *
 * @param array|null $payload
 * @return bool True when the event was queued by this call.
 */
function snbd_dl_queue_purchase_once(?array $payload): bool
{
    if (!$payload) {
        return false;
    }

    $txnId = $payload['ecommerce']['transaction_id'] ?? null;
    if (!$txnId) {
        return false;
    }

    if (!isset($_SESSION['snbd_dl_sent_purchases']) || !is_array($_SESSION['snbd_dl_sent_purchases'])) {
        $_SESSION['snbd_dl_sent_purchases'] = [];
    }

    if (in_array($txnId, $_SESSION['snbd_dl_sent_purchases'], true)) {
        return false;
    }

    $_SESSION['snbd_dl_sent_purchases'][] = $txnId;
    snbd_dl_queue_event($payload);

    return true;
}

add_hook('AcceptOrder', 1, function ($vars) {
    snbd_dl_queue_purchase_once(
        snbd_dl_build_purchase_payload($vars['orderid'] ?? null)
    );
});

/**
 * Order complete page — the only purchase path guaranteed to run inside the
 * buyer's own browser session. AcceptOrder alone loses the conversion whenever
 * acceptance happens in a gateway callback or in the admin area, because the
 * queued event is written to the wrong session and never renders.
 */
add_hook('ShoppingCartCheckoutCompletePage', 1, function ($vars) {
    $orderId = $vars['orderid']
        ?? $vars['orderId']
        ?? ($_SESSION['cartorderid'] ?? null);

    // Queued here, flushed by the footer hook on this same page view.
    snbd_dl_queue_purchase_once(snbd_dl_build_purchase_payload($orderId));
});

/**
 * add_payment_info — fires when the buyer submits checkout with a payment
 * method chosen. ShoppingCartValidateCheckout is the last server-side point
 * before WHMCS creates the order, and it runs in the buyer's own session.
 */
add_hook('ShoppingCartValidateCheckout', 1, function ($vars) {
    try {
        $cartSession = $_SESSION['cart'] ?? [];
        $currencyId  = snbd_dl_get_currency_id();
        $rawItems    = snbd_dl_collect_cart_items($cartSession, $currencyId);

        if (empty($rawItems)) {
            return;
        }

        $formatted = snbd_dl_format_ecommerce_items($rawItems);
        $currency  = snbd_dl_get_currency();

        $paymentType = $_REQUEST['paymentmethod']
            ?? ($cartSession['paymentmethod'] ?? 'Unknown');

        snbd_dl_queue_event([
            'event'     => 'add_payment_info',
            'ecommerce' => [
                'currency'     => $currency,
                'value'        => $formatted['value'],
                'coupon'       => $cartSession['promo'] ?? null,
                'payment_type' => (string)$paymentType,
                'items'        => $formatted['items'],
            ],
        ]);
    } catch (\Throwable $e) { }

    // Must not return a string: WHMCS treats any returned string as a
    // validation error and blocks the checkout.
});

/* ==========================================================================
   7. INVOICE EVENTS
   ========================================================================== */

add_hook('InvoiceCreated', 1, function ($vars) {
    $invoiceId = $vars['invoiceid'] ?? null;
    if (!$invoiceId) {
        return;
    }

    try {
        $invoice = Capsule::table('tblinvoices')->where('id', $invoiceId)->first();
        if ($invoice) {
            snbd_dl_queue_event([
                'event'       => 'invoice_created',
                'invoice_id'  => (int)$invoice->id,
                'invoice_num' => $invoice->invoicenum ? 'INV-' . $invoice->invoicenum : 'INV-' . $invoice->id,
                'value'       => (float)$invoice->total,
                'currency'    => snbd_dl_get_currency(),
                'status'      => $invoice->status,
                'user_id'     => snbd_dl_hash_user_id($invoice->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

add_hook('InvoicePaid', 1, function ($vars) {
    $invoiceId = $vars['invoiceid'] ?? null;
    if (!$invoiceId) {
        return;
    }

    try {
        $invoice = Capsule::table('tblinvoices')->where('id', $invoiceId)->first();
        if (!$invoice) {
            return;
        }

        // Check if invoice is linked to a new order
        $order = Capsule::table('tblorders')->where('invoiceid', $invoiceId)->first();
        $invoiceType = $order ? 'new_order' : 'renewal';
        $orderId = $order ? (int)$order->id : null;

        snbd_dl_queue_event([
            'event'          => 'invoice_paid',
            'invoice_id'     => (int)$invoice->id,
            'invoice_num'    => $invoice->invoicenum ? 'INV-' . $invoice->invoicenum : 'INV-' . $invoice->id,
            'value'          => (float)$invoice->total,
            'currency'       => snbd_dl_get_currency(),
            'payment_method' => $invoice->paymentmethod ?? 'Unknown',
            'invoice_type'   => $invoiceType,
            'order_id'       => $orderId,
            'user_id'        => snbd_dl_hash_user_id($invoice->userid),
        ]);
    } catch (\Throwable $e) { }
});

add_hook('InvoiceRefunded', 1, function ($vars) {
    $invoiceId = $vars['invoiceid'] ?? null;
    if (!$invoiceId) {
        return;
    }

    try {
        $invoice = Capsule::table('tblinvoices')->where('id', $invoiceId)->first();
        if ($invoice) {
            snbd_dl_queue_event([
                'event'      => 'invoice_refunded',
                'invoice_id' => (int)$invoice->id,
                'value'      => (float)$invoice->total,
                'currency'   => snbd_dl_get_currency(),
                'user_id'    => snbd_dl_hash_user_id($invoice->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

add_hook('InvoiceCancelled', 1, function ($vars) {
    $invoiceId = $vars['invoiceid'] ?? null;
    if (!$invoiceId) {
        return;
    }

    try {
        $invoice = Capsule::table('tblinvoices')->where('id', $invoiceId)->first();
        if ($invoice) {
            snbd_dl_queue_event([
                'event'      => 'invoice_cancelled',
                'invoice_id' => (int)$invoice->id,
                'value'      => (float)$invoice->total,
                'currency'   => snbd_dl_get_currency(),
                'user_id'    => snbd_dl_hash_user_id($invoice->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

/* ==========================================================================
   8. SERVICE LIFECYCLE EVENTS
   ========================================================================== */

add_hook('AfterModuleCreate', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $serviceId = $params['serviceid'] ?? null;
    if (!$serviceId) {
        return;
    }

    try {
        $hosting = Capsule::table('tblhosting')
            ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
            ->where('tblhosting.id', $serviceId)
            ->select('tblhosting.*', 'tblproducts.name as product_name', 'tblproducts.gid')
            ->first();

        if ($hosting) {
            $pGroup = Capsule::table('tblproductgroups')->where('id', $hosting->gid)->first();
            snbd_dl_queue_event([
                'event'         => 'service_provisioned',
                'service_id'    => (int)$hosting->id,
                'product_id'    => (int)$hosting->packageid,
                'product_name'  => $hosting->product_name,
                'product_group' => $pGroup->name ?? 'Hosting',
                'domain'        => $hosting->domain,
                'billing_cycle' => strtolower($hosting->billingcycle),
                'user_id'       => snbd_dl_hash_user_id($hosting->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

add_hook('AfterModuleSuspend', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $serviceId = $params['serviceid'] ?? null;
    if ($serviceId) {
        try {
            $hosting = Capsule::table('tblhosting')
                ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
                ->where('tblhosting.id', $serviceId)
                ->select('tblhosting.*', 'tblproducts.name as product_name')
                ->first();

            if ($hosting) {
                snbd_dl_queue_event([
                    'event'          => 'service_suspended',
                    'service_id'     => (int)$hosting->id,
                    'product_name'   => $hosting->product_name,
                    'domain'         => $hosting->domain,
                    'suspend_reason' => $hosting->suspendreason ?? 'overdue',
                    'user_id'        => snbd_dl_hash_user_id($hosting->userid),
                ]);
            }
        } catch (\Throwable $e) { }
    }
});

add_hook('AfterModuleUnsuspend', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $serviceId = $params['serviceid'] ?? null;
    if ($serviceId) {
        try {
            $hosting = Capsule::table('tblhosting')
                ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
                ->where('tblhosting.id', $serviceId)
                ->select('tblhosting.*', 'tblproducts.name as product_name')
                ->first();

            if ($hosting) {
                snbd_dl_queue_event([
                    'event'        => 'service_unsuspended',
                    'service_id'   => (int)$hosting->id,
                    'product_name' => $hosting->product_name,
                    'domain'       => $hosting->domain,
                    'user_id'      => snbd_dl_hash_user_id($hosting->userid),
                ]);
            }
        } catch (\Throwable $e) { }
    }
});

add_hook('AfterModuleTerminate', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $serviceId = $params['serviceid'] ?? null;
    if ($serviceId) {
        try {
            $hosting = Capsule::table('tblhosting')
                ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
                ->where('tblhosting.id', $serviceId)
                ->select('tblhosting.*', 'tblproducts.name as product_name')
                ->first();

            if ($hosting) {
                snbd_dl_queue_event([
                    'event'        => 'service_terminated',
                    'service_id'   => (int)$hosting->id,
                    'product_name' => $hosting->product_name,
                    'domain'       => $hosting->domain,
                    'user_id'      => snbd_dl_hash_user_id($hosting->userid),
                ]);
            }
        } catch (\Throwable $e) { }
    }
});

/* ==========================================================================
   9. TICKET / SUPPORT EVENTS
   ========================================================================== */

add_hook('TicketOpen', 1, function ($vars) {
    $ticketId = $vars['ticketid'] ?? null;
    if (!$ticketId) {
        return;
    }

    try {
        $ticket = Capsule::table('tbltickets')->where('id', $ticketId)->first();
        if ($ticket) {
            $dept = Capsule::table('tblticketdepartments')->where('id', $ticket->did)->first();
            snbd_dl_queue_event([
                'event'         => 'ticket_opened',
                'ticket_id'     => $ticket->tid,
                'ticket_db_id'  => (int)$ticket->id,
                'department'    => $dept->name ?? 'General Support',
                'department_id' => (int)$ticket->did,
                'priority'      => $ticket->urgency,
                'subject'       => substr($ticket->title, 0, 100),
                'user_id'       => snbd_dl_hash_user_id($ticket->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

add_hook('TicketUserReply', 1, function ($vars) {
    $ticketId = $vars['ticketid'] ?? null;
    if (!$ticketId) {
        return;
    }

    try {
        $ticket = Capsule::table('tbltickets')->where('id', $ticketId)->first();
        if ($ticket) {
            snbd_dl_queue_event([
                'event'        => 'ticket_replied',
                'ticket_id'    => $ticket->tid,
                'ticket_db_id' => (int)$ticket->id,
                'user_id'      => snbd_dl_hash_user_id($ticket->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

add_hook('TicketClose', 1, function ($vars) {
    $ticketId = $vars['ticketid'] ?? null;
    if (!$ticketId) {
        return;
    }

    try {
        $ticket = Capsule::table('tbltickets')->where('id', $ticketId)->first();
        if ($ticket) {
            snbd_dl_queue_event([
                'event'        => 'ticket_closed',
                'ticket_id'    => $ticket->tid,
                'ticket_db_id' => (int)$ticket->id,
                'user_id'      => snbd_dl_hash_user_id($ticket->userid),
            ]);
        }
    } catch (\Throwable $e) { }
});

/* ==========================================================================
   10. DOMAIN REGISTRAR EVENTS
   ========================================================================== */

add_hook('AfterRegistrarRegistration', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $sld = $params['sld'] ?? '';
    $tld = $params['tld'] ?? '';
    $domain = trim($sld . '.' . $tld, '.');

    if ($domain) {
        snbd_dl_queue_event([
            'event'               => 'domain_registered',
            'domain'              => $domain,
            'tld'                 => '.' . ltrim($tld, '.'),
            'registration_period' => (int)($params['regperiod'] ?? 1),
            'registrar'           => $params['registrar'] ?? 'Unknown',
            'user_id'             => snbd_dl_hash_user_id($_SESSION['uid'] ?? null),
        ]);
    }
});

add_hook('AfterRegistrarTransfer', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $sld = $params['sld'] ?? '';
    $tld = $params['tld'] ?? '';
    $domain = trim($sld . '.' . $tld, '.');

    if ($domain) {
        snbd_dl_queue_event([
            'event'     => 'domain_transferred',
            'domain'    => $domain,
            'tld'       => '.' . ltrim($tld, '.'),
            'registrar' => $params['registrar'] ?? 'Unknown',
            'user_id'   => snbd_dl_hash_user_id($_SESSION['uid'] ?? null),
        ]);
    }
});

add_hook('AfterRegistrarRenewal', 1, function ($vars) {
    $params = $vars['params'] ?? [];
    $sld = $params['sld'] ?? '';
    $tld = $params['tld'] ?? '';
    $domain = trim($sld . '.' . $tld, '.');

    if ($domain) {
        snbd_dl_queue_event([
            'event'          => 'domain_renewed',
            'domain'         => $domain,
            'tld'            => '.' . ltrim($tld, '.'),
            'renewal_period' => (int)($params['regperiod'] ?? 1),
            'registrar'      => $params['registrar'] ?? 'Unknown',
            'user_id'        => snbd_dl_hash_user_id($_SESSION['uid'] ?? null),
        ]);
    }
});

/* ==========================================================================
   11. CLIENT PROFILE & AFFILIATE EVENTS
   ========================================================================== */

add_hook('ClientEdit', 1, function ($vars) {
    $userId = $vars['userid'] ?? null;
    if (!$userId) {
        return;
    }

    $changedFields = [];
    $possibleFields = ['firstname', 'lastname', 'email', 'companyname', 'address1', 'city', 'state', 'postcode', 'country', 'phonenumber'];
    foreach ($possibleFields as $field) {
        if (isset($vars[$field])) {
            $changedFields[] = $field;
        }
    }

    snbd_dl_queue_event([
        'event'          => 'profile_updated',
        'user_id'        => snbd_dl_hash_user_id($userId),
        'fields_changed' => $changedFields,
    ]);
});

add_hook('AffiliateActivation', 1, function ($vars) {
    $affiliateId = $vars['affiliateid'] ?? null;
    $userId = $vars['userid'] ?? null;

    if ($affiliateId) {
        snbd_dl_queue_event([
            'event'        => 'affiliate_activated',
            'affiliate_id' => (int)$affiliateId,
            'user_id'      => snbd_dl_hash_user_id($userId),
        ]);
    }
});

add_hook('AffiliateCommission', 1, function ($vars) {
    $affiliateId = $vars['affiliateid'] ?? null;
    $amount = (float)($vars['amount'] ?? 0.0);
    $referralId = $vars['referrerid'] ?? ($vars['serviceid'] ?? null);

    if ($affiliateId) {
        snbd_dl_queue_event([
            'event'             => 'affiliate_commission',
            'affiliate_id'      => (int)$affiliateId,
            'commission_amount' => round($amount, 2),
            'currency'          => snbd_dl_get_currency(),
            'referral_id'       => $referralId ? (int)$referralId : null,
            'user_id'           => snbd_dl_hash_user_id($_SESSION['uid'] ?? null),
        ]);
    }
});
