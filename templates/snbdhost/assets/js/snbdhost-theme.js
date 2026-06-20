document.addEventListener('DOMContentLoaded', () => {
  initSidebarToggle();
  initFabMenu();
  initParticles();
  initFormValidation();
});

// Full-screen loading spinner
window.addEventListener('load', () => {
  const loader = document.getElementById('snbd-loader');
  const progressBar = document.querySelector('.loader-progress-bar');
  if (loader && progressBar) {
    setTimeout(() => { progressBar.style.width = '100%'; }, 100);
    setTimeout(() => {
      loader.style.opacity = '0';
      loader.style.pointerEvents = 'none';
      setTimeout(() => loader.remove(), 400);
    }, 900);
  }
});



/* ---- Sidebar Toggle ---- */
function initSidebarToggle() {
  const toggleBtn = document.getElementById('sidebar-toggle-btn');
  const sidebar = document.getElementById('snbd-sidebar');
  const backdrop = document.getElementById('sidebarBackdrop');
  const icon = toggleBtn?.querySelector('i');

  if (!toggleBtn || !sidebar) return;

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
  });

  // Enforce correct icon on page load based on collapsed state
  if (sidebar.classList.contains('collapsed') && icon) {
    icon.className = 'ti ti-x';
  }

  // Close mobile sidebar on backdrop click
  backdrop?.addEventListener('click', () => {
    sidebar.classList.remove('mobile-open');
    backdrop.classList.remove('show');
    if (icon) icon.className = 'ti ti-menu-2';
  });

  // Close sidebar clicking outside on mobile
  document.addEventListener('click', (e) => {
    if (window.innerWidth <= 768 && sidebar.classList.contains('mobile-open')) {
      if (!sidebar.contains(e.target) && !toggleBtn.contains(e.target)) {
        sidebar.classList.remove('mobile-open');
        backdrop?.classList.remove('show');
        if (icon) icon.className = 'ti ti-menu-2';
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
    fabContainer.classList.toggle('active');
    fabMain.classList.toggle('active');
    if (fabContainer.classList.contains('active')) {
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

