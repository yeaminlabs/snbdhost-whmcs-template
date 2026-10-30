{if $successful}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='changessavedsuccessfully'}</p></div>
</div>
{/if}

{if $pending}
<div class="snbd-alert snbd-alert--info" role="status">
    <i class="ti ti-clock snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$pendingMessage}</p></div>
</div>
{/if}

{if $domainInformation && !$pending && $domainInformation->getIsIrtpEnabled() && $domainInformation->isContactChangePending()}
    {if $domainInformation->getPendingSuspension()}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__text"><strong>{lang key='domains.verificationRequired'}</strong></p>
        <p class="snbd-alert__text">{lang key='domains.newRegistration'}</p>
    </div>
</div>
    {else}
<div class="snbd-alert snbd-alert--info" role="status">
    <i class="ti ti-info-circle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__text"><strong>{lang key='domains.contactChangePending'}</strong></p>
        <p class="snbd-alert__text">{lang key='domains.contactsChanged'}</p>
    </div>
</div>
    {/if}
{/if}

{if $error}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{$error}</p></div>
</div>
{/if}

<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Domain</p>
        <h1 class="snbd-page-title">{lang key='domaincontactinfo'}</h1>
        <p class="snbd-page-sub">{lang key='whoisContactWarning'}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="clientarea.php?action=domaindetails&amp;id={$domainid}" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
        </a>
    </div>
</div>

<form method="post" action="{$smarty.server.PHP_SELF}?action=domaincontacts" id="frmDomainContactModification" class="snbd-form">
    <input type="hidden" name="sub" value="save" />
    <input type="hidden" name="domainid" value="{$domainid}" />

    <section class="snbd-card" aria-labelledby="snbd-whois-title">
        <div class="snbd-card__head">
            <h2 class="snbd-card__title" id="snbd-whois-title"><i class="ti ti-address-book" aria-hidden="true"></i>{lang key='domaincontactinfo'}</h2>
        </div>

        <div class="snbd-card__body">
            <ul class="nav snbd-tabs" role="tablist">
                {foreach $contactdetails as $contactdetail => $values}
                <li role="presentation">
                    <button class="snbd-tab{if $values@first} active{/if}" id="tabSelector{$contactdetail}" data-bs-toggle="tab" data-bs-target="#tab{$contactdetail}" type="button" role="tab" aria-controls="tab{$contactdetail}" aria-selected="{if $values@first}true{else}false{/if}">{$contactdetail}</button>
                </li>
                {/foreach}
            </ul>

            <div class="tab-content pt-4">
                {foreach $contactdetails as $contactdetail => $values}
                <div class="tab-pane fade{if $values@first} show active{/if}" id="tab{$contactdetail}" role="tabpanel" aria-labelledby="tabSelector{$contactdetail}">

                    <div class="snbd-choice">
                        <label class="snbd-choice__option">
                            <input type="radio" class="form-check-input" name="wc[{$contactdetail}]" id="{$contactdetail}1" value="contact" onclick="useDefaultWhois(this.id)" />
                            <span>{lang key='domaincontactusexisting'}</span>
                        </label>
                    </div>

                    <div class="mb-3 ms-4">
                        <label class="snbd-label" for="{$contactdetail}3">{lang key='domaincontactchoose'}</label>
                        <input type="hidden" name="sel[{$contactdetail}]" value="">
                        <select id="{$contactdetail}3" class="form-select {$contactdetail}defaultwhois" name="sel[{$contactdetail}]" disabled>
                            <option value="u{$clientsdetails.userid}">{lang key='domaincontactprimary'}</option>
                            {foreach $contacts as $contact}
                            <option value="c{$contact.id}">{$contact.name}</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="snbd-choice">
                        <label class="snbd-choice__option">
                            <input type="radio" class="form-check-input" name="wc[{$contactdetail}]" id="{$contactdetail}2" value="custom" onclick="useCustomWhois(this.id)" checked />
                            <span>{lang key='domaincontactusecustom'}</span>
                        </label>
                    </div>

                    <div class="row g-3">
                        {foreach $values as $name => $value}
                        <div class="col-md-6">
                            <div>
                                <label class="snbd-label" for="{$contactdetail}-{$name}">{$contactdetailstranslations[$name]}</label>
                                <input type="text" id="{$contactdetail}-{$name}" name="contactdetails[{$contactdetail}][{$name}]" value="{$value}" data-original-value="{$value}" class="snbd-input form-control {$contactdetail}customwhois{if isset($irtpFields[$contactdetail]) && in_array($name, $irtpFields[$contactdetail])} irtp-field{/if}" />
                            </div>
                        </div>
                        {/foreach}
                    </div>
                </div>
                {/foreach}
            </div>
        </div>

        <div class="snbd-card__foot">
            {if $domainInformation && $irtpFields}
                <input id="irtpOptOut" type="hidden" name="irtpOptOut" value="0">
                <input id="irtpOptOutReason" type="hidden" name="irtpOptOutReason" value="">
            {/if}
            <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='clientareasavechanges'}</button>
            <button type="reset" class="snbd-btn snbd-btn--ghost">{lang key='clientareacancel'}</button>
        </div>
    </section>
</form>

{if $domainInformation && $irtpFields}
<div class="modal fade" id="modalIRTPConfirmation" tabindex="-1" role="dialog" aria-labelledby="IRTPConfirmationLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header" id="modalIRTPConfirmationHeading">
                <h2 class="modal-title" id="IRTPConfirmationLabel">{lang key='domains.importantReminder'}</h2>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="{lang key='orderForm.close'}"></button>
            </div>
            <div class="modal-body text-center" id="modalIRTPConfirmationBody">
                <p>{lang key='domains.irtpNotice'}</p>
                <div class="form-check d-flex justify-content-center">
                    <input id="modalIrtpOptOut" class="form-check-input" type="checkbox" value="1">
                    <label class="form-check-label ms-2" for="modalIrtpOptOut">{lang key='domains.optOut'}</label>
                </div>
                <div class="text-start">
                    <label class="snbd-label" for="modalReason">{lang key='domains.optOutReason'}</label>
                    <input id="modalReason" type="text" class="snbd-input form-control" autocomplete="off">
                </div>
            </div>
            <div class="modal-footer" id="modalIRTPConfirmationFooter">
                <button type="button" id="IRTPConfirmation-Submit" class="snbd-btn snbd-btn--primary" onclick="irtpSubmit();return false;">{lang key='supportticketsticketsubmit'}</button>
                <button type="button" id="IRTPConfirmation-Cancel" class="snbd-btn snbd-btn--ghost" data-bs-dismiss="modal">{lang key='cancel'}</button>
            </div>
        </div>
    </div>
</div>
{/if}
