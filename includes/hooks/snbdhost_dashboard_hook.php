<?php
/**
 * SNBD Host Dashboard Hook
 * Provides $invoices, $services, and $loyalty_data for the clientareahome.tpl dashboard template.
 * Exposes active product groups and their products for custom referral link generation.
 *
 * INSTALLATION: Placed automatically in WHMCS /includes/hooks/
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

if (!function_exists('snbd_format_currency')) {
    function snbd_format_currency($amount, $prefix = '$', $suffix = ' USD') {
        $val = (float)$amount;
        $isNegative = $val < 0;
        $formattedNum = number_format(abs($val), 2);
        
        $suffixStr = '';
        if (!empty($suffix)) {
            $trimmed = trim($suffix);
            if ($trimmed !== '') {
                $suffixStr = ' ' . $trimmed;
            }
        }
        
        return ($isNegative ? '-' : '') . $prefix . $formattedNum . $suffixStr;
    }
}

add_hook('ClientAreaPageHome', 1, function($vars) {

    if (empty($vars['clientsdetails']['userid'])) {
        return [];
    }

    $userid    = (int) $vars['clientsdetails']['userid'];
    $invoices  = [];
    $services  = [];
    $loyalty   = null;

    // Default currency values to prevent undefined variable errors
    $prefix = '$';
    $suffix = ' USD';

    // ------ Recent Invoices ------
    try {
        $client   = Capsule::table('tblclients')->where('id', $userid)->first();
        if ($client) {
            $currId   = (int)$client->currency;
            $currency = Capsule::table('tblcurrencies')->where('id', $currId)->first();
            if ($currency) {
                $prefix = $currency->prefix;
                $suffix = $currency->suffix;
            }
        }

        $rows = Capsule::table('tblinvoices')
            ->where('userid', $userid)
            ->orderBy('id', 'desc')
            ->limit(5)
            ->get();

        foreach ($rows as $row) {
            $rawNum = $row->invoicenum ? ltrim(trim($row->invoicenum), '#') : $row->id;
            $invoices[] = [
                'id'          => $row->id,
                'invoicenum'  => $rawNum,
                'datecreated' => date('M j, Y', strtotime($row->date)),
                'datedue'     => ($row->duedate && $row->duedate !== '0000-00-00')
                                  ? date('M j, Y', strtotime($row->duedate)) : '—',
                'total'       => snbd_format_currency($row->total, $prefix, $suffix),
                'status'      => ucfirst(strtolower($row->status)),
            ];
        }
    } catch (\Throwable $e) { 
        // Log error if needed: logActivity("SNBD Hook Error (Invoices): " . $e->getMessage());
    }

    // ------ Active Services ------
    try {
        $products = Capsule::table('tblhosting')
            ->join('tblproducts', 'tblhosting.packageid', '=', 'tblproducts.id')
            ->where('tblhosting.userid', $userid)
            ->whereIn('tblhosting.domainstatus', ['Active', 'Pending'])
            ->select(
                'tblhosting.id',
                'tblhosting.domain',
                'tblhosting.domainstatus as status',
                'tblhosting.nextduedate',
                'tblhosting.amount',
                'tblhosting.billingcycle',
                'tblproducts.name as product'
            )
            ->orderBy('tblhosting.domainstatus')
            ->orderBy('tblhosting.nextduedate')
            ->get();

        foreach ($products as $p) {
            $services[] = [
                'id'          => $p->id,
                'product'     => $p->product,
                'domain'      => $p->domain,
                'status'      => ucfirst(strtolower($p->status)),
                'nextduedate' => ($p->nextduedate && $p->nextduedate !== '0000-00-00')
                                  ? date('M j, Y', strtotime($p->nextduedate)) : '—',
                'amount'      => snbd_format_currency($p->amount, $prefix, $suffix),
                'billingcycle'=> $p->billingcycle,
            ];
        }
    } catch (\Throwable $e) { }

    // ------ Loyalty Matrix Widget ------
    try {
        $loyaltyClient = Capsule::table('mod_loyaltymatrix_client_tiers')
            ->join('mod_loyaltymatrix_tiers', 'mod_loyaltymatrix_client_tiers.tier_id', '=', 'mod_loyaltymatrix_tiers.id')
            ->where('mod_loyaltymatrix_client_tiers.client_id', $userid)
            ->select('mod_loyaltymatrix_tiers.name as tier_name', 'mod_loyaltymatrix_tiers.discount')
            ->first();

        if ($loyaltyClient) {
            $loyalty = [
                'tier'         => $loyaltyClient->tier_name ? ucfirst($loyaltyClient->tier_name) : 'Entry Tier',
                'discount'     => number_format((float)$loyaltyClient->discount, 2) . '%',
                'url'          => 'index.php?m=loyaltymatrix',
            ];

            // Next tier info
            $nextTier = Capsule::table('mod_loyaltymatrix_tiers')
                ->where('discount', '>', $loyaltyClient->discount)
                ->orderBy('discount', 'asc')
                ->first();

            if ($nextTier) {
                $loyalty['next_tier']      = ucfirst($nextTier->name);
                $loyalty['next_discount']  = number_format((float)$nextTier->discount, 2) . '%';
            }
        }
    } catch (\Throwable $e) { }

    // ------ Open Support Tickets ------
    $openTickets = [];
    try {
        $rows = Capsule::table('tbltickets')
            ->where('userid', $userid)
            ->whereNotIn('status', ['Closed', 'Answered'])
            ->orderBy('lastreply', 'desc')
            ->limit(5)
            ->get();

        foreach ($rows as $row) {
            $openTickets[] = [
                'id'         => $row->id,
                'tid'        => $row->tid,
                'title'      => $row->title,
                'status'     => $row->status,
                'c'          => $row->c,
                'lastreply'  => date('M j, Y', strtotime($row->lastreply)),
            ];
        }
    } catch (\Throwable $e) { }

    return [
        'invoices'     => $invoices,
        'services'     => $services,
        'loyalty_data' => $loyalty,
        'open_tickets' => $openTickets,
    ];
});

/**
 * ClientAreaPage Hook
 * Feeds the shell notification menu ($snbdNotifications) on every client area page:
 * unpaid invoices and tickets that still need the client's attention.
 */
