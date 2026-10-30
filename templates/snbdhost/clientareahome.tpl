{if !$clientsdetails.phonenumber || !$clientsdetails.address1 || $clientsdetails.phonenumber == '+00000000000' || $clientsdetails.address1 == 'Pending Completion'}
<div class="snbd-alert snbd-alert--warn" role="status">
    <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__title">Complete your profile</p>
        <p class="snbd-alert__text">We need your address and phone number before you can place new orders. This is usually required after signing in with Google.</p>
    </div>
    <a href="clientarea.php?action=details" class="snbd-btn snbd-btn--sm snbd-alert__action">Update profile</a>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">Welcome back, {$clientsdetails.firstname}</h1>
        <p class="snbd-page-sub">Here is an overview of your account and services.</p>
    </div>
</div>

{if $showN8nDashboardPromo}
<div class="snbd-spotlight mb-4" data-snbd-dismissable data-snbd-dismiss-key="snbd_n8n_promo_{$n8nDashboardPromoVersion|default:'v1'}" id="n8n-dashboard-promo-segment">
    <span class="snbd-spotlight__glow" aria-hidden="true"></span>
    <div class="position-relative d-flex align-items-center justify-content-between flex-wrap gap-3">
        <div class="d-flex align-items-center gap-3">
            <span class="snbd-stat__icon"><i class="ti ti-player-play" aria-hidden="true"></i></span>
            <div>
                <span class="snbd-chip snbd-chip--brand mb-2">For n8n clients</span>
                <h2 class="snbd-card__title text-white mb-1">{$n8nDashboardPromoTitle|default:'SNBD Host n8n video masterclass'}</h2>
                <p class="mb-0 small snbd-muted">{$n8nDashboardPromoDesc|default:'Learn n8n workflows, webhooks, API integrations and AI agents with our free step-by-step video guide.'}</p>
            </div>
        </div>
        <div class="d-flex align-items-center gap-2">
            <a href="{$n8nDashboardPromoUrl|default:'https://snbdhost.com/learn/n8n-basic-to-advanced-in-bangla'}" target="_blank" rel="noopener" class="snbd-btn snbd-btn--primary snbd-btn--sm">
                {$n8nDashboardPromoBtnText|default:'Watch the guide'}<i class="ti ti-arrow-right" aria-hidden="true"></i>
            </a>
            <button type="button" class="snbd-icon-btn" data-snbd-dismiss aria-label="Dismiss this promotion">
                <i class="ti ti-x" aria-hidden="true"></i>
            </button>
        </div>
    </div>
</div>
{/if}

<div class="snbd-stats">
    <a class="snbd-stat" href="clientarea.php?action=products">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Active services</span>
            <span class="snbd-stat__value">{$clientsstats.productsnumactive|default:0}</span>
            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Running</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--ok"><i class="ti ti-server" aria-hidden="true"></i></span>
    </a>

    <a class="snbd-stat" href="clientarea.php?action=invoices">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Open invoices</span>
            <span class="snbd-stat__value">{$clientsstats.numunpaidinvoices|default:0}</span>
            {if $clientsstats.numunpaidinvoices > 0}
                <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Needs attention</span>
            {else}
                <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>All paid</span>
            {/if}
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--warn"><i class="ti ti-file-invoice" aria-hidden="true"></i></span>
    </a>

    <a class="snbd-stat" href="clientarea.php?action=invoices">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Unpaid balance</span>
            <span class="snbd-stat__value snbd-price">{$clientsstats.dueinvoicesbalance|default:'$0.00'}</span>
            {if $clientsstats.numunpaidinvoices > 0}
                <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Payment due</span>
            {else}
                <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Settled</span>
            {/if}
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--bad"><i class="ti ti-wallet" aria-hidden="true"></i></span>
    </a>

    <a class="snbd-stat" href="supporttickets.php">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Open tickets</span>
            <span class="snbd-stat__value">{$clientsstats.numactivetickets|default:0}</span>
            {if $clientsstats.numactivetickets > 0}
                <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>Support open</span>
            {else}
                <span class="snbd-chip snbd-chip--neutral"><span class="snbd-chip__dot" aria-hidden="true"></span>No open tickets</span>
            {/if}
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--info"><i class="ti ti-lifebuoy" aria-hidden="true"></i></span>
    </a>
</div>

