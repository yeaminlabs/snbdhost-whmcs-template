<div class="container mt-5 mb-5" style="max-width: 800px;">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="dash-headline" style="font-size: 2.25rem; margin-bottom: 0.25rem;">Free <span class="dash-headline-accent">Migration</span> Request</h1>
            <p class="text-secondary small mb-0">Fill out the details below and our experts will handle the entire migration process for you.</p>
        </div>
        <a href="clientarea.php" class="btn btn-outline-clean"><i class="ti ti-arrow-left me-2"></i>Back to Dashboard</a>
    </div>

    {if $submitted}
        {if $success}
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert" style="border-radius: 14px; border: none; background: #ecfdf5; color: #065f46;">
                <div class="d-flex align-items-center">
                    <i class="ti ti-circle-check-filled me-3" style="font-size: 1.5rem; color: #10b981;"></i>
                    <div>
                        <h5 class="mb-1 fw-bold">Migration Request Submitted!</h5>
                        <p class="mb-0 small">We have received your details. Our migration experts will begin reviewing your request and will contact you shortly.</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        {elseif $error}
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert" style="border-radius: 14px; border: none;">
                <div class="d-flex align-items-center">
                    <i class="ti ti-alert-triangle-filled me-3" style="font-size: 1.5rem;"></i>
                    <div>
                        <h5 class="mb-1 fw-bold">Error Submitting Request</h5>
                        <p class="mb-0 small">{$error}</p>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        {/if}
    {/if}

    {if !$success}
    <div class="card dash-card-clean shadow-sm" style="border-radius: 16px; border: 1px solid #eeeeee;">
        <div class="card-body p-4 p-md-5">
            <form method="post" action="migration.php" id="frmMigration">
                <input type="hidden" name="token" value="{$csrfToken}" />
                <input type="hidden" name="submit_migration" value="1" />

                <div class="row g-4">
                    
                    <!-- Previous Provider -->
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark">Previous Hosting Provider</label>
                        <input type="text" name="previous_provider" class="form-control form-control-lg bg-light border-0 custom-input" placeholder="e.g. Bluehost, HostGator" required>
                    </div>

                    <!-- Website URL -->
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark">Website URL</label>
                        <input type="url" name="website_url" class="form-control form-control-lg bg-light border-0 custom-input" placeholder="https://yourdomain.com" required>
                    </div>

                    <!-- CMS -->
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark">Your CMS</label>
                        <select name="cms" class="form-select form-select-lg bg-light border-0 custom-input" required>
                            <option value="">Select CMS...</option>
                            <option value="WordPress">WordPress</option>
                            <option value="Joomla">Joomla</option>
                            <option value="Drupal">Drupal</option>
                            <option value="Magento">Magento</option>
                            <option value="Custom HTML/PHP">Custom HTML/PHP</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <!-- Web App -->
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-dark">Is this a Web App?</label>
                        <select name="is_web_app" class="form-select form-select-lg bg-light border-0 custom-input" required>
                            <option value="No">No, it's a standard website</option>
                            <option value="Node.js">Yes, Node.js App</option>
                            <option value="Vite/React/Vue">Yes, Vite / React / Vue</option>
                            <option value="Python/Django">Yes, Python / Django</option>
                            <option value="Other">Yes, Other Framework</option>
                        </select>
                    </div>

                    <div class="col-12 mt-4 pt-3 border-top">
                        <h5 class="fw-bold mb-3">Hosting Requirements</h5>
                        <p class="text-secondary small mb-3">What kind of web hosting do you require with this migration?</p>
                        
                        <div class="d-flex flex-column gap-3">
                            <!-- Option 1 -->
                            <label class="premium-radio-card p-3 rounded-3 border d-flex align-items-center cursor-pointer">
                                <input class="form-check-input me-3 mt-0" type="radio" name="hosting_required" value="already_have" id="host_already_have" style="transform: scale(1.2);" required>
                                <div>
                                    <span class="d-block fw-bold text-dark">I already have web hosting with SNBD HOST</span>
                                    <span class="small text-secondary">We will migrate the site into your existing active package.</span>
                                </div>
                            </label>

                            <!-- Dynamic fields for Option 1 -->
                            <div class="bg-light p-4 rounded-3 collapse" id="alreadyHaveFields">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-dark small">Username of your account</label>
                                        <input type="text" name="existing_username" id="field_username" class="form-control form-control-lg border-0 bg-white shadow-sm" placeholder="Your SNBD Host username">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-dark small">Hosting package to migrate to</label>
                                        <input type="text" name="target_package" id="field_package" class="form-control form-control-lg border-0 bg-white shadow-sm" placeholder="e.g. Starter Pro, VPS">
                                    </div>
                                </div>
                            </div>

                            <!-- Option 2 -->
                            <label class="premium-radio-card p-3 rounded-3 border d-flex align-items-center cursor-pointer">
                                <input class="form-check-input me-3 mt-0" type="radio" name="hosting_required" value="need_help" id="host_need_help" style="transform: scale(1.2);">
                                <div>
                                    <span class="d-block fw-bold text-dark">I need help choosing a migration package</span>
                                    <span class="small text-secondary">Not sure which plan to pick? Let our experts guide you.</span>
                                </div>
                            </label>

                            <!-- Dynamic Contact Box for Option 2 -->
                            <div class="p-4 rounded-3 collapse bg-primary bg-opacity-10 border border-primary border-opacity-25" id="needHelpFields">
                                <div class="d-flex flex-column flex-md-row align-items-center justify-content-between gap-4">
                                    <div>
                                        <h5 class="fw-bold text-primary mb-1">Let's talk to an expert!</h5>
                                        <p class="small text-dark mb-0 opacity-75">Please contact us via phone or WhatsApp to discuss your exact needs before we begin the migration.</p>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <a href="tel:+8801900000000" class="btn btn-light shadow-sm text-primary fw-bold px-4 py-2 rounded-pill d-flex align-items-center gap-2">
                                            <i class="ti ti-phone-filled"></i> Call Us
                                        </a>
                                        <a href="https://wa.me/8801900000000" target="_blank" class="btn btn-success shadow-sm fw-bold px-4 py-2 rounded-pill d-flex align-items-center gap-2">
                                            <i class="ti ti-brand-whatsapp"></i> WhatsApp
                                        </a>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 mt-5">
                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-3 fw-bold fs-5 shadow-sm" id="btnSubmitMigration">
                            Submit Migration Request <i class="ti ti-arrow-right ms-2"></i>
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </div>
    {/if}
