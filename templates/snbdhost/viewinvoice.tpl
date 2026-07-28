{if $customadminpath}
    {* This allows admin view of invoice to still render correctly if needed, though usually admin has its own *}
{/if}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Tabler Icons CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800&display=swap" rel="stylesheet">
    
    <!-- Custom styling for standalone invoice -->
    <style>
    body { background-color: #f8fafc; font-family: 'Inter', sans-serif; padding: 2rem 1rem; color: #333; }
    .invoice-container { max-width: 900px; margin: 0 auto; }
    </style>
</head>
<body>
<div class="invoice-container">
<style>
/* ── Invoice Page Styles ── */
.inv-page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 1rem;
    margin-bottom: 1.75rem;
}
.inv-page-header h1 {
    font-size: 2rem;
    font-weight: 800;
    margin-bottom: 0.2rem;
    font-family: 'Plus Jakarta Sans', 'Inter', sans-serif;
    color: #111;
}
.inv-page-header .inv-subtitle {
    color: #666;
    font-size: 0.875rem;
}
.inv-status-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.3rem 1rem;
    border-radius: 50rem;
    font-size: 0.8125rem;
    font-weight: 600;
}
.inv-status-unpaid { background: rgba(198,40,40,0.1); color: #B21C1C; border: 1px solid rgba(198,40,40,0.25); }
.inv-status-paid   { background: rgba(46,125,50,0.1);  color: #2e7d32; border: 1px solid rgba(46,125,50,0.25); }
.inv-status-cancelled { background: rgba(100,100,100,0.08); color: #555; border: 1px solid #ddd; }
.inv-status-other  { background: rgba(100,100,100,0.08); color: #555; border: 1px solid #ddd; }

/* Invoice Card */
.inv-card {
    background: #fff;
    border: 1px solid #eeeeee;
    border-top: 4px solid #BA1114;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 4px 25px rgba(0,0,0,0.03);
    margin-bottom: 1.5rem;
}

/* Invoice Header inside card */
.inv-card-header {
    padding: 1.75rem 2rem;
    border-bottom: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 1.25rem;
    background: #fff;
}
.inv-brand {
    display: flex;
    align-items: center;
    gap: 0.625rem;
    font-size: 1.3rem;
    font-weight: 800;
    color: #111;
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.inv-brand i { color: #BA1114; font-size: 1.5rem; }
.inv-number-block { text-align: right; }
.inv-number-block .inv-num {
    font-size: 1.4rem;
    font-weight: 800;
    color: #111;
    font-family: 'Plus Jakarta Sans', sans-serif;
    display: block;
}
.inv-meta { font-size: 0.8125rem; color: #666; margin-top: 0.2rem; }
.inv-meta-due { color: #B21C1C; font-weight: 600; }

/* Payment method selector in header */
.inv-pm-row {
    margin-top: 0.65rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    flex-wrap: wrap;
}
.inv-pm-label { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: #757575; }
.inv-pm-row select,
.inv-pm-row .form-select {
    padding: 0.4rem 0.85rem;
    border-radius: 8px;
    border: 1.5px solid #e0e0e0;
    background: #fff;
    color: #333;
    font-size: 0.8125rem;
    font-weight: 500;
    font-family: 'Inter', sans-serif;
    transition: border-color 0.18s;
}
.inv-pm-row select:focus,
.inv-pm-row .form-select:focus {
    outline: none;
    border-color: #BA1114;
    box-shadow: 0 0 0 3px rgba(229,57,53,0.1);
}

/* Address section */
.inv-addresses {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
    padding: 1.5rem 2rem;
    background: #fafafa;
    border-bottom: 1px solid #f0f0f0;
}
@media (max-width: 540px) { .inv-addresses { grid-template-columns: 1fr; } }
.inv-addr-label {
    font-size: 0.7rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: #757575;
    margin-bottom: 0.45rem;
}
.inv-addr-name { font-weight: 700; font-size: 0.9375rem; color: #111; margin-bottom: 0.2rem; }
.inv-addr-detail { font-size: 0.8125rem; color: #555; line-height: 1.75; }

/* Line items table */
.inv-items-section { padding: 1.5rem 2rem; }
.inv-items-section h3 {
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    color: #757575;
    margin-bottom: 0.75rem;
}
.inv-table {
    width: 100%;
    border-collapse: collapse;
}
.inv-table thead th {
    font-size: 0.72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #757575;
    padding: 0.5rem 0.75rem;
    border-bottom: 2px solid #BA1114;
}
.inv-table thead th:first-child { padding-left: 0; }
.inv-table thead th:last-child  { text-align: right; padding-right: 0; }
.inv-table tbody td {
    padding: 0.875rem 0.75rem;
    border-bottom: 1px solid #f5f5f5;
    font-size: 0.875rem;
    color: #333;
    vertical-align: top;
}
.inv-table tbody td:first-child { padding-left: 0; }
.inv-table tbody td:last-child  { text-align: right; font-weight: 700; color: #111; padding-right: 0; }
.inv-table tbody tr:last-child td { border-bottom: none; }

/* Totals */
.inv-totals-section {
    padding: 0 2rem 1.5rem;
    display: flex;
    justify-content: flex-end;
}
.inv-totals-table { width: 100%; max-width: 280px; border-collapse: collapse; }
.inv-totals-table td {
    padding: 0.45rem 0;
    font-size: 0.875rem;
    color: #666;
    border: none;
}
.inv-totals-table td:last-child { text-align: right; font-weight: 600; color: #333; }
.inv-total-row td {
    font-weight: 800;
    font-size: 1.1rem;
    color: #111;
    border-top: 2px solid #BA1114;
    padding-top: 0.75rem;
}
.inv-total-row td:last-child { color: #BA1114; }

/* Actions/Payment section */
.inv-actions-section {
    padding: 1.5rem 2rem;
    border-top: 1px solid #f0f0f0;
    background: #fafafa;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
    text-align: center;
}
.inv-pay-wrap { width: 100%; text-align: center; }

/* Pay button override */
.inv-actions-section input[type=submit],
.inv-actions-section button[type=submit],
.inv-actions-section .btn-primary,
.inv-actions-section .btn-success,
.inv-actions-section .btn-danger,
.inv-actions-section a.btn {
    background: #BA1114 !important;
    border-color: #BA1114 !important;
    color: #fff !important;
    border-radius: 50rem !important;
    padding: 0.7rem 2.5rem !important;
    font-weight: 700 !important;
    font-size: 0.9375rem !important;
    cursor: pointer !important;
    transition: all 0.2s !important;
    box-shadow: 0 4px 14px rgba(229,57,53,0.25) !important;
    text-decoration: none !important;
    display: inline-block !important;
    border: none !important;
    font-family: 'Plus Jakarta Sans', 'Inter', sans-serif !important;
}
.inv-actions-section input[type=submit]:hover,
.inv-actions-section button[type=submit]:hover,
.inv-actions-section .btn-primary:hover,
.inv-actions-section .btn-success:hover,
.inv-actions-section a.btn:hover {
    background: #9e0e10 !important;
    box-shadow: 0 6px 20px rgba(229,57,53,0.35) !important;
    transform: translateY(-1px) !important;
}
.inv-actions-divider {
    width: 100%;
    height: 1px;
    background: #eee;
}
.inv-btn-print {
    background: transparent;
    color: #666;
    border: 1px solid #e0e0e0;
    border-radius: 50rem;
    padding: 0.5rem 1.75rem;
    font-weight: 600;
    font-size: 0.875rem;
    text-decoration: none;
    transition: all 0.15s;
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    font-family: 'Inter', sans-serif;
}
.inv-btn-print:hover { border-color: #BA1114; color: #BA1114; background: rgba(186,17,20,0.04); }
.inv-btn-back {
    font-size: 0.8125rem;
    color: #757575;
    text-decoration: none;
    transition: color 0.15s;
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
}
.inv-btn-back:hover { color: #BA1114; }

/* Paid stamp overlay */
.inv-paid-stamp {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    background: rgba(46,125,50,0.06);
    border: 2px solid rgba(46,125,50,0.25);
    border-radius: 12px;
    padding: 0.75rem 1.5rem;
    color: #2e7d32;
    font-weight: 700;
    font-size: 1rem;
    margin-bottom: 0.5rem;
}
.inv-paid-stamp i { font-size: 1.25rem; }

@media print {
    .inv-actions-section { display: none; }
    .inv-card { box-shadow: none; border: 1px solid #ddd; }
}
</style>

<!-- ── Invoice Page Header ── -->
<div class="inv-page-header">
    <div>
        <h1 class="dash-headline" style="font-size: 2rem; margin-bottom: 0.25rem;">
            Invoice <span class="dash-headline-accent">#{$invoiceid}</span>
        </h1>
        <p class="inv-subtitle">Review and manage your invoice details below.</p>
    </div>
    <div class="d-flex align-items-center gap-2 flex-wrap">
        {if $status eq "Unpaid"}
            <span class="inv-status-badge inv-status-unpaid"><i class="ti ti-alert-circle"></i> Unpaid</span>
        {elseif $status eq "Paid"}
            <span class="inv-status-badge inv-status-paid"><i class="ti ti-circle-check"></i> Paid</span>
        {elseif $status eq "Cancelled"}
            <span class="inv-status-badge inv-status-cancelled"><i class="ti ti-ban"></i> Cancelled</span>
        {else}
            <span class="inv-status-badge inv-status-other">{$status}</span>
        {/if}
        <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="btn btn-outline-custom py-2 px-3">
            <i class="ti ti-arrow-left me-2"></i>Back to Invoices
        </a>
    </div>
</div>

<!-- ── Invoice Card ── -->
<div class="inv-card">

    <!-- Card Header: Brand + Invoice Number + Dates -->
    <div class="inv-card-header">
        <div class="inv-brand">
            <i class="ti ti-server"></i>
            {$companyname}
        </div>
        <div class="inv-number-block">
            <span class="inv-num">{$pagetitle}</span>
            <div class="inv-meta"><i class="ti ti-calendar me-1"></i>{$LANG.invoicesdatecreated}: <strong>{$date}</strong></div>
            <div class="inv-meta inv-meta-due"><i class="ti ti-clock me-1"></i>{$LANG.invoicesdatedue}: <strong>{$datedue}</strong></div>

            {if $allowchangegateway}
                <div class="inv-pm-row mt-2">
                    <span class="inv-pm-label">Payment Method:</span>
                    <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" id="frmPaymentMethod" style="display:inline;">
                        {if $gatewaydropdown}
                            {$gatewaydropdown|replace:'<select ':'<select class="form-select form-select-sm" style="display:inline-block; width:auto;" '}
                        {/if}
                    </form>
                </div>
            {elseif $paymentmethod}
                <div class="inv-pm-row mt-2">
                    <span class="inv-pm-label">Payment Method:</span>
                    <span style="font-size:0.8125rem; font-weight:600; color:#333;">{$paymentmethod}</span>
                </div>
            {/if}
        </div>
    </div>

    <!-- Addresses -->
    <div class="inv-addresses">
        <div>
            <div class="inv-addr-label">{$LANG.invoicespayto}</div>
            <div class="inv-addr-name">{$companyname}</div>
            <div class="inv-addr-detail">{$payto}</div>
        </div>
        <div style="text-align: right;">
            <div class="inv-addr-label">{$LANG.invoicesinvoicedto}</div>
            <div class="inv-addr-name">{$clientsdetails.firstname} {$clientsdetails.lastname}</div>
            <div class="inv-addr-detail">
                {if $clientsdetails.companyname}{$clientsdetails.companyname}<br>{/if}
                {$clientsdetails.address1}<br>
                {if $clientsdetails.address2}{$clientsdetails.address2}<br>{/if}
                {$clientsdetails.city}{if $clientsdetails.state}, {$clientsdetails.state}{/if} {$clientsdetails.postcode}<br>
                {$clientsdetails.country}
            </div>
        </div>
    </div>

    <!-- Line Items -->
    <div class="inv-items-section">
        <h3><i class="ti ti-list me-1"></i> Invoice Items</h3>
        <table class="inv-table">
            <thead>
                <tr>
                    <th>{$LANG.invoicesdescription}</th>
                    <th class="text-end">{$LANG.invoicesamount}</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$invoiceitems item=item}
                <tr>
                    <td>{$item.description}</td>
                    <td class="text-end">{$item.amount}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>

    <!-- Totals -->
    <div class="inv-totals-section">
        <table class="inv-totals-table">
            <tbody>
                <tr>
                    <td>{$LANG.invoicessubtotal}</td>
                    <td>{$subtotal}</td>
                </tr>
                {if $taxname}
                <tr>
                    <td>{$taxname} {$taxrate}%</td>
                    <td>{$tax}</td>
                </tr>
                {/if}
                {if $taxname2}
                <tr>
                    <td>{$taxname2} {$taxrate2}%</td>
                    <td>{$tax2}</td>
                </tr>
                {/if}
                {if $credit}
                <tr>
                    <td>Credit Applied</td>
                    <td>-{$credit}</td>
                </tr>
                {/if}
                <tr class="inv-total-row">
                    <td>{$LANG.invoicestotal}</td>
                    <td>{$total}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Actions -->
    <div class="inv-actions-section">
        {if $status eq "Paid"}
            <div class="inv-paid-stamp">
                <i class="ti ti-circle-check"></i>
                This invoice has been paid in full. Thank you!
            </div>
        {elseif $status eq "Unpaid" || $status eq "Overdue"}
            <div class="inv-pay-wrap">
                {$paymentbutton}
            </div>
        {/if}

        <div class="inv-actions-divider"></div>

        <div class="d-flex align-items-center gap-3 flex-wrap justify-content-center">
            <a href="javascript:window.print()" class="inv-btn-print">
                <i class="ti ti-printer"></i>
                {if $status eq "Paid"}Print Receipt{else}Print Invoice{/if}
            </a>
            <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="inv-btn-back">
                <i class="ti ti-arrow-left"></i> Back to Invoices
            </a>
        </div>
    </div>

</div>
<!-- JS Dependencies -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
