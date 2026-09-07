<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediKiosk — AI-Assisted Patient Intake & Clinical Summary Platform</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons (No Emojis Policy) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Custom MediKiosk Design System -->
    <link href="/css/medikiosk.css" rel="stylesheet">
</head>
<body>

    <!-- Ministry of Ayush Official Government Header -->
    <%@ include file="ayush-header.jsp" %>

    <!-- Accessible Skip Link -->
    <a href="#mainContent" class="mk-skip-link">Skip to Main Content</a>

    <!-- Top Navigation -->
    <nav class="navbar navbar-expand-lg mk-navbar sticky-top">
        <div class="container">
            <a class="mk-brand" href="/">
                <i class="bi bi-hospital text-success fs-4"></i>
                <span>MediKiosk</span>
                <span class="mk-brand-badge bg-success bg-opacity-10 text-success">Ayush Grid Intake</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navContent">
                <ul class="navbar-nav align-items-center gap-3">
                    <li class="nav-item">
                        <a class="nav-link text-dark fw-medium" href="#ayush-systems">AYUSH Systems</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-dark fw-medium" href="#how-it-works">How It Works</a>
                    </li>
                    <li class="nav-item">
                        <!-- Accessibility Controls Toolbar -->
                        <div class="mk-a11y-toolbar" role="region" aria-label="Accessibility settings">
                            <button type="button" class="mk-a11y-btn" id="a11yContrastBtn" onclick="toggleContrast()" title="High Contrast Mode (Alt+C)" aria-label="Toggle high contrast">
                                <i class="bi bi-circle-half"></i>
                            </button>
                            <button type="button" class="mk-a11y-btn" id="a11yFontNormal" onclick="changeFontSize('reset')" title="Standard Text Size" aria-label="Standard text size">A</button>
                            <button type="button" class="mk-a11y-btn" id="a11yFontLg" onclick="changeFontSize('increase')" title="Large Text Size" aria-label="Large text size">A+</button>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="btn mk-btn mk-btn-secondary" href="/doctor/login">
                            <i class="bi bi-person-badge"></i> Doctor Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="btn mk-btn mk-btn-primary" href="/login">
                            <i class="bi bi-person-fill"></i> Patient Portal / Kiosk
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="py-5 bg-white border-bottom" id="mainContent">
        <div class="container py-4">
            <div class="row align-items-center g-5">
                <div class="col-lg-7">
                    <div class="d-inline-flex align-items-center gap-2 px-3 py-1 mb-3 rounded-pill bg-success bg-opacity-10 border border-success border-opacity-25 text-success small fw-semibold">
                        <i class="bi bi-shield-check"></i>
                        <span>Ministry of Ayush &bull; Smart India Hackathon Prototype (PS 26047)</span>
                    </div>
                    <h1 class="display-5 fw-bold text-dark mb-3 lh-sm">
                        AI Clinical Intake & Triage for Ayush & Modern OPDs
                    </h1>
                    <p class="lead text-muted mb-4 fs-5">
                        Answer guided clinical questions in English or Hindi across traditional AYUSH and modern clinical frameworks, digitize prescriptions with OCR, and provide your doctor with a structured case summary before consultation.
                    </p>

                    <div class="d-flex flex-wrap gap-3 mb-4">
                        <a href="/login" class="btn mk-btn mk-btn-primary mk-btn-lg">
                            <i class="bi bi-arrow-right-circle"></i> Start Patient Intake
                        </a>
                        <a href="/doctor/login" class="btn mk-btn mk-btn-secondary mk-btn-lg">
                            <i class="bi bi-stethoscope"></i> Doctor Workstation
                        </a>
                    </div>

                    <div class="d-flex flex-wrap gap-4 pt-3 border-top text-muted small">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-mic text-primary"></i> Voice & Multilingual Input
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-file-earmark-medical text-primary"></i> Prescription OCR Digitization
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-exclamation-triangle text-danger"></i> Deterministic Red-Flag Triage
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="mk-card border p-4 shadow-sm bg-light">
                        <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-clipboard2-pulse-fill text-primary fs-5"></i>
                                <span class="fw-bold">Clinical Case Summary Preview</span>
                            </div>
                            <span class="mk-badge mk-badge-high">High Priority</span>
                        </div>
                        
                        <div class="bg-white p-3 rounded border mb-3">
                            <div class="small text-muted mb-1">Chief Complaint</div>
                            <div class="fw-semibold text-dark">Chest pain radiating to left arm (Duration: 2 hours)</div>
                        </div>

                        <div class="bg-white p-3 rounded border mb-3">
                            <div class="small text-muted mb-1">OCR Digitized Medical Record</div>
                            <div class="d-flex justify-content-between small">
                                <span>Type 2 Diabetes (HbA1c: 7.8%)</span>
                                <span class="text-success fw-medium"><i class="bi bi-check-circle"></i> Extracted</span>
                            </div>
                        </div>

                        <div class="p-2 bg-light rounded text-center small text-muted">
                            <i class="bi bi-info-circle me-1"></i> Physician-verified clinical decision support tool.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <!-- Supported AYUSH Traditional Healthcare Systems Section -->
    <section id="ayush-systems" class="py-5 bg-white border-bottom">
        <div class="container py-3">
            <div class="text-center max-w-700 mx-auto mb-5">
                <span class="badge bg-success bg-opacity-10 text-success fw-bold px-3 py-2 mb-2 text-uppercase">
                    <i class="bi bi-flower1 me-1"></i> Ministry of Ayush Streams
                </span>
                <h2 class="fw-bold text-dark mb-2">Integrated AYUSH & Modern Medicine Intake</h2>
                <p class="text-muted small">
                    MediKiosk structures pre-consultation patient intake for traditional Indian systems of medicine aligned with National Ayush Morbidity Codes (NAMASTE portal) and WHO ICD-11 Traditional Medicine Module (TM2).
                </p>
            </div>

            <div class="row g-4">
                <!-- 1. Ayurveda -->
                <div class="col-md-6 col-lg-4">
                    <div class="ayush-stream-card">
                        <div class="ayush-stream-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-flower3"></i>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h5 class="fw-bold text-dark mb-0">Ayurveda (आयुर्वेद)</h5>
                            <span class="ayush-stream-pill ayush-stream-ayurveda">Dosha & Prakriti</span>
                        </div>
                        <p class="text-muted small mb-3">
                            Captures Tridosha constitution (Vata, Pitta, Kapha), Agni (digestive power), Koshtha (bowel habits), and Nidra quality before consultation.
                        </p>
                        <div class="mt-auto pt-2 border-top small text-success fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Rogi-Roga Pariksha Structured
                        </div>
                    </div>
                </div>

                <!-- 2. Yoga & Naturopathy -->
                <div class="col-md-6 col-lg-4">
                    <div class="ayush-stream-card">
                        <div class="ayush-stream-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-person-arms-up"></i>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h5 class="fw-bold text-dark mb-0">Yoga & Naturopathy (योग)</h5>
                            <span class="ayush-stream-pill ayush-stream-yoga">Mind-Body Wellness</span>
                        </div>
                        <p class="text-muted small mb-3">
                            Structures Swasthavritta lifestyle habits, Dinacharya compliance, mental stress metrics, and Pranayama practices for holistic OPD care.
                        </p>
                        <div class="mt-auto pt-2 border-top small text-primary fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Lifestyle & Ahara-Vihara Intake
                        </div>
                    </div>
                </div>

                <!-- 3. Unani -->
                <div class="col-md-6 col-lg-4">
                    <div class="ayush-stream-card">
                        <div class="ayush-stream-icon bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-droplet-half"></i>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h5 class="fw-bold text-dark mb-0">Unani (यूनानी)</h5>
                            <span class="ayush-stream-pill ayush-stream-unani">Mizaj & Akhlat</span>
                        </div>
                        <p class="text-muted small mb-3">
                            Documents Mizaj (Temperament: Hot/Cold/Dry/Moist), Akhlat (Four Humors balance), and Asbab-e-Sittah Zarooriyyah (6 essential factors).
                        </p>
                        <div class="mt-auto pt-2 border-top small text-danger fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Temperament & Humor Profiling
                        </div>
                    </div>
                </div>

                <!-- 4. Siddha -->
                <div class="col-md-6 col-lg-4">
                    <div class="ayush-stream-card">
                        <div class="ayush-stream-icon bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-sun-fill"></i>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h5 class="fw-bold text-dark mb-0">Siddha (सिद्ध)</h5>
                            <span class="ayush-stream-pill ayush-stream-siddha">Mukkuttram</span>
                        </div>
                        <p class="text-muted small mb-3">
                            Intake for Vali, Azhal, and Iyyam bio-energies, complemented by En-Vagai Thervu (eight-fold diagnostic procedure) preparation.
                        </p>
                        <div class="mt-auto pt-2 border-top small text-warning fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Traditional Bio-energy Triage
                        </div>
                    </div>
                </div>

                <!-- 5. Homoeopathy -->
                <div class="col-md-6 col-lg-4">
                    <div class="ayush-stream-card">
                        <div class="ayush-stream-icon" style="background: #f5f3ff; color: #7c3aed;">
                            <i class="bi bi-capsule"></i>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h5 class="fw-bold text-dark mb-0">Homoeopathy (होम्योपैथी)</h5>
                            <span class="ayush-stream-pill ayush-stream-homoeo">Totality of Symptoms</span>
                        </div>
                        <p class="text-muted small mb-3">
                            Structures constitutional symptom totality, modalities (worse/better factors), thermal reactions (chilly/hot), and mental state expressions.
                        </p>
                        <div class="mt-auto pt-2 border-top small fw-semibold" style="color: #7c3aed;">
                            <i class="bi bi-check2-circle me-1"></i> Constitutional Repertory Data
                        </div>
                    </div>
                </div>

                <!-- 6. Sowa-Rigpa & Integrative Medicine -->
                <div class="col-md-6 col-lg-4">
                    <div class="ayush-stream-card">
                        <div class="ayush-stream-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-tree-fill"></i>
                        </div>
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <h5 class="fw-bold text-dark mb-0">Sowa-Rigpa & Allopathy</h5>
                            <span class="ayush-stream-pill ayush-stream-sowarigpa">Integrative Care</span>
                        </div>
                        <p class="text-muted small mb-3">
                            Supports Himalayan traditional medicine alongside modern Allopathic OPD intake with unified HL7 FHIR R4 and ABDM record bundling.
                        </p>
                        <div class="mt-auto pt-2 border-top small text-info fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> Ayush Grid & ABDM Interoperable
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How MediKiosk Works Section -->
    <section id="how-it-works" class="py-5 bg-light">
        <div class="container py-3">
            <div class="text-center max-w-700 mx-auto mb-5">
                <h2 class="fw-bold text-dark mb-2">How MediKiosk Works</h2>
                <p class="text-muted">A step-by-step pre-consultation workflow designed for hospital kiosks and mobile intake.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-4 col-lg">
                    <div class="mk-card h-100 p-4 text-center">
                        <div class="mb-3 d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-person-check fs-4"></i>
                        </div>
                        <h5 class="fw-bold mb-2">1. Identify</h5>
                        <p class="text-muted small mb-0">Sign in with Patient ID or Phone number, confirm consent, and select your preferred language.</p>
                    </div>
                </div>

                <div class="col-md-4 col-lg">
                    <div class="mk-card h-100 p-4 text-center">
                        <div class="mb-3 d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-chat-left-dots fs-4"></i>
                        </div>
                        <h5 class="fw-bold mb-2">2. Answer</h5>
                        <p class="text-muted small mb-0">Answer structured clinical questions via voice, touch, or text input with ease.</p>
                    </div>
                </div>

                <div class="col-md-4 col-lg">
                    <div class="mk-card h-100 p-4 text-center">
                        <div class="mb-3 d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-cloud-arrow-up fs-4"></i>
                        </div>
                        <h5 class="fw-bold mb-2">3. Upload</h5>
                        <p class="text-muted small mb-0">Upload previous prescriptions and lab reports for automatic OCR medical entity extraction.</p>
                    </div>
                </div>

                <div class="col-md-4 col-lg">
                    <div class="mk-card h-100 p-4 text-center">
                        <div class="mb-3 d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-diagram-3 fs-4"></i>
                        </div>
                        <h5 class="fw-bold mb-2">4. Structure</h5>
                        <p class="text-muted small mb-0">The system creates a clinical timeline and detects predefined safety red flags.</p>
                    </div>
                </div>

                <div class="col-md-4 col-lg">
                    <div class="mk-card h-100 p-4 text-center">
                        <div class="mb-3 d-inline-flex p-3 rounded-circle bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-clipboard2-check fs-4"></i>
                        </div>
                        <h5 class="fw-bold mb-2">5. Review</h5>
                        <p class="text-muted small mb-0">Patient reviews and submits for instant doctor verification in the OPD queue.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Clinical Value Proposition Banner -->
    <section id="about" class="py-5 bg-white border-top border-bottom">
        <div class="container text-center py-3">
            <h4 class="fw-bold text-dark mb-3">
                "Collect the patient's story before the consultation, structure the information automatically, and let the doctor focus on the clinical decision."
            </h4>
            <p class="text-muted mb-4 max-w-700 mx-auto small">
                MediKiosk strictly functions as a pre-consultation intake and document digitizing platform. The consulting physician retains 100% responsibility for clinical diagnosis and final treatment decisions.
            </p>
            <div class="d-flex justify-content-center gap-3">
                <a href="/login" class="btn mk-btn mk-btn-primary">
                    <i class="bi bi-box-arrow-in-right"></i> Open Patient Kiosk
                </a>
                <a href="/doctor/login" class="btn mk-btn mk-btn-secondary">
                    <i class="bi bi-shield-lock"></i> Doctor Portal
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-4 bg-light border-top text-center text-muted small">
        <div class="container">
            <div class="d-flex flex-wrap justify-content-center gap-3 mb-2 small">
                <a href="https://www.ayush.gov.in/" target="_blank" rel="noopener noreferrer" class="text-decoration-none text-muted">Ministry of Ayush (Official Portal)</a>
                &bull;
                <a href="https://ayushgrid.gov.in/" target="_blank" rel="noopener noreferrer" class="text-decoration-none text-muted">Ayush Grid Digital Healthcare</a>
                &bull;
                <a href="https://namstp.ayush.gov.in/" target="_blank" rel="noopener noreferrer" class="text-decoration-none text-muted">NAMASTE Morbidity Terminologies</a>
                &bull;
                <a href="https://abdm.gov.in/" target="_blank" rel="noopener noreferrer" class="text-decoration-none text-muted">ABDM Interoperability</a>
            </div>
            <p class="mb-1 fw-medium">MediKiosk &bull; Ministry of Ayush Pre-Consultation Clinical Intake Platform</p>
            <p class="mb-0 text-secondary">Smart India Hackathon 2026 Prototype &bull; Aligned with National Ayush Mission (NAM) & Ayush Grid</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="/js/medikiosk-a11y.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
