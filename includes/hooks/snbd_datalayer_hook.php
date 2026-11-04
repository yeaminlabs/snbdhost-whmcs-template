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
    if (!empty($_SESSION['snbd_dl_queue']) && is_array($_SESSION['snbd_dl_queue'])) {
        foreach ($_SESSION['snbd_dl_queue'] as $queuedEvent) {
            if (isset($queuedEvent['ecommerce'])) {
                $script .= "dataLayer.push({ ecommerce: null });\n";
            }
            $script .= "dataLayer.push(" . json_encode($queuedEvent, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . ");\n";
        }
        $_SESSION['snbd_dl_queue'] = [];
    }

    $script .= "</script>\n";

    return $script;
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

add_hook('ClientAreaPageCart', 1, function ($vars) {
    $action = $_GET['a'] ?? 'view';
    $cartSession = $_SESSION['cart'] ?? [];
    $currency = snbd_dl_get_currency();

    // Snapshot current cart for removal comparisons
    $currentCartItems = [];
    if (!empty($cartSession['products']) && is_array($cartSession['products'])) {
        foreach ($cartSession['products'] as $pIdx => $p) {
            $pid = (int)($p['pid'] ?? 0);
            $product = Capsule::table('tblproducts')->where('id', $pid)->first();
            $pGroup = $product ? Capsule::table('tblproductgroups')->where('id', $product->gid)->first() : null;

            $currentCartItems[] = [
                'item_id'       => 'PROD-' . $pid,
                'product_id'    => $pid,
                'item_name'     => $product->name ?? 'Hosting Service',
                'item_category' => $pGroup->name ?? 'Hosting',
                'group_id'      => (int)($product->gid ?? 0),
                'item_variant'  => strtolower($p['billingcycle'] ?? 'monthly'),
                'price'         => (float)($p['price'] ?? 0.0),
                'quantity'      => 1,
                'cart_index'    => $pIdx,
            ];
        }
    }

    if (!empty($cartSession['domains']) && is_array($cartSession['domains'])) {
        foreach ($cartSession['domains'] as $dIdx => $d) {
            $domainName = $d['domain'] ?? 'domain.com';
            $currentCartItems[] = [
                'item_id'       => 'DOMAIN-' . $domainName,
                'product_id'    => 0,
                'item_name'     => $domainName,
                'item_category' => 'Domain Registration',
                'group_id'      => 0,
                'item_variant'  => ($d['regperiod'] ?? 1) . 'year',
                'price'         => (float)($d['price'] ?? 0.0),
                'quantity'      => 1,
                'cart_index'    => 'd_' . $dIdx,
            ];
        }
    }

    // Handle cart.php?a=remove URL parameter detection
    if ($action === 'remove' && isset($_GET['i'])) {
        $snapshot = $_SESSION['snbd_dl_cart_snapshot'] ?? [];
        $removeIndex = $_GET['i'];
        $removeType  = $_GET['r'] ?? 'p';

        $removedItem = null;
        if (!empty($snapshot)) {
            foreach ($snapshot as $sItem) {
                if ($removeType === 'p' && (string)($sItem['cart_index'] ?? '') === (string)$removeIndex) {
                    $removedItem = $sItem;
                    break;
                } elseif ($removeType === 'd' && (string)($sItem['cart_index'] ?? '') === ('d_' . $removeIndex)) {
                    $removedItem = $sItem;
                    break;
                }
            }
        }

        if ($removedItem) {
            $formattedRem = snbd_dl_format_ecommerce_items([$removedItem]);
            snbd_dl_queue_event([
                'event'     => 'remove_from_cart',
                'ecommerce' => [
                    'currency' => $currency,
                    'value'    => $formattedRem['value'],
                    'items'    => $formattedRem['items'],
                ],
            ]);
        }
    }

    // Handle cart.php?a=add URL parameter detection
    if ($action === 'add' && isset($_GET['pid'])) {
        $addedPid = (int)$_GET['pid'];
        $product = Capsule::table('tblproducts')->where('id', $addedPid)->first();
        if ($product) {
            $pGroup = Capsule::table('tblproductgroups')->where('id', $product->gid)->first();
            $addedItem = [
                'item_id'       => 'PROD-' . $addedPid,
                'product_id'    => $addedPid,
                'item_name'     => $product->name,
                'item_category' => $pGroup->name ?? 'Hosting',
                'group_id'      => (int)$product->gid,
                'item_variant'  => 'monthly',
                'price'         => 0.0, // WHMCS pricing calculated on config step
                'quantity'      => 1,
            ];
            $formattedAdd = snbd_dl_format_ecommerce_items([$addedItem]);
            snbd_dl_queue_event([
                'event'     => 'add_to_cart',
                'ecommerce' => [
                    'currency' => $currency,
                    'value'    => $formattedAdd['value'],
                    'items'    => $formattedAdd['items'],
                ],
            ]);
        }
    }

    // Save snapshot for next removal check
    $_SESSION['snbd_dl_cart_snapshot'] = $currentCartItems;

    // View Cart or Begin Checkout page view events
    if ($action === 'view' && !empty($currentCartItems)) {
        $formattedCart = snbd_dl_format_ecommerce_items($currentCartItems);
        return [
            'snbd_dl_event' => [
                'event'     => 'view_cart',
                'ecommerce' => [
                    'currency' => $currency,
                    'value'    => $formattedCart['value'],
                    'items'    => $formattedCart['items'],
                ],
            ],
        ];
    } elseif ($action === 'checkout' && !empty($currentCartItems)) {
        $formattedCart = snbd_dl_format_ecommerce_items($currentCartItems);
        $coupon = $cartSession['promo'] ?? null;
        return [
            'snbd_dl_event' => [
                'event'     => 'begin_checkout',
                'ecommerce' => [
                    'currency' => $currency,
                    'value'    => $formattedCart['value'],
                    'coupon'   => $coupon,
                    'items'    => $formattedCart['items'],
                ],
            ],
        ];
    }
});

/* ==========================================================================
   6. PURCHASE / ORDER ACCEPTANCE (DEDICATED CONVERSION EVENT)
   ========================================================================== */

add_hook('AcceptOrder', 1, function ($vars) {
    $orderId   = $vars['orderid'] ?? null;
    $invoiceId = $vars['invoiceid'] ?? null;

    if (!$orderId) {
        return;
    }

    try {
        $order = Capsule::table('tblorders')->where('id', $orderId)->first();
        if (!$order) {
            return;
        }

        $currency = snbd_dl_get_currency();
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

        snbd_dl_queue_event([
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
        ]);
    } catch (\Throwable $e) { }
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
