package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.MedicalCase;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class DashavidhaService {

    public static class DashavidhaMatrix {
        private final Map<String, DimensionProfile> dimensions = new LinkedHashMap<>();

        public void addDimension(String code, String sanskritTitle, String englishTitle, String clinicalFinding, String clinicalSignificance) {
            dimensions.put(code, new DimensionProfile(sanskritTitle, englishTitle, clinicalFinding, clinicalSignificance));
        }

        public Map<String, DimensionProfile> getDimensions() {
            return dimensions;
        }
    }

    public static class DimensionProfile {
        private final String sanskritTitle;
        private final String englishTitle;
        private final String clinicalFinding;
        private final String clinicalSignificance;

        public DimensionProfile(String sanskritTitle, String englishTitle, String clinicalFinding, String clinicalSignificance) {
            this.sanskritTitle = sanskritTitle;
            this.englishTitle = englishTitle;
            this.clinicalFinding = clinicalFinding;
            this.clinicalSignificance = clinicalSignificance;
        }

        public String getSanskritTitle() { return sanskritTitle; }
        public String getEnglishTitle() { return englishTitle; }
        public String getClinicalFinding() { return clinicalFinding; }
        public String getClinicalSignificance() { return clinicalSignificance; }
    }

    /**
     * Synthesizes the full 10-fold Ayurvedic Dashavidha Pariksha assessment
     * based on patient intake data, constitutional parameters, and chief complaint.
     */
    public DashavidhaMatrix buildMatrix(MedicalCase mc) {
        DashavidhaMatrix matrix = new DashavidhaMatrix();

        // 1. Prakriti (Constitutional Dosha)
        String prakriti = mc.getAyushPrakriti() != null && !mc.getAyushPrakriti().isBlank()
                ? mc.getAyushPrakriti()
                : "Pitta-Vata Predominant (Dvidoshaja)";
        matrix.addDimension(
                "PRAKRITI",
                "प्रकृति (Prakriti)",
                "Constitutional Genotype / Dosha Baseline",
                prakriti,
                "Determines baseline metabolic rate, physical resilience, and inherent disease susceptibility."
        );

        // 2. Vikriti (Pathological Morbidity / Imbalance)
        String vikriti = mc.getDashavidhaVikriti() != null && !mc.getDashavidhaVikriti().isBlank()
                ? mc.getDashavidhaVikriti()
                : (mc.getChiefComplaint() != null && mc.getChiefComplaint().toLowerCase().contains("chest")
                ? "Vata-Kapha Avarana with Pitta involvement (Pranavaha Sroto-Dushti)"
                : "Vata-Pitta Dushti with Agnimandya");
        matrix.addDimension(
                "VIKRITI",
                "विकृति (Vikriti)",
                "Current Pathological Imbalance & Morbidity State",
                vikriti,
                "Reflects the active doshic deviation from baseline requiring therapeutic pacification (Shamana/Shodhana)."
        );

        // 3. Sara (Tissue Essence / Dhatu Vitality)
        String sara = mc.getDashavidhaSara() != null && !mc.getDashavidhaSara().isBlank()
                ? mc.getDashavidhaSara()
                : "Madhyama Twak-Rakta Sara (Intermediate cutaneous and vascular tissue essence)";
        matrix.addDimension(
                "SARA",
                "सार (Sara)",
                "Dhatu Excellence / Tissue Integrity Assessment",
                sara,
                "Evaluates constitutional structural stability and longevity potential across 7 Dhatus + Sattva."
        );

        // 4. Samhanana (Body Compactness & Physique)
        String samhanana = mc.getDashavidhaSamhanana() != null && !mc.getDashavidhaSamhanana().isBlank()
                ? mc.getDashavidhaSamhanana()
                : "Madhyama Samhanana (Proportionate musculoskeletal compactness)";
        matrix.addDimension(
                "SAMHANANA",
                "संहनन (Samhanana)",
                "Body Compactness & Musculoskeletal Symmetry",
                samhanana,
                "Assesses bone joint integration, firmness of muscles, and resistance to physical trauma."
        );

        // 5. Pramana (Anthropometric Proportions / Stature)
        String pramana = mc.getDashavidhaPramana() != null && !mc.getDashavidhaPramana().isBlank()
                ? mc.getDashavidhaPramana()
                : "Yathokta Pramana (Normal body proportions / Normosthenic build)";
        matrix.addDimension(
                "PRAMANA",
                "प्रमाण (Pramana)",
                "Anthropometric Proportions & Body Geometry",
                pramana,
                "Assesses biological symmetry using classical Anguli measurement principles."
        );

        // 6. Satmya (Habituation & Adaptability)
        String satmya = mc.getDashavidhaSatmya() != null && !mc.getDashavidhaSatmya().isBlank()
                ? mc.getDashavidhaSatmya()
                : "Madhyama Satmya (Adaptable to mixed Shad-Rasa dietary habits and seasonal shifts)";
        matrix.addDimension(
                "SATMYA",
                "सात्म्य (Satmya)",
                "Habituation & Physiological Homologation",
                satmya,
                "Evaluates wholesome dietary habituation and environmental adaptability."
        );

        // 7. Satva (Psychological Stamina / Mental Resilience)
        String satva = mc.getDashavidhaSatva() != null && !mc.getDashavidhaSatva().isBlank()
                ? mc.getDashavidhaSatva()
                : "Madhyama Satva (Moderate emotional resilience, responds well to reassuring guidance)";
        matrix.addDimension(
                "SATVA",
                "सत्त्व (Satva)",
                "Mental Endurance & Psychological Stamina",
                satva,
                "Classified into Pravara (Superior), Madhyama (Average), and Avara (Feeble) coping ability."
        );

        // 8. Ahara Shakti (Digestive Power & Food Assimilation)
        String agni = mc.getAyushAgni() != null ? mc.getAyushAgni() : "Vishama Agni";
        String ahara = mc.getDashavidhaAharaShakti() != null && !mc.getDashavidhaAharaShakti().isBlank()
                ? mc.getDashavidhaAharaShakti()
                : "Abhyavaharana Shakti: Normal; Jarana Shakti: Impaired (" + agni + " - Irregular digestion)";
        matrix.addDimension(
                "AHARA_SHAKTI",
                "आहार शक्ति (Ahara Shakti)",
                "Digestive Intake (Abhyavaharana) & Metabolic (Jarana) Power",
                ahara,
                "Direct index of Jatharagni efficiency and capacity to metabolize oral medications."
        );

        // 9. Vyayama Shakti (Physical Endurance / Capacity for Work)
        String vyayama = mc.getDashavidhaVyayamaShakti() != null && !mc.getDashavidhaVyayamaShakti().isBlank()
                ? mc.getDashavidhaVyayamaShakti()
                : "Madhyama Vyayama Shakti (Tolerates routine walking; breathlessness on strenuous exertion)";
        matrix.addDimension(
                "VYAYAMA_SHAKTI",
                "व्यायाम शक्ति (Vyayama Shakti)",
                "Physical Endurance & Cardiorespiratory Reserve",
                vyayama,
                "Determines appropriate lifestyle recommendations and exertion limits."
        );

        // 10. Vaya (Age Stage & Lifecycle Vulnerability)
        int effectiveAge = 42;
        if (mc.getPatient() != null && mc.getPatient().getAge() != null) {
            effectiveAge = mc.getPatient().getAge();
        }
        String vaya = mc.getDashavidhaVaya() != null && !mc.getDashavidhaVaya().isBlank()
                ? mc.getDashavidhaVaya()
                : (effectiveAge < 16 ? "Bala Vaya (Childhood - Kapha predominant)"
                : (effectiveAge > 60 ? "Vriddha Vaya (Geriatric - Vata predominant)"
                : "Madhyama Vaya (Adulthood - Pitta predominant, " + effectiveAge + " yrs)"));
        matrix.addDimension(
                "VAYA",
                "वय (Vaya)",
                "Age Classification & Biological Phase",
                vaya,
                "Correlates chronological age with doshic dominance and therapeutic dosage thresholds."
        );

        return matrix;
    }
}
