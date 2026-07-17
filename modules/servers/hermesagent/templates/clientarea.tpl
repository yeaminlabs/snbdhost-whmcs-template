<!-- Google Fonts Integration -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Fira+Code:wght@400;500;600&display=swap" rel="stylesheet">
<!-- Chart.js Integration -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    /* Aggressively hide default WHMCS theme elements that clutter the page */
    div[id="cPanelConnect"], 
    .cpanel-feature,
    .panel-cpanel {
        display: none !important;
    }
    
    .hermes-wrapper {
        font-family: 'Outfit', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        color: #111827;
        margin: 20px 0;
    }

    .hermes-wrapper .card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04);
        background: #ffffff;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        overflow: hidden;
    }

    .hermes-wrapper .card:hover {
        transform: translateY(-2px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.06);
    }

    .hermes-wrapper .card-header {
        background: transparent;
        border-bottom: 1px solid rgba(0,0,0,0.05);
        padding: 20px 24px;
        font-weight: 600;
        font-size: 16px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .hermes-header-card {
        position: relative;
        padding: 30px;
        border-radius: 16px;
        background: linear-gradient(135deg, #ffffff 0%, #f9fafb 100%);
        border: 1px solid rgba(0,0,0,0.05);
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
        margin-bottom: 24px;
        overflow: hidden;
    }

    .hermes-header-card::before {
        content: '';
        position: absolute;
        top: 0; left: 0; right: 0; height: 4px;
        background: linear-gradient(90deg, #CC0000, #ff4d4d);
    }

    .hermes-logo-wrapper {
        width: 56px;
        height: 56px;
        background: white;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        border: 1px solid rgba(0,0,0,0.05);
        padding: 8px;
    }

    .hermes-logo-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .hermes-title {
        font-size: 26px;
        font-weight: 700;
        margin: 0;
        color: #111827;
        letter-spacing: -0.5px;
    }

    .hermes-subtitle {
        font-size: 14px;
        color: #6b7280;
        margin: 4px 0 0 0;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        border-radius: 9999px;
        font-size: 13px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }

    .status-active {
        background-color: #111827;
        color: #ffffff;
    }
    
    .status-active .status-dot {
        color: #10b981;
    }

    .status-pending {
        background-color: #f3f4f6;
        color: #4b5563;
    }

    .status-suspended {
        background-color: #fef2f2;
        border: 1px solid #fecaca;
        color: #ef4444;
    }

    .status-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background-color: currentColor;
        display: inline-block;
        animation: pulse 2s infinite;
        box-shadow: 0 0 8px currentColor;
    }

    @keyframes pulse {
        0% { transform: scale(0.95); opacity: 0.5; }
        50% { transform: scale(1.2); opacity: 1; }
        100% { transform: scale(0.95); opacity: 0.5; }
    }

    .glass-card-green {
        background: rgba(220, 252, 231, 0.6);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(134, 239, 172, 0.5);
        border-radius: 16px;
        padding: 24px;
        margin-bottom: 24px;
        position: relative;
        overflow: hidden;
    }

    .glass-card-green::after {
        content: '';
        position: absolute;
        top: -50%; right: -10%;
        width: 150px; height: 150px;
        background: radial-gradient(circle, rgba(34,197,94,0.1) 0%, rgba(255,255,255,0) 70%);
        border-radius: 50%;
        z-index: 0;
    }

    .glass-card-green > * {
        position: relative;
        z-index: 1;
    }

    .progress-bar-animated-gradient {
        width: 100%;
        height: 12px;
        background: #e5e7eb;
        border-radius: 999px;
        overflow: hidden;
        position: relative;
    }

    .progress-bar-animated-gradient .fill {
        height: 100%;
        background: linear-gradient(90deg, #10b981, #34d399, #10b981);
        background-size: 200% 100%;
        border-radius: 999px;
        transition: width 1s cubic-bezier(0.4, 0, 0.2, 1);
        animation: gradientMove 3s linear infinite;
        box-shadow: 0 0 10px rgba(16, 185, 129, 0.4);
    }

    @keyframes gradientMove {
        0% { background-position: 100% 0; }
        100% { background-position: -100% 0; }
    }

    .code-val {
        font-family: 'Fira Code', 'Courier New', monospace;
        background: #f3f4f6;
        padding: 6px 12px;
        border-radius: 8px;
        border: 1px solid rgba(0,0,0,0.05);
        font-size: 13px;
        color: #1f2937;
        font-weight: 500;
    }
    
    .code-val.url-val {
        color: #CC0000;
        background: rgba(204, 0, 0, 0.05);
        border-color: rgba(204, 0, 0, 0.1);
    }

    .btn-icon-only {
        background: #f3f4f6;
        border: none;
        color: #6b7280;
        cursor: pointer;
        width: 32px;
        height: 32px;
        border-radius: 8px;
        transition: all 0.2s;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .btn-icon-only:hover {
        color: #111827;
        background: #e5e7eb;
        transform: translateY(-1px);
    }

    .hermes-btn-primary {
        background: linear-gradient(135deg, #CC0000 0%, #aa0000 100%);
        color: white;
        border: none;
        border-radius: 10px;
        padding: 10px 20px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        text-decoration: none;
        box-shadow: 0 4px 15px rgba(204, 0, 0, 0.3);
    }

    .hermes-btn-primary:hover {
        background: linear-gradient(135deg, #aa0000 0%, #880000 100%);
        color: white;
        text-decoration: none;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(204, 0, 0, 0.4);
    }

    .hermes-btn-dark {
        background: #111827;
        color: white;
        border: none;
        border-radius: 10px;
        padding: 10px 20px;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s ease;
        text-decoration: none;
        box-shadow: 0 4px 15px rgba(17, 24, 39, 0.2);
    }

    .hermes-btn-dark:hover {
        background: #000000;
        color: white;
        text-decoration: none;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(17, 24, 39, 0.3);
    }

    /* Neural Link EKG Animation */
    .neural-link-box {
        background: #0f172a;
        border-radius: 12px;
        padding: 20px;
        position: relative;
        overflow: hidden;
    }
    
    .ekg-line {
        stroke-dasharray: 300;
        stroke-dashoffset: 300;
        animation: drawEkg 2.5s linear infinite;
        filter: drop-shadow(0 0 6px rgba(204, 0, 0, 0.8));
    }
    
    @keyframes drawEkg {
        0% { stroke-dashoffset: 300; }
        30% { stroke-dashoffset: 0; }
        100% { stroke-dashoffset: -300; }
    }

    .metric-box {
        background: rgba(255,255,255,0.05);
        border: 1px solid rgba(255,255,255,0.1);
        border-radius: 8px;
        padding: 12px;
        text-align: center;
        color: white;
    }

    .metric-value {
        font-family: 'Fira Code', monospace;
        font-size: 16px;
        font-weight: 700;
        color: #f87171;
        display: block;
        margin-bottom: 2px;
    }

    .metric-label {
        font-size: 10px;
        color: #94a3b8;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* Custom Toast */
    .hermes-toast-container {
        position: fixed;
        bottom: 24px;
        right: 24px;
        z-index: 1055;
    }

    .step-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .step-item {
        display: flex;
        gap: 16px;
        margin-bottom: 20px;
        font-size: 14px;
        color: #4b5563;
        line-height: 1.6;
    }

    .step-item:last-child {
        margin-bottom: 0;
    }

    .step-number {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: rgba(204, 0, 0, 0.1);
        color: #CC0000;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 13px;
        flex-shrink: 0;
        border: 1px solid rgba(204, 0, 0, 0.2);
    }
</style>

<div class="hermes-wrapper container-fluid px-0">
    {if $deployment_status eq 'Suspended' or $deployment_status eq 'Terminated'}
    <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.8); backdrop-filter: blur(12px); z-index: 99; display: flex; align-items: center; justify-content: center; border-radius: 16px;">
        <div class="card shadow-lg border-danger" style="max-width: 500px; text-align: center; background: #fef2f2;">
            <div class="card-body p-5">
                <i class="fas fa-ban mb-3" style="font-size: 48px; color: #ef4444;"></i>
                <h3 class="fw-bold text-danger mb-3">Account {$deployment_status}</h3>
                <p class="text-danger opacity-75 mb-0">Your Agent account has been suspended or flagged. This typically happens due to a missed payment. Please check your invoices and clear the due dates before it gets terminated. Terminated or Suspended users will not be able to recover any agent data or API keys from their agent.</p>
            </div>
        </div>
    </div>
    {/if}

    <!-- Header Section -->
    <div class="hermes-header-card d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-4">
        <div class="d-flex align-items-center gap-3">
            <div class="hermes-logo-wrapper">
                <img src="https://raw.githubusercontent.com/lobehub/lobe-icons/refs/heads/master/packages/static-png/light/hermesagent.png" alt="Hermes Logo" />
            </div>
            <div>
                <h3 class="hermes-title">Hermes Cloud Agent</h3>
                <p class="hermes-subtitle">Managed dockerized deployment by SNBD Host</p>
            </div>
        </div>
        <div class="d-flex align-items-center gap-3">
            {if $deployment_status eq 'Active'}
                <span class="status-badge status-active">
                    <span class="status-dot"></span>
                    Running
                </span>
                <a href="clientarea.php?action=productdetails&id={$serviceid}&modop=custom&a=manage_llm" class="hermes-btn-primary">
                    <i class="fas fa-microchip"></i> Manage LLMs
                </a>
            {elseif $deployment_status eq 'Suspended'}
                <span class="status-badge status-suspended">
                    Suspended
                </span>
            {else}
                <span class="status-badge status-pending">
                    <span class="status-dot"></span>
                    {$deployment_status}
                </span>
            {/if}
        </div>
    </div>

    {if $error}
        <div class="alert alert-danger d-flex align-items-center gap-2 border-danger bg-danger bg-opacity-10 text-danger rounded-3" role="alert">
            <i class="fas fa-exclamation-triangle"></i> {$error}
        </div>
    {/if}

    <!-- Powered by Gemma -->
    <div class="glass-card-green d-flex align-items-start gap-4">
        <div class="display-5 text-success"><i class="fas fa-robot"></i></div>
        <div>
            <h4 class="fw-bold text-success mb-2 fs-5">Powered by Google Gemma</h4>
            <p class="text-success text-opacity-75 mb-0" style="font-size: 14.5px;">
                This agent is powered by <strong>Google Gemma</strong> technology. You are exclusively allowed to use the model <strong><code>bedrock_mantle/google.gemma-4-e2b</code></strong> for your agentic work. You are initially allowed to use up to <strong>10M tokens combined</strong>. Gemma 4 provides an immense capability for coding, problem-solving, and general reasoning. All you have to do is switch to the <strong><code>bedrock_mantle/google.gemma-4-e2b</code></strong> model in your settings and it will work instantly.
            </p>
        </div>
    </div>

    <!-- Free Gemma Quota -->
    <div class="card mb-4">
        <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0 fs-6 fw-bold text-dark d-flex align-items-center gap-2">
                    <i class="fas fa-chart-pie text-success"></i> Free Gemma Quota
                </h4>
                <span class="badge bg-warning text-dark rounded-pill px-3 py-2 fw-semibold">{$days_remaining} Access</span>
            </div>
            
            <div class="d-flex justify-content-between text-muted fw-semibold mb-2" style="font-size: 13px;">
                <span>Tokens Used: {$total_used|number_format}</span>
                <span>Limit: {$token_limit|number_format}</span>
            </div>
            <div class="progress-bar-animated-gradient">
                <div class="fill" style="width: {$percent_used}%;"></div>
            </div>
            <p class="mt-3 mb-0 text-muted" style="font-size: 12.5px;">
                Your free allowance counts input and output tokens combined. Watch this bar fill up as your agent processes tasks!
            </p>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- Gateway Dashboard Connection -->
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header border-0 pb-0 pt-4 px-4 bg-transparent">
                    <i class="fas fa-sliders-h text-dark opacity-75"></i> Gateway Dashboard Connection
                </div>
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center border-bottom py-3">
                        <span class="text-muted fw-semibold" style="font-size: 13.5px;">Web Dashboard URL</span>
                        <div class="d-flex align-items-center gap-2">
                            {if $dashboard_url}
                                <span class="code-val url-val">{$dashboard_url}</span>
                                <button class="btn-icon-only" onclick="copyToClipboard('{$dashboard_url}', 'Dashboard URL copied!')" title="Copy URL">
                                    <i class="far fa-copy"></i>
                                </button>
                            {else}
                                <span class="text-muted small">Not Available</span>
                            {/if}
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center border-bottom py-3">
                        <span class="text-muted fw-semibold" style="font-size: 13.5px;">Auth Username</span>
                        <div class="d-flex align-items-center gap-2">
                            <span class="code-val">{$username}</span>
                            <button class="btn-icon-only" onclick="copyToClipboard('{$username}', 'Username copied!')" title="Copy Username">
                                <i class="far fa-copy"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center border-bottom py-3">
                        <span class="text-muted fw-semibold" style="font-size: 13.5px;">Auth Password</span>
                        <div class="d-flex align-items-center gap-2">
                            <span class="code-val" id="dash-pass" style="-webkit-text-security: disc;">{$password}</span>
                            <button class="btn-icon-only" onclick="togglePasswordVisibility()" title="Toggle View" id="toggle-pass-btn">
                                <i class="far fa-eye"></i>
                            </button>
                            <button class="btn-icon-only" onclick="copyToClipboard('{$password}', 'Password copied!')" title="Copy Password">
                                <i class="far fa-copy"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center py-3">
                        <span class="text-muted fw-semibold" style="font-size: 13.5px;">Dashboard Port</span>
                        <div class="d-flex align-items-center gap-2">
                            <span class="code-val">{$dash_port}</span>
                        </div>
                    </div>

                    <div class="mt-4 text-end">
                        {if $dashboard_url}
                            <a href="{$dashboard_url}" target="_blank" class="hermes-btn-dark">
                                Open Dashboard <i class="fas fa-arrow-right ms-1"></i>
                            </a>
                        {/if}
                    </div>
                </div>
            </div>
        </div>

        <!-- Agent Neural Link -->
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header border-0 pb-0 pt-4 px-4 bg-transparent">
                    <i class="fas fa-heartbeat text-danger"></i> Agent Neural Link
                </div>
                <div class="card-body p-4">
                    {if $deployment_status eq 'Active'}
                        <div class="neural-link-box mb-4">
                            <div class="position-absolute top-0 end-0 p-3 d-flex align-items-center gap-2" style="font-size: 10px; color: #10b981; font-weight: 700; letter-spacing: 1px;">
                                <span class="status-dot" style="color: #10b981;"></span> SYNCHRONIZED
                            </div>
                            <p class="text-white opacity-50 mb-3" style="font-size: 11px; text-transform: uppercase; letter-spacing: 1px;">Container Link Stream</p>
                            
                            <svg width="100%" height="60" viewBox="0 0 300 60" preserveAspectRatio="none">
                                <pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">
                                    <path d="M 20 0 L 0 0 0 20" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="1"/>
                                </pattern>
                                <rect width="100%" height="100%" fill="url(#grid)" />
                                <path class="ekg-line" d="M 0 30 L 100 30 L 110 10 L 120 50 L 130 15 L 140 35 L 150 30 L 300 30" fill="none" stroke="#CC0000" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-4">
                                <div class="metric-box bg-dark">
                                    <span class="metric-value">{$serviceid}</span>
                                    <span class="metric-label">Container ID</span>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="metric-box bg-dark">
                                    <span class="metric-value text-success">LIVE</span>
                                    <span class="metric-label">Uptime</span>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="metric-box bg-dark">
                                    <span class="metric-value text-success">OK</span>
                                    <span class="metric-label">Memory</span>
                                </div>
                            </div>
                        </div>
                        
                        <p class="text-muted mb-0" style="font-size: 13px; line-height: 1.6;">
                            Your Hermes Agent is fully deployed and listening for remote connections. System resources are actively monitored.
                        </p>
                    {else}
                        <div class="h-100 d-flex flex-column align-items-center justify-content-center text-muted py-5">
                            <i class="fas fa-power-off mb-3" style="font-size: 40px; opacity: 0.3;"></i>
                            <p class="mb-0 fw-medium">Neural link offline. Agent is not currently active.</p>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>

    <!-- Analytics & Usage Dashboard -->
    {if $deployment_status eq 'Active'}
    <div class="card mb-4">
        <div class="card-header border-0 pb-0 pt-4 px-4 bg-transparent">
            <i class="fas fa-chart-line text-primary"></i> Analytics & Usage
        </div>
        <div class="card-body p-4">
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="bg-light rounded-4 p-4 border text-center h-100">
                        <div class="text-muted text-uppercase fw-bold mb-2" style="font-size: 11px; letter-spacing: 1px;">CPU Usage</div>
                        <div id="stat-cpu" class="display-6 fw-bold text-dark" style="font-family: 'Fira Code', monospace;">{$stat_cpu}</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="bg-light rounded-4 p-4 border text-center h-100">
                        <div class="text-muted text-uppercase fw-bold mb-2" style="font-size: 11px; letter-spacing: 1px;">Memory Usage</div>
                        <div id="stat-mem" class="display-6 fw-bold text-dark" style="font-family: 'Fira Code', monospace;">{$stat_mem}</div>
                    </div>
                </div>
            </div>

            <div class="position-relative" style="height: 300px; width: 100%;">
                <canvas id="tokenUsageChart"></canvas>
            </div>
            
            <div class="mt-4 p-3 bg-light rounded-3 text-center border">
                <div class="mb-2" style="font-size: 14px;">
                    <span class="text-muted fw-semibold me-2">Model Filtered:</span>
                    <code class="bg-success bg-opacity-10 text-success px-2 py-1 rounded fw-bold">bedrock_mantle/google.gemma-4-e2b</code>
                </div>
                <div style="font-size: 14px;">
                    <span class="text-muted fw-semibold">Input Tokens:</span> <span class="text-primary fw-bold">{$stat_prompt_tokens|number_format|default:0}</span> 
                    <span class="mx-2 text-muted">|</span> 
                    <span class="text-muted fw-semibold">Output Tokens:</span> <span class="text-success fw-bold">{$stat_completion_tokens|number_format|default:0}</span>
                </div>
            </div>
        </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('tokenUsageChart');
        if(!ctx) return;
        
        const promptTokens = {$stat_prompt_tokens|default:0};
        const completionTokens = {$stat_completion_tokens|default:0};
        
        const hasData = (promptTokens > 0 || completionTokens > 0);
        
        new Chart(ctx.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: hasData ? ['Prompt Tokens', 'Completion Tokens'] : ['No Data Yet'],
                datasets: [{
                    data: hasData ? [promptTokens, completionTokens] : [1],
                    backgroundColor: hasData ? ['#3b82f6', '#10b981'] : ['#e5e7eb'],
                    hoverBackgroundColor: hasData ? ['#2563eb', '#059669'] : ['#d1d5db'],
                    borderWidth: 0,
                    borderRadius: hasData ? 5 : 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            font: { family: "'Outfit', sans-serif", size: 13 },
                            padding: 20
                        }
                    },
                    title: {
                        display: true,
                        text: 'Recent Token Processing',
                        font: { family: "'Outfit', sans-serif", size: 16, weight: '700' },
                        color: '#111827',
                        padding: { bottom: 20 }
                    }
                },
                cutout: '75%',
                animation: {
                    animateScale: true,
                    animateRotate: true
                }
            }
        });
    });
    </script>
    {/if}

    <!-- Website Live Chat Widget -->
    <div class="card mb-4">
        <div class="card-header border-0 pb-0 pt-4 px-4 bg-transparent">
            <i class="fas fa-comment-dots text-info"></i> Website Live Chat Widget
        </div>
        <div class="card-body p-4">
            <p class="text-muted mb-4" style="font-size: 14px;">
                Copy and paste this HTML snippet into the <code class="bg-light px-1 rounded">&lt;body&gt;</code> of your website (WordPress, Shopify, etc.) to instantly add a floating AI customer support chat that connects directly to your Hermes Agent.
            </p>
            
            <div class="position-relative">
                <textarea id="hermesWidgetCode" readonly class="form-control font-monospace bg-dark text-light border-0 shadow-inner p-4 rounded-4" style="height: 250px; font-size: 13px; resize: vertical;" onclick="this.select();">
&lt;!-- Hermes Agent Live Chat Widget --&gt;
&lt;script&gt;
(function() {literal}{{/literal}
    const API_URL = "{$api_url}/v1/chat/completions";
    const API_KEY = "{$api_key}";
{literal}
    const style = document.createElement('style');
    style.innerHTML = `
        #hermes-chat-widget { position: fixed; bottom: 20px; right: 20px; z-index: 999999; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        #hermes-chat-button { width: 60px; height: 60px; border-radius: 50%; background: #3b82f6; box-shadow: 0 4px 12px rgba(0,0,0,0.15); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: transform 0.2s; border: none; outline: none; }
        #hermes-chat-button:hover { transform: scale(1.05); }
        #hermes-chat-button svg { fill: white; width: 28px; height: 28px; }
        #hermes-chat-window { display: none; width: 350px; height: 500px; background: white; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.15); flex-direction: column; overflow: hidden; margin-bottom: 15px; position: absolute; bottom: 70px; right: 0; }
        #hermes-chat-header { background: #3b82f6; color: white; padding: 15px 20px; font-weight: 600; font-size: 16px; display: flex; justify-content: space-between; align-items: center; }
        #hermes-chat-close { cursor: pointer; opacity: 0.8; }
        #hermes-chat-close:hover { opacity: 1; }
        #hermes-chat-messages { flex: 1; overflow-y: auto; padding: 15px; background: #f9fafb; display: flex; flex-direction: column; gap: 10px; }
        .hermes-msg { max-width: 80%; padding: 10px 14px; border-radius: 12px; font-size: 14px; line-height: 1.4; word-wrap: break-word; }
        .hermes-msg-user { background: #3b82f6; color: white; align-self: flex-end; border-bottom-right-radius: 2px; }
        .hermes-msg-bot { background: white; color: #111827; border: 1px solid #e5e7eb; align-self: flex-start; border-bottom-left-radius: 2px; }
        #hermes-chat-input-container { padding: 15px; background: white; border-top: 1px solid #e5e7eb; display: flex; gap: 10px; }
        #hermes-chat-input { flex: 1; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 8px; outline: none; font-size: 14px; }
        #hermes-chat-input:focus { border-color: #3b82f6; }
        #hermes-chat-send { background: #3b82f6; color: white; border: none; border-radius: 8px; padding: 0 15px; cursor: pointer; font-weight: 500; transition: background 0.2s; }
        #hermes-chat-send:hover { background: #2563eb; }
        #hermes-chat-send:disabled { background: #9ca3af; cursor: not-allowed; }
        #hermes-chat-footer { font-size: 10px; text-align: center; color: #9ca3af; padding: 0 0 10px 0; background: white; }
    `;
    document.head.appendChild(style);

    const container = document.createElement('div');
    container.id = 'hermes-chat-widget';
    container.innerHTML = `
        <div id="hermes-chat-window">
            <div id="hermes-chat-header">
                <div>Live Chat</div>
                <div id="hermes-chat-close">✕</div>
            </div>
            <div id="hermes-chat-messages">
                <div class="hermes-msg hermes-msg-bot">Hello! How can I help you today?</div>
            </div>
            <div id="hermes-chat-input-container">
                <input type="text" id="hermes-chat-input" placeholder="Type your message..." autocomplete="off">
                <button id="hermes-chat-send">Send</button>
            </div>
            <div id="hermes-chat-footer">Powered by SNBD HOST</div>
        </div>
        <button id="hermes-chat-button">
            <svg viewBox="0 0 24 24"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"></path></svg>
        </button>
    `;
    document.body.appendChild(container);

    const btn = document.getElementById('hermes-chat-button');
    const win = document.getElementById('hermes-chat-window');
    const closeBtn = document.getElementById('hermes-chat-close');
    const messages = document.getElementById('hermes-chat-messages');
    const input = document.getElementById('hermes-chat-input');
    const sendBtn = document.getElementById('hermes-chat-send');

    let history = [{ role: "system", content: "You are a helpful customer service assistant for this website. Be concise and polite." }];

    btn.addEventListener('click', () => { win.style.display = win.style.display === 'flex' ? 'none' : 'flex'; });
    closeBtn.addEventListener('click', () => { win.style.display = 'none'; });

    function addMsg(txt, isUser) {
        const d = document.createElement('div');
        d.className = 'hermes-msg ' + (isUser ? 'hermes-msg-user' : 'hermes-msg-bot');
        d.innerText = txt;
        messages.appendChild(d);
        messages.scrollTop = messages.scrollHeight;
    }

    async function sendMsg() {
        const txt = input.value.trim();
        if (!txt) return;
        input.value = '';
        input.disabled = sendBtn.disabled = true;
        addMsg(txt, true);
        history.push({ role: "user", content: txt });
        
        try {
            const res = await fetch(API_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + API_KEY },
                body: JSON.stringify({ model: "hermes-default", messages: history, temperature: 0.7 })
            });
            const data = await res.json();
            const reply = data.choices[0].message.content;
            addMsg(reply, false);
            history.push({ role: "assistant", content: reply });
        } catch (e) {
            addMsg("Sorry, I am having trouble connecting right now.", false);
        }
        input.disabled = sendBtn.disabled = false;
        input.focus();
    }

    sendBtn.addEventListener('click', sendMsg);
    input.addEventListener('keypress', (e) => { if (e.key === 'Enter') sendMsg(); });
{/literal}})();
&lt;/script&gt;
                </textarea>
                
                <button onclick="copyHermesWidgetCode(event)" class="btn btn-primary position-absolute top-0 end-0 m-3 d-flex align-items-center gap-2 shadow-sm rounded-3">
                    <i class="far fa-copy"></i> Copy Code
                </button>
            </div>
        </div>
    </div>
    
    <!-- Hermes Desktop Pairing Guide & Data Management -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="card h-100">
                <div class="card-header border-0 pb-0 pt-4 px-4 bg-transparent">
                    <i class="fas fa-desktop text-dark opacity-75"></i> Pair with Hermes Desktop App
                </div>
                <div class="card-body p-4">
                    <ul class="step-list">
                        <li class="step-item">
                            <span class="step-number">1</span>
                            <div>Download and install the <strong>Hermes Desktop</strong> application for your operating system from the official site (<a href="https://hermes-agent.nousresearch.com/" target="_blank" class="text-primary text-decoration-none fw-semibold">hermes-agent.nousresearch.com</a>).</div>
                        </li>
                        <li class="step-item">
                            <span class="step-number">2</span>
                            <div>Launch Hermes Desktop, navigate to the connection manager, and select <strong>Remote Gateway</strong> or <strong>Connect to Remote Server</strong>.</div>
                        </li>
                        <li class="step-item">
                            <span class="step-number">3</span>
                            <div>
                                Enter the connection settings provided in the card above:
                                <div class="mt-2 d-flex flex-wrap gap-2">
                                    <code class="bg-light border px-2 py-1 rounded text-dark">Host/URL: {$dashboard_url}</code>
                                    <code class="bg-light border px-2 py-1 rounded text-dark">Username: {$username}</code>
                                </div>
                            </div>
                        </li>
                        <li class="step-item">
                            <span class="step-number">4</span>
                            <div>Save the configurations. Your local Hermes Desktop app is now connected to this high-performance cloud container and will securely save agent states, memory, and custom skills directly on our host.</div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card h-100 border-success border-opacity-25 bg-success bg-opacity-10">
                <div class="card-body p-4 d-flex flex-column justify-content-center text-center">
                    <div class="display-5 text-success mb-3"><i class="fas fa-database"></i></div>
                    <h4 class="fw-bold text-success mb-3">Data Management</h4>
                    <p class="text-success text-opacity-75 mb-4" style="font-size: 14px;">
                        Download a complete snapshot of your agent's brain. This backup contains all long-term memories, chat history, custom skills, and environment configurations in a highly compressed `.tar.gz` format.
                    </p>
                    <a href="clientarea.php?action=productdetails&id={$serviceid}&modop=custom&a=downloadbackup" class="btn btn-success fw-bold rounded-pill px-4 py-2 mt-auto align-self-center shadow-sm">
                        <i class="fas fa-download me-2"></i> Download Agent Brain
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Danger Zone -->
    <div class="card border-danger border-opacity-50 bg-danger bg-opacity-10 mb-4">
        <div class="card-body p-4">
            <h4 class="fw-bold text-danger mb-3 d-flex align-items-center gap-2">
                <i class="fas fa-exclamation-triangle"></i> Danger Zone
            </h4>
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-4">
                <p class="text-danger text-opacity-75 mb-0" style="font-size: 14.5px;">
                    <strong>Warning:</strong> The Kill Switch will completely destroy your Hermes Agent and permanently wipe all its memory, skills, and configuration data. This action cannot be undone.
                </p>
                <a href="clientarea.php?action=productdetails&id={$serviceid}&modop=custom&a=killswitch" class="btn btn-danger fw-bold rounded-3 px-4 py-2 text-nowrap shadow-sm flex-shrink-0" onclick="return confirm('WARNING: Are you absolutely sure? All data will be lost forever and the agent will be terminated. Click OK to proceed.');">
                    <i class="fas fa-skull-crossbones me-2"></i> Execute Kill Switch
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Domain Management Card -->
<div class="row mb-4 hermes-section">
    <div class="col-12">
        <div class="card" style="border-radius:16px;border:none;box-shadow:0 10px 30px rgba(0,0,0,0.04);">
            <div class="card-header border-0 pb-0 pt-4 px-4 bg-transparent d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-globe" style="color:#CC0000"></i>
                    <span style="font-weight:600;font-size:16px">Domain Management</span>
                </div>
                <button class="hermes-btn-primary" style="font-size:13px;padding:7px 16px" onclick="haOpenModal()">
                    <i class="fas fa-plus"></i> Add Domain
                </button>
            </div>
            <div class="card-body px-4 pb-4 pt-3">
                <div id="ha-domain-list">
                {if $domains}
                    {foreach from=$domains item=d}
                    <div class="d-flex align-items-center gap-2 py-2" id="ha-row-{$d->id}" style="border-bottom:1px solid rgba(0,0,0,.05)">
                        <div style="flex:1;font-size:14px;font-weight:500;word-break:break-all">
                            {if $d->status === 'active'}
                                <a href="https://{$d->domain}" target="_blank" style="color:inherit;text-decoration:none">
                                    <i class="fas fa-external-link-alt" style="font-size:11px;color:#CC0000"></i> {$d->domain}
                                </a>
                            {else}
                                {$d->domain}
                            {/if}
                        </div>
                        {if $d->domain === $default_domain}
                            <span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#e8e8e8;color:#555">DEFAULT</span>
                        {/if}
                        {if $d->type === 'custom'}
                            <span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#cce5ff;color:#004085">CUSTOM</span>
                        {/if}
                        {if $d->status === 'active'}
                            <span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#d4edda;color:#155724">Active</span>
                        {else}
                            <span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#fff3cd;color:#856404">Pending DNS</span>
                            <button class="btn btn-sm" style="background:#fff3cd;color:#856404;border:1px solid #ffc107;font-size:12px;padding:3px 10px;border-radius:6px"
                                    onclick="haVerify({$d->id}, '{$d->domain}', this)">
                                Verify DNS
                            </button>
                        {/if}
                        {if $d->domain !== $default_domain}
                            <button class="btn btn-sm" style="background:#f8d7da;color:#721c24;border:none;font-size:12px;padding:3px 10px;border-radius:6px"
                                    onclick="haRemove({$d->id}, '{$d->domain}', this)">
                                Remove
                            </button>
                        {/if}
                    </div>
                    {/foreach}
                {else}
                    <p style="color:#999;font-size:13px;margin:0">No domains yet.</p>
                {/if}
                </div>
            </div>
        </div>
    </div>
