<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">My services</h1>
        <p class="snbd-page-sub">Manage the hosting, VPS and add-on services on your account.</p>
    </div>
    <div class="snbd-page-actions">
        <a href="cart.php" class="snbd-btn snbd-btn--primary"><i class="ti ti-plus" aria-hidden="true"></i>Order new service</a>
    </div>
</div>

<div class="snbd-toolbar">
    <div class="snbd-seg" role="group" aria-label="Filter services by status">
        <button type="button" class="snbd-seg__item active" data-snbd-filter="all" aria-pressed="true">All</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="active" aria-pressed="false">Active</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="pending" aria-pressed="false">Pending</button>
        <button type="button" class="snbd-seg__item" data-snbd-filter="suspended" aria-pressed="false">Suspended</button>
    </div>
    <p class="snbd-caption mb-0">{$services|@count} service{if $services|@count != 1}s{/if} on this account</p>
</div>

{php}
if (isset($_SESSION['uid']) && !empty($_SESSION['snbd_recent_services'])) {
    $userid = $_SESSION['uid'];
    $recentIds = array_map('intval', $_SESSION['snbd_recent_services']);
    $recent = array();
    foreach ($recentIds as $rid) {
        if (isset($GLOBALS['servicesMap'][$rid])) {
            $recent[] = $GLOBALS['servicesMap'][$rid];
        }
    }
    if (!empty($recent)) {
        $GLOBALS['snbdRecentServices'] = $recent;
    }
}
{/php}

{if $snbdRecentServices}
<div class="mb-4">
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h2 class="snbd-section-title mb-0"><i class="ti ti-clock-hour-4" aria-hidden="true"></i> Recently opened</h2>
        <p class="snbd-caption mb-0">Continue where you left off</p>
    </div>
    <div class="row g-3">
        {foreach item=service from=$snbdRecentServices}
        <div class="col-md-6 col-xl-4">
            <article class="snbd-card snbd-service-card h-100">
                <div class="snbd-card__body d-flex flex-column">
                    <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
                        <div class="d-flex align-items-center gap-3 min-w-0">
                            <span class="snbd-stat__icon"><i class="ti ti-server" aria-hidden="true"></i></span>
                            <div class="min-w-0">
                                <h3 class="snbd-service-card__name snbd-truncate" title="{$service.product}">{$service.product}</h3>
                                {if $service.domain}
                                    <p class="snbd-service-card__domain snbd-truncate"><i class="ti ti-world" aria-hidden="true"></i>{$service.domain}</p>
                                {else}
                                    <p class="snbd-service-card__domain snbd-faint">No domain attached</p>
                                {/if}
                            </div>
                        </div>
                        {if $service.status eq "Active"}
                            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Active</span>
                        {elseif $service.status eq "Pending"}
                            <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Pending</span>
                        {elseif $service.status eq "Suspended"}
                            <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Suspended</span>
                        {elseif $service.status eq "Terminated"}
                            <span class="snbd-chip snbd-chip--neutral">Terminated</span>
                        {else}
                            <span class="snbd-chip snbd-chip--neutral">{$service.status}</span>
                        {/if}
                    </div>
                    <div class="mt-auto pt-2">
                        <a href="clientarea.php?action=productdetails&id={$service.id}" class="snbd-btn snbd-btn--primary snbd-btn--block">
                            <i class="ti ti-arrow-right" aria-hidden="true"></i>Open
                        </a>
                    </div>
                </div>
            </article>
        </div>
        {/foreach}
    </div>
</div>
{/if}

<div class="mb-3">
    <h2 class="snbd-section-title mb-0"><i class="ti ti-layout-grid" aria-hidden="true"></i> All services</h2>
</div>

{php}
if (isset($_SESSION['uid']) && !empty($_SESSION['snbd_recent_services'])) {
    $recentIds = array_map('intval', $_SESSION['snbd_recent_services']);
    $all = isset($GLOBALS['snbdSvc']) ? $GLOBALS['snbdSvc'] : array();
    $ordered = array();
    foreach ($recentIds as $rid) {
        if (isset($all[$rid])) {
            $ordered[] = $all[$rid];
        }
    }
    foreach ($all as $id => $svc) {
        if (!in_array($id, $recentIds)) {
            $ordered[] = $svc;
        }
    }
    $this->assign('services', $ordered);
} else {
    $all = isset($GLOBALS['snbdSvc']) ? $GLOBALS['snbdSvc'] : array();
    krsort($all);
    $this->assign('services', array_values($all));
}
{/php}

