package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.*;
import com.example.Health_Data_Management.repository.CaseAnswerRepository;
import com.example.Health_Data_Management.repository.MedicalCaseRepository;
import com.example.Health_Data_Management.repository.MedicalDocumentRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class CaseService {

    private final MedicalCaseRepository caseRepository;
    private final CaseAnswerRepository answerRepository;
    private final MedicalDocumentRepository documentRepository;
    private final RedFlagService redFlagService;
    private final SummaryService summaryService;
    private final OCRService ocrService;

    public CaseService(
            MedicalCaseRepository caseRepository,
            CaseAnswerRepository answerRepository,
            MedicalDocumentRepository documentRepository,
            RedFlagService redFlagService,
            SummaryService summaryService,
            OCRService ocrService) {
        this.caseRepository = caseRepository;
        this.answerRepository = answerRepository;
        this.documentRepository = documentRepository;
        this.redFlagService = redFlagService;
        this.summaryService = summaryService;
        this.ocrService = ocrService;
    }

    @Transactional
    public MedicalCase getOrCreateDraftCase(Patient patient) {
        Optional<MedicalCase> existingDraft = caseRepository.findFirstByPatientIdAndStatusOrderByCreatedAtDesc(
                patient.getId(), CaseStatus.DRAFT);
        if (existingDraft.isPresent()) {
            return existingDraft.get();
        }

        MedicalCase newCase = new MedicalCase(patient);
        String uniqueNum = String.format("MK-%d-%04d", System.currentTimeMillis() % 1000000, (int)(Math.random() * 9000 + 1000));
        newCase.setCaseNumber(uniqueNum);
        return caseRepository.save(newCase);
    }

    @Transactional
    public CaseAnswer saveOrUpdateAnswer(Long caseId, String questionCode, String questionText, String answerText, InputType inputType) {
        MedicalCase medicalCase = caseRepository.findById(caseId)
                .orElseThrow(() -> new RuntimeException("Case not found: " + caseId));

        Optional<CaseAnswer> existingAnswer = answerRepository.findByMedicalCaseIdAndQuestionCode(caseId, questionCode);
        CaseAnswer answer;
        if (existingAnswer.isPresent()) {
            answer = existingAnswer.get();
            answer.setAnswerText(answerText);
            answer.setInputType(inputType != null ? inputType : InputType.TEXT);
        } else {
            answer = new CaseAnswer(medicalCase, questionCode, questionText, answerText, inputType);
        }

        CaseAnswer saved = answerRepository.save(answer);

        // Map answer to specific case fields
        mapAnswerToCaseField(medicalCase, questionCode, answerText);
        caseRepository.save(medicalCase);

        return saved;
    }

    private void mapAnswerToCaseField(MedicalCase c, String code, String text) {
        if (text == null) return;
        switch (code) {
            case "Q_CHIEF_COMPLAINT" -> c.setChiefComplaint(text);
            case "Q_STATEMENT" -> c.setPatientStatement(text);
            case "Q_ONSET" -> c.setOnset(text);
            case "Q_LOCATION" -> c.setLocation(text);
            case "Q_SEVERITY" -> c.setSeverity(text);
            case "Q_ASSOCIATED_SYMPTOMS" -> c.setAssociatedSymptoms(text);
            case "Q_PAST_DISEASES" -> c.setPastMedicalHistory(text);
            case "Q_SURGERIES" -> c.setSurgicalHistory(text);
            case "Q_MEDICATIONS" -> c.setCurrentMedication(text);
            case "Q_ALLERGIES" -> c.setAllergies(text);
            case "Q_FAMILY_HISTORY" -> c.setFamilyHistory(text);
            case "Q_PERSONAL_HISTORY" -> c.setPersonalHistory(text);
            case "Q_INVESTIGATIONS" -> c.setInvestigations(text);
        }
    }

    @Transactional
    public MedicalDocument addAndProcessDocument(Long caseId, Long patientId, String filename, String originalFilename, String fileType, DocumentType docType) {
        MedicalCase medicalCase = caseRepository.findById(caseId).orElse(null);
        Patient patient = medicalCase != null ? medicalCase.getPatient() : null;

        MedicalDocument doc = new MedicalDocument(patient, medicalCase, filename, originalFilename, fileType, docType);
        ocrService.applyOcrToDocument(doc);
        return documentRepository.save(doc);
    }

    @Transactional
    public MedicalCase generateSummaryAndEvaluateRedFlags(Long caseId) {
        MedicalCase medicalCase = caseRepository.findById(caseId)
                .orElseThrow(() -> new RuntimeException("Case not found: " + caseId));

        List<MedicalDocument> docs = documentRepository.findByMedicalCaseId(caseId);

        // Evaluate deterministic red-flags
        RedFlagService.RedFlagEvaluation evaluation = redFlagService.evaluate(medicalCase);
        medicalCase.setPriority(evaluation.getPriority());
        medicalCase.setRedFlagsDetected(evaluation.isRedFlagsDetected());
        medicalCase.setPriorityReason(evaluation.getReason());

        // Generate structured summary & timeline
        String structuredSummary = summaryService.generateStructuredSummary(medicalCase, docs);
        String timeline = summaryService.generateMedicalTimeline(medicalCase, docs);

        medicalCase.setStructuredSummary(structuredSummary);
        medicalCase.setMedicalTimeline(timeline);

        return caseRepository.save(medicalCase);
    }

    @Transactional
    public MedicalCase submitCase(Long caseId) {
        MedicalCase medicalCase = generateSummaryAndEvaluateRedFlags(caseId);

        if (medicalCase.getTokenNumber() == null) {
            Integer maxToken = caseRepository.findMaxTokenNumber();
            medicalCase.setTokenNumber(maxToken != null ? maxToken + 1 : 104);
        }

        medicalCase.setStatus(CaseStatus.SUBMITTED);
        medicalCase.setSubmittedAt(LocalDateTime.now());
        return caseRepository.save(medicalCase);
    }

    @Transactional
    public MedicalCase doctorReviewCase(Long caseId, Doctor doctor) {
        MedicalCase medicalCase = caseRepository.findById(caseId)
                .orElseThrow(() -> new RuntimeException("Case not found: " + caseId));

        if (medicalCase.getStatus() == CaseStatus.SUBMITTED) {
            medicalCase.setStatus(CaseStatus.UNDER_REVIEW);
        }
        if (doctor != null && medicalCase.getDoctor() == null) {
            medicalCase.setDoctor(doctor);
        }
        return caseRepository.save(medicalCase);
    }

    @Transactional
    public MedicalCase doctorEditCase(Long caseId, String chiefComplaint, String history, String pastHistory,
                                       String medications, String allergies, String investigations,
                                       String doctorNotes, CasePriority priority) {
        MedicalCase medicalCase = caseRepository.findById(caseId)
                .orElseThrow(() -> new RuntimeException("Case not found: " + caseId));

        if (chiefComplaint != null) medicalCase.setChiefComplaint(chiefComplaint);
        if (history != null) medicalCase.setPatientStatement(history);
        if (pastHistory != null) medicalCase.setPastMedicalHistory(pastHistory);
        if (medications != null) medicalCase.setCurrentMedication(medications);
        if (allergies != null) medicalCase.setAllergies(allergies);
        if (investigations != null) medicalCase.setInvestigations(investigations);
        if (doctorNotes != null) medicalCase.setDoctorClinicalNotes(doctorNotes);
        if (priority != null) medicalCase.setPriority(priority);

        medicalCase.setDoctorEdited(true);

        List<MedicalDocument> docs = documentRepository.findByMedicalCaseId(caseId);
        medicalCase.setStructuredSummary(summaryService.generateStructuredSummary(medicalCase, docs));

        return caseRepository.save(medicalCase);
    }

    @Transactional
    public MedicalCase doctorVerifyCase(Long caseId, String doctorName, String doctorNotes) {
        MedicalCase medicalCase = caseRepository.findById(caseId)
                .orElseThrow(() -> new RuntimeException("Case not found: " + caseId));

        medicalCase.setStatus(CaseStatus.VERIFIED);
        medicalCase.setVerifiedByDoctor(doctorName != null ? doctorName : "Dr. Ananya Roy, MD");
        medicalCase.setVerifiedAt(LocalDateTime.now());
        if (doctorNotes != null && !doctorNotes.isBlank()) {
            medicalCase.setDoctorClinicalNotes(doctorNotes);
        }

        return caseRepository.save(medicalCase);
    }

    public MedicalCase getCaseById(Long id) {
        return caseRepository.findById(id).orElse(null);
    }

    public List<MedicalCase> getCasesForPatient(Long patientId) {
        return caseRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
    }

    public List<MedicalCase> getAllCasesForQueue(String keyword, String priorityFilter, String statusFilter) {
        List<MedicalCase> list;
        if (keyword != null && !keyword.trim().isEmpty()) {
            list = caseRepository.searchCases(keyword.trim());
        } else {
            list = caseRepository.findAll();
        }

        return list.stream()
                .filter(c -> c.getStatus() != CaseStatus.DRAFT)
                .filter(c -> {
                    if (priorityFilter == null || priorityFilter.isEmpty() || "ALL".equalsIgnoreCase(priorityFilter)) {
                        return true;
                    }
                    return c.getPriority().name().equalsIgnoreCase(priorityFilter);
                })
                .filter(c -> {
                    if (statusFilter == null || statusFilter.isEmpty() || "ALL".equalsIgnoreCase(statusFilter)) {
                        return true;
                    }
                    return c.getStatus().name().equalsIgnoreCase(statusFilter);
                })
                .sorted((a, b) -> {
                    // Sort by priority (CRITICAL/HIGH first) then token number
                    int prioCompare = Integer.compare(getPrioRank(b.getPriority()), getPrioRank(a.getPriority()));
                    if (prioCompare != 0) return prioCompare;
                    Integer tokA = a.getTokenNumber() != null ? a.getTokenNumber() : Integer.valueOf(999999);
                    Integer tokB = b.getTokenNumber() != null ? b.getTokenNumber() : Integer.valueOf(999999);
                    return tokA.compareTo(tokB);
                })
                .toList();
    }

    private int getPrioRank(CasePriority p) {
        if (p == CasePriority.CRITICAL) return 3;
        if (p == CasePriority.HIGH) return 2;
        return 1;
    }

    public long getCountByStatus(CaseStatus status) {
        return caseRepository.countByStatus(status);
    }

    public long getCountByPriority(CasePriority priority) {
        return caseRepository.countByPriority(priority);
    }
}
