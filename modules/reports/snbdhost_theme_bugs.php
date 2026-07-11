<?php

use WHMCS\Database\Capsule;

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

$reportdata["title"] = "SNBDHost Theme & Template Bugs";
$reportdata["description"] = "A live view of all theme, template, and UI issues reported or logged recently. This helps track active bugs on the SNBDHost portal theme.";

// Define the table columns
$reportdata["tableheadings"] = array(
    "Date / Time",
    "Admin User",
    "Description (Bug / Error Details)"
);

// Fetch data from the activity log securely via Laravel Capsule
$logs = Capsule::table('tblactivitylog')
    ->select('date', 'user', 'description')
    ->where(function ($query) {
        $query->where('description', 'like', '%template%')
              ->orWhere('description', 'like', '%theme%')
              ->orWhere('description', 'like', '%snbdhost%')
              ->orWhere('description', 'like', '%bug%');
    })
    ->orderBy('id', 'desc')
    ->limit(150)
    ->get();

// Populate the table rows
foreach ($logs as $log) {
    // Basic formatting and sanitization for safety
    $date = date("Y-m-d H:i:s", strtotime($log->date));
    $user = $log->user ? $log->user : "System";
    $description = htmlspecialchars($log->description);

    // Highlight keywords in red for easier readability
    $description = str_ireplace("template", "<strong style='color:#e53935;'>template</strong>", $description);
    $description = str_ireplace("theme", "<strong style='color:#e53935;'>theme</strong>", $description);
    $description = str_ireplace("bug", "<strong style='color:#e53935;'>bug</strong>", $description);
    $description = str_ireplace("snbdhost", "<strong style='color:#e53935;'>snbdhost</strong>", $description);

    $reportdata["tablevalues"][] = array(
        $date,
        "<strong>" . $user . "</strong>",
        $description
    );
}

// Optional: Add a summary widget at the top of the report
$reportdata["headertext"] = "<div style=\"background: #fff; border-left: 4px solid #e53935; padding: 15px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border-radius: 4px;\">
    <strong>Admin Note:</strong> This report actively scans the WHMCS Activity Log for entries containing the keywords: <em>template, theme, snbdhost, or bug</em>. Showing the last 150 entries.
</div>";
