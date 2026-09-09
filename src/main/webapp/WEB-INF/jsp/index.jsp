<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ayush Clinical EHR — Government of India Digital Health Gateway</title>
    <meta name="description" content="National Ayush Clinical Electronic Health Record (EHR) and ABDM Integrated Dispensary Management System. Prototype for Smart India Hackathon.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=Noto+Sans+Devanagari:wght@400;500;600;700;800&family=Noto+Serif+Devanagari:wght@500;600;700&display=swap" rel="stylesheet">
    <!-- Lucide Icons UMD CDN -->
    <script src="https://cdn.jsdelivr.net/npm/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="/css/ayush-ehr.css">
</head>
<body>

    <!-- National Tricolor Top Stripe (Government of India) -->
    <div class="gov-tricolor-stripe" aria-hidden="true"></div>

    <!-- Official Government Micro-Header Bar -->
    <div class="gov-micro-header">
        <div class="gov-micro-left">
            <span>भारत सरकार | Government of India</span>
            <span style="color: var(--color-border);">&bull;</span>
            <span>आयुष मंत्रालय | Ministry of Ayush</span>
        </div>
        <div class="gov-micro-right">
            <a href="#mainAppContent" class="gov-micro-link" style="font-size:0.75rem;">Skip to Main Content</a>
            
            <!-- Font Size Scaling Controls -->
            <div class="a11y-font-group" role="group" aria-label="Font Size Controls">
                <button type="button" class="a11y-font-btn" id="font-btn-dec" onclick="setFontScale('decrease')" title="Decrease font size">A-</button>
                <button type="button" class="a11y-font-btn active" id="font-btn-reset" onclick="setFontScale('reset')" title="Standard font size">A</button>
                <button type="button" class="a11y-font-btn" id="font-btn-inc" onclick="setFontScale('increase')" title="Increase font size">A+</button>
            </div>

            <!-- Bilingual Toggle (EN / HI) -->
            <button type="button" class="lang-toggle-btn" onclick="toggleLanguage()" title="Switch Language / भाषा बदलें">
                <i data-lucide="languages" style="width:13px;height:13px;"></i>
                <span id="current-lang-text">EN / HI</span>
            </button>
        </div>
    </div>

    <!-- Official Portal Brand & Emblem Bar -->
    <header class="portal-brand-bar">
        <a href="/" class="portal-brand-wrapper" onclick="switchView('gateway'); return false;">
            <!-- Ashoka Emblem / Ayush Crest SVG -->
            <svg class="portal-emblem-svg" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="50" cy="50" r="47" stroke="#0B2559" stroke-width="2.5" fill="#FFFFFF"/>
                <circle cx="50" cy="50" r="43" stroke="#1E9E5A" stroke-width="1.2" fill="#F8FAFC"/>
                <!-- Lotus Petals -->
                <path d="M22 68 C32 60, 68 60, 78 68 C68 76, 32 76, 22 68 Z" fill="#F4811F"/>
                <path d="M50 22 L57 37 L73 37 L60 48 L65 64 L50 54 L35 64 L40 48 L27 37 L43 37 Z" fill="#0B2559"/>
                <!-- Ashoka Wheel -->
                <circle cx="50" cy="45" r="8" stroke="#1E9E5A" stroke-width="2" fill="#FFFFFF"/>
                <circle cx="50" cy="45" r="2.5" fill="#0B2559"/>
                <text x="50" y="85" font-size="6.8" font-weight="900" fill="#0B2559" text-anchor="middle" font-family="'Noto Sans Devanagari', sans-serif">सत्यमेव जयते</text>
            </svg>
            <div class="portal-brand-titles">
                <span class="brand-hindi" data-en="आयुष स्वास्थ्य ईएचआर पोर्टल" data-hi="आयुष स्वास्थ्य ईएचआर पोर्टल">आयुष स्वास्थ्य ईएचआर पोर्टल</span>
                <span class="brand-eng" data-en="Ayush Clinical EHR & ABDM Digital Health Mission Portal" data-hi="राष्ट्रीय आयुष क्लिनिकल ईएचआर एवं आभा डिजिटल हेल्थ मिशन पोर्टल">Ayush Clinical EHR & ABDM Digital Health Mission Portal</span>
            </div>
        </a>

        <!-- Portal Metadata & Profile -->
        <div class="portal-brand-meta">
            <div class="compliance-badge-pill abdm" title="ABDM Milestone 2 & 3 Certified Gateway">
                <i data-lucide="shield-check" style="width:14px;height:14px;"></i>
                <span>ABDM Compliant<br><strong style="font-size:0.68rem;">FHIR/HL7 M2 & M3</strong></span>
            </div>

            <div class="profile-avatar-pill" onclick="switchView('doctor')" title="Current Logged In Officer">
                <img src="/images/dr_priya.jpg" alt="Doctor Avatar" class="profile-thumb">
                <div class="profile-info">
                    <span class="profile-name">Dr. V. Sharma, MD (Ayu)</span>
                    <span class="profile-role">Senior Medical Officer</span>
                </div>
            </div>
        </div>
    </header>

    <!-- Master Primary Navigation Bar -->
    <nav class="portal-primary-nav">
        <ul class="primary-nav-links">
            <li class="primary-nav-item">
                <a class="primary-nav-link active" data-view="gateway" data-view-target="gateway">
                    <i data-lucide="home" style="width:15px;height:15px;"></i>
                    <span data-en="Home / Gateways" data-hi="गृह / प्रवेश द्वार">Home / Gateways</span>
                </a>
            </li>
            <li class="primary-nav-item">
                <a class="primary-nav-link" data-view="doctor" data-view-target="doctor">
                    <i data-lucide="stethoscope" style="width:15px;height:15px;"></i>
                    <span data-en="Doctor EHR Console" data-hi="चिकित्सक ईएचआर कंसोल">Doctor EHR Console</span>
                </a>
            </li>
            <li class="primary-nav-item">
                <a class="primary-nav-link" data-view="patient" data-view-target="patient">
                    <i data-lucide="folder-lock" style="width:15px;height:15px;"></i>
                    <span data-en="Patient Health Locker" data-hi="रोगी स्वास्थ्य लॉकर">Patient Health Locker</span>
                </a>
            </li>
            <li class="primary-nav-item">
                <a class="primary-nav-link" data-view="nursing" data-view-target="nursing">
                    <i data-lucide="activity" style="width:15px;height:15px;"></i>
                    <span data-en="Nursing & Triage" data-hi="नर्सिंग एवं ट्राइएज">Nursing & Triage</span>
                </a>
            </li>
            <li class="primary-nav-item">
                <a class="primary-nav-link" data-view-target="nursing">
                    <i data-lucide="building-2" style="width:15px;height:15px;"></i>
                    <span data-en="Clinic Admin" data-hi="क्लिनिक प्रशासन">Clinic Admin</span>
                </a>
            </li>
            <li class="primary-nav-item">
                <a class="primary-nav-link" onclick="openConsentModal()">
                    <i data-lucide="file-check-2" style="width:15px;height:15px;"></i>
                    <span>ABDM Compliance</span>
                </a>
            </li>
            <li class="primary-nav-item">
                <a class="primary-nav-link" onclick="showToast('Ayush 24/7 National Operations Helpdesk: 1800-11-2244')">
                    <i data-lucide="life-buoy" style="width:15px;height:15px;"></i>
                    <span>Contact & Support</span>
                </a>
            </li>
        </ul>

        <!-- Universal Search Bar -->
        <div style="display:flex; align-items:center; gap:12px;">
            <div class="universal-search-box">
                <i data-lucide="search" style="width:15px;height:15px;color:rgba(255,255,255,0.8);"></i>
                <input type="text" id="global-abha-search" placeholder="Universal ABHA ID / Health Record (14-digit)..." onkeydown="if(event.key==='Enter'){ showToast('Searching National ABDM Registry for: ' + this.value); switchView('patient'); }">
            </div>
            <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" style="border:none; background:rgba(255,255,255,0.15); color:#FFFFFF; border-radius:50%; width:34px; height:34px; padding:0;" onclick="showToast('System Notifications: 2 New FHIR Clinical Bundles Received from NHA Node.')" title="Notifications">
                <i data-lucide="bell" style="width:16px;height:16px;"></i>
            </button>
        </div>
    </nav>

    <!-- Circulars & Announcement Bar -->
    <div class="circular-ticker-bar">
        <div style="display:flex; align-items:center; overflow:hidden;">
            <span class="ticker-label-badge">
                <i data-lucide="megaphone" style="width:12px;height:12px;"></i>
                <span data-en="घोषणाएँ / Circulars" data-hi="घोषणाएँ / परिपत्र">घोषणाएँ / Circulars</span>
            </span>
            <div class="ticker-content">
                <span class="status-dot red pulse" style="margin-right:4px;"></span>
                <span>Mandate: Universal ABHA Linking (14-digit Health ID) mandatory for all nationwide Ayush Dispensaries by 30 June 2026.</span>
            </div>
        </div>
        <div class="ticker-sec-status">
            <i data-lucide="lock" style="width:12px;height:12px;color:var(--color-green);"></i>
            <span>Secure TLS 1.3 / NIC Gov Gateway</span>
        </div>
    </div>

    <!-- MAIN APPLICATION CONTAINER (SIDEBAR + CONTENT VIEWS) -->
    <div class="app-container" id="mainAppContent">

        <!-- Fixed Left Sidebar Navigation (Clinical Operations & Standards) -->
        <aside class="app-sidebar" id="appSidebar">
            <div class="sidebar-header">
                <div class="sidebar-facility-chip">
                    <span>ABHA Verified Facility</span>
                    <span class="chip-id">HFR #AY-8821</span>
                </div>
            </div>

            <div class="sidebar-nav-body">
                <div class="sidebar-section-title">CLINICAL OPERATIONS</div>
                <ul class="sidebar-nav-list">
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" data-view="doctor" data-view-target="doctor">
                            <i data-lucide="stethoscope" style="width:16px;height:16px;color:var(--color-primary);"></i>
                            <span>Doctor EHR Console</span>
                        </a>
                    </li>
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" data-view="patient" data-view-target="patient">
                            <i data-lucide="folder-heart" style="width:16px;height:16px;color:var(--color-primary);"></i>
                            <span>Patient Health Locker</span>
                        </a>
                    </li>
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" data-view="nursing" data-view-target="nursing">
                            <i data-lucide="activity-square" style="width:16px;height:16px;color:var(--color-primary);"></i>
                            <span>Nursing & Triage</span>
                            <span class="sidebar-badge">42</span>
                        </a>
                    </li>
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" onclick="showToast('Clinic Admin: 5/5 Consult Cabins Active | All 4 Vaidya Roster Staffed.')">
                            <i data-lucide="building" style="width:16px;height:16px;color:var(--color-primary);"></i>
                            <span>Clinic Admin</span>
                        </a>
                    </li>
                </ul>

                <div class="sidebar-section-title">STANDARDS & POLICY</div>
                <ul class="sidebar-nav-list">
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" onclick="openConsentModal()">
                            <i data-lucide="shield-alert" style="width:16px;height:16px;color:var(--color-green);"></i>
                            <span>ABDM Compliance</span>
                            <span class="sidebar-badge" style="background:#DCFCE7;color:#166534;">M2/M3</span>
                        </a>
                    </li>
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" data-view="gateway" data-view-target="gateway">
                            <i data-lucide="layout-grid" style="width:16px;height:16px;color:var(--color-primary);"></i>
                            <span>Portal Gateways</span>
                        </a>
                    </li>
                    <li class="sidebar-nav-item">
                        <a class="sidebar-nav-link" onclick="showToast('Support: ANGOC Operations Room: 1800-11-2244 | 24x7 Helpdesk Active')">
                            <i data-lucide="help-circle" style="width:16px;height:16px;color:var(--color-text-muted);"></i>
                            <span>Contact & Support</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="sidebar-footer">
                <div class="sidebar-sync-status">
                    <span class="status-dot live pulse"></span>
                    <div>
                        <strong>NIC Grid Cloud Sync: OK</strong><br>
                        <span style="color:var(--color-text-muted);font-size:0.68rem;">Data Protection: DPDP Act 2023</span>
                    </div>
                </div>
            </div>
        </aside>

        <!-- CONTENT AREA (MULTI-VIEW SWITCHING) -->
        <main class="app-content-area">

            <!-- VIEW 1: LOGIN / HOME GATEWAY -->
            <section id="view-gateway" class="view-section" style="display:block; padding: 24px;">
                
                <!-- Leadership Quotes / Government Banners -->
                <div class="gateway-hero-quotes">
                    <div class="gov-quote-card">
                        <img src="/images/pm_modi.jpg" alt="Hon'ble Prime Minister Narendra Modi" class="gov-quote-portrait">
                        <div class="gov-quote-body">
                            <div style="color:var(--color-saffron);font-size:1.8rem;line-height:1;margin-bottom:4px;">“</div>
                            <div class="gov-quote-hindi">
                                "पारंपरिक भारतीय चिकित्सा और आधुनिक विज्ञान का यह संगम पूरे विश्व के स्वास्थ्य कल्याण का मार्ग प्रशस्त करेगा। डिजिटल तकनीक और आयुष ग्रिड का यह विस्तार देश के अंतिम व्यक्ति तक स्वास्थ्य सेवा पहुँचाने की गारंटी है।"
                            </div>
                            <div class="gov-quote-eng">
                                "The fusion of classical Ayush medicine with cutting-edge digital infrastructure ensures sovereign, holistic well-being for 1.4 billion citizens."
                            </div>
                            <div class="gov-quote-author">श्री नरेन्द्र मोदी / Shri Narendra Modi</div>
                            <div class="gov-quote-designation">माननीय प्रधानमंत्री / Hon'ble Prime Minister</div>
                            <div style="margin-top:6px;">
                                <span class="category-top-tag classical" style="font-size:0.62rem;">
                                    <i data-lucide="check-circle" style="width:10px;height:10px;margin-right:4px;"></i>
                                    NATIONAL DIGITAL HEALTH VISION
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="gov-quote-card">
                        <img src="/images/minister_nadda.jpg" alt="Hon'ble Union Health Minister" class="gov-quote-portrait">
                        <div class="gov-quote-body">
                            <div style="color:var(--color-saffron);font-size:1.8rem;line-height:1;margin-bottom:4px;">“</div>
                            <div class="gov-quote-hindi">
                                "आयुष्मान भारत डिजिटल मिशन (ABDM) और आयुष क्लिनिकल ईएचआर पोर्टल के माध्यम से हम प्रत्येक नागरिक को पारदर्शी, सुरक्षित और पोर्टेबल डिजिटल स्वास्थ्य पहचान प्रदान कर रहे हैं।"
                            </div>
                            <div class="gov-quote-eng">
                                "Strengthening unified classical dispensaries through certified ABHA consent vaults, FHIR standards, and real-time electronic health records."
                            </div>
                            <div class="gov-quote-author">श्री जगत प्रकाश नड्डा / Shri J. P. Nadda</div>
                            <div class="gov-quote-designation">माननीय केंद्रीय मंत्री / Hon'ble Union Minister</div>
                            <div style="margin-top:6px;">
                                <span class="category-top-tag decoction" style="font-size:0.62rem;">
                                    <i data-lucide="shield-check" style="width:10px;height:10px;margin-right:4px;"></i>
                                    ABDM ECOSYSTEM MANDATE
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Login Gateway Grid -->
                <div class="gateway-main-grid">
                    <div class="login-terminal-card">
                        <div class="terminal-header">
                            <div style="display:flex;align-items:center;gap:10px;">
                                <i data-lucide="shield" style="width:20px;height:20px;color:var(--color-saffron);"></i>
                                <div>
                                    <div style="font-weight:800;font-size:0.92rem;">राष्ट्रीय आयुष एकीकृत प्रवेश द्वार</div>
                                    <div style="font-size:0.72rem;opacity:0.85;">National Ayush Unified Role-Based Access Terminal</div>
                                </div>
                            </div>
                            <div class="compliance-badge-pill gigw">
                                <span class="status-dot live pulse" style="background:#15803D;"></span>
                                <span>Live NHA/ABDM Node</span>
                            </div>
                        </div>

                        <div class="terminal-tabs" role="tablist">
                            <button type="button" class="terminal-tab-btn active" data-role="doctor" onclick="switchLoginRole('doctor')">
                                <i data-lucide="stethoscope" style="width:16px;height:16px;"></i>
                                <span>Doctor / Practitioner</span>
                                <span class="tab-sub">चिकित्सक</span>
                            </button>
                            <button type="button" class="terminal-tab-btn" data-role="patient" onclick="switchLoginRole('patient')">
                                <i data-lucide="user" style="width:16px;height:16px;"></i>
                                <span>Patient Health (ABHA)</span>
                                <span class="tab-sub">रोगी आभा</span>
                            </button>
                            <button type="button" class="terminal-tab-btn" data-role="nursing" onclick="switchLoginRole('nursing')">
                                <i data-lucide="activity" style="width:16px;height:16px;"></i>
                                <span>Nursing & Triage</span>
                                <span class="tab-sub">नर्सिंग / ट्राइएज</span>
                            </button>
                            <button type="button" class="terminal-tab-btn" data-role="admin" onclick="switchLoginRole('admin')">
                                <i data-lucide="key" style="width:16px;height:16px;"></i>
                                <span>Clinic / Super Admin</span>
                                <span class="tab-sub">प्रशासक</span>
                            </button>
                        </div>

                        <form id="login-form" class="login-form-body" onsubmit="return handleLoginSubmit(event)" data-target-view="doctor">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                                <div id="login-portal-title" style="font-size:0.84rem;font-weight:700;color:var(--color-primary);">
                                    NCISM / NCH / Ayush State Council Practitioner Login
                                </div>
                                <span id="login-portal-badge" class="category-top-tag classical">Ayush Practitioner ID</span>
                            </div>

                            <div style="margin-bottom:14px;">
                                <label id="login-id-label" class="form-label-ayush" for="login-id-input">
                                    National Practitioner Registry / Ayush Reg. Number *
                                </label>
                                <input type="text" id="login-id-input" class="form-control-ayush" value="AY-DEL-2021-98421" required>
                            </div>

                            <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;">
                                <div>
                                    <label class="form-label-ayush" for="login-password-input">Practitioner Password *</label>
                                    <input type="password" id="login-password-input" class="form-control-ayush" value="••••••••••••" required>
                                </div>
                                <div>
                                    <label class="form-label-ayush" for="login-2fa-select">2FA Authenticator Mode</label>
                                    <select id="login-2fa-select" class="form-control-ayush">
                                        <option value="aadhaar-otp">Aadhaar / Registered Mobile OTP</option>
                                        <option value="dsc-token">NIC Digital Signature (DSC USB)</option>
                                        <option value="biometric">Aadhaar Biometric RD Service</option>
                                    </select>
                                </div>
                            </div>

                            <div style="display:grid;grid-template-columns:1.2fr 1fr;gap:14px;align-items:center;margin-bottom:16px;">
                                <div class="captcha-box-wrap">
                                    <div id="captcha-display" class="captcha-visual">7KY 9M2</div>
                                    <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="refreshCaptcha()" title="Refresh Captcha">
                                        <i data-lucide="rotate-cw" style="width:14px;height:14px;"></i>
                                    </button>
                                    <input type="text" class="form-control-ayush" placeholder="Enter Captcha" value="7KY9M2" style="max-width:120px;" required>
                                </div>
                                <div style="display:flex;align-items:center;gap:8px;">
                                    <input type="checkbox" id="dsc-token-check" checked style="accent-color:var(--color-primary);width:16px;height:16px;">
                                    <label for="dsc-token-check" style="font-size:0.75rem;color:var(--color-text-secondary);cursor:pointer;">
                                        Login via DSC Token (e-Mudra/NIC)
                                    </label>
                                </div>
                            </div>

                            <div style="display:flex;justify-content:space-between;align-items:center;padding-top:10px;border-top:1px solid var(--color-border-subtle);">
                                <a href="#" onclick="showToast('HPR / NMC Registration Helpdesk: 1800-11-2244'); return false;" style="font-size:0.75rem;color:var(--color-red-dark);text-decoration:none;font-weight:600;">
                                    Forgot Password / Register in HPR (Healthcare Professionals)
                                </a>
                                <button type="submit" id="login-submit-btn" class="btn-ayush btn-ayush-primary" style="padding:10px 24px;">
                                    <span id="login-submit-btn-text">चिकित्सक लॉगिन / Doctor Sign In</span>
                                    <i data-lucide="arrow-right" style="width:16px;height:16px;"></i>
                                </button>
                            </div>

                            <div style="background:#F8FAFC;border:1px solid var(--color-border);border-radius:6px;padding:8px 12px;margin-top:16px;display:flex;justify-content:space-between;align-items:center;font-size:0.7rem;color:var(--color-text-muted);">
                                <span><i data-lucide="lock" style="width:12px;height:12px;margin-right:4px;"></i> Protected under Digital Personal Data Protection Act (DPDP) 2023 & EHR Standards of India.</span>
                                <strong>NIC-CERT-ID: #IND-AYU-8821</strong>
                            </div>
                        </form>
                    </div>

                    <div>
                        <div class="security-mandates-card">
                            <div style="display:flex;justify-content:space-between;align-items:center;">
                                <div style="font-size:0.92rem;font-weight:800;color:var(--color-primary);display:flex;align-items:center;gap:8px;">
                                    <i data-lucide="shield-check" style="width:18px;height:18px;color:var(--color-green);"></i>
                                    Security Mandates & Certifications
                                </div>
                                <span class="compliance-badge-pill gigw">GIGW 3.0</span>
                            </div>

                            <div class="mandates-grid">
                                <div class="mandate-box">
                                    <div class="mandate-box-title">
                                        <i data-lucide="database" style="width:14px;height:14px;color:var(--color-green);"></i>
                                        ABDM M1, M2 & M3
                                    </div>
                                    <div class="mandate-box-desc">
                                        NHA Fully Compliant Gateway for Ayush Grid
                                    </div>
                                </div>
                                <div class="mandate-box">
                                    <div class="mandate-box-title">
                                        <i data-lucide="file-key" style="width:14px;height:14px;color:var(--color-primary);"></i>
                                        HIPAA & DPDP 2023
                                    </div>
                                    <div class="mandate-box-desc">
                                        Confidential Clinical Vault & Patient Consent Manager
                                    </div>
                                </div>
                                <div class="mandate-box">
                                    <div class="mandate-box-title">
                                        <i data-lucide="lock" style="width:14px;height:14px;color:var(--color-red);"></i>
                                        AES-256 Bit Encryption
                                    </div>
                                    <div class="mandate-box-desc">
                                        End-to-End Encrypted Records in Transit and at Rest
                                    </div>
                                </div>
                                <div class="mandate-box">
                                    <div class="mandate-box-title">
                                        <i data-lucide="check-square" style="width:14px;height:14px;color:var(--color-saffron);"></i>
                                        STQC & ISO 27001
                                    </div>
                                    <div class="mandate-box-desc">
                                        Ministry of Electronics & IT Audited Infrastructure
                                    </div>
                                </div>
                            </div>

                            <div class="namaste-banner-bar">
                                <div>
                                    <div style="font-weight:800;letter-spacing:0.02em;">NAMASTE & ICD-11 Compatible</div>
                                    <div style="font-size:0.68rem;opacity:0.85;">Integrated Ayurveda, Siddha & Unani Formulary</div>
                                </div>
                                <span class="category-top-tag external" style="background:#FFFFFF;color:var(--color-primary);">v4.2.1</span>
                            </div>
                        </div>

                        <div class="mobile-download-card">
                            <div style="display:flex;justify-content:space-between;align-items:flex-start;">
                                <div>
                                    <span class="category-top-tag classical" style="font-size:0.65rem;margin-bottom:6px;">MOBILE HEALTHCARE ACCESS</span>
                                    <div style="font-size:0.95rem;font-weight:800;color:var(--color-primary);">Ayush Sanjivani & EHR App</div>
                                    <p style="font-size:0.75rem;color:var(--color-text-secondary);margin-top:4px;">
                                        Download official Android & iOS applications to consult accredited vaidyas, review ABHA lockers, and log Panchakarma progress.
                                    </p>
                                </div>
                                <i data-lucide="smartphone" style="width:28px;height:28px;color:var(--color-saffron);flex-shrink:0;"></i>
                            </div>

                            <div class="app-store-btns">
                                <a href="#" class="store-btn" onclick="showToast('Redirecting to Google Play Store: Ayush Sanjivani App'); return false;">
                                    <i data-lucide="play" style="width:16px;height:16px;color:var(--color-green);"></i>
                                    <div>
                                        <div style="font-size:0.62rem;text-transform:uppercase;color:var(--color-text-muted);">Download for</div>
                                        <div>Google Play</div>
                                    </div>
                                </a>
                                <a href="#" class="store-btn" onclick="showToast('Redirecting to Apple App Store: Ayush Sanjivani App'); return false;">
                                    <i data-lucide="apple" style="width:16px;height:16px;color:var(--color-primary);"></i>
                                    <div>
                                        <div style="font-size:0.62rem;text-transform:uppercase;color:var(--color-text-muted);">Available on</div>
                                        <div>Apple Store</div>
                                    </div>
                                </a>
                            </div>

                            <div style="margin-top:12px;padding-top:10px;border-top:1px solid var(--color-border-subtle);display:flex;justify-content:space-between;align-items:center;font-size:0.74rem;">
                                <span style="color:var(--color-text-secondary);"><i data-lucide="phone-call" style="width:12px;height:12px;margin-right:4px;"></i> National Ayush Tele-Desk</span>
                                <strong style="color:var(--color-saffron-dark);">Toll-Free: 1800-11-2244</strong>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats Strip -->
                <div class="stats-strip-grid">
                    <div class="stat-metric-card">
                        <div class="stat-metric-number">12,500+</div>
                        <div class="stat-metric-label">Functional Ayush Arogya Mandirs</div>
                        <div class="stat-metric-sub">Across 35 States & UTs</div>
                    </div>
                    <div class="stat-metric-card saffron">
                        <div class="stat-metric-number">4.8 Cr+</div>
                        <div class="stat-metric-label">EHR Consultations Recorded</div>
                        <div class="stat-metric-sub">Interoperable with ABDM</div>
                    </div>
                    <div class="stat-metric-card">
                        <div class="stat-metric-number">2.1 Lakh+</div>
                        <div class="stat-metric-label">Accredited Ayush Practitioners</div>
                        <div class="stat-metric-sub">Ayurveda, Yoga, Unani, Siddha, Homoeopathy</div>
                    </div>
                    <div class="stat-metric-card green">
                        <div class="stat-metric-number">100%</div>
                        <div class="stat-metric-label">DPDP & FHIR Compliance</div>
                        <div class="stat-metric-sub">Certified STQC & NIC Node</div>
                    </div>
                </div>

                <!-- Footer -->
                <footer class="ayush-gov-footer">
                    <div class="footer-top-grid">
                        <div>
                            <div style="font-weight:800;font-size:0.95rem;margin-bottom:8px;">Ministry of Ayush</div>
                            <p style="font-size:0.76rem;opacity:0.85;line-height:1.5;margin-bottom:12px;">
                                Government of India. Driving holistic healthcare, standardizing classical medicine electronic records, and unifying national clinical taxonomies through Ayush Grid.
                            </p>
                            <div style="display:flex;gap:8px;">
                                <span class="compliance-badge-pill cert" style="background:rgba(255,255,255,0.1);color:#FFFFFF;border-color:rgba(255,255,255,0.2);">ISO 27001</span>
                                <span class="compliance-badge-pill cert" style="background:rgba(255,255,255,0.1);color:#FFFFFF;border-color:rgba(255,255,255,0.2);">STQC Certified</span>
                            </div>
                        </div>

                        <div>
                            <div class="footer-col-title">CLINICAL MODULES</div>
                            <ul class="footer-links-list">
                                <li><a href="#" onclick="return false;">Ayurveda Clinical Terminology (NAMASTE)</a></li>
                                <li><a href="#" onclick="return false;">Unani & Siddha Morbidity Codes</a></li>
                                <li><a href="#" onclick="return false;">Homeopathy Formulary & Repertory</a></li>
                                <li><a href="#" onclick="return false;">ABHA Linked Patient Consent Manager</a></li>
                            </ul>
                        </div>

                        <div>
                            <div class="footer-col-title">REGULATORY & MANDATES</div>
                            <ul class="footer-links-list">
                                <li><a href="#" onclick="return false;">Ayushman Bharat Digital Mission (ABDM)</a></li>
                                <li><a href="#" onclick="return false;">National Health Authority (NHA)</a></li>
                                <li><a href="#" onclick="return false;">HIPAA & Data Protection DPDP 2023</a></li>
                                <li><a href="#" onclick="return false;">GIGW 3.0 Website Standards</a></li>
                            </ul>
                        </div>

                        <div>
                            <div class="footer-col-title">SUPPORT & EMERGENCY</div>
                            <p style="font-size:0.76rem;opacity:0.85;margin-bottom:8px;">
                                Ayush National Grid Operations Centre (ANGOC)
                            </p>
                            <div style="font-size:1.1rem;font-weight:800;color:var(--color-saffron);margin-bottom:6px;">
                                Toll-Free: 1800-11-2244
                            </div>
                            <div style="font-size:0.72rem;opacity:0.75;">Hours: 24/7 Clinical Desk Support</div>
                        </div>
                    </div>

                    <div class="footer-bottom-bar">
                        <div>
                            &copy; 2026 Ministry of Ayush, Government of India. All Rights Reserved. Ayushman Bharat Digital Mission (ABDM) Integrated.
                        </div>
                        <div style="display:flex;gap:14px;align-items:center;">
                            <span class="status-dot live" style="margin-right:4px;"></span>
                            <span>Last Updated: 24 May 2026 | Version 4.2.1-NIC</span>
                        </div>
                    </div>
                </footer>
            </section>

            <!-- VIEW 2: PATIENT HEALTH LOCKER -->
            <section id="view-patient" class="view-section" style="display:none; padding: 20px 24px;">
                <div style="background:#FFFFFF;border:1px solid var(--color-border);border-radius:6px;padding:6px 14px;margin-bottom:14px;display:flex;justify-content:space-between;align-items:center;font-size:0.74rem;">
                    <span style="font-weight:700;color:var(--color-primary);">भारत सरकार | GOVT. OF INDIA &bull; NATIONAL AYUSH GRID (ABDM-HFR/2026/DL-098)</span>
                    <div style="display:flex;align-items:center;gap:16px;">
                        <span style="color:var(--color-green-dark);font-weight:600;"><i data-lucide="shield-check" style="width:12px;height:12px;margin-right:4px;"></i> DPDP Act 2023 & ABDM Level-3 Certified</span>
                        <a href="tel:14443" class="emergency-sos-pill">
                            <i data-lucide="phone-call" style="width:12px;height:12px;"></i>
                            Toll-Free Ayush Helpline: 14443
                        </a>
                    </div>
                </div>

                <div class="patient-greeting-card">
                    <div class="patient-profile-top">
                        <div class="patient-id-cluster">
                            <img src="/images/patient_rajesh.jpg" alt="Rajesh Sharma" class="patient-headshot">
                            <div>
                                <div class="patient-name-title">
                                    <span>नमस्ते, राजेश शर्मा (Rajesh Sharma)</span>
                                </div>
                                <div style="display:flex;gap:8px;align-items:center;margin-top:4px;">
                                    <span class="compliance-badge-pill abdm" style="font-size:0.7rem;padding:2px 8px;">
                                        <i data-lucide="check" style="width:12px;height:12px;"></i>
                                        Aadhaar Linked & Verified
                                    </span>
                                    <div class="patient-abha-id">
                                        <span>ABHA ID: 91-4523-8871-9012</span>
                                        <button type="button" onclick="copyAbhaId()" style="background:none;border:none;cursor:pointer;color:var(--color-primary);" title="Copy ABHA ID">
                                            <i data-lucide="copy" style="width:12px;height:12px;"></i>
                                        </button>
                                    </div>
                                </div>
                                <div style="font-size:0.75rem;color:var(--color-text-secondary);margin-top:6px;">
                                    <i data-lucide="map-pin" style="width:12px;height:12px;color:var(--color-saffron);"></i>
                                    Central Ayurveda Research Institute, New Delhi &bull; Primary Vaidya: <strong>Dr. Priya Sharma (Reg. #DL-AY-4412)</strong>
                                </div>
                            </div>
                        </div>

                        <div style="display:flex;flex-direction:column;gap:8px;align-items:flex-end;">
                            <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="showToast('Launching Secure Tele-Ayush Video Consultation room...')">
                                <i data-lucide="video" style="width:14px;height:14px;"></i>
                                Join Tele-Ayush Consult
                            </button>
                            <div style="display:flex;gap:6px;">
                                <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="showToast('Opening Ayush OPD Slot Booking Calendar...')">
                                    <i data-lucide="calendar" style="width:13px;height:13px;"></i> Book Follow-Up Slot
                                </button>
                                <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="showToast('Port Record: Generating ABDM consent token for cross-dispensary transfer.')">
                                    <i data-lucide="share-2" style="width:13px;height:13px;"></i> Port Record
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="vitals-summary-strip">
                        <div class="vital-metric-cell">
                            <div class="vital-cell-icon prakriti"><i data-lucide="flame" style="width:18px;height:18px;"></i></div>
                            <div>
                                <div style="font-size:0.68rem;color:var(--color-text-muted);font-weight:700;">Diagnosed Prakriti</div>
                                <div style="font-size:0.86rem;font-weight:800;color:var(--color-primary);">Vata-Pitta (वात-पित्त)</div>
                            </div>
                        </div>
                        <div class="vital-metric-cell">
                            <div class="vital-cell-icon agni"><i data-lucide="zap" style="width:18px;height:18px;"></i></div>
                            <div>
                                <div style="font-size:0.68rem;color:var(--color-text-muted);font-weight:700;">Agni Status (Digestive Fire)</div>
                                <div style="font-size:0.86rem;font-weight:800;color:var(--color-green-dark);">Samagni (Balanced)</div>
                            </div>
                        </div>
                        <div class="vital-metric-cell">
                            <div class="vital-cell-icon nadi"><i data-lucide="activity" style="width:18px;height:18px;"></i></div>
                            <div>
                                <div style="font-size:0.68rem;color:var(--color-text-muted);font-weight:700;">Last Recorded Vitals</div>
                                <div style="font-size:0.86rem;font-weight:800;color:var(--color-primary);">BP 118/76 &bull; Nadi 72 bpm</div>
                            </div>
                        </div>
                        <div class="vital-metric-cell">
                            <div class="vital-cell-icon sos"><i data-lucide="shield-alert" style="width:18px;height:18px;"></i></div>
                            <div>
                                <div style="font-size:0.68rem;color:var(--color-red-dark);font-weight:700;">Emergency SOS Helpline</div>
                                <div style="font-size:0.86rem;font-weight:800;color:var(--color-red);">Direct Line: 14443</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="encrypted-locker-banner">
                    <div style="display:flex;gap:14px;align-items:center;">
                        <i data-lucide="lock" style="width:28px;height:28px;color:var(--color-saffron);flex-shrink:0;"></i>
                        <div>
                            <div style="font-weight:800;font-size:0.95rem;display:flex;align-items:center;gap:8px;">
                                AES-256 Bit Encrypted Ayush Health Locker
                                <span class="category-top-tag decoction" style="background:rgba(255,255,255,0.15);color:#FFFFFF;border-color:rgba(255,255,255,0.3);">ZERO-KNOWLEDGE VAULT</span>
                            </div>
                            <div style="font-size:0.75rem;opacity:0.85;margin-top:2px;">
                                Your holistic clinical consultations, botanical prescriptions, and Panchakarma records are strictly confidential and governed by the <strong>Digital Personal Data Protection (DPDP) Act 2023</strong> and Ayushman Bharat Consent Architecture.
                            </div>
                        </div>
                    </div>
                    <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="openConsentModal()">
                        <i data-lucide="key" style="width:14px;height:14px;"></i> Manage Doctor Consent (2 Active)
                    </button>
                </div>

                <div class="locker-tabs-nav">
                    <button type="button" class="locker-tab-btn active" data-locker-tab="prescriptions" onclick="switchLockerTab('prescriptions')">
                        <i data-lucide="pill" style="width:15px;height:15px;"></i> My Prescriptions & Medicines
                    </button>
                    <button type="button" class="locker-tab-btn" data-locker-tab="case-history" onclick="switchLockerTab('case-history')">
                        <i data-lucide="history" style="width:15px;height:15px;"></i> Clinical Case History & Follow-Up
                    </button>
                    <button type="button" class="locker-tab-btn" data-locker-tab="diagnostic" onclick="switchLockerTab('diagnostic')">
                        <i data-lucide="file-text" style="width:15px;height:15px;"></i> Encrypted Diagnostic Locker
                    </button>
                    <button type="button" class="locker-tab-btn" data-locker-tab="vitals" onclick="switchLockerTab('vitals')">
                        <i data-lucide="heart" style="width:15px;height:15px;"></i> Daily Vitals Journal
                    </button>
                </div>

                <div id="locker-pane-prescriptions" class="locker-tab-pane" style="display:block;">
                    <div class="dose-reminder-banner">
                        <div class="dose-reminder-left">
                            <i data-lucide="clock" style="width:24px;height:24px;color:var(--color-saffron-dark);flex-shrink:0;"></i>
                            <div>
                                <div style="font-size:0.86rem;font-weight:800;color:#9A3412;">
                                    IMMEDIATE NEXT DOSE REMINDER: Yogaraj Guggulu (योगराज गुग्गुलु) at 2:00 PM <span id="dose-countdown-timer">(1h 18m remaining)</span>
                                </div>
                                <div style="font-size:0.75rem;color:#7C2D12;margin-top:2px;">
                                    Take 2 tablets with Luke-warm water post lunch.
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="openPrescriptionModal()">
                            <i data-lucide="download" style="width:13px;height:13px;"></i> Download Official Signed e-Prescription (PDF)
                        </button>
                    </div>

                    <div class="medications-grid">
                        <div class="medication-card">
                            <div>
                                <div class="med-header">
                                    <div>
                                        <span class="category-top-tag classical">AYURVEDA CLASSICAL</span>
                                        <div class="med-name" style="margin-top:4px;">Yogaraj Guggulu</div>
                                        <div class="med-name-hindi">योगराज गुग्गुलु (Vata-Shamana)</div>
                                    </div>
                                    <i data-lucide="pill" style="width:20px;height:20px;color:var(--color-saffron);"></i>
                                </div>
                                <div class="med-detail-list">
                                    <div class="med-detail-row"><span>Dosage:</span><strong>2 Tablets (500mg each)</strong></div>
                                    <div class="med-detail-row"><span>Frequency:</span><strong>Twice Daily (Morning / Noon)</strong></div>
                                    <div class="med-detail-row"><span>Anupana:</span><strong style="color:var(--color-saffron-dark);">Luke-warm ginger water</strong></div>
                                </div>
                                <div style="margin-top:10px;">
                                    <div style="display:flex;justify-content:space-between;font-size:0.72rem;font-weight:700;margin-bottom:4px;">
                                        <span>Course Progress</span><span>Day 11 of 21</span>
                                    </div>
                                    <div class="progress-bar-container"><div class="progress-fill saffron" style="width: 52%;"></div></div>
                                </div>
                            </div>
                            <div style="margin-top:16px;padding-top:10px;border-top:1px solid var(--color-border-subtle);display:flex;justify-content:space-between;font-size:0.72rem;">
                                <span>Next: Today, 2:00 PM</span>
                                <a href="#" onclick="showToast('Yogaraj Guggulu instructions displayed.'); return false;" style="color:var(--color-primary);font-weight:700;text-decoration:none;">Instructions &rarr;</a>
                            </div>
                        </div>

                        <div class="medication-card">
                            <div>
                                <div class="med-header">
                                    <div>
                                        <span class="category-top-tag decoction">DECOCTION (KASHAYA)</span>
                                        <div class="med-name" style="margin-top:4px;">Maharasnadi Kwath</div>
                                        <div class="med-name-hindi">महारास्नादि क्वाथ (Joint & Neural Ease)</div>
                                    </div>
                                    <i data-lucide="beaker" style="width:20px;height:20px;color:var(--color-green);"></i>
                                </div>
                                <div class="med-detail-list">
                                    <div class="med-detail-row"><span>Dosage:</span><strong>15 ml + 60ml water</strong></div>
                                    <div class="med-detail-row"><span>Frequency:</span><strong>Early Morning (Empty Stomach)</strong></div>
                                    <div class="med-detail-row"><span>Anupana:</span><strong style="color:var(--color-green-dark);">Warm boiled water</strong></div>
                                </div>
                                <div style="margin-top:10px;">
                                    <div style="display:flex;justify-content:space-between;font-size:0.72rem;font-weight:700;margin-bottom:4px;">
                                        <span>Course Progress</span><span>Day 11 of 21</span>
                                    </div>
                                    <div class="progress-bar-container"><div class="progress-fill green" style="width: 52%;"></div></div>
                                </div>
                            </div>
                            <div style="margin-top:16px;padding-top:10px;border-top:1px solid var(--color-border-subtle);display:flex;justify-content:space-between;font-size:0.72rem;">
                                <span style="color:var(--color-green);font-weight:700;">Completed at 07:30 AM &check;</span>
                                <span class="status-chip ready">Refill Alert: OK</span>
                            </div>
                        </div>

                        <div class="medication-card">
                            <div>
                                <div class="med-header">
                                    <div>
                                        <span class="category-top-tag external">EXTERNAL APPLICATION (TAILA)</span>
                                        <div class="med-name" style="margin-top:4px;">Mahanarayana Taila</div>
                                        <div class="med-name-hindi">महानारायण तेल (Abhyanga / Knee Joint)</div>
                                    </div>
                                    <i data-lucide="droplet" style="width:20px;height:20px;color:var(--color-blue-info);"></i>
                                </div>
                                <div class="med-detail-list">
                                    <div class="med-detail-row"><span>Usage:</span><strong>Gentle massage on lumbar & knees</strong></div>
                                    <div class="med-detail-row"><span>Timing:</span><strong>Evening at 6:30 PM with steam</strong></div>
                                    <div class="med-detail-row"><span>Post-App:</span><strong>Hot towel fomentation (10 mins)</strong></div>
                                </div>
                                <div style="margin-top:10px;">
                                    <div style="display:flex;justify-content:space-between;font-size:0.72rem;font-weight:700;margin-bottom:4px;">
                                        <span>Stock Left</span><span>~140 ml (7 days remaining)</span>
                                    </div>
                                    <div class="progress-bar-container"><div class="progress-fill red" style="width: 35%;"></div></div>
                                </div>
                            </div>
                            <div style="margin-top:16px;padding-top:10px;border-top:1px solid var(--color-border-subtle);display:flex;justify-content:space-between;font-size:0.72rem;">
                                <span>Scheduled: 06:30 PM</span>
                                <a href="#" onclick="showToast('Video Guide for Abhyanga opened.'); return false;" style="color:var(--color-primary);font-weight:700;text-decoration:none;">Video Guide &rarr;</a>
                            </div>
                        </div>
                    </div>

                    <!-- Pathya / Apathya -->
                    <div class="pathya-apathya-grid">
                        <div class="pathya-card">
                            <div style="font-size:0.92rem;font-weight:800;color:var(--color-green-dark);margin-bottom:14px;">
                                <i data-lucide="check-circle-2" style="width:18px;height:18px;color:var(--color-green);margin-right:6px;"></i>
                                पथ्य (Pathya - Recommended Lifestyle & Foods)
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="check" style="width:16px;height:16px;color:var(--color-green);"></i>
                                <div><strong>Warm, moist foods:</strong> Moong dal soup, aged rice (Purana Shali), bottle gourd, tender drumstick.</div>
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="check" style="width:16px;height:16px;color:var(--color-green);"></i>
                                <div><strong>Healthy fats:</strong> 1 tsp A2 Desi Cow Ghee infused with cumin or turmeric in warm lunch.</div>
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="check" style="width:16px;height:16px;color:var(--color-green);"></i>
                                <div><strong>Regimen:</strong> Regular sleep before 10:00 PM, morning exposure to gentle sunrise for 20 minutes.</div>
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="check" style="width:16px;height:16px;color:var(--color-green);"></i>
                                <div><strong>Hydration:</strong> Boiled water cooled to warm temperature with a pinch of dry ginger (Shunti).</div>
                            </div>
                        </div>

                        <div class="apathya-card">
                            <div style="font-size:0.92rem;font-weight:800;color:var(--color-red-dark);margin-bottom:14px;">
                                <i data-lucide="x-circle" style="width:18px;height:18px;color:var(--color-red);margin-right:6px;"></i>
                                अपथ्य (Apathya - Strict Restrictions & Contraindications)
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="x" style="width:16px;height:16px;color:var(--color-red);"></i>
                                <div><strong>Cold & Stale Diet:</strong> Avoid refrigerated food, curd at night, ice water, aerated drinks.</div>
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="x" style="width:16px;height:16px;color:var(--color-red);"></i>
                                <div><strong>Vata Aggravators:</strong> Raw salads, chickpeas (chana), deep-fried snacks, maida bakery products.</div>
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="x" style="width:16px;height:16px;color:var(--color-red);"></i>
                                <div><strong>Habits:</strong> High-speed AC vents, sleeping in day time (Divaswapna), suppressing natural urges.</div>
                            </div>
                            <div class="regimen-item">
                                <i data-lucide="x" style="width:16px;height:16px;color:var(--color-red);"></i>
                                <div><strong>Strenuous Exertion:</strong> Heavy running or squats until knee swelling recedes completely.</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="locker-pane-case-history" class="locker-tab-pane" style="display:none;">
                    <div class="clinical-card card-body-pad">
                        <div class="card-title-lg" style="margin-bottom:12px;">Clinical Consultation History</div>
                        <div class="queue-item-card">
                            <div class="queue-token-num">#14</div>
                            <div class="queue-patient-meta">
                                <div class="queue-name">Follow-up: Sandhivata <span class="status-chip ready">Verified</span></div>
                                <div class="queue-sub">Central Ayurveda Research Institute &bull; Dr. Priya Sharma MD &bull; 28 Oct 2026</div>
                            </div>
                            <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="openPrescriptionModal()">View Summary</button>
                        </div>
                    </div>
                </div>

                <div id="locker-pane-diagnostic" class="locker-tab-pane" style="display:none;">
                    <div class="clinical-card card-body-pad">
                        <div class="card-title-lg" style="margin-bottom:12px;">Encrypted Diagnostic Locker</div>
                        <div class="medication-card" style="cursor:pointer;" onclick="openXrayModal()">
                            <div style="display:flex;gap:12px;align-items:center;">
                                <img src="/images/knee_xray.jpg" alt="X-Ray Thumbnail" style="width:64px;height:64px;border-radius:6px;object-fit:cover;">
                                <div>
                                    <div style="font-weight:800;font-size:0.86rem;color:var(--color-primary);">Digital X-Ray Bilateral Knees</div>
                                    <div style="font-size:0.72rem;color:var(--color-text-muted);">Govt District Hospital &bull; 12 Sep 2026</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="locker-pane-vitals" class="locker-tab-pane" style="display:none;">
                    <div class="clinical-card card-body-pad">
                        <div class="card-title-lg" style="margin-bottom:12px;">Daily Dinacharya Journal</div>
                        <p style="font-size:0.78rem;color:var(--color-text-secondary);">Sleep: 7.5 hrs &bull; Stiffness: 15 mins &bull; Hydration: 2.2 L</p>
                    </div>
                </div>
            </section>

            <!-- VIEW 3: NURSING & TRIAGE DASHBOARD -->
            <section id="view-nursing" class="view-section" style="display:none; padding: 20px 24px;">
                <div class="triage-unit-header">
                    <div>
                        <div style="font-size:1.05rem;font-weight:800;color:var(--color-primary);">
                            AYUSHMAN AROGYA MANDIR OPD Unit #DL-ND-04
                        </div>
                        <div style="font-size:0.74rem;color:var(--color-text-secondary);">
                            Ayush Triage & Administrative Console &bull; राष्ट्रीय स्वास्थ्य मिशन (NHM) सहकार्य
                        </div>
                    </div>
                    <div style="display:flex;align-items:center;gap:10px;">
                        <span class="compliance-badge-pill abdm"><span class="status-dot live pulse"></span> ABDM Gateway Active</span>
                        <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="showToast('Scanning ABHA QR Code...')">
                            <i data-lucide="scan-line" style="width:14px;height:14px;"></i> Quick ABHA Scan
                        </button>
                    </div>
                </div>

                <div class="kpi-stat-strip">
                    <div class="kpi-card">
                        <div class="kpi-top"><span class="kpi-title">Today's OPD Queue</span><i data-lucide="users" style="width:16px;height:16px;"></i></div>
                        <div class="kpi-num" id="kpi-queue-count">42</div>
                        <div style="font-size:0.7rem;color:var(--color-text-muted);margin-bottom:6px;">18 Waiting &bull; 16 Consult &bull; 8 Done</div>
                        <div class="segmented-queue-bar"><div class="seg-waiting" style="width: 42%;"></div><div class="seg-consult" style="width: 38%;"></div><div class="seg-done" style="width: 20%;"></div></div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-top"><span class="kpi-title">Active Doctors</span><i data-lucide="stethoscope" style="width:16px;height:16px;color:var(--color-green);"></i></div>
                        <div class="kpi-num" style="color:var(--color-green-dark);">6 On Duty</div>
                        <div style="font-size:0.7rem;color:var(--color-text-muted);">&check; All 4 OPD Cabins Staffed</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-top"><span class="kpi-title">Triage Avg Wait</span><i data-lucide="timer" style="width:16px;height:16px;color:var(--color-saffron-dark);"></i></div>
                        <div class="kpi-num" style="color:var(--color-saffron-dark);">11 Mins</div>
                        <div style="font-size:0.7rem;color:var(--color-green);font-weight:700;">&darr; 4m below benchmark</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-top"><span class="kpi-title">Urgent / Emergency</span><i data-lucide="alert-triangle" style="width:16px;height:16px;color:var(--color-red);"></i></div>
                        <div class="kpi-num">0 Cases</div>
                        <div style="font-size:0.7rem;color:var(--color-green);">&check; No critical escalation</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-top"><span class="kpi-title">HIPAA / DPDP Audit</span><i data-lucide="shield-check" style="width:16px;height:16px;color:var(--color-green);"></i></div>
                        <div class="kpi-num" style="color:var(--color-green-dark);">100% Valid</div>
                        <div style="font-size:0.7rem;color:var(--color-text-muted);">&check; Fully Encrypted Logs</div>
                    </div>
                </div>

                <div class="triage-master-columns">
                    <div>
                        <div class="clinical-card" style="margin-bottom:18px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg"><i data-lucide="heart-pulse"></i> Triage Intake & Vitals</div>
                                <span class="category-top-tag classical">Live Intake</span>
                            </div>
                            <div class="card-body-pad">
                                <div style="display:flex;gap:8px;margin-bottom:12px;">
                                    <input type="text" id="triage-abha-input" class="form-control-ayush" value="91-8834-2109">
                                    <button type="button" id="triage-fetch-btn" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="fetchAbhaVitals()">Fetch</button>
                                </div>
                                <div id="triage-patient-banner" style="background:#F0FDF4;border:1px solid #BBF7D0;border-radius:6px;padding:8px 12px;margin-bottom:12px;display:flex;justify-content:space-between;font-size:0.74rem;">
                                    <span><strong>Patient:</strong> Rajesh Kumar Verma (48/M)</span>
                                    <span class="compliance-badge-pill abdm">&check; Verified</span>
                                </div>
                                <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:12px;">
                                    <div><label class="form-label-ayush">Blood Pressure</label><input type="text" id="triage-bp" class="form-control-ayush" value="128/84"></div>
                                    <div><label class="form-label-ayush">Pulse / Nadi</label><input type="text" id="triage-pulse" class="form-control-ayush" value="74"></div>
                                    <div><label class="form-label-ayush">SpO2 Level</label><input type="text" id="triage-spo2" class="form-control-ayush" value="98"></div>
                                </div>
                                <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-bottom:14px;">
                                    <div><label class="form-label-ayush">Body Temp</label><input type="text" id="triage-temp" class="form-control-ayush" value="98.4"></div>
                                    <div><label class="form-label-ayush">Random Glucose</label><input type="text" id="triage-glucose" class="form-control-ayush" value="112"></div>
                                    <div><label class="form-label-ayush">Weight / BMI</label><input type="text" id="triage-weight" class="form-control-ayush" value="71.5"></div>
                                </div>
                                <div style="background:#F8FAFC;border:1px solid var(--color-border);border-radius:6px;padding:10px;margin-bottom:14px;">
                                    <div style="font-size:0.74rem;font-weight:700;margin-bottom:6px;">Ayush Prakriti Quick Screener</div>
                                    <div style="display:flex;gap:14px;font-size:0.76rem;">
                                        <label><input type="radio" name="prakriti-screener" value="Vata"> Vata</label>
                                        <label><input type="radio" id="prakriti-pitta" name="prakriti-screener" value="Pitta" checked> Pitta</label>
                                        <label><input type="radio" name="prakriti-screener" value="Kapha"> Kapha</label>
                                    </div>
                                </div>
                                <div style="display:grid;grid-template-columns:1fr 1.2fr;gap:10px;margin-bottom:14px;">
                                    <div><label class="form-label-ayush">Triage Priority</label><select id="triage-priority" class="form-control-ayush"><option value="Routine">Routine OPD</option><option value="Urgent">Urgent</option><option value="Senior">Senior</option><option value="Panchakarma">Panchakarma</option></select></div>
                                    <div><label class="form-label-ayush">Assign Room</label><select id="triage-room" class="form-control-ayush"><option value="OPD-02">OPD-02: Dr. Sunita Roy</option><option value="OPD-01">OPD-01: Dr. V. Sharma</option></select></div>
                                </div>
                                <div style="display:flex;gap:8px;">
                                    <button type="button" class="btn-ayush btn-ayush-primary" style="flex:1;" onclick="commitTriageVitals()">Commit Vitals & Push</button>
                                    <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="printTokenModal()">Token</button>
                                </div>
                            </div>
                        </div>

                        <div class="clinical-card">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Waiting Patients Queue</div>
                                <span class="category-top-tag classical">Live Sync</span>
                            </div>
                            <div class="card-body-pad" id="waiting-patients-container"></div>
                        </div>
                    </div>

                    <div>
                        <div class="clinical-card" style="margin-bottom:18px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Room Allocation & Status</div>
                                <span class="status-chip ready">5/5 Active</span>
                            </div>
                            <div class="card-body-pad">
                                <div class="room-status-item">
                                    <div><div class="room-name">OPD 1 &bull; Kayachikitsa</div><div class="room-doctor">Dr. V. Sharma (Token #16)</div></div>
                                    <span class="status-chip occupied">Occupied</span>
                                </div>
                                <div class="room-status-item">
                                    <div><div class="room-name">OPD 2 &bull; Panchakarma</div><div class="room-doctor">Dr. Sunita Roy</div></div>
                                    <span class="status-chip ready">Ready</span>
                                </div>
                                <div class="room-status-item">
                                    <div><div class="room-name">Panchakarma Suite A</div><div class="room-doctor">Therapist Ramesh</div></div>
                                    <span class="status-chip therapy">Therapy</span>
                                </div>
                            </div>
                        </div>

                        <div class="clinical-card" style="margin-bottom:18px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Staff Roster & Attendance</div>
                            </div>
                            <div class="card-body-pad">
                                <div class="room-status-item">
                                    <div><div class="room-name">Nurse Anjali Rawat</div><div class="room-doctor">Lead Triage &bull; 08:00 - 16:00</div></div>
                                    <span class="status-chip present">Present</span>
                                </div>
                                <div class="room-status-item">
                                    <div><div class="room-name">Mukesh Singh</div><div class="room-doctor">Chief Pharmacist</div></div>
                                    <span class="status-chip present">Present</span>
                                </div>
                            </div>
                        </div>

                        <div class="clinical-card">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Dispensary Stock Alerts</div>
                                <span class="status-chip auto-indent">2 Reorders</span>
                            </div>
                            <div class="card-body-pad">
                                <div style="margin-bottom:12px;">
                                    <div style="display:flex;justify-content:space-between;font-size:0.8rem;">
                                        <strong>Triphala Churna (250g)</strong><span style="color:var(--color-red-dark);font-weight:700;">14 packs left</span>
                                    </div>
                                    <div class="progress-bar-container" style="margin:4px 0;"><div class="progress-fill saffron" style="width: 28%;"></div></div>
                                    <span class="status-chip auto-indent" style="font-size:0.65rem;">Auto-Indent Raised</span>
                                </div>
                                <div>
                                    <div style="display:flex;justify-content:space-between;font-size:0.8rem;">
                                        <strong>Mahanarayana Taila (500ml)</strong><span style="color:var(--color-red);font-weight:800;">6 bottles left</span>
                                    </div>
                                    <div class="progress-bar-container" style="margin:4px 0;"><div class="progress-fill red" style="width: 15%;"></div></div>
                                    <span class="status-chip critical" style="font-size:0.65rem;">Critical Low</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="clinical-card" style="margin-bottom:18px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Compliance Audit</div>
                                <span class="category-top-tag decoction">DPDP Act 2023</span>
                            </div>
                            <div class="card-body-pad">
                                <ul class="audit-feed-list" id="audit-feed-container"></ul>
                            </div>
                        </div>

                        <div class="clinical-card">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Encryption & Vault</div>
                                <span class="status-chip ready">FIPS 140-3</span>
                            </div>
                            <div class="card-body-pad" style="font-size:0.75rem;">
                                <div style="display:flex;justify-content:space-between;padding:4px 0;"><span>Database:</span><strong>AES-256 (GCM)</strong></div>
                                <div style="display:flex;justify-content:space-between;padding:4px 0;"><span>Network:</span><strong>TLS 1.3 Strict</strong></div>
                                <div style="display:flex;justify-content:space-between;padding:4px 0;"><span>ABDM Bridge:</span><strong style="color:var(--color-green-dark);">&check; Active</strong></div>
                                <div style="margin-top:10px;">
                                    <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" style="width:100%;" onclick="showToast('Compliance report exported.');">Export Compliance Report</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- VIEW 4: DOCTOR EHR CONSOLE -->
            <section id="view-doctor" class="view-section" style="display:none; padding: 20px 24px;">
                <div class="doctor-on-duty-bar">
                    <div style="display:flex;align-items:center;gap:14px;">
                        <img src="/images/dr_priya.jpg" alt="Dr Priya Sharma" style="width:42px;height:42px;border-radius:50%;object-fit:cover;border:2px solid var(--color-green);">
                        <div>
                            <div style="font-size:0.95rem;font-weight:800;color:var(--color-primary);">
                                Dr. Priya Sharma, MD (Ayurveda) <span class="category-top-tag classical">Reg #AY-88321</span>
                            </div>
                            <div style="font-size:0.74rem;color:var(--color-text-secondary);margin-top:2px;">
                                <span class="status-dot live"></span> On Duty &bull; Ayush OPD Room 102 &bull; Shift 08:30 - 15:30 IST
                            </div>
                        </div>
                    </div>
                    <div style="display:flex;align-items:center;gap:8px;">
                        <span class="compliance-badge-pill abdm">Digital Signature Token Active</span>
                        <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="showToast('Loading next patient...')">Next Patient (Queue: 9)</button>
                    </div>
                </div>

                <div class="current-patient-bar">
                    <div style="display:flex;align-items:center;gap:14px;">
                        <img src="/images/patient_rajesh.jpg" alt="Rajesh Sharma" style="width:50px;height:50px;border-radius:50%;object-fit:cover;">
                        <div>
                            <div style="font-size:1.1rem;font-weight:800;color:var(--color-primary);">Rajesh Sharma (Male, 48 Yrs) <span class="category-top-tag classical">Token #14</span></div>
                            <div style="font-size:0.74rem;color:var(--color-text-secondary);">ABHA: 91-4523-8871-9012 &bull; &check; ABHA Consent: Active & Linked</div>
                        </div>
                    </div>
                    <div style="display:flex;align-items:center;gap:16px;">
                        <div class="vital-metric-cell"><div><div style="font-size:0.68rem;color:var(--color-text-muted);">PRAKRITI</div><div style="font-size:0.8rem;font-weight:800;">Vata-Pitta</div></div></div>
                        <div class="vital-metric-cell"><div><div style="font-size:0.68rem;color:var(--color-text-muted);">PULSE</div><div style="font-size:0.8rem;font-weight:800;">Manduka Gati (76 bpm)</div></div></div>
                        <div class="vital-metric-cell"><div><div style="font-size:0.68rem;color:var(--color-text-muted);">AGNI</div><div style="font-size:0.8rem;font-weight:800;color:var(--color-green-dark);">Vishamagni</div></div></div>
                    </div>
                </div>

                <div class="doctor-console-grid">
                    <div>
                        <div class="clinical-card" style="margin-bottom:16px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Chief Complaints</div>
                                <span class="category-top-tag classical">NAM: AYU-MS-0412</span>
                            </div>
                            <div class="card-body-pad">
                                <strong style="font-size:0.85rem;color:var(--color-primary);">Sandhivata (Osteoarthritis) - Bilateral Knee (6 Months)</strong>
                                <p style="font-size:0.75rem;color:var(--color-text-secondary);margin-top:6px;">Severe morning stiffness (+3), swelling in left knee.</p>
                            </div>
                        </div>

                        <div class="clinical-card" style="margin-bottom:16px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">Ashtavidha Pariksha (8-Fold)</div>
                            </div>
                            <div class="card-body-pad">
                                <div class="ashtavidha-grid">
                                    <div class="pariksha-item"><div class="pariksha-label">Nadi</div><select class="pariksha-select"><option selected>Manduka (Pitta-Vata)</option></select></div>
                                    <div class="pariksha-item"><div class="pariksha-label">Mutra</div><select class="pariksha-select"><option selected>Pita (Pale Yellow)</option></select></div>
                                    <div class="pariksha-item"><div class="pariksha-label">Mala</div><select class="pariksha-select"><option selected>Baddha (Constipated)</option></select></div>
                                    <div class="pariksha-item"><div class="pariksha-label">Jihva</div><select class="pariksha-select"><option selected>Saama (Coated)</option></select></div>
                                </div>
                            </div>
                        </div>

                        <div class="clinical-card">
                            <div class="card-header-clean with-bg"><div class="card-title-lg">Tridosha Vikriti Gauge</div><span class="status-chip critical">Vata High</span></div>
                            <div class="card-body-pad">
                                <div class="tridosha-row">
                                    <div class="tridosha-header"><span style="color:#C2410C;">Vata (58%)</span></div>
                                    <div class="progress-bar-container"><div class="progress-fill saffron" style="width: 58%;"></div></div>
                                </div>
                                <div class="tridosha-row">
                                    <div class="tridosha-header"><span>Pitta (28%)</span></div>
                                    <div class="progress-bar-container"><div class="progress-fill primary" style="width: 28%;"></div></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="clinical-card" style="margin-bottom:16px;">
                            <div class="card-header-clean with-bg">
                                <div class="card-title-lg">National Ayush Pharmacopoeia Rx</div>
                                <span class="compliance-badge-pill abdm">e-Aushadhi</span>
                            </div>
                            <div class="card-body-pad">
                                <div style="background:#F8FAFC;border:1px solid var(--color-border);border-radius:8px;padding:12px;margin-bottom:14px;">
                                    <div style="margin-bottom:8px;">
                                        <label class="form-label-ayush">Formulation</label>
                                        <select id="rx-drug-select" class="form-control-ayush"><option>Shallaki (Boswellia serrata) Extract</option><option>Rasnasaptaka Kwath</option></select>
                                    </div>
                                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:8px;margin-bottom:8px;">
                                        <div><label class="form-label-ayush">Form</label><select id="rx-form-select" class="form-control-ayush"><option>500 mg Vati</option></select></div>
                                        <div><label class="form-label-ayush">Frequency</label><select id="rx-freq-select" class="form-control-ayush"><option>BD (Twice daily)</option></select></div>
                                        <div><label class="form-label-ayush">Timing</label><select id="rx-kala-select" class="form-control-ayush"><option>Adhobhakta</option></select></div>
                                    </div>
                                    <div style="display:grid;grid-template-columns:1.5fr 1fr;gap:8px;margin-bottom:10px;">
                                        <div><label class="form-label-ayush">Anupana</label><input type="text" id="rx-anupana-input" class="form-control-ayush" value="Lukewarm water"></div>
                                        <div><label class="form-label-ayush">Duration</label><input type="text" id="rx-duration-input" class="form-control-ayush" value="21 Days"></div>
                                    </div>
                                    <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" style="width:100%;" onclick="appendMedication()">Append to Script</button>
                                </div>

                                <div id="prescription-items-list">
                                    <div class="rx-item-card">
                                        <div>
                                            <div class="rx-item-title">1. Yogaraj Guggulu <span class="status-chip ready">500mg Vati</span></div>
                                            <div class="rx-item-meta">Frequency: TDS (1-1-1) &bull; Anupana: Ginger water &bull; 30 Days</div>
                                        </div>
                                    </div>
                                    <div class="rx-item-card">
                                        <div>
                                            <div class="rx-item-title">2. Dashamularishta <span class="status-chip ready">Liquid Asava</span></div>
                                            <div class="rx-item-meta">Frequency: 20ml BD &bull; Warm water &bull; 30 Days</div>
                                        </div>
                                    </div>
                                </div>

                                <div style="margin-top:14px;">
                                    <button type="button" id="doctor-sign-push-btn" class="btn-ayush btn-ayush-primary btn-ayush-sm" style="width:100%;" onclick="signAndPushAbha()">
                                        Digitally Sign & Push to Patient ABHA Locker
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="clinical-card" style="margin-bottom:16px;">
                            <div class="card-header-clean with-bg"><div class="card-title-lg">Clinical Progress</div><span class="status-chip ready">-62.5% Pain</span></div>
                            <div class="card-body-pad">
                                <svg viewBox="0 0 300 80" style="width:100%;height:80px;background:#F8FAFC;border:1px solid var(--color-border-subtle);border-radius:6px;">
                                    <polyline fill="none" stroke="var(--color-saffron)" stroke-width="2.5" points="30,15 110,35 190,50 270,68"/>
                                    <circle cx="30" cy="15" r="4" fill="#C2410C"/>
                                    <circle cx="270" cy="68" r="4" fill="var(--color-green)"/>
                                </svg>
                                <div style="font-size:0.72rem;color:var(--color-text-secondary);margin-top:8px;">VAS Knee Pain Scale reduced significantly.</div>
                            </div>
                        </div>

                        <div class="clinical-card">
                            <div class="card-header-clean with-bg"><div class="card-title-lg">Diagnostic Records</div></div>
                            <div class="card-body-pad">
                                <div class="room-status-item" style="cursor:pointer;" onclick="openXrayModal()">
                                    <div style="display:flex;gap:10px;align-items:center;">
                                        <img src="/images/knee_xray.jpg" alt="X-Ray" style="width:36px;height:36px;border-radius:4px;object-fit:cover;">
                                        <div><div style="font-size:0.78rem;font-weight:700;">Digital X-Ray Knees</div><div style="font-size:0.68rem;color:var(--color-text-muted);">12 Sep 2026</div></div>
                                    </div>
                                    <i data-lucide="eye" style="width:16px;height:16px;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <!-- MODALS -->
    <div id="consent-modal" class="ayush-modal-overlay">
        <div class="ayush-modal-card">
            <div class="ayush-modal-header">
                <div style="font-weight:800;font-size:0.95rem;">ABDM Consent Management Vault (DPDP Act 2023)</div>
                <button type="button" onclick="closeModal('consent-modal')" style="background:none;border:none;color:#FFFFFF;cursor:pointer;">&times;</button>
            </div>
            <div class="ayush-modal-body">
                <p style="font-size:0.78rem;color:var(--color-text-secondary);margin-bottom:14px;">
                    Patient retains complete sovereign control over electronic health records.
                </p>
                <div style="background:#F8FAFC;border:1px solid var(--color-border);border-radius:8px;padding:12px;margin-bottom:12px;">
                    <div style="display:flex;justify-content:space-between;align-items:center;">
                        <strong>Dr. Priya Sharma, MD (Ayurveda)</strong>
                        <span class="status-chip ready">Consent Active</span>
                    </div>
                </div>
            </div>
            <div class="ayush-modal-footer">
                <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="closeModal('consent-modal')">Close</button>
            </div>
        </div>
    </div>

    <div id="prescription-modal" class="ayush-modal-overlay">
        <div class="ayush-modal-card" style="max-width:640px;">
            <div class="ayush-modal-header">
                <div style="font-weight:800;font-size:0.95rem;">Government of India Official e-Prescription (e-Sign #GOI-AY-9821)</div>
                <button type="button" onclick="closeModal('prescription-modal')" style="background:none;border:none;color:#FFFFFF;cursor:pointer;">&times;</button>
            </div>
            <div class="ayush-modal-body" style="font-size:0.8rem;background:#FFFFFF;">
                <div style="border-bottom:2px solid var(--color-primary);padding-bottom:10px;margin-bottom:12px;text-align:center;">
                    <div style="font-size:0.7rem;font-weight:700;color:var(--color-saffron-dark);">भारत सरकार &bull; आयुष मंत्रालय | MINISTRY OF AYUSH</div>
                    <div style="font-size:1.05rem;font-weight:900;color:var(--color-primary);">CENTRAL AYURVEDA RESEARCH INSTITUTE</div>
                </div>
                <p><strong>Patient:</strong> Rajesh Sharma (48/M) &bull; <strong>ABHA ID:</strong> 91-4523-8871-9012</p>
                <p><strong>Diagnosis:</strong> Sandhivata (Osteoarthritis Knee) &bull; <strong>Prescriber:</strong> Dr. Priya Sharma, MD</p>
            </div>
            <div class="ayush-modal-footer">
                <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="closeModal('prescription-modal')">Close</button>
                <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="window.print();">Print / Save PDF</button>
            </div>
        </div>
    </div>

    <div id="xray-modal" class="ayush-modal-overlay">
        <div class="ayush-modal-card" style="max-width:620px;">
            <div class="ayush-modal-header">
                <div style="font-weight:800;font-size:0.95rem;">Digital Radiograph &bull; Bilateral Knees</div>
                <button type="button" onclick="closeModal('xray-modal')" style="background:none;border:none;color:#FFFFFF;cursor:pointer;">&times;</button>
            </div>
            <div class="ayush-modal-body" style="text-align:center;background:#000000;padding:12px;">
                <img src="/images/knee_xray.jpg" alt="Knee Radiograph" style="max-width:100%;max-height:60vh;border-radius:4px;">
            </div>
            <div class="ayush-modal-footer">
                <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="closeModal('xray-modal')">Close</button>
            </div>
        </div>
    </div>

    <div id="token-modal" class="ayush-modal-overlay">
        <div class="ayush-modal-card" style="max-width:380px;">
            <div class="ayush-modal-header">
                <div style="font-weight:800;font-size:0.9rem;">Official OPD Token Slip</div>
                <button type="button" onclick="closeModal('token-modal')" style="background:none;border:none;color:#FFFFFF;cursor:pointer;">&times;</button>
            </div>
            <div class="ayush-modal-body" style="text-align:center;font-family:monospace;background:#FFFFFF;border:1px dashed #CBD5E1;margin:16px;padding:16px;border-radius:6px;">
                <div style="font-size:2.4rem;font-weight:900;color:var(--color-primary);margin:8px 0;">#18</div>
                <div>Rajesh Kumar Verma (48/M)</div>
                <div>ABHA: 91-8834-2109 &bull; ROOM: OPD-02</div>
            </div>
            <div class="ayush-modal-footer">
                <button type="button" class="btn-ayush btn-ayush-secondary btn-ayush-sm" onclick="closeModal('token-modal')">Close</button>
                <button type="button" class="btn-ayush btn-ayush-primary btn-ayush-sm" onclick="window.print(); closeModal('token-modal');">Print</button>
            </div>
        </div>
    </div>

    <script src="/js/ayush-ehr.js"></script>
    <script>
        if (window.lucide) {
            window.lucide.createIcons();
        }
    </script>
</body>
</html>
