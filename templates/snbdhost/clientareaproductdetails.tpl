{if $modulecustombuttonresult}
    {if $modulecustombuttonresult == "success"}
        <div class="snbd-alert snbd-alert--ok" role="status" id="alertModuleCustomButtonSuccess">
            <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
            <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='moduleactionsuccess'}</p></div>
        </div>
    {else}
        <div class="snbd-alert snbd-alert--bad" role="alert" id="alertModuleCustomButtonFailed">
            <i class="ti ti-alert-circle snbd-alert__icon" aria-hidden="true"></i>
            <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='moduleactionfailed'}: {$modulecustombuttonresult}</p></div>
        </div>
    {/if}
{/if}

{if $pendingcancellation}
    <div class="snbd-alert snbd-alert--warn" role="status" id="alertPendingCancellation">
        <i class="ti ti-clock snbd-alert__icon" aria-hidden="true"></i>
        <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='cancellationrequestedexplanation'}</p></div>
    </div>
{/if}

{if $unpaidInvoice}
    <div class="snbd-alert snbd-alert--bad" role="alert" id="alertUnpaidInvoice">
        <i class="ti ti-receipt snbd-alert__icon" aria-hidden="true"></i>
        <div class="snbd-alert__body"><p class="snbd-alert__text">{$unpaidInvoiceMessage}</p></div>
        <a href="viewinvoice.php?id={$unpaidInvoice}" class="snbd-btn snbd-btn--sm snbd-btn--primary snbd-alert__action">{lang key='payInvoice'}</a>
    </div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">{$groupname|default:'Service'}</p>
        <h1 class="snbd-page-title">{$product}</h1>
        <div class="snbd-cluster mt-2">
            {if $status eq "Active"}
                <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Active</span>
            {elseif $status eq "Pending"}
                <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Pending</span>
            {elseif $status eq "Suspended"}
                <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Suspended</span>
            {else}
                <span class="snbd-chip snbd-chip--neutral">{$status}</span>
            {/if}
            {if $domain}
                <a href="http://{$domain}" target="_blank" rel="noopener" class="snbd-chip snbd-chip--neutral"><i class="ti ti-world" aria-hidden="true"></i>{$domain}<i class="ti ti-external-link" aria-hidden="true"></i></a>
            {/if}
        </div>
    </div>
    <div class="snbd-page-actions">
            {if $status eq "Active"}
            <form method="post" action="{$smarty.server.PHP_SELF}?action=productdetails&id={$id}" class="d-inline" id="frmServiceSso">
                <input type="hidden" name="token" value="{$token}">
                <input type="hidden" name="modop" value="singlesignon">
                <button type="submit" class="snbd-btn snbd-btn--primary"><i class="ti ti-login" aria-hidden="true"></i>Login to panel</button>
            </form>
            {/if}
            {if $packagesupgrade}
                <a href="upgrade.php?type=package&amp;id={$id}" class="snbd-btn snbd-btn--secondary"><i class="ti ti-arrow-up-circle" aria-hidden="true"></i>Upgrade plan</a>
            {/if}
            <a href="clientarea.php?action=products" class="snbd-btn snbd-btn--secondary"><i class="ti ti-arrow-left" aria-hidden="true"></i>All services</a>
        </div>
</div>

<ul class="nav snbd-tabs" id="productDetailsTabs" role="tablist">
    <li role="presentation">
        <button class="snbd-tab active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#tabOverview" type="button" role="tab" aria-controls="tabOverview" aria-selected="true">Overview</button>
    </li>
    {if $modulechangepassword}
    <li role="presentation">
        <button class="snbd-tab" id="password-tab" data-bs-toggle="tab" data-bs-target="#tabPassword" type="button" role="tab" aria-controls="tabPassword" aria-selected="false">Change password</button>
    </li>
    {/if}
    {if $downloads}
    <li role="presentation">
        <button class="snbd-tab" id="downloads-tab" data-bs-toggle="tab" data-bs-target="#tabDownloads" type="button" role="tab" aria-controls="tabDownloads" aria-selected="false">Downloads</button>
    </li>
    {/if}
    {if $addons}
    <li role="presentation">
        <button class="snbd-tab" id="addons-tab" data-bs-toggle="tab" data-bs-target="#tabAddons" type="button" role="tab" aria-controls="tabAddons" aria-selected="false">Add-ons ({$addons|count})</button>
    </li>
    {/if}
