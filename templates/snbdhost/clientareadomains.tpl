{assign var="domainTotal" value=$domains|@count}
{assign var="domainActive" value=0}
{assign var="domainAutoRenew" value=0}
{foreach $domains as $domain}
    {if $domain.statusClass eq 'active'}{assign var="domainActive" value=$domainActive+1}{/if}
    {if $domain.autorenew}{assign var="domainAutoRenew" value=$domainAutoRenew+1}{/if}
{/foreach}

{if $warnings}
<div class="snbd-alert snbd-alert--warn" role="status">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__title">Heads up</p>
        <p class="snbd-alert__text">{$warnings}</p>
    </div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">My domains</h1>
        <p class="snbd-page-sub">Manage registrations, nameservers, DNS records and renewal settings.</p>
    </div>
    <div class="snbd-page-actions">
        <a href="cart.php?a=add&amp;domain=register" class="snbd-btn snbd-btn--primary"><i class="ti ti-plus" aria-hidden="true"></i>Register a domain</a>
    </div>
</div>

<div class="snbd-stats snbd-stats--three">
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Domains</span>
            <span class="snbd-stat__value">{$domainTotal}</span>
            <span class="snbd-chip snbd-chip--neutral">On this account</span>
        </span>
        <span class="snbd-stat__icon"><i class="ti ti-world" aria-hidden="true"></i></span>
    </div>
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Active</span>
            <span class="snbd-stat__value">{$domainActive}</span>
            <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Registered</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--ok"><i class="ti ti-circle-check" aria-hidden="true"></i></span>
    </div>
    <div class="snbd-stat">
        <span class="snbd-stat__main">
            <span class="snbd-stat__label">Auto-renew</span>
            <span class="snbd-stat__value">{$domainAutoRenew}</span>
            <span class="snbd-chip snbd-chip--info"><span class="snbd-chip__dot" aria-hidden="true"></span>Enabled</span>
        </span>
        <span class="snbd-stat__icon snbd-stat__icon--info"><i class="ti ti-repeat" aria-hidden="true"></i></span>
    </div>
</div>

