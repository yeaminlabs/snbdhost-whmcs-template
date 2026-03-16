<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{$companyname} - {$pagetitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; }
        body {
            background: #F7F7F4;
            color: #1a1a1a;
            padding: 2.5rem 1rem;
            min-height: 100vh;
        }
        .inv-shell {
            max-width: 820px;
            margin: 0 auto;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-top: 4px solid #BA1114;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
        }
        .inv-header {
            padding: 2rem 2.5rem;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .inv-logo {
            display: flex; align-items: center; gap: 0.625rem;
            font-size: 1.35rem; font-weight: 700; color: #1a1a1a;
        }
        .inv-logo i { color: #BA1114; font-size: 1.5rem; }
        .inv-number { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; }
        .inv-meta-row { font-size: 0.875rem; color: #555; margin-top: 4px; }
        .inv-date-due { color: #B21C1C; font-weight: 600; }

        .inv-status-badge {
            display: inline-block;
            padding: 0.3rem 1rem;
            border-radius: 50rem;
            font-size: 0.8125rem;
            font-weight: 600;
            margin-top: 0.5rem;
        }
        .inv-status-unpaid { background: rgba(198,40,40,0.1); color: #B21C1C; border: 1px solid rgba(198,40,40,0.25); }
        .inv-status-paid   { background: rgba(46,125,50,0.1);  color: #2e7d32; border: 1px solid rgba(46,125,50,0.25); }
        .inv-status-other  { background: rgba(100,100,100,0.08); color: #555; border: 1px solid #ddd; }

        .inv-addresses {
            padding: 1.75rem 2.5rem;
            border-bottom: 1px solid #eee;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            background: #fafafa;
        }
        @media(max-width:540px){ .inv-addresses { grid-template-columns: 1fr; } }
        .inv-address-label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: #999; margin-bottom: 0.5rem; }
        .inv-address-name { font-weight: 600; font-size: 0.9375rem; color: #1a1a1a; margin-bottom: 0.25rem; }
        .inv-address-detail { font-size: 0.8125rem; color: #555; line-height: 1.7; }

        .inv-items {
            padding: 1.5rem 2.5rem;
        }
        .inv-table {
            width: 100%;
            border-collapse: collapse;
        }
        .inv-table thead th {
            font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
            color: #888;
            padding: 0.5rem 0;
            border-bottom: 2px solid #BA1114;
        }
        .inv-table tbody td {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.875rem;
            color: #333;
        }
        .inv-table tbody tr:last-child td { border-bottom: none; }

        .inv-totals-wrap {
            padding: 1rem 2.5rem 1.5rem;
            display: flex;
            justify-content: flex-end;
        }
        .inv-totals-table {
            width: 100%;
            max-width: 300px;
            border-collapse: collapse;
        }
        .inv-totals-table td {
            padding: 0.5rem 0;
            font-size: 0.875rem;
            color: #555;
            border: none;
        }
        .inv-totals-table td:last-child { text-align: right; }
        .inv-total-row td { color: #1a1a1a; font-weight: 700; font-size: 1.1rem; border-top: 2px solid #BA1114; padding-top: 0.75rem; }
        .inv-total-amount { color: #BA1114 !important; }

        /* ── Payment Section ── */
        .inv-actions {
            padding: 1.75rem 2.5rem;
            border-top: 1px solid #eee;
            background: #fafafa;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }
    
        /* Payment Method Row */
        .inv-payment-method-row {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.75rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
            margin-bottom: 0.5rem;
        }
        .inv-pm-label {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: #999;
        }
        .inv-pm-select {
            min-width: 220px;
            padding: 0.5rem 2rem 0.5rem 0.85rem;
            border-radius: 8px;
            border: 1.5px solid #ddd;
            background: #fff;
            color: #333;
            font-size: 0.875rem;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: border-color 0.18s, box-shadow 0.18s;
            appearance: auto;
            -webkit-appearance: auto;
        }
        .inv-pm-select:focus {
            outline: none;
            border-color: #BA1114;
            box-shadow: 0 0 0 3px rgba(229,57,53,0.12);
        }
        .inv-pm-select:hover {
            border-color: #BA1114;
        }

        .gw-divider {
            width: 100%; height: 1px;
            background: #eee; margin: 0.25rem 0;
        }

        /* Pay button */
        .inv-actions input[type=submit],
        .inv-actions button[type=submit],
        .inv-actions .btn-primary,
        .inv-actions .btn-success,
        .inv-actions a.btn {
            background: #BA1114 !important;
            border-color: #BA1114 !important;
            color: #fff !important;
            border-radius: 50rem !important;
            padding: 0.7rem 2.5rem !important;
            font-weight: 600 !important;
            font-size: 0.95rem !important;
            cursor: pointer !important;
            transition: all 0.2s !important;
            box-shadow: 0 4px 14px rgba(229,57,53,0.3) !important;
            text-decoration: none !important;
            display: inline-block !important;
            border: none !important;
        }
        .inv-actions input[type=submit]:hover,
        .inv-actions button[type=submit]:hover,
        .inv-actions .btn-primary:hover,
        .inv-actions .btn-success:hover,
        .inv-actions a.btn:hover {
            background: #B21C1C !important;
            box-shadow: 0 6px 20px rgba(229,57,53,0.4) !important;
            transform: translateY(-1px);
        }

        /* Standard pay/print/back */
        .btn-print {
            background: transparent;
            color: #555;
            border: 1px solid #ddd;
            border-radius: 50rem;
            padding: 0.5rem 2rem;
            font-weight: 500;
            font-size: 0.875rem;
            text-decoration: none;
            transition: all 0.15s;
        }
        .btn-print:hover { background: #fff3f3; border-color: #BA1114; color: #BA1114; }
        .inv-back {
            font-size: 0.8125rem;
            color: #888;
            text-decoration: none;
            transition: color 0.15s;
        }
        .inv-back:hover { color: #BA1114; }

        /* Spinner overlay for payment method change */
        .inv-pm-loading {
            display: none;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8125rem;
            color: #999;
        }
        .inv-pm-loading.active { display: flex; }
        .inv-pm-spinner {
            width: 14px; height: 14px;
            border: 2px solid #ddd;
            border-top-color: #BA1114;
            border-radius: 50%;
            animation: pmSpin 0.6s linear infinite;
        }
        @keyframes pmSpin { to { transform: rotate(360deg); } }

        @media print {
            body { background: #fff; padding: 0; }
            .inv-shell { box-shadow: none; border: none; }
            .inv-actions { display: none; }
        }
    </style>
</head>
<body>

<div class="inv-shell">

    <!-- Invoice Header -->
    <div class="inv-header">
        <div class="inv-logo">
            <i class="fas fa-server"></i>
            {$companyname}
        </div>
        <div class="text-end">
            <div class="inv-number">{$pagetitle}</div>
            <div class="inv-meta-row">{$LANG.invoicesdatecreated}: {$date}</div>
            <div class="inv-meta-row inv-date-due">{$LANG.invoicesdatedue}: {$datedue}</div>
            
            {if $allowchangegateway}
             <div class="inv-meta-row" style="margin-top: 8px;">
                 <strong>Payment Method:</strong>
                 <form method="post" action="{$smarty.server.PHP_SELF}?id={$invoiceid}" id="frmPaymentMethod" style="display:inline-block; margin-left: 5px;">
                     {$gatewaydropdown|replace:'<select ':'<select class="form-select form-select-sm" style="display:inline-block; width:auto;" '}
                 </form>
             </div>
            {elseif $paymentmethod}
             <div class="inv-meta-row" style="margin-top: 8px;">
                 <strong>Payment Method:</strong> {$paymentmethod}
             </div>
            {/if}

            <div>
                {if $status eq "Unpaid"}
                    <span class="inv-status-badge inv-status-unpaid"><i class="fas fa-exclamation-circle me-1"></i>Unpaid</span>
                {elseif $status eq "Paid"}
                    <span class="inv-status-badge inv-status-paid"><i class="fas fa-check-circle me-1"></i>Paid</span>
                {else}
                    <span class="inv-status-badge inv-status-other">{$status}</span>
                {/if}
            </div>
        </div>
    </div>

    <!-- Addresses -->
    <div class="inv-addresses">
        <div>
            <div class="inv-address-label">{$LANG.invoicespayto}</div>
            <div class="inv-address-name">{$companyname}</div>
            <div class="inv-address-detail">{$payto}</div>
        </div>
        <div class="text-sm-end">
            <div class="inv-address-label">{$LANG.invoicesinvoicedto}</div>
            <div class="inv-address-name">{$clientsdetails.firstname} {$clientsdetails.lastname}</div>
            <div class="inv-address-detail">
                {if $clientsdetails.companyname}{$clientsdetails.companyname}<br>{/if}
                {$clientsdetails.address1}<br>
                {$clientsdetails.city}{if $clientsdetails.state}, {$clientsdetails.state}{/if} {$clientsdetails.postcode}<br>
                {$clientsdetails.country}
            </div>
        </div>
    </div>

    <!-- Line Items -->
    <div class="inv-items">
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
                    <td class="text-end fw-semibold">{$item.amount}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>

    <!-- Totals -->
    <div class="inv-totals-wrap">
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
                <tr class="inv-total-row">
                    <td>{$LANG.invoicestotal}</td>
                    <td class="inv-total-amount">{$total}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Actions -->
    <div class="inv-actions">

        {if $status eq "Unpaid" || $status eq "unpaid"}

            {* ── Pay Button ── *}
            <div class="w-100 text-center">{$paymentbutton}</div>

        {/if}

        <div class="gw-divider"></div>
        <a href="javascript:window.print()" class="btn-print">
            <i class="fas fa-print me-2"></i>
            {if $status eq "Paid"}Print Receipt{else}Print Invoice{/if}
        </a>
        <a href="{$WEB_ROOT}/clientarea.php?action=invoices" class="inv-back">
            <i class="fas fa-arrow-left me-1"></i>Back to Invoices
        </a>
    </div>

    <!-- WHMCS natively handles the gateway dropdown submission -->

</div>

</body>
</html>
