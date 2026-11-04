{* Fallback only. hermesagent_manage_chat() issues a 302 straight to the agent's
   own /chat; this renders solely when output has already started and PHP can no
   longer send headers. Keep it minimal — it exists to get out of WHMCS fast. *}
<script>window.location.replace({$chat_url|json_encode nofilter});</script>
<meta http-equiv="refresh" content="0;url={$chat_url|escape:'html'}">

<div style="font-family:system-ui,sans-serif;text-align:center;padding:60px 20px;color:#6b7280">
  <div style="font-size:15px;margin-bottom:14px">Opening your agent's chat…</div>
  <a href="{$chat_url|escape:'html'}"
     style="display:inline-block;padding:11px 22px;border-radius:9px;background:linear-gradient(135deg,#f5a524,#ff7a20);color:#1a1109;font-weight:700;text-decoration:none">
    Continue to chat
  </a>
</div>
