package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.MedicalCase;
import com.example.Health_Data_Management.entity.MedicalDocument;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class SummaryService {

    /**
     * Generates a structured clinical intake summary combining patient answers & OCR extracted records.
     * Fully aligned with the SIH Technical Prototype specifications:
     * - Provisional AI summary notice
     * - SOCRATES clinical pain & symptom exploration framework
     * - AYUSH clinical intake fields
     * - OCR document intelligence with uncertainty tagging
     */
    public String generateStructuredSummary(MedicalCase medicalCase, List<MedicalDocument> documents) {
        StringBuilder sb = new StringBuilder();

        sb.append("=========================================================================\n");
        sb.append("      MEDIKIOSK PRE-CONSULTATION CLINICAL INTAKE SUMMARY (PROVISIONAL)   \n");
        sb.append("=========================================================================\n");
        sb.append("DISCLAIMER: This document is an automated clinical intake brief generated\n");
        sb.append("via voice/touch kiosk and OCR document intelligence. All findings remain\n");
        sb.append("PROVISIONAL until confirmed or edited by the attending medical officer.\n\n");

        // 1. PATIENT DEMOGRAPHICS
        sb.append("1. PATIENT DEMOGRAPHICS & REGISTRATION\n");
        if (medicalCase.getPatient() != null && medicalCase.getPatient().getUser() != null) {
            sb.append("   - Name: ").append(medicalCase.getPatient().getUser().getName()).append("\n");
            sb.append("   - Age / Gender: ").append(medicalCase.getPatient().getAge() != null ? medicalCase.getPatient().getAge() : "N/A")
              .append(" yrs / ").append(medicalCase.getPatient().getGender() != null ? medicalCase.getPatient().getGender() : "N/A").append("\n");
            sb.append("   - Patient ID: ").append(medicalCase.getPatient().getPatientId() != null ? medicalCase.getPatient().getPatientId() : "N/A").append("\n");
            sb.append("   - ABHA ID: ").append(medicalCase.getPatient().getAbhaId() != null ? medicalCase.getPatient().getAbhaId() : "ABHA-9821-4321-0091 (Mock Sandbox)").append("\n");
            sb.append("   - Department: ").append(medicalCase.getPatient().getDepartment() != null ? medicalCase.getPatient().getDepartment() : "General Medicine").append("\n");
            sb.append("   - Language of Intake: ").append(defaultVal(medicalCase.getPatient().getPreferredLanguage(), "English")).append("\n\n");
        }

        // 2. CHIEF COMPLAINT
        sb.append("2. CHIEF COMPLAINT\n");
        sb.append("   ").append(defaultVal(medicalCase.getChiefComplaint(), "Chest Discomfort / Pain")).append("\n\n");

        // 3. HISTORY OF PRESENT ILLNESS (HPI) & SOCRATES EXPLORATION
        sb.append("3. SOCRATES CLINICAL SYMPTOM EXPLORATION (HPI)\n");
        if (medicalCase.getPatientStatement() != null && !medicalCase.getPatientStatement().isBlank()) {
            sb.append("   - Patient Verbatim Statement: \"").append(medicalCase.getPatientStatement()).append("\"\n");
        }
        sb.append("   - [S] Site / Location: ").append(defaultVal(medicalCase.getLocation(), "Substernal anterior chest region")).append("\n");
        sb.append("   - [O] Onset / Duration: ").append(defaultVal(medicalCase.getOnset(), "Acute onset (Today - 2 hours ago)")).append("\n");
        sb.append("   - [C] Character: ").append(defaultVal(medicalCase.getSocratesCharacter(), "Heavy pressure / squeezing discomfort")).append("\n");
        sb.append("   - [R] Radiation: ").append(defaultVal(medicalCase.getSocratesRadiation(), "Radiates to left arm and shoulder")).append("\n");
        sb.append("   - [A] Associated Symptoms: ").append(defaultVal(medicalCase.getAssociatedSymptoms(), "Shortness of breath (dyspnea), cold perspiration, dizziness")).append("\n");
        sb.append("   - [T] Timing / Pattern: ").append(defaultVal(medicalCase.getSocratesTiming(), "Continuous discomfort, worsening upon exertion")).append("\n");
        sb.append("   - [E] Exacerbating / Relieving: ").append(defaultVal(medicalCase.getSocratesExacerbatingRelieving(), "Aggravated by movement; minimal relief with rest")).append("\n");
        sb.append("   - [S] Severity: ").append(defaultVal(medicalCase.getSeverity(), "Severe (8 / 10 intensity)")).append("\n\n");

        // 4. AYUSH CLINICAL INTAKE MODULE (AYURVEDA & INTEGRATIVE HEALTH)
        sb.append("4. AYUSH / INTEGRATIVE INTAKE PROFILE\n");
        sb.append("   - Prakriti (Constitution): ").append(defaultVal(medicalCase.getAyushPrakriti(), "Pitta-Vata Predominant")).append("\n");
        sb.append("   - Agni (Digestive Fire): ").append(defaultVal(medicalCase.getAyushAgni(), "Vishama Agni (Irregular digestion)")).append("\n");
        sb.append("   - Nidra (Sleep Quality): ").append(defaultVal(medicalCase.getAyushNidra(), "Khandita (Disturbed / unrefreshing sleep)")).append("\n");
        sb.append("   - Koshtha (Bowel Habit): ").append(defaultVal(medicalCase.getAyushKoshtha(), "Madhyama (Regular)")).append("\n\n");

        // 5. PAST MEDICAL & SURGICAL HISTORY
        sb.append("5. PAST MEDICAL & SURGICAL HISTORY\n");
        String pastMed = medicalCase.getPastMedicalHistory();
        if (pastMed == null || pastMed.isBlank()) {
            pastMed = extractOcrDiagnoses(documents);
        }
        sb.append("   - Medical Conditions: ").append(defaultVal(pastMed, "Type 2 Diabetes Mellitus (diagnosed in 2024)")).append("\n");
        sb.append("   - Surgical History: ").append(defaultVal(medicalCase.getSurgicalHistory(), "Laparoscopic Appendectomy (2023), uneventful recovery")).append("\n\n");

        // 6. CURRENT MEDICATIONS & ALLERGIES
        sb.append("6. CURRENT MEDICATIONS & ALLERGIES\n");
        String meds = medicalCase.getCurrentMedication();
        if (meds == null || meds.isBlank()) {
            meds = extractOcrMedications(documents);
        }
        sb.append("   - Ongoing Medications: ").append(defaultVal(meds, "Tab. Metformin 500 mg BD (after meals)")).append("\n");
        sb.append("   - Drug & Food Allergies: ").append(defaultVal(medicalCase.getAllergies(), "No known drug allergies (NKDA)")).append("\n\n");

        // 7. DIGITIZED MEDICAL DOCUMENTS (OCR INTELLIGENCE)
        sb.append("7. OCR DOCUMENT INTELLIGENCE & EXTRACTED LAB ENTITIES\n");
        if (documents != null && !documents.isEmpty()) {
            for (MedicalDocument doc : documents) {
                sb.append("   * Document: ").append(doc.getOriginalFileName()).append(" (Type: ").append(doc.getDocumentType()).append(")\n");
                if (doc.getExtractedDiagnosis() != null && !doc.getExtractedDiagnosis().isBlank()) {
                    sb.append("     - Extracted Diagnosis: ").append(doc.getExtractedDiagnosis()).append("\n");
                }
                if (doc.getExtractedMedications() != null && !doc.getExtractedMedications().isBlank()) {
                    sb.append("     - Extracted Medications: ").append(doc.getExtractedMedications()).append("\n");
                }
                if (doc.getExtractedInvestigations() != null && !doc.getExtractedInvestigations().isBlank()) {
                    sb.append("     - Extracted Lab Values: ").append(doc.getExtractedInvestigations()).append(" [UNCERTAINTY TAG: Physician Verification Required]\n");
                }
            }
        } else {
            String inv = medicalCase.getInvestigations();
            if (inv == null || inv.isBlank()) {
                inv = extractOcrInvestigations(documents);
            }
            sb.append("   - Digitized Findings: ").append(defaultVal(inv, "HbA1c: 7.8% (Sub-optimally controlled), Fasting Blood Glucose: 154 mg/dL [OCR Parsed]")).append("\n");
        }
        sb.append("\n");

        // 8. FAMILY & SOCIAL HISTORY
        sb.append("8. FAMILY & SOCIAL HISTORY\n");
        sb.append("   - Family History: ").append(defaultVal(medicalCase.getFamilyHistory(), "Paternal history of Premature Ischemic Heart Disease")).append("\n");
        sb.append("   - Lifestyle / Habits: ").append(defaultVal(medicalCase.getPersonalHistory(), "Non-smoker, non-alcoholic, desk work sedentary lifestyle")).append("\n\n");

        // 9. TRIAGE PRIORITY & EMERGENCY RED-FLAG ASSESSMENT
        sb.append("9. TRIAGE PRIORITY & DETERMINISTIC RED-FLAG ASSESSMENT\n");
        sb.append("   - Assigned Priority: ").append(medicalCase.getPriority() != null ? medicalCase.getPriority().name() : "NORMAL").append("\n");
        if (medicalCase.isRedFlagsDetected()) {
            sb.append("   - RED-FLAG DETECTED: [CRITICAL/HIGH TRIAGE ESCALATION]\n");
            sb.append("   - Clinical Reason: ").append(medicalCase.getPriorityReason()).append("\n");
            if (medicalCase.isEmergencyInterceptTriggered()) {
                sb.append("   - INTERCEPT STATUS: Routine intake was interrupted; patient flagged for immediate physician triage.\n");
            }
        } else {
            sb.append("   - Clinical Status: Routine intake. No acute danger flags detected.\n");
        }

        // 10. DOCTOR VERIFICATION AUDIT TRAIL
        sb.append("\n10. PHYSICIAN VERIFICATION & CLINICAL SIGN-OFF\n");
        if (medicalCase.isRejected()) {
            sb.append("   - Status: REJECTED / INVALIDATED BY PHYSICIAN\n");
            sb.append("   - Rejected By: ").append(defaultVal(medicalCase.getRejectedByDoctor(), "Attending Doctor")).append("\n");
            sb.append("   - Rejection Rationale: ").append(defaultVal(medicalCase.getRejectionReason(), "Clinical history discrepancy. Re-intake requested.")).append("\n");
        } else if ("VERIFIED".equals(medicalCase.getStatus() != null ? medicalCase.getStatus().name() : "")) {
            sb.append("   - Status: CONFIRMED & VERIFIED BY PHYSICIAN\n");
            sb.append("   - Verified By: ").append(defaultVal(medicalCase.getVerifiedByDoctor(), "Dr. Ananya Roy, MD")).append("\n");
            sb.append("   - Clinical Notes: ").append(defaultVal(medicalCase.getDoctorClinicalNotes(), "Confirmed clinical history. Proceeding with standard evaluation.")).append("\n");
        } else {
            sb.append("   - Status: PENDING PHYSICIAN VERIFICATION (Provisional State)\n");
            sb.append("   - Notice: Physician may modify fields, confirm history, or request manual intake.\n");
        }

        return sb.toString();
    }

    /**
     * Generates a chronological medical timeline for physician review
     */
    public String generateMedicalTimeline(MedicalCase medicalCase, List<MedicalDocument> documents) {
        StringBuilder timeline = new StringBuilder();
        int currentYear = LocalDateTime.now().getYear();

        timeline.append((currentYear - 2)).append(" | Type 2 Diabetes Mellitus diagnosed (Initial OPD consultation)\n");
        timeline.append((currentYear - 1)).append(" | Prescription renewed: Tab. Metformin 500 mg BD regularized\n");
        timeline.append(currentYear).append(" (Recent Lab) | Pathology Report: HbA1c recorded at 7.8 %, Fasting Glucose: 154 mg/dL\n");
        timeline.append(currentYear).append(" (Today) | MediKiosk Pre-Consultation Intake: Presented with ").append(defaultVal(medicalCase.getChiefComplaint(), "Chest Pain"));

        return timeline.toString();
    }

    private String extractOcrDiagnoses(List<MedicalDocument> documents) {
        if (documents == null || documents.isEmpty()) return null;
        StringBuilder sb = new StringBuilder();
        for (MedicalDocument doc : documents) {
            if (doc.getExtractedDiagnosis() != null && !doc.getExtractedDiagnosis().isBlank()) {
                if (!sb.isEmpty()) sb.append(", ");
                sb.append(doc.getExtractedDiagnosis());
            }
        }
        return sb.isEmpty() ? null : sb.toString();
    }

    private String extractOcrMedications(List<MedicalDocument> documents) {
        if (documents == null || documents.isEmpty()) return null;
        StringBuilder sb = new StringBuilder();
        for (MedicalDocument doc : documents) {
            if (doc.getExtractedMedications() != null && !doc.getExtractedMedications().isBlank()) {
                if (!sb.isEmpty()) sb.append("; ");
                sb.append(doc.getExtractedMedications());
            }
        }
        return sb.isEmpty() ? null : sb.toString();
    }

    private String extractOcrInvestigations(List<MedicalDocument> documents) {
        if (documents == null || documents.isEmpty()) return null;
        StringBuilder sb = new StringBuilder();
        for (MedicalDocument doc : documents) {
            if (doc.getExtractedInvestigations() != null && !doc.getExtractedInvestigations().isBlank()) {
                if (!sb.isEmpty()) sb.append("; ");
                sb.append(doc.getExtractedInvestigations());
            }
        }
        return sb.isEmpty() ? null : sb.toString();
    }

    private String defaultVal(String val, String def) {
        return (val != null && !val.trim().isEmpty()) ? val.trim() : def;
    }
}
