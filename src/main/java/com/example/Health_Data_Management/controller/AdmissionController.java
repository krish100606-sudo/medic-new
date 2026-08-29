package com.example.Health_Data_Management.controller;

import com.example.Health_Data_Management.entity.Admission;
import com.example.Health_Data_Management.service.AdmissionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admissions")
public class AdmissionController {

    private final AdmissionService admissionService;

    public AdmissionController(AdmissionService admissionService) {
        this.admissionService = admissionService;
    }

    @PostMapping("/admit")
    public ResponseEntity<Admission> admitPatient(
            @RequestParam Long patientId, 
            @RequestParam String roomNumber,
            @RequestParam(required = false) String admissionType,
            @RequestParam(required = false) String reason,
            @RequestParam(required = false) String condition,
            @RequestParam(required = false) String dietary,
            @RequestParam(required = false) Long doctorId) {
        
        Admission admission = admissionService.admitPatient(
                patientId, roomNumber, admissionType, reason, condition, dietary, doctorId);
        return ResponseEntity.ok(admission);
    }

    @PostMapping("/{id}/discharge")
    public ResponseEntity<Admission> dischargePatient(@PathVariable Long id) {
        Admission admission = admissionService.dischargePatient(id);
        return ResponseEntity.ok(admission);
    }

    @GetMapping
    public ResponseEntity<List<Admission>> getAllAdmissions() {
        return ResponseEntity.ok(admissionService.getAllAdmissions());
    }
    
    @GetMapping("/active")
    public ResponseEntity<List<Admission>> getActiveAdmissions() {
        return ResponseEntity.ok(admissionService.getActiveAdmissions());
    }
}