</div>

<style>
.custom-input:focus {
    box-shadow: 0 0 0 4px rgba(255, 108, 44, 0.15) !important;
}
.premium-radio-card {
    transition: all 0.2s ease;
    background: #ffffff;
}
.premium-radio-card:hover {
    border-color: #ff6c2c !important;
    background: rgba(255,108,44,0.02);
}
.premium-radio-card.active-radio {
    border-color: #ff6c2c !important;
    background: rgba(255,108,44,0.05);
    box-shadow: 0 4px 15px rgba(255,108,44,0.1);
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const radioAlreadyHave = document.getElementById('host_already_have');
    const radioNeedHelp = document.getElementById('host_need_help');
    
    const panelAlreadyHave = document.getElementById('alreadyHaveFields');
    const panelNeedHelp = document.getElementById('needHelpFields');
    
    const inputUsername = document.getElementById('field_username');
    const inputPackage = document.getElementById('field_package');
    const submitBtn = document.getElementById('btnSubmitMigration');

    function updateUI() {
        // Reset styles
        document.querySelectorAll('.premium-radio-card').forEach(el => el.classList.remove('active-radio'));

        if (radioAlreadyHave.checked) {
            radioAlreadyHave.closest('.premium-radio-card').classList.add('active-radio');
            
            // Show fields
            panelAlreadyHave.classList.add('show');
            panelNeedHelp.classList.remove('show');
            
            // Make required
            inputUsername.setAttribute('required', 'required');
            inputPackage.setAttribute('required', 'required');

            // Enable submit
            submitBtn.style.display = 'block';
        } else if (radioNeedHelp.checked) {
            radioNeedHelp.closest('.premium-radio-card').classList.add('active-radio');
            
            // Show contact info
            panelNeedHelp.classList.add('show');
            panelAlreadyHave.classList.remove('show');
            
            // Remove required
            inputUsername.removeAttribute('required');
            inputPackage.removeAttribute('required');

            // Optionally disable or change submit button text
            submitBtn.style.display = 'none'; // Since they must contact first
        }
    }

    radioAlreadyHave.addEventListener('change', updateUI);
    radioNeedHelp.addEventListener('change', updateUI);
});
</script>
