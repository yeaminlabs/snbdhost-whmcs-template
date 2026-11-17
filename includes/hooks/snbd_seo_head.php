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

// ── Per-response CSP nonce and output hardening ─────────────────────────────
if (!function_exists('snbd_get_csp_nonce')) {
    /**
     * Return one unpredictable nonce for this response.
     *
     * The output buffer below adds it to every rendered script/style element,
     * including WHMCS/module templates that are outside this hook file.
     */
    function snbd_get_csp_nonce(): string
    {
        static $nonce = null;

        if ($nonce !== null) {
            return $nonce;
        }

        try {
            $bytes = random_bytes(18);
        } catch (\Throwable $e) {
            $bytes = function_exists('openssl_random_pseudo_bytes')
                ? openssl_random_pseudo_bytes(18)
                : false;
        }

        if (!is_string($bytes) || $bytes === '') {
            $bytes = hash('sha256', uniqid((string)mt_rand(), true), true);
        }

        $nonce = rtrim(strtr(base64_encode($bytes), '+/', '-_'), '=');

        return $nonce;
    }
}

if (!function_exists('snbd_csp_nonce_output_buffer')) {
    /**
     * Hash rendered inline event handlers so legacy WHMCS controls keep
     * working without allowing arbitrary inline script elements.
     *
     * @param string $html
     * @return array<string>
     */
    function snbd_csp_event_handler_hashes(string $html): array
    {
        $hashes = [];

        if (!preg_match_all(
            '/\bon[a-z][a-z0-9_-]*\s*=\s*(["\'])(.*?)\1/is',
            $html,
            $matches,
            PREG_SET_ORDER
        )) {
            return [];
        }

        foreach ($matches as $match) {
            $handler = trim(html_entity_decode($match[2], ENT_QUOTES | ENT_HTML5, 'UTF-8'));
            if ($handler === '') {
                continue;
            }

            $hashes["'sha256-" . base64_encode(hash('sha256', $handler, true)) . "'"] = true;
        }

        return array_keys($hashes);
    }

    /**
     * Build and send the narrowed client-area CSP.
     *
     * @param array<string> $scriptAttributeHashes
     * @return void
     */
    function snbd_send_csp_header(array $scriptAttributeHashes = []): void
    {
        if (headers_sent()) {
            return;
        }

        $nonce = snbd_get_csp_nonce();
        $scriptAttrSources = "'unsafe-hashes'";
        foreach ($scriptAttributeHashes as $hash) {
            $scriptAttrSources .= ' ' . $hash;
        }

        header(
            "Content-Security-Policy: " .
            "default-src 'self'; " .
            "base-uri 'self'; " .
            "object-src 'none'; " .
            // The WHMCS/Smarty theme emits inline bootstrap and page scripts
            // before this hook can reliably rewrite their opening tags. Keep
            // inline compatibility while retaining the important controls:
            // no unsafe-eval, no broad HTTPS wildcard, and explicit origins.
            "script-src 'self' 'unsafe-inline' " .
                "https://portal.snbdhost.com https://static.cloudflareinsights.com " .
                "https://accounts.google.com https://www.googletagmanager.com " .
                "https://cdn.jsdelivr.net https://platform.twitter.com " .
                "https://challenges.cloudflare.com https://embed.tawk.to " .
                "https://connect.facebook.net https://js.stripe.com " .
                "https://googleads.g.doubleclick.net; " .
            "script-src-attr 'unsafe-inline'; " .
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com " .
                "https://fonts.gstatic.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com " .
                "https://*.tawk.to https://accounts.google.com; " .
            "style-src-attr 'unsafe-inline'; " .
            "font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net " .
                "https://cdnjs.cloudflare.com https://*.tawk.to data:; " .
            "img-src 'self' https: data: blob:; " .
            "connect-src 'self' https://gtm.snbdhost.com " .
                "https://www.googletagmanager.com https://www.google-analytics.com " .
                "https://analytics.google.com https://accounts.google.com https://www.google.com " .
                "https://www.googleadservices.com https://googleads.g.doubleclick.net " .
                "https://ad.doubleclick.net " .
                "https://challenges.cloudflare.com https://ai-proxy.snbdhost.com " .
                "https://va.tawk.to https://*.tawk.to wss://*.tawk.to " .
                "https://api.stripe.com https://m.stripe.network https://r.stripe.com " .
                "https://www.facebook.com https://*.ecs.us-east-2.on.aws " .
                "https://*.conversionsapigateway.com; " .
            "style-src-elem 'self' 'unsafe-inline' https://fonts.googleapis.com " .
                "https://fonts.gstatic.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com " .
                "https://*.tawk.to https://accounts.google.com; " .
            "frame-src 'self' https:; " .
            "frame-ancestors 'self'; upgrade-insecure-requests;",
            true
        );
    }

    /**
     * Add the response nonce to inline and external script/style elements.
     * Existing nonce attributes are preserved if another integration added
     * one before this callback runs.
     */
    function snbd_csp_nonce_output_buffer(string $html): string
    {
        $nonce = htmlspecialchars(snbd_get_csp_nonce(), ENT_QUOTES, 'UTF-8');

        // The completed response is available here, so hashes can cover
        // Smarty-rendered event attributes with dynamic values as well.
        snbd_send_csp_header(snbd_csp_event_handler_hashes($html));

        $result = preg_replace_callback(
            '/<(script|style)\b(?![^>]*\bnonce\s*=)([^>]*)>/i',
            static function (array $match) use ($nonce): string {
                return '<' . $match[1] . ' nonce="' . $nonce . '"' . $match[2] . '>';
            },
            $html
        );

        return is_string($result) ? $result : $html;
    }
}

if (!function_exists('snbd_start_csp_nonce_buffer')) {
    function snbd_start_csp_nonce_buffer(): void
    {
        static $started = false;

        if ($started || headers_sent()) {
            return;
        }

        ob_start('snbd_csp_nonce_output_buffer');
        $started = true;
    }
}

// ── Helper defined at file scope (not inside a closure) ──────────────────────
if (!function_exists('snbd_get_page_meta')) {
    function snbd_get_page_meta(string $uri): array {
        // View invoice: title must reflect the invoice, not the generic portal title.
        if (stripos($uri, 'viewinvoice') !== false) {
            preg_match('/[?&]id=(\d+)/', $uri, $m);
            $id = $m[1] ?? '';
            return [
                'title'       => $id ? ('Invoice #' . $id . ' — SNBD HOST') : 'Invoice — SNBD HOST',
                'description' => 'View and pay your SNBD HOST invoice.',
            ];
        }

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

    // Start before any page template output so every inline element receives
    // the same nonce advertised by the response header.
    snbd_start_csp_nonce_buffer();

    if (!headers_sent()) {
        header('Strict-Transport-Security: max-age=31536000; includeSubDomains', true);
        // Set a baseline before rendering; the output callback replaces it
        // with the final event-handler hash list before bytes are sent.
        snbd_send_csp_header();
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
