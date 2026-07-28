<div class="modal fade" id="modalGeneratePassword" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow" style="border-radius: 16px; overflow: hidden; background: var(--bg-surface, #ffffff); border: 1px solid var(--border-color, #e0e0e0) !important;">
            <div class="modal-header border-bottom py-3 px-4">
                <h5 class="modal-title fw-bold text-dark d-flex align-items-center gap-2" style="font-family: var(--font-heading, 'Plus Jakarta Sans', sans-serif); font-size: 1.1rem;">
                    <i class="ti ti-key text-danger"></i> {$LANG.generatePassword.title|default:"Generate Password"}
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <form id="frmGeneratePassword">
                    <div class="alert alert-danger w-hidden mb-3" id="generatePwLengthError">
                        {$LANG.generatePassword.lengthValidationError|default:"Please enter a number between 8 and 64 for the password length"}
                    </div>
                    
                    <div class="mb-3">
                        <label for="inputGeneratePasswordLength" class="form-label small fw-bold text-muted">
                            {$LANG.generatePassword.pwLength|default:"Password Length"}
                        </label>
                        <input type="number" min="8" max="64" value="16" class="form-control form-control-lg" id="inputGeneratePasswordLength" style="border-radius: 10px; font-weight: 600;">
                    </div>

                    <div class="mb-3">
                        <label for="inputGeneratePasswordOutput" class="form-label small fw-bold text-muted">
                            {$LANG.generatePassword.generatedPw|default:"Generated Password"}
                        </label>
                        <div class="input-group">
                            <input type="text" class="form-control form-control-lg font-monospace" id="inputGeneratePasswordOutput" readonly style="border-radius: 10px 0 0 10px; font-weight: 700; color: var(--brand-primary, #E05052);">
                            <button type="submit" class="btn btn-outline-secondary px-3" type="button" style="border-radius: 0 10px 10px 0; font-weight: 600;">
                                <i class="ti ti-refresh me-1"></i> {$LANG.generatePassword.generateNew|default:"Regenerate"}
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top bg-light py-3 px-4 d-flex justify-content-between" style="background: var(--bg-elevated, #fafafa) !important;">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3 fw-semibold" data-bs-dismiss="modal" style="border-radius: 8px;">
                    {$LANG.close|default:"Close"}
                </button>
                <button type="button" class="btn btn-brand-clean btn-sm px-4 fw-bold" id="btnGeneratePasswordInsert" data-clipboard-target="#inputGeneratePasswordOutput">
                    <i class="ti ti-copy me-1"></i> {$LANG.generatePassword.copyAndInsert|default:"Copy & Insert"}
                </button>
            </div>
        </div>
    </div>
</div>