</div>

<!-- DNS info box (shown after adding a pending custom domain) -->
<div id="ha-dns-info" style="display:none" class="row mb-4 hermes-section">
    <div class="col-12">
        <div class="card" style="border-radius:16px;border:1px solid #ffc107;background:#fffdf0;box-shadow:none;">
            <div class="card-body px-4 py-3">
                <div style="font-weight:600;font-size:14px;margin-bottom:8px;color:#856404">
                    <i class="fas fa-info-circle"></i> DNS Setup Required
                </div>
                <p style="font-size:13px;margin-bottom:10px;color:#555">
                    Add this A record to your domain's DNS, then click <strong>Verify DNS</strong> on the row above.
                </p>
                <div style="background:#f8f9fa;border:1px solid #dee2e6;border-radius:8px;padding:14px;font-family:monospace;font-size:13px">
                    <div class="d-flex gap-4 mb-1"><span style="color:#888;min-width:60px">Type</span><strong>A</strong></div>
                    <div class="d-flex gap-4 mb-1"><span style="color:#888;min-width:60px">Name</span><strong id="ha-dns-name">@</strong></div>
                    <div class="d-flex gap-4"><span style="color:#888;min-width:60px">Value</span><strong style="color:#CC0000">{$server_ip}</strong></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Domain Modal -->
