<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
    .onb-wrapper {
        font-family: 'Outfit', sans-serif;
        max-width: 800px;
        margin: 40px auto;
        color: #333;
    }
    .onb-card {
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        padding: 40px;
        border: 1px solid #eee;
    }
    .onb-header {
        text-align: center;
        margin-bottom: 40px;
    }
    .onb-title {
        font-size: 28px;
        font-weight: 700;
        color: #2b3e50;
        margin: 0 0 10px 0;
    }
    .onb-subtitle {
        font-size: 16px;
        color: #666;
        margin: 0;
    }
    .onb-step {
        display: none;
    }
    .onb-step.active {
        display: block;
        animation: fadeIn 0.4s ease;
    }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .onb-input-group {
        margin-bottom: 25px;
    }
    .onb-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 8px;
        color: #2b3e50;
    }
    .onb-input {
        width: 100%;
        padding: 15px;
        font-size: 16px;
        border: 2px solid #e3e6f0;
        border-radius: 8px;
        transition: border-color 0.2s;
        font-family: 'Outfit', sans-serif;
    }
    .onb-input:focus {
        outline: none;
        border-color: #4e73df;
    }
    
    .onb-chips {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        margin-top: 10px;
    }
    .onb-chip {
        background: #f8f9fc;
        border: 1px solid #e3e6f0;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.2s;
        color: #555;
    }
    .onb-chip:hover {
        background: #eaecf4;
        color: #333;
    }
    
    .onb-cards {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
        margin-bottom: 20px;
    }
    @media (max-width: 600px) {
        .onb-cards { grid-template-columns: 1fr; }
    }
    .onb-opt-card {
        border: 2px solid #e3e6f0;
        border-radius: 12px;
        padding: 20px;
        cursor: pointer;
        transition: all 0.2s;
    }
    .onb-opt-card:hover {
        border-color: #b7c9f7;
        background: #f8f9fc;
    }
    .onb-opt-card.selected {
        border-color: #4e73df;
        background: #f0f4ff;
    }
    .onb-opt-icon {
        font-size: 24px;
        color: #4e73df;
        margin-bottom: 10px;
    }
    .onb-opt-title {
        font-weight: 700;
        font-size: 16px;
        margin: 0 0 5px 0;
        color: #2b3e50;
    }
    .onb-opt-desc {
        font-size: 13px;
        color: #666;
        margin: 0;
        line-height: 1.4;
    }

    .onb-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 40px;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
    .onb-btn {
        padding: 12px 24px;
        font-size: 15px;
        font-weight: 600;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
        font-family: 'Outfit', sans-serif;
        border: none;
    }
    .onb-btn-primary {
        background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
        color: #fff;
    }
    .onb-btn-primary:hover {
        opacity: 0.9;
        color: #fff;
    }
    .onb-btn-secondary {
        background: #f8f9fc;
        color: #555;
        border: 1px solid #e3e6f0;
    }
    .onb-btn-secondary:hover {
        background: #eaecf4;
    }
    .onb-btn-skip {
        background: transparent;
        color: #888;
        font-weight: 400;
        text-decoration: underline;
        font-size: 14px;
    }
    .onb-btn-skip:hover {
        color: #555;
    }

    /* Launching Loader */
    .onb-loader-container {
        text-align: center;
        padding: 40px 0;
    }
    .onb-spinner {
        width: 60px;
        height: 60px;
        border: 5px solid #f3f3f3;
        border-top: 5px solid #4e73df;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px auto;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    .onb-progress-text {
        font-size: 16px;
        font-weight: 600;
        color: #4e73df;
        margin-bottom: 10px;
    }
    .onb-progress-desc {
        font-size: 14px;
        color: #666;
    }
</style>

