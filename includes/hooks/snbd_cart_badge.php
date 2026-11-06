<?php
/**
 * SNBD Host — Cart badge in portal header
 *
 * Injects the live cart item count into every client-area page via a small
 * inline script that runs after DOMContentLoaded. The header renders
 * #snbdCartBtn / #snbdCartCount regardless of login state; this hook
 * populates the badge and aria-label when there is at least one item.
 *
 * INSTALLATION: copy to /includes/hooks/snbd_cart_badge.php
 */

if (!defined('WHMCS')) {
    die('This file cannot be accessed directly');
}

add_hook('ClientAreaHeadOutput', 1, function ($vars) {
    $count = count($_SESSION['cart'] ?? []) + count($_SESSION['domains'] ?? []);
    $count = max(0, (int) $count);

    if ($count <= 0) {
        return '';
    }

    $label = 'Shopping cart (' . $count . ' ' . ($count === 1 ? 'item' : 'items') . ')';
    $display = $count > 9 ? '9+' : (string) $count;

    // Runs after DOM is ready so the badge element exists.
    return '<script>document.addEventListener("DOMContentLoaded",function(){'
        . 'var b=document.getElementById("snbdCartCount");'
        . 'if(b){b.textContent=' . json_encode($display) . ';b.style.display="";}'
        . 'var a=document.getElementById("snbdCartBtn");'
        . 'if(a)a.setAttribute("aria-label",' . json_encode($label) . ');'
        . '});</script>';
});
