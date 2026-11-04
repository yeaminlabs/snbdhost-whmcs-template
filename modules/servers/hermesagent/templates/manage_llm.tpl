<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
    .hermes-container {
        font-family: 'Outfit', sans-serif;
        background: #ffffff;
        border-radius: 12px;
        padding: 35px;
        color: #111827;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        margin: 20px 0;
        position: relative;
        border: 1px solid #e5e7eb;
    }
    .hermes-container::before {
        content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
        background: #CC0000;
        border-top-left-radius: 12px;
        border-top-right-radius: 12px;
    }
    .snbd-title {
        font-size: 24px; font-weight: 700; margin: 0 0 5px 0;
        color: #111827; display: flex; align-items: center; gap: 10px;
    }
    .snbd-title i { color: #111827; }
    .snbd-subtitle { font-size: 14px; color: #6b7280; margin-bottom: 25px; }
    
    .form-group { margin-bottom: 20px; }
    .form-label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #4b5563; }
    .form-control-custom {
        width: 100%; padding: 12px 15px; border-radius: 8px;
        background: #ffffff; border: 1px solid #d1d5db;
        color: #111827; font-family: 'Fira Code', 'Courier New', monospace; font-size: 14px; transition: all 0.2s;
        box-sizing: border-box;
    }
    .form-control-custom:focus {
        outline: none; border-color: #CC0000; box-shadow: 0 0 0 3px rgba(204, 0, 0, 0.15);
    }
    .btn-submit {
        background: #CC0000; color: white;
        border: none; padding: 12px 24px; border-radius: 8px; font-weight: 600; cursor: pointer;
        font-size: 15px; transition: all 0.2s;
        display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-submit:hover { background: #aa0000; color: white; text-decoration: none; }
    .btn-back {
        background: #ffffff; color: #4b5563; border: 1px solid #d1d5db;
        padding: 12px 24px; border-radius: 8px; font-weight: 600; cursor: pointer;
        text-decoration: none; display: inline-flex; align-items: center; gap: 8px; transition: all 0.2s;
    }
    .btn-back:hover { background: #f3f4f6; color: #111827; text-decoration: none; }
    .btn-container { display: flex; gap: 15px; margin-top: 30px; }
    .alert-success-custom { background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
    .alert-error-custom { background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
    .card-section { background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 12px; padding: 25px; margin-bottom: 20px; }
    .section-title { font-size: 16px; font-weight: 700; color: #111827; margin-top: 0; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; border-bottom: 1px solid #e5e7eb; padding-bottom: 10px; }
</style>

<div class="hermes-container">
    {if $deployment_status eq 'Suspended' or $deployment_status eq 'Terminated'}
    <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.7); backdrop-filter: blur(8px); z-index: 99; display: flex; align-items: center; justify-content: center; border-radius: 12px; border: 1px solid rgba(239, 68, 68, 0.3);">
        <div style="background: #fef2f2; padding: 30px; border-radius: 12px; border: 2px solid #ef4444; max-width: 85%; text-align: center; box-shadow: 0 10px 25px rgba(239, 68, 68, 0.2);">
            <i class="fas fa-ban" style="font-size: 40px; color: #ef4444; margin-bottom: 15px;"></i>
            <h3 style="margin: 0 0 10px 0; color: #991b1b; font-size: 20px;">Account {$deployment_status}</h3>
            <p style="color: #7f1d1d; margin: 0; font-size: 14px; line-height: 1.5;">Your Agent account has been suspended or flagged. This typically happens due to a missed payment. Please check your invoices and clear the due dates before it gets terminated. Terminated or Suspended users will not be able to recover any agent data or API keys from their agent.</p>
        </div>
    </div>
    {/if}
    <h2 class="snbd-title"><i class="fas fa-microchip"></i> Manage LLM Providers</h2>
    <p class="snbd-subtitle">Add multiple API keys and seamlessly swap your active model powered by SNBD HOST.</p>

    {if $success}
        <div class="alert-success-custom"><i class="fas fa-check-circle"></i> LLM Configuration updated! Your Hermes Agent has been restarted and is now using the new settings.</div>
    {/if}
    {if $error}
        <div class="alert-error-custom"><i class="fas fa-exclamation-triangle"></i> {$error}</div>
    {/if}

    <form method="post" action="clientarea.php?action=productdetails&id={$serviceid}&modop=custom&a=update_llm">
        <div class="card-section">
            <h3 class="section-title"><i class="fas fa-brain" style="color: #CC0000;"></i> Active Model</h3>
            <div class="form-group">
                <label class="form-label">Model String</label>
                {if $is_free_tier}
                <input type="text" name="active_model" class="form-control-custom" value="{$active_model}" placeholder="e.g. claude-haiku, llama-3-8b, mistral-7b">
                <small style="color: #9ca3af; display: block; margin-top: 5px;">Model as configured in the SNBD LiteLLM Gateway. Leave as default unless you know what you're doing.</small>
                {else}
                <input type="text" name="active_model" class="form-control-custom" value="{$active_model}" placeholder="e.g. openrouter/meta-llama/llama-3-70b-instruct">
                <small style="color: #9ca3af; display: block; margin-top: 5px;">This specifies exactly which model your agent should use.</small>
                {/if}
            </div>
        </div>

        {if $is_free_tier}
        <div class="card-section" style="background: #fef2f2; border-color: #fecaca;">
            <h3 class="section-title" style="border-bottom: none; margin-bottom: 5px;"><i class="fas fa-shield-alt" style="color: #CC0000;"></i> SNBD Free Tier Active</h3>
            <p style="font-size: 13px; color: #6b7280; margin: 0;">Your model access is managed automatically through the SNBD LiteLLM Gateway. No API key is needed — inference is routed and billed centrally on your behalf.</p>
        </div>
        {else}
        <div class="card-section">
            <h3 class="section-title"><i class="fas fa-key" style="color: #CC0000;"></i> API Keys (Add as many as you want)</h3>
            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    OpenRouter API Key
                </label>
                <input type="password" name="openrouter_key" class="form-control-custom" value="{$openrouter_key}" placeholder="sk-or-v1-...">
            </div>
            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/><path d="M2 12h20"/></svg>
                    OpenAI API Key
                </label>
                <input type="password" name="openai_key" class="form-control-custom" value="{$openai_key}" placeholder="sk-...">
            </div>
            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
                    Anthropic API Key
                </label>
                <input type="password" name="anthropic_key" class="form-control-custom" value="{$anthropic_key}" placeholder="sk-ant-...">
            </div>
            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                    Nous Portal API Key
                </label>
                <input type="password" name="nous_key" class="form-control-custom" value="{$nous_key}" placeholder="...">
            </div>
        </div>
        {/if}

        <!-- ── Messaging Channels ──────────────────────────────────────────── -->
        <style>
        .msg-card {
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 14px;
            transition: box-shadow .2s;
        }
        .msg-card:last-child { margin-bottom: 0; }
        .msg-card-header {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 20px;
            background: #f9fafb;
            cursor: pointer;
            user-select: none;
        }
        .msg-card-icon {
            width: 38px; height: 38px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; flex-shrink: 0;
        }
        .msg-card-icon.tg  { background: #e8f5ff; color: #0088cc; }
        .msg-card-icon.dc  { background: #eef0ff; color: #5865F2; }
        .msg-card-icon.sl  { background: #fdf6e3; color: #611f69; }
        .msg-card-meta { flex: 1; }
        .msg-card-name { font-size: 15px; font-weight: 700; color: #111827; }
        .msg-badge-connected {
            display: inline-flex; align-items: center; gap: 5px;
            background: #d1fae5; color: #065f46;
            font-size: 11px; font-weight: 700;
            padding: 3px 9px; border-radius: 100px;
            text-transform: uppercase; letter-spacing: .04em;
        }
        .msg-badge-connected::before { content: ''; display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #059669; }
        .msg-badge-disconnected {
            display: inline-flex; align-items: center; gap: 5px;
            background: #f3f4f6; color: #6b7280;
            font-size: 11px; font-weight: 600;
            padding: 3px 9px; border-radius: 100px;
            text-transform: uppercase; letter-spacing: .04em;
        }
        .msg-badge-disconnected::before { content: ''; display: inline-block; width: 6px; height: 6px; border-radius: 50%; background: #9ca3af; }
        .btn-msg-connect {
            background: #CC0000; color: #fff; border: none;
            padding: 8px 16px; border-radius: 7px; font-size: 13px;
            font-weight: 600; cursor: pointer; white-space: nowrap;
            display: inline-flex; align-items: center; gap: 6px;
            transition: background .15s;
        }
        .btn-msg-connect:hover { background: #aa0000; }
        .btn-msg-connect:disabled { background: #d1d5db; cursor: not-allowed; }
        .btn-msg-disconnect {
            background: #fff; color: #6b7280; border: 1px solid #d1d5db;
            padding: 8px 16px; border-radius: 7px; font-size: 13px;
            font-weight: 600; cursor: pointer; white-space: nowrap;
            display: inline-flex; align-items: center; gap: 6px;
            transition: all .15s;
        }
        .btn-msg-disconnect:hover { background: #fef2f2; color: #dc2626; border-color: #fca5a5; }
        .msg-card-body {
            padding: 18px 20px;
            border-top: 1px solid #e5e7eb;
            background: #fff;
        }
        .msg-instruction {
            font-size: 13px; color: #6b7280; margin-bottom: 14px; line-height: 1.6;
        }
        .msg-instruction a { color: #CC0000; font-weight: 600; }
        .msg-input-row { display: flex; gap: 10px; align-items: flex-start; }
        .msg-input-row input {
            flex: 1; padding: 10px 14px; border: 1px solid #d1d5db;
            border-radius: 7px; font-size: 13px; font-family: 'Fira Code', monospace;
            outline: none; transition: border-color .15s;
        }
        .msg-input-row input:focus { border-color: #CC0000; box-shadow: 0 0 0 3px rgba(204,0,0,.1); }
        .msg-feedback {
            margin-top: 10px; padding: 10px 14px; border-radius: 7px;
            font-size: 13px; font-weight: 600;
            display: flex; align-items: center; gap: 8px;
        }
        .msg-feedback.connecting { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .msg-feedback.success    { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
        .msg-feedback.error      { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .msg-spinner {
            display: inline-block; width: 14px; height: 14px; flex-shrink: 0;
            border: 2px solid currentColor; border-top-color: transparent;
            border-radius: 50%; animation: msg-spin .6s linear infinite;
        }
        @keyframes msg-spin { to { transform: rotate(360deg); } }
        </style>

        <div class="card-section">
            <h3 class="section-title"><i class="fas fa-plug" style="color:#CC0000;"></i> Messaging Channels</h3>
            <p style="font-size:13px;color:#6b7280;margin:-8px 0 18px;">Connect your Hermes agent to a chat platform. Tokens are validated live then injected into your running container.</p>

            <!-- Telegram -->
            <div class="msg-card" id="msg-card-telegram">
                <div class="msg-card-header" onclick="msgToggle('telegram')">
                    <div class="msg-card-icon tg"><i class="fab fa-telegram"></i></div>
                    <div class="msg-card-meta">
                        <div class="msg-card-name">Telegram</div>
                        <div id="badge-telegram" style="margin-top:3px;">
                            {if $telegram_token}
                                <span class="msg-badge-connected">Connected</span>
                            {else}
                                <span class="msg-badge-disconnected">Not connected</span>
                            {/if}
                        </div>
                    </div>
                    <div id="action-telegram">
                        {if $telegram_token}
                            <button type="button" class="btn-msg-disconnect" onclick="event.stopPropagation();msgDisconnect('telegram')">
                                <i class="fas fa-unlink"></i> Disconnect
                            </button>
                        {else}
                            <button type="button" class="btn-msg-connect" onclick="event.stopPropagation();msgToggle('telegram')">
                                <i class="fas fa-plug"></i> Connect
                            </button>
                        {/if}
                    </div>
                </div>
                <div class="msg-card-body" id="body-telegram" style="display:none;">
                    {if !$telegram_token}
                    <p class="msg-instruction">
                        1. Open Telegram and message <strong>@BotFather</strong><br>
                        2. Send <code>/newbot</code> and follow the steps<br>
                        3. Copy the token BotFather gives you and paste it below
                    </p>
                    <div class="msg-input-row">
                        <input type="text" id="token-telegram" placeholder="123456789:ABCdefGHIjklMNOpqrSTUvwxYZ" autocomplete="off" spellcheck="false">
                        <button type="button" class="btn-msg-connect" id="btn-telegram" onclick="msgConnect('telegram')">
                            <i class="fas fa-plug"></i> Connect
                        </button>
                    </div>
                    <div id="feedback-telegram" style="display:none;" class="msg-feedback"></div>
                    {else}
                    <div class="pairing-box" id="pairing-box-telegram">
                        <h4><i class="fas fa-key"></i> Pair yourself with your Telegram bot</h4>
                        <div class="pairing-steps">
                            1. Open Telegram and send any message to your bot<br>
                            2. The bot will reply with: <code>Here's your pairing code: XXXXXXXX</code><br>
                            3. Enter that code below to authorize yourself
                        </div>
                        <div class="pairing-input-row">
                            <input type="text" id="pair-code-telegram" maxlength="12" placeholder="e.g. 97JQLXQK" oninput="this.value=this.value.toUpperCase()">
                            <button type="button" class="btn-pair" id="btn-pair-telegram" onclick="approvePairing('telegram')">
                                <i class="fas fa-check"></i> Approve
                            </button>
                        </div>
                        <div id="pair-feedback-telegram" style="display:none;" class="pair-feedback"></div>
                    </div>
                    {/if}
                </div>
            </div>

            <!-- Discord -->
            <div class="msg-card" id="msg-card-discord">
                <div class="msg-card-header" onclick="msgToggle('discord')">
                    <div class="msg-card-icon dc"><i class="fab fa-discord"></i></div>
                    <div class="msg-card-meta">
                        <div class="msg-card-name">Discord</div>
                        <div id="badge-discord" style="margin-top:3px;">
                            {if $discord_token}
                                <span class="msg-badge-connected">Connected</span>
                            {else}
                                <span class="msg-badge-disconnected">Not connected</span>
                            {/if}
                        </div>
                    </div>
                    <div id="action-discord">
                        {if $discord_token}
                            <button type="button" class="btn-msg-disconnect" onclick="event.stopPropagation();msgDisconnect('discord')">
                                <i class="fas fa-unlink"></i> Disconnect
                            </button>
                        {else}
                            <button type="button" class="btn-msg-connect" onclick="event.stopPropagation();msgToggle('discord')">
                                <i class="fas fa-plug"></i> Connect
                            </button>
                        {/if}
                    </div>
                </div>
                <div class="msg-card-body" id="body-discord" style="display:none;">
                    <p class="msg-instruction">
                        1. Go to <a href="https://discord.com/developers/applications" target="_blank">Discord Developer Portal</a><br>
                        2. Create an application → Bot section → Reset Token<br>
                        3. Paste the bot token below
                    </p>
                    <div class="msg-input-row">
                        <input type="text" id="token-discord" placeholder="MTEyMzQ1Njc4OTA.abcDEF.1234567890abcdef" autocomplete="off" spellcheck="false">
                        <button type="button" class="btn-msg-connect" id="btn-discord" onclick="msgConnect('discord')">
                            <i class="fas fa-plug"></i> Connect
                        </button>
                    </div>
                    <div id="feedback-discord" style="display:none;" class="msg-feedback"></div>
                </div>
            </div>

            <!-- Slack -->
            <div class="msg-card" id="msg-card-slack">
                <div class="msg-card-header" onclick="msgToggle('slack')">
                    <div class="msg-card-icon sl"><i class="fab fa-slack"></i></div>
                    <div class="msg-card-meta">
                        <div class="msg-card-name">Slack</div>
                        <div id="badge-slack" style="margin-top:3px;">
                            {if $slack_token}
                                <span class="msg-badge-connected">Connected</span>
                            {else}
                                <span class="msg-badge-disconnected">Not connected</span>
                            {/if}
                        </div>
                    </div>
                    <div id="action-slack">
                        {if $slack_token}
                            <button type="button" class="btn-msg-disconnect" onclick="event.stopPropagation();msgDisconnect('slack')">
                                <i class="fas fa-unlink"></i> Disconnect
                            </button>
                        {else}
                            <button type="button" class="btn-msg-connect" onclick="event.stopPropagation();msgToggle('slack')">
                                <i class="fas fa-plug"></i> Connect
                            </button>
                        {/if}
                    </div>
                </div>
                <div class="msg-card-body" id="body-slack" style="display:none;">
                    <p class="msg-instruction">
                        1. Go to <a href="https://api.slack.com/apps" target="_blank">api.slack.com/apps</a> and create an app<br>
                        2. Under <strong>OAuth & Permissions</strong>, add bot scopes and install the app<br>
                        3. Copy the <strong>Bot User OAuth Token</strong> (starts with <code>xoxb-</code>) and paste it below
                    </p>
                    <div class="msg-input-row">
                        <input type="text" id="token-slack" placeholder="xoxb-..." autocomplete="off" spellcheck="false">
                        <button type="button" class="btn-msg-connect" id="btn-slack" onclick="msgConnect('slack')">
                            <i class="fas fa-plug"></i> Connect
                        </button>
                    </div>
                    <div id="feedback-slack" style="display:none;" class="msg-feedback"></div>
                </div>
            </div>
        </div>

        <!-- Pairing section (shown after connect or if already connected) -->
        <style>
        .pairing-box {
            margin-top: 14px; padding: 16px 18px;
            background: #fffbeb; border: 1px solid #fde68a; border-radius: 8px;
        }
        .pairing-box h4 {
            margin: 0 0 8px; font-size: 14px; font-weight: 700; color: #92400e;
            display: flex; align-items: center; gap: 7px;
        }
        .pairing-steps { font-size: 13px; color: #78350f; line-height: 1.8; margin-bottom: 12px; }
        .pairing-steps code {
            background: rgba(0,0,0,0.06); padding: 1px 6px; border-radius: 4px;
            font-family: monospace; font-size: 12px;
        }
        .pairing-input-row { display: flex; gap: 8px; align-items: center; }
        .pairing-input-row input {
            flex: 1; padding: 9px 13px; border: 1px solid #fbbf24; border-radius: 7px;
            font-size: 14px; font-family: monospace; font-weight: 700; letter-spacing: .1em;
            text-transform: uppercase; outline: none; background: #fff;
        }
        .pairing-input-row input:focus { border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(251,191,36,.2); }
        .btn-pair {
            background: #d97706; color: #fff; border: none;
            padding: 9px 16px; border-radius: 7px; font-size: 13px;
            font-weight: 700; cursor: pointer; white-space: nowrap;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-pair:hover { background: #b45309; }
        .btn-pair:disabled { background: #d1d5db; cursor: not-allowed; }
        .pair-feedback {
            margin-top: 10px; padding: 9px 13px; border-radius: 7px;
            font-size: 13px; font-weight: 600;
            display: flex; align-items: center; gap: 8px;
        }
        .pair-feedback.success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
        .pair-feedback.error   { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .pair-feedback.working { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        </style>

        <script>
        var _msgServiceId = {$serviceid};
        var _msgAjaxUrl = 'modules/servers/hermesagent/ajax.php';

        function msgToggle(platform) {
            var body = document.getElementById('body-' + platform);
            var isNowOpen = body.style.display === 'none';
            body.style.display = isNowOpen ? 'block' : 'none';
            // If already connected and opening, show pairing box
            var badge = document.getElementById('badge-' + platform);
            if (isNowOpen && badge && badge.querySelector('.msg-badge-connected')) {
                showPairingBox(platform, '');
            }
        }

        function msgConnect(platform) {
            var tokenEl  = document.getElementById('token-' + platform);
            var btnEl    = document.getElementById('btn-' + platform);
            var feedback = document.getElementById('feedback-' + platform);
            var token    = tokenEl.value.trim();

            if (!token) { tokenEl.focus(); return; }

            // Connecting state
            btnEl.disabled = true;
            btnEl.innerHTML = '<span class="msg-spinner"></span> Connecting...';
            feedback.className = 'msg-feedback connecting';
            feedback.innerHTML = '<span class="msg-spinner"></span> Validating token with ' + platform.charAt(0).toUpperCase() + platform.slice(1) + '...';
            feedback.style.display = 'flex';

            var fd = new FormData();
            fd.append('action', 'connect_messaging');
            fd.append('serviceId', _msgServiceId);
            fd.append('platform', platform);
            fd.append('token', token);

            fetch(_msgAjaxUrl, { method: 'POST', body: fd })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    btnEl.disabled = false;
                    if (data.success) {
                        feedback.className = 'msg-feedback success';
                        feedback.innerHTML = '<i class="fas fa-check-circle"></i> Connected as <strong>' + data.bot_name + '</strong> — agent is restarting now.';

                        // Update badge and action button
                        document.getElementById('badge-' + platform).innerHTML =
                            '<span class="msg-badge-connected">Connected as ' + data.bot_name + '</span>';
                        document.getElementById('action-' + platform).innerHTML =
                            '<button type="button" class="btn-msg-disconnect" onclick="event.stopPropagation();msgDisconnect(\'' + platform + '\')">'
                            + '<i class="fas fa-unlink"></i> Disconnect</button>';

                        tokenEl.value = '';
                        btnEl.innerHTML = '<i class="fas fa-plug"></i> Connect';

                        // Show pairing box
                        showPairingBox(platform, data.bot_name);
                    } else {
                        feedback.className = 'msg-feedback error';
                        feedback.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + (data.error || 'Connection failed');
                        btnEl.innerHTML = '<i class="fas fa-plug"></i> Connect';
                    }
                })
                .catch(function(err) {
                    btnEl.disabled = false;
                    btnEl.innerHTML = '<i class="fas fa-plug"></i> Connect';
                    feedback.className = 'msg-feedback error';
                    feedback.innerHTML = '<i class="fas fa-exclamation-circle"></i> Network error — please try again.';
                });
        }

        function showPairingBox(platform, botName) {
            var body = document.getElementById('body-' + platform);
            var existing = document.getElementById('pairing-box-' + platform);
            if (existing) return; // already shown

            var platformLabel = platform.charAt(0).toUpperCase() + platform.slice(1);
            var html = '<div class="pairing-box" id="pairing-box-' + platform + '">'
                + '<h4><i class="fas fa-key"></i> Step 2 — Pair yourself with the bot</h4>'
                + '<div class="pairing-steps">'
                + '1. Open ' + platformLabel + ' and send any message to <strong>' + botName + '</strong><br>'
                + '2. The bot will reply with: <code>Here\'s your pairing code: XXXXXXXX</code><br>'
                + '3. Enter that code below to authorize yourself'
                + '</div>'
                + '<div class="pairing-input-row">'
                + '<input type="text" id="pair-code-' + platform + '" maxlength="12" placeholder="e.g. 97JQLXQK" oninput="this.value=this.value.toUpperCase()">'
                + '<button type="button" class="btn-pair" id="btn-pair-' + platform + '" onclick="approvePairing(\'' + platform + '\')">'
                + '<i class="fas fa-check"></i> Approve</button>'
                + '</div>'
                + '<div id="pair-feedback-' + platform + '" style="display:none;" class="pair-feedback"></div>'
                + '</div>';

            body.insertAdjacentHTML('beforeend', html);
        }

        function approvePairing(platform) {
            var codeEl    = document.getElementById('pair-code-' + platform);
            var btnEl     = document.getElementById('btn-pair-' + platform);
            var feedback  = document.getElementById('pair-feedback-' + platform);
            var code      = codeEl.value.trim().toUpperCase();

            if (!code) { codeEl.focus(); return; }

            btnEl.disabled = true;
            btnEl.innerHTML = '<span class="msg-spinner" style="border-color:#fff;border-top-color:transparent;"></span> Approving...';
            feedback.className = 'pair-feedback working';
            feedback.innerHTML = '<span class="msg-spinner"></span> Running pairing approval inside your agent...';
            feedback.style.display = 'flex';

            var fd = new FormData();
            fd.append('action', 'approve_pairing');
            fd.append('serviceId', _msgServiceId);
            fd.append('platform', platform);
            fd.append('code', code);

            fetch(_msgAjaxUrl, { method: 'POST', body: fd })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    btnEl.disabled = false;
                    btnEl.innerHTML = '<i class="fas fa-check"></i> Approve';
                    if (data.success) {
                        feedback.className = 'pair-feedback success';
                        feedback.innerHTML = '<i class="fas fa-check-circle"></i> Paired! You can now chat with your agent on '
                            + platform.charAt(0).toUpperCase() + platform.slice(1) + '.';
                        codeEl.value = '';
                        // Hide pairing box after 4s
                        setTimeout(function() {
                            var box = document.getElementById('pairing-box-' + platform);
                            if (box) box.style.display = 'none';
                        }, 4000);
                    } else {
                        feedback.className = 'pair-feedback error';
                        feedback.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + (data.error || 'Pairing failed');
                    }
                })
                .catch(function() {
                    btnEl.disabled = false;
                    btnEl.innerHTML = '<i class="fas fa-check"></i> Approve';
                    feedback.className = 'pair-feedback error';
                    feedback.innerHTML = '<i class="fas fa-exclamation-circle"></i> Network error — try again.';
                });
        }

        function msgDisconnect(platform) {
            if (!confirm('Disconnect ' + platform.charAt(0).toUpperCase() + platform.slice(1) + ' from your agent? The agent will restart.')) return;

            var actionEl = document.getElementById('action-' + platform);
            actionEl.innerHTML = '<span style="font-size:12px;color:#9ca3af;"><span class="msg-spinner" style="border-color:#9ca3af;border-top-color:transparent;"></span> Disconnecting...</span>';

            var fd = new FormData();
            fd.append('action', 'disconnect_messaging');
            fd.append('serviceId', _msgServiceId);
            fd.append('platform', platform);

            fetch(_msgAjaxUrl, { method: 'POST', body: fd })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.success) {
                        document.getElementById('badge-' + platform).innerHTML =
                            '<span class="msg-badge-disconnected">Not connected</span>';
                        actionEl.innerHTML =
                            '<button type="button" class="btn-msg-connect" onclick="event.stopPropagation();msgToggle(\'' + platform + '\')">'
                            + '<i class="fas fa-plug"></i> Connect</button>';
                        document.getElementById('body-' + platform).style.display = 'none';
                        var fb = document.getElementById('feedback-' + platform);
                        if (fb) fb.style.display = 'none';
                    } else {
                        actionEl.innerHTML =
                            '<button type="button" class="btn-msg-disconnect" onclick="event.stopPropagation();msgDisconnect(\'' + platform + '\')">'
                            + '<i class="fas fa-unlink"></i> Disconnect</button>';
                        alert('Disconnect failed: ' + (data.error || 'Unknown error'));
                    }
                })
                .catch(function() {
                    actionEl.innerHTML =
                        '<button type="button" class="btn-msg-disconnect" onclick="event.stopPropagation();msgDisconnect(\'' + platform + '\')">'
                        + '<i class="fas fa-unlink"></i> Disconnect</button>';
                    alert('Network error — please try again.');
                });
        }
        </script>
        
        <div class="card-section">
            <h3 class="section-title"><i class="fas fa-server" style="color: #CC0000;"></i> Custom OpenAI-Compatible Endpoint</h3>
            <div class="form-group">
                <label class="form-label">Custom API Base URL</label>
                <input type="text" name="custom_url" class="form-control-custom" value="{$custom_url}" placeholder="https://api.yourdomain.com/v1">
            </div>
            <div class="form-group">
                <label class="form-label">Custom API Key</label>
                <input type="password" name="custom_key" class="form-control-custom" value="{$custom_key}" placeholder="Custom Key (if required)">
            </div>
        </div>

        {if $api_enabled}
        <div class="card-section" style="background: #ffffff; border-color: #CC0000; border-left: 4px solid #CC0000;">
            <h3 class="section-title" style="border-bottom: none; margin-bottom: 5px;"><i class="fas fa-code-branch" style="color: #CC0000;"></i> Connect to Your Agent's API</h3>
            <p style="font-size: 13px; color: #6b7280; margin-bottom: 20px;">Use these credentials to connect third-party apps (like LobeChat or Open WebUI) directly to your Hermes Agent.</p>
            
            <div class="form-group">
                <label class="form-label">Agent API Base URL (v1)</label>
                <input type="text" class="form-control-custom" value="{$api_url}" readonly onclick="this.select()">
            </div>
            
            <div class="form-group">
                <label class="form-label">Agent API Key</label>
                <input type="text" class="form-control-custom" value="{$api_key}" readonly onclick="this.select()">
            </div>
            
            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Agent API Port</label>
                <input type="text" class="form-control-custom" value="{$api_port}" readonly>
            </div>
        </div>
        {/if}

        <div class="btn-container">
            <button type="submit" class="btn-submit"><i class="fas fa-save"></i> Save & Restart Agent</button>
            <a href="clientarea.php?action=productdetails&id={$serviceid}" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>
    </form>
</div>
