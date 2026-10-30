<?php
/**
 * SNBD SEO Head Hook
 *
 * Fixes every Screpy signal on portal.snbdhost.com:
 *   - Proper page title  (fixes short_titles — pagetitle returned from ClientAreaPage)
 *   - Canonical link tag (fixes canonical_issues)
 *   - Meta description   (fixes missing_descriptions)
 *   - noindex/nofollow   (portal pages should not be indexed)
 *   - HSTS header        (fixes missing_hsts)
 *   - CSP header         (fixes missing_csp)
 *
 * INSTALLATION: Copy to WHMCS /includes/hooks/snbd_seo_head.php
 */

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

// ── Helper defined at file scope (not inside a closure) ──────────────────────
if (!function_exists('snbd_get_page_meta')) {
    function snbd_get_page_meta(string $uri): array {
        $map = [
            'submitticket.php?step=2' => [
                'title'       => 'New Support Ticket — SNBD HOST Help Desk & Technical Support',
                'description' => 'Describe your issue and submit a new support ticket to the SNBD HOST help desk.',
            ],
            'submitticket'            => [
                'title'       => 'Submit a Support Ticket — SNBD HOST Help Desk & Technical Support',
                'description' => 'Submit a support ticket to the SNBD HOST team for fast technical assistance.',
            ],
            'cart.php?a=checkout'     => [
                'title'       => 'Secure Checkout — Complete Your SNBD HOST Web Hosting Order',
                'description' => 'Complete your secure checkout for SNBD HOST hosting, VPS, and domain services.',
            ],
            'cart.php?a=confproduct'  => [
                'title'       => 'Configure Your Hosting Plan — SNBD HOST Order Portal',
                'description' => 'Customise your selected SNBD HOST hosting or VPS plan before checkout.',
            ],
            'cart.php?a=view'         => [
                'title'       => 'Review Your Order — SNBD HOST Web Hosting & VPS Checkout',
                'description' => 'Review the items in your SNBD HOST cart before completing your order.',
            ],
            'cart.php'                => [
                'title'       => 'Shopping Cart — SNBD HOST Web Hosting & VPS Services',
                'description' => 'View and manage your SNBD HOST hosting, VPS, and domain order.',
            ],
            'store/bdix-reseller'     => [
                'title'       => 'BDIX Reseller Hosting — Choose Your Plan & Domain — SNBD HOST',
                'description' => 'Select your BDIX reseller hosting plan and configure your domain with SNBD HOST.',
            ],
            'store/'                  => [
                'title'       => 'Order Hosting, VPS & Domains — SNBD HOST Web Hosting Store',
                'description' => 'Browse and order SNBD HOST web hosting plans, VPS servers, and domain registrations.',
            ],
            'knowledgebase'           => [
                'title'       => 'Knowledge Base — SNBD HOST Support Guides & Hosting Tutorials',
                'description' => 'Browse SNBD HOST support guides, hosting tutorials, and technical knowledge base articles.',
            ],
            'contact.php'             => [
                'title'       => 'Contact SNBD HOST — Pre-Sales Hosting & Domain Enquiries',
                'description' => 'Contact the SNBD HOST pre-sales team for hosting, VPS, and domain questions.',
            ],
            'pwreset'                 => [
                'title'       => 'Reset Your SNBD HOST Account Password — Secure Client Portal',
                'description' => 'Reset your SNBD HOST client portal password securely.',
            ],
            'register'                => [
                'title'       => 'Create an SNBD HOST Account — Web Hosting & VPS Client Portal',
                'description' => 'Create your SNBD HOST account to order hosting, manage services, and get support.',
            ],
            'login'                   => [
                'title'       => 'Client Portal Login — Manage Your SNBD HOST Hosting Account',
                'description' => 'Sign in to your SNBD HOST client portal to manage hosting, domains, and billing.',
            ],
            'announcements'           => [
                'title'       => 'Service Announcements & Maintenance Notices — SNBD HOST',
                'description' => 'Read the latest SNBD HOST service announcements and scheduled maintenance notices.',
            ],
            'downloads'               => [
                'title'       => 'Downloads — Resources & Tools — SNBD HOST Client Portal',
                'description' => 'Download resources, software, and tools from your SNBD HOST client portal.',
            ],
        ];

        foreach ($map as $fragment => $meta) {
            if (stripos($uri, $fragment) !== false) {
                return $meta;
            }
        }

        return [
            'title'       => 'Client Portal — Manage Your SNBD HOST Hosting & VPS Services',
            'description' => 'Manage your SNBD HOST services — billing, support, and account settings.',
        ];
    }
}

// ── 1. Override page title + add security headers ────────────────────────────
add_hook('ClientAreaPage', 1, function ($vars) {
    $uri  = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '/';
    $meta = snbd_get_page_meta($uri);

    if (!headers_sent()) {
        header('Strict-Transport-Security: max-age=31536000; includeSubDomains', true);
        header(
            "Content-Security-Policy: default-src 'self' https: data: blob: 'unsafe-inline' 'unsafe-eval'; " .
            "img-src 'self' https: data: blob:; " .
            "connect-src 'self' https: wss:; " .
            "frame-ancestors 'self'; upgrade-insecure-requests;",
            true
        );
    }

    return ['pagetitle' => $meta['title']];
});

// ── 2. Inject canonical + description + noindex ──────────────────────────────
add_hook('ClientAreaHeadOutput', 1, function ($vars) {
    $uri  = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '/';
    $meta = snbd_get_page_meta($uri);

    $path      = strtok($uri, '?');
    $path      = $path ? rtrim($path, '/') : '';
    $canonical = 'https://portal.snbdhost.com' . ($path ?: '/login');

    $safeCanonical   = htmlspecialchars($canonical, ENT_QUOTES, 'UTF-8');
    $safeDescription = htmlspecialchars($meta['description'], ENT_QUOTES, 'UTF-8');

    return <<<HTML
<link rel="canonical" href="{$safeCanonical}">
<meta name="description" content="{$safeDescription}">
<meta name="robots" content="noindex, nofollow">
HTML;
});
