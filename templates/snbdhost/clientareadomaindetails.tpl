{if $alerts}
    {foreach $alerts as $alert}
    <div class="snbd-alert snbd-alert--{if $alert.type eq 'success'}ok{elseif $alert.type eq 'danger'}bad{elseif $alert.type eq 'warning'}warn{else}info{/if}" role="status">
        <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
        <div class="snbd-alert__body"><p class="snbd-alert__text">{$alert.message}</p></div>
    </div>
    {/foreach}
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Domain</p>
        <h1 class="snbd-page-title">{$domain}</h1>
        <div class="snbd-cluster mt-2">
            {if $status eq 'Active'}
                <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Active</span>
            {elseif $status eq 'Pending'}
                <span class="snbd-chip snbd-chip--warn"><span class="snbd-chip__dot" aria-hidden="true"></span>Pending</span>
            {elseif $status eq 'Expired'}
                <span class="snbd-chip snbd-chip--bad"><span class="snbd-chip__dot" aria-hidden="true"></span>Expired</span>
            {else}
                <span class="snbd-chip snbd-chip--neutral">{$status}</span>
            {/if}
            <span class="snbd-chip snbd-chip--neutral">Registered {$registrationdate}</span>
            <span class="snbd-chip snbd-chip--neutral">Renews {$nextduedate}</span>
        </div>
    </div>
    <div class="snbd-page-actions">
        <a href="http://{$domain}" target="_blank" rel="noopener" class="snbd-btn snbd-btn--secondary"><i class="ti ti-external-link" aria-hidden="true"></i>Visit website</a>
        <a href="clientarea.php?action=domains" class="snbd-btn snbd-btn--secondary"><i class="ti ti-arrow-left" aria-hidden="true"></i>All domains</a>
    </div>
</div>

<ul class="nav snbd-tabs" id="domainTabs" role="tablist">
    <li role="presentation"><button class="snbd-tab active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#tabOverview" type="button" role="tab" aria-controls="tabOverview" aria-selected="true">Overview</button></li>
    <li role="presentation"><button class="snbd-tab" id="nameservers-tab" data-bs-toggle="tab" data-bs-target="#tabNameservers" type="button" role="tab" aria-controls="tabNameservers" aria-selected="false">Nameservers</button></li>
    {if $dnsmanagement}
    <li role="presentation"><button class="snbd-tab" id="dns-tab" data-bs-toggle="tab" data-bs-target="#tabDNSManagement" type="button" role="tab" aria-controls="tabDNSManagement" aria-selected="false">DNS records</button></li>
    {/if}
    {if $eppcode}
    <li role="presentation"><button class="snbd-tab" id="epp-tab" data-bs-toggle="tab" data-bs-target="#tabEPP" type="button" role="tab" aria-controls="tabEPP" aria-selected="false">EPP code</button></li>
    {/if}
    <li role="presentation"><button class="snbd-tab" id="contacts-tab" data-bs-toggle="tab" data-bs-target="#tabContacts" type="button" role="tab" aria-controls="tabContacts" aria-selected="false">Contacts</button></li>
    <li role="presentation"><button class="snbd-tab" id="autorenew-tab" data-bs-toggle="tab" data-bs-target="#tabAutoRenew" type="button" role="tab" aria-controls="tabAutoRenew" aria-selected="false">Auto-renew</button></li>
</ul>

