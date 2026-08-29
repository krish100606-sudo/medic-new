<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinical Consent — MediKiosk</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons (No Emojis) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Top Header -->
    <header class="mk-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="mk-brand" href="/patient/dashboard">
                <i class="bi bi-hospital text-primary fs-4"></i>
                <span>MediKiosk</span>
                <span class="mk-brand-badge">Patient Intake</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted small"><i class="bi bi-person-circle me-1"></i> ${patient.user.name}</span>
                <a href="/logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Sign Out
                </a>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <main class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">

                <!-- Consent Card -->
                <div class="mk-card p-4 p-md-5">
                    <div class="d-flex align-items-center gap-3 mb-4 pb-3 border-bottom">
                        <div class="p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-shield-check fs-2"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold text-dark mb-1">Before We Begin</h3>
                            <p class="text-muted small mb-0">Patient Consent & Data Privacy Policy for Pre-Consultation Intake</p>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h6 class="fw-bold text-dark mb-2">Please review the following clinical intake consent terms:</h6>
                        
                        <div class="p-3 bg-light rounded border mb-3">
                            <h6 class="fw-semibold text-dark mb-1"><i class="bi bi-info-circle text-primary me-1"></i> What information is being collected?</h6>
                            <p class="text-muted small mb-0">Your chief symptoms, timeline of illness, previous medical history, surgical records, ongoing medications, allergies, and uploaded medical documents (prescriptions, pathology reports).</p>
                        </div>

                        <div class="p-3 bg-light rounded border mb-3">
                            <h6 class="fw-semibold text-dark mb-1"><i class="bi bi-question-circle text-primary me-1"></i> Why is this required?</h6>
                            <p class="text-muted small mb-0">To streamline your hospital visit, eliminate redundant paperwork, and prepare a structured, chronological summary for your doctor before you enter the consultation room.</p>
                        </div>

                        <div class="p-3 bg-light rounded border mb-3">
                            <h6 class="fw-semibold text-dark mb-1"><i class="bi bi-lock text-primary me-1"></i> How will it be used & secured?</h6>
                            <p class="text-muted small mb-0">All data is encrypted, stored under hospital healthcare standards, and only accessible to authorized medical professionals involved in your direct care.</p>
                        </div>

                        <div class="p-3 bg-primary bg-opacity-10 rounded border border-primary border-opacity-25 mb-3">
                            <h6 class="fw-semibold text-primary mb-1"><i class="bi bi-stethoscope me-1"></i> Important Medical Notice</h6>
                            <p class="text-dark small mb-0">MediKiosk is NOT an AI doctor and does not make autonomous clinical diagnoses. Your consulting doctor will personally review, verify, and make all medical decisions regarding your care.</p>
                        </div>
                    </div>

                    <form action="/patient/consent" method="POST">
                        <div class="form-check p-3 bg-white rounded border mb-4">
                            <input class="form-check-input ms-0 me-2" type="checkbox" name="consent" id="consentCheck" value="true" required>
                            <label class="form-check-label fw-semibold text-dark small" for="consentCheck">
                                I have read and agree to the clinical intake collection terms, and give consent to digitize my medical history for my doctor's review.
                            </label>
                        </div>

                        <div class="d-flex justify-content-between align-items-center">
                            <a href="/patient/dashboard" class="btn mk-btn mk-btn-secondary">
                                <i class="bi bi-x-circle"></i> Cancel
                            </a>
                            <button type="submit" class="btn mk-btn mk-btn-primary mk-btn-lg">
                                <i class="bi bi-check2-circle"></i> I Agree & Continue
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
