<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinical Case Intake — Question ${currentStep} of ${totalSteps} — MediKiosk (SIH Prototype)</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
    <style>
        .mk-framework-badge {
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            background: #ede9fe;
            color: #6d28d9;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .mk-confidence-indicator {
            font-size: 0.75rem;
            padding: 3px 8px;
            border-radius: 6px;
            background: #f1f5f9;
            color: #475569;
        }
        .mk-ayush-badge {
            background: #ecfdf5 !important;
            color: #059669 !important;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Ministry of Ayush Government Header -->
    <%@ include file="../ayush-header.jsp" %>

    <!-- Accessible Skip Link -->
    <a href="#mainContent" class="mk-skip-link">Skip to Question</a>

    <!-- Top Navigation -->
    <header class="mk-navbar sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="mk-brand" href="/patient/dashboard">
                <i class="bi bi-hospital text-primary fs-4"></i>
                <span>MediKiosk</span>
                <span class="mk-brand-badge d-none d-sm-inline-block">SIH Clinical Intake</span>
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

                <button type="button" class="btn btn-outline-primary btn-sm d-flex align-items-center gap-1" onclick="readAloudQuestion()" title="Listen to Question (Alt+R)" aria-label="Listen to question in audio">
                    <i class="bi bi-volume-up-fill"></i> <span class="d-none d-sm-inline">Listen</span>
                </button>

                <span class="badge bg-light text-dark border d-none d-sm-inline-block"><i class="bi bi-translate me-1"></i> ${lang}</span>
                <a href="/patient/dashboard" class="btn mk-btn mk-btn-secondary btn-sm" aria-label="Exit Intake">
                    <i class="bi bi-door-closed"></i> <span class="d-none d-md-inline">Exit</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Intake Container -->
    <main class="container py-3 py-md-4 mk-has-sticky-actions" id="mainContent">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-7">

                <!-- Intake Mode Switcher -->
                <div class="d-flex justify-content-center mb-4">
                    <div class="btn-group p-1 bg-white border rounded-pill shadow-sm" role="group" aria-label="Intake Mode Switcher">
                        <a href="/patient/case-taking?mode=conversational" class="btn btn-sm rounded-pill ${mode != 'steps' ? 'btn-primary px-3' : 'btn-outline-secondary px-3'}">
                            <i class="bi bi-chat-heart-fill me-1"></i> AI Conversational Mode
                        </a>
                        <a href="/patient/case-taking?mode=steps&step=1" class="btn btn-sm rounded-pill ${mode == 'steps' ? 'btn-primary px-3' : 'btn-outline-secondary px-3'}">
                            <i class="bi bi-ui-checks-grid me-1"></i> Guided Step Mode (10 Steps)
                        </a>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${mode != 'steps'}">
                        <!-- =========================================================
                             AI CONVERSATIONAL INTAKE MODE (Interactive Voice & Touch)
                             ========================================================= -->
                        <div class="mk-card p-4 p-md-5">
                            <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 44px; height: 44px; box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);">
                                        <i class="bi bi-robot fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-0 text-dark">MediKiosk AI Clinical Intake</h5>
                                        <div class="small text-muted">Bilingual Voice & Touch Dialogue &bull; Adaptive Clinical Reasoning</div>
                                    </div>
                                </div>
                                <span class="badge bg-light text-dark border px-2 py-1 small">
                                    <i class="bi bi-translate me-1"></i> ${lang}
                                </span>
                            </div>

                            <!-- Live Conversational Chat Stream -->
                            <div class="mk-chat-stream mb-3" id="chatStream">
                                <!-- AI Assistant Initial Greeting -->
                                <div class="mk-chat-msg msg-ai">
                                    <div class="mk-chat-avatar"><i class="bi bi-hospital"></i></div>
                                    <div class="mk-chat-bubble">
                                        <c:choose>
                                            <c:when test="${lang == 'Hindi'}">
                                                <strong>नमस्ते ${patient.user.name}!</strong> मैं आपका मेडीकियोस्क एआई प्री-कंसल्टेशन सहायक हूँ। आज आपको क्या मुख्य स्वास्थ्य समस्या या दर्द हो रहा है? आप नीचे बोल सकते हैं, टाइप कर सकते हैं, या तुरंत विकल्प चुन सकते हैं।
                                            </c:when>
                                            <c:otherwise>
                                                <strong>Namaste ${patient.user.name}!</strong> I am your MediKiosk AI clinical intake assistant. What main symptom or health discomfort brings you to the hospital today? You can speak, type, or tap the quick response buttons below.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Render prior conversation turns if any -->
                                <c:if test="${not empty medicalCase.conversationalHistory}">
                                    <c:forEach var="line" items="${medicalCase.conversationalHistory.split('\\n')}">
                                        <c:if test="${line.startsWith('[PATIENT]: ')}">
                                            <div class="mk-chat-msg msg-user">
                                                <div class="mk-chat-avatar"><i class="bi bi-person-fill"></i></div>
                                                <div class="mk-chat-bubble">${line.replace('[PATIENT]: ', '')}</div>
                                            </div>
                                        </c:if>
                                        <c:if test="${line.startsWith('[AI ASSISTANT]: ')}">
                                            <div class="mk-chat-msg msg-ai">
                                                <div class="mk-chat-avatar"><i class="bi bi-hospital"></i></div>
                                                <div class="mk-chat-bubble">${line.replace('[AI ASSISTANT]: ', '')}</div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </div>

                            <!-- Tactile Quick-Response Touch Chips -->
                            <div class="mb-3">
                                <div class="small fw-semibold text-muted mb-1"><i class="bi bi-hand-index-thumb me-1"></i>Quick Touch Responses:</div>
                                <div class="mk-touch-chips">
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('Chest pain with heavy pressure', 'Q_CHIEF_COMPLAINT', 'Chest Pain')">
                                        <i class="bi bi-heart-pulse text-danger"></i> Chest Pain (छाती में दर्द)
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('High fever and dry cough', 'Q_CHIEF_COMPLAINT', 'Fever and Cough')">
                                        <i class="bi bi-thermometer-high text-warning"></i> Fever & Cough (बुखार)
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('Severe stomach ache with vomiting', 'Q_CHIEF_COMPLAINT', 'Abdominal Pain')">
                                        <i class="bi bi-capsule text-primary"></i> Stomach Pain (पेट दर्द)
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('Started 2 hours ago today', 'Q_ONSET', '2 hours ago')">
                                        <i class="bi bi-clock-history"></i> 2 Hours Ago (2 घंटे पहले)
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('Pain radiates to my left arm and jaw', 'Q_SOCRATES_RADIATION', 'Radiates to left arm')">
                                        <i class="bi bi-arrow-down-left-circle text-danger"></i> Left Arm Radiation
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('Severe pain level 8 out of 10', 'Q_SEVERITY', '8 / 10')">
                                        <i class="bi bi-speedometer text-danger"></i> Severe (8/10)
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('I take Tab. Metformin 500mg daily for Diabetes', 'Q_MEDICATIONS', 'Metformin 500mg BD')">
                                        <i class="bi bi-capsule-pill text-info"></i> Metformin 500mg
                                    </button>
                                    <button type="button" class="mk-touch-chip" onclick="quickSend('No known drug allergies or surgeries', 'Q_ALLERGIES', 'No known allergies')">
                                        <i class="bi bi-shield-check text-success"></i> No Allergies
                                    </button>
                                </div>
                            </div>

                            <!-- Voice & Text Input Box -->
                            <div class="d-flex gap-2 align-items-center mb-4">
                                <button type="button" class="mk-mic-pulse-btn" id="convMicBtn" onclick="toggleConversationalVoice()" title="Click to speak in ${lang}">
                                    <i class="bi bi-mic-fill"></i>
                                </button>
                                <input type="text" class="form-control form-control-lg" id="convInput" placeholder="${lang == 'Hindi' ? 'अपनी समस्या बोलें या यहाँ लिखें...' : 'Speak or type your symptoms here...'}" onkeydown="if(event.key==='Enter'){event.preventDefault();sendConversationalMsg();}">
                                <button type="button" class="btn btn-primary btn-lg px-3 px-md-4" onclick="sendConversationalMsg()" title="Send">
                                    <i class="bi bi-send-fill"></i>
                                </button>
                            </div>

                            <!-- Live Extracted Entity Telemetry Card -->
                            <div class="card border bg-light-subtle mb-4">
                                <div class="card-body p-3">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="fw-bold text-dark mb-0 small text-uppercase"><i class="bi bi-cpu text-primary me-1"></i>Real-time Clinical Extraction Telemetry</h6>
                                        <span class="badge ${medicalCase.priority == 'HIGH' ? 'bg-danger text-white' : 'bg-success-subtle text-success'}" id="livePriorityBadge">
                                            Priority: ${medicalCase.priority}
                                        </span>
                                    </div>
                                    <div class="row g-2 text-start small">
                                        <div class="col-sm-6">
                                            <span class="text-muted">Chief Complaint:</span>
                                            <strong class="text-dark ms-1" id="liveComplaint">${not empty medicalCase.chiefComplaint ? medicalCase.chiefComplaint : 'Pending intake...'}</strong>
                                        </div>
                                        <div class="col-sm-6">
                                            <span class="text-muted">Onset / Duration:</span>
                                            <strong class="text-dark ms-1" id="liveOnset">${not empty medicalCase.onset ? medicalCase.onset : 'Not yet specified'}</strong>
                                        </div>
                                        <div class="col-sm-6">
                                            <span class="text-muted">Severity:</span>
                                            <strong class="text-dark ms-1" id="liveSeverity">${not empty medicalCase.severity ? medicalCase.severity : 'Not yet evaluated'}</strong>
                                        </div>
                                        <div class="col-sm-6">
                                            <span class="text-muted">Medications:</span>
                                            <strong class="text-dark ms-1" id="liveMedications">${not empty medicalCase.currentMedication ? medicalCase.currentMedication : 'None noted'}</strong>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Continue Action Buttons -->
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <a href="/patient/dashboard" class="btn btn-outline-secondary px-3 px-md-4">
                                    <i class="bi bi-arrow-left me-1"></i> Exit to Dashboard
                                </a>
                                <a href="/patient/document-upload" class="btn btn-primary btn-lg px-4">
                                    <span>Proceed to Document Upload</span>
                                    <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <!-- =========================================================
                             GUIDED STEP MODE (10-Step Guided Flow)
                             ========================================================= -->
                        <!-- Progress Header -->
                        <div class="mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="fw-bold text-primary small text-uppercase">Question ${currentStep} of ${totalSteps}</span>
                                    <c:choose>
                                        <c:when test="${currentStep >= 3 && currentStep <= 7}">
                                            <span class="mk-framework-badge"><i class="bi bi-journal-medical"></i> SOCRATES Framework</span>
                                        </c:when>
                                        <c:when test="${currentStep == 10}">
                                            <span class="mk-framework-badge mk-ayush-badge"><i class="bi bi-flower1"></i> AYUSH Module</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <span class="text-muted small">${(currentStep * 10)}% Completed</span>
                            </div>
                            <div class="progress" style="height: 8px;">
                                <div class="progress-bar bg-primary" role="progressbar" id="progressBar" data-progress="${currentStep * 10}"></div>
                            </div>
                        </div>

                        <!-- Guided Question Card -->
                        <div class="mk-card p-4 p-md-5">

                            <form action="/patient/case-taking/save-step" method="POST" id="intakeForm">
                                <input type="hidden" name="step" value="${currentStep}">
                                <input type="hidden" name="inputType" id="inputType" value="TEXT">

                        <!-- ---------------- STEP 1: CHIEF COMPLAINT ---------------- -->
                        <c:if test="${currentStep == 1}">
                            <input type="hidden" name="questionCode" value="Q_CHIEF_COMPLAINT">
                            <input type="hidden" name="questionText" value="What is your main health problem?">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">What is your main health problem?</h3>
                                <c:if test="${lang == 'Hindi'}">
                                    <h5 class="text-muted fw-normal">आपकी मुख्य स्वास्थ्य समस्या क्या है?</h5>
                                </c:if>
                                <p class="text-muted small">Select from common issues or speak / type your symptom below.</p>
                            </div>

                            <!-- Fast Touch Options with Pictograms (Low Digital Literacy) -->
                            <div class="row g-2 mb-4">
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Chest Pain' ? 'selected' : ''}" onclick="selectAnswer('Chest Pain', 'TOUCH', this)">
                                        <span>Chest Pain</span>
                                        <i class="bi bi-heart-pulse text-danger"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Fever and Cough' ? 'selected' : ''}" onclick="selectAnswer('Fever and Cough', 'TOUCH', this)">
                                        <span>Fever / Cough</span>
                                        <i class="bi bi-thermometer-high text-warning"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Shortness of Breath' ? 'selected' : ''}" onclick="selectAnswer('Shortness of Breath', 'TOUCH', this)">
                                        <span>Breathlessness</span>
                                        <i class="bi bi-lungs text-primary"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Severe Headache' ? 'selected' : ''}" onclick="selectAnswer('Severe Headache', 'TOUCH', this)">
                                        <span>Headache</span>
                                        <i class="bi bi-activity text-secondary"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Abdominal Pain' ? 'selected' : ''}" onclick="selectAnswer('Abdominal Pain', 'TOUCH', this)">
                                        <span>Abdominal Pain</span>
                                        <i class="bi bi-slash-circle text-info"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Joint Pain / Injury' ? 'selected' : ''}" onclick="selectAnswer('Joint Pain / Injury', 'TOUCH', this)">
                                        <span>Joint / Muscle</span>
                                        <i class="bi bi-bandaid text-success"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Or type / speak your complaint:</label>
                                <div class="input-group">
                                    <input type="text" class="form-control form-control-lg" id="answerInput" name="answerText" value="${not empty medicalCase.chiefComplaint ? medicalCase.chiefComplaint : 'Chest Pain'}" placeholder="e.g. Chest Pain or Fever" required>
                                    <button type="button" class="mk-mic-btn ms-2" id="micBtn" title="Speak in English or Hindi">
                                        <i class="bi bi-mic-fill"></i>
                                    </button>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mt-2">
                                    <div id="voiceStatus" class="small text-muted">Click microphone to speak (English or Hindi).</div>
                                    <span class="mk-confidence-indicator" id="confidenceBadge"><i class="bi bi-shield-check text-success me-1"></i> ASR Ready</span>
                                </div>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 2: PATIENT VERBATIM STATEMENT ---------------- -->
                        <c:if test="${currentStep == 2}">
                            <input type="hidden" name="questionCode" value="Q_STATEMENT">
                            <input type="hidden" name="questionText" value="Please describe how you feel in your own words">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Describe your symptoms in your own words</h3>
                                <c:if test="${lang == 'Hindi'}">
                                    <h5 class="text-muted fw-normal">कृपया अपनी भाषा में अपनी समस्या बताएं</h5>
                                </c:if>
                                <p class="text-muted small">You can speak freely in Hindi or English (Bilingual Voice Intake).</p>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <label class="form-label fw-semibold small text-muted mb-0">Spoken / Written Statement:</label>
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="setDemoVoiceSample()">
                                        <i class="bi bi-magic"></i> Auto-fill Sample Voice
                                    </button>
                                </div>
                                <div class="position-relative">
                                    <textarea class="form-control" id="answerInput" name="answerText" rows="4" placeholder="Speak or type your symptoms freely..." required>${not empty medicalCase.patientStatement ? medicalCase.patientStatement : 'Mujhe do ghante se chest mein pain ho raha hai aur saans lene mein takleef hai.'}</textarea>
                                </div>
                                <div class="d-flex align-items-center gap-3 mt-3">
                                    <button type="button" class="mk-mic-btn" id="micBtn">
                                        <i class="bi bi-mic-fill"></i>
                                    </button>
                                    <div>
                                        <div class="fw-semibold small">Bilingual Voice Input (हिन्दी / English)</div>
                                        <div id="voiceStatus" class="small text-muted">Tap mic to speak. Live transcription with semantic normalization.</div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 3: SOCRATES - ONSET & TIME COURSE ---------------- -->
                        <c:if test="${currentStep == 3}">
                            <input type="hidden" name="questionCode" value="Q_ONSET">
                            <input type="hidden" name="questionText" value="[SOCRATES: O - Onset] When did the problem start?">

                            <div class="text-center mb-4">
                                <div class="mk-framework-badge mb-2"><i class="bi bi-clock-history"></i> SOCRATES: Onset & Time Course</div>
                                <h3 class="fw-bold text-dark mb-1">When did the symptoms begin?</h3>
                                <c:if test="${lang == 'Hindi'}"><h5 class="text-muted fw-normal">यह समस्या कब शुरू हुई?</h5></c:if>
                            </div>

                            <input type="hidden" id="answerInput" name="answerText" value="${not empty medicalCase.onset ? medicalCase.onset : 'Today (Acute - 2 hours ago)'}">

                            <div class="d-grid gap-3 mb-4">
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == 'Today (Acute - 2 hours ago)' || empty medicalCase.onset ? 'selected' : ''}" onclick="selectAnswer('Today (Acute - 2 hours ago)', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold">Today (Acute - Few hours ago)</div>
                                        <div class="small text-muted">Sudden acute onset requiring immediate assessment</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == '1–3 days' ? 'selected' : ''}" onclick="selectAnswer('1–3 days', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold">1–3 days</div>
                                        <div class="small text-muted">Started gradually over the past 48–72 hours</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == 'More than 1 week' ? 'selected' : ''}" onclick="selectAnswer('More than 1 week', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold">Chronic (> 1 week)</div>
                                        <div class="small text-muted">Long-standing recurrent issue</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 4: SOCRATES - SITE & LOCATION ---------------- -->
                        <c:if test="${currentStep == 4}">
                            <input type="hidden" name="questionCode" value="Q_LOCATION">
                            <input type="hidden" name="questionText" value="[SOCRATES: S - Site] Where is the discomfort located?">

                            <div class="text-center mb-4">
                                <div class="mk-framework-badge mb-2"><i class="bi bi-geo-alt"></i> SOCRATES: Site of Discomfort</div>
                                <h3 class="fw-bold text-dark mb-1">Where is the primary site of pain?</h3>
                                <p class="text-muted small">Select anatomical region or type specific area.</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Substernal anterior chest region' || empty medicalCase.location ? 'selected' : ''}" onclick="selectAnswer('Substernal anterior chest region', 'TOUCH', this)">
                                        <span>Anterior Chest</span>
                                        <i class="bi bi-heart text-danger"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Throat and Upper Respiratory' ? 'selected' : ''}" onclick="selectAnswer('Throat and Upper Respiratory', 'TOUCH', this)">
                                        <span>Throat / Neck</span>
                                        <i class="bi bi-activity text-primary"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Epigastric / Upper Abdomen' ? 'selected' : ''}" onclick="selectAnswer('Epigastric / Upper Abdomen', 'TOUCH', this)">
                                        <span>Abdomen</span>
                                        <i class="bi bi-slash-circle text-warning"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Cranial / Head & Neck' ? 'selected' : ''}" onclick="selectAnswer('Cranial / Head & Neck', 'TOUCH', this)">
                                        <span>Head / Cranial</span>
                                        <i class="bi bi-person text-secondary"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Specific location description:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.location ? medicalCase.location : 'Substernal anterior chest region'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 5: SOCRATES - CHARACTER & RADIATION ---------------- -->
                        <c:if test="${currentStep == 5}">
                            <input type="hidden" name="questionCode" value="Q_SOCRATES_CHARACTER">
                            <input type="hidden" name="questionText" value="[SOCRATES: C - Character & Radiation]">

                            <div class="text-center mb-4">
                                <div class="mk-framework-badge mb-2"><i class="bi bi-arrows-angle-expand"></i> SOCRATES: Character & Radiation</div>
                                <h3 class="fw-bold text-dark mb-1">What does the discomfort feel like?</h3>
                                <p class="text-muted small">Select the character of sensation and if it radiates anywhere.</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 selected" onclick="selectAnswer('Heavy pressure / squeezing discomfort radiating to left arm', 'TOUCH', this)">
                                        <span>Heavy Pressure</span>
                                        <i class="bi bi-arrow-down-circle text-danger"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('Sharp / stabbing pain', 'TOUCH', this)">
                                        <span>Sharp / Stabbing</span>
                                        <i class="bi bi-lightning text-warning"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('Burning sensation (Heartburn)', 'TOUCH', this)">
                                        <span>Burning</span>
                                        <i class="bi bi-fire text-danger"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('Dull ache / Throbbing', 'TOUCH', this)">
                                        <span>Dull Ache</span>
                                        <i class="bi bi-circle text-secondary"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Character & Radiation details:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.socratesCharacter ? medicalCase.socratesCharacter : 'Heavy pressure / squeezing discomfort radiating to left arm and jaw'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 6: SOCRATES - SEVERITY & TIMING ---------------- -->
                        <c:if test="${currentStep == 6}">
                            <input type="hidden" name="questionCode" value="Q_SEVERITY">
                            <input type="hidden" name="questionText" value="[SOCRATES: S - Severity & Timing]">

                            <div class="text-center mb-4">
                                <div class="mk-framework-badge mb-2"><i class="bi bi-speedometer2"></i> SOCRATES: Severity Rating (1-10)</div>
                                <h3 class="fw-bold text-dark mb-1">Rate the severity of your discomfort</h3>
                                <p class="text-muted small">Choose the intensity score from 1 (Mild) to 10 (Critical Unbearable).</p>
                            </div>

                            <input type="hidden" id="answerInput" name="answerText" value="${not empty medicalCase.severity ? medicalCase.severity : 'Severe (8/10)'}">

                            <div class="d-grid gap-3 mb-4">
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Mild (1-3/10)' ? 'selected' : ''}" onclick="selectAnswer('Mild (1-3/10)', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold text-success">Mild (1–3 / 10)</div>
                                        <div class="small text-muted">Noticeable but routine activities continue</div>
                                    </div>
                                    <span class="badge bg-success bg-opacity-10 text-success">Mild</span>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Moderate (4-6/10)' ? 'selected' : ''}" onclick="selectAnswer('Moderate (4-6/10)', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold text-warning">Moderate (4–6 / 10)</div>
                                        <div class="small text-muted">Interferes with work and daily movement</div>
                                    </div>
                                    <span class="badge bg-warning bg-opacity-10 text-warning">Moderate</span>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Severe (8/10)' || empty medicalCase.severity ? 'selected' : ''}" onclick="selectAnswer('Severe (8/10)', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold text-danger">Severe (7–8 / 10)</div>
                                        <div class="small text-muted">Acute distress requiring prompt medical attention</div>
                                    </div>
                                    <span class="badge bg-danger bg-opacity-10 text-danger">Severe</span>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Critical (9-10/10)' ? 'selected' : ''}" onclick="selectAnswer('Critical (9-10/10)', 'TOUCH', this)">
                                    <div>
                                        <div class="fw-bold text-danger">Critical (9–10 / 10)</div>
                                        <div class="small text-muted">Unbearable emergency pain</div>
                                    </div>
                                    <span class="badge bg-danger text-white">Critical</span>
                                </button>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 7: SOCRATES - ASSOCIATED SYMPTOMS ---------------- -->
                        <c:if test="${currentStep == 7}">
                            <input type="hidden" name="questionCode" value="Q_ASSOCIATED_SYMPTOMS">
                            <input type="hidden" name="questionText" value="[SOCRATES: A - Associated Symptoms]">

                            <div class="text-center mb-4">
                                <div class="mk-framework-badge mb-2"><i class="bi bi-plus-circle"></i> SOCRATES: Associated Symptoms</div>
                                <h3 class="fw-bold text-dark mb-1">Any associated symptoms?</h3>
                                <p class="text-muted small">Check all symptoms occurring along with your main complaint.</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <div class="form-check p-3 bg-light rounded border">
                                        <input class="form-check-input ms-0 me-2" type="checkbox" id="symp1" value="Breathing difficulty" checked onchange="updateSymptoms()">
                                        <label class="form-check-label fw-semibold small" for="symp1">Breathing difficulty / Saans ki takleef</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check p-3 bg-light rounded border">
                                        <input class="form-check-input ms-0 me-2" type="checkbox" id="symp2" value="Cold perspiration / Sweats" checked onchange="updateSymptoms()">
                                        <label class="form-check-label fw-semibold small" for="symp2">Sweating / Perspiration</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check p-3 bg-light rounded border">
                                        <input class="form-check-input ms-0 me-2" type="checkbox" id="symp3" value="Nausea / Dizziness" onchange="updateSymptoms()">
                                        <label class="form-check-label fw-semibold small" for="symp3">Nausea / Dizziness</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check p-3 bg-light rounded border">
                                        <input class="form-check-input ms-0 me-2" type="checkbox" id="symp4" value="Radiating pain to left arm" checked onchange="updateSymptoms()">
                                        <label class="form-check-label fw-semibold small" for="symp4">Pain radiating to left arm/jaw</label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Summary of symptoms:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.associatedSymptoms ? medicalCase.associatedSymptoms : 'Breathing difficulty, cold perspiration, pain radiating to left arm'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 8: PAST MEDICAL & SURGICAL HISTORY ---------------- -->
                        <c:if test="${currentStep == 8}">
                            <input type="hidden" name="questionCode" value="Q_PAST_DISEASES">
                            <input type="hidden" name="questionText" value="Previous medical conditions">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Previous Medical Conditions</h3>
                                <p class="text-muted small">Do you have any ongoing or diagnosed health conditions?</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Type 2 Diabetes Mellitus' ? 'selected' : ''}" onclick="selectAnswer('Type 2 Diabetes Mellitus (since 2024)', 'TOUCH', this)">
                                        <span>Diabetes</span>
                                        <i class="bi bi-droplet"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Hypertension (High BP)' ? 'selected' : ''}" onclick="selectAnswer('Hypertension (High BP)', 'TOUCH', this)">
                                        <span>High BP</span>
                                        <i class="bi bi-speedometer2"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Asthma / Respiratory' ? 'selected' : ''}" onclick="selectAnswer('Asthma / Respiratory', 'TOUCH', this)">
                                        <span>Asthma</span>
                                        <i class="bi bi-lungs"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Thyroid Disorder' ? 'selected' : ''}" onclick="selectAnswer('Thyroid Disorder', 'TOUCH', this)">
                                        <span>Thyroid</span>
                                        <i class="bi bi-circle"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'None' ? 'selected' : ''}" onclick="selectAnswer('None', 'TOUCH', this)">
                                        <span>None</span>
                                        <i class="bi bi-check-circle"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Details or year diagnosed:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.pastMedicalHistory ? medicalCase.pastMedicalHistory : 'Type 2 Diabetes Mellitus (diagnosed in 2024)'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 9: MEDICATIONS & ALLERGIES ---------------- -->
                        <c:if test="${currentStep == 9}">
                            <input type="hidden" name="questionCode" value="Q_MEDICATIONS">
                            <input type="hidden" name="questionText" value="Current ongoing medications and allergies">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Current Medications & Allergies</h3>
                                <p class="text-muted small">List any tablets, insulin, or syrups you take regularly, or speak them.</p>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <label class="form-label fw-semibold small text-muted mb-0">Medications & Dosages:</label>
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="selectAnswer('Tab. Metformin 500 mg BD (after meals)', 'TOUCH', this)">
                                        <i class="bi bi-capsule"></i> Metformin 500mg (Auto-fill)
                                    </button>
                                </div>
                                <div class="input-group">
                                    <input type="text" class="form-control form-control-lg" id="answerInput" name="answerText" value="${not empty medicalCase.currentMedication ? medicalCase.currentMedication : 'Tab. Metformin 500 mg BD (after meals)'}" placeholder="e.g. Metformin 500 mg BD" required>
                                    <button type="button" class="mk-mic-btn ms-2" id="micBtn">
                                        <i class="bi bi-mic-fill"></i>
                                    </button>
                                </div>
                                <div id="voiceStatus" class="small mt-2 text-muted">You can speak medicine names or upload previous prescription in the next step.</div>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 10: AYUSH INTAKE PROFILE ---------------- -->
                        <c:if test="${currentStep == 10}">
                            <input type="hidden" name="questionCode" value="Q_AYUSH_PRAKRITI">
                            <input type="hidden" name="questionText" value="[AYUSH: Prakriti, Agni, Koshtha & Lifestyle Profile]">

                            <div class="text-center mb-4">
                                <div class="mk-framework-badge mb-2" style="background:#ecfdf5; color:#046a38; border: 1px solid rgba(4,106,56,0.2);">
                                    <i class="bi bi-flower1"></i> Ministry of Ayush &bull; Integrative Clinical Intake
                                </div>
                                <h3 class="fw-bold text-dark mb-1">Ayush Constitution & Lifestyle Profile</h3>
                                <p class="text-muted small">Standardized for Ayush Grid, NAMASTE Morbidity Portal, and WHO ICD-11 TM2 Module.</p>
                            </div>

                            <!-- Ayush Stream Selection Tabs/Pills -->
                            <div class="mb-3">
                                <label class="form-label fw-bold small text-dark mb-2">
                                    <i class="bi bi-diagram-3 text-success me-1"></i> Consultation Stream / Department:
                                </label>
                                <div class="d-flex flex-wrap gap-2 mb-3">
                                    <button type="button" class="ayush-stream-pill ayush-stream-ayurveda" onclick="setAyushStream('Ayurveda')">Ayurveda</button>
                                    <button type="button" class="ayush-stream-pill ayush-stream-yoga" onclick="setAyushStream('Yoga & Naturopathy')">Yoga & Naturopathy</button>
                                    <button type="button" class="ayush-stream-pill ayush-stream-unani" onclick="setAyushStream('Unani')">Unani</button>
                                    <button type="button" class="ayush-stream-pill ayush-stream-siddha" onclick="setAyushStream('Siddha')">Siddha</button>
                                    <button type="button" class="ayush-stream-pill ayush-stream-homoeo" onclick="setAyushStream('Homoeopathy')">Homoeopathy</button>
                                    <button type="button" class="ayush-stream-pill" style="background:#e0f2fe; color:#0369a1; border-color:#bae6fd;" onclick="setAyushStream('Integrative OPD')">Integrative OPD</button>
                                </div>
                            </div>

                            <!-- Prakriti / Constitutional Dominance -->
                            <label class="form-label fw-bold small text-dark mb-2">
                                <i class="bi bi-person-hearts text-danger me-1"></i> Constitutional Dominance (Prakriti / Mizaj):
                            </label>
                            <div class="row g-2 mb-3">
                                <div class="col-6 col-md-3">
                                    <button type="button" class="mk-touch-option w-100 selected text-start p-2" onclick="setConstitution('Pitta-Vata (Metabolic & Variable)', this)">
                                        <div class="fw-bold text-dark small"><i class="bi bi-fire text-warning me-1"></i> Pitta-Vata</div>
                                        <div class="text-muted" style="font-size:0.75rem;">Heat sensitive, active</div>
                                    </button>
                                </div>
                                <div class="col-6 col-md-3">
                                    <button type="button" class="mk-touch-option w-100 text-start p-2" onclick="setConstitution('Kapha-Pitta (Moderate & Steady)', this)">
                                        <div class="fw-bold text-dark small"><i class="bi bi-water text-primary me-1"></i> Kapha-Pitta</div>
                                        <div class="text-muted" style="font-size:0.75rem;">Steady, cool build</div>
                                    </button>
                                </div>
                                <div class="col-6 col-md-3">
                                    <button type="button" class="mk-touch-option w-100 text-start p-2" onclick="setConstitution('Vata Predominant (Quick, Dry)', this)">
                                        <div class="fw-bold text-dark small"><i class="bi bi-wind text-info me-1"></i> Vata Dominant</div>
                                        <div class="text-muted" style="font-size:0.75rem;">Light sleep, variable</div>
                                    </button>
                                </div>
                                <div class="col-6 col-md-3">
                                    <button type="button" class="mk-touch-option w-100 text-start p-2" onclick="setConstitution('Sama / Balanced Constitution', this)">
                                        <div class="fw-bold text-dark small"><i class="bi bi-check-circle-fill text-success me-1"></i> Sama / Balanced</div>
                                        <div class="text-muted" style="font-size:0.75rem;">Equilibrium of doshas</div>
                                    </button>
                                </div>
                            </div>

                            <!-- Digestion & Bowel (Agni & Koshtha) -->
                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-6">
                                    <label class="form-label fw-semibold small text-muted mb-1">
                                        <i class="bi bi-fire text-danger me-1"></i>Digestive Capacity (Agni / अग्नि):
                                    </label>
                                    <div class="d-flex flex-wrap gap-1">
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Agni', 'Sama Agni (Normal/Balanced)')">Sama (Balanced)</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Agni', 'Tikshna Agni (Hyper/Acidic)')">Tikshna (Acidic)</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Agni', 'Manda Agni (Slow/Sluggish)')">Manda (Slow)</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Agni', 'Vishama Agni (Irregular/Bloating)')">Vishama (Irregular)</button>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label fw-semibold small text-muted mb-1">
                                        <i class="bi bi-moon-stars text-primary me-1"></i>Sleep Pattern (Nidra / निद्रा):
                                    </label>
                                    <div class="d-flex flex-wrap gap-1">
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Nidra', 'Sukha Nidra (Sound 7-8 hrs)')">Sound (7-8 hrs)</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Nidra', 'Alpa Nidra (Interrupted < 6 hrs)')">Interrupted (&lt; 6 hrs)</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Nidra', 'Anidra (Severe Insomnia)')">Insomnia</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Nidra', 'Ati Nidra (Excessive Daytime)')">Excessive Daytime</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Dashavidha Pariksha Matrix: Tissue Vitality (Sara) & Physical Endurance (Vyayama) -->
                            <div class="row g-3 mb-3">
                                <div class="col-12 col-md-6">
                                    <label class="form-label fw-semibold small text-muted mb-1">
                                        <i class="bi bi-shield-plus text-success me-1"></i>Tissue Vitality (Sara / धातु सारता):
                                    </label>
                                    <div class="d-flex flex-wrap gap-1">
                                        <button type="button" class="btn btn-sm btn-outline-success py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Sara', 'Pravara Sara (Superior Tissue Essence)')">Pravara (High)</button>
                                        <button type="button" class="btn btn-sm btn-outline-success py-1 px-2 active" style="font-size:0.8rem;" onclick="appendAyushTrait('Sara', 'Madhyama Sara (Moderate Vitality)')">Madhyama (Moderate)</button>
                                        <button type="button" class="btn btn-sm btn-outline-success py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Sara', 'Avara Sara (Suboptimal Vitality)')">Avara (Low)</button>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6">
                                    <label class="form-label fw-semibold small text-muted mb-1">
                                        <i class="bi bi-heart-pulse text-success me-1"></i>Physical Endurance (Vyayama Shakti / व्यायाम शक्ति):
                                    </label>
                                    <div class="d-flex flex-wrap gap-1">
                                        <button type="button" class="btn btn-sm btn-outline-success py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Vyayama', 'Pravara Vyayama (High Stamina)')">Pravara (High)</button>
                                        <button type="button" class="btn btn-sm btn-outline-success py-1 px-2 active" style="font-size:0.8rem;" onclick="appendAyushTrait('Vyayama', 'Madhyama Vyayama (Moderate Stamina)')">Madhyama (Moderate)</button>
                                        <button type="button" class="btn btn-sm btn-outline-success py-1 px-2" style="font-size:0.8rem;" onclick="appendAyushTrait('Vyayama', 'Avara Vyayama (Easily Fatigued)')">Avara (Low)</button>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Official Ayush Intake Summary (NAMASTE Standard):</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.ayushPrakriti ? medicalCase.ayushPrakriti : 'Stream: Ayurveda | Constitution: Pitta-Vata | Agni: Vishama Agni | Nidra: Alpa Nidra | Sara: Madhyama Sara | Vyayama: Madhyama Vyayama'}" required>
                            </div>

                            <div class="p-3 bg-light rounded border mb-4 d-flex align-items-center gap-3">
                                <div class="bg-success text-white rounded-circle p-2 d-flex align-items-center justify-content-center" style="width:36px; height:36px;">
                                    <i class="bi bi-shield-check fs-5"></i>
                                </div>
                                <div>
                                    <div class="small fw-semibold text-dark">Pre-Consultation Clinical Intake Ready</div>
                                    <div class="small text-muted">Proceeding to step 11 will summarize and submit your case to the Ayush OPD queue.</div>
                                </div>
                            </div>

                            <script>
                                let currentStream = 'Ayurveda';
                                let currentConst = 'Pitta-Vata';
                                let currentAgni = 'Vishama Agni';
                                let currentNidra = 'Alpa Nidra';
                                let currentSara = 'Madhyama Sara';
                                let currentVyayama = 'Madhyama Vyayama';

                                function updateAyushInput() {
                                    const input = document.getElementById('answerInput');
                                    if (input) {
                                        input.value = 'Stream: ' + currentStream + ' | Constitution: ' + currentConst + ' | Agni: ' + currentAgni + ' | Nidra: ' + currentNidra + ' | Sara: ' + currentSara + ' | Vyayama: ' + currentVyayama;
                                    }
                                }

                                function setAyushStream(stream) {
                                    currentStream = stream;
                                    updateAyushInput();
                                }

                                function setConstitution(c, btn) {
                                    currentConst = c;
                                    document.querySelectorAll('.mk-touch-option').forEach(el => el.classList.remove('selected'));
                                    if (btn) btn.classList.add('selected');
                                    updateAyushInput();
                                }

                                function appendAyushTrait(type, val) {
                                    if (type === 'Agni') currentAgni = val;
                                    if (type === 'Nidra') currentNidra = val;
                                    if (type === 'Sara') currentSara = val;
                                    if (type === 'Vyayama') currentVyayama = val;
                                    updateAyushInput();
                                }
                            </script>
                        </c:if>

                        <!-- Navigation Footer Buttons (Responsive & Mobile Sticky) -->
                        <div class="d-flex justify-content-between align-items-center pt-3 border-top mk-sticky-mobile-actions">
                            <c:choose>
                                <c:when test="${currentStep > 1}">
                                    <button type="submit" name="action" value="back" class="btn mk-btn mk-btn-secondary px-3 px-md-4">
                                        <i class="bi bi-arrow-left"></i> <span class="d-none d-sm-inline">Back</span>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="/patient/dashboard" class="btn mk-btn mk-btn-secondary px-3 px-md-4">
                                        <i class="bi bi-x-circle"></i> <span class="d-none d-sm-inline">Cancel</span>
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <button type="submit" name="action" value="next" class="btn mk-btn mk-btn-primary mk-btn-lg px-4">
                                <span>Continue</span>
                                <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                        </div>

                    </form>

                </div>
            </c:otherwise>
        </c:choose>

            </div>
        </div>
    </main>

    <!-- Voice Recognition Module -->
    <script src="/js/medikiosk-voice.js"></script>
    <script src="/js/medikiosk-a11y.js"></script>
    <script>
        let convRecognition = null;
        let isConvRecording = false;

        document.addEventListener('DOMContentLoaded', () => {
            const pb = document.getElementById('progressBar');
            if (pb && pb.getAttribute('data-progress')) {
                pb.style.width = pb.getAttribute('data-progress') + '%';
            }
            const langCode = '${lang}' === 'Hindi' ? 'hi-IN' : 'en-IN';
            const answerEl = document.getElementById('answerInput');
            if (answerEl) {
                new MediKioskVoice({
                    targetInputId: 'answerInput',
                    micButtonId: 'micBtn',
                    statusElementId: 'voiceStatus',
                    lang: langCode
                });
            }

            // Scroll chat to bottom
            const stream = document.getElementById('chatStream');
            if (stream) {
                stream.scrollTop = stream.scrollHeight;
            }
        });

        function switchIntakeMode(mode) {
            window.location.href = '/patient/case-taking?mode=' + mode + (mode === 'steps' ? '&step=1' : '');
        }

        function quickSend(message, entityCode, entityVal) {
            sendConversationalPayload(message, entityCode, entityVal);
        }

        function sendConversationalMsg() {
            const input = document.getElementById('convInput');
            if (!input || !input.value.trim()) return;
            const text = input.value.trim();
            input.value = '';
            sendConversationalPayload(text, null, null);
        }

        function sendConversationalPayload(message, entityCode, entityVal) {
            const stream = document.getElementById('chatStream');
            if (!stream) return;

            // Append user bubble
            const userMsgEl = document.createElement('div');
            userMsgEl.className = 'mk-chat-msg msg-user';
            userMsgEl.innerHTML = '<div class="mk-chat-avatar"><i class="bi bi-person-fill"></i></div><div class="mk-chat-bubble">' + escapeHtml(message) + '</div>';
            stream.appendChild(userMsgEl);
            stream.scrollTop = stream.scrollHeight;

            // Typing indicator
            const typingEl = document.createElement('div');
            typingEl.className = 'mk-chat-msg msg-ai typing-msg';
            typingEl.innerHTML = '<div class="mk-chat-avatar"><i class="bi bi-hospital"></i></div><div class="mk-chat-bubble text-muted"><span class="spinner-grow spinner-grow-sm me-2"></span>Clinical Assistant analyzing...</div>';
            stream.appendChild(typingEl);
            stream.scrollTop = stream.scrollHeight;

            const formData = new URLSearchParams();
            formData.append('message', message);
            if (entityCode) formData.append('entityCode', entityCode);
            if (entityVal) formData.append('entityValue', entityVal);
            formData.append('lang', '${lang}');

            fetch('/patient/conversational-intake', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                typingEl.remove();
                if (data.reply) {
                    const aiMsgEl = document.createElement('div');
                    aiMsgEl.className = 'mk-chat-msg msg-ai';
                    aiMsgEl.innerHTML = '<div class="mk-chat-avatar"><i class="bi bi-hospital"></i></div><div class="mk-chat-bubble">' + escapeHtml(data.reply) + '</div>';
                    stream.appendChild(aiMsgEl);
                    stream.scrollTop = stream.scrollHeight;

                    // Text-To-Speech read aloud
                    if ('speechSynthesis' in window) {
                        const utt = new SpeechSynthesisUtterance(data.reply);
                        utt.lang = '${lang}' === 'Hindi' ? 'hi-IN' : 'en-IN';
                        window.speechSynthesis.speak(utt);
                    }
                }

                // Update live telemetry
                if (data.chiefComplaint) document.getElementById('liveComplaint').innerText = data.chiefComplaint;
                if (data.onset) document.getElementById('liveOnset').innerText = data.onset;
                if (data.severity) document.getElementById('liveSeverity').innerText = data.severity;
                if (data.medications) document.getElementById('liveMedications').innerText = data.medications;
                if (data.priority) {
                    const badge = document.getElementById('livePriorityBadge');
                    if (badge) {
                        badge.innerText = 'Priority: ' + data.priority;
                        if (data.priority === 'HIGH' || data.priority === 'CRITICAL') {
                            badge.className = 'badge bg-danger text-white';
                        }
                    }
                }

                // Deterministic emergency intercept
                if (data.interceptRequired && data.interceptUrl) {
                    setTimeout(() => {
                        window.location.href = data.interceptUrl;
                    }, 1200);
                }
            })
            .catch(err => {
                typingEl.remove();
                console.error(err);
            });
        }

        function toggleConversationalVoice() {
            const micBtn = document.getElementById('convMicBtn');
            const input = document.getElementById('convInput');
            const SpeechRec = window.SpeechRecognition || window.webkitSpeechRecognition;

            if (!SpeechRec) {
                alert('Speech recognition is not supported on this browser. Please type your message.');
                return;
            }

            if (isConvRecording && convRecognition) {
                convRecognition.stop();
                isConvRecording = false;
                micBtn.classList.remove('recording');
                return;
            }

            convRecognition = new SpeechRec();
            convRecognition.lang = '${lang}' === 'Hindi' ? 'hi-IN' : 'en-IN';
            convRecognition.interimResults = false;
            convRecognition.maxAlternatives = 1;

            convRecognition.onstart = () => {
                isConvRecording = true;
                micBtn.classList.add('recording');
                if (window.announceA11y) window.announceA11y('Microphone listening...');
            };

            convRecognition.onresult = (e) => {
                const transcript = e.results[0][0].transcript;
                if (input) input.value = transcript;
                sendConversationalMsg();
            };

            convRecognition.onerror = (e) => {
                console.warn('Voice error:', e.error);
                isConvRecording = false;
                micBtn.classList.remove('recording');
            };

            convRecognition.onend = () => {
                isConvRecording = false;
                micBtn.classList.remove('recording');
            };

            convRecognition.start();
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.innerText = text;
            return div.innerHTML;
        }

        function readAloudQuestion() {
            if ('speechSynthesis' in window) {
                window.speechSynthesis.cancel();
                // Extract question text
                const qTitle = document.querySelector('.mk-card h4, .mk-card h5');
                const text = qTitle ? qTitle.innerText.trim() : 'Please answer the current medical question.';
                const utterance = new SpeechSynthesisUtterance(text);
                utterance.lang = '${lang}' === 'Hindi' ? 'hi-IN' : 'en-IN';
                window.speechSynthesis.speak(utterance);
                if (window.announceA11y) window.announceA11y('Reading question aloud: ' + text);
            } else {
                alert('Audio playback is not supported in this browser.');
            }
        }

        function selectAnswer(text, type, buttonEl) {
            const input = document.getElementById('answerInput');
            if (input) input.value = text;
            const inputTypeEl = document.getElementById('inputType');
            if (inputTypeEl) inputTypeEl.value = type;
            
            document.querySelectorAll('.mk-touch-option').forEach(el => el.classList.remove('selected'));
            if (buttonEl) {
                buttonEl.classList.add('selected');
            }
        }

        function setDemoVoiceSample() {
            const input = document.getElementById('answerInput');
            if (input) {
                input.value = "Mujhe do ghante se chest mein severe pain ho raha hai aur saans lene mein takleef hai.";
            }
        }

        function updateSymptoms() {
            const symps = [];
            if (document.getElementById('symp1')?.checked) symps.push('Breathing difficulty');
            if (document.getElementById('symp2')?.checked) symps.push('Cold perspiration / Sweats');
            if (document.getElementById('symp3')?.checked) symps.push('Nausea / Dizziness');
            if (document.getElementById('symp4')?.checked) symps.push('Radiating pain to left arm');
            const input = document.getElementById('answerInput');
            if (input) input.value = symps.join(', ');
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
