package com.example.Health_Data_Management.controller;

import com.example.Health_Data_Management.service.FhirService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class FhirController {

    private final FhirService fhirService;

    public FhirController(FhirService fhirService) {
        this.fhirService = fhirService;
    }

    /**
     * HL7 FHIR R4 Compliant Clinical Document Bundle Endpoint
     */
    @GetMapping(value = "/fhir/cases/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getFhirBundle(@PathVariable("id") Long caseId) {
        Map<String, Object> bundle = fhirService.generateFhirR4Bundle(caseId);
        return ResponseEntity.ok(bundle);
    }

    /**
     * Mock ABDM (Ayushman Bharat Digital Mission) Sandbox Patient Profile Lookup
     */
    @GetMapping(value = "/abdm/sandbox/patient/{abhaId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getAbdmPatientProfile(@PathVariable("abhaId") String abhaId) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "SUCCESS");
        response.put("sandboxMode", true);
        response.put("network", "ABDM Sandbox Testbed (SIH 2026)");
        response.put("abhaId", abhaId);
        response.put("name", "Rahul Sharma");
        response.put("gender", "M");
        response.put("yearOfBirth", "1984");
        response.put("state", "Delhi");
        response.put("kycVerified", true);
        response.put("linkedHIPs", List.of(
                Map.of("hipId", "HIP-DELHI-001", "hipName", "AIIMS New Delhi OPD"),
                Map.of("hipId", "HIP-DELHI-004", "hipName", "Safdarjung Hospital")
        ));
        response.put("consentManagerStatus", "ACTIVE");
        return ResponseEntity.ok(response);
    }

    /**
     * Mock ABDM Push Record Endpoint (HIP Data Push Sandbox)
     */
    @PostMapping(value = "/abdm/sandbox/push-record", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> pushRecordToAbdm(@RequestBody(required = false) Map<String, Object> payload) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "SUCCESS");
        response.put("txId", "abdm-tx-" + UUID.randomUUID());
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("message", "Pre-consultation clinical bundle pushed to ABDM Gateway Sandbox");
        response.put("hipCode", "MEDIKIOSK-OPD-772");
        return ResponseEntity.ok(response);
    }
}
