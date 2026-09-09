package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.MedicalDocument;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
public class DrugInteractionService {

    public static class DrugInteractionAlert {
        private final String drugA;
        private final String drugB;
        private final String severity; // CRITICAL, MAJOR, MODERATE
        private final String riskSummary;
        private final String clinicalMechanism;
        private final String recommendation;

        public DrugInteractionAlert(String drugA, String drugB, String severity, String riskSummary, String clinicalMechanism, String recommendation) {
            this.drugA = drugA;
            this.drugB = drugB;
            this.severity = severity;
            this.riskSummary = riskSummary;
            this.clinicalMechanism = clinicalMechanism;
            this.recommendation = recommendation;
        }

        public String getDrugA() { return drugA; }
        public String getDrugB() { return drugB; }
        public String getSeverity() { return severity; }
        public String getRiskSummary() { return riskSummary; }
        public String getClinicalMechanism() { return clinicalMechanism; }
        public String getRecommendation() { return recommendation; }
    }

    /**
     * Evaluates current medications against clinical pharmacology drug-drug and herb-drug interaction rules.
     */
    public List<DrugInteractionAlert> evaluateInteractions(String medicationText, List<MedicalDocument> documents, String chiefComplaint) {
        List<DrugInteractionAlert> alerts = new ArrayList<>();

        StringBuilder fullMeds = new StringBuilder();
        if (medicationText != null) {
            fullMeds.append(medicationText.toLowerCase(Locale.ROOT)).append(" ");
        }
        if (documents != null) {
            for (MedicalDocument doc : documents) {
                if (doc.getExtractedMedications() != null) {
                    fullMeds.append(doc.getExtractedMedications().toLowerCase(Locale.ROOT)).append(" ");
                }
            }
        }

        String corpus = fullMeds.toString();
        String cc = chiefComplaint != null ? chiefComplaint.toLowerCase(Locale.ROOT) : "";

        // 1. Warfarin / Anticoagulants + Aspirin / NSAIDs (Severe Bleeding Hazard)
        boolean hasWarfarin = corpus.contains("warfarin") || corpus.contains("coumadin") || corpus.contains("heparin") || corpus.contains("apixaban") || corpus.contains("rivaroxaban");
        boolean hasAspirinOrNsaid = corpus.contains("aspirin") || corpus.contains("ibuprofen") || corpus.contains("naproxen") || corpus.contains("diclofenac") || corpus.contains("clopidogrel");

        if (hasWarfarin && hasAspirinOrNsaid) {
            alerts.add(new DrugInteractionAlert(
                    "Anticoagulant (Warfarin/Direct Factor Xa)",
                    "Antiplatelet/NSAID (Aspirin/Clopidogrel)",
                    "CRITICAL",
                    "Potentiated Gastrointestinal & Systemic Hemorrhage Risk",
                    "Synergistic inhibition of platelet aggregation combined with coagulation cascade suppression drastically increases mucosal bleeding risk.",
                    "Review prothrombin time (INR). Consider replacing NSAID with paracetamol; evaluate gastroprotective PPI co-prescription if combination is clinically mandated."
            ));
        }

        // 2. Metformin + Iodinated Contrast or Acute Renal Compromise
        boolean hasMetformin = corpus.contains("metformin") || corpus.contains("glucophage") || corpus.contains("glycomet");
        boolean hasContrastOrRenalRisk = corpus.contains("contrast") || corpus.contains("dialysis") || corpus.contains("creatinine") || cc.contains("renal") || cc.contains("kidney");

        if (hasMetformin && hasContrastOrRenalRisk) {
            alerts.add(new DrugInteractionAlert(
                    "Metformin",
                    "Iodinated Radiocontrast / Renal Impairment",
                    "MAJOR",
                    "Lactic Acidosis Hazard with Acute Contrast Nephropathy",
                    "Contrast-induced renal dysfunction reduces metformin clearance, leading to toxic intracellular biguanide accumulation and metabolic acidosis.",
                    "Withhold metformin at the time of procedure and for 48 hours following contrast administration. Recheck serum eGFR prior to restarting."
            ));
        }

        // 3. ACE Inhibitor / ARB + Spironolactone or Potassium Sparing Agents
        boolean hasAceOrArb = corpus.contains("enalapril") || corpus.contains("ramipril") || corpus.contains("lisinopril") || corpus.contains("losartan") || corpus.contains("telmisartan");
        boolean hasPotassiumAgent = corpus.contains("spironolactone") || corpus.contains("aldactone") || corpus.contains("potassium") || corpus.contains("eplerenone");

        if (hasAceOrArb && hasPotassiumAgent) {
            alerts.add(new DrugInteractionAlert(
                    "ACE Inhibitor / ARB (Ramipril/Telmisartan)",
                    "Potassium-Sparing Diuretic (Spironolactone)",
                    "MAJOR",
                    "Severe Hyperkalemia & Cardiac Arrhythmia Risk",
                    "Combined suppression of aldosterone secretion and renal tubular potassium excretion can cause life-threatening serum potassium elevation (> 5.5 mEq/L).",
                    "Monitor baseline serum electrolytes and creatinine within 1-2 weeks of initiation. Advise patient against potassium salt substitutes."
            ));
        }

        // 4. Nitrates + PDE5 Inhibitors (Sildenafil / Tadalafil)
        boolean hasNitrate = corpus.contains("nitroglycerin") || corpus.contains("sorbitrate") || corpus.contains("isosorbide");
        boolean hasPde5 = corpus.contains("sildenafil") || corpus.contains("tadalafil") || corpus.contains("viagra");

        if (hasNitrate && hasPde5) {
            alerts.add(new DrugInteractionAlert(
                    "Organic Nitrate (Nitroglycerin/Isosorbide)",
                    "PDE-5 Inhibitor (Sildenafil/Tadalafil)",
                    "CRITICAL",
                    "Severe Refractory Vasodilation & Precipitous Hypotension",
                    "Cyclic GMP accumulation causes profound systemic arterial vasodilation, resulting in fatal coronary hypoperfusion and syncope.",
                    "Co-administration is strictly contraindicated. Ensure minimum 24-48 hour washout period before nitrate administration."
            ));
        }

        // 5. AYUSH Herb-Drug Interactions (Ayurveda Guggulu / Ashwagandha / Yashtimadhu)
        boolean hasAshwagandha = corpus.contains("ashwagandha") || corpus.contains("withania");
        boolean hasSedative = corpus.contains("alprazolam") || corpus.contains("clonazepam") || corpus.contains("zolpidem") || corpus.contains("lorazepam");

        if (hasAshwagandha && hasSedative) {
            alerts.add(new DrugInteractionAlert(
                    "Ashwagandha (Withania somnifera)",
                    "Benzodiazepine / Sedative (Alprazolam/Clonazepam)",
                    "MODERATE",
                    "Potentiated CNS Depression & Excessive Sedation",
                    "GABA-mimetic constituents in Withania synergize with central benzodiazepine receptors, augmenting somnolence and motor impairment.",
                    "Counsel patient regarding psychomotor slowing, nighttime dizziness, and operating machinery. Consider titration."
            ));
        }

        boolean hasGuggulu = corpus.contains("guggul") || corpus.contains("guggulu") || corpus.contains("commiphora");
        if (hasGuggulu && (hasWarfarin || hasAspirinOrNsaid)) {
            alerts.add(new DrugInteractionAlert(
                    "Guggulu (Commiphora mukul)",
                    "Anticoagulant / Antiplatelet",
                    "MODERATE",
                    "Antiplatelet Aggregation Additive Bleeding Risk",
                    "Guggulsterones exhibit intrinsic anti-thrombotic properties that can augment the anticoagulant effect of allopathic blood thinners.",
                    "Advise clinical surveillance for spontaneous bruising, epistaxis, or hematuria."
            ));
        }

        return alerts;
    }

    /**
     * Converts alerts into compact JSON string for database persistence and client inspection.
     */
    public String alertsToJson(List<DrugInteractionAlert> alerts) {
        if (alerts == null || alerts.isEmpty()) {
            return "[]";
        }
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < alerts.size(); i++) {
            DrugInteractionAlert a = alerts.get(i);
            sb.append("{")
                    .append("\"drugA\":\"").append(escapeJson(a.getDrugA())).append("\",")
                    .append("\"drugB\":\"").append(escapeJson(a.getDrugB())).append("\",")
                    .append("\"severity\":\"").append(escapeJson(a.getSeverity())).append("\",")
                    .append("\"riskSummary\":\"").append(escapeJson(a.getRiskSummary())).append("\",")
                    .append("\"clinicalMechanism\":\"").append(escapeJson(a.getClinicalMechanism())).append("\",")
                    .append("\"recommendation\":\"").append(escapeJson(a.getRecommendation())).append("\"")
                    .append("}");
            if (i < alerts.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"").replace("\n", " ");
    }
}
