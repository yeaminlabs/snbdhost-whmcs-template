<?php
use WHMCS\ClientArea;
use WHMCS\Database\Capsule;

define('CLIENTAREA', true);

// Require the WHMCS initialization file
require __DIR__ . '/init.php';

$ca = new ClientArea();
$ca->setPageTitle('Free Migration Request');
$ca->addToBreadCrumb('index.php', Lang::trans('globalsystemname'));
$ca->addToBreadCrumb('migration.php', 'Free Migration Request');
$ca->initPage();

// 1. Create table if it doesn't exist
try {
    if (!Capsule::schema()->hasTable('mod_snbd_migrations')) {
        Capsule::schema()->create('mod_snbd_migrations', function ($table) {
            $table->increments('id');
            $table->integer('user_id')->default(0);
            $table->string('previous_provider', 255)->nullable();
            $table->string('website_url', 255)->nullable();
            $table->string('cms', 100)->nullable();
            $table->string('is_web_app', 100)->nullable();
            $table->string('hosting_required', 100)->nullable();
            $table->string('existing_username', 100)->nullable();
            $table->string('target_package', 255)->nullable();
            $table->timestamps();
        });
    }
} catch (\Exception $e) {
    // Silently ignore schema creation errors in production if it already exists but hasTable failed
}

// 2. Handle Form Submission
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_migration'])) {
    $ca->assign('submitted', true);
    
    // Simple CSRF Check
    check_token();

    try {
        Capsule::table('mod_snbd_migrations')->insert([
            'user_id' => $ca->getUserID() ?: 0,
            'previous_provider' => trim($_POST['previous_provider'] ?? ''),
            'website_url' => trim($_POST['website_url'] ?? ''),
            'cms' => trim($_POST['cms'] ?? ''),
            'is_web_app' => trim($_POST['is_web_app'] ?? ''),
            'hosting_required' => trim($_POST['hosting_required'] ?? ''),
            'existing_username' => trim($_POST['existing_username'] ?? ''),
            'target_package' => trim($_POST['target_package'] ?? ''),
            'created_at' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s'),
        ]);
        $ca->assign('success', true);
    } catch (\Exception $e) {
        $ca->assign('error', 'An error occurred while submitting your request: ' . $e->getMessage());
    }
}

// Pass current user status to template
$ca->assign('isLoggedIn', $ca->isLoggedIn());

// Define the template filename to be used without the .tpl extension
$ca->setTemplate('migration');
$ca->output();
