{include file="orderforms/snbdhost_cart/common.tpl"}

<style>
.order-complete-hero {
    text-align: center;
    padding: 3rem 2rem 2rem;
}
.order-complete-icon {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--brand), var(--brand-hover));
    display: inline-flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 1.5rem;
    box-shadow: 0 8px 32px rgba(var(--brand-rgb), 0.3);
    animation: scaleIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
}
.order-complete-icon i {
    font-size: 2.5rem;
    color: #fff;
}
@keyframes scaleIn {
    from { transform: scale(0); opacity: 0; }
    to   { transform: scale(1); opacity: 1; }
}
.order-complete-hero h2 {
    font-size: 1.75rem;
    font-weight: 800;
    color: var(--text-main);
    margin-bottom: 0.5rem;
}
.order-complete-hero p {
    color: var(--text-sec);
    font-size: 0.9375rem;
    max-width: 520px;
    margin: 0 auto 1.5rem;
}
.order-number-card {
    display: inline-flex;
    align-items: center;
    gap: 0.75rem;
    background: var(--surface);
    border: 1px solid var(--border);
    border-left: 4px solid var(--brand);
    border-radius: var(--radius-sm);
    padding: 1rem 1.75rem;
    margin: 0 auto 2rem;
    font-family: 'Plus Jakarta Sans', sans-serif;
}
.order-number-card .label {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: var(--text-dim);
    font-weight: 600;
}
.order-number-card .number {
    font-size: 1.5rem;
    font-weight: 800;
    color: var(--brand);
}
.order-status-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 1rem;
    max-width: 600px;
    margin: 0 auto 2rem;
}
.order-status-item {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 1rem;
    text-align: center;
}
.order-status-item i {
    font-size: 1.25rem;
    color: var(--brand);
    display: block;
    margin-bottom: 0.5rem;
}
.order-status-item span {
    font-size: 0.8125rem;
    color: var(--text-sec);
    font-weight: 500;
}
.complete-actions {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
    margin-top: 1rem;
}
.btn-complete-primary {
    background: var(--brand);
    color: #fff;
    border: none;
    border-radius: 50rem;
    padding: 0.75rem 2rem;
    font-weight: 700;
    font-size: 0.9375rem;
    font-family: 'Plus Jakarta Sans', sans-serif;
    transition: all 0.2s ease;
    box-shadow: 0 4px 14px rgba(var(--brand-rgb), 0.2);
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
}
.btn-complete-primary:hover {
    background: var(--brand-hover);
    transform: translateY(-2px);
    color: #fff;
}
.btn-complete-ghost {
    background: transparent;
    color: var(--text-sec);
    border: 1px solid var(--border);
    border-radius: 50rem;
    padding: 0.75rem 2rem;
    font-weight: 600;
    font-size: 0.9375rem;
    font-family: 'Plus Jakarta Sans', sans-serif;
    transition: all 0.2s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
}
.btn-complete-ghost:hover {
    border-color: var(--brand);
    color: var(--brand);
}
.complete-alert-box {
    max-width: 560px;
    margin: 0 auto 1.5rem;
    border-radius: var(--radius-sm);
    padding: 1rem 1.25rem;
    font-size: 0.875rem;
    text-align: center;
}
.complete-alert-box.warning {
    background: rgba(210, 153, 34, 0.1);
    border: 1px solid rgba(210, 153, 34, 0.25);
    color: #d29922;
}
.complete-alert-box.danger {
    background: rgba(248, 81, 73, 0.1);
    border: 1px solid rgba(248, 81, 73, 0.2);
    color: #f85149;
}
.complete-alert-box.info {
    background: rgba(var(--brand-rgb), 0.06);
    border: 1px solid rgba(var(--brand-rgb), 0.2);
    color: var(--brand);
}
.order-confirmation-addon-output {
    max-width: 680px;
    margin: 0 auto 1rem;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 1rem;
}
</style>

<div id="order-standard_cart">
    <div class="row">
        <div class="cart-body">

            <div class="order-complete-hero">
                <div class="order-complete-icon">
                    <i class="ti ti-check"></i>
                </div>
                <h2>{$LANG.orderconfirmation}</h2>
                <p>{$LANG.orderreceived}</p>

                <div class="order-number-card">
                    <div>
                        <div class="label">{$LANG.ordernumberis}</div>
                        <div class="number">#{$ordernumber}</div>
                    </div>
                </div>

                <div class="order-status-grid">
                    <div class="order-status-item">
                        <i class="ti ti-shield-check"></i>
                        <span>Order Verified</span>
                    </div>
                    <div class="order-status-item">
                        <i class="ti ti-mail"></i>
                        <span>Confirmation Sent</span>
                    </div>
                    <div class="order-status-item">
                        <i class="ti ti-bolt"></i>
                        <span>Processing Started</span>
                    </div>
                </div>

                <p style="font-size:0.875rem; color: var(--text-dim);">{$LANG.orderfinalinstructions}</p>

                {if $expressCheckoutInfo}
                    <div class="complete-alert-box info">
                        <i class="ti ti-info-circle"></i> {$expressCheckoutInfo}
                    </div>
                {elseif $expressCheckoutError}
                    <div class="complete-alert-box danger">
                        <i class="ti ti-alert-circle"></i> {$expressCheckoutError}
                    </div>
                {elseif $invoiceid && !$ispaid}
                    <div class="complete-alert-box warning">
                        <i class="ti ti-alert-triangle"></i>
                        {$LANG.ordercompletebutnotpaid}
                        <br /><br />
                        <a href="{$WEB_ROOT}/viewinvoice.php?id={$invoiceid}" target="_blank" style="color: inherit; font-weight: 700;">
                            {$LANG.invoicenumber}{$invoiceid} &rarr;
                        </a>
                    </div>
                {/if}

                {foreach $addons_html as $addon_html}
                    <div class="order-confirmation-addon-output">
                        {$addon_html}
                    </div>
                {/foreach}

                {if $ispaid}
                    <!-- Conversion/affiliate tracking scripts go here -->
                {/if}

                <div class="complete-actions">
                    <a href="{$WEB_ROOT}/clientarea.php" class="btn-complete-primary">
                        <i class="ti ti-layout-dashboard"></i>
                        {$LANG.orderForm.continueToClientArea}
                    </a>
                    <a href="{$WEB_ROOT}/cart.php" class="btn-complete-ghost">
                        <i class="ti ti-shopping-cart"></i>
                        Continue Shopping
                    </a>
                </div>
            </div>

            {if $hasRecommendations}
                {include file="orderforms/snbdhost_cart/includes/product-recommendations.tpl"}
            {/if}

        </div>
    </div>
</div>
