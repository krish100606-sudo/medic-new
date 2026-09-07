<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinical Consent — Audio-Guided Checkpoint — MediKiosk</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
    <style>
        .mk-audio-btn {
            background: #eef2ff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
            border-radius: 50px;
            padding: 8px 18px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }
        .mk-audio-btn:hover {
            background: #2563eb;
            color: #ffffff;
        }
        .mk-pictogram-card {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px;
            background: #ffffff;
            transition: all 0.2s;
        }
        .mk-pictogram-card:hover {
            border-color: #2563eb;
            box-shadow: 0 4px 12px rgba(37,99,235,0.08);
        }
    </style>
</head>
<body class="bg-light">

    <!-- Ministry of Ayush Government Header -->
    <%@ include file="../ayush-header.jsp" %>

    <!-- Accessible Skip Link -->
    <a href="#mainContent" class="mk-skip-link">Skip to Consent Agreement</a>

    <!-- Top Header -->
    <header class="mk-navbar sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="mk-brand" href="/patient/dashboard">
                <i class="bi bi-hospital text-primary fs-4"></i>
                <span>MediKiosk</span>
                <span class="mk-brand-badge d-none d-sm-inline-block">SIH Prototype</span>
            </a>
            <div class="d-flex align-items-center gap-2">
                <!-- Accessibility Controls Toolbar -->
                <div class="mk-a11y-toolbar" role="region" aria-label="Accessibility settings">
                    <button type="button" class="mk-a11y-btn" id="a11yContrastBtn" onclick="toggleContrast()" title="High Contrast Mode (Alt+C)" aria-label="Toggle high contrast">
                        <i class="bi bi-circle-half"></i>
                    </button>
                    <button type="button" class="mk-a11y-btn" id="a11yFontNormal" onclick="changeFontSize('reset')" title="Standard Text Size" aria-label="Standard text size">A</button>
                    <button type="button" class="mk-a11y-btn" id="a11yFontLg" onclick="changeFontSize('increase')" title="Large Text Size" aria-label="Large text size">A+</button>
                </div>

                <button type="button" class="btn btn-outline-primary btn-sm" onclick="toggleAssistanceMode()" aria-label="Toggle volunteer assistance mode">
                    <i class="bi bi-person-raised-hand me-1"></i> <span class="d-none d-sm-inline">Assistance Mode</span>
                </button>
                <a href="/logout" class="btn btn-outline-danger btn-sm" aria-label="Sign Out">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container py-4 py-md-5" id="mainContent">
        <div class="row justify-content-center">
            <div class="col-lg-9 col-xl-8">

                <!-- Consent Card -->
                <div class="mk-card p-4 p-md-5">
                    
                    <!-- Header with Audio Readout -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom gap-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-shield-check fs-2"></i>
                            </div>
                            <div>
                                <h3 class="fw-bold text-dark mb-0">Audio-Guided Consent Checkpoint</h3>
                                <p class="text-muted small mb-0">Pre-Consultation Clinical Intake & Privacy Consent (रोगी सहमति)</p>
                            </div>
                        </div>

                        <!-- Audio Playback Buttons for Accessibility -->
                        <div class="d-flex gap-2">
                            <button type="button" class="mk-audio-btn" onclick="playAudioConsent('en')">
                                <i class="bi bi-volume-up-fill"></i> English
                            </button>
                            <button type="button" class="mk-audio-btn" onclick="playAudioConsent('hi')">
                                <i class="bi bi-volume-up-fill"></i> हिन्दी में सुनें
                            </button>
                        </div>
                    </div>

                    <!-- Assistance Mode Notice if Activated -->
                    <div id="assistanceAlert" class="alert alert-info d-none mb-4">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-person-arms-up fs-4"></i>
                            <div>
                                <strong>Assistance Mode Active:</strong> Hospital volunteers or nursing staff are available at the kiosk station to assist with touch navigation and document scanning.
                            </div>
                        </div>
                    </div>

                    <!-- Pictogram Visual Explanations (Low Digital Literacy Support) -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <div class="mk-pictogram-card text-center h-100">
                                <div class="fs-1 text-primary mb-2"><i class="bi bi-mic-fill"></i></div>
                                <h6 class="fw-bold text-dark mb-1">1. Speak or Touch</h6>
                                <p class="text-muted small mb-0">Answer guided questions using voice (English/Hindi) or large touch buttons.</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-pictogram-card text-center h-100">
                                <div class="fs-1 text-primary mb-2"><i class="bi bi-camera-fill"></i></div>
                                <h6 class="fw-bold text-dark mb-1">2. Scan Records</h6>
                                <p class="text-muted small mb-0">Upload old prescriptions or lab tests to auto-extract diagnoses and medicines.</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-pictogram-card text-center h-100">
                                <div class="fs-1 text-primary mb-2"><i class="bi bi-person-check-fill"></i></div>
                                <h6 class="fw-bold text-dark mb-1">3. Doctor Verifies</h6>
                                <p class="text-muted small mb-0">Your consulting physician personally reviews and confirms your clinical history.</p>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="p-3 bg-light rounded border mb-3">
                            <h6 class="fw-semibold text-dark mb-1"><i class="bi bi-lock text-primary me-1"></i> Data Privacy & ABDM Compliance</h6>
                            <p class="text-muted small mb-0">Your information is stored in compliance with hospital security standards, formatted for HL7 FHIR R4 interoperability, and cleared after each session for public kiosk privacy.</p>
                        </div>

                        <div class="p-3 bg-primary bg-opacity-10 rounded border border-primary border-opacity-25 mb-3">
                            <h6 class="fw-semibold text-primary mb-1"><i class="bi bi-stethoscope me-1"></i> Assistive Clinical Tool Notice</h6>
                            <p class="text-dark small mb-0">MediKiosk is an assistive clinical intake platform. It does NOT generate autonomous prescriptions or diagnoses. Full clinical authority remains with your consulting physician.</p>
                        </div>
                    </div>

                    <form action="/patient/consent" method="POST">
                        <div class="p-3 bg-white rounded border mb-4 shadow-sm">
                            <div class="form-check">
                                <input class="form-check-input ms-0 me-3" style="width: 24px; height: 24px;" type="checkbox" name="consent" id="consentCheck" value="true" required>
                                <label class="form-check-label fw-bold text-dark" for="consentCheck" style="margin-top: 2px;">
                                    I agree to the pre-consultation clinical intake terms and consent to digitize my symptoms and records for my doctor's review.
                                    <div class="text-muted fw-normal small mt-1">मैं अपने लक्षणों और पिछले रिकॉर्ड्स को डॉक्टर के परामर्श हेतु डिजिटाइज़ करने की सहमति देता/देती हूँ।</div>
                                </label>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center">
                            <a href="/patient/dashboard" class="btn mk-btn mk-btn-secondary">
                                <i class="bi bi-x-circle"></i> Cancel
                            </a>
                            <button type="submit" class="btn mk-btn mk-btn-primary mk-btn-lg px-4">
                                <i class="bi bi-check2-circle me-1"></i> I Agree & Continue (आगे बढ़ें)
                            </button>
                        </div>
                    </form>

                </div>

            </div>
        </div>
    </main>

    <script>
        function playAudioConsent(lang) {
            if ('speechSynthesis' in window) {
                window.speechSynthesis.cancel();
                let text = "";
                if (lang === 'hi') {
                    text = "मेडीकियोस्क में आपका स्वागत है। डॉक्टर से मिलने से पहले अपने लक्षणों और पुरानी पर्चियों को आवाज़ या टच से रिकॉर्ड करने के लिए इस सहमति चेकबॉक्स पर टिक करें और आगे बढ़ें पर टैप करें।";
                } else {
                    text = "Welcome to MediKiosk. Please review the clinical intake terms. You can provide your symptoms using voice or touch, and upload previous records. Your doctor will verify all findings during consultation. Please check the agreement box and click continue.";
                }
                const utterance = new SpeechSynthesisUtterance(text);
                utterance.lang = (lang === 'hi') ? 'hi-IN' : 'en-IN';
                window.speechSynthesis.speak(utterance);
            } else {
                alert('Audio playback is not supported in this browser.');
            }
        }

        function toggleAssistanceMode() {
            const el = document.getElementById('assistanceAlert');
            if (el) el.classList.toggle('d-none');
        }
    </script>
    <script src="/js/medikiosk-a11y.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
