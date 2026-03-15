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
            background: #f5f5f5;
            color: #1a1a1a;
            padding: 2.5rem 1rem;
            min-height: 100vh;
        }
        .inv-shell {
            max-width: 820px;
            margin: 0 auto;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-top: 4px solid #e53935;
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
        .inv-logo i { color: #e53935; font-size: 1.5rem; }
        .inv-number { font-size: 1.5rem; font-weight: 700; color: #1a1a1a; }
        .inv-meta-row { font-size: 0.875rem; color: #555; margin-top: 4px; }
        .inv-date-due { color: #c62828; font-weight: 600; }

        .inv-status-badge {
            display: inline-block;
            padding: 0.3rem 1rem;
            border-radius: 50rem;
            font-size: 0.8125rem;
            font-weight: 600;
            margin-top: 0.5rem;
        }
        .inv-status-unpaid { background: rgba(198,40,40,0.1); color: #c62828; border: 1px solid rgba(198,40,40,0.25); }
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
            border-bottom: 2px solid #e53935;
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
        .inv-total-row td { color: #1a1a1a; font-weight: 700; font-size: 1.1rem; border-top: 2px solid #e53935; padding-top: 0.75rem; }
        .inv-total-amount { color: #e53935 !important; }

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

        /* Gateway Picker */
        .gw-picker-label {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            color: #999;
            margin-bottom: 0.25rem;
        }
        .gw-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            justify-content: center;
        }
        .gw-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.45rem 1.1rem;
            border-radius: 50rem;
            border: 1.5px solid #ddd;
            background: #fff;
            color: #555;
            font-size: 0.8125rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.18s;
            user-select: none;
            white-space: nowrap;
        }
        .gw-pill:hover {
            border-color: #e53935;
            color: #e53935;
            background: #fff8f8;
        }
        .gw-pill.active {
            border-color: #e53935;
            background: #e53935;
            color: #fff;
            box-shadow: 0 3px 10px rgba(229,57,53,0.28);
        }
        .gw-pill .gw-dot {
            width: 7px; height: 7px;
            border-radius: 50%;
            background: currentColor;
            opacity: 0.55;
        }
        .gw-pill.active .gw-dot { opacity: 1; }

        /* Gateway panels */
        .gw-panels { width: 100%; }
        .gw-panel {
            display: none;
            flex-direction: column;
            align-items: center;
            gap: 0.6rem;
            animation: gwFadeIn 0.22s ease;
        }
        .gw-panel.active { display: flex; }
        @keyframes gwFadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Override default WHMCS pay button inside panel */
        .gw-panel input[type=submit],
        .gw-panel button[type=submit],
        .gw-panel .btn-primary,
        .gw-panel a[href*="viewinvoice"] {
            background: #e53935 !important;
            border-color: #e53935 !important;
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
        .gw-panel input[type=submit]:hover,
        .gw-panel button[type=submit]:hover,
        .gw-panel .btn-primary:hover { background: #c62828 !important; box-shadow: 0 6px 20px rgba(229,57,53,0.4) !important; transform: translateY(-1px); }

        .gw-divider {
            width: 100%; height: 1px;
            background: #eee; margin: 0.25rem 0;
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
        .btn-print:hover { background: #fff3f3; border-color: #e53935; color: #e53935; }
        .inv-back {
            font-size: 0.8125rem;
            color: #888;
            text-decoration: none;
            transition: color 0.15s;
        }
        .inv-back:hover { color: #e53935; }

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

            {* ── Gateway Selector ── *}
            {if $gateways}

                {* Count gateways to decide whether to show picker *}
                {assign var="gwCount" value=$gateways|@count}

                {if $gwCount gt 1}
                <div class="gw-picker-label">Choose Payment Method</div>
                <div class="gw-pills" id="gwPills">
                    {foreach from=$gateways item=gw name=gwloop}
                    <button class="gw-pill{if $smarty.foreach.gwloop.first} active{/if}"
                            type="button"
                            onclick="selectGateway('{$gw.sysname}', this)">
                        <span class="gw-dot"></span>
                        {$gw.displayname}
                    </button>
                    {/foreach}
                </div>
                <div class="gw-divider"></div>
                {/if}

                {* ── Payment Panels (one per gateway) ── *}
                <div class="gw-panels" id="gwPanels">
                    {foreach from=$gateways item=gw name=gwloop}
                    <div class="gw-panel{if $smarty.foreach.gwloop.first} active{/if}"
                         id="gwPanel-{$gw.sysname}">
                        {$gw.form}
                    </div>
                    {/foreach}
                </div>

            {else}
                {* Fallback: no gateways array – use legacy paymentbutton *}
                <div class="w-100 text-center">{$paymentbutton}</div>
            {/if}

        {/if}

        <div class="gw-divider"></div>
        <a href="javascript:window.print()" class="btn-print">
            <i class="fas fa-print me-2"></i>
            {if $status eq "Paid"}Print Receipt{else}Print Invoice{/if}
        </a>
        <a href="clientarea.php?action=invoices" class="inv-back">
            <i class="fas fa-arrow-left me-1"></i>Back to Invoices
        </a>
    </div>

    {if $status eq "Unpaid" || $status eq "unpaid"}
    <script>
{literal}
    (function () {
        'use strict';

        // Activate a gateway panel and highlight its pill.
        // sysname: gateway sysname used as panel id suffix
        // pill: the clicked pill element (may be null on init)
        function selectGateway(sysname, pill) {
            // Deactivate all panels
            document.querySelectorAll('.gw-panel').forEach(function (p) {
                p.classList.remove('active');
            });
            // Deactivate all pills
            document.querySelectorAll('.gw-pill').forEach(function (p) {
                p.classList.remove('active');
            });

            // Activate the selected panel
            var panel = document.getElementById('gwPanel-' + sysname);
            if (panel) { panel.classList.add('active'); }

            // Activate the pill
            if (pill) { pill.classList.add('active'); }

            // Persist choice in sessionStorage so a refresh remembers it
            try { sessionStorage.setItem('snbd_gw_choice', sysname); } catch (e) {}
        }

        // Expose so inline onclick can reach it
        window.selectGateway = selectGateway;

        // On page load, restore last choice if available
        document.addEventListener('DOMContentLoaded', function () {
            var saved;
            try { saved = sessionStorage.getItem('snbd_gw_choice'); } catch (e) {}
            if (saved) {
                var panel = document.getElementById('gwPanel-' + saved);
                if (panel) {
                    var pill = document.querySelector('.gw-pill[onclick*="' + saved + '"]');
                    selectGateway(saved, pill);
                }
            }
        });
    })();
{/literal}
    </script>
    {/if}

</div>

</body>
</html>
