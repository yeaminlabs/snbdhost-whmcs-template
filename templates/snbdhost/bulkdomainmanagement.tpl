<div class="snbd-page-head">
    <div class="snbd-page-head__text">
        <p class="snbd-eyebrow">Domains</p>
        <h1 class="snbd-page-title">
            {if $update eq "nameservers"}{lang key='changenameservers'}
            {elseif $update eq "autorenew"}{lang key='domainautorenewstatus'}
            {elseif $update eq "reglock"}{lang key='domainreglockstatus'}
            {elseif $update eq "contactinfo"}{lang key='domaincontactinfoedit'}
            {else}{lang key='domainbulkmanagement'}{/if}
        </h1>
        <p class="snbd-page-sub">{lang key='domainbulkmanagementchangesaffect'}</p>
    </div>
    <div class="snbd-page-actions">
        <a href="clientarea.php?action=domains" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
            <i class="ti ti-arrow-left" aria-hidden="true"></i>{lang key='clientareabacklink'}
        </a>
    </div>
</div>

{if $save}
    {if $errors}
<div class="snbd-alert snbd-alert--warn" role="alert">
    <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body">
        <p class="snbd-alert__title">{lang key='clientareaerrors'}</p>
        <ul class="mb-0">
            {foreach $errors as $error}
            <li>{$error}</li>
            {/foreach}
        </ul>
    </div>
</div>
    {else}
<div class="snbd-alert snbd-alert--ok" role="status">
    <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
    <div class="snbd-alert__body"><p class="snbd-alert__text">{lang key='changessavedsuccessfully'}</p></div>
</div>
    {/if}
{/if}

<form method="post" action="{$smarty.server.PHP_SELF}?action=bulkdomain" class="snbd-form">
    <input type="hidden" name="token" value="{$token}">
    <input type="hidden" name="update" value="{$update}">
    <input type="hidden" name="save" value="1">
    {foreach $domainids as $domainid}
    <input type="hidden" name="domids[]" value="{$domainid}" />
    {/foreach}

    <section class="snbd-card" aria-labelledby="snbd-bulk-title">
        <div class="snbd-card__head">
            <h2 class="snbd-card__title" id="snbd-bulk-title">
                <i class="ti ti-stack" aria-hidden="true"></i>
                {if $update eq "nameservers"}{lang key='changenameservers'}
                {elseif $update eq "autorenew"}{lang key='domainautorenewstatus'}
                {elseif $update eq "reglock"}{lang key='domainreglockstatus'}
                {elseif $update eq "contactinfo"}{lang key='domaincontactinfoedit'}
                {else}{lang key='domainbulkmanagement'}{/if}
            </h2>
            <span class="snbd-chip snbd-chip--neutral">{$domains|@count} {lang key='domains'}</span>
        </div>

        <div class="snbd-card__body">
            <ul class="snbd-list mb-4">
                {foreach $domains as $domain}
                <li><span class="snbd-list__item d-flex align-items-center gap-2"><i class="ti ti-world" aria-hidden="true"></i>{$domain}</span></li>
                {/foreach}
            </ul>

            {if $update eq "nameservers"}

                <div class="snbd-choice">
                    <label class="snbd-choice__option">
                        <input id="nsChoiceDefault" type="radio" class="form-check-input" name="nschoice" value="default" onclick="disableFields('domnsinputs',true)" checked />
                        <span>{lang key='nschoicedefault'}</span>
                    </label>
                    <label class="snbd-choice__option">
                        <input id="nsChoiceCustom" type="radio" class="form-check-input" name="nschoice" value="custom" onclick="disableFields('domnsinputs', '')" checked />
                        <span>{lang key='nschoicecustom'}</span>
                    </label>
                </div>

                <div class="row g-3">
                    {for $num=1 to 5}
                    <div class="col-md-6">
                        <label class="snbd-label" for="inputNs{$num}">{lang key='clientareanameserver'} {$num}</label>
                        <input type="text" name="ns{$num}" class="snbd-input form-control domnsinputs" id="inputNs{$num}" />
                    </div>
                    {/for}
                </div>

            {elseif $update eq "autorenew"}

                <p>{lang key='domainautorenewinfo'}</p>
                <p class="snbd-hint">{lang key='domainautorenewrecommend'}</p>

            {elseif $update eq "reglock"}

                <p>{lang key='domainreglockinfo'}</p>
                <p class="snbd-hint">{lang key='domainreglockrecommend'}</p>

            {elseif $update eq "contactinfo"}

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
                            <select id="{$contactdetail}3" class="snbd-input form-select {$contactdetail}defaultwhois" name="sel[{$contactdetail}]" disabled>
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
                                <label class="snbd-label" for="{$contactdetail}-{$name}">{$contactdetailstranslations[$name]}</label>
                                <input type="text" id="{$contactdetail}-{$name}" name="contactdetails[{$contactdetail}][{$name}]" value="{$value}" data-original-value="{$value}" class="snbd-input form-control {$contactdetail}customwhois{if isset($irtpFields[$contactdetail]) && in_array($name, $irtpFields[$contactdetail])} irtp-field{/if}" />
                            </div>
                            {/foreach}
                        </div>
                    </div>
                    {/foreach}
                </div>

            {/if}
        </div>

        <div class="snbd-card__foot">
            {if $update eq "autorenew"}
                <button type="submit" name="enable" class="snbd-btn snbd-btn--primary">{lang key='domainsautorenewenable'}</button>
                <button type="submit" name="disable" class="snbd-btn snbd-btn--danger">{lang key='domainsautorenewdisable'}</button>
            {elseif $update eq "reglock"}
                <button type="submit" name="enable" class="snbd-btn snbd-btn--primary">{lang key='domainreglockenable'}</button>
                <button type="submit" name="disable" class="snbd-btn snbd-btn--danger">{lang key='domainreglockdisable'}</button>
            {elseif $update eq "nameservers"}
                <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='changenameservers'}</button>
            {elseif $update eq "contactinfo"}
                <button type="submit" class="snbd-btn snbd-btn--primary">{lang key='clientareasavechanges'}</button>
            {/if}
            <a href="clientarea.php?action=domains" class="snbd-btn snbd-btn--ghost">{lang key='cancel'}</a>
        </div>
    </section>
</form>

<script type="text/javascript">
    var disableInternalTabSelection = true;
</script>
