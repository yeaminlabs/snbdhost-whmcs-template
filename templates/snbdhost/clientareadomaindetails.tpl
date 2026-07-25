{if $alerts}
    {foreach $alerts as $alert}
        {include file="$template/includes/alert.tpl" type=$alert.type msg=$alert.message textcenter=true}
    {/foreach}
{/if}

<!-- Domain Overview Header Card -->
<div class="card border-0 mb-4 shadow-sm" style="border-radius: 16px; overflow: hidden; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
    <div class="card-body p-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <h1 class="dash-headline mb-0" style="font-size: 2rem; font-weight: 800;">{$domain}</h1>
                    {if $status eq 'Active'}
                        <span class="badge bg-success">Active</span>
                    {elseif $status eq 'Pending'}
                        <span class="badge bg-warning text-dark">Pending</span>
                    {elseif $status eq 'Expired'}
                        <span class="badge bg-danger">Expired</span>
                    {else}
                        <span class="badge bg-secondary">{$status}</span>
                    {/if}
                </div>
                <p class="text-muted small mb-0">
                    Registration Date: <strong>{$registrationdate}</strong> • Next Due Date: <strong>{$nextduedate}</strong>
                </p>
            </div>
            
            <div class="d-flex align-items-center gap-2">
                <a href="http://{$domain}" target="_blank" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1" style="font-weight: 600;">
                    <i class="ti ti-external-link"></i> Visit Website
                </a>
                <a href="clientarea.php?action=domains" class="btn btn-brand-clean btn-sm d-inline-flex align-items-center gap-1" style="font-weight: 600;">
                    <i class="ti ti-arrow-left"></i> Back to Domains
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Nav Tabs -->
<ul class="nav nav-tabs border-bottom-0 gap-2 mb-4" id="domainTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active fw-bold px-3 py-2 border-0 rounded-3" id="overview-tab" data-bs-toggle="tab" data-bs-target="#tabOverview" type="button" role="tab" style="font-size: 0.9rem;">
            <i class="ti ti-info-circle me-1"></i> Overview
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold px-3 py-2 border-0 rounded-3" id="nameservers-tab" data-bs-toggle="tab" data-bs-target="#tabNameservers" type="button" role="tab" style="font-size: 0.9rem;">
            <i class="ti ti-world me-1"></i> Nameservers
        </button>
    </li>
    {if $dnsmanagement}
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold px-3 py-2 border-0 rounded-3" id="dns-tab" data-bs-toggle="tab" data-bs-target="#tabDNSManagement" type="button" role="tab" style="font-size: 0.9rem;">
            <i class="ti ti-dns me-1 text-danger"></i> DNS Management
        </button>
    </li>
    {/if}
    {if $eppcode}
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold px-3 py-2 border-0 rounded-3" id="epp-tab" data-bs-toggle="tab" data-bs-target="#tabEPP" type="button" role="tab" style="font-size: 0.9rem;">
            <i class="ti ti-key me-1 text-warning"></i> EPP Code
        </button>
    </li>
    {/if}
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold px-3 py-2 border-0 rounded-3" id="contacts-tab" data-bs-toggle="tab" data-bs-target="#tabContacts" type="button" role="tab" style="font-size: 0.9rem;">
            <i class="ti ti-user-edit me-1"></i> Contact Info
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link fw-bold px-3 py-2 border-0 rounded-3" id="autorenew-tab" data-bs-toggle="tab" data-bs-target="#tabAutoRenew" type="button" role="tab" style="font-size: 0.9rem;">
            <i class="ti ti-repeat me-1"></i> Auto Renew
        </button>
    </li>
</ul>