<div id="ha-add-modal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:9999;align-items:center;justify-content:center">
    <div style="background:#fff;border-radius:16px;padding:28px;width:100%;max-width:460px;margin:16px;box-shadow:0 20px 60px rgba(0,0,0,.2)">
        <div style="font-size:16px;font-weight:700;margin-bottom:20px;color:#CC0000">
            <i class="fas fa-globe"></i> Add Domain
        </div>
        <div style="display:flex;gap:4px;margin-bottom:16px;border-bottom:2px solid #eee" id="ha-tabs">
            <button class="ha-tab active" onclick="haSwitchTab('hermes',this)"
                    style="padding:8px 16px;font-size:13px;font-weight:500;cursor:pointer;border:none;background:none;color:#CC0000;border-bottom:2px solid #CC0000;margin-bottom:-2px">
                Hermes Subdomain
            </button>
            <button class="ha-tab" onclick="haSwitchTab('custom',this)"
                    style="padding:8px 16px;font-size:13px;font-weight:500;cursor:pointer;border:none;background:none;color:#888;border-bottom:2px solid transparent;margin-bottom:-2px">
                Custom Domain
            </button>
        </div>
        <div id="ha-tab-hermes">
            <label style="font-size:12px;font-weight:600;display:block;margin-bottom:5px;color:#555">Subdomain</label>
            <div style="display:flex;align-items:center;border:1px solid #ddd;border-radius:6px;overflow:hidden">
                <input type="text" id="ha-hermes-sub" placeholder="myapp" autocomplete="off"
                       style="border:none;padding:8px 12px;font-size:14px;flex:1;outline:none;min-width:0">
                <span style="padding:8px 10px;background:#f5f5f5;font-size:13px;color:#666;white-space:nowrap;border-left:1px solid #ddd">.hermes.deltadns.xyz</span>
            </div>
            <div style="font-size:11px;color:#999;margin-top:5px">Instantly active — no DNS setup needed.</div>
        </div>
        <div id="ha-tab-custom" style="display:none">
            <label style="font-size:12px;font-weight:600;display:block;margin-bottom:5px;color:#555">Your Domain</label>
            <input type="text" class="form-control" id="ha-custom-domain" placeholder="app.yourdomain.com" autocomplete="off">
            <div style="font-size:12px;color:#666;margin-top:6px">After adding, you'll get the A record to set. Activates once DNS propagates.</div>
        </div>
        <div id="ha-modal-alert" style="display:none;padding:10px 14px;border-radius:6px;font-size:13px;margin-top:10px"></div>
        <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:20px">
            <button class="btn" style="border:1px solid #CC0000;color:#CC0000;border-radius:8px;padding:8px 18px;font-weight:500" onclick="haCloseModal()">Cancel</button>
            <button class="hermes-btn-primary" id="ha-add-btn" onclick="haAddDomain()">Add Domain</button>
        </div>
    </div>
