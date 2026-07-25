{if $warnings}
    {include file="$template/includes/alert.tpl" type="warning" msg=$warnings textcenter=true}
{/if}

<!-- Domains Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline" style="font-size: 2rem; margin-bottom: 0.25rem; font-weight: 800;">My <span class="dash-headline-accent">Domains</span></h1>
        <p class="text-muted small mb-0">Manage, renew, and configure your registered domain names and DNS.</p>
    </div>
    <a href="domainregister.php" class="btn btn-brand-clean d-inline-flex align-items-center gap-2" style="border-radius: 8px; padding: 0.6rem 1.25rem; font-weight: 600;">
        <i class="ti ti-plus" style="font-size: 1rem;"></i> Register New Domain
    </a>
</div>

<div class="tab-content">
    <div class="tab-pane fade show active" id="tabOverview">
        {include file="$template/includes/tablelist.tpl" tableName="DomainsList" noSortColumns="0, 1, 6" startOrderCol="2" filterColumn="5"}
        <script>
            jQuery(document).ready(function () {
                var table = jQuery('#tableDomainsList').show().DataTable();

                {if $orderby == 'domain'}
                    table.order(2, '{$sort}');
                {elseif $orderby == 'regdate' || $orderby == 'registrationdate'}
                    table.order(3, '{$sort}');
                {elseif $orderby == 'nextduedate'}
                    table.order(4, '{$sort}');
                {elseif $orderby == 'autorenew'}
                    table.order(5, '{$sort}');
                {elseif $orderby == 'status'}
                    table.order(6, '{$sort}');
                {/if}
                table.draw();
                jQuery('#tableLoading').hide();
            });
        </script>

        <form id="domainForm" method="post" action="clientarea.php?action=bulkdomain">
            <input id="bulkaction" name="update" type="hidden" />

            <!-- Bulk Action Toolbar -->
            <div class="d-flex align-items-center flex-wrap gap-2 mb-3">
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-outline-secondary btn-sm setBulkAction d-inline-flex align-items-center gap-1" id="nameservers" style="font-weight: 600;">
                        <i class="ti ti-world" style="font-size: 0.95rem;"></i>
                        {lang key='domainmanagens'}
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-sm setBulkAction d-inline-flex align-items-center gap-1" id="contactinfo" style="font-weight: 600;">
                        <i class="ti ti-user-edit" style="font-size: 0.95rem;"></i>
                        {lang key='domaincontactinfoedit'}
                    </button>
                    {if $allowrenew}
                        <button type="button" class="btn btn-outline-secondary btn-sm setBulkAction d-inline-flex align-items-center gap-1" id="renewDomains" style="font-weight: 600;">
                            <i class="ti ti-refresh" style="font-size: 0.95rem;"></i>
                            {lang key='domainmassrenew'}
                        </button>
                    {/if}
                </div>

                <div class="dropdown">
                    <button id="btnGroupDrop1" type="button" class="btn btn-outline-secondary btn-sm dropdown-toggle d-inline-flex align-items-center gap-1" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-weight: 600;">
                        <i class="ti ti-dots-vertical"></i> {lang key="more"}
                    </button>
                    <div class="dropdown-menu shadow-sm" aria-labelledby="btnGroupDrop1">
                        <a class="dropdown-item setBulkAction" href="#" id="autorenew">
                            <i class="ti ti-repeat me-2"></i> {lang key='domainautorenewstatus'}
                        </a>
                        <a class="dropdown-item setBulkAction" href="#" id="reglock">
                            <i class="ti ti-lock me-2"></i> {lang key='domainreglockstatus'}
                        </a>
                    </div>
                </div>
            </div>

            <!-- Table Container -->
            <div class="table-responsive rounded-3 border">
                <table id="tableDomainsList" class="table table-hover align-middle mb-0 w-100" style="display: none; font-size: 0.9rem;">
                    <thead class="table-light">
                        <tr>
                            <th class="width-fixed-20 ps-3" style="width: 40px;"></th>
                            <th style="width: 45px;">SSL</th>
                            <th>{lang key='orderdomain'}</th>
                            <th>{lang key='clientareahostingregdate'}</th>
                            <th>{lang key='clientareahostingnextduedate'}</th>
                            <th>{lang key='domainstatus'}</th>
                            <th class="text-end pe-3">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    {foreach $domains as $domain}
                        <tr>
                            <td class="ps-3">
                                <input type="checkbox" name="domids[]" class="domids form-check-input stopEventBubble" value="{$domain.id}" />
                            </td>
                            <td class="text-center ssl-info" data-element-id="{$domain.id}" data-type="domain" data-domain="{$domain.domain}">
                                {if $domain.sslStatus}
                                    <img src="{$domain.sslStatus->getImagePath()}" width="22" data-bs-toggle="tooltip" title="{$domain.sslStatus->getTooltipContent()}" class="{$domain.sslStatus->getClass()}">
                                {elseif !$domain.isActive}
                                    <img src="{$BASE_PATH_IMG}/ssl/ssl-inactive-domain.png" width="22" data-bs-toggle="tooltip" title="{lang key='sslState.sslInactiveDomain'}">
                                {/if}
                            </td>
                            <td>
                                <a href="clientarea.php?action=domaindetails&amp;id={$domain.id}" class="fw-bold text-decoration-none">{$domain.domain}</a>
                                <div class="small text-muted mt-0.5">
                                    {if $domain.autorenew}
                                        <span class="text-success"><i class="ti ti-check me-1"></i>Auto Renew On</span>
                                    {else}
                                        <span class="text-secondary"><i class="ti ti-x me-1"></i>Auto Renew Off</span>
                                    {/if}
                                </div>
                            </td>
                            <td><span class="w-hidden">{$domain.normalisedRegistrationDate}</span>{$domain.registrationdate}</td>
                            <td><span class="w-hidden">{$domain.normalisedNextDueDate}</span>{$domain.nextduedate}</td>
                            <td>
                                {if $domain.statusClass eq 'active'}
                                    <span class="badge bg-success">{$domain.statustext}</span>
                                {elseif $domain.statusClass eq 'pending'}
                                    <span class="badge bg-warning text-dark">{$domain.statustext}</span>
                                {elseif $domain.statusClass eq 'expired'}
                                    <span class="badge bg-danger">{$domain.statustext}</span>
                                {else}
                                    <span class="badge bg-secondary">{$domain.statustext}</span>
                                {/if}
                            </td>
                            <td class="text-end pe-3">
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-light border dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="border-radius: 6px; font-weight: 600; font-size: 0.8rem;">
                                        Manage
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" style="font-size: 0.85rem;">
                                        <li>
                                            <a class="dropdown-item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}">
                                                <i class="ti ti-settings me-2 text-primary"></i> Domain Overview
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabDNS">
                                                <i class="ti ti-dns me-2 text-danger"></i> Manage DNS
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabNameservers">
                                                <i class="ti ti-world me-2 text-info"></i> Nameservers
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabEPP">
                                                <i class="ti ti-key me-2 text-warning"></i> EPP Code
                                            </a>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <a class="dropdown-item" href="clientarea.php?action=domaindetails&amp;id={$domain.id}#tabContacts">
                                                <i class="ti ti-user me-2 text-secondary"></i> Contact Information
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                    {/foreach}
                    </tbody>
                </table>
                <div class="text-center py-4" id="tableLoading">
                    <div class="spinner-border spinner-border-sm text-danger" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