<div class="tab-content" id="domainTabsContent">

    <!-- Tab 1: Overview -->
    <div class="tab-pane fade show active" id="tabOverview" role="tabpanel">
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm h-100" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                            <i class="ti ti-shield-check text-success"></i> Domain Status & Security
                        </h5>
                        <table class="table table-borderless small mb-0">
                            <tr>
                                <td class="text-muted ps-0">Registrar Lock:</td>
                                <td class="text-end fw-bold">
                                    {if $lockstatus eq 'locked'}
                                        <span class="text-success"><i class="ti ti-lock me-1"></i> Locked</span>
                                    {else}
                                        <span class="text-warning"><i class="ti ti-lock-open me-1"></i> Unlocked</span>
                                    {/if}
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted ps-0">Auto Renew Status:</td>
                                <td class="text-end fw-bold">
                                    {if $autorenew}
                                        <span class="text-success"><i class="ti ti-check me-1"></i> Enabled</span>
                                    {else}
                                        <span class="text-secondary"><i class="ti ti-x me-1"></i> Disabled</span>
                                    {/if}
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted ps-0">First Registered:</td>
                                <td class="text-end fw-bold">{$registrationdate}</td>
                            </tr>
                            <tr>
                                <td class="text-muted ps-0">Next Due Date:</td>
                                <td class="text-end fw-bold">{$nextduedate}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card border-0 shadow-sm h-100" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                            <i class="ti ti-bolt text-danger"></i> Quick Management Options
                        </h5>
                        <div class="d-flex flex-column gap-2">
                            {if $dnsmanagement}
                            <button type="button" onclick="jQuery('#dns-tab').click()" class="btn btn-outline-secondary btn-sm text-start py-2 px-3 d-flex justify-content-between align-items-center" style="font-weight: 600;">
                                <span><i class="ti ti-dns text-danger me-2"></i> Configure DNS Host Records</span>
                                <i class="ti ti-chevron-right"></i>
                            </button>
                            {/if}
                            <button type="button" onclick="jQuery('#nameservers-tab').click()" class="btn btn-outline-secondary btn-sm text-start py-2 px-3 d-flex justify-content-between align-items-center" style="font-weight: 600;">
                                <span><i class="ti ti-world text-info me-2"></i> Update Nameservers</span>
                                <i class="ti ti-chevron-right"></i>
                            </button>
                            {if $eppcode}
                            <button type="button" onclick="jQuery('#epp-tab').click()" class="btn btn-outline-secondary btn-sm text-start py-2 px-3 d-flex justify-content-between align-items-center" style="font-weight: 600;">
                                <span><i class="ti ti-key text-warning me-2"></i> View EPP / Auth Transfer Code</span>
                                <i class="ti ti-chevron-right"></i>
                            </button>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Tab 2: Nameservers -->
    <div class="tab-pane fade" id="tabNameservers" role="tabpanel">
        <div class="card border-0 shadow-sm" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-3"><i class="ti ti-world me-2 text-info"></i> Manage Nameservers</h5>
                <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
                    <input type="hidden" name="id" value="{$domainid}">
                    <input type="hidden" name="sub" value="savens">
                    
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="nschoice" id="nschoiceDefault" value="default" {if $defaultns}checked{/if}>
                        <label class="form-check-label fw-semibold" for="nschoiceDefault">
                            Use Default Nameservers (SNBD Host Infrastructure)
                        </label>
                    </div>
                    <div class="form-check mb-4">
                        <input class="form-check-input" type="radio" name="nschoice" id="nschoiceCustom" value="custom" {if !$defaultns}checked{/if}>
                        <label class="form-check-label fw-semibold" for="nschoiceCustom">
                            Use Custom Nameservers (Enter below)
                        </label>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Nameserver 1</label>
                            <input type="text" class="form-control" name="ns1" value="{$ns1}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Nameserver 2</label>
                            <input type="text" class="form-control" name="ns2" value="{$ns2}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Nameserver 3 (Optional)</label>
                            <input type="text" class="form-control" name="ns3" value="{$ns3}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted">Nameserver 4 (Optional)</label>
                            <input type="text" class="form-control" name="ns4" value="{$ns4}">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-brand-clean fw-bold py-2 px-4" style="border-radius: 8px;">
                        Save Nameservers
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Tab 3: DNS Management -->
    {if $dnsmanagement}
    <div class="tab-pane fade" id="tabDNSManagement" role="tabpanel">
        <div class="card border-0 shadow-sm" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-2"><i class="ti ti-dns me-2 text-danger"></i> DNS Host Records Management</h5>
                <p class="text-muted small mb-4">Add, modify, or remove A, CNAME, MX, and TXT DNS records for {$domain}.</p>
                
                {if $addonmodulestext}
                    {$addonmodulestext}
                {else}
                    <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
                        <input type="hidden" name="id" value="{$domainid}">
                        <input type="hidden" name="sub" value="savedns">
                        
                        <div class="table-responsive mb-4">
                            <table class="table align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Hostname / Name</th>
                                        <th>Record Type</th>
                                        <th>Address / Target Value</th>
                                        <th>Priority / MX</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach from=$dnsrecords item=dnsrecord}
                                    <tr>
                                        <td>
                                            <input type="text" name="dnsrecordhost[]" value="{$dnsrecord.hostname}" class="form-control form-control-sm">
                                        </td>
                                        <td>
                                            <select name="dnsrecordtype[]" class="form-select form-select-sm">
                                                <option value="A"{if $dnsrecord.type eq "A"} selected{/if}>A (Address)</option>
                                                <option value="AAAA"{if $dnsrecord.type eq "AAAA"} selected{/if}>AAAA (IPv6)</option>
                                                <option value="CNAME"{if $dnsrecord.type eq "CNAME"} selected{/if}>CNAME (Alias)</option>
                                                <option value="MX"{if $dnsrecord.type eq "MX"} selected{/if}>MX (Mail Exchange)</option>
                                                <option value="TXT"{if $dnsrecord.type eq "TXT"} selected{/if}>TXT (Text)</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" name="dnsrecordaddress[]" value="{$dnsrecord.address}" class="form-control form-control-sm">
                                        </td>
                                        <td>
                                            <input type="text" name="dnsrecordpriority[]" value="{$dnsrecord.priority}" class="form-control form-control-sm" style="max-width: 80px;">
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>

                        <button type="submit" class="btn btn-brand-clean fw-bold py-2 px-4" style="border-radius: 8px;">
                            Save DNS Changes
                        </button>
                    </form>
                {/if}
            </div>
        </div>
    </div>
    {/if}

    <!-- Tab 4: EPP Code -->
    {if $eppcode}
    <div class="tab-pane fade" id="tabEPP" role="tabpanel">
        <div class="card border-0 shadow-sm" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-3"><i class="ti ti-key me-2 text-warning"></i> EPP / Authorization Transfer Code</h5>
                <p class="text-muted small mb-3">Use this code if you wish to transfer your domain registration to another registrar.</p>

                <div class="alert alert-light border p-3 rounded-3 font-monospace d-flex justify-content-between align-items-center">
                    <span id="eppCodeText" class="fw-bold text-dark fs-6">{$eppcode}</span>
                    <button type="button" onclick="navigator.clipboard.writeText('{$eppcode}')" class="btn btn-sm btn-outline-secondary">
                        <i class="ti ti-copy"></i> Copy Code
                    </button>
                </div>
            </div>
        </div>
    </div>
    {/if}

    <!-- Tab 5: Contact Info -->
    <div class="tab-pane fade" id="tabContacts" role="tabpanel">
        <div class="card border-0 shadow-sm" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-3"><i class="ti ti-user-edit me-2"></i> Domain Contact Information</h5>
                <a href="clientarea.php?action=domaincontacts&amp;domainid={$domainid}" class="btn btn-brand-clean fw-bold py-2 px-4" style="border-radius: 8px;">
                    Edit Registrant & Contact Details
                </a>
            </div>
        </div>
    </div>

    <!-- Tab 6: Auto Renew -->
    <div class="tab-pane fade" id="tabAutoRenew" role="tabpanel">
        <div class="card border-0 shadow-sm" style="border-radius: 14px; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="card-body p-4">
                <h5 class="fw-bold mb-2"><i class="ti ti-repeat me-2"></i> Auto Renew Settings</h5>
                <p class="text-muted small mb-4">When auto-renew is enabled, we automatically generate an invoice prior to your domain's expiration date.</p>

                <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
                    <input type="hidden" name="id" value="{$domainid}">
                    <input type="hidden" name="sub" value="autorenew">
                    
                    {if $autorenew}
                        <input type="hidden" name="autorenew" value="disable">
                        <button type="submit" class="btn btn-danger fw-bold py-2 px-4" style="border-radius: 8px;">
                            Disable Auto Renew
                        </button>
                    {else}
                        <input type="hidden" name="autorenew" value="enable">
                        <button type="submit" class="btn btn-success fw-bold py-2 px-4" style="border-radius: 8px;">
                            Enable Auto Renew
                        </button>
                    {/if}
                </form>
            </div>
        </div>
    </div>

</div>

<!-- Tab hash activation script -->
<script>
{literal}
document.addEventListener("DOMContentLoaded", function() {
    var hash = window.location.hash;
    if (hash) {
        var triggerEl = document.querySelector('button[data-bs-target="' + hash + '"]');
        if (triggerEl) {
            var tab = new bootstrap.Tab(triggerEl);
            tab.show();
        }
    }
});
{/literal}
</script>
