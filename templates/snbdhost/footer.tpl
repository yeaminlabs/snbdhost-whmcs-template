{if !$snbdAuthPage}
            </div><!-- .snbd-content -->
        </main>
    </div><!-- #snbd-wrapper -->
{/if}

{$footeroutput}

{if !$snbdCustomTemplate}
    <script src="{$BASE_PATH_JS|default:'/assets/js'}/bootstrap.min.js"></script>
    {* Parent theme glue: it calls lightbox and the Bootstrap 4 plugins from the
       parent bundle, so it only ships to pages that still load that bundle. *}
    <script src="{$WEB_ROOT}/templates/{$template}/js/whmcs.js?v={$versionHash}"></script>
{else}
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
{/if}
<script src="{$WEB_ROOT}/templates/{$template}/assets/js/snbd-shell.js?v={$smarty.now}"></script>

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
