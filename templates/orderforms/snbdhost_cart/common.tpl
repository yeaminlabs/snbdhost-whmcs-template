<link rel="stylesheet" type="text/css" href="{assetPath file='all.min.css'}?v={$versionHash}" />
<link rel="stylesheet" type="text/css" href="{assetPath file='custom.css'}?v={$versionHash}" />
{assetExists file="custom.css"}
<link rel="stylesheet" type="text/css" href="{$__assetPath__}?v={$versionHash}" />
{/assetExists}
<script type="text/javascript" src="{assetPath file='scripts.min.js'}?v={$versionHash}"></script>