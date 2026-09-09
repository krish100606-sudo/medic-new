package com.example.Health_Data_Management.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "medical_cases")
public class MedicalCase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "case_number", unique = true, nullable = false, length = 50)
    private String caseNumber;

    @Column(name = "token_number")
    private Integer tokenNumber;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "doctor_id")
    private Doctor doctor;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private CaseStatus status = CaseStatus.DRAFT;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private CasePriority priority = CasePriority.NORMAL;

    @Column(name = "priority_reason", length = 1000)
    private String priorityReason;

    @Column(name = "red_flags_detected")
    private Boolean redFlagsDetected = false;

    @Column(name = "red_flags_details", length = 2000)
    private String redFlagsDetails;

    // ---------------- Clinical Intake Fields ----------------
    @Column(name = "chief_complaint", length = 1000)
    private String chiefComplaint;

    @Column(name = "patient_statement", length = 2000)
    private String patientStatement;

    @Column(length = 255)
    private String onset;

    @Column(length = 255)
    private String location;

    @Column(length = 255)
    private String severity;

    @Column(name = "associated_symptoms", length = 2000)
    private String associatedSymptoms;

    @Column(name = "past_medical_history", length = 3000)
    private String pastMedicalHistory;

    @Column(name = "surgical_history", length = 2000)
    private String surgicalHistory;

    @Column(name = "current_medication", length = 3000)
    private String currentMedication;

    @Column(length = 1000)
    private String allergies;

    @Column(name = "family_history", length = 2000)
    private String familyHistory;

    @Column(name = "personal_history", length = 2000)
    private String personalHistory;

    @Column(length = 3000)
    private String investigations;

    @Column(name = "medical_timeline", length = 4000)
    private String medicalTimeline;

    @Column(name = "structured_summary", length = 6000)
    private String structuredSummary;

    // ---------------- SOCRATES Framework Fields ----------------
    @Column(name = "socrates_character", length = 500)
    private String socratesCharacter;

    @Column(name = "socrates_radiation", length = 500)
    private String socratesRadiation;

    @Column(name = "socrates_timing", length = 500)
    private String socratesTiming;

    @Column(name = "socrates_exacerbating_relieving", length = 1000)
    private String socratesExacerbatingRelieving;

    // ---------------- AYUSH Intake Fields ----------------
    @Column(name = "ayush_prakriti", length = 255)
    private String ayushPrakriti;

    @Column(name = "ayush_agni", length = 255)
    private String ayushAgni;

    @Column(name = "ayush_nidra", length = 255)
    private String ayushNidra;

    @Column(name = "ayush_koshtha", length = 255)
    private String ayushKoshtha;

    // ---------------- AI Conversational Intake History ----------------
    @Column(name = "conversational_history", length = 10000)
    private String conversationalHistory;

    // ---------------- AYUSH Dashavidha Pariksha (10-Fold Assessment) ----------------
    @Column(name = "dashavidha_vikriti", length = 500)
    private String dashavidhaVikriti;

    @Column(name = "dashavidha_sara", length = 500)
    private String dashavidhaSara;

    @Column(name = "dashavidha_samhanana", length = 255)
    private String dashavidhaSamhanana;

    @Column(name = "dashavidha_pramana", length = 255)
    private String dashavidhaPramana;

    @Column(name = "dashavidha_satmya", length = 500)
    private String dashavidhaSatmya;

    @Column(name = "dashavidha_satva", length = 255)
    private String dashavidhaSatva;

    @Column(name = "dashavidha_ahara_shakti", length = 500)
    private String dashavidhaAharaShakti;

    @Column(name = "dashavidha_vyayama_shakti", length = 255)
    private String dashavidhaVyayamaShakti;

    @Column(name = "dashavidha_vaya", length = 255)
    private String dashavidhaVaya;

    // ---------------- Clinical Drug-Drug Interaction (DDI) Detection ----------------
    @Column(name = "drug_interactions_detected")
    private Boolean drugInteractionsDetected = false;

    @Column(name = "drug_interactions_json", length = 4000)
    private String drugInteractionsJson;

    // ---------------- Emergency Interception & Triage ----------------
    @Column(name = "emergency_intercept_triggered")
    private Boolean emergencyInterceptTriggered = false;

    @Column(name = "emergency_escalated_at")
    private LocalDateTime emergencyEscalatedAt;

    // ---------------- Doctor Verification & Rejection Fields ----------------
    @Column(name = "is_doctor_edited")
    private Boolean isDoctorEdited = false;

    @Column(name = "doctor_clinical_notes", length = 5000)
    private String doctorClinicalNotes;

    @Column(name = "verified_by_doctor", length = 150)
    private String verifiedByDoctor;

    @Column(name = "verified_at")
    private LocalDateTime verifiedAt;

    @Column(name = "is_rejected")
    private Boolean isRejected = false;

    @Column(name = "rejected_by_doctor", length = 150)
    private String rejectedByDoctor;

    @Column(name = "rejection_reason", length = 2000)
    private String rejectionReason;

    @Column(name = "rejected_at")
    private LocalDateTime rejectedAt;

    @Column(name = "submitted_at")
    private LocalDateTime submittedAt;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "medicalCase", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CaseAnswer> answers = new ArrayList<>();

    @OneToMany(mappedBy = "medicalCase", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MedicalDocument> documents = new ArrayList<>();

    public MedicalCase() {
    }

    public MedicalCase(Patient patient) {
        this.patient = patient;
        this.status = CaseStatus.DRAFT;
        this.priority = CasePriority.NORMAL;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (caseNumber == null) {
            caseNumber = "CASE-" + System.currentTimeMillis() % 1000000;
        }
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCaseNumber() {
        return caseNumber;
    }

    public void setCaseNumber(String caseNumber) {
        this.caseNumber = caseNumber;
    }

    public Integer getTokenNumber() {
        return tokenNumber;
    }

    public void setTokenNumber(Integer tokenNumber) {
        this.tokenNumber = tokenNumber;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }

    public CaseStatus getStatus() {
        return status;
    }

    public void setStatus(CaseStatus status) {
        this.status = status;
    }

    public CasePriority getPriority() {
        return priority;
    }

    public void setPriority(CasePriority priority) {
        this.priority = priority;
    }

    public String getPriorityReason() {
        return priorityReason;
    }

    public void setPriorityReason(String priorityReason) {
        this.priorityReason = priorityReason;
    }

    public boolean isRedFlagsDetected() {
        return Boolean.TRUE.equals(redFlagsDetected);
    }

    public void setRedFlagsDetected(Boolean redFlagsDetected) {
        this.redFlagsDetected = Boolean.TRUE.equals(redFlagsDetected);
    }

    public String getRedFlagsDetails() {
        return redFlagsDetails;
    }

    public void setRedFlagsDetails(String redFlagsDetails) {
        this.redFlagsDetails = redFlagsDetails;
    }

    public String getChiefComplaint() {
        return chiefComplaint;
    }

    public void setChiefComplaint(String chiefComplaint) {
        this.chiefComplaint = chiefComplaint;
    }

    public String getPatientStatement() {
        return patientStatement;
    }

    public void setPatientStatement(String patientStatement) {
        this.patientStatement = patientStatement;
    }

    public String getOnset() {
        return onset;
    }

    public void setOnset(String onset) {
        this.onset = onset;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getAssociatedSymptoms() {
        return associatedSymptoms;
    }

    public void setAssociatedSymptoms(String associatedSymptoms) {
        this.associatedSymptoms = associatedSymptoms;
    }

    public String getPastMedicalHistory() {
        return pastMedicalHistory;
    }

    public void setPastMedicalHistory(String pastMedicalHistory) {
        this.pastMedicalHistory = pastMedicalHistory;
    }

    public String getSurgicalHistory() {
        return surgicalHistory;
    }

    public void setSurgicalHistory(String surgicalHistory) {
        this.surgicalHistory = surgicalHistory;
    }

    public String getCurrentMedication() {
        return currentMedication;
    }

    public void setCurrentMedication(String currentMedication) {
        this.currentMedication = currentMedication;
    }

    public String getAllergies() {
        return allergies;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }

    public String getFamilyHistory() {
        return familyHistory;
    }

    public void setFamilyHistory(String familyHistory) {
        this.familyHistory = familyHistory;
    }

    public String getPersonalHistory() {
        return personalHistory;
    }

    public void setPersonalHistory(String personalHistory) {
        this.personalHistory = personalHistory;
    }

    public String getInvestigations() {
        return investigations;
    }

    public void setInvestigations(String investigations) {
        this.investigations = investigations;
    }

    public String getMedicalTimeline() {
        return medicalTimeline;
    }

    public void setMedicalTimeline(String medicalTimeline) {
        this.medicalTimeline = medicalTimeline;
    }

    public String getStructuredSummary() {
        return structuredSummary;
    }

    public void setStructuredSummary(String structuredSummary) {
        this.structuredSummary = structuredSummary;
    }

    public boolean isDoctorEdited() {
        return Boolean.TRUE.equals(isDoctorEdited);
    }

    public void setDoctorEdited(Boolean doctorEdited) {
        this.isDoctorEdited = Boolean.TRUE.equals(doctorEdited);
    }

    public String getDoctorClinicalNotes() {
        return doctorClinicalNotes;
    }

    public void setDoctorClinicalNotes(String doctorClinicalNotes) {
        this.doctorClinicalNotes = doctorClinicalNotes;
    }

    public String getVerifiedByDoctor() {
        return verifiedByDoctor;
    }

    public void setVerifiedByDoctor(String verifiedByDoctor) {
        this.verifiedByDoctor = verifiedByDoctor;
    }

    public LocalDateTime getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(LocalDateTime verifiedAt) {
        this.verifiedAt = verifiedAt;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public String getSocratesCharacter() { return socratesCharacter; }
    public void setSocratesCharacter(String socratesCharacter) { this.socratesCharacter = socratesCharacter; }

    public String getSocratesRadiation() { return socratesRadiation; }
    public void setSocratesRadiation(String socratesRadiation) { this.socratesRadiation = socratesRadiation; }

    public String getSocratesTiming() { return socratesTiming; }
    public void setSocratesTiming(String socratesTiming) { this.socratesTiming = socratesTiming; }

    public String getSocratesExacerbatingRelieving() { return socratesExacerbatingRelieving; }
    public void setSocratesExacerbatingRelieving(String socratesExacerbatingRelieving) { this.socratesExacerbatingRelieving = socratesExacerbatingRelieving; }

    public String getAyushPrakriti() { return ayushPrakriti; }
    public void setAyushPrakriti(String ayushPrakriti) { this.ayushPrakriti = ayushPrakriti; }

    public String getAyushAgni() { return ayushAgni; }
    public void setAyushAgni(String ayushAgni) { this.ayushAgni = ayushAgni; }

    public String getAyushNidra() { return ayushNidra; }
    public void setAyushNidra(String ayushNidra) { this.ayushNidra = ayushNidra; }

    public String getAyushKoshtha() { return ayushKoshtha; }
    public void setAyushKoshtha(String ayushKoshtha) { this.ayushKoshtha = ayushKoshtha; }

    public String getConversationalHistory() { return conversationalHistory; }
    public void setConversationalHistory(String conversationalHistory) { this.conversationalHistory = conversationalHistory; }

    public String getDashavidhaVikriti() { return dashavidhaVikriti; }
    public void setDashavidhaVikriti(String dashavidhaVikriti) { this.dashavidhaVikriti = dashavidhaVikriti; }

    public String getDashavidhaSara() { return dashavidhaSara; }
    public void setDashavidhaSara(String dashavidhaSara) { this.dashavidhaSara = dashavidhaSara; }

    public String getDashavidhaSamhanana() { return dashavidhaSamhanana; }
    public void setDashavidhaSamhanana(String dashavidhaSamhanana) { this.dashavidhaSamhanana = dashavidhaSamhanana; }

    public String getDashavidhaPramana() { return dashavidhaPramana; }
    public void setDashavidhaPramana(String dashavidhaPramana) { this.dashavidhaPramana = dashavidhaPramana; }

    public String getDashavidhaSatmya() { return dashavidhaSatmya; }
    public void setDashavidhaSatmya(String dashavidhaSatmya) { this.dashavidhaSatmya = dashavidhaSatmya; }

    public String getDashavidhaSatva() { return dashavidhaSatva; }
    public void setDashavidhaSatva(String dashavidhaSatva) { this.dashavidhaSatva = dashavidhaSatva; }

    public String getDashavidhaAharaShakti() { return dashavidhaAharaShakti; }
    public void setDashavidhaAharaShakti(String dashavidhaAharaShakti) { this.dashavidhaAharaShakti = dashavidhaAharaShakti; }

    public String getDashavidhaVyayamaShakti() { return dashavidhaVyayamaShakti; }
    public void setDashavidhaVyayamaShakti(String dashavidhaVyayamaShakti) { this.dashavidhaVyayamaShakti = dashavidhaVyayamaShakti; }

    public String getDashavidhaVaya() { return dashavidhaVaya; }
    public void setDashavidhaVaya(String dashavidhaVaya) { this.dashavidhaVaya = dashavidhaVaya; }

    public Boolean getDrugInteractionsDetected() { return drugInteractionsDetected; }
    public void setDrugInteractionsDetected(Boolean drugInteractionsDetected) { this.drugInteractionsDetected = drugInteractionsDetected; }

    public String getDrugInteractionsJson() { return drugInteractionsJson; }
    public void setDrugInteractionsJson(String drugInteractionsJson) { this.drugInteractionsJson = drugInteractionsJson; }

    public boolean isEmergencyInterceptTriggered() {
        return Boolean.TRUE.equals(emergencyInterceptTriggered);
    }

    public void setEmergencyInterceptTriggered(Boolean emergencyInterceptTriggered) {
        this.emergencyInterceptTriggered = Boolean.TRUE.equals(emergencyInterceptTriggered);
    }

    public LocalDateTime getEmergencyEscalatedAt() { return emergencyEscalatedAt; }
    public void setEmergencyEscalatedAt(LocalDateTime emergencyEscalatedAt) { this.emergencyEscalatedAt = emergencyEscalatedAt; }

    public boolean isRejected() {
        return Boolean.TRUE.equals(isRejected);
    }

    public void setRejected(Boolean rejected) {
        this.isRejected = Boolean.TRUE.equals(rejected);
    }

    public String getRejectedByDoctor() { return rejectedByDoctor; }
    public void setRejectedByDoctor(String rejectedByDoctor) { this.rejectedByDoctor = rejectedByDoctor; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public LocalDateTime getRejectedAt() { return rejectedAt; }
    public void setRejectedAt(LocalDateTime rejectedAt) { this.rejectedAt = rejectedAt; }

    public List<CaseAnswer> getAnswers() {
        return answers;
    }

    public void setAnswers(List<CaseAnswer> answers) {
        this.answers = answers;
    }

    public List<MedicalDocument> getDocuments() {
        return documents;
    }

    public void setDocuments(List<MedicalDocument> documents) {
        this.documents = documents;
    }
}
