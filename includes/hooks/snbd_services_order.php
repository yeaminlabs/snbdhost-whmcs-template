<?php
/**
 * SNBD Host - Reorder services by ID desc (newest first)
 */
if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

add_hook('ClientAreaPage', 1, function($vars) {
    if (isset($vars['templatefile']) && $vars['templatefile'] === 'clientareaproducts') {
        if (isset($vars['services']) && is_array($vars['services'])) {
            usort($vars['services'], function($a, $b) {
                $aid = isset($a['id']) ? (int)$a['id'] : 0;
                $bid = isset($b['id']) ? (int)$b['id'] : 0;
                return $bid <=> $aid;
            });
            return ['services' => $vars['services']];
        }
    }
    return [];
});
