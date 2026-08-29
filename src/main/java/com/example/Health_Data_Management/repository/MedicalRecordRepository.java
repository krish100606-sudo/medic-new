package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.CaseStatus;
import com.example.Health_Data_Management.entity.MedicalRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MedicalRecordRepository
        extends JpaRepository<MedicalRecord, Long> {

    // Find a case using its case number
    Optional<MedicalRecord> findByCaseNumber(String caseNumber);

    // Check whether a case number already exists
    boolean existsByCaseNumber(String caseNumber);

    // Find all medical records of a patient
    List<MedicalRecord> findByPatientId(Long patientId);

    // Find all cases assigned to a doctor
    List<MedicalRecord> findByDoctorId(Long doctorId);

    // Find all cases handled by a nurse
    List<MedicalRecord> findByNurseId(Long nurseId);

    // Find cases by status
    List<MedicalRecord> findByStatus(CaseStatus status);

    // Find cases of a patient with a particular status
    List<MedicalRecord> findByPatientIdAndStatus(
            Long patientId,
            CaseStatus status
    );

    // Find cases assigned to a doctor with a particular status
    List<MedicalRecord> findByDoctorIdAndStatus(
            Long doctorId,
            CaseStatus status
    );
}
