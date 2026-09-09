package com.example.Health_Data_Management.controller;

import com.example.Health_Data_Management.entity.*;
import com.example.Health_Data_Management.repository.DoctorRepository;
import com.example.Health_Data_Management.repository.UserRepository;
import com.example.Health_Data_Management.service.CaseService;
import com.example.Health_Data_Management.service.DashavidhaService;
import com.example.Health_Data_Management.service.DrugInteractionService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/doctor")
public class DoctorPortalController {

    private final CaseService caseService;
    private final DoctorRepository doctorRepository;
    private final UserRepository userRepository;
    private final DashavidhaService dashavidhaService;
    private final DrugInteractionService drugInteractionService;

    public DoctorPortalController(
            CaseService caseService,
            DoctorRepository doctorRepository,
            UserRepository userRepository,
            DashavidhaService dashavidhaService,
            DrugInteractionService drugInteractionService) {
        this.caseService = caseService;
        this.doctorRepository = doctorRepository;
        this.userRepository = userRepository;
        this.dashavidhaService = dashavidhaService;
        this.drugInteractionService = drugInteractionService;
    }

    private Doctor getCurrentDoctor(Authentication authentication) {
        if (authentication == null) return null;
        String email = authentication.getName();
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null) return null;
        return doctorRepository.findByUserId(user.getId()).orElse(null);
    }

    // ---------------------------------------------------------
    // DOCTOR DASHBOARD & PATIENT QUEUE
    // ---------------------------------------------------------
    @GetMapping("/dashboard")
    public String dashboard(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "priority", defaultValue = "ALL") String priority,
            @RequestParam(value = "status", defaultValue = "ALL") String status,
            Authentication authentication,
            Model model) {

        Doctor doctor = getCurrentDoctor(authentication);
        List<MedicalCase> queueCases = caseService.getAllCasesForQueue(search, priority, status);

        long totalSubmitted = caseService.getCountByStatus(CaseStatus.SUBMITTED);
        long totalUnderReview = caseService.getCountByStatus(CaseStatus.UNDER_REVIEW);
        long totalVerified = caseService.getCountByStatus(CaseStatus.VERIFIED);
        long totalHighPriority = caseService.getCountByPriority(CasePriority.HIGH) + caseService.getCountByPriority(CasePriority.CRITICAL);

        model.addAttribute("doctor", doctor);
        model.addAttribute("cases", queueCases);
        model.addAttribute("search", search);
        model.addAttribute("selectedPriority", priority);
        model.addAttribute("selectedStatus", status);

        model.addAttribute("statTotalQueue", totalSubmitted + totalUnderReview);
        model.addAttribute("statHighPriority", totalHighPriority);
        model.addAttribute("statPendingReview", totalSubmitted);
        model.addAttribute("statVerified", totalVerified);

        return "doctor/dashboard";
    }

    // ---------------------------------------------------------
    // VIEW PATIENT CASE
    // ---------------------------------------------------------
    @GetMapping("/case/{id}")
    public String viewCase(
            @PathVariable("id") Long caseId,
            Authentication authentication,
            Model model) {

        Doctor doctor = getCurrentDoctor(authentication);
        MedicalCase medicalCase = caseService.getCaseById(caseId);
        if (medicalCase == null) {
            return "redirect:/doctor/dashboard";
        }

        // Move to UNDER_REVIEW if currently SUBMITTED
        if (medicalCase.getStatus() == CaseStatus.SUBMITTED) {
            medicalCase = caseService.doctorReviewCase(caseId, doctor);
        }

        DashavidhaService.DashavidhaMatrix dashavidhaMatrix = dashavidhaService.buildMatrix(medicalCase);
        List<DrugInteractionService.DrugInteractionAlert> ddiAlerts = drugInteractionService.evaluateInteractions(
                medicalCase.getCurrentMedication(), medicalCase.getDocuments(), medicalCase.getChiefComplaint());

        model.addAttribute("doctor", doctor);
        model.addAttribute("medicalCase", medicalCase);
        model.addAttribute("patient", medicalCase.getPatient());
        model.addAttribute("documents", medicalCase.getDocuments());
        model.addAttribute("answers", medicalCase.getAnswers());
        model.addAttribute("dashavidhaMatrix", dashavidhaMatrix);
        model.addAttribute("ddiAlerts", ddiAlerts);

        return "doctor/patient-case";
    }

    // ---------------------------------------------------------
    // EDIT CLINICAL SUMMARY (DOCTOR EDITING)
    // ---------------------------------------------------------
    @PostMapping("/case/{id}/edit")
    public String editCase(
            @PathVariable("id") Long caseId,
            @RequestParam(value = "chiefComplaint", required = false) String chiefComplaint,
            @RequestParam(value = "patientStatement", required = false) String patientStatement,
            @RequestParam(value = "pastMedicalHistory", required = false) String pastMedicalHistory,
            @RequestParam(value = "currentMedication", required = false) String currentMedication,
            @RequestParam(value = "allergies", required = false) String allergies,
            @RequestParam(value = "investigations", required = false) String investigations,
            @RequestParam(value = "ayushPrakriti", required = false) String ayushPrakriti,
            @RequestParam(value = "dashavidhaVikriti", required = false) String dashavidhaVikriti,
            @RequestParam(value = "dashavidhaSara", required = false) String dashavidhaSara,
            @RequestParam(value = "dashavidhaAhara", required = false) String dashavidhaAhara,
            @RequestParam(value = "doctorClinicalNotes", required = false) String doctorClinicalNotes,
            @RequestParam(value = "priority", defaultValue = "HIGH") String priorityStr) {

        CasePriority priority = CasePriority.NORMAL;
        try {
            priority = CasePriority.valueOf(priorityStr.toUpperCase());
        } catch (Exception ignored) {}

        caseService.doctorEditCase(caseId, chiefComplaint, patientStatement, pastMedicalHistory,
                currentMedication, allergies, investigations, doctorClinicalNotes, priority, ayushPrakriti,
                dashavidhaVikriti, dashavidhaSara, dashavidhaAhara);

        return "redirect:/doctor/case/" + caseId + "?edited=true";
    }

    @PostMapping("/case/{id}/verify")
    public String verifyCase(
            @PathVariable("id") Long caseId,
            @RequestParam(value = "chiefComplaint", required = false) String chiefComplaint,
            @RequestParam(value = "patientStatement", required = false) String patientStatement,
            @RequestParam(value = "pastMedicalHistory", required = false) String pastMedicalHistory,
            @RequestParam(value = "currentMedication", required = false) String currentMedication,
            @RequestParam(value = "allergies", required = false) String allergies,
            @RequestParam(value = "investigations", required = false) String investigations,
            @RequestParam(value = "ayushPrakriti", required = false) String ayushPrakriti,
            @RequestParam(value = "dashavidhaVikriti", required = false) String dashavidhaVikriti,
            @RequestParam(value = "dashavidhaSara", required = false) String dashavidhaSara,
            @RequestParam(value = "dashavidhaAhara", required = false) String dashavidhaAhara,
            @RequestParam(value = "doctorClinicalNotes", required = false) String doctorClinicalNotes,
            @RequestParam(value = "doctorNotes", required = false) String doctorNotes,
            @RequestParam(value = "priority", defaultValue = "NORMAL") String priorityStr,
            Authentication authentication) {

        String finalNotes = (doctorClinicalNotes != null && !doctorClinicalNotes.trim().isEmpty()) ?
                doctorClinicalNotes : doctorNotes;

        if (chiefComplaint != null) {
            CasePriority priority = CasePriority.NORMAL;
            try {
                priority = CasePriority.valueOf(priorityStr.toUpperCase());
            } catch (Exception ignored) {}
            caseService.doctorEditCase(caseId, chiefComplaint, patientStatement, pastMedicalHistory,
                    currentMedication, allergies, investigations, finalNotes, priority, ayushPrakriti,
                    dashavidhaVikriti, dashavidhaSara, dashavidhaAhara);
        }

        Doctor doctor = getCurrentDoctor(authentication);
        String name = (doctor != null && doctor.getUser() != null) ? doctor.getUser().getName() : "Dr. Ananya Roy";
        String prefix = name.startsWith("Dr.") ? "" : "Dr. ";
        String qual = (doctor != null && doctor.getQualification() != null) ? " (" + doctor.getQualification() + ")" : ", MD";
        String doctorName = prefix + name + qual;

        caseService.doctorVerifyCase(caseId, doctorName, finalNotes);

        return "redirect:/doctor/case/" + caseId + "?verified=true";
    }

    // ---------------------------------------------------------
    // REJECT / INVALIDATE CLINICAL SUMMARY (PHYSICIAN AUTHORITY)
    // ---------------------------------------------------------
    @PostMapping("/case/{id}/reject")
    public String rejectCase(
            @PathVariable("id") Long caseId,
            @RequestParam(value = "reason", required = false) String reason,
            Authentication authentication) {

        Doctor doctor = getCurrentDoctor(authentication);
        String name = (doctor != null && doctor.getUser() != null) ? doctor.getUser().getName() : "Dr. Ananya Roy";
        String doctorName = name.startsWith("Dr.") ? name : "Dr. " + name;

        caseService.doctorRejectCase(caseId, doctorName, reason);
        return "redirect:/doctor/case/" + caseId + "?rejected=true";
    }

    // ---------------------------------------------------------
    // REAL-TIME OPD QUEUE STREAM (HACKATHON DUAL-TERMINAL SYNC)
    // ---------------------------------------------------------
    @GetMapping("/queue/live")
    @ResponseBody
    public java.util.Map<String, Object> liveQueueStatus() {
        java.util.Map<String, Object> res = new java.util.HashMap<>();
        long totalSubmitted = caseService.getCountByStatus(CaseStatus.SUBMITTED);
        long totalUnderReview = caseService.getCountByStatus(CaseStatus.UNDER_REVIEW);
        long totalVerified = caseService.getCountByStatus(CaseStatus.VERIFIED);
        long totalHigh = caseService.getCountByPriority(CasePriority.HIGH);
        long totalCritical = caseService.getCountByPriority(CasePriority.CRITICAL);

        List<MedicalCase> queueCases = caseService.getAllCasesForQueue(null, "ALL", "ALL");

        res.put("totalQueue", totalSubmitted + totalUnderReview);
        res.put("pendingReview", totalSubmitted);
        res.put("underReview", totalUnderReview);
        res.put("verified", totalVerified);
        res.put("highPriority", totalHigh + totalCritical);
        res.put("criticalCount", totalCritical);

        // Check for urgent emergency alert
        boolean hasActiveEmergency = queueCases.stream()
                .anyMatch(c -> c.getStatus() == CaseStatus.EMERGENCY_ESCALATED || 
                              (c.getPriority() == CasePriority.CRITICAL && c.getStatus() != CaseStatus.VERIFIED));
        res.put("hasActiveEmergency", hasActiveEmergency);

        if (hasActiveEmergency) {
            MedicalCase emergencyCase = queueCases.stream()
                    .filter(c -> c.getStatus() == CaseStatus.EMERGENCY_ESCALATED || c.getPriority() == CasePriority.CRITICAL)
                    .findFirst().orElse(null);
            if (emergencyCase != null) {
                res.put("emergencyToken", emergencyCase.getTokenNumber());
                res.put("emergencyPatient", emergencyCase.getPatient() != null && emergencyCase.getPatient().getUser() != null ? emergencyCase.getPatient().getUser().getName() : "Patient");
                res.put("emergencyReason", emergencyCase.getPriorityReason());
                res.put("emergencyCaseId", emergencyCase.getId());
            }
        }

        return res;
    }
}