add_hook('ClientAreaPage', 1, function ($vars) {
    if (empty($vars['clientsdetails']['userid'])) {
        return [];
    }

    $userid = (int) $vars['clientsdetails']['userid'];
    $items  = [];
    $counts = ['unpaidInvoices' => 0, 'openTickets' => 0];

    try {
        $counts['unpaidInvoices'] = (int) Capsule::table('tblinvoices')
            ->where('userid', $userid)
            ->whereIn('status', ['Unpaid', 'Overdue', 'Payment Pending'])
            ->count();

        if ($counts['unpaidInvoices'] > 0) {
            $items[] = [
                'severity' => 'warn',
                'icon'     => 'ti-receipt',
                'title'    => $counts['unpaidInvoices'] . ' unpaid invoice' . ($counts['unpaidInvoices'] === 1 ? '' : 's'),
                'meta'     => 'Review and settle your balance',
                'url'      => 'clientarea.php?action=invoices',
            ];
        }
    } catch (\Throwable $e) { }

    try {
        $counts['openTickets'] = (int) Capsule::table('tbltickets')
            ->where('userid', $userid)
            ->whereNotIn('status', ['Closed'])
            ->count();

        if ($counts['openTickets'] > 0) {
            $items[] = [
                'severity' => 'info',
                'icon'     => 'ti-lifebuoy',
                'title'    => $counts['openTickets'] . ' open ticket' . ($counts['openTickets'] === 1 ? '' : 's'),
                'meta'     => 'Check the latest replies',
                'url'      => 'supporttickets.php',
            ];
        }
    } catch (\Throwable $e) { }

    return [
        'snbdNotifications' => [
            'total'       => $counts['unpaidInvoices'] + $counts['openTickets'],
            'openTickets' => $counts['openTickets'],
            'items'       => $items,
        ],
    ];
});

/**
 * ClientAreaPage Hook
 * Tells the shell whether the page being rendered has its own template in this
 * theme ($snbdCustomTemplate). The header uses it to load one Bootstrap and the
 * matching stylesheets, so a page opts into the SNBD design system by existing
 * as a template file rather than by being named in a list.
 *
 * Also flags the login, registration and password pages ($snbdAuthPage) so the
 * header and the footer agree on whether the shell was opened. Setting it here
 * rather than with {assign} in header.tpl matters: Smarty {assign} only lives in
 * the scope of the template that runs it, so the footer never saw the header's
 * value and closed a shell that the auth pages had not opened.
 */
add_hook('ClientAreaPage', 1, function ($vars) {
    $template = ltrim(str_replace(['..', '\\', "\0"], '', (string) ($vars['templatefile'] ?? '')), '/');

    if ($template === '') {
        return ['snbdCustomTemplate' => false, 'snbdAuthPage' => false];
    }

    $theme = empty($vars['template']) ? 'snbdhost' : (string) $vars['template'];
    $root  = defined('ROOTDIR') ? ROOTDIR : dirname(__DIR__, 2);

    return [
        'snbdCustomTemplate' => is_file($root . '/templates/' . $theme . '/' . $template . '.tpl'),
        'snbdAuthPage' => in_array($template, ['login', 'clientregister', 'pwreset'], true)
            || str_starts_with($template, 'password-'),
    ];
});

/**
 * ClientAreaPageAffiliates Hook
 * Exposes active product groups and their products for custom referral link generation.
 */
add_hook('ClientAreaPageAffiliates', 1, function($vars) {
    $productGroups = [];
    try {
        $groups = Capsule::table('tblproductgroups')
            ->where('hidden', 0)
            ->orderBy('order', 'asc')
            ->get();
            
        foreach ($groups as $group) {
            $products = Capsule::table('tblproducts')
                ->where('gid', $group->id)
                ->where('hidden', 0)
                ->orderBy('order', 'asc')
                ->select('id', 'name')
                ->get();
                
            $productList = [];
            foreach ($products as $product) {
                $productList[] = [
                    'id'   => $product->id,
                    'name' => $product->name,
                ];
            }
            
            $productGroups[] = [
                'id'       => $group->id,
                'name'     => $group->name,
                'products' => $productList,
            ];
        }
    } catch (\Throwable $e) {}
    
    return [
        'affiliateProductGroups' => $productGroups,
    ];
});
