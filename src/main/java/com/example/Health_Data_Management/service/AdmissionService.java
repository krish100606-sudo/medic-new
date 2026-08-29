package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.Admission;
import com.example.Health_Data_Management.entity.Doctor;
import com.example.Health_Data_Management.entity.Patient;
import com.example.Health_Data_Management.repository.AdmissionRepository;
import com.example.Health_Data_Management.repository.DoctorRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AdmissionService {

    private final AdmissionRepository admissionRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;

    public AdmissionService(AdmissionRepository admissionRepository, PatientRepository patientRepository, DoctorRepository doctorRepository) {
        this.admissionRepository = admissionRepository;
        this.patientRepository = patientRepository;
        this.doctorRepository = doctorRepository;
    }

    public Admission admitPatient(Long patientId, String roomNumber, String admissionType, String reason, String condition, String dietary, Long doctorId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        
        Doctor doctor = null;
        if (doctorId != null) {
            doctor = doctorRepository.findById(doctorId).orElse(null);
        }
        
        Admission admission = new Admission();
        admission.setPatient(patient);
        admission.setRoomNumber(roomNumber);
        admission.setAdmissionType(admissionType);
        admission.setReasonForAdmission(reason);
        admission.setConditionUponAdmission(condition);
        admission.setDietaryRequirements(dietary);
        admission.setAttendingDoctor(doctor);
        
        return admissionRepository.save(admission);
    }

    public Admission dischargePatient(Long admissionId) {
        Admission admission = admissionRepository.findById(admissionId)
                .orElseThrow(() -> new RuntimeException("Admission not found"));
        
        admission.setStatus("DISCHARGED");
        admission.setDischargeDate(LocalDateTime.now());
        return admissionRepository.save(admission);
    }

    public List<Admission> getAllAdmissions() {
        return admissionRepository.findAll();
    }
    
    public List<Admission> getActiveAdmissions() {
        return admissionRepository.findByStatus("ADMITTED");
    }

    public Optional<Admission> getAdmissionById(Long id) {
        return admissionRepository.findById(id);
    }
}
