package com.example.Health_Data_Management.controller;

import com.example.Health_Data_Management.entity.*;
import com.example.Health_Data_Management.repository.MedicalCaseRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import com.example.Health_Data_Management.repository.UserRepository;
import com.example.Health_Data_Management.service.CaseService;
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
import java.util.List;

@Controller
@RequestMapping("/patient")
public class PatientFlowController {

    private final PatientRepository patientRepository;
    private final UserRepository userRepository;
    private final CaseService caseService;
    private final MedicalCaseRepository caseRepository;
    private final RedFlagService redFlagService;

    private final String uploadDir = "uploads";

    public PatientFlowController(
            PatientRepository patientRepository,
            UserRepository userRepository,
            CaseService caseService,
            MedicalCaseRepository caseRepository,
            RedFlagService redFlagService) {
        this.patientRepository = patientRepository;
        this.userRepository = userRepository;
        this.caseService = caseService;
        this.caseRepository = caseRepository;
        this.redFlagService = redFlagService;

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
            Model model) {
        Patient patient = getCurrentPatient(authentication);
        if (patient == null) return "redirect:/login";

        MedicalCase medicalCase = caseService.getOrCreateDraftCase(patient);

        if (step < 1) step = 1;
        if (step > 10) step = 10;

        model.addAttribute("patient", patient);
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("currentStep", step);
        model.addAttribute("totalSteps", 10);
        model.addAttribute("lang", patient.getPreferredLanguage() != null ? patient.getPreferredLanguage() : "English");

        return "patient/case-taking";
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
