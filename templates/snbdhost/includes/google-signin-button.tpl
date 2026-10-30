{* Shared Google Identity Services button — relies on assets/js/google-signin.js (onGoogleSignIn) *}
<div class="snbd-google">
    <div id="g_id_onload"
         data-client_id="{$googleClientId}"
         data-context="signin"
         data-ux_mode="popup"
         data-callback="onGoogleSignIn"
         data-auto_prompt="false"></div>
    <div class="g_id_signin"
         data-type="standard"
         data-shape="rectangular"
         data-theme="outline"
         data-text="signin_with"
         data-size="large"
         data-logo_alignment="center"></div>
    <div id="snbdGoogleSignInLoading" class="snbd-auth__google-status" hidden>
        <i class="ti ti-loader-2 snbd-spin" aria-hidden="true"></i> Authenticating securely…
    </div>
    <div id="snbdGoogleSignInError" class="snbd-alert snbd-alert--bad mt-3" role="alert" hidden></div>
</div>
