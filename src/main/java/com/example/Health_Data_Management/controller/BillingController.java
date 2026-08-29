package com.example.Health_Data_Management.controller;

import com.example.Health_Data_Management.entity.Billing;
import com.example.Health_Data_Management.service.BillingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/billing")
public class BillingController {

    private final BillingService billingService;

    public BillingController(BillingService billingService) {
        this.billingService = billingService;
    }

    @PostMapping("/create")
    public ResponseEntity<Billing> createBill(
            @RequestParam Long patientId, 
            @RequestParam(required = false) Long admissionId, 
            @RequestParam Double amount) {
        Billing billing = billingService.createBill(patientId, admissionId, amount);
        return ResponseEntity.ok(billing);
    }

    @PostMapping("/{id}/pay")
    public ResponseEntity<Billing> payBill(@PathVariable Long id) {
        Billing billing = billingService.payBill(id);
        return ResponseEntity.ok(billing);
    }

    @GetMapping
    public ResponseEntity<List<Billing>> getAllBills() {
        return ResponseEntity.ok(billingService.getAllBills());
    }
}
