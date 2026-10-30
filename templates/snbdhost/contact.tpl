{if $sent}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='contactsent'}</p></div>
</div>
{/if}

{if $errormessage}
<div class="snbd-alert snbd-alert--bad" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">{$errormessage}</div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <h1 class="snbd-page-title">{lang key='contactus'}</h1>
        <p class="snbd-page-sub">{lang key='readyforquestions'}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="submitticket.php" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-lifebuoy" aria-hidden="true"></i>Open a ticket instead
        </a>
    </div>
</div>

<div class="row g-4">
    <div class="col-xl-8">
        {if !$sent}
        <section class="snbd-card" aria-labelledby="snbd-contact-form">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-contact-form"><i class="ti ti-mail" aria-hidden="true"></i>{lang key='contactus'}</h2>
            </div>
            <form method="post" action="contact.php" class="snbd-form" role="form">
                <input type="hidden" name="action" value="send">
                <div class="snbd-card__body">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputName">{lang key='supportticketsclientname'}</label>
                            <input type="text" name="name" value="{$name}" class="form-control" id="inputName" autocomplete="name">
                        </div>
                        <div class="col-sm-6">
                            <label class="snbd-label" for="inputEmail">{lang key='supportticketsclientemail'}</label>
                            <input type="email" name="email" value="{$email}" class="form-control" id="inputEmail" autocomplete="email">
                        </div>
                        <div class="col-12">
                            <label class="snbd-label" for="inputSubject">{lang key='supportticketsticketsubject'}</label>
                            <input type="text" name="subject" value="{$subject}" class="form-control" id="inputSubject">
                        </div>
                        <div class="col-12">
                            <label class="snbd-label" for="inputMessage">{lang key='contactmessage'}</label>
                            <textarea name="message" rows="7" class="form-control" id="inputMessage">{$message}</textarea>
                        </div>
                        {if $captcha}
                        <div class="col-12">
                            {include file="$template/includes/captcha.tpl"}
                        </div>
                        {/if}
                    </div>
                </div>
                <div class="snbd-card__foot">
                    <button type="submit" class="snbd-btn snbd-btn--primary{if $captcha} {$captcha->getButtonClass($captchaForm)}{/if}">
                        <i class="ti ti-send" aria-hidden="true"></i>{lang key='contactsend'}
                    </button>
                </div>
            </form>
        </section>
        {else}
        <section class="snbd-card">
            <div class="snbd-empty">
                <span class="snbd-empty__icon"><i class="ti ti-send" aria-hidden="true"></i></span>
                <p class="snbd-empty__title">{lang key='contactsent'}</p>
                <p class="snbd-empty__text">We have your message and will reply to the address you gave us.</p>
                <a href="clientarea.php" class="snbd-btn snbd-btn--secondary snbd-btn--sm">Back to the client area</a>
            </div>
        </section>
        {/if}
    </div>

    <div class="col-xl-4">
        <aside class="snbd-card snbd-card--rail" aria-labelledby="snbd-contact-help">
            <div class="snbd-card__head">
                <h2 class="snbd-card__title" id="snbd-contact-help"><i class="ti ti-lifebuoy" aria-hidden="true"></i>Faster options</h2>
            </div>
            <div class="snbd-card__body">
                <dl class="snbd-kv">
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">Account or billing</dt>
                        <dd class="snbd-kv__v"><a href="submitticket.php">Open a ticket</a></dd>
                    </div>
                    <div class="snbd-kv__row">
                        <dt class="snbd-kv__k">How-to answers</dt>
                        <dd class="snbd-kv__v"><a href="{$WEB_ROOT}/knowledgebase.php">Knowledge base</a></dd>
                    </div>
                </dl>
            </div>
            <div class="snbd-card__foot">
                <p class="snbd-caption mb-0">This form is for pre-sales questions. Existing services are handled through tickets.</p>
            </div>
        </aside>
    </div>
</div>
