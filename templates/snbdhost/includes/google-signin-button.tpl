{* Shared Google Identity Services button — relies on assets/js/google-signin.js (onGoogleSignIn) *}
<div class="snbd-google-signin-wrapper">
    <div id="g_id_onload"
         data-client_id="{$googleClientId}"
         data-context="signin"
         data-ux_mode="popup"
         data-callback="onGoogleSignIn"
         data-auto_prompt="false">
    </div>
    <div class="g_id_signin"
         data-type="standard"
         data-shape="rectangular"
         data-theme="outline"
         data-text="signin_with"
         data-size="large"
         data-logo_alignment="center">
    </div>
    <div id="snbdGoogleSignInLoading"><i class="fas fa-circle-notch fa-spin me-2"></i>Authenticating securely...</div>
    <div id="snbdGoogleSignInError" class="pr-error text-start"></div>
</div>
