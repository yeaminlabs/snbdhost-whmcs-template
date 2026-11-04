<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* ── Page wrapper ─────────────────────────────────────────────── */
.hterm-page { font-family:'Outfit',sans-serif; margin:20px 0; }

/* ── Header card ─────────────────────────────────────────────── */
.hterm-header {
    background:#fff; border:1px solid #e5e7eb; border-radius:12px 12px 0 0;
    padding:18px 24px; display:flex; align-items:center; justify-content:space-between;
    border-bottom:none;
}
.hterm-header-left { display:flex; align-items:center; gap:12px; }
.hterm-header-title { font-size:16px; font-weight:700; color:#111827; }
.hterm-header-sub   { font-size:12px; color:#6b7280; margin-top:2px; }
.hterm-badge {
    display:inline-flex; align-items:center; gap:5px; padding:4px 10px;
    border-radius:100px; font-size:11px; font-weight:700;
    background:#ecfdf5; color:#065f46; border:1px solid #a7f3d0;
}
.hterm-badge-dot { width:6px; height:6px; border-radius:50%; background:#10b981; animation:hterm-pulse 1.5s infinite; }
@keyframes hterm-pulse { 0%,100% { opacity:1; } 50% { opacity:.4; } }

.hterm-toolbar {
    display:flex; gap:8px; align-items:center;
}
.hterm-btn {
    padding:6px 14px; border-radius:7px; font-size:12px; font-weight:700;
    cursor:pointer; border:1px solid #e5e7eb; background:#f9fafb; color:#374151;
    display:flex; align-items:center; gap:5px; transition:all .15s;
    font-family:'Outfit',sans-serif;
}
.hterm-btn:hover { background:#f3f4f6; border-color:#d1d5db; }
.hterm-btn-danger { background:#fef2f2; border-color:#fecaca; color:#dc2626; }
.hterm-btn-danger:hover { background:#fee2e2; }

/* ── Terminal window ─────────────────────────────────────────── */
.hterm-window {
    background:#0d1117; border:1px solid #30363d;
    border-radius:0 0 12px 12px; overflow:hidden;
    box-shadow:0 8px 32px rgba(0,0,0,.3);
}

/* ── Fake title bar ──────────────────────────────────────────── */
.hterm-titlebar {
    background:#161b22; padding:10px 16px;
    display:flex; align-items:center; gap:8px; border-bottom:1px solid #30363d;
}
.hterm-dot { width:12px; height:12px; border-radius:50%; }
.hterm-dot-r { background:#ff5f57; }
.hterm-dot-y { background:#febc2e; }
.hterm-dot-g { background:#28c840; }
.hterm-titlebar-label {
    flex:1; text-align:center; font-size:12px; color:#8b949e;
    font-family:'JetBrains Mono',monospace; font-weight:500;
}

/* ── Output area ─────────────────────────────────────────────── */
.hterm-output {
    height:480px; overflow-y:auto; padding:14px 18px;
    font-family:'JetBrains Mono',monospace; font-size:13px; line-height:1.65;
    color:#e6edf3; word-break:break-all;
    scrollbar-width:thin; scrollbar-color:#30363d #0d1117;
}
.hterm-output::-webkit-scrollbar { width:6px; }
.hterm-output::-webkit-scrollbar-track { background:#0d1117; }
.hterm-output::-webkit-scrollbar-thumb { background:#30363d; border-radius:3px; }

.hterm-line { white-space:pre-wrap; }
.hterm-line-cmd  { color:#79c0ff; }
.hterm-line-out  { color:#e6edf3; }
.hterm-line-err  { color:#ff7b72; }
.hterm-line-info { color:#8b949e; font-style:italic; }
.hterm-line-ok   { color:#3fb950; }

/* ── Prompt row ──────────────────────────────────────────────── */
.hterm-prompt-row {
    display:flex; align-items:center; gap:0;
    border-top:1px solid #21262d; background:#0d1117; padding:10px 18px;
}
.hterm-prompt-label {
    font-family:'JetBrains Mono',monospace; font-size:13px;
    white-space:nowrap; flex-shrink:0; user-select:none;
}
.hterm-prompt-user { color:#3fb950; font-weight:500; }
.hterm-prompt-at   { color:#8b949e; }
.hterm-prompt-host { color:#79c0ff; font-weight:500; }
.hterm-prompt-path { color:#e6edf3; }
.hterm-prompt-sym  { color:#f0883e; margin-right:8px; }
.hterm-input {
    flex:1; background:transparent; border:none; outline:none; caret-color:#e6edf3;
    font-family:'JetBrains Mono',monospace; font-size:13px; color:#e6edf3;
}

/* ── Security notice ─────────────────────────────────────────── */
.hterm-notice {
    margin-top:12px; padding:10px 16px; border-radius:8px;
    background:#161b22; border:1px solid #30363d;
    font-size:12px; color:#8b949e; display:flex; align-items:center; gap:8px;
}

/* ── Suspended overlay ───────────────────────────────────────── */
.hterm-suspended {
    background:#fef2f2; padding:16px; border-radius:12px;
    border:1px solid #fecaca; color:#991b1b; font-weight:600; font-size:14px;
}
</style>

<div class="hterm-page">

{if $deployment_status eq 'Suspended' or $deployment_status eq 'Terminated'}
<div class="hterm-suspended">
    <i class="fas fa-ban"></i> Account {$deployment_status} — Terminal is unavailable.
</div>
{else}

<div class="hterm-header">
    <div class="hterm-header-left">
        <div>
            <div class="hterm-header-title">
                <i class="fas fa-terminal" style="color:#CC0000;margin-right:6px;"></i>Container Terminal
            </div>
            <div class="hterm-header-sub">Sandboxed shell inside your Hermes agent container</div>
        </div>
        <div class="hterm-badge">
            <span class="hterm-badge-dot"></span> hermes-{$serviceid}
        </div>
    </div>
    <div style="display:flex;align-items:center;gap:8px;">
        <div class="hterm-toolbar">
            <button class="hterm-btn" onclick="htermClear()" title="Clear output">
                <i class="fas fa-eraser"></i> Clear
            </button>
            <button class="hterm-btn" onclick="htermCopy()" title="Copy all output">
                <i class="fas fa-copy"></i> Copy
            </button>
        </div>
        <a href="clientarea.php?action=productdetails&id={$serviceid}"
           style="color:#6b7280;font-size:13px;font-weight:600;text-decoration:none;margin-left:8px;">
            <i class="fas fa-arrow-left"></i> Back
        </a>
    </div>
</div>

<div class="hterm-window">
    <div class="hterm-titlebar">
        <span class="hterm-dot hterm-dot-r"></span>
        <span class="hterm-dot hterm-dot-y"></span>
        <span class="hterm-dot hterm-dot-g"></span>
        <span class="hterm-titlebar-label">hermes-{$serviceid} — bash</span>
    </div>

    <div class="hterm-output" id="hterm-out">
        <div class="hterm-line hterm-line-info">Connected to container hermes-{$serviceid}</div>
        <div class="hterm-line hterm-line-info">Type a command and press Enter. Type <span style="color:#f0883e;">help</span> to see built-in shortcuts.</div>
        <div class="hterm-line hterm-line-info">─────────────────────────────────────────</div>
    </div>

    <div class="hterm-prompt-row">
        <span class="hterm-prompt-label">
            <span class="hterm-prompt-user">root</span><span class="hterm-prompt-at">@</span><span class="hterm-prompt-host">hermes-{$serviceid}</span><span class="hterm-prompt-path">:~</span><span class="hterm-prompt-sym">$</span>
        </span>
        <input class="hterm-input" id="hterm-input"
               type="text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"
               placeholder="enter command…">
    </div>
</div>

<div class="hterm-notice">
    <i class="fas fa-shield-alt" style="color:#3fb950;flex-shrink:0;"></i>
    <span>Commands run <strong>inside your Docker container only</strong> — no access to the host server or other customers' containers. Your data directory is mounted at <code style="background:#0d1117;padding:1px 5px;border-radius:3px;color:#79c0ff;">/opt/data</code>.</span>
</div>

{/if}
</div>

<script>
(function () {
    var SVC_ID  = {$serviceid};
    var AJAX    = 'modules/servers/hermesagent/ajax.php';
    var out     = document.getElementById('hterm-out');
    var inp     = document.getElementById('hterm-input');
    if (!inp) return;

    var history = [];
    var histPos = -1;
    var busy    = false;

    // ── Built-in client-side commands ──────────────────────────
    var builtins = {
        'clear': function () { htermClear(); return null; },
        'help': function () {
            append([
                '  Built-in shortcuts:',
                '    clear          — clear the terminal',
                '    help           — show this message',
                '    ↑ / ↓          — navigate command history',
                '    Ctrl+C         — cancel current input',
                '',
                '  Useful container commands:',
                '    ls /opt/data            — your data directory',
                '    cat /opt/data/config.yaml',
                '    hermes status',
                '    hermes logs -n 50',
                '    pip list',
                '    env | grep -i api',
            ].join('\n'), 'info');
            return null;
        }
    };

    function append(text, type) {
        type = type || 'out';
        var div = document.createElement('div');
        div.className = 'hterm-line hterm-line-' + type;
        div.textContent = text;
        out.appendChild(div);
        out.scrollTop = out.scrollHeight;
    }

    function appendCmd(cmd) {
        var row = document.createElement('div');
        row.className = 'hterm-line hterm-line-cmd';
        row.textContent = '$ ' + cmd;
        out.appendChild(row);
        out.scrollTop = out.scrollHeight;
    }

    function setLoading(on) {
        busy = on;
        inp.disabled = on;
        if (!on) { inp.focus(); }
    }

    function run(cmd) {
        cmd = cmd.trim();
        if (!cmd) return;

        // History
        if (history[history.length - 1] !== cmd) history.push(cmd);
        histPos = history.length;

        appendCmd(cmd);

        // Built-ins
        if (builtins[cmd]) {
            builtins[cmd]();
            return;
        }

        setLoading(true);

        var fd = new FormData();
        fd.append('action', 'terminal_exec');
        fd.append('serviceId', SVC_ID);
        fd.append('command', cmd);

        fetch(AJAX, { method: 'POST', body: fd })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (!data.success) {
                    append('Error: ' + (data.error || 'Unknown error'), 'err');
                } else {
                    var output = data.output || '';
                    // Trim trailing newline
                    output = output.replace(/\n$/, '');
                    if (output) {
                        // Split and colour by exit code
                        var type = data.exit_code !== 0 ? 'err' : 'out';
                        output.split('\n').forEach(function (line) {
                            append(line, type);
                        });
                    }
                    if (data.exit_code !== 0) {
                        append('[exit ' + data.exit_code + ']', 'err');
                    }
                }
            })
            .catch(function (e) {
                append('Network error: ' + e.message, 'err');
            })
            .finally(function () {
                setLoading(false);
            });
    }

    inp.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            var cmd = inp.value;
            inp.value = '';
            run(cmd);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            if (histPos > 0) {
                histPos--;
                inp.value = history[histPos];
                // Move cursor to end
                setTimeout(function () { inp.selectionStart = inp.selectionEnd = inp.value.length; }, 0);
            }
        } else if (e.key === 'ArrowDown') {
            e.preventDefault();
            if (histPos < history.length - 1) {
                histPos++;
                inp.value = history[histPos];
            } else {
                histPos = history.length;
                inp.value = '';
            }
        } else if (e.key === 'c' && e.ctrlKey) {
            inp.value = '';
            append('^C', 'err');
        } else if (e.key === 'l' && e.ctrlKey) {
            e.preventDefault();
            htermClear();
        }
    });

    // Click anywhere on the terminal to focus input
    document.getElementById('hterm-out').addEventListener('click', function () {
        inp.focus();
    });

    // Auto-focus on load
    inp.focus();

    // Expose globals for toolbar buttons
    window.htermClear = function () {
        out.innerHTML = '';
        append('Terminal cleared.', 'info');
    };
    window.htermCopy = function () {
        var text = Array.from(out.querySelectorAll('.hterm-line'))
            .map(function (el) { return el.textContent; }).join('\n');
        navigator.clipboard.writeText(text).then(function () {
            append('Output copied to clipboard.', 'ok');
        }).catch(function () {
            append('Copy failed — select the text manually.', 'err');
        });
    };
})();
</script>
