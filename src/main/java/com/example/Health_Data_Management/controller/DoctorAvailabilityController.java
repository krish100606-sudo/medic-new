package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.DoctorAvailability;
import com.example.Health_Data_Management.service.DoctorAvailabilityService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/doctor-availability")
public class DoctorAvailabilityController {

    private final DoctorAvailabilityService availabilityService;

    public DoctorAvailabilityController(
            DoctorAvailabilityService availabilityService) {

        this.availabilityService = availabilityService;
    }

    // ---------------------------------------------------------
    // CREATE AVAILABILITY
    // POST /api/doctor-availability/doctor/{doctorId}
    // ---------------------------------------------------------

    @PostMapping("/doctor/{doctorId}")
    public ResponseEntity<DoctorAvailability> createAvailability(
            @PathVariable Long doctorId,
            @RequestBody DoctorAvailability availability) {

        return ResponseEntity.ok(
                availabilityService.createAvailability(
                        doctorId,
                        availability
                )
        );
    }

    // ---------------------------------------------------------
    // GET ALL AVAILABILITY
    // GET /api/doctor-availability
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<DoctorAvailability>>
    getAllAvailability() {

        return ResponseEntity.ok(
                availabilityService.getAllAvailability()
        );
    }

    // ---------------------------------------------------------
    // GET AVAILABILITY BY ID
    // GET /api/doctor-availability/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<DoctorAvailability> getAvailability(
            @PathVariable Long id) {

        return availabilityService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ---------------------------------------------------------
    // GET DOCTOR AVAILABILITY
    // GET /api/doctor-availability/doctor/{doctorId}
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<List<DoctorAvailability>>
    getDoctorAvailability(
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                availabilityService
                        .getDoctorAvailability(doctorId)
        );
    }

    // ---------------------------------------------------------
    // GET DOCTOR AVAILABILITY FOR DATE
    // GET /api/doctor-availability/doctor/{doctorId}/date/{date}
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}/date/{date}")
    public ResponseEntity<List<DoctorAvailability>>
    getDoctorAvailabilityByDate(
            @PathVariable Long doctorId,
            @PathVariable LocalDate date) {

        return ResponseEntity.ok(
                availabilityService
                        .getDoctorAvailabilityByDate(
                                doctorId,
                                date
                        )
        );
    }

    // ---------------------------------------------------------
    // GET AVAILABLE SLOTS
    // GET /api/doctor-availability/doctor/{doctorId}/available
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}/available")
    public ResponseEntity<List<DoctorAvailability>>
    getAvailableSlots(
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                availabilityService
                        .getAvailableSlots(doctorId)
        );
    }

    // ---------------------------------------------------------
    // GET AVAILABILITY BY DATE
    // GET /api/doctor-availability/date/{date}
    // ---------------------------------------------------------

    @GetMapping("/date/{date}")
    public ResponseEntity<List<DoctorAvailability>>
    getAvailabilityByDate(
            @PathVariable LocalDate date) {

        return ResponseEntity.ok(
                availabilityService
                        .getAvailabilityByDate(date)
        );
    }

    // ---------------------------------------------------------
    // UPDATE AVAILABILITY
    // PUT /api/doctor-availability/{id}
    // ---------------------------------------------------------

    @PutMapping("/{id}")
    public ResponseEntity<DoctorAvailability> updateAvailability(
            @PathVariable Long id,
            @RequestBody DoctorAvailability availability) {

        return ResponseEntity.ok(
                availabilityService.updateAvailability(
                        id,
                        availability
                )
        );
    }

    // ---------------------------------------------------------
    // ENABLE AVAILABILITY
    // PUT /api/doctor-availability/{id}/enable
    // ---------------------------------------------------------

    @PutMapping("/{id}/enable")
    public ResponseEntity<DoctorAvailability>
    enableAvailability(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                availabilityService.enableAvailability(id)
        );
    }

    // ---------------------------------------------------------
    // DISABLE AVAILABILITY
    // PUT /api/doctor-availability/{id}/disable
    // ---------------------------------------------------------

    @PutMapping("/{id}/disable")
    public ResponseEntity<DoctorAvailability>
    disableAvailability(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                availabilityService.disableAvailability(id)
        );
    }

    // ---------------------------------------------------------
    // DELETE AVAILABILITY
    // DELETE /api/doctor-availability/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteAvailability(
            @PathVariable Long id) {

        availabilityService.deleteAvailability(id);

        return ResponseEntity.ok(
                "Doctor availability deleted successfully"
        );
    }
}
