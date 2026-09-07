/**
 * MediKiosk Universal Accessibility & Responsiveness Engine (WCAG 2.1 AA)
 * Features:
 * - High Contrast Mode toggle & persistence
 * - Font Size Scaling (Normal, Large, Extra Large)
 * - Text-To-Speech Read Aloud Assist
 * - Screen Reader Live Announcer (aria-live="polite")
 * - Keyboard navigation shortcuts (Alt+C: Contrast, Alt+R: Read, Alt++ / Alt+-: Font)
 */

(function () {
  'use strict';

  const STORAGE_CONTRAST = 'mk_high_contrast';
  const STORAGE_FONT = 'mk_font_size';

  // Apply stored preferences immediately before rendering completes
  const savedContrast = localStorage.getItem(STORAGE_CONTRAST);
  if (savedContrast === 'true') {
    document.documentElement.classList.add('mk-high-contrast');
    if (document.body) document.body.classList.add('mk-high-contrast');
  }

  const savedFont = localStorage.getItem(STORAGE_FONT);
  if (savedFont) {
    document.documentElement.setAttribute('data-font-size', savedFont);
  }

  document.addEventListener('DOMContentLoaded', () => {
    // Sync body class
    if (document.documentElement.classList.contains('mk-high-contrast') && document.body) {
      document.body.classList.add('mk-high-contrast');
    }

    // Ensure live screen reader announcer exists
    if (!document.getElementById('mkA11yAnnouncer')) {
      const announcer = document.createElement('div');
      announcer.id = 'mkA11yAnnouncer';
      announcer.setAttribute('role', 'status');
      announcer.setAttribute('aria-live', 'polite');
      announcer.className = 'visually-hidden';
      document.body.appendChild(announcer);
    }

    // Initialize accessibility toolbar buttons if present
    updateToolbarUI();

    // Setup global keyboard shortcuts
    document.addEventListener('keydown', (e) => {
      // Alt + C: Toggle Contrast
      if (e.altKey && (e.key === 'c' || e.key === 'C')) {
        e.preventDefault();
        window.toggleContrast();
      }
      // Alt + + or Alt + =: Increase Font Size
      if (e.altKey && (e.key === '+' || e.key === '=')) {
        e.preventDefault();
        window.changeFontSize('increase');
      }
      // Alt + -: Decrease Font Size
      if (e.altKey && e.key === '-') {
        e.preventDefault();
        window.changeFontSize('decrease');
      }
      // Alt + 0: Reset Font Size
      if (e.altKey && e.key === '0') {
        e.preventDefault();
        window.changeFontSize('reset');
      }
      // Alt + R: Read Aloud active card / main content
      if (e.altKey && (e.key === 'r' || e.key === 'R')) {
        e.preventDefault();
        window.readAloudActiveSection();
      }
    });

    // Setup mobile sidebar toggle if present
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.mk-doctor-sidebar');
    if (sidebarToggle && sidebar) {
      sidebarToggle.addEventListener('click', () => {
        const isShown = sidebar.classList.toggle('show');
        sidebarToggle.setAttribute('aria-expanded', isShown ? 'true' : 'false');
      });
    }
  });

  // Announce to Screen Readers
  window.announceA11y = function (message) {
    const announcer = document.getElementById('mkA11yAnnouncer');
    if (announcer) {
      announcer.textContent = message;
    }
  };

  // High Contrast Mode Toggle
  window.toggleContrast = function () {
    const isHigh = document.documentElement.classList.toggle('mk-high-contrast');
    if (document.body) {
      document.body.classList.toggle('mk-high-contrast', isHigh);
    }
    localStorage.setItem(STORAGE_CONTRAST, isHigh ? 'true' : 'false');
    window.announceA11y(isHigh ? 'High contrast mode enabled' : 'High contrast mode disabled');
    updateToolbarUI();
  };

  // Font Size Scaling
  window.changeFontSize = function (action) {
    const current = document.documentElement.getAttribute('data-font-size') || 'normal';
    let next = 'normal';

    if (action === 'increase') {
      if (current === 'normal') next = 'lg';
      else if (current === 'lg') next = 'xl';
      else next = 'xl';
    } else if (action === 'decrease') {
      if (current === 'xl') next = 'lg';
      else if (current === 'lg') next = 'normal';
      else next = 'normal';
    } else {
      next = 'normal';
    }

    if (next === 'normal') {
      document.documentElement.removeAttribute('data-font-size');
      localStorage.removeItem(STORAGE_FONT);
      window.announceA11y('Font size set to default');
    } else {
      document.documentElement.setAttribute('data-font-size', next);
      localStorage.setItem(STORAGE_FONT, next);
      window.announceA11y('Font size increased to ' + (next === 'lg' ? 'large' : 'extra large'));
    }
    updateToolbarUI();
  };

  // Read Aloud Helper
  window.readAloudActiveSection = function () {
    if (!('speechSynthesis' in window)) {
      alert('Text-to-speech audio is not supported in this browser.');
      return;
    }
    window.speechSynthesis.cancel();

    // Find main question or primary card
    let target = document.querySelector('.mk-question-title') ||
                 document.querySelector('main h1, main h2') ||
                 document.querySelector('.mk-card');

    if (target) {
      const text = target.innerText.replace(/\s+/g, ' ').trim();
      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = text.match(/[\u0900-\u097F]/) ? 'hi-IN' : 'en-IN';
      window.speechSynthesis.speak(utterance);
      window.announceA11y('Reading content aloud');
    }
  };

  // Update Toolbar buttons visually
  function updateToolbarUI() {
    const isHigh = document.documentElement.classList.contains('mk-high-contrast');
    const contrastBtn = document.getElementById('a11yContrastBtn');
    if (contrastBtn) {
      contrastBtn.classList.toggle('active', isHigh);
      contrastBtn.setAttribute('aria-pressed', isHigh ? 'true' : 'false');
    }

    const currentFont = document.documentElement.getAttribute('data-font-size') || 'normal';
    const fontNormalBtn = document.getElementById('a11yFontNormal');
    const fontLgBtn = document.getElementById('a11yFontLg');
    const fontXlBtn = document.getElementById('a11yFontXl');

    if (fontNormalBtn) fontNormalBtn.classList.toggle('active', currentFont === 'normal');
    if (fontLgBtn) fontLgBtn.classList.toggle('active', currentFont === 'lg');
    if (fontXlBtn) fontXlBtn.classList.toggle('active', currentFont === 'xl');
  }

})();
