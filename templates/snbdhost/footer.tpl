{if $templatefile == 'login' || $templatefile == 'clientregister' || $templatefile == 'pwreset' || strpos($templatefile, 'password-reset') !== false}
    </div><!-- .auth-page -->
{else}
            </div><!-- .snbd-content -->
        </main>
    </div><!-- #snbd-wrapper -->
{/if}

{if $templatefile != 'login' && $templatefile != 'clientregister' && $templatefile != 'pwreset' && strpos($templatefile, 'password-reset') === false}
    <!-- Floating Action Button -->
    <div id="fab-container" class="fab-container">
        <button id="fab-main" class="fab-main"><i class="fas fa-plus"></i></button>
        <div class="fab-menu">
            <a href="submitticket.php" class="fab-item" data-tooltip="New Ticket"><i class="fas fa-envelope"></i></a>
            <a href="clientarea.php?action=invoices" class="fab-item" data-tooltip="Pay Invoice"><i class="fas fa-file-invoice-dollar"></i></a>
            <a href="cart.php" class="fab-item" data-tooltip="Order Service"><i class="fas fa-shopping-cart"></i></a>
        </div>
    </div>
{/if}



{$footeroutput}

<!-- JS Dependencies -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
<script src="{$WEB_ROOT}/templates/{$template}/assets/js/snbdhost-theme.js"></script>

</body>
</html>
