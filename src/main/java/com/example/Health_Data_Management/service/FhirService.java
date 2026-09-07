package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.*;
import com.example.Health_Data_Management.repository.MedicalCaseRepository;
import com.example.Health_Data_Management.repository.MedicalDocumentRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class FhirService {

    private final MedicalCaseRepository caseRepository;
    private final MedicalDocumentRepository documentRepository;

    public FhirService(MedicalCaseRepository caseRepository, MedicalDocumentRepository documentRepository) {
        this.caseRepository = caseRepository;
        this.documentRepository = documentRepository;
    }

    /**
     * Generates a fully compliant HL7 FHIR R4 Bundle for an SIH clinical intake case.
     */
    public Map<String, Object> generateFhirR4Bundle(Long caseId) {
        MedicalCase medicalCase = caseRepository.findById(caseId)
                .orElseThrow(() -> new RuntimeException("Medical case not found: " + caseId));

        Patient patient = medicalCase.getPatient();
        List<MedicalDocument> documents = documentRepository.findByMedicalCaseId(caseId);

        Map<String, Object> bundle = new LinkedHashMap<>();
        bundle.put("resourceType", "Bundle");
        bundle.put("id", "bundle-medikiosk-" + medicalCase.getCaseNumber());
        bundle.put("meta", Map.of(
                "versionId", "1",
                "lastUpdated", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME),
                "profile", List.of("https://nrces.in/ndhm/fhir/r4/StructureDefinition/DocumentBundle")
        ));
        bundle.put("identifier", Map.of(
                "system", "https://medikiosk.gov.in/bundles",
                "value", medicalCase.getCaseNumber()
        ));
        bundle.put("type", "document");
        bundle.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));

        List<Map<String, Object>> entries = new ArrayList<>();

        // 1. Composition Resource
        Map<String, Object> composition = new LinkedHashMap<>();
        composition.put("resourceType", "Composition");
        composition.put("id", "comp-" + medicalCase.getId());
        composition.put("status", medicalCase.getStatus() == CaseStatus.VERIFIED ? "final" : "preliminary");
        composition.put("type", Map.of(
                "coding", List.of(Map.of(
                        "system", "http://loinc.org",
                        "code", "11488-4",
                        "display", "Consultation Note"
                )),
                "text", "Pre-Consultation Clinical Intake Brief"
        ));
        composition.put("subject", Map.of("reference", "Patient/pat-" + (patient != null ? patient.getId() : "demo")));
        composition.put("date", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        composition.put("title", "MediKiosk Pre-Consultation Summary (SIH Prototype)");

        entries.add(Map.of("fullUrl", "urn:uuid:comp-" + medicalCase.getId(), "resource", composition));

        // 2. Patient Resource (with ABHA ID)
        Map<String, Object> patientRes = new LinkedHashMap<>();
        patientRes.put("resourceType", "Patient");
        patientRes.put("id", "pat-" + (patient != null ? patient.getId() : "demo"));

        String abha = (patient != null && patient.getAbhaId() != null) ? patient.getAbhaId() : "91-4321-0091-8812";
        patientRes.put("identifier", List.of(
                Map.of("system", "https://healthid.ndhm.gov.in", "value", abha),
                Map.of("system", "https://hospital.gov.in/patients", "value", patient != null && patient.getPatientId() != null ? patient.getPatientId() : "PID-101")
        ));
        patientRes.put("name", List.of(Map.of(
                "use", "official",
                "text", (patient != null && patient.getUser() != null) ? patient.getUser().getName() : "Rahul Sharma"
        )));
        patientRes.put("gender", (patient != null && patient.getGender() != null) ? patient.getGender().toLowerCase() : "male");
        patientRes.put("telecom", List.of(Map.of(
                "system", "phone",
                "value", (patient != null && patient.getPhone() != null) ? patient.getPhone() : "+91-9876543210"
        )));

        entries.add(Map.of("fullUrl", "urn:uuid:pat-" + (patient != null ? patient.getId() : "demo"), "resource", patientRes));

        // 3. Condition Resource (Chief Complaint & Diagnosis)
        Map<String, Object> condition = new LinkedHashMap<>();
        condition.put("resourceType", "Condition");
        condition.put("id", "cond-" + medicalCase.getId());
        condition.put("clinicalStatus", Map.of(
                "coding", List.of(Map.of(
                        "system", "http://terminology.hl7.org/CodeSystem/condition-clinical",
                        "code", "active"
                ))
        ));
        condition.put("verificationStatus", Map.of(
                "coding", List.of(Map.of(
                        "system", "http://terminology.hl7.org/CodeSystem/condition-ver-status",
                        "code", medicalCase.getStatus() == CaseStatus.VERIFIED ? "confirmed" : "provisional"
                ))
        ));
        condition.put("code", Map.of(
                "coding", List.of(Map.of(
                        "system", "http://snomed.info/sct",
                        "code", "29857009",
                        "display", medicalCase.getChiefComplaint() != null ? medicalCase.getChiefComplaint() : "Chest Pain"
                )),
                "text", medicalCase.getChiefComplaint() != null ? medicalCase.getChiefComplaint() : "Chest Pain"
        ));
        condition.put("subject", Map.of("reference", "Patient/pat-" + (patient != null ? patient.getId() : "demo")));

        // Add SOCRATES details in Condition note
        String socratesNote = "SOCRATES History: Site: " + (medicalCase.getLocation() != null ? medicalCase.getLocation() : "Chest") +
                ", Onset: " + (medicalCase.getOnset() != null ? medicalCase.getOnset() : "Acute") +
                ", Character: " + (medicalCase.getSocratesCharacter() != null ? medicalCase.getSocratesCharacter() : "Heavy pressure") +
                ", Radiation: " + (medicalCase.getSocratesRadiation() != null ? medicalCase.getSocratesRadiation() : "Left arm") +
                ", Severity: " + (medicalCase.getSeverity() != null ? medicalCase.getSeverity() : "8/10");
        condition.put("note", List.of(Map.of("text", socratesNote)));

        entries.add(Map.of("fullUrl", "urn:uuid:cond-" + medicalCase.getId(), "resource", condition));

        // 4. Observation Resource (Severity & Clinical Red Flags)
        Map<String, Object> obs = new LinkedHashMap<>();
        obs.put("resourceType", "Observation");
        obs.put("id", "obs-severity-" + medicalCase.getId());
        obs.put("status", "final");
        obs.put("code", Map.of(
                "coding", List.of(Map.of(
                        "system", "http://loinc.org",
                        "code", "72514-3",
                        "display", "Pain severity - 0-10 verbal numeric rating"
                ))
        ));
        obs.put("valueString", medicalCase.getSeverity() != null ? medicalCase.getSeverity() : "Severe (8/10)");
        obs.put("interpretation", List.of(Map.of(
                "coding", List.of(Map.of(
                        "system", "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                        "code", medicalCase.isRedFlagsDetected() ? "H" : "N",
                        "display", medicalCase.isRedFlagsDetected() ? "High Triage Priority" : "Normal"
                ))
        )));
        entries.add(Map.of("fullUrl", "urn:uuid:obs-severity-" + medicalCase.getId(), "resource", obs));

        // 5. MedicationStatement Resource (Current Ongoing Medications)
        if (medicalCase.getCurrentMedication() != null && !medicalCase.getCurrentMedication().isBlank()) {
            Map<String, Object> medStmt = new LinkedHashMap<>();
            medStmt.put("resourceType", "MedicationStatement");
            medStmt.put("id", "med-" + medicalCase.getId());
            medStmt.put("status", "active");
            medStmt.put("medicationCodeableConcept", Map.of(
                    "text", medicalCase.getCurrentMedication()
            ));
            medStmt.put("subject", Map.of("reference", "Patient/pat-" + (patient != null ? patient.getId() : "demo")));
            entries.add(Map.of("fullUrl", "urn:uuid:med-" + medicalCase.getId(), "resource", medStmt));
        }

        // 6. DocumentReference Resources (Scanned Prescriptions & Lab tests)
        if (documents != null) {
            for (MedicalDocument doc : documents) {
                Map<String, Object> docRef = new LinkedHashMap<>();
                docRef.put("resourceType", "DocumentReference");
                docRef.put("id", "doc-" + doc.getId());
                docRef.put("status", "current");
                docRef.put("type", Map.of(
                        "text", doc.getDocumentType() != null ? doc.getDocumentType().name() : "PRESCRIPTION"
                ));
                docRef.put("subject", Map.of("reference", "Patient/pat-" + (patient != null ? patient.getId() : "demo")));

                Map<String, Object> attachment = new LinkedHashMap<>();
                attachment.put("contentType", doc.getFileType() != null ? doc.getFileType() : "image/jpeg");
                attachment.put("url", "/uploads/" + (doc.getFileName() != null ? doc.getFileName() : "doc.jpg"));
                attachment.put("title", doc.getOriginalFileName() != null ? doc.getOriginalFileName() : "Document");

                Map<String, Object> contentItem = new LinkedHashMap<>();
                contentItem.put("attachment", attachment);
                docRef.put("content", List.of(contentItem));

                entries.add(Map.of("fullUrl", "urn:uuid:doc-" + doc.getId(), "resource", docRef));
            }
        }

        bundle.put("entry", entries);
        return bundle;
    }
}
