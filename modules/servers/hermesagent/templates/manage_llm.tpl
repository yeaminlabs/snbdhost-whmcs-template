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

        <div class="card-section">
            <h3 class="section-title"><i class="fab fa-telegram-plane" style="color: #CC0000;"></i> Messaging Channels</h3>
            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <i class="fab fa-telegram" style="color: #0088cc; font-size: 16px;"></i> Telegram Bot Token
                </label>
                <input type="password" name="telegram_token" class="form-control-custom" value="{$telegram_token}" placeholder="123456789:ABCdefGHIjklMNOpqrSTUvwxYZ">
                <small style="color: #9ca3af; display: block; margin-top: 5px;">Get this from BotFather on Telegram to allow your agent to talk via Telegram.</small>
            </div>
            <div class="form-group">
                <label class="form-label" style="display: flex; align-items: center; gap: 8px;">
                    <i class="fab fa-discord" style="color: #5865F2; font-size: 16px;"></i> Discord Bot Token
                </label>
                <input type="password" name="discord_token" class="form-control-custom" value="{$discord_token}" placeholder="MTEyMzQ1Njc4OTA.abcDEF.1234567890abcdef">
            </div>
        </div>
        
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
