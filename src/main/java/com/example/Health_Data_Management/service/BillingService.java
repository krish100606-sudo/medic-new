package com.example.Health_Data_Management.service;

import com.example.Health_Data_Management.entity.Admission;
import com.example.Health_Data_Management.entity.Billing;
import com.example.Health_Data_Management.entity.Patient;
import com.example.Health_Data_Management.repository.AdmissionRepository;
import com.example.Health_Data_Management.repository.BillingRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class BillingService {

    private final BillingRepository billingRepository;
    private final PatientRepository patientRepository;
    private final AdmissionRepository admissionRepository;

    public BillingService(BillingRepository billingRepository, PatientRepository patientRepository, AdmissionRepository admissionRepository) {
        this.billingRepository = billingRepository;
        this.patientRepository = patientRepository;
        this.admissionRepository = admissionRepository;
    }

    public Billing createBill(Long patientId, Long admissionId, Double amount) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        
        Admission admission = null;
        if (admissionId != null) {
            admission = admissionRepository.findById(admissionId)
                    .orElseThrow(() -> new RuntimeException("Admission not found"));
        }

        Billing billing = new Billing();
        billing.setPatient(patient);
        billing.setAdmission(admission);
        billing.setAmount(amount);
        return billingRepository.save(billing);
    }

    public Billing payBill(Long billingId) {
        Billing billing = billingRepository.findById(billingId)
                .orElseThrow(() -> new RuntimeException("Bill not found"));
        
        billing.setStatus("PAID");
        billing.setPaidDate(LocalDateTime.now());
        return billingRepository.save(billing);
    }

    public List<Billing> getAllBills() {
        return billingRepository.findAll();
    }
}
