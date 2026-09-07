<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emergency Triage Intercept — MediKiosk</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
    <style>
        .mk-emergency-card {
            border: 3px solid #dc3545;
            box-shadow: 0 10px 40px rgba(220, 53, 69, 0.25);
            background: #ffffff;
            border-radius: 16px;
        }
        .mk-pulse-alert {
            animation: mkPulse 1.8s infinite;
        }
        @keyframes mkPulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.08); opacity: 0.85; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body class="bg-light">

    <!-- Accessible Skip Link -->
    <a href="#mainContent" class="mk-skip-link">Skip to Emergency Intercept</a>

    <!-- Top Navigation -->
    <header class="mk-navbar bg-danger text-white sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-octagon-fill fs-3 text-warning mk-pulse-alert"></i>
                <span class="fw-bold fs-5 d-none d-sm-inline">MediKiosk Emergency Triage Intercept</span>
                <span class="fw-bold fs-6 d-sm-none">Emergency Intercept</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <!-- Accessibility Controls Toolbar -->
                <div class="mk-a11y-toolbar bg-white bg-opacity-25 border-0 me-1" role="region" aria-label="Accessibility settings">
                    <button type="button" class="mk-a11y-btn text-white" id="a11yContrastBtn" onclick="toggleContrast()" title="High Contrast Mode (Alt+C)" aria-label="Toggle high contrast">
                        <i class="bi bi-circle-half"></i>
                    </button>
                    <button type="button" class="mk-a11y-btn text-white" id="a11yFontNormal" onclick="changeFontSize('reset')" title="Standard Text Size" aria-label="Standard text size">A</button>
                    <button type="button" class="mk-a11y-btn text-white" id="a11yFontLg" onclick="changeFontSize('increase')" title="Large Text Size" aria-label="Large text size">A+</button>
                </div>
                <span class="badge bg-warning text-dark fw-bold px-3 py-2">
                    <i class="bi bi-bell-fill me-1"></i> PRIORITY ALERT
                </span>
            </div>
        </div>
    </header>

    <!-- Main Intercept Screen -->
    <main class="container py-4 py-md-5" id="mainContent">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-7">

                <div class="mk-emergency-card p-4 p-md-5 text-center">

                    <div class="mb-4">
                        <div class="d-inline-flex p-4 rounded-circle bg-danger bg-opacity-10 text-danger mb-3 mk-pulse-alert">
                            <i class="bi bi-shield-fill-exclamation fs-1"></i>
                        </div>
                        <h2 class="fw-bold text-danger mb-1">Routine Intake Paused</h2>
                        <h5 class="text-dark fw-semibold mb-2">Immediate Clinical Triage Required</h5>
                        <c:if test="${lang == 'Hindi'}">
                            <p class="text-muted fs-6">गंभीर लक्षण पाए गए हैं। कृपया तुरंत आपातकालीन कक्ष या काउंटर 0 पर जाएं।</p>
                        </c:if>
                    </div>

                    <!-- Red-Flag Details Box -->
                    <div class="p-3 bg-danger bg-opacity-10 border border-danger rounded mb-4 text-start">
                        <div class="fw-bold text-danger mb-1">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> Clinical Red-Flag Triggered:
                        </div>
                        <div class="text-dark fw-semibold">
                            ${medicalCase.priorityReason != null ? medicalCase.priorityReason : "Acute chest discomfort / severe breathing distress detected in symptom input."}
                        </div>
                        <div class="small text-muted mt-2">
                            <i class="bi bi-info-circle me-1"></i> Under hospital safety protocols, MediKiosk interrupts routine history-taking when acute cardiopulmonary or neurological distress phrases are detected.
                        </div>
                    </div>

                    <!-- Action Guidance -->
                    <div class="row g-3 text-start mb-4">
                        <div class="col-md-6">
                            <div class="p-3 bg-light rounded border h-100">
                                <div class="fw-bold text-dark mb-1">
                                    <i class="bi bi-geo-alt-fill text-danger me-1"></i> Where to go right now:
                                </div>
                                <div class="text-primary fw-bold fs-5">Triage Counter 0 / ER</div>
                                <div class="small text-muted">Directly opposite the OPD entrance. Nursing staff are alerted.</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="p-3 bg-light rounded border h-100">
                                <div class="fw-bold text-dark mb-1">
                                    <i class="bi bi-broadcast text-primary me-1"></i> Doctor Notification:
                                </div>
                                <div class="text-dark fw-semibold">High-Priority Alert Dispatched</div>
                                <div class="small text-muted">Case marked CRITICAL on physician queue with emergency badge.</div>
                            </div>
                        </div>
                    </div>

                    <!-- Audio Guidance Button -->
                    <div class="mb-4">
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="speakAlert()">
                            <i class="bi bi-volume-up-fill me-1"></i> Listen to Audio Guidance (आवाज़ में सुनें)
                        </button>
                    </div>

                    <!-- Decision Action Forms -->
                    <div class="d-grid gap-3">
                        <form action="/patient/emergency-escalate" method="POST">
                            <input type="hidden" name="reason" value="${medicalCase.priorityReason}">
                            <button type="submit" class="btn btn-danger btn-lg w-100 py-3 fw-bold shadow">
                                <i class="bi bi-check2-circle me-2"></i> Proceed to Immediate Emergency Triage (Get Priority Token)
                            </button>
                        </form>

                        <form action="/patient/emergency-continue" method="POST">
                            <input type="hidden" name="step" value="${step}">
                            <button type="submit" class="btn btn-outline-secondary w-100 py-2 small">
                                <i class="bi bi-person-check me-1"></i> Continue with Hospital Staff / Nurse Assistance (False Alarm Override)
                            </button>
                        </form>
                    </div>

                </div>

            </div>
        </div>
    </main>

    <script>
        function speakAlert() {
            if ('speechSynthesis' in window) {
                window.speechSynthesis.cancel();
                const isHindi = '${lang}' === 'Hindi';
                const text = isHindi
                    ? "कृपया ध्यान दें। आपातकालीन लक्षण पाए गए हैं। कृपया काउंटर शून्य या आपातकालीन कक्ष में तुरंत संपर्क करें।"
                    : "Attention. Severe symptoms detected. Please proceed immediately to Emergency Room or Triage Counter Zero. A doctor alert has been dispatched.";
                const utterance = new SpeechSynthesisUtterance(text);
                utterance.lang = isHindi ? 'hi-IN' : 'en-IN';
                window.speechSynthesis.speak(utterance);
            }
        }

        // Trigger brief audio notice on load
        document.addEventListener('DOMContentLoaded', () => {
            setTimeout(speakAlert, 500);
        });
    </script>
    <script src="/js/medikiosk-a11y.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
