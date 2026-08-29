package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.Prescription;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PrescriptionRepository
        extends JpaRepository<Prescription, Long> {

    // Get all prescriptions of a patient
    List<Prescription> findByPatientId(Long patientId);

    // Get all prescriptions written by a doctor
    List<Prescription> findByDoctorId(Long doctorId);

    // Get prescriptions belonging to a medical record
    List<Prescription> findByMedicalRecordId(
            Long medicalRecordId
    );

    // Get prescriptions of a patient written by a particular doctor
    List<Prescription> findByPatientIdAndDoctorId(
            Long patientId,
            Long doctorId
    );

    // Search prescriptions by medicine name
    List<Prescription> findByMedicineNameIgnoreCase(
            String medicineName
    );
}