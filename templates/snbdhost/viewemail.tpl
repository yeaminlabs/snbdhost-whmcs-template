<!DOCTYPE html>
<html lang="{if $language}{$language}{else}en{/if}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{lang key='clientareaemails'} - {$companyname}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@3.50.0/dist/tabler-icons.min.css">
    <link rel="stylesheet" href="{$WEB_ROOT}/templates/{$template}/assets/css/snbd-system.css?v={$versionHash}">
    <link rel="stylesheet" href="{$WEB_ROOT}/templates/{$template}/assets/css/snbd-shell.css?v={$versionHash}">
</head>
<body class="snbd-popup-body">
    <article class="snbd-card snbd-popup-card" aria-labelledby="snbd-email-subject">
        <div class="snbd-card__head">
            <h1 class="snbd-card__title snbd-popup-title" id="snbd-email-subject">
                <i class="ti ti-mail" aria-hidden="true"></i>{$subject}
            </h1>
        </div>

        {if is_array($attachments) && count($attachments) > 0}
        <div class="snbd-card__body snbd-popup-attachments">
            <p class="snbd-eyebrow">Attachments</p>
            <ul class="snbd-popup-attachment-list">
                {foreach $attachments as $attachedFile}
                <li><i class="ti ti-paperclip" aria-hidden="true"></i>{$attachedFile}</li>
                {/foreach}
            </ul>
        </div>
        {/if}

        <div class="snbd-card__body snbd-popup-message">
            <iframe title="{$subject}" width="100%" height="380" frameborder="0" sandbox="allow-popups allow-popups-to-escape-sandbox" srcdoc="{$message|escape}"></iframe>
        </div>

        <div class="snbd-card__foot snbd-popup-foot">
            <button type="button" class="snbd-btn snbd-btn--primary" onclick="window.close()">
                {lang key='closewindow'}
            </button>
        </div>
    </article>
</body>
</html>
