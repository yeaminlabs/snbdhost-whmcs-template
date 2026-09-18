document.addEventListener('DOMContentLoaded', () => {
  initSidebarToggle();
  initFabMenu();
  initParticles();
  initFormValidation();
  initCurrencyDecorator();
  initPasswordGenerator();
});

/* ---- DOM Currency Decorator ($1.63USD -> $1.63 USD) ---- */
function initCurrencyDecorator() {
  function fixText(node) {
    if (!node) return;
    if (node.nodeType === Node.TEXT_NODE) {
      var txt = node.nodeValue;
      if (txt && (txt.includes('USD') || txt.includes('BDT') || txt.includes('$-') || txt.includes('৳-'))) {
        var updated = txt.replace(/(\$|৳|€|£)(\d+(?:\.\d+)?)(USD|BDT|EUR|GBP)/g, '$1$2 $3');
        updated = updated.replace(/(\$|৳|€|£)-(\d+(?:\.\d+)?)/g, '-$1$2');
        if (updated !== txt) {
          node.nodeValue = updated;
        }
      }
    } else if (node.nodeType === Node.ELEMENT_NODE && node.tagName !== 'SCRIPT' && node.tagName !== 'STYLE' && node.tagName !== 'INPUT' && node.tagName !== 'TEXTAREA') {
      for (var i = 0; i < node.childNodes.length; i++) {
        fixText(node.childNodes[i]);
      }
    }
  }

  fixText(document.body);

  if (window.MutationObserver) {
    var debounceTimer = null;
    var pendingNodes = new Set();

    var observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        mutation.addedNodes.forEach(function(n) {
          if (n.nodeType === Node.ELEMENT_NODE || n.nodeType === Node.TEXT_NODE) {
            pendingNodes.add(n);
          }
        });
      });

      if (!debounceTimer && pendingNodes.size > 0) {
        debounceTimer = setTimeout(function() {
          pendingNodes.forEach(function(node) {
            fixText(node);
          });
          pendingNodes.clear();
          debounceTimer = null;
        }, 60);
      }
    });
    observer.observe(document.body, { childList: true, subtree: true });
  }
}