</div>

<script>
(function() {
    var SID      = {$serviceid|intval};
    var AJAX_URL = 'modules/servers/hermesagent/ajax.php';
    var activeTab = 'hermes';

    window.haOpenModal = function() {
        var m = document.getElementById('ha-add-modal');
        m.style.display = 'flex';
        document.getElementById('ha-hermes-sub').value = '';
        document.getElementById('ha-custom-domain').value = '';
        haModalAlert('', '');
    };
    window.haCloseModal = function() {
        document.getElementById('ha-add-modal').style.display = 'none';
    };
    document.getElementById('ha-add-modal').addEventListener('click', function(e) {
        if (e.target === this) haCloseModal();
    });

    window.haSwitchTab = function(tab, el) {
        activeTab = tab;
        document.querySelectorAll('.ha-tab').forEach(function(t) {
            t.style.color = '#888';
            t.style.borderBottomColor = 'transparent';
        });
        el.style.color = '#CC0000';
        el.style.borderBottomColor = '#CC0000';
        document.getElementById('ha-tab-hermes').style.display = tab === 'hermes' ? '' : 'none';
        document.getElementById('ha-tab-custom').style.display  = tab === 'custom'  ? '' : 'none';
        haModalAlert('', '');
    };

    function haModalAlert(type, msg) {
        var el = document.getElementById('ha-modal-alert');
        el.style.display = msg ? 'block' : 'none';
        el.style.background = type === 'error' ? '#f8d7da' : '#d4edda';
        el.style.color = type === 'error' ? '#721c24' : '#155724';
        el.textContent = msg;
    }

    window.haAddDomain = function() {
        var btn = document.getElementById('ha-add-btn');
        var domain = '';
        if (activeTab === 'hermes') {
            var sub = document.getElementById('ha-hermes-sub').value.trim().toLowerCase();
            if (!sub) { haModalAlert('error', 'Enter a subdomain name.'); return; }
            if (!/^[a-z0-9][a-z0-9\-]*$/.test(sub)) { haModalAlert('error', 'Only lowercase letters, numbers, and hyphens.'); return; }
            domain = sub + '.hermes.deltadns.xyz';
        } else {
            domain = document.getElementById('ha-custom-domain').value.trim().toLowerCase();
            if (!domain) { haModalAlert('error', 'Enter a domain name.'); return; }
        }
        btn.disabled = true; btn.textContent = 'Adding…';
        haPost({ action: 'add_domain', serviceId: SID, domain: domain, type: activeTab })
        .then(function(d) {
            if (!d.success) { haModalAlert('error', d.error || 'Failed'); btn.disabled = false; btn.innerHTML = '<i class="fas fa-plus"></i> Add Domain'; return; }
            haCloseModal();
            if (d.status === 'active') {
                haAppendRow(0, d.domain, 'active', activeTab === 'custom' ? 'custom' : 'hermes');
            } else {
                haAppendRow(0, d.domain, 'pending', 'custom');
                document.getElementById('ha-dns-name').textContent = d.domain;
                document.getElementById('ha-dns-info').style.display = '';
            }
            btn.disabled = false; btn.innerHTML = '<i class="fas fa-plus"></i> Add Domain';
        })
        .catch(function() { haModalAlert('error', 'Request failed.'); btn.disabled = false; btn.innerHTML = '<i class="fas fa-plus"></i> Add Domain'; });
    };

    window.haVerify = function(id, domain, btn) {
        btn.disabled = true; btn.textContent = 'Checking…';
        haPost({ action: 'verify_domain', serviceId: SID, domain: domain })
        .then(function(d) {
            if (!d.success) { alert('DNS check: ' + (d.error || 'Failed')); btn.disabled = false; btn.textContent = 'Verify DNS'; return; }
            var row = document.getElementById('ha-row-' + id);
            if (row) {
                var badge = row.querySelector('[style*="fff3cd"]');
                if (badge) { badge.style.background = '#d4edda'; badge.style.color = '#155724'; badge.textContent = 'Active'; }
                var nameEl = row.querySelector('div:first-child');
                if (nameEl) nameEl.innerHTML = '<a href="https://' + domain + '" target="_blank" style="color:inherit;text-decoration:none"><i class="fas fa-external-link-alt" style="font-size:11px;color:#CC0000"></i> ' + domain + '</a>';
                btn.remove();
            }
            document.getElementById('ha-dns-info').style.display = 'none';
        })
        .catch(function() { alert('Request failed.'); btn.disabled = false; btn.textContent = 'Verify DNS'; });
    };

    window.haRemove = function(id, domain, btn) {
        if (!confirm('Remove ' + domain + '?\n\nCaddy config will be deleted and the domain will stop working immediately.')) return;
        btn.disabled = true;
        haPost({ action: 'remove_domain', serviceId: SID, domain_id: id })
        .then(function(d) {
            if (!d.success) { alert('Error: ' + (d.error || 'Unknown')); btn.disabled = false; return; }
            var row = document.getElementById('ha-row-' + id);
            if (row) row.remove();
        })
        .catch(function() { alert('Request failed.'); btn.disabled = false; });
    };

    function haAppendRow(id, domain, status, type) {
        var list = document.getElementById('ha-domain-list');
        var noMsg = list.querySelector('p');
        if (noMsg) noMsg.remove();
        var row = document.createElement('div');
        row.className = 'd-flex align-items-center gap-2 py-2';
        row.id = 'ha-row-' + id;
        row.style.borderBottom = '1px solid rgba(0,0,0,.05)';
        var nameHtml = status === 'active'
            ? '<a href="https://' + domain + '" target="_blank" style="color:inherit;text-decoration:none"><i class="fas fa-external-link-alt" style="font-size:11px;color:#CC0000"></i> ' + domain + '</a>'
            : domain;
        var typeBadge = type === 'custom' ? '<span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#cce5ff;color:#004085">CUSTOM</span>' : '';
        var statusBadge = status === 'active'
            ? '<span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#d4edda;color:#155724">Active</span>'
            : '<span style="font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px;background:#fff3cd;color:#856404">Pending DNS</span>';
        var verifyBtn = status !== 'active'
            ? '<button class="btn btn-sm" style="background:#fff3cd;color:#856404;border:1px solid #ffc107;font-size:12px;padding:3px 10px;border-radius:6px" onclick="haVerify(' + id + ',\'' + domain + '\',this)">Verify DNS</button>'
            : '';
        var removeBtn = '<button class="btn btn-sm" style="background:#f8d7da;color:#721c24;border:none;font-size:12px;padding:3px 10px;border-radius:6px" onclick="haRemove(' + id + ',\'' + domain + '\',this)">Remove</button>';
        row.innerHTML = '<div style="flex:1;font-size:14px;font-weight:500;word-break:break-all">' + nameHtml + '</div>' + typeBadge + statusBadge + verifyBtn + removeBtn;
        list.appendChild(row);
    }

    function haPost(data) {
        var fd = new FormData();
        Object.keys(data).forEach(function(k) { fd.append(k, data[k]); });
        return fetch(AJAX_URL, { method: 'POST', body: fd }).then(function(r) { return r.json(); });
    }
})();
</script>