<div class="onb-wrapper">
    <div class="onb-card">
        
        {if $status eq 'pending'}
        
        <!-- Wizard Form -->
        <div id="onb-wizard">
            <div class="onb-header">
                <h2 class="onb-title">Welcome to your new Hermes Agent!</h2>
                <p class="onb-subtitle">Let's personalize your agent before we launch the container.</p>
            </div>
            
            <!-- Step 1: Name -->
            <div class="onb-step active" id="step-1">
                <h3 style="font-size:20px; font-weight:700; margin-bottom: 20px;"><i class="fas fa-id-badge" style="color:#4e73df; margin-right:8px;"></i> Give your agent a name</h3>
                <div class="onb-input-group">
                    <label class="onb-label">Agent Name</label>
                    <input type="text" id="agent_name" class="onb-input" placeholder="e.g. Jarvis, SupportBot, Alpha">
                    <div class="onb-chips">
                        <span class="onb-chip" onclick="setInputValue('agent_name', 'Hermes')">Hermes</span>
                        <span class="onb-chip" onclick="setInputValue('agent_name', 'Jarvis')">Jarvis</span>
                        <span class="onb-chip" onclick="setInputValue('agent_name', 'Friday')">Friday</span>
                        <span class="onb-chip" onclick="setInputValue('agent_name', 'SupportBot')">SupportBot</span>
                    </div>
                </div>
                <div class="onb-footer">
                    <button class="onb-btn onb-btn-skip" onclick="submitOnboarding(true)">Skip setup</button>
                    <button class="onb-btn onb-btn-primary" onclick="nextStep(2)">Next Step <i class="fas fa-arrow-right"></i></button>
                </div>
            </div>

            <!-- Step 2: Use Case -->
            <div class="onb-step" id="step-2">
                <h3 style="font-size:20px; font-weight:700; margin-bottom: 20px;"><i class="fas fa-briefcase" style="color:#4e73df; margin-right:8px;"></i> What's the primary role?</h3>
                <input type="hidden" id="use_case" value="general">
                
                <div class="onb-cards">
                    <div class="onb-opt-card selected" onclick="selectCard('use_case', 'general', this)">
                        <div class="onb-opt-icon"><i class="fas fa-robot"></i></div>
                        <h4 class="onb-opt-title">General Assistant</h4>
                        <p class="onb-opt-desc">Versatile and helpful across a variety of daily tasks.</p>
                    </div>
                    <div class="onb-opt-card" onclick="selectCard('use_case', 'coding', this)">
                        <div class="onb-opt-icon"><i class="fas fa-code"></i></div>
                        <h4 class="onb-opt-title">Coding Assistant</h4>
                        <p class="onb-opt-desc">Expert at writing clean, maintainable, and bug-free code.</p>
                    </div>
                    <div class="onb-opt-card" onclick="selectCard('use_case', 'support', this)">
                        <div class="onb-opt-icon"><i class="fas fa-headset"></i></div>
                        <h4 class="onb-opt-title">Customer Support</h4>
                        <p class="onb-opt-desc">Patient, clear, and effective at resolving issues.</p>
                    </div>
                    <div class="onb-opt-card" onclick="selectCard('use_case', 'content', this)">
                        <div class="onb-opt-icon"><i class="fas fa-pen-nib"></i></div>
                        <h4 class="onb-opt-title">Content Creator</h4>
                        <p class="onb-opt-desc">Creative and engaging content writing for your audience.</p>
                    </div>
                </div>

                <div class="onb-footer">
                    <button class="onb-btn onb-btn-secondary" onclick="nextStep(1)"><i class="fas fa-arrow-left"></i> Back</button>
                    <button class="onb-btn onb-btn-primary" onclick="nextStep(3)">Next Step <i class="fas fa-arrow-right"></i></button>
                </div>
            </div>

            <!-- Step 3: Personality -->
            <div class="onb-step" id="step-3">
                <h3 style="font-size:20px; font-weight:700; margin-bottom: 20px;"><i class="fas fa-comment-dots" style="color:#4e73df; margin-right:8px;"></i> Define personality & rules</h3>
                
                <div class="onb-input-group">
                    <label class="onb-label">Agent Tone</label>
                    <input type="hidden" id="tone" value="helpful">
                    <div class="onb-cards" style="grid-template-columns: 1fr 1fr 1fr;">
                        <div class="onb-opt-card selected" style="padding:15px; text-align:center;" onclick="selectCard('tone', 'helpful', this, '.tone-card')">
                            <h4 class="onb-opt-title" style="font-size:14px;">Helpful & Friendly</h4>
                        </div>
                        <div class="onb-opt-card tone-card" style="padding:15px; text-align:center;" onclick="selectCard('tone', 'professional', this, '.tone-card')">
                            <h4 class="onb-opt-title" style="font-size:14px;">Professional</h4>
                        </div>
                        <div class="onb-opt-card tone-card" style="padding:15px; text-align:center;" onclick="selectCard('tone', 'concise', this, '.tone-card')">
                            <h4 class="onb-opt-title" style="font-size:14px;">Direct & Concise</h4>
                        </div>
                    </div>
                </div>
                
                <div class="onb-input-group">
                    <label class="onb-label">Custom Instructions (Optional)</label>
                    <textarea id="custom_instructions" class="onb-input" rows="4" placeholder="Any specific rules or knowledge your agent should always remember?"></textarea>
                </div>

                <div class="onb-footer">
                    <button class="onb-btn onb-btn-secondary" onclick="nextStep(2)"><i class="fas fa-arrow-left"></i> Back</button>
                    <button class="onb-btn onb-btn-primary" id="btn-submit" onclick="submitOnboarding(false)"><i class="fas fa-rocket"></i> Launch Agent</button>
                </div>
            </div>
        </div>
        
        {/if}

        <!-- Launching Screen (Hidden by default, shown when submitting or if status is completed but not yet Active) -->
        <div id="onb-launching" style="{if $status eq 'completed' or $status eq 'skipped'}display:block;{else}display:none;{/if}">
            <div class="onb-header">
                <h2 class="onb-title">Launching your Agent</h2>
                <p class="onb-subtitle">We are spinning up your isolated container environment.</p>
            </div>
            
            <div class="onb-loader-container">
                <div class="onb-spinner"></div>
                <div class="onb-progress-text" id="progress-text">Provisioning server...</div>
                <div class="onb-progress-desc">This usually takes about 30 to 60 seconds.</div>
            </div>
        </div>

    </div>