<section class="snbd-card mb-5">
    <div class="snbd-card__head">
        <h2 class="snbd-card__title"><i class="ti ti-world" aria-hidden="true"></i>Domain list</h2>
        <div class="snbd-card__actions">
            <a href="clientarea.php?action=domains" class="snbd-btn snbd-btn--sm snbd-btn--secondary"><i class="ti ti-refresh" aria-hidden="true"></i>Refresh</a>
        </div>
    </div>

    <div class="snbd-card__body snbd-card__body--tight">
        <form id="domainForm" method="post" action="clientarea.php?action=bulkdomain">
            <input id="bulkaction" name="update" type="hidden">
            <input type="hidden" name="token" value="{$token}">

            <div class="snbd-toolbar mb-3">
                <div class="snbd-cluster">
                    <button type="button" class="snbd-btn snbd-btn--sm snbd-btn--secondary setBulkAction" id="nameservers">
                        <i class="ti ti-world" aria-hidden="true"></i>{lang key='domainmanagens'}
                    </button>
                    <button type="button" class="snbd-btn snbd-btn--sm snbd-btn--secondary setBulkAction" id="contactinfo">
                        <i class="ti ti-user-edit" aria-hidden="true"></i>{lang key='domaincontactinfoedit'}
                    </button>
                    {if $allowrenew}
                    <button type="button" class="snbd-btn snbd-btn--sm snbd-btn--secondary setBulkAction" id="renewDomains">
                        <i class="ti ti-refresh" aria-hidden="true"></i>{lang key='domainmassrenew'}
                    </button>
                    {/if}

                    <div class="dropdown">
                        <button id="btnGroupDrop1" type="button" class="snbd-btn snbd-btn--sm snbd-btn--secondary dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="ti ti-dots" aria-hidden="true"></i>{lang key="more"}
                        </button>
                        <div class="dropdown-menu" aria-labelledby="btnGroupDrop1">
                            <a class="dropdown-item snbd-menu__item setBulkAction" href="#" id="autorenew">
                                <i class="ti ti-repeat" aria-hidden="true"></i>{lang key='domainautorenewstatus'}
                            </a>
                            <a class="dropdown-item snbd-menu__item setBulkAction" href="#" id="reglock">
                                <i class="ti ti-lock" aria-hidden="true"></i>{lang key='domainreglockstatus'}
                            </a>
                        </div>
                    </div>
                </div>
                <p class="snbd-caption mb-0">Select domains with the checkboxes to use bulk actions.</p>
            </div>

            <div class="snbd-table-wrap snbd-datatable-scope">
                <table id="tableDomainsList" class="snbd-table w-100 d-none">
                    <caption class="snbd-visually-hidden">Your registered domains</caption>
                    <thead>
                        <tr>
                            <th scope="col" class="snbd-col-check"><span class="snbd-visually-hidden">Select</span></th>
                            <th scope="col" class="snbd-col-ssl">SSL</th>
                            <th scope="col">{lang key='orderdomain'}</th>
                            <th scope="col">{lang key='clientareahostingregdate'}</th>
                            <th scope="col">{lang key='clientareahostingnextduedate'}</th>
                            <th scope="col">{lang key='domainstatus'}</th>
                            <th scope="col" class="snbd-table__actions">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $domains as $domain}
                        <tr>
                            <td>
                                <input type="checkbox" name="domids[]" class="domids form-check-input stopEventBubble" value="{$domain.id}" aria-label="Select {$domain.domain}">
                            </td>
                            <td class="text-center ssl-info" data-element-id="{$domain.id}" data-type="domain" data-domain="{$domain.domain}">
                                {if $domain.sslStatus}
                                    <img src="{$domain.sslStatus->getImagePath()}" width="22" data-bs-toggle="tooltip" title="{$domain.sslStatus->getTooltipContent()}" class="{$domain.sslStatus->getClass()}" alt="SSL status">
                                {elseif !$domain.isActive}
                                    <img src="{$BASE_PATH_IMG}/ssl/ssl-inactive-domain.png" width="22" data-bs-toggle="tooltip" title="{lang key='sslState.sslInactiveDomain'}" alt="SSL inactive">
                                {/if}
                            </td>
                            <td data-label="Domain">
                                <a href="clientarea.php?action=domaindetails&amp;id={$domain.id}" class="fw-semibold">{$domain.domain}</a>
                                <div class="snbd-caption mt-1">
                                    {if $domain.autorenew}
                                        <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Auto-renew on</span>
                                    {else}
                                        <span class="snbd-chip snbd-chip--neutral"><span class="snbd-chip__dot" aria-hidden="true"></span>Auto-renew off</span>
                                    {/if}
                                </div>
                            </td>
                            <td data-label="Registered"><span class="snbd-visually-hidden">{$domain.normalisedRegistrationDate}</span>{$domain.registrationdate}</td>
                            <td data-label="Next due"><span class="snbd-visually-hidden">{$domain.normalisedNextDueDate}</span>{$domain.nextduedate}</td>
                            <td data-label="Status">
                                {if $domain.statusClass eq 'active'}
                                    <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>{$domain.statustext}</span>
                                {elseif $domain.statusClass eq 'pending'}
                                    <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>{$domain.statustext}</span>
                                {elseif $domain.statusClass eq 'expired'}
                                    <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>{$domain.statustext}</span>
                                {else}
                                    <span class="snbd-chip snbd-chip--neutral">{$domain.statustext}</span>
                                {/if}
                            </td>
                            <td class="snbd-table__actions" data-label="Action">
                                <div class="dropdown">
                                    <button class="snbd-btn snbd-btn--sm snbd-btn--secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        Manage
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item snbd-menu__item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}"><i class="ti ti-settings" aria-hidden="true"></i>Domain overview</a></li>
                                        <li><a class="dropdown-item snbd-menu__item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabDNS"><i class="ti ti-dns" aria-hidden="true"></i>Manage DNS</a></li>
                                        <li><a class="dropdown-item snbd-menu__item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabNameservers"><i class="ti ti-world" aria-hidden="true"></i>Nameservers</a></li>
                                        <li><a class="dropdown-item snbd-menu__item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabEPP"><i class="ti ti-key" aria-hidden="true"></i>EPP code</a></li>
                                        <li><hr class="snbd-menu__divider"></li>
                                        <li><a class="dropdown-item snbd-menu__item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabContacts"><i class="ti ti-user" aria-hidden="true"></i>Contact information</a></li>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
                <div class="text-center py-4" id="tableLoading">
                    <span class="snbd-skel snbd-skel--wide" aria-hidden="true"></span>
                    <span class="snbd-visually-hidden">Loading domains</span>
                </div>
            </div>
        </form>
    </div>
</section>

<script>
    jQuery(document).ready(function () {
        var table = jQuery('#tableDomainsList').removeClass('d-none').DataTable();
        {if $orderby == 'domain'}
            table.order(2, '{$sort}');
        {elseif $orderby == 'regdate' || $orderby == 'registrationdate'}
            table.order(3, '{$sort}');
        {elseif $orderby == 'nextduedate'}
            table.order(4, '{$sort}');
        {elseif $orderby == 'status'}
            table.order(5, '{$sort}');
        {/if}
        table.draw();
        jQuery('#tableLoading').addClass('d-none');
    });
</script>
