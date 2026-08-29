package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.CaseStatus;
import com.example.Health_Data_Management.entity.MedicalRecord;
import com.example.Health_Data_Management.service.MedicalRecordService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/medical-records")
public class MedicalRecordController {

    private final MedicalRecordService medicalRecordService;

    public MedicalRecordController(
            MedicalRecordService medicalRecordService) {

        this.medicalRecordService = medicalRecordService;
    }


    // ---------------------------------------------------------
    // CREATE MEDICAL RECORD
    // POST /api/medical-records/patient/{patientId}
    // ---------------------------------------------------------

    @PostMapping("/patient/{patientId}")
    public ResponseEntity<MedicalRecord> createRecord(
            @PathVariable Long patientId) {

        MedicalRecord record =
                medicalRecordService.createRecord(patientId);

        return ResponseEntity.ok(record);
    }


    // ---------------------------------------------------------
    // GET ALL MEDICAL RECORDS
    // GET /api/medical-records
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<MedicalRecord>> getAllRecords() {

        return ResponseEntity.ok(
                medicalRecordService.getAllRecords()
        );
    }


    // ---------------------------------------------------------
    // GET RECORD BY ID
    // GET /api/medical-records/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<MedicalRecord> getRecord(
            @PathVariable Long id) {

        return medicalRecordService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // ---------------------------------------------------------
    // GET RECORD BY CASE NUMBER
    // GET /api/medical-records/case/{caseNumber}
    // ---------------------------------------------------------

    @GetMapping("/case/{caseNumber}")
    public ResponseEntity<MedicalRecord> getByCaseNumber(
            @PathVariable String caseNumber) {

        return medicalRecordService
                .findByCaseNumber(caseNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // ---------------------------------------------------------
    // GET PATIENT RECORDS
    // GET /api/medical-records/patient/{patientId}
    // ---------------------------------------------------------

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<MedicalRecord>> getPatientRecords(
            @PathVariable Long patientId) {

        return ResponseEntity.ok(
                medicalRecordService
                        .getPatientRecords(patientId)
        );
    }


    // ---------------------------------------------------------
    // ASSIGN DOCTOR
    // PUT /api/medical-records/{recordId}/doctor/{doctorId}
    // ---------------------------------------------------------

    @PutMapping("/{recordId}/doctor/{doctorId}")
    public ResponseEntity<MedicalRecord> assignDoctor(
            @PathVariable Long recordId,
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                medicalRecordService.assignDoctor(
                        recordId,
                        doctorId
                )
        );
    }


    // ---------------------------------------------------------
    // ASSIGN NURSE
    // PUT /api/medical-records/{recordId}/nurse/{nurseId}
    // ---------------------------------------------------------

    @PutMapping("/{recordId}/nurse/{nurseId}")
    public ResponseEntity<MedicalRecord> assignNurse(
            @PathVariable Long recordId,
            @PathVariable Long nurseId) {

        return ResponseEntity.ok(
                medicalRecordService.assignNurse(
                        recordId,
                        nurseId
                )
        );
    }


    // ---------------------------------------------------------
    // UPDATE MEDICAL RECORD
    // PUT /api/medical-records/{id}
    // ---------------------------------------------------------

    @PutMapping("/{id}")
    public ResponseEntity<MedicalRecord> updateRecord(
            @PathVariable Long id,
            @RequestBody MedicalRecord record) {

        record.setId(id);

        MedicalRecord updatedRecord =
                medicalRecordService.updateRecord(record);

        return ResponseEntity.ok(updatedRecord);
    }


    // ---------------------------------------------------------
    // UPDATE CASE STATUS
    // PUT /api/medical-records/{id}/status/{status}
    // ---------------------------------------------------------

    @PutMapping("/{id}/status/{status}")
    public ResponseEntity<MedicalRecord> updateStatus(
            @PathVariable Long id,
            @PathVariable CaseStatus status) {

        return ResponseEntity.ok(
                medicalRecordService.updateStatus(
                        id,
                        status
                )
        );
    }


    // ---------------------------------------------------------
    // GET DOCTOR RECORDS
    // GET /api/medical-records/doctor/{doctorId}
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<List<MedicalRecord>> getDoctorRecords(
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                medicalRecordService
                        .getDoctorRecords(doctorId)
        );
    }


    // ---------------------------------------------------------
    // GET NURSE RECORDS
    // GET /api/medical-records/nurse/{nurseId}
    // ---------------------------------------------------------

    @GetMapping("/nurse/{nurseId}")
    public ResponseEntity<List<MedicalRecord>> getNurseRecords(
            @PathVariable Long nurseId) {

        return ResponseEntity.ok(
                medicalRecordService
                        .getNurseRecords(nurseId)
        );
    }


    // ---------------------------------------------------------
    // GET RECORDS BY STATUS
    // GET /api/medical-records/status/{status}
    // ---------------------------------------------------------

    @GetMapping("/status/{status}")
    public ResponseEntity<List<MedicalRecord>> getRecordsByStatus(
            @PathVariable CaseStatus status) {

        return ResponseEntity.ok(
                medicalRecordService
                        .getRecordsByStatus(status)
        );
    }


    // ---------------------------------------------------------
    // DELETE RECORD
    // DELETE /api/medical-records/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteRecord(
            @PathVariable Long id) {

        medicalRecordService.deleteRecord(id);

        return ResponseEntity.ok(
                "Medical record deleted successfully"
        );
    }
}