<div class="row g-4 mb-5" data-snbd-filter-target>
    {foreach key=num item=service from=$services}
    {php}$s = $this->get_template_vars('service'); if($s && isset($s['id'])) { $GLOBALS['snbdSvc'][$s['id']] = $s; }{/php}
    <div class="col-md-6 col-xxl-4 snbd-filter-row">
        <article class="snbd-card snbd-service-card h-100">
            <div class="snbd-card__body d-flex flex-column">
                <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
                    <div class="d-flex align-items-center gap-3 min-w-0">
                        <span class="snbd-stat__icon"><i class="ti ti-server" aria-hidden="true"></i></span>
                        <div class="min-w-0">
                            <h2 class="snbd-service-card__name snbd-truncate" title="{$service.product}">{$service.product}</h2>
                            {if $service.domain}
                                <p class="snbd-service-card__domain snbd-truncate"><i class="ti ti-world" aria-hidden="true"></i>{$service.domain}</p>
                            {else}
                                <p class="snbd-service-card__domain snbd-faint">No domain attached</p>
                            {/if}
                        </div>
                    </div>
                    {if $service.status eq "Active"}
                        <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Active</span>
                    {elseif $service.status eq "Pending"}
                        <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Pending</span>
                    {elseif $service.status eq "Suspended"}
                        <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Suspended</span>
                    {elseif $service.status eq "Terminated"}
                        <span class="snbd-chip snbd-chip--neutral">Terminated</span>
                    {else}
                        <span class="snbd-chip snbd-chip--neutral">{$service.status}</span>
                    {/if}
                </div>

                <dl class="snbd-service-card__meta">
                    <div>
                        <dt>Price</dt>
                        <dd class="snbd-price">{$service.amount}</dd>
                    </div>
                    <div>
                        <dt>Next due</dt>
                        <dd>{$service.nextduedate}</dd>
                    </div>
                    <div>
                        <dt>Billing cycle</dt>
                        <dd class="text-capitalize">{$service.billingcycle}</dd>
                    </div>
                </dl>

                <div class="mt-auto pt-3">
                    <a href="clientarea.php?action=productdetails&id={$service.id}" class="snbd-btn snbd-btn--secondary snbd-btn--block">
                        <i class="ti ti-settings" aria-hidden="true"></i>Manage service
                    </a>
                </div>
            </div>
        </article>
    </div>
    {foreachelse}
    <div class="col-12">
        <div class="snbd-card">
            <div class="snbd-empty">
                <span class="snbd-empty__icon"><i class="ti ti-server" aria-hidden="true"></i></span>
                <p class="snbd-empty__title">No services yet</p>
                <p class="snbd-empty__text">Once you order hosting, a VPS or an add-on, it will appear here with its renewal details.</p>
                <a href="cart.php" class="snbd-btn snbd-btn--primary">Browse services</a>
            </div>
        </div>
    </div>
    {/foreach}
</div>

{if $prevpage || $nextpage}
<nav class="snbd-pagination" aria-label="Services pages">
    {if $prevpage}
        <a href="?action=products&page={$prevpage}" class="snbd-btn snbd-btn--sm snbd-btn--secondary"><i class="ti ti-arrow-left" aria-hidden="true"></i>Previous</a>
    {else}
        <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true"><i class="ti ti-arrow-left" aria-hidden="true"></i>Previous</span>
    {/if}
    {if $nextpage}
        <a href="?action=products&page={$nextpage}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">Next<i class="ti ti-arrow-right" aria-hidden="true"></i></a>
    {else}
        <span class="snbd-btn snbd-btn--sm snbd-btn--secondary disabled" aria-disabled="true">Next<i class="ti ti-arrow-right" aria-hidden="true"></i></span>
    {/if}
</nav>
{/if}