<div class="row g-4 mb-4">
    <div class="col-xl-8">
        <section class="snbd-card h-100" aria-labelledby="dash-services-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="dash-services-title"><i class="ti ti-server" aria-hidden="true"></i>Your services</h2>
                <a href="clientarea.php?action=products" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View all</a>
            </div>
            {if $homepageproducts}
            <div class="snbd-table-wrap">
                <table class="snbd-table">
                    <caption class="snbd-visually-hidden">Your active products and services</caption>
                    <thead>
                        <tr>
                            <th scope="col">Service</th>
                            <th scope="col">Domain</th>
                            <th scope="col">Status</th>
                            <th scope="col" class="snbd-table__actions">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach key=k item=product from=$homepageproducts}
                        <tr>
                            <td data-label="Service">
                                <span class="d-block fw-semibold">{$product.name}</span>
                            </td>
                            <td data-label="Domain">
                                {if $product.domain}
                                    <span class="snbd-muted snbd-mono">{$product.domain}</span>
                                {else}
                                    <span class="snbd-faint">Not set</span>
                                {/if}
                            </td>
                            <td data-label="Status">
                                {if $product.status eq "Active"}
                                    <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Active</span>
                                {elseif $product.status eq "Pending"}
                                    <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Pending</span>
                                {elseif $product.status eq "Suspended"}
                                    <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Suspended</span>
                                {else}
                                    <span class="snbd-chip snbd-chip--neutral">{$product.status}</span>
                                {/if}
                            </td>
                            <td class="snbd-table__actions" data-label="Action">
                                <a href="clientarea.php?action=productdetails&id={$product.id}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">Manage</a>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            {else}
            <div class="snbd-empty">
                <span class="snbd-empty__icon"><i class="ti ti-server" aria-hidden="true"></i></span>
                <p class="snbd-empty__title">No services yet</p>
                <p class="snbd-empty__text">Your hosting, VPS and other services will appear here once you order.</p>
                <a href="cart.php" class="snbd-btn snbd-btn--primary snbd-btn--sm">Browse services</a>
            </div>
            {/if}
        </section>
    </div>

    <div class="col-xl-4">
        <aside class="snbd-card snbd-card--rail h-100" aria-labelledby="dash-account-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="dash-account-title"><i class="ti ti-user-circle" aria-hidden="true"></i>Account</h2>
            </div>
            <div class="snbd-card__body">
                <dl class="snbd-kv mb-4">
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Active services</dt>
                        <dd class="snbd-kv__v snbd-kv__v--num">{$clientsstats.productsnumactive|default:0}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Unpaid invoices</dt>
                        <dd class="snbd-kv__v snbd-kv__v--num">{$clientsstats.numunpaidinvoices|default:0}</dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Amount due</dt>
                        <dd class="snbd-kv__v snbd-kv__v--num snbd-price">{$clientsstats.dueinvoicesbalance|default:'$0.00'}</dd>
                    </div>
                    {if $loyalty_data && $loyalty_data.tier}
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Loyalty tier</dt>
                        <dd class="snbd-kv__v"><span class="snbd-chip snbd-chip--brand">{$loyalty_data.tier}{if $loyalty_data.discount} · {$loyalty_data.discount} off{/if}</span></dd>
                    </div>
                    {if $loyalty_data.next_tier}
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Next tier</dt>
                        <dd class="snbd-kv__v">{$loyalty_data.next_tier} · {$loyalty_data.next_discount}</dd>
                    </div>
                    {/if}
                    {/if}
                </dl>

                <div class="snbd-eyebrow">Quick actions</div>
                <div class="snbd-dash-actions">
                    <a href="submitticket.php" class="snbd-dash-action"><i class="ti ti-message-plus" aria-hidden="true"></i><span>New ticket</span></a>
                    <a href="clientarea.php?action=invoices" class="snbd-dash-action"><i class="ti ti-receipt" aria-hidden="true"></i><span>Invoices</span></a>
                    <a href="clientarea.php?action=addfunds" class="snbd-dash-action"><i class="ti ti-wallet" aria-hidden="true"></i><span>Add funds</span></a>
                    <a href="affiliates.php" class="snbd-dash-action"><i class="ti ti-users" aria-hidden="true"></i><span>Affiliates</span></a>
                </div>
            </div>
        </aside>
    </div>
</div>

{if $open_tickets || $clientsstats.numunpaidinvoices > 0}
<section class="snbd-card mb-4" aria-labelledby="dash-action-title">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title" id="dash-action-title"><i class="ti ti-alert-triangle" aria-hidden="true"></i>Action required</h2>
    </div>
    <div class="snbd-table-wrap">
        <table class="snbd-table">
            <caption class="snbd-visually-hidden">Items that need your attention</caption>
            <tbody>
                {foreach key=num item=invoice from=$invoices}
                    {if $invoice.status eq "Unpaid" || $invoice.status eq "Overdue"}
                    <tr>
                        <td data-label="Item">
                            <span class="d-inline-flex align-items-center gap-2">
                                <span class="snbd-stat__icon snbd-stat__icon--warn"><i class="ti ti-file-invoice" aria-hidden="true"></i></span>
                                <span>
                                    <span class="d-block fw-semibold">Invoice #{$invoice.invoicenum} is {$invoice.status|lower}</span>
                                    <span class="snbd-caption">Due {$invoice.datedue} · <span class="snbd-price">{$invoice.total}</span></span>
                                </span>
                            </span>
                        </td>
                        <td class="snbd-table__actions" data-label="Action">
                            <a href="viewinvoice.php?id={$invoice.id}" class="snbd-btn snbd-btn--sm snbd-btn--primary">Pay invoice</a>
                        </td>
                    </tr>
                    {/if}
                {/foreach}
                {foreach item=ticket from=$open_tickets}
                <tr>
                    <td data-label="Item">
                        <span class="d-inline-flex align-items-center gap-2">
                            <span class="snbd-stat__icon snbd-stat__icon--info"><i class="ti ti-lifebuoy" aria-hidden="true"></i></span>
                            <span>
                                <span class="d-block fw-semibold">Ticket #{$ticket.tid}: {$ticket.title}</span>
                                <span class="snbd-caption">Last reply {$ticket.lastreply} · {$ticket.status}</span>
                            </span>
                        </span>
                    </td>
                    <td class="snbd-table__actions" data-label="Action">
                        <a href="viewticket.php?tid={$ticket.tid}&amp;c={$ticket.c}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View ticket</a>
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</section>
{/if}

