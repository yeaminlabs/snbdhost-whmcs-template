<!-- Services Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="h4 fw-bold mb-0">My Services</h2>
    <a href="cart.php" class="btn btn-brand"><i class="fas fa-plus me-2"></i>Order New</a>
</div>

<!-- Service Cards Grid -->
<div class="row g-3 mb-4">
    {foreach key=num item=service from=$services}
    <div class="col-md-6 col-xl-4">
        <div class="card service-card h-100 {if $service.status eq 'Active'}service-active{elseif $service.status eq 'Pending'}service-pending{elseif $service.status eq 'Suspended'}service-suspended{/if}">
            <div class="card-body d-flex flex-column">
                <!-- Header: icon + status -->
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div class="stat-icon icon-services">
                        <i class="fas fa-server"></i>
                    </div>
                    {if $service.status eq "Active"}
                        <span class="badge bg-success">Active</span>
                    {elseif $service.status eq "Pending"}
                        <span class="badge bg-warning">Pending</span>
                    {elseif $service.status eq "Suspended"}
                        <span class="badge bg-danger">Suspended</span>
                    {elseif $service.status eq "Terminated"}
                        <span class="badge bg-secondary">Terminated</span>
                    {elseif $service.status eq "Cancelled"}
                        <span class="badge bg-secondary">Cancelled</span>
                    {else}
                        <span class="badge bg-secondary">{$service.status}</span>
                    {/if}
                </div>

                <!-- Product Name & Domain -->
                <h5 class="fw-semibold mb-1 text-truncate" title="{$service.product}">{$service.product}</h5>
                <div class="text-secondary small mb-3 text-truncate">
                    {if $service.domain}
                        <i class="fas fa-globe me-1"></i>{$service.domain}
                    {else}
                        <i class="fas fa-minus me-1"></i>No domain
                    {/if}
                </div>

                <!-- Pricing & Due Date -->
                <div class="mt-auto">
                    <div class="d-flex justify-content-between mb-3">
                        <div>
                            <div class="small text-secondary">Price</div>
                            <div class="fw-semibold">{$service.amount}</div>
                        </div>
                        <div class="text-end">
                            <div class="small text-secondary">Next Due</div>
                            <div class="fw-semibold">{$service.nextduedate}</div>
                        </div>
                    </div>
                    <div class="small text-secondary mb-3">
                        <i class="fas fa-sync-alt me-1"></i>{$service.billingcycle}
                    </div>
                    <a href="clientarea.php?action=productdetails&id={$service.id}" class="btn btn-outline-custom w-100 btn-sm">
                        <i class="fas fa-cog me-1"></i>Manage Service
                    </a>
                </div>
            </div>
        </div>
    </div>
    {foreachelse}
    <div class="col-12">
        <div class="card">
            <div class="card-body">
                <div class="empty-state">
                    <i class="fas fa-cube d-block"></i>
                    <p>No services found. <a href="cart.php">Order your first service</a></p>
                </div>
            </div>
        </div>
    </div>
    {/foreach}
</div>

{if $prevpage || $nextpage}
<div class="d-flex justify-content-between">
    <a href="?action=products&page={$prevpage}" class="btn btn-outline-custom {if !$prevpage}disabled{/if}"><i class="fas fa-arrow-left me-2"></i>Previous</a>
    <a href="?action=products&page={$nextpage}" class="btn btn-outline-custom {if !$nextpage}disabled{/if}">Next<i class="fas fa-arrow-right ms-2"></i></a>
</div>
{/if}
