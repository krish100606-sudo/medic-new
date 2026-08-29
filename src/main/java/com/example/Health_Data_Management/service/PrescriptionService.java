package com.example.Health_Data_Management.service;



import com.example.Health_Data_Management.entity.Doctor;
import com.example.Health_Data_Management.entity.MedicalRecord;
import com.example.Health_Data_Management.entity.Patient;
import com.example.Health_Data_Management.entity.Prescription;
import com.example.Health_Data_Management.repository.DoctorRepository;
import com.example.Health_Data_Management.repository.MedicalRecordRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import com.example.Health_Data_Management.repository.PrescriptionRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class PrescriptionService {

    private final PrescriptionRepository prescriptionRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;
    private final MedicalRecordRepository medicalRecordRepository;

    public PrescriptionService(
            PrescriptionRepository prescriptionRepository,
            PatientRepository patientRepository,
            DoctorRepository doctorRepository,
            MedicalRecordRepository medicalRecordRepository) {

        this.prescriptionRepository = prescriptionRepository;
        this.patientRepository = patientRepository;
        this.doctorRepository = doctorRepository;
        this.medicalRecordRepository = medicalRecordRepository;
    }

    // ---------------------------------------------------------
    // CREATE PRESCRIPTION
    // ---------------------------------------------------------

    public Prescription createPrescription(
            Long patientId,
            Long doctorId,
            Long medicalRecordId,
            Prescription prescription) {

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() ->
                        new RuntimeException("Patient not found"));

        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() ->
                        new RuntimeException("Doctor not found"));

        MedicalRecord medicalRecord =
                medicalRecordRepository.findById(medicalRecordId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Medical record not found"));

        if (prescription.getMedicineName() == null ||
                prescription.getMedicineName().isBlank()) {

            throw new RuntimeException(
                    "Medicine name is required");
        }

        prescription.setPatient(patient);
        prescription.setDoctor(doctor);
        prescription.setMedicalRecord(medicalRecord);

        if (prescription.getPrescriptionDate() == null) {
            prescription.setPrescriptionDate(LocalDate.now());
        }

        return prescriptionRepository.save(prescription);
    }

    // ---------------------------------------------------------
    // GET PRESCRIPTION BY ID
    // ---------------------------------------------------------

    public Optional<Prescription> findById(Long id) {

        return prescriptionRepository.findById(id);
    }

    // ---------------------------------------------------------
    // GET ALL PRESCRIPTIONS
    // ---------------------------------------------------------

    public List<Prescription> getAllPrescriptions() {

        return prescriptionRepository.findAll();
    }

    // ---------------------------------------------------------
    // GET PATIENT PRESCRIPTIONS
    // ---------------------------------------------------------

    public List<Prescription> getPatientPrescriptions(
            Long patientId) {

        return prescriptionRepository
                .findByPatientId(patientId);
    }

    // ---------------------------------------------------------
    // GET DOCTOR PRESCRIPTIONS
    // ---------------------------------------------------------

    public List<Prescription> getDoctorPrescriptions(
            Long doctorId) {

        return prescriptionRepository
                .findByDoctorId(doctorId);
    }

    // ---------------------------------------------------------
    // GET MEDICAL RECORD PRESCRIPTIONS
    // ---------------------------------------------------------

    public List<Prescription> getMedicalRecordPrescriptions(
            Long medicalRecordId) {

        return prescriptionRepository
                .findByMedicalRecordId(medicalRecordId);
    }

    // ---------------------------------------------------------
    // GET PATIENT PRESCRIPTIONS BY DOCTOR
    // ---------------------------------------------------------

    public List<Prescription> getPatientPrescriptionsByDoctor(
            Long patientId,
            Long doctorId) {

        return prescriptionRepository
                .findByPatientIdAndDoctorId(
                        patientId,
                        doctorId
                );
    }

    // ---------------------------------------------------------
    // SEARCH BY MEDICINE
    // ---------------------------------------------------------

    public List<Prescription> searchByMedicine(
            String medicineName) {

        return prescriptionRepository
                .findByMedicineNameIgnoreCase(
                        medicineName
                );
    }

    // ---------------------------------------------------------
    // UPDATE PRESCRIPTION
    // ---------------------------------------------------------

    public Prescription updatePrescription(
            Long id,
            Prescription updatedPrescription) {

        Prescription prescription =
                prescriptionRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Prescription not found"));

        if (updatedPrescription.getMedicineName() != null &&
                !updatedPrescription.getMedicineName().isBlank()) {

            prescription.setMedicineName(
                    updatedPrescription.getMedicineName());
        }

        if (updatedPrescription.getDosage() != null) {

            prescription.setDosage(
                    updatedPrescription.getDosage());
        }

        if (updatedPrescription.getFrequency() != null) {

            prescription.setFrequency(
                    updatedPrescription.getFrequency());
        }

        if (updatedPrescription.getDuration() != null) {

            prescription.setDuration(
                    updatedPrescription.getDuration());
        }

        if (updatedPrescription.getInstructions() != null) {

            prescription.setInstructions(
                    updatedPrescription.getInstructions());
        }

        if (updatedPrescription.getPrescriptionDate() != null) {

            prescription.setPrescriptionDate(
                    updatedPrescription.getPrescriptionDate());
        }

        return prescriptionRepository.save(prescription);
    }

    // ---------------------------------------------------------
    // DELETE PRESCRIPTION
    // ---------------------------------------------------------

    public void deletePrescription(Long id) {

        if (!prescriptionRepository.existsById(id)) {

            throw new RuntimeException(
                    "Prescription not found");
        }

        prescriptionRepository.deleteById(id);
    }
}
