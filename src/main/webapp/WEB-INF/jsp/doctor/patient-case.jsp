<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinical Case Review — ${patient.user.name} (Token #${medicalCase.tokenNumber}) — MediKiosk</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons (No Emojis) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Top Header -->
    <header class="mk-navbar sticky-top">
        <div class="container-fluid px-4 d-flex justify-content-between align-items-center">
            <a class="mk-brand" href="/doctor/dashboard">
                <i class="bi bi-hospital text-primary fs-4"></i>
                <span>MediKiosk</span>
                <span class="mk-brand-badge bg-secondary bg-opacity-10 text-secondary">Doctor Workstation</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <a href="/doctor/dashboard" class="btn mk-btn mk-btn-secondary btn-sm">
                    <i class="bi bi-arrow-left"></i> Return to Queue
                </a>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container-fluid px-4 py-4">

        <!-- Case Header & Patient Demographics -->
        <div class="mk-card mb-4 bg-white">
            <div class="d-flex flex-wrap justify-content-between align-items-center pb-3 mb-3 border-bottom gap-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-circle">
                        <i class="bi bi-person-badge fs-2"></i>
                    </div>
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <h3 class="fw-bold text-dark mb-0">${patient.user.name}</h3>
                            <span class="badge bg-primary fs-6">Token #${medicalCase.tokenNumber}</span>
                            <c:choose>
                                <c:when test="${medicalCase.status == 'VERIFIED'}">
                                    <span class="mk-badge mk-badge-verified"><i class="bi bi-shield-check"></i> Doctor Verified</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="mk-badge mk-badge-pending"><i class="bi bi-clock-history"></i> ${medicalCase.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-muted small mt-1">
                            <span>ID: <strong>${patient.patientId}</strong></span> &bull; 
                            <span>Age: <strong>${patient.age != null ? patient.age : "42"} yrs</strong></span> &bull; 
                            <span>Gender: <strong>${patient.gender}</strong></span> &bull; 
                            <span>Department: <strong class="text-primary">${patient.department}</strong></span> &bull; 
                            <span>Language: <strong>${patient.preferredLanguage}</strong></span>
                        </div>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${medicalCase.priority == 'HIGH' || medicalCase.priority == 'CRITICAL'}">
                            <span class="mk-badge mk-badge-high fs-6 p-2 px-3">
                                <i class="bi bi-exclamation-triangle-fill"></i> ${medicalCase.priority} Priority
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="mk-badge mk-badge-normal fs-6 p-2 px-3">
                                <i class="bi bi-check-circle"></i> Standard Priority
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Red-Flag Safety Alert Banner if present -->
            <c:if test="${medicalCase.redFlagsDetected}">
                <div class="mk-red-flag-box mb-0">
                    <div class="mk-red-flag-title">
                        <i class="bi bi-exclamation-octagon-fill fs-5"></i> High Priority Triage Red-Flag Alert
                    </div>
                    <div class="text-dark small mt-1">
                        <strong>Deterministic Reason:</strong> ${medicalCase.priorityReason}
                    </div>
                </div>
            </c:if>
        </div>

        <div class="row g-4">

            <!-- Left Column: Clinical Case Details & Digitized Records -->
            <div class="col-lg-7">

                <!-- Digitized Documents & OCR Findings -->
                <div class="mk-card mb-4">
                    <div class="mk-card-header">
                        <h6 class="fw-bold text-dark mb-0"><i class="bi bi-file-earmark-medical text-primary me-2"></i>Digitized Patient Documents (${documents != null ? documents.size() : 0})</h6>
                        <span class="badge bg-light text-dark border">OCR Auto-Parsed</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty documents}">
                            <div class="d-grid gap-3">
                                <c:forEach var="doc" items="${documents}">
                                    <div class="p-3 bg-light rounded border">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="fw-bold text-dark">
                                                <i class="bi bi-file-earmark-text text-primary me-1"></i> ${doc.originalFileName}
                                            </div>
                                            <span class="mk-badge mk-badge-verified small">${doc.documentType} &bull; Processed</span>
                                        </div>
                                        <div class="row g-2 small">
                                            <div class="col-md-4">
                                                <span class="text-muted">Extracted Diagnosis:</span>
                                                <div class="fw-semibold text-dark">${not empty doc.extractedDiagnosis ? doc.extractedDiagnosis : "None"}</div>
                                            </div>
                                            <div class="col-md-4">
                                                <span class="text-muted">Medications:</span>
                                                <div class="fw-semibold text-primary">${not empty doc.extractedMedications ? doc.extractedMedications : "None"}</div>
                                            </div>
                                            <div class="col-md-4">
                                                <span class="text-muted">Investigations:</span>
                                                <div class="fw-semibold text-secondary">${not empty doc.extractedInvestigations ? doc.extractedInvestigations : "None"}</div>
                                            </div>
                                        </div>
                                        <c:if test="${not empty doc.extractedText}">
                                            <details class="mt-2">
                                                <summary class="small text-muted" style="cursor: pointer;">View Raw OCR Extracted Text</summary>
                                                <pre class="bg-white p-2 rounded border small mt-1 mb-0" style="font-size: 0.75rem; white-space: pre-wrap;">${doc.extractedText}</pre>
                                            </details>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted small py-2">No documents attached to this case.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Chronological Medical Timeline -->
                <div class="mk-card mb-4">
                    <div class="mk-card-header">
                        <h6 class="fw-bold text-dark mb-0"><i class="bi bi-calendar-range text-primary me-2"></i>Chronological Medical Timeline</h6>
                    </div>
                    <div class="mk-timeline">
                        <div class="mk-timeline-item">
                            <div class="mk-timeline-date">2024</div>
                            <div class="mk-timeline-text">Type 2 Diabetes Mellitus diagnosed (Initial OPD consultation)</div>
                        </div>
                        <div class="mk-timeline-item">
                            <div class="mk-timeline-date">2025</div>
                            <div class="mk-timeline-text">Prescription renewed: Tab. Metformin 500 mg BD regularized</div>
                        </div>
                        <div class="mk-timeline-item">
                            <div class="mk-timeline-date">2026 (Recent Lab)</div>
                            <div class="mk-timeline-text">Pathology Report: HbA1c recorded at 7.8 %, Fasting Blood Glucose: 154 mg/dL</div>
                        </div>
                        <div class="mk-timeline-item">
                            <div class="mk-timeline-date">2026 (Today - Pre-Consultation)</div>
                            <div class="mk-timeline-text fw-bold text-primary">MediKiosk Intake: Presented with ${not empty medicalCase.chiefComplaint ? medicalCase.chiefComplaint : "Chest Pain"}</div>
                        </div>
                    </div>
                </div>

                <!-- Structured Summary Preview Card -->
                <div class="mk-card">
                    <div class="mk-card-header">
                        <h6 class="fw-bold text-dark mb-0"><i class="bi bi-body-text text-primary me-2"></i>Structured AI Clinical Summary</h6>
                        <span class="badge bg-light text-muted border">Pre-Consultation Digest</span>
                    </div>
                    <pre class="bg-light p-3 rounded border small text-dark mb-0" style="white-space: pre-wrap; font-family: monospace; font-size: 0.85rem;">${medicalCase.structuredSummary}</pre>
                </div>

            </div>

            <!-- Right Column: Doctor Review, Editable Fields & Verification Form -->
            <div class="col-lg-5">

                <!-- Doctor Editing & Verification Card -->
                <div class="mk-card">
                    <div class="mk-card-header">
                        <div>
                            <h6 class="fw-bold text-dark mb-0"><i class="bi bi-pencil-square text-primary me-2"></i>Clinician Review & Verification</h6>
                            <div class="small text-muted mt-1">Review, modify extracted fields, and confirm clinical history.</div>
                        </div>
                        <c:if test="${medicalCase.doctorEdited}">
                            <span class="badge bg-warning bg-opacity-25 text-warning border border-warning">Doctor Edited</span>
                        </c:if>
                    </div>

                    <!-- Verification Stamp if Already Verified -->
                    <c:if test="${medicalCase.status == 'VERIFIED'}">
                        <div class="mk-verified-stamp mb-4">
                            <div class="fs-4 fw-bold mb-1"><i class="bi bi-patch-check-fill text-primary"></i> VERIFIED CASE</div>
                            <div class="fw-semibold text-dark">${medicalCase.verifiedByDoctor}</div>
                            <div class="small text-muted">Verified on: ${medicalCase.verifiedAt}</div>
                            <c:if test="${not empty medicalCase.doctorClinicalNotes}">
                                <div class="mt-2 pt-2 border-top small text-dark text-start">
                                    <strong>Doctor Notes:</strong> ${medicalCase.doctorClinicalNotes}
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <form action="/doctor/case/${medicalCase.id}/edit" method="POST" id="doctorEditForm">
                        
                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Chief Complaint</label>
                            <input type="text" class="form-control" name="chiefComplaint" value="${medicalCase.chiefComplaint}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">History of Present Illness (HPI)</label>
                            <textarea class="form-control" name="patientStatement" rows="2">${medicalCase.patientStatement}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Past Medical History</label>
                            <input type="text" class="form-control" name="pastMedicalHistory" value="${medicalCase.pastMedicalHistory}">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Current Ongoing Medications</label>
                            <input type="text" class="form-control" name="currentMedication" value="${medicalCase.currentMedication}">
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-muted">Allergies</label>
                                <input type="text" class="form-control" name="allergies" value="${medicalCase.allergies}">
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-semibold small text-muted">Priority</label>
                                <select class="form-select" name="priority">
                                    <option value="HIGH" ${medicalCase.priority == 'HIGH' ? 'selected' : ''}>HIGH</option>
                                    <option value="NORMAL" ${medicalCase.priority == 'NORMAL' ? 'selected' : ''}>NORMAL</option>
                                    <option value="CRITICAL" ${medicalCase.priority == 'CRITICAL' ? 'selected' : ''}>CRITICAL</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small text-muted">Laboratory & Investigation Findings</label>
                            <input type="text" class="form-control" name="investigations" value="${medicalCase.investigations}">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted">Doctor's Clinical Notes & Assessment Plan</label>
                            <textarea class="form-control" name="doctorClinicalNotes" rows="3" placeholder="Enter clinical assessment, differential diagnosis, and recommended plan...">${medicalCase.doctorClinicalNotes}</textarea>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn mk-btn mk-btn-secondary">
                                <i class="bi bi-save"></i> Save Edited Fields
                            </button>
                            <button type="submit" formaction="/doctor/case/${medicalCase.id}/verify" class="btn mk-btn mk-btn-primary w-100 mk-btn-lg mt-2">
                                <i class="bi bi-check2-circle"></i> Confirm History & Verify Case
                            </button>
                        </div>
                    </form>

                </div>

            </div>
        </div>

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
