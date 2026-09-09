/**
 * AYUSH CLINICAL EHR & ABDM DIGITAL HEALTH MISSION PORTAL
 * Master Interactive Controller — Smart India Hackathon Prototype
 */

(function () {
    'use strict';

    // Application Global State
    const AyushApp = {
        currentView: 'gateway',
        currentLang: 'EN',
        currentFontScale: 1.0,
        patientData: {
            name: 'Rajesh Sharma',
            nameHi: 'राजेश शर्मा',
            abhaId: '91-4523-8871-9012',
            prakriti: 'Vata-Pitta (वात-पित्त)',
            agni: 'Samagni (Balanced)',
            bp: '118/76',
            nadi: '72 bpm',
            pulseGati: 'Manduka Gati (Froglike / 76 bpm)'
        },
        triageQueue: [
            { token: 18, name: 'Sunita Mehra', abha: '91-4402-9912', priority: 'Urgent', wait: '4m', room: 'OPD-01', bp: '148/92' },
            { token: 19, name: 'Harish Chandra Das', abha: '91-0021-3994', priority: 'Senior', wait: '9m', room: 'OPD-03', prakriti: 'Vata' },
            { token: 20, name: 'Pooja Sharma', abha: '91-7712-4011', priority: 'Routine', wait: '12m', room: 'OPD-02', notes: 'Follow-up' },
            { token: 21, name: 'Mohd. Tariq Ansari', abha: '91-2311-9002', priority: 'Panchakarma', wait: '18m', room: 'Suite A', notes: 'Snehana Session' }
        ],
        auditTrail: [
            { time: '10:21 AM', actor: 'Dr. V. Sharma', action: 'Decrypted Record #91-4523 (K. Patel), Purpose: Consultation', badge: 'Consent Token Valid', color: 'green' },
            { time: '10:18 AM', actor: 'Nurse Anjali Rawat', action: 'Recorded Vitals & Prakriti screening for Token #17', badge: 'Triage Station 01', color: 'gray' },
            { time: '10:11 AM', actor: 'Pharmacist Mukesh', action: 'Dispensed e-Prescription for Record #91-3094', badge: 'ABDM FHIR Bundle Synced', color: 'green' },
            { time: '10:00 AM', actor: 'System Auto-Guardian', action: 'Automated hash check completed for 1,420 dispensary health records', badge: 'Zero Integrity Breach', color: 'blue' }
        ]
    };

    // Initialize Application
    document.addEventListener('DOMContentLoaded', () => {
        initNavigation();
        initAccessibility();
        initCaptcha();
        initDoseCountdown();
        initTriageForm();
        renderAuditTrail();
        renderQueueList();
        renderLucide();
    });

    function renderLucide() {
        if (window.lucide && typeof window.lucide.createIcons === 'function') {
            window.lucide.createIcons();
        }
    }

    // =========================================================================
    // VIEW ROUTING / SWITCHING
    // =========================================================================
    window.switchView = function (viewId) {
        AyushApp.currentView = viewId;

        // Hide all views
        document.querySelectorAll('.view-section').forEach(el => {
            el.style.display = 'none';
        });

        // Show selected view
        const target = document.getElementById('view-' + viewId);
        if (target) {
            target.style.display = 'block';
        }

        // Synchronize Nav Links (Top Nav + Sidebar)
        document.querySelectorAll('.primary-nav-link').forEach(link => {
            if (link.getAttribute('data-view') === viewId) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });

        document.querySelectorAll('.sidebar-nav-link').forEach(link => {
            if (link.getAttribute('data-view') === viewId) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });

        // Update document title
        const titles = {
            gateway: 'Ayush Clinical EHR — Government of India Digital Health Gateway',
            patient: 'Patient Health Locker — Ayush Clinical EHR (ABDM Integrated)',
            nursing: 'Nursing & Triage Dashboard — Ayushman Arogya Mandir',
            doctor: 'Doctor EHR Console — National Ayush Portal'
        };
        document.title = titles[viewId] || 'Ayush Clinical EHR';

        window.scrollTo({ top: 0, behavior: 'smooth' });
        setTimeout(renderLucide, 50);
    };

    function initNavigation() {
        document.querySelectorAll('[data-view-target]').forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const targetView = item.getAttribute('data-view-target');
                window.switchView(targetView);
            });
        });
    }

    // =========================================================================
    // ACCESSIBILITY & BILINGUAL ENGINE
    // =========================================================================
    function initAccessibility() {
        window.setFontScale = function (action) {
            if (action === 'decrease') {
                AyushApp.currentFontScale = 0.88;
            } else if (action === 'increase') {
                AyushApp.currentFontScale = 1.14;
            } else {
                AyushApp.currentFontScale = 1.0;
            }
            document.documentElement.style.setProperty('--font-scale', AyushApp.currentFontScale);

            document.querySelectorAll('.a11y-font-btn').forEach(btn => btn.classList.remove('active'));
            if (action === 'decrease') document.getElementById('font-btn-dec')?.classList.add('active');
            else if (action === 'increase') document.getElementById('font-btn-inc')?.classList.add('active');
            else document.getElementById('font-btn-reset')?.classList.add('active');
        };

        window.toggleLanguage = function () {
            AyushApp.currentLang = AyushApp.currentLang === 'EN' ? 'HI' : 'EN';
            const langLabel = document.getElementById('current-lang-text');
            if (langLabel) {
                langLabel.textContent = AyushApp.currentLang === 'EN' ? 'EN / HI' : 'हिन्दी / EN';
            }

            // Swap texts across elements with data-en and data-hi
            document.querySelectorAll('[data-en][data-hi]').forEach(el => {
                el.textContent = AyushApp.currentLang === 'EN' ? el.getAttribute('data-en') : el.getAttribute('data-hi');
            });

            // Update placeholders
            document.querySelectorAll('[data-placeholder-en][data-placeholder-hi]').forEach(el => {
                el.placeholder = AyushApp.currentLang === 'EN' ? el.getAttribute('data-placeholder-en') : el.getAttribute('data-placeholder-hi');
            });

            showToast(AyushApp.currentLang === 'EN' ? 'Language switched to English' : 'भाषा हिन्दी में बदली गई (Hindi Activated)');
        };
    }

    // =========================================================================
    // LOGIN / ROLE GATEWAY
    // =========================================================================
    const roleConfigs = {
        doctor: {
            title: 'NCISM / NCH / Ayush State Council Practitioner Login',
            badge: 'Ayush Practitioner ID',
            fieldLabel: 'National Practitioner Registry / Ayush Reg. Number *',
            placeholder: 'e.g., AY-DEL-2021-98421 or NMC/HPR-ID',
            defaultValue: 'AY-DEL-2021-98421',
            redirectView: 'doctor',
            btnText: 'चिकित्सक लॉगिन / Doctor Sign In'
        },
        patient: {
            title: 'Ayushman Bharat Digital Mission (ABDM) Patient Gateway',
            badge: '14-Digit ABHA ID / Aadhaar',
            fieldLabel: 'Universal ABHA ID or Linked Mobile Number *',
            placeholder: 'e.g., 91-4523-8871-9012 or 9876543210',
            defaultValue: '91-4523-8871-9012',
            redirectView: 'patient',
            btnText: 'स्वास्थ्य लॉकर प्रवेश / Patient ABHA Login'
        },
        nursing: {
            title: 'Dispensary Triage & Clinical Staff Console',
            badge: 'Staff Registry ID',
            fieldLabel: 'Nursing / Triage Officer Reg. ID *',
            placeholder: 'e.g., TRIAGE-DEL-04 or NURSE-9921',
            defaultValue: 'TRIAGE-DEL-04',
            redirectView: 'nursing',
            btnText: 'ट्राइएज लॉगिन / Triage Staff Sign In'
        },
        admin: {
            title: 'National Ayush Grid Facility Administrator Node',
            badge: 'HFR Facility SuperAdmin',
            fieldLabel: 'Facility HFR Code / NHA Admin Token *',
            placeholder: 'e.g., HFR-IN-DL-AY-8821',
            defaultValue: 'HFR-IN-DL-AY-8821',
            redirectView: 'nursing',
            btnText: 'प्रशासक लॉगिन / Facility Admin Login'
        }
    };

    window.switchLoginRole = function (roleKey) {
        document.querySelectorAll('.terminal-tab-btn').forEach(btn => {
            if (btn.getAttribute('data-role') === roleKey) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        const config = roleConfigs[roleKey];
        if (config) {
            document.getElementById('login-portal-badge').textContent = config.badge;
            document.getElementById('login-portal-title').textContent = config.title;
            document.getElementById('login-id-label').textContent = config.fieldLabel;
            const idInput = document.getElementById('login-id-input');
            if (idInput) {
                idInput.placeholder = config.placeholder;
                idInput.value = config.defaultValue;
            }
            const submitBtn = document.getElementById('login-submit-btn-text');
            if (submitBtn) {
                submitBtn.textContent = config.btnText;
            }
            document.getElementById('login-form').setAttribute('data-target-view', config.redirectView);
        }
    };

    function initCaptcha() {
        window.refreshCaptcha = function () {
            const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
            let code = '';
            for (let i = 0; i < 6; i++) {
                code += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            const visual = document.getElementById('captcha-display');
            if (visual) {
                visual.textContent = code.slice(0, 3) + ' ' + code.slice(3);
            }
        };
        window.refreshCaptcha();
    }

    window.handleLoginSubmit = function (e) {
        if (e) e.preventDefault();
        const form = document.getElementById('login-form');
        const targetView = form.getAttribute('data-target-view') || 'doctor';

        const submitBtn = document.getElementById('login-submit-btn');
        if (submitBtn) {
            submitBtn.innerHTML = `<span class="status-dot live pulse"></span> Authenticating via NIC Gateway...`;
            submitBtn.disabled = true;
        }

        setTimeout(() => {
            if (submitBtn) {
                submitBtn.innerHTML = `<i data-lucide="check"></i> 2FA Verified`;
                renderLucide();
            }
            showToast('ABDM Token Validated. Authenticated via e-Mudra/NIC Gateway.');
            setTimeout(() => {
                if (submitBtn) submitBtn.disabled = false;
                window.switchView(targetView);
            }, 600);
        }, 800);

        return false;
    };

    // =========================================================================
    // PATIENT HEALTH LOCKER ENGINE
    // =========================================================================
    function initDoseCountdown() {
        let totalSeconds = 1 * 3600 + 18 * 60; // 1h 18m
        const timerEl = document.getElementById('dose-countdown-timer');

        setInterval(() => {
            if (totalSeconds > 0) {
                totalSeconds--;
                const hrs = Math.floor(totalSeconds / 3600);
                const mins = Math.floor((totalSeconds % 3600) / 60);
                const secs = totalSeconds % 60;
                if (timerEl) {
                    timerEl.textContent = `(${hrs}h ${mins}m ${secs < 10 ? '0' : ''}${secs}s remaining)`;
                }
            }
        }, 1000);
    }

    window.switchLockerTab = function (tabId) {
        document.querySelectorAll('.locker-tab-btn').forEach(btn => {
            btn.classList.toggle('active', btn.getAttribute('data-locker-tab') === tabId);
        });

        document.querySelectorAll('.locker-tab-pane').forEach(pane => {
            pane.style.display = pane.id === 'locker-pane-' + tabId ? 'block' : 'none';
        });
        setTimeout(renderLucide, 30);
    };

    window.openConsentModal = function () {
        openModal('consent-modal');
    };

    window.openPrescriptionModal = function () {
        openModal('prescription-modal');
    };

    window.openXrayModal = function () {
        openModal('xray-modal');
    };

    window.copyAbhaId = function () {
        navigator.clipboard?.writeText(AyushApp.patientData.abhaId);
        showToast('ABHA ID (91-4523-8871-9012) copied to clipboard');
    };

    // =========================================================================
    // NURSING & TRIAGE ENGINE
    // =========================================================================
    function initTriageForm() {
        window.fetchAbhaVitals = function () {
            const abhaInput = document.getElementById('triage-abha-input').value.trim();
            const fetchBtn = document.getElementById('triage-fetch-btn');

            fetchBtn.innerHTML = `<span class="status-dot orange pulse"></span> Fetching...`;
            fetchBtn.disabled = true;

            setTimeout(() => {
                fetchBtn.innerHTML = `Fetch`;
                fetchBtn.disabled = false;

                // Populate form
                document.getElementById('triage-patient-banner').style.display = 'block';
                document.getElementById('triage-bp').value = '128/84';
                document.getElementById('triage-pulse').value = '74';
                document.getElementById('triage-spo2').value = '98';
                document.getElementById('triage-temp').value = '98.4';
                document.getElementById('triage-glucose').value = '112';
                document.getElementById('triage-weight').value = '71.5';

                // Select Pitta
                const pittaRadio = document.getElementById('prakriti-pitta');
                if (pittaRadio) pittaRadio.checked = true;

                showToast('ABHA Record Fetched: Rajesh Kumar Verma (48/M) verified via NHA node.');
            }, 650);
        };

        window.commitTriageVitals = function () {
            const bp = document.getElementById('triage-bp').value || '128/84';
            const priority = document.getElementById('triage-priority').value || 'Routine';
            const room = document.getElementById('triage-room').value || 'OPD-02';

            const nextToken = AyushApp.triageQueue.length + 18;
            const newPatient = {
                token: nextToken,
                name: 'Rajesh Kumar Verma',
                abha: '91-8834-2109',
                priority: priority,
                wait: '0m',
                room: room,
                bp: bp
            };

            AyushApp.triageQueue.unshift(newPatient);
            renderQueueList();

            // Add to audit trail
            AyushApp.auditTrail.unshift({
                time: 'Just now',
                actor: 'Nurse Anjali Rawat',
                action: `Triage intake completed & queued Token #${nextToken} to ${room}`,
                badge: 'Triage Station 01',
                color: 'green'
            });
            renderAuditTrail();

            // Increment count on KPI
            const queueCountEl = document.getElementById('kpi-queue-count');
            if (queueCountEl) {
                queueCountEl.textContent = parseInt(queueCountEl.textContent, 10) + 1;
            }

            showToast(`Patient Token #${nextToken} pushed to ${room} with ${priority} priority.`);
            renderLucide();
        };

        window.printTokenModal = function () {
            openModal('token-modal');
        };
    }

    function renderQueueList() {
        const container = document.getElementById('waiting-patients-container');
        if (!container) return;

        container.innerHTML = AyushApp.triageQueue.map(p => {
            let badgeClass = 'status-chip ready';
            if (p.priority === 'Urgent') badgeClass = 'status-chip critical';
            else if (p.priority === 'Senior') badgeClass = 'status-chip on-call';
            else if (p.priority === 'Panchakarma') badgeClass = 'status-chip therapy';

            return `
                <div class="queue-item-card">
                    <div class="queue-token-num">#${p.token}</div>
                    <div class="queue-patient-meta">
                        <div class="queue-name">
                            ${p.name}
                            <span class="${badgeClass}">${p.priority}</span>
                        </div>
                        <div class="queue-sub">
                            ABHA: ${p.abha} &bull; ${p.bp ? 'BP ' + p.bp : (p.prakriti ? 'Prakriti: ' + p.prakriti : p.notes)} &bull; Wait: ${p.wait}
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <span class="status-chip ready" style="font-size: 0.7rem;">${p.room}</span>
                    </div>
                </div>
            `;
        }).join('');
    }

    function renderAuditTrail() {
        const container = document.getElementById('audit-feed-container');
        if (!container) return;

        container.innerHTML = AyushApp.auditTrail.map(item => `
            <li class="audit-feed-item">
                <span class="audit-feed-dot" style="background-color: ${item.color === 'green' ? 'var(--color-green)' : (item.color === 'blue' ? 'var(--color-blue-info)' : '#94A3B8')}"></span>
                <div class="audit-actor">
                    <span>${item.actor}</span>
                    <span style="font-weight: 500; color: var(--color-text-muted);">${item.time}</span>
                </div>
                <div class="audit-desc">${item.action}</div>
                <div style="margin-top: 4px;">
                    <span class="status-chip ${item.color === 'green' ? 'ready' : (item.color === 'blue' ? 'on-call' : 'occupied')}" style="font-size: 0.65rem;">${item.badge}</span>
                </div>
            </li>
        `).join('');
    }

    // =========================================================================
    // DOCTOR EHR CONSOLE ENGINE
    // =========================================================================
    window.appendMedication = function () {
        const drug = document.getElementById('rx-drug-select').value;
        const form = document.getElementById('rx-form-select').value;
        const freq = document.getElementById('rx-freq-select').value;
        const kala = document.getElementById('rx-kala-select').value;
        const duration = document.getElementById('rx-duration-input').value || '21 Days';
        const anupana = document.getElementById('rx-anupana-input').value || 'Lukewarm ginger water';

        const listContainer = document.getElementById('prescription-items-list');
        if (!listContainer) return;

        const newItem = document.createElement('div');
        newItem.className = 'rx-item-card';
        newItem.innerHTML = `
            <div>
                <div class="rx-item-title">${drug} <span class="status-chip ready" style="font-size:0.65rem; margin-left:6px;">${form}</span></div>
                <div class="rx-item-meta">
                    <strong>Frequency:</strong> ${freq} &bull; <strong>Timing:</strong> ${kala} &bull; <strong>Anupana:</strong> ${anupana}
                </div>
                <div class="rx-item-meta" style="color: var(--color-text-muted);">
                    Duration: ${duration} &bull; Qty: 45 Units
                </div>
            </div>
            <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="this.closest('.rx-item-card').remove(); showToast('Medication removed from draft.');" title="Remove">
                <i data-lucide="trash-2" style="width:14px;height:14px;color:var(--color-red);"></i>
            </button>
        `;

        listContainer.appendChild(newItem);
        showToast(`Added ${drug} (${form}) to Prescription Draft.`);
        renderLucide();
    };

    window.signAndPushAbha = function () {
        const btn = document.getElementById('doctor-sign-push-btn');
        if (btn) {
            btn.innerHTML = `<span class="status-dot live pulse"></span> Signing with DSC Token...`;
            btn.disabled = true;
        }

        setTimeout(() => {
            if (btn) {
                btn.innerHTML = `<i data-lucide="check-check"></i> Digitally Signed & Synced`;
                btn.disabled = false;
            }
            showToast('e-Prescription digitally signed via DSC Token #AY-88321 and transmitted to Patient ABHA Locker #91-4523-8871-9012.');
            renderLucide();
        }, 900);
    };

    window.lockAppointment = function () {
        showToast('Follow-up locked for 11/04/2026. Official Ayush SMS & ABHA app push notification dispatched.');
    };

    // =========================================================================
    // MODAL DIALOG CONTROLS
    // =========================================================================
    function openModal(modalId) {
        const el = document.getElementById(modalId);
        if (el) {
            el.classList.add('active');
            renderLucide();
        }
    }

    window.closeModal = function (modalId) {
        const el = document.getElementById(modalId);
        if (el) {
            el.classList.remove('active');
        }
    };

    // Close on overlay background click
    document.addEventListener('click', (e) => {
        if (e.target.classList.contains('ayush-modal-overlay')) {
            e.target.classList.remove('active');
        }
    });

    // =========================================================================
    // TOAST NOTIFICATIONS
    // =========================================================================
    function showToast(message) {
        let toast = document.getElementById('ayush-toast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'ayush-toast';
            toast.style.position = 'fixed';
            toast.style.bottom = '24px';
            toast.style.right = '24px';
            toast.style.backgroundColor = 'var(--color-primary-dark)';
            toast.style.color = '#FFFFFF';
            toast.style.padding = '12px 20px';
            toast.style.borderRadius = '8px';
            toast.style.fontSize = '0.84rem';
            toast.style.fontWeight = '600';
            toast.style.boxShadow = '0 6px 18px rgba(0,0,0,0.2)';
            toast.style.zIndex = '3000';
            toast.style.transition = 'all 0.3s ease';
            toast.style.display = 'flex';
            toast.style.alignItems = 'center';
            toast.style.gap = '10px';
            document.body.appendChild(toast);
        }

        toast.innerHTML = `<span class="status-dot live"></span> ${message}`;
        toast.style.opacity = '1';
        toast.style.transform = 'translateY(0)';

        clearTimeout(toast._timeout);
        toast._timeout = setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(10px)';
        }, 3600);
    }

    window.showToast = showToast;

})();
