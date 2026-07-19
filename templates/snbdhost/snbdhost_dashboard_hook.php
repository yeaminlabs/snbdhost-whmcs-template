<?php
/**
 * SNBD Host Dashboard Hook
 * Provides $invoices, $services, and $loyalty_data for the clientareahome.tpl dashboard template.
 *
 * INSTALLATION: Copy this file to your WHMCS: /includes/hooks/snbdhost_dashboard_hook.php
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

use WHMCS\Database\Capsule;

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
            $invoices[] = [
                'id'          => $row->id,
                'invoicenum'  => $row->invoicenum ?: '#' . $row->id,
                'datecreated' => date('M j, Y', strtotime($row->date)),
                'total'       => $prefix . number_format((float)$row->total, 2) . $suffix,
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
                'amount'      => $prefix . number_format((float)$p->amount, 2) . $suffix,
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

