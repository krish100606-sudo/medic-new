<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinical Case Intake — Question ${currentStep} of ${totalSteps} — MediKiosk</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons (No Emojis) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Top Navigation -->
    <header class="mk-navbar sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="mk-brand" href="/patient/dashboard">
                <i class="bi bi-hospital text-primary fs-4"></i>
                <span>MediKiosk</span>
                <span class="mk-brand-badge">Clinical Intake</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-light text-dark border"><i class="bi bi-translate me-1"></i> ${lang}</span>
                <a href="/patient/dashboard" class="btn mk-btn mk-btn-secondary btn-sm">
                    <i class="bi bi-door-closed"></i> Save & Exit
                </a>
            </div>
        </div>
    </header>

    <!-- Intake Container -->
    <main class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-xl-7">

                <!-- Progress Header -->
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="fw-bold text-primary small text-uppercase">Question ${currentStep} of ${totalSteps}</span>
                        <span class="text-muted small">${(currentStep * 10)}% Completed</span>
                    </div>
                    <div class="progress" style="height: 8px;">
                        <div class="progress-bar bg-primary" role="progressbar" style="width: ${(currentStep * 10)}%;"></div>
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

                            <!-- Fast Touch Options -->
                            <div class="row g-2 mb-4">
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Chest Pain' ? 'selected' : ''}" onclick="selectAnswer('Chest Pain', 'TOUCH')">
                                        <span>Chest Pain</span>
                                        <i class="bi bi-heart-pulse text-danger"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Fever and Cough' ? 'selected' : ''}" onclick="selectAnswer('Fever and Cough', 'TOUCH')">
                                        <span>Fever / Cough</span>
                                        <i class="bi bi-thermometer-high text-warning"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Shortness of Breath' ? 'selected' : ''}" onclick="selectAnswer('Shortness of Breath', 'TOUCH')">
                                        <span>Breathlessness</span>
                                        <i class="bi bi-lungs text-primary"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Severe Headache' ? 'selected' : ''}" onclick="selectAnswer('Severe Headache', 'TOUCH')">
                                        <span>Headache</span>
                                        <i class="bi bi-activity text-secondary"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Abdominal Pain' ? 'selected' : ''}" onclick="selectAnswer('Abdominal Pain', 'TOUCH')">
                                        <span>Abdominal Pain</span>
                                        <i class="bi bi-slash-circle text-info"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.chiefComplaint == 'Joint Pain / Injury' ? 'selected' : ''}" onclick="selectAnswer('Joint Pain / Injury', 'TOUCH')">
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
                                <div id="voiceStatus" class="small mt-2 text-muted">Click microphone to speak (English or Hindi).</div>
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
                                <p class="text-muted small">You can speak in Hindi or English (e.g. "Mujhe do ghante se chest mein pain ho raha hai").</p>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <label class="form-label fw-semibold small text-muted mb-0">Your Spoken / Written Statement:</label>
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="setDemoVoiceSample()">
                                        <i class="bi bi-magic"></i> Auto-fill Sample Voice
                                    </button>
                                </div>
                                <div class="position-relative">
                                    <textarea class="form-control" id="answerInput" name="answerText" rows="4" placeholder="Speak or type your symptoms freely..." required>${not empty medicalCase.patientStatement ? medicalCase.patientStatement : 'Mujhe do ghante se chest mein pain ho raha hai.'}</textarea>
                                </div>
                                <div class="d-flex align-items-center gap-3 mt-3">
                                    <button type="button" class="mk-mic-btn" id="micBtn">
                                        <i class="bi bi-mic-fill"></i>
                                    </button>
                                    <div>
                                        <div class="fw-semibold small">Microphone Voice Input</div>
                                        <div id="voiceStatus" class="small text-muted">Tap mic and speak in English or Hindi. You can edit afterwards.</div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 3: ONSET / DURATION ---------------- -->
                        <c:if test="${currentStep == 3}">
                            <input type="hidden" name="questionCode" value="Q_ONSET">
                            <input type="hidden" name="questionText" value="When did the problem start?">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">When did the problem start?</h3>
                                <c:if test="${lang == 'Hindi'}">
                                    <h5 class="text-muted fw-normal">यह समस्या कब शुरू हुई?</h5>
                                </c:if>
                                <p class="text-muted small">Select the duration of your symptoms.</p>
                            </div>

                            <input type="hidden" id="answerInput" name="answerText" value="${not empty medicalCase.onset ? medicalCase.onset : 'Today'}">

                            <div class="d-grid gap-3 mb-4">
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == 'Today' || empty medicalCase.onset ? 'selected' : ''}" onclick="selectAnswer('Today', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold">Today (Few hours ago)</div>
                                        <div class="small text-muted">Acute onset started within the last 24 hours</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == '1–3 days' ? 'selected' : ''}" onclick="selectAnswer('1–3 days', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold">1–3 days</div>
                                        <div class="small text-muted">Started over the past couple of days</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == '4–7 days' ? 'selected' : ''}" onclick="selectAnswer('4–7 days', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold">4–7 days</div>
                                        <div class="small text-muted">Persistent over roughly one week</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.onset == 'More than 1 week' ? 'selected' : ''}" onclick="selectAnswer('More than 1 week', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold">More than 1 week</div>
                                        <div class="small text-muted">Chronic or long-standing discomfort</div>
                                    </div>
                                    <i class="bi bi-check-lg fs-4 text-primary"></i>
                                </button>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 4: LOCATION ---------------- -->
                        <c:if test="${currentStep == 4}">
                            <input type="hidden" name="questionCode" value="Q_LOCATION">
                            <input type="hidden" name="questionText" value="Where is the problem located?">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Where is the problem located?</h3>
                                <p class="text-muted small">Select the anatomical area or specify details.</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Substernal chest region radiating to left shoulder' ? 'selected' : ''}" onclick="selectAnswer('Substernal chest region radiating to left shoulder', 'TOUCH')">
                                        <span>Chest / Heart</span>
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Throat and Upper Respiratory' ? 'selected' : ''}" onclick="selectAnswer('Throat and Upper Respiratory', 'TOUCH')">
                                        <span>Throat / Neck</span>
                                        <i class="bi bi-activity"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Upper Abdomen / Stomach' ? 'selected' : ''}" onclick="selectAnswer('Upper Abdomen / Stomach', 'TOUCH')">
                                        <span>Abdomen</span>
                                        <i class="bi bi-slash-circle"></i>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.location == 'Head / Cranial' ? 'selected' : ''}" onclick="selectAnswer('Head / Cranial', 'TOUCH')">
                                        <span>Head / Eyes</span>
                                        <i class="bi bi-person"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Specific location description:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.location ? medicalCase.location : 'Substernal chest region radiating to left shoulder'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 5: SEVERITY ---------------- -->
                        <c:if test="${currentStep == 5}">
                            <input type="hidden" name="questionCode" value="Q_SEVERITY">
                            <input type="hidden" name="questionText" value="How severe is the problem?">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">How severe is the problem?</h3>
                                <p class="text-muted small">Choose the intensity level that best describes your discomfort.</p>
                            </div>

                            <input type="hidden" id="answerInput" name="answerText" value="${not empty medicalCase.severity ? medicalCase.severity : 'Severe (8/10)'}">

                            <div class="d-grid gap-3 mb-4">
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Mild (1-3/10)' ? 'selected' : ''}" onclick="selectAnswer('Mild (1-3/10)', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold text-success">Mild (1–3 / 10)</div>
                                        <div class="small text-muted">Noticeable but does not disrupt routine activities</div>
                                    </div>
                                    <span class="badge bg-success bg-opacity-10 text-success">Mild</span>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Moderate (4-6/10)' ? 'selected' : ''}" onclick="selectAnswer('Moderate (4-6/10)', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold text-warning">Moderate (4–6 / 10)</div>
                                        <div class="small text-muted">Uncomfortable and interferes with daily tasks</div>
                                    </div>
                                    <span class="badge bg-warning bg-opacity-10 text-warning">Moderate</span>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Severe (8/10)' || empty medicalCase.severity ? 'selected' : ''}" onclick="selectAnswer('Severe (8/10)', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold text-danger">Severe (7–8 / 10)</div>
                                        <div class="small text-muted">Severe distress, requires prompt medical evaluation</div>
                                    </div>
                                    <span class="badge bg-danger bg-opacity-10 text-danger">Severe</span>
                                </button>
                                <button type="button" class="mk-touch-option p-3 ${medicalCase.severity == 'Critical (9-10/10)' ? 'selected' : ''}" onclick="selectAnswer('Critical (9-10/10)', 'TOUCH')">
                                    <div>
                                        <div class="fw-bold text-danger">Critical (9–10 / 10)</div>
                                        <div class="small text-muted">Extremely acute unbearable pain</div>
                                    </div>
                                    <span class="badge bg-danger text-white">Critical</span>
                                </button>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 6: ASSOCIATED SYMPTOMS ---------------- -->
                        <c:if test="${currentStep == 6}">
                            <input type="hidden" name="questionCode" value="Q_ASSOCIATED_SYMPTOMS">
                            <input type="hidden" name="questionText" value="Do you have any associated symptoms?">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Do you have any associated symptoms?</h3>
                                <p class="text-muted small">Check all symptoms you are currently experiencing alongside the main complaint.</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <div class="form-check p-3 bg-light rounded border">
                                        <input class="form-check-input ms-0 me-2" type="checkbox" id="symp1" value="Breathing difficulty" checked onchange="updateSymptoms()">
                                        <label class="form-check-label fw-semibold small" for="symp1">Breathing difficulty / Saans lene mein takleef</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check p-3 bg-light rounded border">
                                        <input class="form-check-input ms-0 me-2" type="checkbox" id="symp2" value="Mild perspiration / Cold sweats" checked onchange="updateSymptoms()">
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
                                        <label class="form-check-label fw-semibold small" for="symp4">Pain radiating to arm/jaw</label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Summary of symptoms:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.associatedSymptoms ? medicalCase.associatedSymptoms : 'Breathing difficulty, mild perspiration, pain radiating to left arm'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 7: PAST MEDICAL HISTORY ---------------- -->
                        <c:if test="${currentStep == 7}">
                            <input type="hidden" name="questionCode" value="Q_PAST_DISEASES">
                            <input type="hidden" name="questionText" value="Previous medical conditions">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Previous Medical Conditions</h3>
                                <p class="text-muted small">Do you have any ongoing or diagnosed health conditions?</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Type 2 Diabetes Mellitus' ? 'selected' : ''}" onclick="selectAnswer('Type 2 Diabetes Mellitus (since 2024)', 'TOUCH')">
                                        <span>Diabetes</span>
                                        <i class="bi bi-droplet"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Hypertension (High BP)' ? 'selected' : ''}" onclick="selectAnswer('Hypertension (High BP)', 'TOUCH')">
                                        <span>High BP</span>
                                        <i class="bi bi-speedometer2"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Asthma / Respiratory' ? 'selected' : ''}" onclick="selectAnswer('Asthma / Respiratory', 'TOUCH')">
                                        <span>Asthma</span>
                                        <i class="bi bi-lungs"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'Thyroid Disorder' ? 'selected' : ''}" onclick="selectAnswer('Thyroid Disorder', 'TOUCH')">
                                        <span>Thyroid</span>
                                        <i class="bi bi-circle"></i>
                                    </button>
                                </div>
                                <div class="col-6 col-md-4">
                                    <button type="button" class="mk-touch-option w-100 ${medicalCase.pastMedicalHistory == 'None' ? 'selected' : ''}" onclick="selectAnswer('None', 'TOUCH')">
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

                        <!-- ---------------- STEP 8: SURGICAL HISTORY ---------------- -->
                        <c:if test="${currentStep == 8}">
                            <input type="hidden" name="questionCode" value="Q_SURGERIES">
                            <input type="hidden" name="questionText" value="Previous surgeries or hospitalizations">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Previous Surgeries</h3>
                                <p class="text-muted small">Have you undergone any major surgery or hospitalizations in the past?</p>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('Laparoscopic Appendectomy (2023)', 'TOUCH')">
                                        <span>Appendectomy (2023)</span>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('Gallbladder Surgery (Cholecystectomy)', 'TOUCH')">
                                        <span>Gallbladder Surgery</span>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('Cardiac / Stent Procedure', 'TOUCH')">
                                        <span>Cardiac Stent</span>
                                    </button>
                                </div>
                                <div class="col-6">
                                    <button type="button" class="mk-touch-option w-100" onclick="selectAnswer('No previous surgeries', 'TOUCH')">
                                        <span>No Surgeries</span>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold small text-muted">Surgery description & year:</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.surgicalHistory ? medicalCase.surgicalHistory : 'Laparoscopic Appendectomy (2023), uneventful recovery'}" required>
                            </div>
                        </c:if>

                        <!-- ---------------- STEP 9: CURRENT MEDICATIONS ---------------- -->
                        <c:if test="${currentStep == 9}">
                            <input type="hidden" name="questionCode" value="Q_MEDICATIONS">
                            <input type="hidden" name="questionText" value="Current medications">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Current Medications</h3>
                                <p class="text-muted small">List any tablets, insulin, or syrups you take on a daily or regular basis.</p>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <label class="form-label fw-semibold small text-muted mb-0">Medications & Dosages:</label>
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="selectAnswer('Tab. Metformin 500 mg BD (after meals)', 'TOUCH')">
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

                        <!-- ---------------- STEP 10: ALLERGIES & FAMILY HISTORY ---------------- -->
                        <c:if test="${currentStep == 10}">
                            <input type="hidden" name="questionCode" value="Q_ALLERGIES">
                            <input type="hidden" name="questionText" value="Allergies and Family History">

                            <div class="text-center mb-4">
                                <h3 class="fw-bold text-dark mb-1">Allergies & Family History</h3>
                                <p class="text-muted small">Final question: any known drug allergies or family history of cardiac/diabetes disease?</p>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold small text-muted">Allergies (Medicines, Food, Contrast):</label>
                                <input type="text" class="form-control" id="answerInput" name="answerText" value="${not empty medicalCase.allergies ? medicalCase.allergies : 'No known drug or food allergies (NKDA)'}" required>
                            </div>

                            <div class="p-3 bg-light rounded border mb-4">
                                <div class="small fw-semibold text-dark mb-1"><i class="bi bi-check2-circle text-primary me-1"></i> Ready for Document Digitization</div>
                                <div class="small text-muted">Next step: Upload previous prescriptions or blood reports to auto-extract clinical values.</div>
                            </div>
                        </c:if>

                        <!-- Navigation Footer Buttons -->
                        <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                            <c:choose>
                                <c:when test="${currentStep > 1}">
                                    <button type="submit" name="action" value="back" class="btn mk-btn mk-btn-secondary">
                                        <i class="bi bi-arrow-left"></i> Back
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="/patient/dashboard" class="btn mk-btn mk-btn-secondary">
                                        <i class="bi bi-x-circle"></i> Cancel
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <button type="submit" name="action" value="next" class="btn mk-btn mk-btn-primary mk-btn-lg">
                                <span>Continue</span>
                                <i class="bi bi-arrow-right"></i>
                            </button>
                        </div>

                    </form>

                </div>

            </div>
        </div>
    </main>

    <!-- Voice Recognition Module -->
    <script src="/js/medikiosk-voice.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const langCode = '${lang}' === 'Hindi' ? 'hi-IN' : 'en-IN';
            new MediKioskVoice({
                targetInputId: 'answerInput',
                micButtonId: 'micBtn',
                statusElementId: 'voiceStatus',
                lang: langCode
            });
        });

        function selectAnswer(text, type) {
            const input = document.getElementById('answerInput');
            if (input) input.value = text;
            const inputTypeEl = document.getElementById('inputType');
            if (inputTypeEl) inputTypeEl.value = type;
        }

        function setDemoVoiceSample() {
            const input = document.getElementById('answerInput');
            if (input) {
                input.value = "Mujhe do ghante se chest mein pain ho raha hai aur saans lene mein takleef hai.";
            }
        }

        function updateSymptoms() {
            const symps = [];
            if (document.getElementById('symp1')?.checked) symps.push('Breathing difficulty');
            if (document.getElementById('symp2')?.checked) symps.push('Mild perspiration');
            if (document.getElementById('symp3')?.checked) symps.push('Nausea / Dizziness');
            if (document.getElementById('symp4')?.checked) symps.push('Radiating pain to left arm');
            const input = document.getElementById('answerInput');
            if (input) input.value = symps.join(', ');
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