<div class="tab-content" id="domainTabsContent">
    <div class="tab-pane fade show active" id="tabOverview" role="tabpanel" aria-labelledby="overview-tab">
        <div class="row g-4">
            <div class="col-lg-6">
                <section class="snbd-card h-100" aria-labelledby="domain-status-title">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title" id="domain-status-title"><i class="ti ti-shield-check" aria-hidden="true"></i>Status &amp; security</h2>
                    </div>
                    <div class="snbd-card__body">
                        <dl class="snbd-kv">
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Registrar lock</dt>
                                <dd class="snbd-kv__v">
                                    {if $lockstatus eq 'locked'}
                                        <span class="snbd-chip snbd-chip--ok"><i class="ti ti-lock" aria-hidden="true"></i>Locked</span>
                                    {else}
                                        <span class="snbd-chip snbd-chip--warn"><i class="ti ti-lock-open" aria-hidden="true"></i>Unlocked</span>
                                    {/if}
                                </dd>
                            </div>
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Auto-renew</dt>
                                <dd class="snbd-kv__v">
                                    {if $autorenew}
                                        <span class="snbd-chip snbd-chip--ok"><span class="snbd-chip__dot" aria-hidden="true"></span>Enabled</span>
                                    {else}
                                        <span class="snbd-chip snbd-chip--neutral"><span class="snbd-chip__dot" aria-hidden="true"></span>Disabled</span>
                                    {/if}
                                </dd>
                            </div>
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">First registered</dt>
                                <dd class="snbd-kv__v">{$registrationdate}</dd>
                            </div>
                            <div class="snbd-kv__row">
                                <dt class="snbd-kv__k">Next due</dt>
                                <dd class="snbd-kv__v">{$nextduedate}</dd>
                            </div>
                        </dl>
                    </div>
                </section>
            </div>

            <div class="col-lg-6">
                <section class="snbd-card h-100" aria-labelledby="domain-manage-title">
                    <div class="snbd-card__head">
                        <h2 class="snbd-card__title" id="domain-manage-title"><i class="ti ti-adjustments" aria-hidden="true"></i>Manage</h2>
                    </div>
                    <div class="snbd-card__body">
                        <div class="snbd-stack snbd-stack--sm">
                            {if $dnsmanagement}
                            <button type="button" class="snbd-linkrow" onclick="document.getElementById('dns-tab').click()">
                                <span><i class="ti ti-dns" aria-hidden="true"></i>Configure DNS records</span>
                                <i class="ti ti-chevron-right" aria-hidden="true"></i>
                            </button>
                            {/if}
                            <button type="button" class="snbd-linkrow" onclick="document.getElementById('nameservers-tab').click()">
                                <span><i class="ti ti-world" aria-hidden="true"></i>Update nameservers</span>
                                <i class="ti ti-chevron-right" aria-hidden="true"></i>
                            </button>
                            {if $eppcode}
                            <button type="button" class="snbd-linkrow" onclick="document.getElementById('epp-tab').click()">
                                <span><i class="ti ti-key" aria-hidden="true"></i>View EPP transfer code</span>
                                <i class="ti ti-chevron-right" aria-hidden="true"></i>
                            </button>
                            {/if}
                            <a class="snbd-linkrow" href="clientarea.php?action=domaincontacts&amp;domainid={$domainid}">
                                <span><i class="ti ti-user-edit" aria-hidden="true"></i>Edit contact details</span>
                                <i class="ti ti-chevron-right" aria-hidden="true"></i>
                            </a>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <div class="tab-pane fade" id="tabNameservers" role="tabpanel" aria-labelledby="nameservers-tab">
        <section class="snbd-card" aria-labelledby="nameservers-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="nameservers-title"><i class="ti ti-world" aria-hidden="true"></i>Nameservers</h2>
            </div>
            <div class="snbd-card__body snbd-form">
                <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
                    <input type="hidden" name="token" value="{$token}">
                    <input type="hidden" name="id" value="{$domainid}">
                    <input type="hidden" name="sub" value="savens">

                    <div class="snbd-choice">
                        <label class="snbd-choice__option">
                            <input class="form-check-input" type="radio" name="nschoice" id="nschoiceDefault" value="default" {if $defaultns}checked{/if}>
                            <span><strong>Use SNBD Host nameservers</strong><small>Recommended — we manage DNS on our infrastructure.</small></span>
                        </label>
                        <label class="snbd-choice__option">
                            <input class="form-check-input" type="radio" name="nschoice" id="nschoiceCustom" value="custom" {if !$defaultns}checked{/if}>
                            <span><strong>Use custom nameservers</strong><small>Point this domain at another DNS provider.</small></span>
                        </label>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="snbd-label" for="ns1">Nameserver 1</label>
                            <input type="text" class="form-control" id="ns1" name="ns1" value="{$ns1}">
                        </div>
                        <div class="col-md-6">
                            <label class="snbd-label" for="ns2">Nameserver 2</label>
                            <input type="text" class="form-control" id="ns2" name="ns2" value="{$ns2}">
                        </div>
                        <div class="col-md-6">
                            <label class="snbd-label" for="ns3">Nameserver 3 <span class="snbd-muted fw-normal">(optional)</span></label>
                            <input type="text" class="form-control" id="ns3" name="ns3" value="{$ns3}">
                        </div>
                        <div class="col-md-6">
                            <label class="snbd-label" for="ns4">Nameserver 4 <span class="snbd-muted fw-normal">(optional)</span></label>
                            <input type="text" class="form-control" id="ns4" name="ns4" value="{$ns4}">
                        </div>
                    </div>

                    <button type="submit" class="snbd-btn snbd-btn--primary">Save nameservers</button>
                </form>
            </div>
        </section>
    </div>

    {if $dnsmanagement}
    <div class="tab-pane fade" id="tabDNSManagement" role="tabpanel" aria-labelledby="dns-tab">
        <section class="snbd-card" aria-labelledby="dns-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="dns-title"><i class="ti ti-dns" aria-hidden="true"></i>DNS records</h2>
            </div>
            <div class="snbd-card__body snbd-form">
                <p class="snbd-caption mb-4">Add, modify or remove A, AAAA, CNAME, MX and TXT records for {$domain}.</p>

                {if $addonmodulestext}
                    {$addonmodulestext}
                {else}
                <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
                    <input type="hidden" name="token" value="{$token}">
                    <input type="hidden" name="id" value="{$domainid}">
                    <input type="hidden" name="sub" value="savedns">
                    <div class="snbd-table-wrap mb-4">
                        <table class="snbd-table snbd-table--compact">
                            <caption class="snbd-visually-hidden">DNS records for {$domain}</caption>
                            <thead>
                                <tr>
                                    <th scope="col">Hostname</th>
                                    <th scope="col">Type</th>
                                    <th scope="col">Value</th>
                                    <th scope="col">Priority</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach from=$dnsrecords item=dnsrecord}
                                <tr>
                                    <td data-label="Hostname">
                                        <input type="hidden" name="dnsrecordid[]" value="{$dnsrecord.id}">
                                        <input type="text" name="dnsrecordhost[]" value="{$dnsrecord.hostname}" class="form-control form-control-sm" aria-label="Hostname">
                                    </td>
                                    <td data-label="Type">
                                        <select name="dnsrecordtype[]" class="form-select form-select-sm" aria-label="Record type">
                                            <option value="A"{if $dnsrecord.type eq "A"} selected{/if}>A</option>
                                            <option value="AAAA"{if $dnsrecord.type eq "AAAA"} selected{/if}>AAAA</option>
                                            <option value="CNAME"{if $dnsrecord.type eq "CNAME"} selected{/if}>CNAME</option>
                                            <option value="MX"{if $dnsrecord.type eq "MX"} selected{/if}>MX</option>
                                            <option value="TXT"{if $dnsrecord.type eq "TXT"} selected{/if}>TXT</option>
                                        </select>
                                    </td>
                                    <td data-label="Value"><input type="text" name="dnsrecordaddress[]" value="{$dnsrecord.address}" class="form-control form-control-sm" aria-label="Record value"></td>
                                    <td data-label="Priority"><input type="text" name="dnsrecordpriority[]" value="{$dnsrecord.priority}" class="form-control form-control-sm" aria-label="Priority"></td>
                                </tr>
                                {foreachelse}
                                <tr>
                                    <td colspan="4" class="snbd-faint text-center">No DNS records found. Add a new record below.</td>
                                </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                    <button type="submit" class="snbd-btn snbd-btn--primary">Save DNS changes</button>
                </form>
                {/if}
            </div>
        </section>
    </div>
    {/if}

    {if $eppcode}
    <div class="tab-pane fade" id="tabEPP" role="tabpanel" aria-labelledby="epp-tab">
        <section class="snbd-card" aria-labelledby="epp-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="epp-title"><i class="ti ti-key" aria-hidden="true"></i>EPP / authorisation code</h2>
            </div>
            <div class="snbd-card__body">
                <p class="snbd-caption mb-3">Give this code to your new registrar when transferring the domain away from SNBD Host.</p>
                <div class="snbd-copy">
                    <input type="text" id="eppCode" value="{$eppcode}" readonly aria-label="EPP authorisation code" class="snbd-mono">
                    <button type="button" data-snbd-copy="#eppCode" aria-label="Copy EPP code"><i class="ti ti-copy" aria-hidden="true"></i></button>
                </div>
            </div>
        </section>
    </div>
    {/if}

    <div class="tab-pane fade" id="tabContacts" role="tabpanel" aria-labelledby="contacts-tab">
        <section class="snbd-card" aria-labelledby="contacts-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="contacts-title"><i class="ti ti-user-edit" aria-hidden="true"></i>Contact information</h2>
            </div>
            <div class="snbd-card__body">
                <p class="snbd-caption mb-3">Registrant, admin, technical and billing contacts for this domain.</p>
                <a href="clientarea.php?action=domaincontacts&amp;domainid={$domainid}" class="snbd-btn snbd-btn--primary">Edit contact details</a>
            </div>
        </section>
    </div>

    <div class="tab-pane fade" id="tabAutoRenew" role="tabpanel" aria-labelledby="autorenew-tab">
        <section class="snbd-card" aria-labelledby="autorenew-title">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="autorenew-title"><i class="ti ti-repeat" aria-hidden="true"></i>Auto-renew</h2>
            </div>
            <div class="snbd-card__body">
                <p class="snbd-caption mb-4">With auto-renew on, we generate an invoice before the domain expires so you never lose it by accident.</p>
                <form method="post" action="{$smarty.server.PHP_SELF}?action=domaindetails">
                    <input type="hidden" name="token" value="{$token}">
                    <input type="hidden" name="id" value="{$domainid}">
                    <input type="hidden" name="sub" value="autorenew">
                    {if $autorenew}
                        <input type="hidden" name="autorenew" value="disable">
                        <button type="submit" class="snbd-btn snbd-btn--danger">Disable auto-renew</button>
                    {else}
                        <input type="hidden" name="autorenew" value="enable">
                        <button type="submit" class="snbd-btn snbd-btn--primary">Enable auto-renew</button>
                    {/if}
                </form>
            </div>
        </section>
    </div>
</div>

<script>
{literal}
document.addEventListener("DOMContentLoaded", function () {
    var hash = window.location.hash;
    if (!hash) return;
    var trigger = document.querySelector('button[data-bs-target="' + hash + '"]');
    if (trigger && window.bootstrap) new bootstrap.Tab(trigger).show();
});
{/literal}
</script>
