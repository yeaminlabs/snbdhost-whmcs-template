/* ============================================================================
   SNBD HOST — APPLICATION SHELL SCRIPT
   Sidebar (rail + off-canvas), sticky topbar, popovers, modals, copying,
   password generation and price formatting. No layout is written by scroll
   handlers beyond a class toggle.
   ========================================================================== */
(function () {
  'use strict';

  var MQ_DESKTOP = window.matchMedia('(min-width: 1200px)');
  var MQ_NAV = window.matchMedia('(max-width: 1024px)');

  function $(sel, ctx) { return (ctx || document).querySelector(sel); }
  function $$(sel, ctx) { return Array.prototype.slice.call((ctx || document).querySelectorAll(sel)); }

  /* ------------------------------------------------------------- Sidebar rail */
  function initSidebar() {
    var root = document.documentElement;
    var sidebar = $('#snbd-sidebar');
    var toggle = $('.snbd-rail-toggle');
    var menuBtn = $('.snbd-menu-btn');
    var backdrop = $('.snbd-backdrop');
    var storageKey = 'snbd-sidebar-rail';

    // Sync button state with the pre-paint class set in the document head.
    function syncRailToggle() {
      if (!toggle) return;
      var rail = root.classList.contains('snbd-rail');
      toggle.setAttribute('aria-expanded', rail ? 'false' : 'true');
      toggle.setAttribute('aria-label', rail ? 'Expand sidebar' : 'Collapse sidebar');
      var icon = toggle.querySelector('i');
      if (icon) icon.className = rail ? 'ti ti-layout-sidebar-left-expand' : 'ti ti-layout-sidebar-left-collapse';
    }

    if (toggle) {
      toggle.addEventListener('click', function () {
        root.classList.toggle('snbd-rail');
        try { localStorage.setItem(storageKey, root.classList.contains('snbd-rail') ? '1' : '0'); } catch (e) {}
        syncRailToggle();
      });
      syncRailToggle();
    }

    function closeNav() {
      if (!sidebar) return;
      sidebar.classList.remove('is-open');
      if (backdrop) backdrop.classList.remove('is-open');
      if (menuBtn) menuBtn.setAttribute('aria-expanded', 'false');
      document.body.style.overflow = '';
    }

    function openNav() {
      if (!sidebar) return;
      sidebar.classList.add('is-open');
      if (backdrop) backdrop.classList.add('is-open');
      if (menuBtn) menuBtn.setAttribute('aria-expanded', 'true');
      document.body.style.overflow = 'hidden';
      var first = sidebar.querySelector('a, button');
      if (first) first.focus();
    }

    if (menuBtn) {
      menuBtn.addEventListener('click', function () {
        if (sidebar && sidebar.classList.contains('is-open')) closeNav();
        else openNav();
      });
    }
    if (backdrop) backdrop.addEventListener('click', closeNav);

    // Closing behaviour when leaving mobile widths.
    if (MQ_NAV.addEventListener) {
      MQ_NAV.addEventListener('change', function (e) { if (!e.matches) closeNav(); });
    }

    // Close after choosing a destination on mobile.
    $$('#snbd-sidebar a.snbd-nav__item').forEach(function (link) {
      link.addEventListener('click', function () { if (MQ_NAV.matches) closeNav(); });
    });

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') closeNav();
    });
  }

  /* ------------------------------------------------------------ Topbar shadow */
  function initTopbar() {
    var topbar = $('#snbd-topbar');
    if (!topbar) return;
    var ticking = false;
    function update() {
      topbar.classList.toggle('is-scrolled', window.scrollY > 8);
      ticking = false;
    }
    window.addEventListener('scroll', function () {
      if (!ticking) {
        window.requestAnimationFrame(update);
        ticking = true;
      }
    }, { passive: true });
    update();
  }

  /* ---------------------------------------------------------------- Popovers */
  function initPopovers() {
    var triggers = $$('[data-snbd-popover]');

    function closeAll(except) {
      triggers.forEach(function (trigger) {
        var panel = document.getElementById(trigger.getAttribute('data-snbd-popover'));
        if (!panel || panel === except) return;
        panel.classList.remove('is-open');
        trigger.setAttribute('aria-expanded', 'false');
      });
    }

    triggers.forEach(function (trigger) {
      var panel = document.getElementById(trigger.getAttribute('data-snbd-popover'));
      if (!panel) return;
      trigger.addEventListener('click', function (e) {
        e.stopPropagation();
        var open = panel.classList.contains('is-open');
        closeAll(panel);
        panel.classList.toggle('is-open', !open);
        trigger.setAttribute('aria-expanded', String(!open));
        if (!open) {
          var first = panel.querySelector('a, button');
          if (first) first.focus();
        }
      });
      panel.addEventListener('click', function (e) { e.stopPropagation(); });
    });

    document.addEventListener('click', function () { closeAll(); });
    document.addEventListener('keydown', function (e) {
      if (e.key !== 'Escape') return;
      var open = document.querySelector('.snbd-popover.is-open');
      if (!open) return;
      open.classList.remove('is-open');
      triggers.forEach(function (t) {
        if (t.getAttribute('data-snbd-popover') === open.id) {
          t.setAttribute('aria-expanded', 'false');
          t.focus();
        }
      });
    });
  }

  /* -------------------------------------------------------------------- Search */
  function initSearch() {
    var input = $('[data-snbd-search]');
    if (!input) return;
    document.addEventListener('keydown', function (e) {
      var tag = (e.target.tagName || '').toLowerCase();
      var typing = tag === 'input' || tag === 'textarea' || tag === 'select' || e.target.isContentEditable;
      if (e.key === '/' && !typing) {
        e.preventDefault();
        input.focus();
      } else if (e.key === 'Escape' && document.activeElement === input) {
        input.value = '';
        input.blur();
      }
    });
  }

  /* --------------------------------------------------------------- Copy fields */
  function initCopy() {
    $$('[data-snbd-copy]').forEach(function (button) {
      button.addEventListener('click', function () {
        var selector = button.getAttribute('data-snbd-copy');
        var field = selector === 'self' ? button : document.querySelector(selector);
        if (!field) return;
        var value = field.value !== undefined ? field.value : field.textContent;
        var done = function () {
          var icon = button.querySelector('i');
          var prev = icon ? icon.className : '';
          if (icon) icon.className = 'ti ti-check';
          button.classList.add('is-copied');
          setTimeout(function () {
            if (icon) icon.className = prev;
            button.classList.remove('is-copied');
          }, 1400);
        };
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(value).then(done, done);
        } else {
          var range = document.createRange();
          range.selectNodeContents(field);
          var sel = window.getSelection();
          sel.removeAllRanges();
          sel.addRange(range);
          try { document.execCommand('copy'); } catch (err) {}
          done();
        }
      });
    });
  }

  /* --------------------------------------------------------------------- Modal */
  function openModal(modal) {
    if (!modal) return;
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
    var focusable = modal.querySelector('input, select, textarea, button, a[href]');
    if (focusable) focusable.focus();
    modal._snbdReturnFocus = document.activeElement;
  }
  function closeModal(modal) {
    if (!modal) return;
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    if (modal._snbdReturnFocus && modal._snbdReturnFocus.focus) modal._snbdReturnFocus.focus();
  }
  window.snbdOpenModal = openModal;
  window.snbdCloseModal = closeModal;

  function initModals() {
    $$('[data-snbd-modal-open]').forEach(function (trigger) {
      trigger.addEventListener('click', function (e) {
        e.preventDefault();
        openModal(document.getElementById(trigger.getAttribute('data-snbd-modal-open')));
      });
    });
    $$('[data-snbd-modal-close]').forEach(function (trigger) {
      trigger.addEventListener('click', function () {
        closeModal(trigger.closest('.snbd-modal'));
      });
    });
    $$('.snbd-modal').forEach(function (modal) {
      var backdrop = modal.querySelector('.snbd-modal__backdrop');
      if (backdrop) backdrop.addEventListener('click', function () { closeModal(modal); });
      modal.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') { closeModal(modal); return; }
        if (e.key !== 'Tab') return;
        var items = modal.querySelectorAll('a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled])');
        if (!items.length) return;
        var first = items[0];
        var last = items[items.length - 1];
        if (e.shiftKey && document.activeElement === first) { e.preventDefault(); last.focus(); }
        else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
      });
    });
  }

  /* -------------------------------------------------------- Price formatting */
  // $1.63USD -> $1.63 USD, only inside declared price nodes.
  function initPrices() {
    var pattern = /(\$|৳|€|£)(\d+(?:[.,]\d+)?)(USD|BDT|EUR|GBP)/g;
    $$('.snbd-price').forEach(function (node) {
      var walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT, null);
      var text;
      while ((text = walker.nextNode())) {
        var updated = text.nodeValue
          .replace(pattern, '$1$2 $3')
          .replace(/(\$|৳|€|£)-(\d+(?:[.,]\d+)?)/g, '-$1$2');
        if (updated !== text.nodeValue) text.nodeValue = updated;
      }
    });
  }

  /* ------------------------------------------------------- Password generator */
  function initPasswordGenerator() {
    window.WHMCS = window.WHMCS || {};
    window.WHMCS.utils = window.WHMCS.utils || {};
    if (!window.WHMCS.utils.generatePassword) {
      window.WHMCS.utils.generatePassword = function (len) {
        var length = len || 16;
        var charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+~`|}{[]:;?><,./-=';
        var out = '';
        for (var i = 0; i < length; i++) out += charset.charAt(Math.floor(Math.random() * charset.length));
        return out;
      };
    }

    document.addEventListener('click', function (e) {
      var trigger = e.target.closest('.generate-password');
      if (!trigger) return;
      e.preventDefault();
      var fieldsAttr = trigger.getAttribute('data-targetfields') || 'inputNewPassword1,inputNewPassword2';
      var generated = window.WHMCS.utils.generatePassword(16);
      var output = document.getElementById('inputGeneratePasswordOutput');
      if (output) output.value = generated;
      var modal = document.getElementById('modalGeneratePassword');
      if (modal && window.bootstrap && bootstrap.Modal) {
        modal.setAttribute('data-targetfields', fieldsAttr);
        var instance = bootstrap.Modal.getInstance(modal) || new bootstrap.Modal(modal);
        instance.show();
      } else {
        fieldsAttr.split(',').forEach(function (id) {
          var field = document.getElementById(id.trim());
          if (!field) return;
          field.value = generated;
          field.dispatchEvent(new Event('change', { bubbles: true }));
          field.dispatchEvent(new Event('keyup', { bubbles: true }));
        });
      }
    });

    var insert = document.getElementById('btnGeneratePasswordInsert');
    if (insert) {
      insert.addEventListener('click', function () {
        var output = document.getElementById('inputGeneratePasswordOutput');
        var modal = document.getElementById('modalGeneratePassword');
        if (!output || !modal) return;
        var generated = output.value;
        (modal.getAttribute('data-targetfields') || 'inputNewPassword1,inputNewPassword2').split(',').forEach(function (id) {
          var field = document.getElementById(id.trim());
          if (!field) return;
          field.value = generated;
          field.dispatchEvent(new Event('change', { bubbles: true }));
          field.dispatchEvent(new Event('keyup', { bubbles: true }));
        });
        if (navigator.clipboard) navigator.clipboard.writeText(generated);
        if (window.bootstrap && bootstrap.Modal) {
          var instance = bootstrap.Modal.getInstance(modal);
          if (instance) instance.hide();
        }
      });
    }

    var regen = document.getElementById('frmGeneratePassword');
    if (regen) {
      regen.addEventListener('submit', function (e) {
        e.preventDefault();
        var lenInput = document.getElementById('inputGeneratePasswordLength');
        var len = lenInput ? parseInt(lenInput.value, 10) : 16;
        if (len < 8 || len > 64) len = 16;
        var output = document.getElementById('inputGeneratePasswordOutput');
        if (output) output.value = window.WHMCS.utils.generatePassword(len);
      });
    }
  }

  /* -------------------------------------------------------- Password visibility */
  function initPasswordToggles() {
    $$('[data-snbd-password-toggle]').forEach(function (button) {
      var input = document.querySelector(button.getAttribute('data-snbd-password-toggle'));
      if (!input) return;
      button.addEventListener('click', function () {
        var reveal = input.type === 'password';
        input.type = reveal ? 'text' : 'password';
        button.setAttribute('aria-label', reveal ? 'Hide password' : 'Show password');
        var icon = button.querySelector('i');
        if (icon) icon.className = reveal ? 'ti ti-eye-off' : 'ti ti-eye';
      });
    });
  }

  /* ------------------------------------------------------------- Status filter */
  function initFilters() {
    $$('[data-snbd-filter]').forEach(function (button) {
      button.addEventListener('click', function () {
        var scope = button.closest('.snbd-toolbar') || document;
        var target = (button.getAttribute('data-snbd-filter-target') && document.querySelector(button.getAttribute('data-snbd-filter-target'))) || $('[data-snbd-filter-target]', scope) || $('[data-snbd-filter-target]');
        var value = button.getAttribute('data-snbd-filter');
        $$('.snbd-seg__item', button.parentElement).forEach(function (peer) {
          var active = peer === button;
          peer.classList.toggle('active', active);
          peer.setAttribute('aria-pressed', String(active));
        });
        if (!target) return;
        $$('.snbd-filter-row', target).forEach(function (item) {
          var chip = item.querySelector('.snbd-chip');
          var status = chip ? chip.textContent.trim().toLowerCase().replace(/\s+/g, '-') : '';
          item.hidden = value !== 'all' && status !== value;
        });
      });
    });
  }

  /* --------------------------------------------------------- Dismissable blocks */
  function initDismiss() {
    $$('[data-snbd-dismiss]').forEach(function (button) {
      var block = button.closest('[data-snbd-dismissable]');
      if (!block) return;
      var key = block.getAttribute('data-snbd-dismiss-key');
      try {
        if (key && localStorage.getItem(key) === '1') { block.hidden = true; return; }
      } catch (e) {}
      button.addEventListener('click', function () {
        block.hidden = true;
        try { if (key) localStorage.setItem(key, '1'); } catch (e) {}
      });
    });
  }

  /* ----------------------------------------------------------- Form validation */
  /* ------------------------------------------------------- Parent alert dismiss */
  function initAlerts() {
    document.addEventListener('click', function (e) {
      var dismiss = e.target.closest('[data-dismiss="alert"], [data-bs-dismiss="alert"]');
      if (!dismiss) return;
      var alert = dismiss.closest('.alert');
      if (alert) alert.remove();
    });
  }

  function initValidation() {
    $$('form.needs-validation').forEach(function (form) {
      form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    initSidebar();
    initTopbar();
    initPopovers();
    initSearch();
    initCopy();
    initModals();
    initPrices();
    initFilters();
    initDismiss();
    initPasswordToggles();
    initPasswordGenerator();
    initAlerts();
    initValidation();
  });
})();
