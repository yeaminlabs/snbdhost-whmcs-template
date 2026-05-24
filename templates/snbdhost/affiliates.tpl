<!-- ====== AFFILIATES DASHBOARD ====== -->
{if $inactive}
    {include file="$template/includes/alert.tpl" type="danger" msg="{lang key='affiliatesdisabled'}" textcenter=true}
{else}
    <!-- Load Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    {include file="$template/includes/flashmessage.tpl"}
    {if $withdrawrequestsent}
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>{lang key='affiliateswithdrawalrequestsuccessful'}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    {/if}

    <div class="affiliate-dashboard">
        <!-- Dashboard Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h3 mb-1 text-dark">Affiliate Program</h2>
                <p class="text-muted mb-0">Track your performance and earnings.</p>
            </div>
            {if !$withdrawrequestsent && $withdrawlevel}
                <form method="POST" action="{$smarty.server.PHP_SELF}">
                    <input type="hidden" name="action" value="withdrawrequest" />
                    <button type="submit" class="btn btn-primary shadow-sm hover-elevate">
                        <i class="fas fa-money-bill-wave me-2"></i> {lang key='affiliatesrequestwithdrawal'}
                    </button>
                </form>
            {/if}
        </div>

        {if !$withdrawrequestsent && !$withdrawlevel}
             <div class="alert alert-info border-0 rounded-4 shadow-sm mb-4">
                 <i class="fas fa-info-circle me-2"></i> {lang key="affiliateWithdrawalSummary" amountForWithdrawal=$affiliatePayoutMinimum}
             </div>
        {/if}

        <!-- KPI Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="stat-card p-4 rounded-4 shadow-sm bg-white hover-elevate border-start border-warning border-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="icon-shape bg-warning bg-opacity-10 text-warning rounded-circle p-3 me-3">
                            <i class="fas fa-mouse-pointer fa-fw fa-lg"></i>
                        </div>
                        <h6 class="text-muted mb-0 text-uppercase fw-bold small">{lang key='affiliatesclicks'}</h6>
                    </div>
                    <h3 class="mb-0 fw-bold text-dark">{$visitors}</h3>
                    <div class="mt-2 small text-warning">Total visitors referred</div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card p-4 rounded-4 shadow-sm bg-white hover-elevate border-start border-info border-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="icon-shape bg-info bg-opacity-10 text-info rounded-circle p-3 me-3">
                            <i class="fas fa-user-plus fa-fw fa-lg"></i>
                        </div>
                        <h6 class="text-muted mb-0 text-uppercase fw-bold small">{lang key='affiliatessignups'}</h6>
                    </div>
                    <h3 class="mb-0 fw-bold text-dark">{$signups}</h3>
                    <div class="mt-2 small text-info">Accounts created</div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card p-4 rounded-4 shadow-sm bg-white hover-elevate border-start border-success border-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="icon-shape bg-success bg-opacity-10 text-success rounded-circle p-3 me-3">
                            <i class="fas fa-chart-line fa-fw fa-lg"></i>
                        </div>
                        <h6 class="text-muted mb-0 text-uppercase fw-bold small">{lang key='affiliatesconversionrate'}</h6>
                    </div>
                    <h3 class="mb-0 fw-bold text-dark">{$conversionrate}%</h3>
                    <div class="mt-2 small text-success">Click-to-signup ratio</div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <!-- Earnings Chart -->
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="card-title fw-bold mb-0">Earnings Summary</h5>
                    </div>
                    <div class="card-body" style="position: relative; height: 250px;">
                        <canvas id="earningsChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <!-- Conversion Doughnut -->
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-header bg-white border-0 pt-4 pb-0 text-center">
                        <h5 class="card-title fw-bold mb-0">Conversion Overview</h5>
                    </div>
                    <div class="card-body d-flex justify-content-center align-items-center" style="position: relative; height: 200px;">
                        <canvas id="conversionChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Hidden inputs to hold values for JS chart parsing -->
        <input type="hidden" id="rawPending" value="{$pendingcommissions}">
        <input type="hidden" id="rawAvailable" value="{$balance}">
        <input type="hidden" id="rawWithdrawn" value="{$withdrawn}">
        <input type="hidden" id="valClicks" value="{$visitors}">
        <input type="hidden" id="valSignups" value="{$signups}">


        <!-- Referral Link & Commission Text Summary -->
        <div class="row g-4 mb-4">
            <div class="col-md-7">
                <div class="card border-0 shadow-sm rounded-4 h-100">
                    <div class="card-body p-4">
                        <h5 class="card-title fw-bold mb-3"><i class="fas fa-link text-danger me-2"></i>{lang key='affiliatesreferallink'}</h5>
                        <p class="text-muted small mb-3">Share this link directly with your audience to track referrals automatically.</p>
                        
                        <div class="input-group input-group-lg shadow-sm">
                            <input type="text" class="form-control bg-light border-0 fs-6" id="referralLinkInput" readonly="readonly" value="{$referrallink}">
                            <button class="btn btn-danger px-4" type="button" onclick="copyReferralLink()" aria-label="Copy Link" style="background-color: #BA1114; border-color: #BA1114;">
                                <i class="fas fa-copy me-2"></i>Copy
                            </button>
                        </div>
                        
                        {if $affiliatelinkscode}
                            <div class="mt-4 pt-4 border-top">
                                <h6 class="fw-bold mb-2 small text-uppercase text-muted">{lang key='affiliateslinktous'}</h6>
                                <div class="bg-light p-3 rounded-3 text-break small font-monospace">
                                    {$affiliatelinkscode}
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
            
            <div class="col-md-5">
                <div class="card border-0 shadow-sm rounded-4 text-white h-100 overflow-hidden position-relative" style="background-color: #BA1114;">
                    <!-- Deco bg -->
                    <div class="position-absolute top-0 end-0 opacity-10 p-4">
                         <i class="fas fa-wallet fa-8x"></i>
                    </div>

                    <div class="card-body p-4 position-relative z-1 d-flex flex-column justify-content-center">
                        <h5 class="fw-bold mb-4">Financial Overview</h5>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3 border-bottom border-white border-opacity-25 pb-3">
                            <span class="opacity-75">{lang key='affiliatescommissionspending'}</span>
                            <strong class="fs-5">{$pendingcommissions}</strong>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3 border-bottom border-white border-opacity-25 pb-3">
                            <span class="opacity-75">{lang key='affiliatescommissionsavailable'}</span>
                            <strong class="fs-4 text-warning">{$balance}</strong>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="opacity-75">{lang key='affiliateswithdrawn'}</span>
                            <strong class="fs-5">{$withdrawn}</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Referrals Table -->
        <h3 class="fw-bold h4 mb-3 mt-5">{lang key='affiliatesreferals'}</h3>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-5">
            <div class="card-body p-0">
                
                <script>
                    jQuery(document).ready(function() {
                        var table = jQuery('#tableAffiliatesList').show().DataTable({
                            // Added custom wrapper classes to mirror SaaS look
                            dom: '<"row mt-3 px-3 d-flex align-items-center"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6 text-end"f>>' +
                                 '<"row px-0 mx-0 border-top mt-3"<"col-sm-12 px-0"tr>>' +
                                 '<"row mb-3 px-3 mt-3 d-flex align-items-center"<"col-sm-12 col-md-5 text-muted small"i><"col-sm-12 col-md-7 d-flex justify-content-end"p>>',
                            language: {
                                search: "_INPUT_",
                                searchPlaceholder: "Search referrals...",
                                lengthMenu: "Show _MENU_ entries"
                            }
                        });

                        {if $orderby == 'regdate'}
                            table.order(0, '{$sort}');
                        {elseif $orderby == 'product'}
                            table.order(1, '{$sort}');
                        {elseif $orderby == 'amount'}
                            table.order(2, '{$sort}');
                        {elseif $orderby == 'status'}
                            table.order(4, '{$sort}');
                        {/if}
                        
                        table.draw();
                        jQuery('#tableLoading').hide();
                    });
                </script>
                
                <div class="table-responsive">
                    <table id="tableAffiliatesList" class="table table-hover align-middle mb-0 w-hidden" style="width:100%; display: none;">
                        <thead class="table-light text-muted small text-uppercase" style="background-color: var(--bs-gray-100);">
                            <tr>
                                <th class="ps-4 fw-semibold border-bottom-0 py-3">{lang key='affiliatessignupdate'}</th>
                                <th class="fw-semibold border-bottom-0 py-3">{lang key='orderproduct'}</th>
                                <th class="fw-semibold border-bottom-0 py-3">{lang key='affiliatesamount'}</th>
                                <th class="fw-semibold border-bottom-0 py-3">{lang key='affiliatescommission'}</th>
                                <th class="pe-4 fw-semibold border-bottom-0 py-3">{lang key='affiliatesstatus'}</th>
                            </tr>
                        </thead>
                        <tbody class="border-top-0">
                        {foreach $referrals as $referral}
                            <tr>
                                <td class="ps-4 py-3"><span class="d-none">{$referral.datets}</span><i class="far fa-calendar-alt text-muted me-2 small"></i><span class="text-dark">{$referral.date}</span></td>
                                <td class="fw-medium text-dark py-3">{$referral.service}</td>
                                <td data-order="{$referral.amountnum}" class="py-3">{$referral.amountdesc}</td>
                                <td data-order="{$referral.commissionnum}" class="text-success fw-bold py-3">{$referral.commission}</td>
                                <td class="pe-4 py-3">
                                    {if $referral.rawstatus|strtolower == 'pending'}
                                        <span class='badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill border border-warning border-opacity-25'>{$referral.status}</span>
                                    {elseif $referral.rawstatus|strtolower == 'active'}
                                        <span class='badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill border border-success border-opacity-25'>{$referral.status}</span>
                                    {elseif $referral.rawstatus|strtolower == 'cancelled' || $referral.rawstatus|strtolower == 'fraud'}
                                        <span class='badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill border border-danger border-opacity-25'>{$referral.status}</span>
                                    {else}
                                        <span class='badge bg-secondary bg-opacity-10 text-secondary px-3 py-2 rounded-pill'>{$referral.status}</span>
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}
                        {if !$referrals}
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">No referrals found yet. Share your link to get started!</td>
                            </tr>
                        {/if}
                        </tbody>
                    </table>
                </div>
                <!-- Loading State -->
                <div class="text-center py-5" id="tableLoading">
                    <div class="spinner-border text-danger" role="status">
                        <span class="visually-hidden">{lang key='loading'}</span>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Affiliate Dashboard Scripts -->
    <style>
        .hover-elevate { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .hover-elevate:hover { transform: translateY(-3px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.08)!important; }
        .stat-card { border: 1px solid rgba(0,0,0,.05); border-left-width: 4px !important; }
        .icon-shape { width: 48px; height: 48px; display: flex; align-items: center; justify-content: center; }
        /* DataTables overrides to match Bootstrap 5 & SaaS feel */
        div.dataTables_wrapper div.dataTables_filter input { 
            border: 1px solid #dee2e6; 
            border-radius: .375rem; 
            padding: .375rem .75rem; 
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
        }
        div.dataTables_wrapper div.dataTables_filter input:focus {
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(13,110,253,.25);
        }
        div.dataTables_wrapper div.dataTables_length select {
            border: 1px solid #dee2e6;
            border-radius: .375rem;
            padding: .375rem 2.25rem .375rem .75rem;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
        }
        .dataTables_paginate .paginate_button.current {
            background: #0d6efd !important;
            color: white !important;
            border: 1px solid #0d6efd !important;
            border-radius: .375rem !important;
        }
        table.dataTable.no-footer { border-bottom: none; }
        div.dataTables_wrapper .dataTables_paginate .paginate_button { margin-left: 2px; }
    </style>
    
    <script>
        function copyReferralLink() {
            var copyText = document.getElementById("referralLinkInput");
            copyText.select();
            copyText.setSelectionRange(0, 99999); 
            navigator.clipboard.writeText(copyText.value);
            
            // Show toast/alert loosely based on bootstrap
            const btn = event.currentTarget;
            const originalHTML = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check me-2"></i>Copied!';
            
            // Temporary success color
            btn.style.backgroundColor = '#198754';
            btn.style.borderColor = '#198754';
            
            setTimeout(() => {
                btn.innerHTML = originalHTML;
                // Revert to theme red
                btn.style.backgroundColor = '#BA1114';
                btn.style.borderColor = '#BA1114';
            }, 2000);
        }

        // --- Chart JS Init ---
        document.addEventListener('DOMContentLoaded', function() {
            
            // Helper to strip currency string to float (e.g. ৳10.00BDT or $10.00 USD -> 10.00)
            const parseCurrency = (str) => {
                if(!str) return 0;
                // Strip everything except numbers and decimal point
                const num = parseFloat(str.replace(/[^0-9.]/g, ''));
                return isNaN(num) ? 0 : num;
            };

            const pendingVal = parseCurrency(document.getElementById('rawPending').value);
            const availableVal = parseCurrency(document.getElementById('rawAvailable').value);
            const withdrawnVal = parseCurrency(document.getElementById('rawWithdrawn').value);

            const clicksVal = parseInt(document.getElementById('valClicks').value) || 0;
            const signupsVal = parseInt(document.getElementById('valSignups').value) || 0;
            const lostClicks = clicksVal - signupsVal;

            // Chart Defaults for consistent SaaS styling
            Chart.defaults.font.family = "'Inter', 'Roboto', 'Helvetica Neue', 'Helvetica', 'Arial', sans-serif";
            Chart.defaults.color = '#8898aa';
            Chart.defaults.scale.grid.color = 'rgba(0, 0, 0, 0.05)';

            // 1. Bar Chart (Earnings)
            const ctxEarnings = document.getElementById('earningsChart').getContext('2d');
            
            // Create Gradient
            let gradientRed = ctxEarnings.createLinearGradient(0, 0, 0, 400);
            gradientRed.addColorStop(0, 'rgba(186, 17, 20, 0.8)'); // Theme Red #BA1114
            gradientRed.addColorStop(1, 'rgba(186, 17, 20, 0.2)');

            new Chart(ctxEarnings, {
                type: 'bar',
                data: {
                    labels: ['Pending', 'Available', 'Withdrawn'],
                    datasets: [{
                        label: 'Amount',
                        data: [pendingVal, availableVal, withdrawnVal],
                        backgroundColor: [
                            'rgba(255, 193, 7, 0.8)', // Warning
                            gradientRed,               // Primary Red
                            'rgba(25, 135, 84, 0.8)'  // Success
                        ],
                        borderRadius: 6,
                        borderSkipped: false,
                        maxBarThickness: 50
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#fff',
                            titleColor: '#212529',
                            bodyColor: '#212529',
                            borderColor: 'rgba(0,0,0,0.1)',
                            borderWidth: 1,
                            padding: 12,
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    return context.parsed.y.toFixed(2); // Keep generic decimal representation
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { drawBorder: false },
                            ticks: { padding: 10 }
                        },
                        x: {
                            grid: { display: false, drawBorder: false },
                            ticks: { padding: 10 }
                        }
                    }
                }
            });

            // 2. Doughnut Chart (Conversion)
            const ctxConversion = document.getElementById('conversionChart').getContext('2d');
            
            // If completely 0, render a grey placeholder
            const hasData = clicksVal > 0 || signupsVal > 0;
            const donutData = hasData ? [signupsVal, Math.max(0, lostClicks)] : [1];
            const donutColors = hasData ? ['#BA1114', '#e9ecef'] : ['#f8f9fa'];
            const donutLabels = hasData ? ['Signups', 'Lost Clicks'] : ['No Data'];

            new Chart(ctxConversion, {
                type: 'doughnut',
                data: {
                    labels: donutLabels,
                    datasets: [{
                        data: donutData,
                        backgroundColor: donutColors,
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '75%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        },
                        tooltip: {
                            enabled: hasData,
                            backgroundColor: '#fff',
                            titleColor: '#212529',
                            bodyColor: '#212529',
                            borderColor: 'rgba(0,0,0,0.1)',
                            borderWidth: 1
                        }
                    }
                }
            });
        });
    </script>

{/if}
