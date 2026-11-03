<?php
/**
 * SNBD Host - Track last opened/viewed services
 */
if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

add_hook('ClientAreaPageProductDetails', 1, function($vars) {
    if (empty($_SESSION['uid'])) {
        return [];
    }
    
    $serviceId = isset($vars['id']) ? (int)$vars['id'] : 0;
    if (!$serviceId) {
        return [];
    }
    
    if (!isset($_SESSION['snbd_recent_services'])) {
        $_SESSION['snbd_recent_services'] = array();
    }
    
    // Remove if already exists to move to front
    $_SESSION['snbd_recent_services'] = array_values(array_filter($_SESSION['snbd_recent_services'], function($id) use ($serviceId) {
        return (int)$id !== $serviceId;
    }));
    
    // Add to front
    array_unshift($_SESSION['snbd_recent_services'], $serviceId);
    
    // Keep only last 10
    if (count($_SESSION['snbd_recent_services']) > 10) {
        $_SESSION['snbd_recent_services'] = array_slice($_SESSION['snbd_recent_services'], 0, 10);
    }
    
    return [];
});