/* ---- Generate Password Utility & Listener ---- */
function initPasswordGenerator() {
  if (typeof window.WHMCS === 'undefined' || !window.WHMCS.utils || !window.WHMCS.utils.generatePassword) {
    window.WHMCS = window.WHMCS || {};
    window.WHMCS.utils = window.WHMCS.utils || {};
    window.WHMCS.utils.generatePassword = function(len) {
      var length = len || 16;
      var charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+~`|}{[]:;?><,./-=";
      var retVal = "";
      for (var i = 0, n = charset.length; i < length; ++i) {
        retVal += charset.charAt(Math.floor(Math.random() * n));
      }
      return retVal;
    };
  }

  document.addEventListener('click', function(e) {
    var target = e.target.closest('.generate-password');
    if (!target) return;
    e.preventDefault();

    var targetFieldsAttr = target.getAttribute('data-targetfields') || 'inputNewPassword1,inputNewPassword2';
    var modalEl = document.getElementById('modalGeneratePassword');
    
    var generated = window.WHMCS.utils.generatePassword(16);
    var outputInput = document.getElementById('inputGeneratePasswordOutput');
    if (outputInput) {
      outputInput.value = generated;
    }

    if (modalEl && typeof bootstrap !== 'undefined') {
      modalEl.setAttribute('data-targetfields', targetFieldsAttr);
      var bsModal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
      bsModal.show();
    } else {
      // Direct insertion fallback if bootstrap modal is unavailable
      var fields = targetFieldsAttr.split(',');
      for (var i = 0; i < fields.length; i++) {
        var el = document.getElementById(fields[i].trim());
        if (el) {
          el.value = generated;
          el.dispatchEvent(new Event('change', { bubbles: true }));
          el.dispatchEvent(new Event('keyup', { bubbles: true }));
        }
      }
    }
  });

  // Handle Copy & Insert click inside modal
  var insertBtn = document.getElementById('btnGeneratePasswordInsert');
  if (insertBtn) {
    insertBtn.addEventListener('click', function() {
      var outputInput = document.getElementById('inputGeneratePasswordOutput');
      var modalEl = document.getElementById('modalGeneratePassword');
      if (!outputInput || !modalEl) return;

      var generatedPw = outputInput.value;
      var targetFieldsAttr = modalEl.getAttribute('data-targetfields') || 'inputNewPassword1,inputNewPassword2';
      var fields = targetFieldsAttr.split(',');
      for (var i = 0; i < fields.length; i++) {
        var el = document.getElementById(fields[i].trim());
        if (el) {
          el.value = generatedPw;
          el.dispatchEvent(new Event('change', { bubbles: true }));
          el.dispatchEvent(new Event('keyup', { bubbles: true }));
        }
      }

      if (navigator.clipboard) {
        navigator.clipboard.writeText(generatedPw);
      }

      if (typeof bootstrap !== 'undefined') {
        var bsModal = bootstrap.Modal.getInstance(modalEl);
        if (bsModal) bsModal.hide();
      }
    });
  }

  // Handle form regenerate click inside modal
  var frmGen = document.getElementById('frmGeneratePassword');
  if (frmGen) {
    frmGen.addEventListener('submit', function(e) {
      e.preventDefault();
      var lenInput = document.getElementById('inputGeneratePasswordLength');
      var len = lenInput ? parseInt(lenInput.value, 10) : 16;
      if (len < 8 || len > 64) len = 16;
      var outputInput = document.getElementById('inputGeneratePasswordOutput');
      if (outputInput) {
        outputInput.value = window.WHMCS.utils.generatePassword(len);
      }
    });
  }
}

// Full-screen loading spinner
window.addEventListener('load', () => {
  const loader = document.getElementById('snbd-loader');
  const progressBar = document.querySelector('.loader-progress-bar');
  if (loader) {
    if (progressBar) progressBar.style.width = '100%';
    loader.style.opacity = '0';
    loader.style.pointerEvents = 'none';
    setTimeout(() => loader.remove(), 250);
  }
});

/* ---- Sidebar Toggle ---- */
function initSidebarToggle() {
  const toggleBtn = document.getElementById('sidebar-toggle-btn');
  const sidebar = document.getElementById('snbd-sidebar');
  const backdrop = document.getElementById('sidebarBackdrop');
  const icon = toggleBtn?.querySelector('i');

  if (!toggleBtn || !sidebar) return;

  function updateAriaState() {
    const isMobile = window.innerWidth <= 768;
    const isOpen = isMobile ? sidebar.classList.contains('mobile-open') : !sidebar.classList.contains('collapsed');
    toggleBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
  }

  toggleBtn.addEventListener('click', () => {
    if (window.innerWidth <= 768) {
      sidebar.classList.toggle('mobile-open');
      backdrop?.classList.toggle('show');
    } else {
      sidebar.classList.toggle('collapsed');
      // Persist desktop collapsed state
      localStorage.setItem('snbd-sidebar-collapsed', sidebar.classList.contains('collapsed') ? 'true' : 'false');
    }
    if (icon) {
      icon.className = (sidebar.classList.contains('mobile-open') || sidebar.classList.contains('collapsed'))
        ? 'ti ti-x' : 'ti ti-menu-2';
    }
    updateAriaState();
  });

  // Enforce correct icon and aria state on page load
  if (sidebar.classList.contains('collapsed') && icon) {
    icon.className = 'ti ti-x';
  }
  updateAriaState();

  // Close mobile sidebar on backdrop click
  backdrop?.addEventListener('click', () => {
    sidebar.classList.remove('mobile-open');
    backdrop.classList.remove('show');
    if (icon) icon.className = 'ti ti-menu-2';
    updateAriaState();
  });

  // Close sidebar clicking outside on mobile
  document.addEventListener('click', (e) => {
    if (window.innerWidth <= 768 && sidebar.classList.contains('mobile-open')) {
      if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
        sidebar.classList.remove('mobile-open');
        backdrop?.classList.remove('show');
        if (icon) icon.className = 'ti ti-menu-2';
        updateAriaState();
      }
    }
  });
}

/* ---- FAB Menu ---- */
function initFabMenu() {
  const fabContainer = document.getElementById('fab-container');
  const fabMain = document.getElementById('fab-main');
  const fabItems = document.querySelectorAll('.fab-item');

  if (!fabContainer || !fabMain) return;

  fabMain.addEventListener('click', () => {
    const isNowActive = fabContainer.classList.toggle('active');
    fabMain.classList.toggle('active');
    fabMain.setAttribute('aria-expanded', isNowActive ? 'true' : 'false');

    if (isNowActive) {
      fabItems.forEach((item, i) => {
        setTimeout(() => {
          item.style.opacity = '1';
          item.style.transform = 'translateY(0) scale(1)';
        }, i * 50);
      });
    } else {
      fabItems.forEach((item) => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(20px) scale(0.8)';
      });
    }
  });

  document.addEventListener('click', (e) => {
    if (fabContainer.classList.contains('active') && !fabContainer.contains(e.target)) {
      fabContainer.classList.remove('active');
      fabMain.classList.remove('active');
      fabMain.setAttribute('aria-expanded', 'false');
      fabItems.forEach((item) => {
        item.style.opacity = '0';
        item.style.transform = 'translateY(20px) scale(0.8)';
      });
    }
  });
}

/* ---- Bootstrap Form Validation ---- */
function initFormValidation() {
  const forms = document.querySelectorAll('.needs-validation');
  forms.forEach(form => {
    form.addEventListener('submit', event => {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  });
}

/* ---- Particles.js (Auth Pages) ---- */
function initParticles() {
  const particlesEl = document.getElementById('particles-js');
  if (!window.particlesJS || !particlesEl) return;
  // Skip init when the template hides particles (e.g. password-reset pages)
  if (window.getComputedStyle(particlesEl).display === 'none') return;
  if (window.particlesJS && particlesEl) {
    particlesJS('particles-js', {
      particles: {
        number: { value: 50, density: { enable: true, value_area: 800 } },
        color: { value: ['#e53935', '#ffffff'] },
        shape: { type: 'circle' },
        opacity: { value: 0.4, random: true, anim: { enable: true, speed: 1, opacity_min: 0.1, sync: false } },
        size: { value: 3, random: true },
        line_linked: { enable: true, distance: 150, color: '#e53935', opacity: 0.15, width: 1 },
        move: { enable: true, speed: 1, direction: 'none', random: true, straight: false, out_mode: 'out' }
      },
      interactivity: {
        detect_on: 'canvas',
        events: { onhover: { enable: true, mode: 'grab' }, onclick: { enable: true, mode: 'push' }, resize: true },
        modes: { grab: { distance: 140, line_linked: { opacity: 0.4 } }, push: { particles_nb: 3 } }
      },
      retina_detect: true
    });
  }
}

