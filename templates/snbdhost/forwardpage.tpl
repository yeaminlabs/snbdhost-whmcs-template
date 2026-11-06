{* Payment hand-off (cart.php?a=complete, viewinvoice → gateway).
   Overrides twenty-one/forwardpage.tpl. The gateway's form ($code) and the
   fallback form must stay inside #frmPayment: autoSubmitFormByContainer()
   submits the first form it finds there. *}
<style>
.snbd-forward {
    display: flex;
    justify-content: center;
    padding: var(--snbd-s10) 0 var(--snbd-s14);
}
.snbd-forward__card {
    width: 100%;
    max-width: 520px;
    padding: var(--snbd-s10) var(--snbd-s8) var(--snbd-s8);
    background: var(--snbd-surface);
    border: 1px solid var(--snbd-line);
    border-radius: var(--snbd-r-xl);
    box-shadow: var(--snbd-e2);
    text-align: center;
}
.snbd-forward__icon {
    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 72px;
    height: 72px;
    margin-bottom: var(--snbd-s5);
    border-radius: 50%;
    background: var(--snbd-red-soft);
    color: var(--snbd-red);
    font-size: 1.75rem;
}
.snbd-forward__icon::after {
    content: "";
    position: absolute;
    inset: -6px;
    border-radius: 50%;
    border: 2px solid transparent;
    border-top-color: var(--snbd-red);
    animation: snbdForwardSpin 1s linear infinite;
}
@keyframes snbdForwardSpin { to { transform: rotate(360deg); } }
.snbd-forward__title {
    margin: 0 0 var(--snbd-s2);
    font-family: var(--snbd-font-display);
    font-size: 1.375rem;
    font-weight: 800;
    letter-spacing: -0.015em;
    color: var(--snbd-ink-900);
}
.snbd-forward__msg {
    margin: 0 auto var(--snbd-s6);
    max-width: 40ch;
    font-size: 0.9375rem;
    line-height: 1.55;
    color: var(--snbd-ink-500);
}
.snbd-forward__bar {
    height: 4px;
    margin: 0 0 var(--snbd-s3);
    overflow: hidden;
    border-radius: var(--snbd-r-pill);
    background: var(--snbd-surface-3);
}
.snbd-forward__bar span {
    display: block;
    width: 0;
    height: 100%;
    border-radius: inherit;
    background: var(--snbd-red);
    animation: snbdForwardFill 5s linear forwards;
}
@keyframes snbdForwardFill { to { width: 100%; } }
.snbd-forward__count {
    margin: 0 0 var(--snbd-s6);
    font-size: 0.8125rem;
    color: var(--snbd-ink-400);
    font-variant-numeric: tabular-nums;
}
.snbd-forward__actions {
    display: flex;
    flex-direction: column;
    gap: var(--snbd-s2);
}
.snbd-forward__secure {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    margin: var(--snbd-s6) 0 0;
    padding-top: var(--snbd-s5);
    border-top: 1px solid var(--snbd-line);
    font-size: 0.75rem;
    color: var(--snbd-ink-400);
}
.snbd-forward__secure i { font-size: 0.9375rem; color: var(--snbd-ok); }
/* Gateway markup is kept (some gateways print instructions), but its own
   buttons duplicate ours, so they are tucked away. */
.snbd-forward__gateway { margin-top: var(--snbd-s4); font-size: 0.875rem; color: var(--snbd-ink-500); }
.snbd-forward__gateway input[type="submit"],
.snbd-forward__gateway button[type="submit"],
.snbd-forward__gateway button:not([type]) { display: none; }
.snbd-forward--manual .snbd-forward__icon::after,
.snbd-forward--manual .snbd-forward__bar,
.snbd-forward--manual .snbd-forward__count,
.snbd-forward--manual #snbdForwardNow { display: none; }
.snbd-forward--manual .snbd-forward__gateway { text-align: left; }
.snbd-forward--manual .snbd-forward__gateway input[type="submit"],
.snbd-forward--manual .snbd-forward__gateway button { display: inline-flex; }
@media (prefers-reduced-motion: reduce) {
    .snbd-forward__icon::after { animation: none; border-color: var(--snbd-red-ring); }
    .snbd-forward__bar span { animation: none; width: 100%; }
}
@media (max-width: 575px) {
    .snbd-forward { padding: var(--snbd-s6) 0 var(--snbd-s10); }
    .snbd-forward__card { padding: var(--snbd-s8) var(--snbd-s5) var(--snbd-s6); }
}
</style>

<div class="snbd-forward">
    <div class="snbd-forward__card" role="status" aria-live="polite">
        <span class="snbd-forward__icon" aria-hidden="true"><i class="ti ti-credit-card"></i></span>
        <h1 class="snbd-forward__title">Taking you to payment</h1>
        <p class="snbd-forward__msg">{$message}</p>

        <div class="snbd-forward__bar" aria-hidden="true"><span></span></div>
        <p class="snbd-forward__count" id="snbdForwardCount">Redirecting in <strong>5</strong> seconds…</p>

        <div class="snbd-forward__actions">
            <button type="button" class="snbd-btn snbd-btn--primary snbd-btn--lg snbd-btn--block" id="snbdForwardNow">
                Continue to payment <i class="ti ti-arrow-right" aria-hidden="true"></i>
            </button>
            {if $invoiceid}
                <a href="viewinvoice.php?id={$invoiceid}" class="snbd-btn snbd-btn--ghost snbd-btn--block">
                    View invoice #{$invoiceid}
                </a>
            {/if}
        </div>

        <div id="frmPayment" class="snbd-forward__gateway">{$code}<form method="post" action="{if $invoiceid}viewinvoice.php?id={$invoiceid}{else}clientarea.php{/if}"></form></div>

        <p class="snbd-forward__secure"><i class="ti ti-lock" aria-hidden="true"></i> Secure checkout. Don't close or refresh this page.</p>
    </div>
</div>

<script>
{literal}
(function () {
    var seconds = 5,
        sent = false,
        count = document.getElementById('snbdForwardCount'),
        btn = document.getElementById('snbdForwardNow');

    // Gateways that need customer input set noAutoSubmit in $code. Show their
    // own form and buttons instead of counting down to a submit that won't happen.
    if (typeof noAutoSubmit !== 'undefined' && noAutoSubmit) {
        document.querySelector('.snbd-forward').classList.add('snbd-forward--manual');
        document.querySelector('.snbd-forward__title').textContent = 'Complete your payment';
        return;
    }

    function go() {
        if (sent) {
            return;
        }
        sent = true;
        btn.disabled = true;
        btn.innerHTML = '<i class="ti ti-loader-2" aria-hidden="true"></i> Redirecting…';
        count.textContent = 'Redirecting now…';
        autoSubmitFormByContainer('frmPayment');
    }

    var timer = setInterval(function () {
        seconds--;
        if (seconds <= 0) {
            clearInterval(timer);
            go();
            return;
        }
        count.innerHTML = 'Redirecting in <strong>' + seconds + '</strong> second' + (seconds === 1 ? '' : 's') + '…';
    }, 1000);

    btn.addEventListener('click', function () {
        clearInterval(timer);
        go();
    });
})();
{/literal}
</script>
