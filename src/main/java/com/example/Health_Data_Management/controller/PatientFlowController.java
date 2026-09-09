package com.example.Health_Data_Management.controller;

import com.example.Health_Data_Management.entity.*;
import com.example.Health_Data_Management.repository.MedicalCaseRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import com.example.Health_Data_Management.repository.UserRepository;
import com.example.Health_Data_Management.service.CaseService;
import com.example.Health_Data_Management.service.DashavidhaService;
import com.example.Health_Data_Management.service.RedFlagService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/patient")
public class PatientFlowController {

    private final PatientRepository patientRepository;
    private final UserRepository userRepository;
    private final CaseService caseService;
    private final MedicalCaseRepository caseRepository;
    private final RedFlagService redFlagService;
    private final DashavidhaService dashavidhaService;

    private final String uploadDir = "uploads";

    public PatientFlowController(
            PatientRepository patientRepository,
            UserRepository userRepository,
            CaseService caseService,
            MedicalCaseRepository caseRepository,
            RedFlagService redFlagService,
            DashavidhaService dashavidhaService) {
        this.patientRepository = patientRepository;
        this.userRepository = userRepository;
        this.caseService = caseService;
        this.caseRepository = caseRepository;
        this.redFlagService = redFlagService;
        this.dashavidhaService = dashavidhaService;

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    private Patient getCurrentPatient(Authentication authentication) {
        if (authentication == null) return null;
        String email = authentication.getName();
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) return null;
        return patientRepository.findByUserId(user.getId()).orElse(null);
    }

