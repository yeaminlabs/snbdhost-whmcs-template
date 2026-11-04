{*
   $versionHash is the WHMCS version, so it never changes when a theme is
   deployed: browsers kept serving the pre-redesign custom.css against the new
   markup and the store rendered as bare text. Stamp it per render, exactly as
   header.tpl does for the theme stylesheets, so a deploy is always picked up.
*}
<link rel="stylesheet" type="text/css" href="{assetPath file='custom.css'}?v={$smarty.now}" />
<script type="text/javascript" src="{assetPath file='scripts.min.js'}?v={$smarty.now}"></script>
