package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.CasePriority;
import com.example.Health_Data_Management.entity.MedicalCase;
import org.springframework.stereotype.Service;

@Service
public class RedFlagService {

    public static class RedFlagEvaluation {
        private final CasePriority priority;
        private final boolean redFlagsDetected;
        private final String reason;

        public RedFlagEvaluation(CasePriority priority, boolean redFlagsDetected, String reason) {
            this.priority = priority;
            this.redFlagsDetected = redFlagsDetected;
            this.reason = reason;
        }

        public CasePriority getPriority() { return priority; }
        public boolean isRedFlagsDetected() { return redFlagsDetected; }
        public String getReason() { return reason; }
    }

    /**
     * Deterministic clinical red-flag detection rules
     */
    public RedFlagEvaluation evaluate(MedicalCase medicalCase) {
        String complaint = normalize(medicalCase.getChiefComplaint());
        String symptoms = normalize(medicalCase.getAssociatedSymptoms());
        String statement = normalize(medicalCase.getPatientStatement());
        String severity = normalize(medicalCase.getSeverity());

        boolean hasChestPain = complaint.contains("chest") || complaint.contains("heart") ||
                              statement.contains("chest") || statement.contains("chhati") ||
                              symptoms.contains("chest pain");

        boolean hasBreathingDifficulty = symptoms.contains("breath") || symptoms.contains("saans") ||
                                       symptoms.contains("dyspnea") || symptoms.contains("shortness of breath") ||
                                       statement.contains("saans") || complaint.contains("breath");

        boolean isSevere = severity.contains("severe") || severity.contains("critical") || severity.contains("high") ||
                          severity.contains("8") || severity.contains("9") || severity.contains("10");

        // Rule 1: Chest Pain + Breathing Difficulty -> HIGH PRIORITY
        if (hasChestPain && hasBreathingDifficulty) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Chest pain with breathing difficulty (Cardiovascular / Respiratory Red Flag)"
            );
        }

        // Rule 2: Chest Pain alone with high severity -> HIGH PRIORITY
        if (hasChestPain && isSevere) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Severe chest discomfort reported by patient"
            );
        }

        // Rule 3: Acute Neurological (slurred speech, sudden weakness) -> CRITICAL
        if (complaint.contains("stroke") || complaint.contains("paralysis") || symptoms.contains("slurred speech") || symptoms.contains("facial droop")) {
            return new RedFlagEvaluation(
                CasePriority.CRITICAL,
                true,
                "Acute neurological focal deficit signs detected"
            );
        }

        // Rule 4: High fever with altered consciousness or seizure -> HIGH
        if ((complaint.contains("fever") || symptoms.contains("fever")) && (symptoms.contains("stiff neck") || symptoms.contains("confusion") || symptoms.contains("unconscious"))) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Febrile illness with central nervous system red flags"
            );
        }

        // Rule 5: Severe standalone breathing difficulty
        if (hasBreathingDifficulty && isSevere) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Acute severe respiratory distress"
            );
        }

        // Default Normal Priority
        return new RedFlagEvaluation(
            CasePriority.NORMAL,
            false,
            "Standard clinical intake. No acute predefined red flags detected."
        );
    }

    private String normalize(String input) {
        return input != null ? input.toLowerCase().trim() : "";
    }
}