    // ---------------------------------------------------------
    // PATIENT DASHBOARD
    // ---------------------------------------------------------
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) {
            return "redirect:/login";
        }

        List<MedicalCase> cases = caseService.getCasesForPatient(patient.getId());
        MedicalCase currentCase = cases.stream()
                .filter(c -> c.getStatus() == CaseStatus.DRAFT || c.getStatus() == CaseStatus.SUBMITTED || c.getStatus() == CaseStatus.UNDER_REVIEW)
                .findFirst()
                .orElse(null);

        model.addAttribute("patient", patient);
        model.addAttribute("currentCase", currentCase);
        model.addAttribute("cases", cases);
        return "patient/dashboard";
    }

    // ---------------------------------------------------------
    // START NEW CASE / CONSENT SCREEN
    // ---------------------------------------------------------
    @GetMapping("/consent")
    public String consentScreen(Authentication authentication, Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        model.addAttribute("patient", patient);
        return "patient/consent";
    }

    @PostMapping("/consent")
    public String acceptConsent(
            Authentication authentication,
            @RequestParam(value = "consent", defaultValue = "false") boolean consent) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        if (!consent) {
            return "redirect:/patient/consent?error=required";
        }

        patient.setConsentAccepted(true);
        patient.setConsentAcceptedAt(LocalDateTime.now());
        patientRepository.save(patient);

        return "redirect:/patient/language";
    }

    // ---------------------------------------------------------
    // LANGUAGE SELECTION
    // ---------------------------------------------------------
    @GetMapping("/language")
    public String languageScreen(Authentication authentication, Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        model.addAttribute("patient", patient);
        return "patient/language";
    }

    @PostMapping("/language")
    public String saveLanguage(
            Authentication authentication,
            @RequestParam("language") String language) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        patient.setPreferredLanguage(language);
        patientRepository.save(patient);

        // Ensure draft case exists
        caseService.getOrCreateDraftCase(patient);

        return "redirect:/patient/case-taking?step=1";
    }

    // ---------------------------------------------------------
    // CLINICAL CASE-TAKING (STEP-BY-STEP GUIDED INTERFACE)
    // ---------------------------------------------------------
    @GetMapping("/case-taking")
    public String caseTaking(
            Authentication authentication,
            @RequestParam(value = "step", defaultValue = "1") int step,
            @RequestParam(value = "mode", defaultValue = "conversational") String mode,
            Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);

        if (step < 1) step = 1;
        if (step > 10) step = 10;

        DashavidhaService.DashavidhaMatrix dashavidhaMatrix = dashavidhaService.buildMatrix(medicalCase);

        model.addAttribute("patient", patient);
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("currentStep", step);
        model.addAttribute("totalSteps", 10);
        model.addAttribute("mode", mode);
        model.addAttribute("dashavidhaMatrix", dashavidhaMatrix);
        model.addAttribute("lang", patient.getPreferredLanguage() != null ? patient.getPreferredLanguage() : "English");

        return "patient/case-taking";
    }

    @PostMapping("/conversational-intake")
    @ResponseBody
    public Map<String, Object> conversationalIntake(
            Authentication authentication,
            @RequestParam("message") String message,
            @RequestParam(value = "entityCode", required = false) String entityCode,
            @RequestParam(value = "entityValue", required = false) String entityValue,
            @RequestParam(value = "lang", defaultValue = "English") String lang) {

        Map<String, Object> response = new HashMap<>();
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) {
            response.put("error", "Unauthorized");
            return response;
        }

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);
        String text = message != null ? message.trim() : "";
        String textLower = text.toLowerCase();
        boolean isHindi = "Hindi".equalsIgnoreCase(lang) || textLower.contains("hai") || textLower.contains("dard") || textLower.contains("mujhe");

        String reply;
        String determinedCode = entityCode;
        String determinedVal = (entityValue != null && !entityValue.isBlank()) ? entityValue : text;

        // Adaptive clinical conversation engine
        if (determinedCode == null || determinedCode.isBlank()) {
            if (textLower.contains("chest") || textLower.contains("chhati") || textLower.contains("angina") || textLower.contains("dil")) {
                determinedCode = "Q_CHIEF_COMPLAINT";
                determinedVal = "Chest Discomfort / Pain";
                reply = isHindi
                        ? "छाती में दर्द दर्ज कर लिया गया है। कृपया बताएं कि यह दर्द कब शुरू हुआ (जैसे 2 घंटे पहले, आज, या कुछ दिनों से), और 1 से 10 के पैमाने पर कितना तेज है?"
                        : "Chief complaint noted as Chest Discomfort. When did this pain start (e.g. 2 hours ago, today, or several days), and how intense is it on a scale of 1 to 10?";
            } else if (textLower.contains("fever") || textLower.contains("bukhar") || textLower.contains("tap")) {
                determinedCode = "Q_CHIEF_COMPLAINT";
                determinedVal = "Acute Febrile Illness / Fever";
                reply = isHindi
                        ? "बुखार दर्ज कर लिया गया है। क्या बुखार के साथ ठंड लग रही है, खांसी या बदन दर्द है, और यह कब से शुरू हुआ?"
                        : "Fever complaint noted. Are you also experiencing chills, cough, or body ache, and how long has it persisted?";
            } else if (textLower.contains("stomach") || textLower.contains("pet") || textLower.contains("abdomen") || textLower.contains("acidity")) {
                determinedCode = "Q_CHIEF_COMPLAINT";
                determinedVal = "Abdominal Discomfort / Pain";
                reply = isHindi
                        ? "पेट दर्द दर्ज कर लिया गया है। क्या यह दर्द खाने के बाद बढ़ता है, और क्या आपको उल्टी या कब्ज की शिकायत है?"
                        : "Abdominal discomfort noted. Is the pain related to meals, and have you had any nausea, vomiting, or altered bowel habits?";
            } else if (textLower.contains("cough") || textLower.contains("khansi") || textLower.contains("breath") || textLower.contains("saans")) {
                determinedCode = "Q_ASSOCIATED_SYMPTOMS";
                determinedVal = text;
                reply = isHindi
                        ? "सांस या खांसी के लक्षण नोट कर लिए गए हैं। क्या आपको पहले से अस्थमा या एलर्जी है, और रोजाना कौन सी दवाइयां ले रहे हैं?"
                        : "Respiratory symptom noted. Do you have any pre-existing respiratory illness, and what medications are you currently taking?";
            } else if (textLower.contains("hour") || textLower.contains("ghante") || textLower.contains("today") || textLower.contains("aaj") || textLower.contains("day") || textLower.contains("din")) {
                determinedCode = "Q_ONSET";
                reply = isHindi
                        ? "समय अवधि दर्ज हो गई है। क्या यह दर्द किसी अन्य हिस्से (जैसे बाएं हाथ, कंधे, जबड़े) में फैल रहा है?"
                        : "Onset duration recorded. Does the discomfort radiate anywhere, such as your left arm, shoulder, or jaw?";
            } else if (textLower.contains("arm") || textLower.contains("haath") || textLower.contains("jaw") || textLower.contains("left") || textLower.contains("radiat")) {
                determinedCode = "Q_SOCRATES_RADIATION";
                reply = isHindi
                        ? "रेडिएशन लक्षण नोट किया गया। क्या आपको पूर्व में डायबिटीज, उच्च रक्तचाप, या कोई सर्जरी हुई है?"
                        : "Radiation symptom noted. Do you have a history of diabetes, hypertension, or previous surgeries?";
            } else if (textLower.contains("sugar") || textLower.contains("diabetes") || textLower.contains("bp") || textLower.contains("hypertension") || textLower.contains("none") || textLower.contains("nhi")) {
                determinedCode = "Q_PAST_DISEASES";
                reply = isHindi
                        ? "पिछला चिकित्सीय इतिहास दर्ज हुआ। आप अभी कौन सी दवाइयां (Allopathic या Ayurvedic) ले रहे हैं?"
                        : "Past medical history noted. What current medications or herbal remedies are you taking?";
            } else if (textLower.contains("tab") || textLower.contains("metformin") || textLower.contains("dawa") || textLower.contains("medicine")) {
                determinedCode = "Q_MEDICATIONS";
                reply = isHindi
                        ? "दवाइयों का विवरण दर्ज हुआ। क्या आपको किसी दवा या खाद्य पदार्थ से कोई एलर्जी है?"
                        : "Medication details recorded. Do you have any known drug or food allergies?";
            } else {
                determinedCode = "Q_STATEMENT";
                reply = isHindi
                        ? "आपकी जानकारी सुरक्षित कर ली गई है। क्या आप पिछले पर्चे या टेस्ट रिपोर्ट अपलोड करना चाहते हैं या सीधे समीक्षा पर जाएं?"
                        : "Information recorded in your intake file. Would you like to upload previous medical records, or proceed to final review?";
            }
        } else {
            reply = isHindi ? "जानकारी सफलतापूर्वक दर्ज कर ली गई है।" : "Information successfully recorded.";
        }

        // Record exchange & update entity
        medicalCase = caseService.recordConversationalExchange(medicalCase.getId(), text, reply, determinedCode, determinedVal);

        // Check red-flag intercept
        RedFlagService.RedFlagEvaluation eval = redFlagService.evaluate(medicalCase);
        boolean intercept = eval.isInterruptIntake() && eval.isRedFlagsDetected();

        response.put("success", true);
        response.put("reply", reply);
        response.put("extractedCode", determinedCode);
        response.put("extractedVal", determinedVal);
        response.put("priority", medicalCase.getPriority().name());
        response.put("redFlags", medicalCase.isRedFlagsDetected());
        response.put("interceptRequired", intercept);
        response.put("interceptUrl", "/patient/emergency-intercept?step=1");
        response.put("chiefComplaint", medicalCase.getChiefComplaint());
        response.put("onset", medicalCase.getOnset());
        response.put("severity", medicalCase.getSeverity());
        response.put("medications", medicalCase.getCurrentMedication());

        return response;
    }

    @PostMapping("/case-taking/save-step")
    public String saveStep(
            Authentication authentication,
            @RequestParam("step") int step,
            @RequestParam(value = "questionCode", required = false) String questionCode,
            @RequestParam(value = "questionText", required = false) String questionText,
            @RequestParam(value = "answerText", required = false) String answerText,
            @RequestParam(value = "inputType", defaultValue = "TEXT") String inputTypeStr,
            @RequestParam(value = "action", defaultValue = "next") String action) {

        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);

        InputType inputType = InputType.TEXT;
        try {
            inputType = InputType.valueOf(inputTypeStr.toUpperCase());
        } catch (Exception ignored) {}

        if (questionCode != null && answerText != null && !answerText.trim().isEmpty()) {
            caseService.saveOrUpdateAnswer(medicalCase.getId(), questionCode, questionText, answerText.trim(), inputType);
            medicalCase = caseService.getCaseById(medicalCase.getId());

            // Deterministic Emergency Red-Flag Interceptor Check (SIH Requirement)
            RedFlagService.RedFlagEvaluation evaluation = redFlagService.evaluate(medicalCase);
            if (evaluation.isInterruptIntake() && !"back".equalsIgnoreCase(action) && !"exit".equalsIgnoreCase(action)) {
                medicalCase.setPriority(evaluation.getPriority());
                medicalCase.setRedFlagsDetected(true);
                medicalCase.setPriorityReason(evaluation.getReason());
                medicalCase.setEmergencyInterceptTriggered(true);
                caseRepository.save(medicalCase);
                return "redirect:/patient/emergency-intercept?step=" + step;
            }
        }

        if ("exit".equalsIgnoreCase(action)) {
            return "redirect:/patient/dashboard";
        }

        if ("back".equalsIgnoreCase(action)) {
            int prevStep = Math.max(1, step - 1);
            return "redirect:/patient/case-taking?step=" + prevStep;
        }

        int nextStep = step + 1;
        if (nextStep > 10) {
            return "redirect:/patient/document-upload";
        }

        return "redirect:/patient/case-taking?step=" + nextStep;
    }

    // ---------------------------------------------------------
    // EMERGENCY TRIAGE INTERCEPTION (SIH REQUIREMENT)
    // ---------------------------------------------------------
    @GetMapping("/emergency-intercept")
    public String emergencyIntercept(
            Authentication authentication,
            @RequestParam(value = "step", defaultValue = "1") int step,
            Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);
        model.addAttribute("patient", patient);
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("step", step);
        model.addAttribute("lang", patient.getPreferredLanguage() != null ? patient.getPreferredLanguage() : "English");
        return "patient/emergency-intercept";
    }

    @PostMapping("/emergency-escalate")
    public String escalateEmergency(
            Authentication authentication,
            @RequestParam(value = "reason", required = false) String reason) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);
        String finalReason = (reason != null && !reason.isBlank()) ? reason : medicalCase.getPriorityReason();
        MedicalCase escalated = caseService.escalateEmergencyCase(medicalCase.getId(), finalReason);

        return "redirect:/patient/case-complete?id=" + escalated.getId() + "&emergency=true";
    }

    @PostMapping("/emergency-continue")
    public String continueRoutineIntake(
            Authentication authentication,
            @RequestParam(value = "step", defaultValue = "1") int step) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);
        medicalCase.setEmergencyInterceptTriggered(false);
        caseRepository.save(medicalCase);

        int nextStep = Math.min(10, step + 1);
        return "redirect:/patient/case-taking?step=" + nextStep + "&assisted=true";
    }

    // ---------------------------------------------------------
    // DOCUMENT UPLOAD & OCR
    // ---------------------------------------------------------
    @GetMapping("/document-upload")
    public String documentUploadScreen(Authentication authentication, Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);

        model.addAttribute("patient", patient);
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("documents", medicalCase.getDocuments());
        return "patient/document-upload";
    }

    @PostMapping("/document-upload")
    public String uploadDocument(
            Authentication authentication,
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "documentType", defaultValue = "PRESCRIPTION") String docTypeStr) {

        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);

        DocumentType docType = DocumentType.PRESCRIPTION;
        try {
            docType = DocumentType.valueOf(docTypeStr.toUpperCase());
        } catch (Exception ignored) {}

        if (!file.isEmpty()) {
            String originalFileName = file.getOriginalFilename();
            String storedFileName = System.currentTimeMillis() + "_" + (originalFileName != null ? originalFileName.replaceAll("\\s+", "_") : "doc.jpg");
            try {
                Path targetPath = Paths.get(uploadDir, storedFileName);
                Files.write(targetPath, file.getBytes());
            } catch (IOException e) {
                // In demo, fallback gracefully
            }
            caseService.addAndProcessDocument(medicalCase.getId(), patient.getId(), storedFileName, originalFileName, file.getContentType(), docType);
        }

        return "redirect:/patient/document-upload";
    }

    @PostMapping("/document-upload/sample")
    public String attachSampleDocument(
            Authentication authentication,
            @RequestParam("sampleType") String sampleType) {

        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);

        if ("prescription".equalsIgnoreCase(sampleType)) {
            caseService.addAndProcessDocument(medicalCase.getId(), patient.getId(), "previous-prescription.jpg", "previous-prescription.jpg", "image/jpeg", DocumentType.PRESCRIPTION);
        } else if ("blood".equalsIgnoreCase(sampleType)) {
            caseService.addAndProcessDocument(medicalCase.getId(), patient.getId(), "blood-report.jpg", "blood-report.jpg", "image/jpeg", DocumentType.BLOOD_REPORT);
        }

        return "redirect:/patient/document-upload";
    }

    // ---------------------------------------------------------
    // FINAL CLINICAL REVIEW
    // ---------------------------------------------------------
    @GetMapping("/review")
    public String reviewScreen(Authentication authentication, Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);
        medicalCase = caseService.generateSummaryAndEvaluateRedFlags(medicalCase.getId());

        model.addAttribute("patient", patient);
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("documents", medicalCase.getDocuments());
        return "patient/review";
    }

    // ---------------------------------------------------------
    // SUBMIT CASE
    // ---------------------------------------------------------
    @PostMapping("/submit-case")
    public String submitCase(Authentication authentication) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);
        MedicalCase submitted = caseService.submitCase(medicalCase.getId());

        return "redirect:/patient/case-complete?id=" + submitted.getId();
    }

    // ---------------------------------------------------------
    // CASE COMPLETE CONFIRMATION
    // ---------------------------------------------------------
    @GetMapping("/case-complete")
    public String caseComplete(
            @RequestParam("id") Long caseId,
            Authentication authentication,
            Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getCaseById(caseId);
        if (medicalCase == null) return "redirect:/patient/dashboard";

        model.addAttribute("patient", patient);
        model.addAttribute("medicalCase", medicalCase);
        return "patient/case-complete";
    }
}