{if $widgets}
<div class="row g-4 mb-4">
    {foreach from=$widgets item=widget}
    {if $widget.content}
    <div class="col-md-6 col-xl-4">
        <section class="snbd-card h-100">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title">
                    {if $widget.icon}<i class="{$widget.icon}" aria-hidden="true"></i>{else}<i class="ti ti-layout-grid" aria-hidden="true"></i>{/if}
                    {$widget.title}
                </h2>
            </div>
            <div class="snbd-card__body">
                {$widget.content}
            </div>
        </section>
    </div>
    {/if}
    {/foreach}
</div>
{/if}

<div class="row g-4 mb-4">
    <div class="col-xl-8">
        <section class="snbd-card h-100" aria-labelledby="dash-invoices-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="dash-invoices-title"><i class="ti ti-receipt" aria-hidden="true"></i>Recent invoices</h2>
                <div class="snbd-card__actions">
                    {if $clientsstats.numunpaidinvoices > 0}
                        <a href="clientarea.php?action=masspay&all=true" class="snbd-btn snbd-btn--sm snbd-btn--primary">Pay all unpaid</a>
                    {/if}
                    <a href="clientarea.php?action=invoices" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View all</a>
                </div>
            </div>
            {if $invoices}
            <div class="snbd-table-wrap">
                <table class="snbd-table">
                    <caption class="snbd-visually-hidden">Your most recent invoices</caption>
                    <thead>
                        <tr>
                            <th scope="col">Invoice</th>
                            <th scope="col">Date</th>
                            <th scope="col" class="snbd-table__num">Total</th>
                            <th scope="col">Status</th>
                            <th scope="col" class="snbd-table__actions">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach key=num item=invoice from=$invoices}
                        <tr>
                            <td data-label="Invoice" class="fw-semibold">#{$invoice.invoicenum}</td>
                            <td data-label="Date" class="snbd-muted">{$invoice.datecreated}</td>
                            <td data-label="Total" class="snbd-table__num snbd-price">{$invoice.total}</td>
                            <td data-label="Status">
                                {if $invoice.status eq "Paid"}
                                    <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Paid</span>
                                {elseif $invoice.status eq "Unpaid"}
                                    <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Unpaid</span>
                                {elseif $invoice.status eq "Overdue"}
                                    <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Overdue</span>
                                {else}
                                    <span class="snbd-chip snbd-chip--neutral">{$invoice.status}</span>
                                {/if}
                            </td>
                            <td class="snbd-table__actions" data-label="Action">
                                <a href="viewinvoice.php?id={$invoice.id}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View</a>
                            </td>
                        </tr>
                        {foreachelse}
                        <tr>
                            <td colspan="5">
                                <div class="snbd-empty">
                                    <span class="snbd-empty__icon"><i class="ti ti-receipt" aria-hidden="true"></i></span>
                                    <p class="snbd-empty__title">No invoices yet</p>
                                    <p class="snbd-empty__text">Invoices appear here as soon as you place an order.</p>
                                </div>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            {else}
            <div class="snbd-empty">
                <span class="snbd-empty__icon"><i class="ti ti-receipt" aria-hidden="true"></i></span>
                <p class="snbd-empty__title">No invoices yet</p>
                <p class="snbd-empty__text">Invoices appear here as soon as you place an order.</p>
            </div>
            {/if}
        </section>
    </div>

    <div class="col-xl-4">
        <section class="snbd-card h-100" aria-labelledby="dash-announce-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="dash-announce-title"><i class="ti ti-news" aria-hidden="true"></i>Announcements</h2>
                <a href="announcements.php" class="snbd-btn snbd-btn--sm snbd-btn--secondary">View all</a>
            </div>
            <div class="snbd-card__body">
                {if $announcements}
                    <div class="snbd-stack snbd-stack--sm">
                    {foreach key=num item=announcement from=$announcements}
                        {if $num < 5}
                        <a href="announcements.php?id={$announcement.id}" class="snbd-announce">
                            <span class="snbd-announce__title">{$announcement.title}</span>
                            <span class="snbd-announce__date"><i class="ti ti-calendar" aria-hidden="true"></i>{$announcement.date}</span>
                        </a>
                        {/if}
                    {/foreach}
                    </div>
                {else}
                    <div class="snbd-empty">
                        <span class="snbd-empty__icon"><i class="ti ti-news" aria-hidden="true"></i></span>
                        <p class="snbd-empty__title">Nothing new</p>
                        <p class="snbd-empty__text">Announcements and maintenance notices will show up here.</p>
                    </div>
                {/if}
            </div>
        </section>
    </div>
</div>
