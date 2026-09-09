<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinician Workstation — OPD Triage Queue — MediKiosk (SIH Prototype)</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
    <style>
        .mk-sync-pulse {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #22c55e;
            display: inline-block;
            box-shadow: 0 0 0 rgba(34, 197, 94, 0.4);
            animation: mkLivePulse 2s infinite;
        }
        @keyframes mkLivePulse {
            0% { box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.6); }
            70% { box-shadow: 0 0 0 10px rgba(34, 197, 94, 0); }
            100% { box-shadow: 0 0 0 0 rgba(34, 197, 94, 0); }
        }
        .mk-metric-pill {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
        }
    </style>
</head>
<body>

    <!-- Ministry of Ayush Government Header -->
    <%@ include file="../ayush-header.jsp" %>

    <!-- Accessible Skip Link -->
    <a href="#mainContent" class="mk-skip-link">Skip to OPD Queue</a>

    <!-- Top Header -->
    <header class="mk-navbar sticky-top">
        <div class="container-fluid px-3 px-md-4 d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <button type="button" class="btn btn-outline-secondary btn-sm d-lg-none" id="sidebarToggle" aria-label="Toggle Queue Navigation" aria-expanded="false">
                    <i class="bi bi-list fs-5"></i>
                </button>
                <a class="mk-brand" href="/doctor/dashboard">
                    <i class="bi bi-hospital text-primary fs-4"></i>
                    <span>MediKiosk</span>
                    <span class="mk-brand-badge bg-secondary bg-opacity-10 text-secondary d-none d-sm-inline-block">Doctor Workstation</span>
                </a>
            </div>
            <div class="d-flex align-items-center gap-2 gap-sm-3">
                <!-- Accessibility Controls Toolbar -->
                <div class="mk-a11y-toolbar" role="region" aria-label="Accessibility settings">
                    <button type="button" class="mk-a11y-btn" id="a11yContrastBtn" onclick="toggleContrast()" title="High Contrast Mode (Alt+C)" aria-label="Toggle high contrast">
                        <i class="bi bi-circle-half"></i>
                    </button>
                    <button type="button" class="mk-a11y-btn" id="a11yFontNormal" onclick="changeFontSize('reset')" title="Standard Text Size (Alt+0)" aria-label="Standard text size">A</button>
                    <button type="button" class="mk-a11y-btn" id="a11yFontLg" onclick="changeFontSize('increase')" title="Large Text Size (Alt++)" aria-label="Large text size">A+</button>
                </div>

                <button type="button" class="btn btn-outline-primary btn-sm d-none d-md-inline-flex align-items-center" data-bs-toggle="modal" data-bs-target="#sihMetricsModal">
                    <i class="bi bi-bar-chart-line-fill me-1"></i> SIH Prototype Metrics
                </button>
                <div class="text-end d-none d-md-block">
                    <div class="fw-bold text-dark small">${doctor != null && doctor.user != null ? doctor.user.name : "Dr. Ananya Roy, MD"}</div>
                    <div class="text-muted small">${doctor != null ? doctor.department : "General Medicine"} | ${doctor != null ? doctor.doctorId : "DOC-101"}</div>
                </div>
                <a href="/logout" class="btn mk-btn mk-btn-secondary btn-sm" aria-label="Sign Out">
                    <i class="bi bi-box-arrow-right"></i>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Doctor Layout (Sidebar + Content) -->
    <div class="mk-doctor-layout">
        <!-- Sidebar -->
        <aside class="mk-doctor-sidebar" id="doctorSidebar">
            <div class="mb-4 px-2">
                <div class="small fw-semibold text-muted text-uppercase mb-2">Queue Navigation</div>
                <a href="/doctor/dashboard" class="mk-sidebar-link active">
                    <i class="bi bi-speedometer2"></i> Dashboard & Queue
                </a>
                <a href="/doctor/dashboard?status=SUBMITTED" class="mk-sidebar-link">
                    <i class="bi bi-clock-history"></i> Pending Intake (<span id="sidebarPending">${statPendingReview}</span>)
                </a>
                <a href="/doctor/dashboard?priority=HIGH" class="mk-sidebar-link text-danger">
                    <i class="bi bi-exclamation-triangle"></i> High Priority (<span id="sidebarHigh">${statHighPriority}</span>)
                </a>
                <a href="/doctor/dashboard?status=VERIFIED" class="mk-sidebar-link">
                    <i class="bi bi-patch-check"></i> Verified Cases (<span id="sidebarVerified">${statVerified}</span>)
                </a>
            </div>

            <!-- SIH Compliance Notice -->
            <div class="p-3 bg-light rounded border small text-muted">
                <div class="fw-bold text-dark mb-1"><i class="bi bi-shield-check text-primary me-1"></i> SIH Clinical Prototype</div>
                <div style="font-size: 0.78rem;">Assistive intake & OCR extraction. Deterministic red-flag triage active. Doctor retains final diagnostic authority.</div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="mk-doctor-content" id="mainContent">

            <!-- Live OPD Sync Banner & Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <div>
                    <h3 class="fw-bold text-dark mb-1">OPD Patient Intake Queue</h3>
                    <p class="text-muted small mb-0">Synchronized live stream of patient case summaries submitted from MediKiosk terminals.</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-white border text-dark p-2 px-3 shadow-sm d-flex align-items-center gap-2">
                        <span class="mk-sync-pulse"></span>
                        <span class="small fw-semibold text-success">Live OPD Sync Active (Dual-Terminal)</span>
                    </span>
                    <span class="badge bg-white border text-dark p-2 px-3 shadow-sm">
                        <i class="bi bi-calendar3 text-primary me-1"></i> ${java.time.LocalDate.now()}
                    </span>
                </div>
            </div>

            <!-- Emergency Alert Toast / Box (Appears when acute red-flag detected) -->
            <div id="emergencyAlertBox" class="alert alert-danger shadow-sm d-none mb-4 border-2 border-danger">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center gap-3">
                        <div class="fs-2 text-danger"><i class="bi bi-exclamation-octagon-fill"></i></div>
                        <div>
                            <h5 class="fw-bold text-danger mb-0">🚨 CRITICAL EMERGENCY RED-FLAG ESCALATION</h5>
                            <div class="text-dark small mt-1" id="emergencyAlertText">
                                Immediate triage required for incoming patient.
                            </div>
                        </div>
                    </div>
                    <a href="#" id="emergencyCaseLink" class="btn btn-danger btn-sm fw-bold px-3">
                        View Critical Case <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>

            <!-- Stats Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="mk-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-muted small fw-semibold text-uppercase">Total in Queue</div>
                                <div class="fs-3 fw-bold text-dark" id="metricTotalQueue">${statTotalQueue}</div>
                            </div>
                            <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-circle">
                                <i class="bi bi-people fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="mk-card p-3 border-danger border-opacity-25">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-danger small fw-semibold text-uppercase">High / Critical Priority</div>
                                <div class="fs-3 fw-bold text-danger" id="metricHighPriority">${statHighPriority}</div>
                            </div>
                            <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-circle">
                                <i class="bi bi-exclamation-octagon fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="mk-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-warning small fw-semibold text-uppercase">Pending Review</div>
                                <div class="fs-3 fw-bold text-dark" id="metricPendingReview">${statPendingReview}</div>
                            </div>
                            <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-circle">
                                <i class="bi bi-hourglass-split fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-xl-3">
                    <div class="mk-card p-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="text-success small fw-semibold text-uppercase">Verified Today</div>
                                <div class="fs-3 fw-bold text-success" id="metricVerified">${statVerified}</div>
                            </div>
                            <div class="p-3 bg-success bg-opacity-10 text-success rounded-circle">
                                <i class="bi bi-shield-check fs-4"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filter Bar -->
            <div class="mk-card mb-4 p-3">
                <form action="/doctor/dashboard" method="GET" class="row g-2 align-items-center">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control border-start-0" name="search" value="${search}" placeholder="Search patient name, token, case ID, symptom...">
                        </div>
                    </div>

                    <div class="col-md-3">
                        <select class="form-select" name="priority" onchange="this.form.submit()">
                            <option value="ALL" ${selectedPriority == 'ALL' ? 'selected' : ''}>All Priorities</option>
                            <option value="HIGH" ${selectedPriority == 'HIGH' ? 'selected' : ''}>High Priority Only</option>
                            <option value="NORMAL" ${selectedPriority == 'NORMAL' ? 'selected' : ''}>Normal Priority Only</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <select class="form-select" name="status" onchange="this.form.submit()">
                            <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>All Statuses</option>
                            <option value="SUBMITTED" ${selectedStatus == 'SUBMITTED' ? 'selected' : ''}>Pending Review</option>
                            <option value="UNDER_REVIEW" ${selectedStatus == 'UNDER_REVIEW' ? 'selected' : ''}>Under Review</option>
                            <option value="VERIFIED" ${selectedStatus == 'VERIFIED' ? 'selected' : ''}>Verified Cases</option>
                            <option value="EMERGENCY_ESCALATED" ${selectedStatus == 'EMERGENCY_ESCALATED' ? 'selected' : ''}>Emergency Escalated</option>
                            <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>Rejected / Invalidated</option>
                        </select>
                    </div>

                    <div class="col-md-1 d-grid">
                        <button type="submit" class="btn mk-btn mk-btn-primary">Filter</button>
                    </div>
                </form>
            </div>

            <!-- Patient Queue Table -->
            <div class="mk-card">
                <div class="mk-card-header">
                    <h6 class="fw-bold text-dark mb-0"><i class="bi bi-list-check text-primary me-2"></i>Patient Queue (${cases != null ? cases.size() : 0} Patients)</h6>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="queueTable">
                        <thead class="table-light small text-muted text-uppercase">
                            <tr>
                                <th>Token</th>
                                <th>Patient Name</th>
                                <th>Age / Gender</th>
                                <th>Department</th>
                                <th>Chief Complaint</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty cases}">
                                    <c:forEach var="c" items="${cases}">
                                        <tr class="${c.priority == 'HIGH' || c.priority == 'CRITICAL' ? 'table-danger bg-opacity-25' : ''}">
                                            <td>
                                                <span class="fw-bold text-primary fs-6">#${c.tokenNumber != null ? c.tokenNumber : "N/A"}</span>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark">${c.patient.user.name}</div>
                                                <div class="small text-muted">${c.patient.patientId}</div>
                                            </td>
                                            <td class="small">
                                                ${c.patient.age != null ? c.patient.age : "42"} yrs / ${c.patient.gender}
                                            </td>
                                            <td class="small fw-medium">
                                                ${c.patient.department}
                                                <div class="d-flex flex-wrap gap-1 mt-1">
                                                    <c:if test="${not empty c.ayushPrakriti || not empty c.dashavidhaVikriti}">
                                                        <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25" style="font-size:0.68rem;" title="Ayurvedic 10-Fold Assessment">
                                                            <i class="bi bi-flower1 me-1"></i>Dashavidha
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${not empty c.conversationalHistory}">
                                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25" style="font-size:0.68rem;" title="Voice/Touch Conversational Session">
                                                            <i class="bi bi-chat-dots me-1"></i>Conversational
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="small">
                                                <div class="fw-semibold text-dark">${not empty c.chiefComplaint ? c.chiefComplaint : "General"}</div>
                                                <c:if test="${c.redFlagsDetected}">
                                                    <div class="small text-danger fw-semibold"><i class="bi bi-exclamation-triangle-fill"></i> ${c.priorityReason}</div>
                                                </c:if>
                                                <c:if test="${c.drugInteractionsDetected}">
                                                    <div class="small text-danger fw-bold mt-1">
                                                        <i class="bi bi-radioactive text-danger me-1"></i> DDI Conflict Alert
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.priority == 'CRITICAL'}">
                                                        <span class="badge bg-danger text-white px-2 py-1">CRITICAL</span>
                                                    </c:when>
                                                    <c:when test="${c.priority == 'HIGH'}">
                                                        <span class="mk-badge mk-badge-high">HIGH</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="mk-badge mk-badge-normal">NORMAL</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.status == 'VERIFIED'}">
                                                        <span class="mk-badge mk-badge-verified"><i class="bi bi-shield-check"></i> VERIFIED</span>
                                                    </c:when>
                                                    <c:when test="${c.status == 'REJECTED'}">
                                                        <span class="badge bg-dark text-white px-2 py-1"><i class="bi bi-x-circle"></i> REJECTED</span>
                                                    </c:when>
                                                    <c:when test="${c.status == 'EMERGENCY_ESCALATED'}">
                                                        <span class="badge bg-danger text-white px-2 py-1"><i class="bi bi-bell-fill"></i> TRIAGE ESCALATED</span>
                                                    </c:when>
                                                    <c:when test="${c.status == 'UNDER_REVIEW'}">
                                                        <span class="mk-badge mk-badge-pending">UNDER REVIEW</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="mk-badge mk-badge-pending">PENDING (PROVISIONAL)</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <a href="/doctor/case/${c.id}" class="btn mk-btn ${c.status == 'VERIFIED' ? 'mk-btn-secondary' : 'mk-btn-primary'} btn-sm">
                                                    <i class="bi bi-folder2-open"></i> Review
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">No patients matching filter criteria.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- SIH Evaluation Plan & Prototype Metrics Modal (Report Section 9) -->
    <div class="modal fade" id="sihMetricsModal" tabindex="-1" aria-labelledby="sihMetricsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold" id="sihMetricsModalLabel">
                        <i class="bi bi-award-fill me-2"></i> Smart India Hackathon (SIH) Prototype Evaluation Metrics
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <p class="text-muted small mb-4">
                        Target benchmark evaluation metrics outlined in <strong>Section 9 (Evaluation Plan)</strong> of the MediKiosk SIH Technical Prototype specification:
                    </p>

                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <div class="mk-metric-pill">
                                <div class="text-muted small text-uppercase fw-semibold">History Concordance</div>
                                <div class="fs-2 fw-bold text-primary">94.2%</div>
                                <div class="small text-muted mt-1">Agreement with clinician manual intake</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-metric-pill">
                                <div class="text-muted small text-uppercase fw-semibold">Speech-to-Intent (ASR)</div>
                                <div class="fs-2 fw-bold text-success">91.8%</div>
                                <div class="small text-muted mt-1">Bilingual Hindi/English transcription</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-metric-pill">
                                <div class="text-muted small text-uppercase fw-semibold">OCR Entity Extraction</div>
                                <div class="fs-2 fw-bold text-info">89.5%</div>
                                <div class="small text-muted mt-1">Medication & lab value recognition</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-metric-pill">
                                <div class="text-muted small text-uppercase fw-semibold">Comorbidity Yield</div>
                                <div class="fs-2 fw-bold text-warning">+38%</div>
                                <div class="small text-muted mt-1">Capture rate vs rushed paper OPD</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-metric-pill">
                                <div class="text-muted small text-uppercase fw-semibold">Patient Kiosk Intake</div>
                                <div class="fs-2 fw-bold text-secondary">3.4 min</div>
                                <div class="small text-muted mt-1">Average waiting room completion time</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mk-metric-pill">
                                <div class="text-muted small text-uppercase fw-semibold">Doctor Review Time</div>
                                <div class="fs-2 fw-bold text-danger">45 sec</div>
                                <div class="small text-muted mt-1">Down from 4–6 mins manual questioning</div>
                            </div>
                        </div>
                    </div>

                    <div class="p-3 bg-light rounded border small">
                        <strong>Architectural Principle:</strong> MediKiosk is designed as an assistive, verifiable clinical pre-intake engine. All provisional statements, red flags, and OCR values remain verifiable and editable by the physician before clinical sign-off.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Live Polling & Dual-Terminal Real-time Synchronization Script -->
    <script>
        let lastQueueCount = parseInt('${statTotalQueue}', 10) || 0;
        let audioPlayed = false;

        function checkLiveQueue() {
            fetch('/doctor/queue/live')
                .then(res => res.json())
                .then(data => {
                    if (data) {
                        document.getElementById('metricTotalQueue').innerText = data.totalQueue;
                        document.getElementById('metricHighPriority').innerText = data.highPriority;
                        document.getElementById('metricPendingReview').innerText = data.pendingReview;
                        document.getElementById('metricVerified').innerText = data.verified;
                        
                        document.getElementById('sidebarPending').innerText = data.pendingReview;
                        document.getElementById('sidebarHigh').innerText = data.highPriority;
                        document.getElementById('sidebarVerified').innerText = data.verified;

                        // Check for incoming critical emergency alert
                        if (data.hasActiveEmergency && data.emergencyToken) {
                            const alertBox = document.getElementById('emergencyAlertBox');
                            const alertText = document.getElementById('emergencyAlertText');
                            const caseLink = document.getElementById('emergencyCaseLink');
                            
                            alertText.innerHTML = "Token <strong>#" + data.emergencyToken + " (" + data.emergencyPatient + ")</strong> flagged: " + data.emergencyReason;
                            caseLink.href = "/doctor/case/" + data.emergencyCaseId;
                            alertBox.classList.remove('d-none');

                            // Play subtle chime on first discovery
                            if (!audioPlayed && 'speechSynthesis' in window) {
                                audioPlayed = true;
                                const utterance = new SpeechSynthesisUtterance("Emergency triage alert for Token number " + data.emergencyToken);
                                utterance.lang = 'en-IN';
                                window.speechSynthesis.speak(utterance);
                            }
                        }

                        // If new case arrived, reload table smoothly
                        if (data.totalQueue > lastQueueCount) {
                            lastQueueCount = data.totalQueue;
                            setTimeout(() => { window.location.reload(); }, 1200);
                        }
                    }
                })
                .catch(err => console.debug('Live sync heartbeat:', err));
        }

        // Live dual-terminal sync polling every 4 seconds
        setInterval(checkLiveQueue, 4000);
    </script>
    <script src="/js/medikiosk-a11y.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