</ul>

<div class="tab-content">
    <div class="tab-pane fade show active" id="tabOverview" role="tabpanel" aria-labelledby="overview-tab">
        <div class="row g-4">
            <div class="col-xl-8">
                <section class="snbd-card mb-4" aria-labelledby="service-overview-title">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title" id="service-overview-title"><i class="ti ti-info-circle" aria-hidden="true"></i>Service overview</h2>
                    </div>
                    <div class="snbd-card__body">
                        <dl class="snbd-detail-grid">
                            <div>
                                <dt>Registration date</dt>
                                <dd>{$regdate}</dd>
                            </div>
                            <div>
                                <dt>Recurring amount</dt>
                                <dd class="snbd-price">{$amount}</dd>
                            </div>
                            <div>
                                <dt>Billing cycle</dt>
                                <dd class="text-capitalize">{$billingcycle}</dd>
                            </div>
                            <div>
                                <dt>Next due date</dt>
                                <dd>{$nextduedate}</dd>
                            </div>
                            <div>
                                <dt>Payment method</dt>
                                <dd>{$paymentmethod}</dd>
                            </div>
                            {if $domain}
                            <div>
                                <dt>Domain / hostname</dt>
                                <dd class="snbd-truncate" title="{$domain}">{$domain}</dd>
                            </div>
                            {/if}
                        </dl>
                    </div>
                </section>

                {if $tplOverviewTabOutput}
                    <div class="module-clientarea-wrap mb-4" id="moduleClientAreaWrap">{$tplOverviewTabOutput}</div>
                {elseif $moduleclientarea}
                    <div class="module-clientarea-wrap mb-4" id="moduleClientAreaWrap">{$moduleclientarea}</div>
                {/if}
            </div>

            <div class="col-xl-4">
                <aside class="snbd-card snbd-card--rail" aria-labelledby="service-billing-title">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title" id="service-billing-title"><i class="ti ti-credit-card" aria-hidden="true"></i>Billing</h2>
                    </div>
                    <div class="snbd-card__body">
                        <dl class="snbd-kv">
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Recurring</dt>
                                <dd class="snbd-kv__v snbd-price">{$amount}</dd>
                            </div>
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Cycle</dt>
                                <dd class="snbd-kv__v text-capitalize">{$billingcycle}</dd>
                            </div>
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Next due</dt>
                                <dd class="snbd-kv__v">{$nextduedate}</dd>
                            </div>
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Method</dt>
                                <dd class="snbd-kv__v">{$paymentmethod}</dd>
                            </div>
                        </dl>

                        {if $packagesupgrade || $showcancelbutton}
                        <hr class="snbd-divider">
                        <div class="snbd-stack snbd-stack--sm">
                            {if $packagesupgrade}
                                <a href="upgrade.php?type=package&amp;id={$id}" class="snbd-btn snbd-btn--secondary snbd-btn--sm snbd-btn--block"><i class="ti ti-arrow-up-circle" aria-hidden="true"></i>Upgrade or downgrade</a>
                            {/if}
                            {if $showcancelbutton}
                                <a href="clientarea.php?action=cancel&amp;id={$id}" class="snbd-btn snbd-btn--danger snbd-btn--sm snbd-btn--block {if $pendingcancellation}disabled{/if}"><i class="ti ti-ban" aria-hidden="true"></i>Request cancellation</a>
                            {/if}
                        </div>
                        {/if}
                    </div>
                </aside>
            </div>
        </div>
    </div>

    {if $modulechangepassword}
    <div class="tab-pane fade" id="tabPassword" role="tabpanel" aria-labelledby="password-tab">
        <section class="snbd-card" aria-labelledby="password-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="password-title"><i class="ti ti-key" aria-hidden="true"></i>Change password</h2>
            </div>
            <div class="snbd-card__body snbd-form snbd-form--narrow">
                <form class="using-password-strength" method="post" action="{$smarty.server.PHP_SELF}?action=productdetails#tabPassword">
                    <input type="hidden" name="token" value="{$token}">
                    <input type="hidden" name="id" value="{$id}">
                    <input type="hidden" name="modulechangepassword" value="true">

                    {if $username}
                    <div class="mb-3">
                        <label class="snbd-label">Username</label>
                        <input type="text" readonly class="form-control" value="{$username}">
                    </div>
                    {/if}

                    <div class="mb-3">
                        <label for="inputNewPassword1" class="snbd-label">New password</label>
                        <input type="password" class="form-control" id="inputNewPassword1" name="newpw" autocomplete="new-password" placeholder="Enter a new password">
                    </div>
                    <div class="mb-4">
                        <label for="inputNewPassword2" class="snbd-label">Confirm password</label>
                        <input type="password" class="form-control" id="inputNewPassword2" name="confirmpw" autocomplete="new-password" placeholder="Repeat the new password">
                    </div>
                    <button type="submit" class="snbd-btn snbd-btn--primary">Save changes</button>
                </form>
            </div>
        </section>
    </div>
    {/if}

    {if $downloads}
    <div class="tab-pane fade" id="tabDownloads" role="tabpanel" aria-labelledby="downloads-tab">
        <section class="snbd-card" aria-labelledby="downloads-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="downloads-title"><i class="ti ti-download" aria-hidden="true"></i>Downloads</h2>
            </div>
            <div class="snbd-table-wrap">
                <table class="snbd-table">
                    <caption class="snbd-visually-hidden">Files available for this service</caption>
                    <thead>
                        <tr><th scope="col">File</th><th scope="col">Description</th><th scope="col" class="snbd-table__actions">Action</th></tr>
                    </thead>
                    <tbody>
                        {foreach from=$downloads item=download}
                        <tr>
                            <td data-label="File" class="fw-semibold">{$download.title}</td>
                            <td data-label="Description" class="snbd-muted">{$download.description}</td>
                            <td class="snbd-table__actions" data-label="Action"><a href="{$download.link}" class="snbd-btn snbd-btn--sm snbd-btn--secondary">Download</a></td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </section>
    </div>
    {/if}

    {if $addons}
    <div class="tab-pane fade" id="tabAddons" role="tabpanel" aria-labelledby="addons-tab">
        <section class="snbd-card" aria-labelledby="addons-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="addons-title"><i class="ti ti-puzzle" aria-hidden="true"></i>Add-ons</h2>
            </div>
            <div class="snbd-table-wrap">
                <table class="snbd-table">
                    <caption class="snbd-visually-hidden">Add-ons attached to this service</caption>
                    <thead>
                        <tr><th scope="col">Add-on</th><th scope="col">Pricing</th><th scope="col">Next due</th><th scope="col">Status</th></tr>
                    </thead>
                    <tbody>
                        {foreach from=$addons item=addon}
                        <tr>
                            <td data-label="Add-on" class="fw-semibold">{$addon.name}</td>
                            <td data-label="Pricing" class="snbd-price">{$addon.pricing}</td>
                            <td data-label="Next due" class="snbd-muted">{$addon.nextduedate}</td>
                            <td data-label="Status">
                                {if $addon.status eq "Active"}
                                    <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Active</span>
                                {elseif $addon.status eq "Pending"}
                                    <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Pending</span>
                                {elseif $addon.status eq "Suspended"}
                                    <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Suspended</span>
                                {else}
                                    <span class="snbd-chip snbd-chip--neutral">{$addon.status}</span>
                                {/if}
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </section>
    </div>
    {/if}
</div>
