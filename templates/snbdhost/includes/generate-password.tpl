<div class="modal fade" id="modalGeneratePassword" tabindex="-1" role="dialog" aria-labelledby="modalGeneratePasswordLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content border-0 shadow" style="border-radius: 16px; overflow: hidden; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="modal-header border-bottom py-3 px-4" style="background: transparent;">
                <h5 class="modal-title fw-bold text-dark fs-5" id="modalGeneratePasswordLabel" style="font-family: 'Plus Jakarta Sans', sans-serif;">
                    <i class="ti ti-key text-danger me-2"></i>{$LANG.generatePassword.title|default:"Generate Password"}
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="frmGeneratePassword" onsubmit="return false;">
                    <div class="alert alert-danger mb-3" id="generatePwLengthError" style="display:none; font-size: 0.85rem; border-radius: 8px;">
                        <i class="ti ti-alert-circle me-1"></i> {$LANG.generatePassword.lengthValidationError|default:"Please enter a number between 8 and 64 for the password length"}
                    </div>
                    
                    <div class="mb-3">
                        <label for="inputGeneratePasswordLength" class="form-label small fw-bold text-muted">
                            {$LANG.generatePassword.pwLength|default:"Password Length"}
                        </label>
                        <input type="number" min="8" max="64" value="12" class="form-control" id="inputGeneratePasswordLength" style="border-radius: 8px; font-weight: 600;">
                    </div>

                    <div class="mb-3">
                        <label for="inputGeneratePasswordOutput" class="form-label small fw-bold text-muted">
                            {$LANG.generatePassword.generatedPw|default:"Generated Password"}
                        </label>
                        <div class="input-group">
                            <input type="text" class="form-control font-monospace" id="inputGeneratePasswordOutput" readonly style="border-radius: 8px 0 0 8px; font-weight: 700; font-size: 1rem; color: var(--brand-primary, #BA1114);">
                            <button type="button" class="btn btn-outline-secondary" onclick="document.getElementById('frmGeneratePassword').dispatchEvent(new Event('submit'))" style="border-radius: 0 8px 8px 0; font-weight: 600;">
                                <i class="ti ti-refresh me-1"></i> Regenerate
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top py-3 px-4" style="background: transparent;">
                <button type="button" class="btn btn-light border px-3" data-bs-dismiss="modal" style="border-radius: 8px; font-weight: 600; font-size: 0.85rem;">
                    {$LANG.close|default:"Close"}
                </button>
                <button type="button" class="btn btn-brand-clean px-4" id="btnGeneratePasswordInsert" data-clipboard-target="#inputGeneratePasswordOutput" style="border-radius: 8px; font-weight: 600; font-size: 0.85rem;">
                    <i class="ti ti-copy me-1"></i> {$LANG.generatePassword.copyAndInsert|default:"Copy to Clipboard & Insert"}
                </button>
            </div>
        </div>
    </div>
</div>
