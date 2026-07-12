/**
 * SNBD HOST Custom Google Sign-In Handler
 * Handles the callback from Google Identity Services
 */

function onGoogleSignIn(credentialResponse) {
    var errorDiv = document.getElementById('snbdGoogleSignInError');
    var loadingDiv = document.getElementById('snbdGoogleSignInLoading');
    var signinBtn = document.querySelector('.g_id_signin');

    if (errorDiv) {
        errorDiv.style.display = 'none';
        errorDiv.innerHTML = '';
    }

    if (!credentialResponse || !credentialResponse.credential) {
        showGoogleError('<i class="fas fa-exclamation-circle"></i> Invalid response from Google. Please try again.');
        return;
    }

    // Show loading state
    if (loadingDiv) {
        loadingDiv.style.display = 'block';
    }
    if (signinBtn) {
        signinBtn.style.opacity = '0.5';
        signinBtn.style.pointerEvents = 'none';
    }

    var csrfToken = window.csrfToken || ''; // Provided by WHMCS in header.tpl

    var formData = new FormData();
    formData.append('id_token', credentialResponse.credential);
    formData.append('token', csrfToken);

    fetch(whmcsBaseUrl + '/google-signin.php', {
        method: 'POST',
        body: formData
    })
    .then(function(response) {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(function(data) {
        if (data.redirect) {
            window.location.href = data.redirect;
        } else if (data.error) {
            hideGoogleLoading();
            if (data.error === 'twofa_required') {
                showGoogleError('<i class="fas fa-shield-alt"></i> Two-factor authentication is enabled for this account. Please sign in with your password to complete 2FA verification.');
            } else {
                showGoogleError('<i class="fas fa-exclamation-circle"></i> ' + escapeHtml(data.error));
            }
        } else {
            hideGoogleLoading();
            showGoogleError('<i class="fas fa-exclamation-circle"></i> An unexpected error occurred. Please contact support.');
        }
    })
    .catch(function(error) {
        hideGoogleLoading();
        showGoogleError('<i class="fas fa-exclamation-circle"></i> Connection error. Please try again.');
        console.error('Google Sign-In Error:', error);
    });
}

function hideGoogleLoading() {
    var loadingDiv = document.getElementById('snbdGoogleSignInLoading');
    var signinBtn = document.querySelector('.g_id_signin');
    if (loadingDiv) loadingDiv.style.display = 'none';
    if (signinBtn) {
        signinBtn.style.opacity = '1';
        signinBtn.style.pointerEvents = 'auto';
    }
}

function showGoogleError(htmlMsg) {
    var errorDiv = document.getElementById('snbdGoogleSignInError');
    if (errorDiv) {
        errorDiv.innerHTML = htmlMsg;
        errorDiv.style.display = 'flex';
    }
}

function escapeHtml(str) {
    return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('auth') === 'google') {
        // Poll until the Google Identity Services API (GSI) is fully loaded
        const checkGSI = setInterval(function() {
            if (window.google && window.google.accounts && window.google.accounts.id) {
                clearInterval(checkGSI);
                // Programmatically trigger Google account selector/prompt
                google.accounts.id.prompt();
            }
        }, 100);
    }
});