<!-- Bootstrap 5 Toast Container for Clipboard Notifications -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1080;">
    <div id="hermesToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold" id="hermesToastMsg">
                Copied to clipboard!
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<script>
    function copyToClipboard(text, message) {
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(text).then(() => { showToast(message); });
        } else {
            var dummy = document.createElement("textarea");
            document.body.appendChild(dummy);
            dummy.value = text;
            dummy.select();
            document.execCommand("copy");
            document.body.removeChild(dummy);
            showToast(message);
        }
    }

    function showToast(message) {
        var toastEl = document.getElementById('hermesToast');
        var toastMsg = document.getElementById('hermesToastMsg');
        if(toastEl && toastMsg) {
            toastMsg.innerText = message;
            // Check if bootstrap is available (WHMCS 9.0 native)
            if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
                var toast = new bootstrap.Toast(toastEl, { delay: 2500 });
                toast.show();
            } else {
                // Fallback if bootstrap JS isn't loaded for some reason
                toastEl.classList.add('show');
                setTimeout(() => toastEl.classList.remove('show'), 2500);
            }
        }
    }

    function togglePasswordVisibility() {
        var passField = document.getElementById("dash-pass");
        var btn = document.getElementById("toggle-pass-btn");
        if (passField.style.webkitTextSecurity === "disc" || passField.style.webkitTextSecurity === "") {
            passField.style.webkitTextSecurity = "none";
            btn.innerHTML = '<i class="far fa-eye-slash"></i>';
        } else {
            passField.style.webkitTextSecurity = "disc";
            btn.innerHTML = '<i class="far fa-eye"></i>';
        }
    }

    function copyHermesWidgetCode(event) {
        var copyText = document.getElementById("hermesWidgetCode");
        copyText.select();
        copyText.setSelectionRange(0, 99999);
        
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(copyText.value).then(handleWidgetCopySuccess);
        } else {
            document.execCommand("copy");
            handleWidgetCopySuccess();
        }
        
        function handleWidgetCopySuccess() {
            const btn = event.currentTarget;
            const originalHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
            btn.classList.remove('btn-primary');
            btn.classList.add('btn-success');
            setTimeout(function() {
                btn.innerHTML = originalHtml;
                btn.classList.remove('btn-success');
                btn.classList.add('btn-primary');
            }, 2000);
        }
    }

    // Modern SaaS Overhaul: Remove WHMCS Default Clutter more safely
    document.addEventListener("DOMContentLoaded", function() {
        const hermesWrapper = document.querySelector('.hermes-wrapper');
        
        // Find the main container tab content
        const tabContent = hermesWrapper?.closest('.tab-pane') || 
                           hermesWrapper?.closest('.product-details') || 
                           document.querySelector('#Primary_Sidebar')?.parentElement ||
                           document.querySelector('.client-area-content');
        
        if (hermesWrapper && tabContent) {
            // Move to top
            tabContent.insertBefore(hermesWrapper, tabContent.firstChild);
        }

        // Hide default panels securely
        requestAnimationFrame(() => {
            const elementsToHide = document.querySelectorAll('.card, .panel, .mb-4, .row');
            elementsToHide.forEach(el => {
                if (el.classList.contains('hermes-wrapper') || el.closest('.hermes-wrapper')) return;
                
                const text = el.innerText.toLowerCase();
                if (
                    text.includes('cpanel') || 
                    text.includes('service overview') || 
                    text.includes('additional information') ||
                    text.includes('registration date')
                ) {
                    el.style.display = 'none';
                    el.style.opacity = '0';
                }
            });
            
            document.querySelectorAll('img[src*="cpanel"]').forEach(img => {
                const wrapper = img.closest('.card') || img.closest('.panel') || img.closest('.row');
                if (wrapper && !wrapper.closest('.hermes-wrapper')) {
                    wrapper.style.display = 'none';
                }
            });
        });
    });
</script>
