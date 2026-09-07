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
        private final boolean interruptIntake;

        public RedFlagEvaluation(CasePriority priority, boolean redFlagsDetected, String reason, boolean interruptIntake) {
            this.priority = priority;
            this.redFlagsDetected = redFlagsDetected;
            this.reason = reason;
            this.interruptIntake = interruptIntake;
        }

        public CasePriority getPriority() { return priority; }
        public boolean isRedFlagsDetected() { return redFlagsDetected; }
        public String getReason() { return reason; }
        public boolean isInterruptIntake() { return interruptIntake; }
    }

    /**
     * Deterministic clinical red-flag detection rules aligned with SIH Technical Prototype specs.
     * Evaluates symptoms in English, Hindi, and transliterated Hinglish.
     */
    public RedFlagEvaluation evaluate(MedicalCase medicalCase) {
        String complaint = normalize(medicalCase.getChiefComplaint());
        String symptoms = normalize(medicalCase.getAssociatedSymptoms());
        String statement = normalize(medicalCase.getPatientStatement());
        String severity = normalize(medicalCase.getSeverity());
        String location = normalize(medicalCase.getLocation());
        String radiation = normalize(medicalCase.getSocratesRadiation());

        String aggregate = complaint + " " + symptoms + " " + statement + " " + location + " " + radiation;

        boolean hasChestPain = aggregate.contains("chest") || aggregate.contains("heart") ||
                              aggregate.contains("chhati") || aggregate.contains("chaati") ||
                              aggregate.contains("seene") || aggregate.contains("angina") ||
                              aggregate.contains("cardiac");

        boolean hasBreathingDifficulty = aggregate.contains("breath") || aggregate.contains("saans") ||
                                       aggregate.contains("dyspnea") || aggregate.contains("shortness of breath") ||
                                       aggregate.contains("gasping") || aggregate.contains("choking") ||
                                       aggregate.contains("suffocation");

        boolean hasRadiatingPain = aggregate.contains("arm") || aggregate.contains("jaw") ||
                                  aggregate.contains("back") || aggregate.contains("shoulder") ||
                                  aggregate.contains("baye hath") || aggregate.contains("left arm");

        boolean isSevere = severity.contains("severe") || severity.contains("critical") ||
                          severity.contains("high") || severity.contains("8") ||
                          severity.contains("9") || severity.contains("10");

        // Rule 1: Acute Neurological Deficits (Stroke, Lakwa, Slurred Speech, Seizure) -> CRITICAL & INTERRUPT
        if (aggregate.contains("stroke") || aggregate.contains("paralysis") || aggregate.contains("lakwa") ||
            aggregate.contains("slurred speech") || aggregate.contains("facial droop") || aggregate.contains("bolne me dikkat") ||
            aggregate.contains("seizure") || aggregate.contains("daura") || aggregate.contains("unconscious") ||
            aggregate.contains("behosh") || aggregate.contains("loss of consciousness")) {
            return new RedFlagEvaluation(
                CasePriority.CRITICAL,
                true,
                "Acute Neurological / Cerebrovascular Emergency Detected (Immediate Stroke/Seizure Triage Required)",
                true
            );
        }

        // Rule 2: Chest Pain + Breathing Difficulty / Radiating Pain -> CRITICAL & INTERRUPT
        if (hasChestPain && (hasBreathingDifficulty || hasRadiatingPain || isSevere)) {
            return new RedFlagEvaluation(
                CasePriority.CRITICAL,
                true,
                "Acute Coronary Syndrome (ACS) / Cardiopulmonary Red Flag (Chest discomfort with respiratory/radiation signs)",
                true
            );
        }

        // Rule 3: Acute Severe Respiratory Distress Alone -> HIGH & INTERRUPT
        if (hasBreathingDifficulty && isSevere) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Severe Respiratory Distress / Acute Hypoxia Risk (Immediate Oxygenation & Evaluation Required)",
                true
            );
        }

        // Rule 4: Moderate Chest Discomfort alone -> HIGH (Prompt review)
        if (hasChestPain) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Cardiovascular warning: Patient reports chest discomfort",
                false
            );
        }

        // Rule 5: Febrile illness with altered sensorium or stiff neck -> HIGH
        if ((aggregate.contains("fever") || aggregate.contains("bukhar")) &&
            (aggregate.contains("stiff neck") || aggregate.contains("confusion") || aggregate.contains("delirium"))) {
            return new RedFlagEvaluation(
                CasePriority.HIGH,
                true,
                "Febrile illness with central nervous system red flags (Meningitis/Encephalitis alert)",
                true
            );
        }

        // Rule 6: Massive Bleeding or Anaphylaxis -> CRITICAL & INTERRUPT
        if (aggregate.contains("vomiting blood") || aggregate.contains("khoon ki ulti") ||
            aggregate.contains("severe bleeding") || aggregate.contains("anaphylaxis") ||
            aggregate.contains("throat swelling") || aggregate.contains("gale me sujan")) {
            return new RedFlagEvaluation(
                CasePriority.CRITICAL,
                true,
                "Critical Medical Emergency: Acute Hemorrhage or Anaphylaxis Warning",
                true
            );
        }

        // Default Normal Priority
        return new RedFlagEvaluation(
            CasePriority.NORMAL,
            false,
            "Standard clinical intake. No acute emergency red flags detected.",
            false
        );
    }

    private String normalize(String input) {
        return input != null ? input.toLowerCase().trim() : "";
    }
}
