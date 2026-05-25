<!-- Services Page Header -->
<div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
    <div>
        <h1 class="dash-headline" style="font-size: 2.25rem; margin-bottom: 0.25rem;">My <span class="dash-headline-accent">Services.</span></h1>
        <p class="text-secondary small mb-0">Manage and configure your active services and hosting accounts.</p>
    </div>
    <a href="cart.php" class="btn btn-brand-clean"><i class="ti ti-plus me-2"></i>Order New Service</a>
</div>

<!-- Service Cards Grid -->
<div class="row g-3 mb-5">
    {foreach key=num item=service from=$services}
    <div class="col-md-6 col-xl-4">
        <div class="card service-card h-100">
            <div class="card-body d-flex flex-column">
                <!-- Header: icon + status badge -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="service-card-icon {if $service.status eq 'Active'}active{elseif $service.status eq 'Pending'}pending{elseif $service.status eq 'Suspended'}suspended{else}terminated{/if}">
                        <i class="ti ti-server"></i>
                    </div>
                    {if $service.status eq "Active"}
                        <span class="badge-clean badge-clean-success">Active</span>
                    {elseif $service.status eq "Pending"}
                        <span class="badge-clean badge-clean-warning">Pending</span>
                    {elseif $service.status eq "Suspended"}
                        <span class="badge-clean badge-clean-danger">Suspended</span>
                    {elseif $service.status eq "Terminated"}
                        <span class="badge-clean badge-clean-danger" style="background: rgba(100,100,100,0.08) !important; color: #666666 !important; border: 1px solid rgba(100,100,100,0.15) !important;">Terminated</span>
                    {else}
                        <span class="badge-clean badge-clean-info" style="background: rgba(100,100,100,0.08) !important; color: #666666 !important; border: 1px solid rgba(100,100,100,0.15) !important;">{$service.status}</span>
                    {/if}
                </div>

                <!-- Product Name & Domain -->
                <h4 style="font-size: 1.15rem; font-weight: 700; color: #111111; letter-spacing: -0.02em; margin-bottom: 0.35rem;" class="text-truncate" title="{$service.product}">
                    {$service.product}
                </h4>
                <div class="text-secondary small mb-4 text-truncate d-flex align-items-center gap-1">
                    {if $service.domain}
                        <i class="ti ti-world" style="font-size: 0.95rem; color: #888888;"></i> {$service.domain}
                    {else}
                        <i class="ti ti-minus" style="font-size: 0.95rem; color: #888888;"></i> No domain associated
                    {/if}
                </div>

                <!-- Pricing & Due Date Section -->
                <div class="mt-auto">
                    <div class="d-flex justify-content-between align-items-center mb-3" style="background: #fafafa; border-radius: 10px; padding: 0.75rem 1rem;">
                        <div>
                            <div class="small text-secondary" style="font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Price</div>
                            <div class="fw-bold text-dark mt-1" style="font-size: 0.9rem;">{$service.amount}</div>
                        </div>
                        <div class="text-end">
                            <div class="small text-secondary" style="font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Next Due</div>
                            <div class="fw-bold text-dark mt-1" style="font-size: 0.9rem;">{$service.nextduedate}</div>
                        </div>
                    </div>
                    
                    <div class="small text-secondary mb-4 d-flex align-items-center gap-1 fw-semibold" style="padding-left: 0.25rem;">
                        <i class="ti ti-refresh" style="font-size: 0.95rem;"></i> {$service.billingcycle}
                    </div>
                    
                    <a href="clientarea.php?action=productdetails&id={$service.id}" class="btn-outline-table w-100 justify-content-center py-2" style="font-size: 0.8rem;">
                        <i class="ti ti-settings me-1"></i> Manage Service
                    </a>
                </div>
            </div>
        </div>
    </div>
    {foreachelse}
    <div class="col-12">
        <div class="card dash-card-clean">
            <div class="card-body">
                <div class="empty-state-clean">
                    <i class="ti ti-server d-block"></i>
                    <p>No services found. <a href="cart.php" class="text-danger fw-bold text-decoration-none">Order your first service</a></p>
                </div>
            </div>
        </div>
    </div>
    {/foreach}
</div>

{if $prevpage || $nextpage}
<div class="d-flex justify-content-between mb-5">
    <a href="?action=products&page={$prevpage}" class="btn-outline-clean {if !$prevpage}disabled{/if}"><i class="ti ti-arrow-left me-2"></i>Previous</a>
    <a href="?action=products&page={$nextpage}" class="btn-outline-clean {if !$nextpage}disabled{/if}">Next<i class="ti ti-arrow-right ms-2"></i></a>
</div>
{/if}