</div>

<script>
    const serviceId = {$serviceid};
    
    function setInputValue(id, val) {
        document.getElementById(id).value = val;
    }
    
    function selectCard(inputId, val, elem, selector = '.onb-opt-card') {
        document.getElementById(inputId).value = val;
        let siblings = elem.parentElement.querySelectorAll(selector);
        siblings.forEach(el => el.classList.remove('selected'));
        elem.classList.add('selected');
    }
    
    function nextStep(step) {
        document.querySelectorAll('.onb-step').forEach(el => el.classList.remove('active'));
        document.getElementById('step-' + step).classList.add('active');
    }
    
    function submitOnboarding(skip = false) {
        if(document.getElementById('onb-wizard')) {
            document.getElementById('onb-wizard').style.display = 'none';
        }
        document.getElementById('onb-launching').style.display = 'block';
        
        const data = new FormData();
        data.append('serviceId', serviceId);
        data.append('action', 'save_onboarding');
        
        if (skip) {
            data.append('skip', '1');
        } else {
            data.append('agent_name', document.getElementById('agent_name').value);
            data.append('use_case', document.getElementById('use_case').value);
            data.append('tone', document.getElementById('tone').value);
            data.append('custom_instructions', document.getElementById('custom_instructions').value);
        }
        
        fetch('modules/servers/hermesagent/ajax.php', {
            method: 'POST',
            body: data
        })
        .then(async res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            const text = await res.text();
            try {
                return JSON.parse(text);
            } catch (e) {
                console.error("Raw response:", text);
                throw new Error("Invalid server response: " + text.substring(0, 50));
            }
        })
        .then(res => {
            if (res.success) {
                // start polling
                document.getElementById('progress-text').innerText = 'Starting services...';
                pollProvisionStatus();
            } else {
                alert('Error: ' + res.error);
                location.reload();
            }
        })
        .catch(err => {
            alert('Network error: ' + err.message);
            console.error(err);
        });
    }
    
    function pollProvisionStatus() {
        const data = new FormData();
        data.append('serviceId', serviceId);
        data.append('action', 'provision_status');
        
        setInterval(() => {
            fetch('modules/servers/hermesagent/ajax.php', {
                method: 'POST',
                body: data
            })
            .then(res => res.json())
            .then(res => {
                if (res.success && res.provisioned) {
                    document.getElementById('progress-text').innerText = 'Ready!';
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
                }
            });
        }, 3000);
    }
    
    {if $status eq 'completed' or $status eq 'skipped'}
    // Auto-poll if we load the page and it's already completed (provisioning in background)
    pollProvisionStatus();
    {/if}
    
    // Hide default WHMCS product panels while onboarding is active
    document.addEventListener("DOMContentLoaded", function() {
        setTimeout(function() {
            const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6, .card-header, .panel-heading, .title');
            headings.forEach(function(h) {
                const text = h.textContent.trim();
                if (text === 'Service Overview' || text.includes('Control Panel Access') || text === 'Additional Information' || text === 'Billing Cycle') {
                    const container = h.closest('.card, .panel, .lagom-panel, .section, .row');
                    if (container) container.style.display = 'none';
                }
            });
            // Also hide any stray cPanel login buttons or sections
            document.querySelectorAll('a[href*="dologin.php"]').forEach(function(el) {
                const container = el.closest('.card, .panel, .row');
                if (container) container.style.display = 'none';
            });
        }, 50); // slight delay to ensure DOM is fully parsed
    });
</script>
