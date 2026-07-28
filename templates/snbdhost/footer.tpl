{if $templatefile == 'login' || $templatefile == 'clientregister' || $templatefile == 'pwreset' || strpos($templatefile|default:'', 'password-reset') !== false}
    </div><!-- .auth-page -->
{else}
            </div><!-- .snbd-content -->
        </main>
    </div><!-- #snbd-wrapper -->
{/if}

{if $templatefile != 'login' && $templatefile != 'clientregister' && $templatefile != 'pwreset' && strpos($templatefile|default:'', 'password-reset') === false}
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
<script src="{$WEB_ROOT}/templates/{$template}/assets/js/snbdhost-theme.js"></script>

<!--Start of Tawk.to Script-->
<script type="text/javascript">
var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
(function(){
var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;
s1.src='https://embed.tawk.to/682acb6cb26df01905315870/1irjil7vn';
s1.charset='UTF-8';
s1.setAttribute('crossorigin','*');
s0.parentNode.insertBefore(s1,s0);
})();
</script>
<!--End of Tawk.to Script-->

</body>
</html>
