<div class="snbd-stack snbd-form">

    {if $submitted}
        {if $success}
            <div class="snbd-alert snbd-alert--ok" role="status">
                <i class="ti ti-circle-check snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body">
                    <p class="snbd-alert__title">Migration request submitted</p>
                    <p class="snbd-alert__text">We have your details. Our migration team will review the request and contact you shortly.</p>
                </div>
            </div>
        {elseif $error}
            <div class="snbd-alert snbd-alert--bad" role="alert">
                <i class="ti ti-alert-triangle snbd-alert__icon" aria-hidden="true"></i>
                <div class="snbd-alert__body">
                    <p class="snbd-alert__title">We could not submit the request</p>
                    <p class="snbd-alert__text">{$error}</p>
                </div>
            </div>
        {/if}
    {/if}

    <header class="snbd-page-head">
        <div class="snbd-page-head__text">
            <p class="snbd-eyebrow">Free service</p>
            <h1 class="snbd-page-title">Migrate to SNBD Host</h1>
            <p class="snbd-page-sub">Tell us where your site lives today and our team will move it over, usually within one business day.</p>
        </div>
        <div class="snbd-page-actions">
            <a href="clientarea.php" class="snbd-btn snbd-btn--ghost">
                <i class="ti ti-arrow-left" aria-hidden="true"></i> Back to dashboard
            </a>
        </div>
    </header>

    {if !$success}
    <section class="snbd-card">
        <form method="post" action="migration.php" id="frmMigration">
            <input type="hidden" name="token" value="{$csrfToken}" />
            <input type="hidden" name="submit_migration" value="1" />

            <div class="snbd-card__head">
                <h2 class="snbd-card__title"><i class="ti ti-world-upload" aria-hidden="true"></i> Site details</h2>
            </div>

            <div class="snbd-card__body snbd-stack">
                <div class="snbd-grid snbd-grid--2">
                    <div>
                        <label class="snbd-label" for="migProvider">Previous hosting provider</label>
                        <input type="text" name="previous_provider" id="migProvider" class="form-control" placeholder="e.g. Bluehost, HostGator" required>
                    </div>
                    <div>
                        <label class="snbd-label" for="migUrl">Website URL</label>
                        <input type="url" name="website_url" id="migUrl" class="form-control" placeholder="https://yourdomain.com" required>
                    </div>
                    <div>
                        <label class="snbd-label" for="migCms">CMS</label>
                        <select name="cms" id="migCms" class="form-select" required>
                            <option value="">Select CMS…</option>
                            <option value="WordPress">WordPress</option>
                            <option value="Joomla">Joomla</option>
                            <option value="Drupal">Drupal</option>
                            <option value="Magento">Magento</option>
                            <option value="Custom HTML/PHP">Custom HTML/PHP</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div>
                        <label class="snbd-label" for="migApp">Is this a web app?</label>
                        <select name="is_web_app" id="migApp" class="form-select" required>
                            <option value="No">No, a standard website</option>
                            <option value="Node.js">Yes, Node.js app</option>
                            <option value="Vite/React/Vue">Yes, Vite / React / Vue</option>
                            <option value="Python/Django">Yes, Python / Django</option>
                            <option value="Other">Yes, other framework</option>
                        </select>
                    </div>
                </div>

                <hr class="snbd-divider">

                <div>
                    <span class="snbd-label">Hosting requirements</span>
                    <p class="snbd-hint mb-3">What do you need after the migration?</p>

                    <div class="snbd-stack snbd-stack--sm">
                        <label class="snbd-choice-card" for="host_already_have">
                            <input class="snbd-choice__input" type="radio" name="hosting_required" value="already_have" id="host_already_have" required>
                            <span class="snbd-choice-card__body">
                                <span class="snbd-choice-card__title">I already have hosting with SNBD Host</span>
                                <span class="snbd-choice-card__text">We will move the site into your existing active package.</span>
                            </span>
                        </label>

                        <div class="snbd-choice-reveal" id="alreadyHaveFields">
                            <div class="snbd-grid snbd-grid--2">
                                <div>
                                    <label class="snbd-label" for="field_username">Account username</label>
                                    <input type="text" name="existing_username" id="field_username" class="form-control" placeholder="Your SNBD Host username">
                                </div>
                                <div>
                                    <label class="snbd-label" for="field_package">Package to migrate to</label>
                                    <input type="text" name="target_package" id="field_package" class="form-control" placeholder="e.g. Starter Pro, VPS">
                                </div>
                            </div>
                        </div>

                        <label class="snbd-choice-card" for="host_need_help">
                            <input class="snbd-choice__input" type="radio" name="hosting_required" value="need_help" id="host_need_help">
                            <span class="snbd-choice-card__body">
                                <span class="snbd-choice-card__title">Help me choose a package</span>
                                <span class="snbd-choice-card__text">Not sure yet? An expert will talk it through with you.</span>
                            </span>
                        </label>

                        <div class="snbd-choice-reveal" id="needHelpFields">
                            <div class="snbd-spread">
                                <p class="mb-0 snbd-small">Call or message us and we will recommend the right plan before starting.</p>
                                <span class="snbd-cluster snbd-cluster--loose">
                                    <a href="tel:+8801900000000" class="snbd-btn snbd-btn--secondary snbd-btn--sm">
                                        <i class="ti ti-phone" aria-hidden="true"></i> Call
                                    </a>
                                    <a href="https://wa.me/8801900000000" target="_blank" rel="noopener" class="snbd-btn snbd-btn--primary snbd-btn--sm">
                                        <i class="ti ti-brand-whatsapp" aria-hidden="true"></i> WhatsApp
                                    </a>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="snbd-card__foot">
                <span class="snbd-caption">No downtime migration · Free for every plan</span>
                <button type="submit" class="snbd-btn snbd-btn--primary" id="btnSubmitMigration">
                    Submit request <i class="ti ti-arrow-right" aria-hidden="true"></i>
                </button>
            </div>
        </form>
    </section>
    {/if}

</div>

<script>
{literal}
document.addEventListener('DOMContentLoaded', function () {
    const radioAlreadyHave = document.getElementById('host_already_have');
    const radioNeedHelp = document.getElementById('host_need_help');
    const panelAlreadyHave = document.getElementById('alreadyHaveFields');
    const panelNeedHelp = document.getElementById('needHelpFields');
    const inputUsername = document.getElementById('field_username');
    const inputPackage = document.getElementById('field_package');
    const submitBtn = document.getElementById('btnSubmitMigration');

    if (!radioAlreadyHave || !radioNeedHelp) return;

    function updateUI() {
        document.querySelectorAll('.snbd-choice-card').forEach(function (el) {
            el.classList.remove('is-selected');
        });

        if (radioAlreadyHave.checked) {
            radioAlreadyHave.closest('.snbd-choice-card').classList.add('is-selected');
            panelAlreadyHave.classList.add('is-open');
            panelNeedHelp.classList.remove('is-open');
            inputUsername.setAttribute('required', 'required');
            inputPackage.setAttribute('required', 'required');
            if (submitBtn) submitBtn.style.display = '';
        } else if (radioNeedHelp.checked) {
            radioNeedHelp.closest('.snbd-choice-card').classList.add('is-selected');
            panelNeedHelp.classList.add('is-open');
            panelAlreadyHave.classList.remove('is-open');
            inputUsername.removeAttribute('required');
            inputPackage.removeAttribute('required');
            if (submitBtn) submitBtn.style.display = 'none';
        }
    }

    radioAlreadyHave.addEventListener('change', updateUI);
    radioNeedHelp.addEventListener('change', updateUI);
    updateUI();
});
{/literal}
</script>
