package com.example.Health_Data_Management.service;



import com.example.Health_Data_Management.entity.CaseStatus;
import com.example.Health_Data_Management.entity.Doctor;
import com.example.Health_Data_Management.entity.MedicalRecord;
import com.example.Health_Data_Management.entity.Nurse;
import com.example.Health_Data_Management.entity.Patient;
import com.example.Health_Data_Management.repository.DoctorRepository;
import com.example.Health_Data_Management.repository.MedicalRecordRepository;
import com.example.Health_Data_Management.repository.NurseRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class MedicalRecordService {

    private final MedicalRecordRepository medicalRecordRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;
    private final NurseRepository nurseRepository;

    public MedicalRecordService(
            MedicalRecordRepository medicalRecordRepository,
            PatientRepository patientRepository,
            DoctorRepository doctorRepository,
            NurseRepository nurseRepository) {

        this.medicalRecordRepository = medicalRecordRepository;
        this.patientRepository = patientRepository;
        this.doctorRepository = doctorRepository;
        this.nurseRepository = nurseRepository;
    }


    // ---------------------------------------------------------
    // CREATE MEDICAL CASE
    // ---------------------------------------------------------

    public MedicalRecord createRecord(Long patientId) {

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() ->
                        new RuntimeException("Patient not found")
                );

        MedicalRecord record = new MedicalRecord();

        record.setPatient(patient);

        record.setCaseNumber(generateCaseNumber());

        record.setStatus(CaseStatus.OPEN);

        return medicalRecordRepository.save(record);
    }


    // ---------------------------------------------------------
    // GENERATE CASE NUMBER
    // ---------------------------------------------------------

    private String generateCaseNumber() {

        String caseNumber;

        do {
            caseNumber = "CASE-" +
                    UUID.randomUUID()
                            .toString()
                            .substring(0, 8)
                            .toUpperCase();

        } while (
                medicalRecordRepository
                        .existsByCaseNumber(caseNumber)
        );

        return caseNumber;
    }


    // ---------------------------------------------------------
    // FIND RECORD BY ID
    // ---------------------------------------------------------

    public Optional<MedicalRecord> findById(Long id) {

        return medicalRecordRepository.findById(id);
    }


    // ---------------------------------------------------------
    // FIND RECORD BY CASE NUMBER
    // ---------------------------------------------------------

    public Optional<MedicalRecord> findByCaseNumber(
            String caseNumber) {

        return medicalRecordRepository
                .findByCaseNumber(caseNumber);
    }


    // ---------------------------------------------------------
    // GET ALL RECORDS
    // ---------------------------------------------------------

    public List<MedicalRecord> getAllRecords() {

        return medicalRecordRepository.findAll();
    }


    // ---------------------------------------------------------
    // GET PATIENT CASES
    // ---------------------------------------------------------

    public List<MedicalRecord> getPatientRecords(
            Long patientId) {

        return medicalRecordRepository
                .findByPatientId(patientId);
    }


    // ---------------------------------------------------------
    // ASSIGN DOCTOR
    // ---------------------------------------------------------

    public MedicalRecord assignDoctor(
            Long recordId,
            Long doctorId) {

        MedicalRecord record =
                medicalRecordRepository.findById(recordId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Medical record not found"
                                )
                        );

        Doctor doctor =
                doctorRepository.findById(doctorId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Doctor not found"
                                )
                        );

        record.setDoctor(doctor);

        record.setStatus(CaseStatus.UNDER_REVIEW);

        return medicalRecordRepository.save(record);
    }


    // ---------------------------------------------------------
    // ASSIGN NURSE
    // ---------------------------------------------------------

    public MedicalRecord assignNurse(
            Long recordId,
            Long nurseId) {

        MedicalRecord record =
                medicalRecordRepository.findById(recordId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Medical record not found"
                                )
                        );

        Nurse nurse =
                nurseRepository.findById(nurseId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Nurse not found"
                                )
                        );

        record.setNurse(nurse);

        return medicalRecordRepository.save(record);
    }


    // ---------------------------------------------------------
    // UPDATE CASE INFORMATION
    // ---------------------------------------------------------

    public MedicalRecord updateRecord(
            MedicalRecord updatedRecord) {

        MedicalRecord record =
                medicalRecordRepository.findById(
                        updatedRecord.getId()
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Medical record not found"
                        )
                );

        record.setChiefComplaint(
                updatedRecord.getChiefComplaint()
        );

        record.setSymptoms(
                updatedRecord.getSymptoms()
        );

        record.setDiagnosis(
                updatedRecord.getDiagnosis()
        );

        record.setTreatmentPlan(
                updatedRecord.getTreatmentPlan()
        );

        record.setMedications(
                updatedRecord.getMedications()
        );

        record.setAdditionalNotes(
                updatedRecord.getAdditionalNotes()
        );

        record.setTemperature(
                updatedRecord.getTemperature()
        );

        record.setBloodPressure(
                updatedRecord.getBloodPressure()
        );

        record.setHeartRate(
                updatedRecord.getHeartRate()
        );

        record.setRespiratoryRate(
                updatedRecord.getRespiratoryRate()
        );

        record.setOxygenSaturation(
                updatedRecord.getOxygenSaturation()
        );

        record.setWeight(
                updatedRecord.getWeight()
        );

        record.setHeight(
                updatedRecord.getHeight()
        );

        return medicalRecordRepository.save(record);
    }


    // ---------------------------------------------------------
    // UPDATE CASE STATUS
    // ---------------------------------------------------------

    public MedicalRecord updateStatus(
            Long recordId,
            CaseStatus status) {

        MedicalRecord record =
                medicalRecordRepository.findById(recordId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Medical record not found"
                                )
                        );

        record.setStatus(status);

        return medicalRecordRepository.save(record);
    }


    // ---------------------------------------------------------
    // GET DOCTOR CASES
    // ---------------------------------------------------------

    public List<MedicalRecord> getDoctorRecords(
            Long doctorId) {

        return medicalRecordRepository
                .findByDoctorId(doctorId);
    }


    // ---------------------------------------------------------
    // GET NURSE CASES
    // ---------------------------------------------------------

    public List<MedicalRecord> getNurseRecords(
            Long nurseId) {

        return medicalRecordRepository
                .findByNurseId(nurseId);
    }


    // ---------------------------------------------------------
    // GET CASES BY STATUS
    // ---------------------------------------------------------

    public List<MedicalRecord> getRecordsByStatus(
            CaseStatus status) {

        return medicalRecordRepository
                .findByStatus(status);
    }


    // ---------------------------------------------------------
    // DELETE MEDICAL RECORD
    // ---------------------------------------------------------

    public void deleteRecord(Long id) {

        if (!medicalRecordRepository.existsById(id)) {

            throw new RuntimeException(
                    "Medical record not found"
            );
        }

        medicalRecordRepository.deleteById(id);
    }
}