package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.Prescription;
import com.example.Health_Data_Management.service.PrescriptionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/prescriptions")
public class PrescriptionController {

    private final PrescriptionService prescriptionService;

    public PrescriptionController(
            PrescriptionService prescriptionService) {

        this.prescriptionService = prescriptionService;
    }

    // ---------------------------------------------------------
    // CREATE PRESCRIPTION
    // POST /api/prescriptions/patient/{patientId}/doctor/{doctorId}/record/{medicalRecordId}
    // ---------------------------------------------------------

    @PostMapping(
            "/patient/{patientId}/doctor/{doctorId}/record/{medicalRecordId}"
    )
    public ResponseEntity<Prescription> createPrescription(
            @PathVariable Long patientId,
            @PathVariable Long doctorId,
            @PathVariable Long medicalRecordId,
            @RequestBody Prescription prescription) {

        return ResponseEntity.ok(
                prescriptionService.createPrescription(
                        patientId,
                        doctorId,
                        medicalRecordId,
                        prescription
                )
        );
    }

    // ---------------------------------------------------------
    // GET ALL PRESCRIPTIONS
    // GET /api/prescriptions
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<Prescription>>
    getAllPrescriptions() {

        return ResponseEntity.ok(
                prescriptionService.getAllPrescriptions()
        );
    }

    // ---------------------------------------------------------
    // GET PRESCRIPTION BY ID
    // GET /api/prescriptions/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<Prescription> getPrescription(
            @PathVariable Long id) {

        return prescriptionService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ---------------------------------------------------------
    // GET PATIENT PRESCRIPTIONS
    // GET /api/prescriptions/patient/{patientId}
    // ---------------------------------------------------------

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Prescription>>
    getPatientPrescriptions(
            @PathVariable Long patientId) {

        return ResponseEntity.ok(
                prescriptionService
                        .getPatientPrescriptions(patientId)
        );
    }

    // ---------------------------------------------------------
    // GET DOCTOR PRESCRIPTIONS
    // GET /api/prescriptions/doctor/{doctorId}
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<List<Prescription>>
    getDoctorPrescriptions(
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                prescriptionService
                        .getDoctorPrescriptions(doctorId)
        );
    }

    // ---------------------------------------------------------
    // GET PRESCRIPTIONS BY MEDICAL RECORD
    // GET /api/prescriptions/record/{medicalRecordId}
    // ---------------------------------------------------------

    @GetMapping("/record/{medicalRecordId}")
    public ResponseEntity<List<Prescription>>
    getMedicalRecordPrescriptions(
            @PathVariable Long medicalRecordId) {

        return ResponseEntity.ok(
                prescriptionService
                        .getMedicalRecordPrescriptions(
                                medicalRecordId
                        )
        );
    }

    // ---------------------------------------------------------
    // GET PATIENT PRESCRIPTIONS BY DOCTOR
    // GET /api/prescriptions/patient/{patientId}/doctor/{doctorId}
    // ---------------------------------------------------------

    @GetMapping(
            "/patient/{patientId}/doctor/{doctorId}"
    )
    public ResponseEntity<List<Prescription>>
    getPatientPrescriptionsByDoctor(
            @PathVariable Long patientId,
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                prescriptionService
                        .getPatientPrescriptionsByDoctor(
                                patientId,
                                doctorId
                        )
        );
    }

    // ---------------------------------------------------------
    // SEARCH BY MEDICINE
    // GET /api/prescriptions/search?medicine=Paracetamol
    // ---------------------------------------------------------

    @GetMapping("/search")
    public ResponseEntity<List<Prescription>>
    searchByMedicine(
            @RequestParam String medicine) {

        return ResponseEntity.ok(
                prescriptionService
                        .searchByMedicine(medicine)
        );
    }

    // ---------------------------------------------------------
    // UPDATE PRESCRIPTION
    // PUT /api/prescriptions/{id}
    // ---------------------------------------------------------

    @PutMapping("/{id}")
    public ResponseEntity<Prescription> updatePrescription(
            @PathVariable Long id,
            @RequestBody Prescription prescription) {

        return ResponseEntity.ok(
                prescriptionService.updatePrescription(
                        id,
                        prescription
                )
        );
    }

    // ---------------------------------------------------------
    // DELETE PRESCRIPTION
    // DELETE /api/prescriptions/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deletePrescription(
            @PathVariable Long id) {

        prescriptionService.deletePrescription(id);

        return ResponseEntity.ok(
                "Prescription deleted successfully"
        );
    }
}