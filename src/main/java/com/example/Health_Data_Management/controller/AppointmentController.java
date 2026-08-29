package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.Appointment;
import com.example.Health_Data_Management.entity.AppointmentStatus;
import com.example.Health_Data_Management.service.AppointmentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;

    public AppointmentController(
            AppointmentService appointmentService) {

        this.appointmentService = appointmentService;
    }

    // ---------------------------------------------------------
    // CREATE APPOINTMENT
    // POST /api/appointments/patient/{patientId}/doctor/{doctorId}
    // ---------------------------------------------------------

    @PostMapping("/patient/{patientId}/doctor/{doctorId}")
    public ResponseEntity<Appointment> createAppointment(
            @PathVariable Long patientId,
            @PathVariable Long doctorId,
            @RequestBody Appointment appointment) {

        Appointment savedAppointment =
                appointmentService.createAppointment(
                        patientId,
                        doctorId,
                        appointment
                );

        return ResponseEntity.ok(savedAppointment);
    }

    // ---------------------------------------------------------
    // GET ALL APPOINTMENTS
    // GET /api/appointments
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<Appointment>> getAllAppointments() {

        return ResponseEntity.ok(
                appointmentService.getAllAppointments()
        );
    }

    // ---------------------------------------------------------
    // GET APPOINTMENT BY ID
    // GET /api/appointments/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<Appointment> getAppointment(
            @PathVariable Long id) {

        return appointmentService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ---------------------------------------------------------
    // GET PATIENT APPOINTMENTS
    // GET /api/appointments/patient/{patientId}
    // ---------------------------------------------------------

    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Appointment>> getPatientAppointments(
            @PathVariable Long patientId) {

        return ResponseEntity.ok(
                appointmentService
                        .getPatientAppointments(patientId)
        );
    }

    // ---------------------------------------------------------
    // GET DOCTOR APPOINTMENTS
    // GET /api/appointments/doctor/{doctorId}
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}")
    public ResponseEntity<List<Appointment>> getDoctorAppointments(
            @PathVariable Long doctorId) {

        return ResponseEntity.ok(
                appointmentService
                        .getDoctorAppointments(doctorId)
        );
    }

    // ---------------------------------------------------------
    // GET APPOINTMENTS BY STATUS
    // GET /api/appointments/status/{status}
    // ---------------------------------------------------------

    @GetMapping("/status/{status}")
    public ResponseEntity<List<Appointment>> getByStatus(
            @PathVariable AppointmentStatus status) {

        return ResponseEntity.ok(
                appointmentService
                        .getAppointmentsByStatus(status)
        );
    }

    // ---------------------------------------------------------
    // GET PATIENT APPOINTMENTS BY STATUS
    // ---------------------------------------------------------

    @GetMapping("/patient/{patientId}/status/{status}")
    public ResponseEntity<List<Appointment>>
    getPatientAppointmentsByStatus(
            @PathVariable Long patientId,
            @PathVariable AppointmentStatus status) {

        return ResponseEntity.ok(
                appointmentService
                        .getPatientAppointmentsByStatus(
                                patientId,
                                status
                        )
        );
    }

    // ---------------------------------------------------------
    // GET DOCTOR APPOINTMENTS BY STATUS
    // ---------------------------------------------------------

    @GetMapping("/doctor/{doctorId}/status/{status}")
    public ResponseEntity<List<Appointment>>
    getDoctorAppointmentsByStatus(
            @PathVariable Long doctorId,
            @PathVariable AppointmentStatus status) {

        return ResponseEntity.ok(
                appointmentService
                        .getDoctorAppointmentsByStatus(
                                doctorId,
                                status
                        )
        );
    }

    // ---------------------------------------------------------
    // CONFIRM APPOINTMENT
    // PUT /api/appointments/{id}/confirm
    // ---------------------------------------------------------

    @PutMapping("/{id}/confirm")
    public ResponseEntity<Appointment> confirmAppointment(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                appointmentService.confirmAppointment(id)
        );
    }

    // ---------------------------------------------------------
    // START APPOINTMENT
    // PUT /api/appointments/{id}/start
    // ---------------------------------------------------------

    @PutMapping("/{id}/start")
    public ResponseEntity<Appointment> startAppointment(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                appointmentService.startAppointment(id)
        );
    }

    // ---------------------------------------------------------
    // COMPLETE APPOINTMENT
    // PUT /api/appointments/{id}/complete
    // ---------------------------------------------------------

    @PutMapping("/{id}/complete")
    public ResponseEntity<Appointment> completeAppointment(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                appointmentService.completeAppointment(id)
        );
    }

    // ---------------------------------------------------------
    // CANCEL APPOINTMENT
    // PUT /api/appointments/{id}/cancel
    // ---------------------------------------------------------

    @PutMapping("/{id}/cancel")
    public ResponseEntity<Appointment> cancelAppointment(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                appointmentService.cancelAppointment(id)
        );
    }

    // ---------------------------------------------------------
    // MARK NO-SHOW
    // PUT /api/appointments/{id}/no-show
    // ---------------------------------------------------------

    @PutMapping("/{id}/no-show")
    public ResponseEntity<Appointment> markAsNoShow(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                appointmentService.markAsNoShow(id)
        );
    }

    // ---------------------------------------------------------
    // LINK MEDICAL RECORD
    // PUT /api/appointments/{appointmentId}/medical-record/{medicalRecordId}
    // ---------------------------------------------------------

    @PutMapping("/{appointmentId}/medical-record/{medicalRecordId}")
    public ResponseEntity<Appointment> linkMedicalRecord(
            @PathVariable Long appointmentId,
            @PathVariable Long medicalRecordId) {

        return ResponseEntity.ok(
                appointmentService.linkMedicalRecord(
                        appointmentId,
                        medicalRecordId
                )
        );
    }

    // ---------------------------------------------------------
    // UPDATE NOTES
    // PUT /api/appointments/{id}/notes
    // ---------------------------------------------------------

    @PutMapping("/{id}/notes")
    public ResponseEntity<Appointment> updateNotes(
            @PathVariable Long id,
            @RequestBody String notes) {

        return ResponseEntity.ok(
                appointmentService.updateNotes(
                        id,
                        notes
                )
        );
    }

    // ---------------------------------------------------------
    // UPDATE REASON
    // PUT /api/appointments/{id}/reason
    // ---------------------------------------------------------

    @PutMapping("/{id}/reason")
    public ResponseEntity<Appointment> updateReason(
            @PathVariable Long id,
            @RequestBody String reason) {

        return ResponseEntity.ok(
                appointmentService.updateReason(
                        id,
                        reason
                )
        );
    }

    // ---------------------------------------------------------
    // GET UPCOMING APPOINTMENTS
    // GET /api/appointments/upcoming
    // ---------------------------------------------------------

    @GetMapping("/upcoming")
    public ResponseEntity<List<Appointment>>
    getUpcomingAppointments() {

        return ResponseEntity.ok(
                appointmentService
                        .getUpcomingAppointments()
        );
    }

    // ---------------------------------------------------------
    // GET APPOINTMENTS BETWEEN DATES
    // GET /api/appointments/between
    // ---------------------------------------------------------

    @GetMapping("/between")
    public ResponseEntity<List<Appointment>>
    getAppointmentsBetween(
            @RequestParam LocalDateTime startDate,
            @RequestParam LocalDateTime endDate) {

        return ResponseEntity.ok(
                appointmentService
                        .getAppointmentsBetween(
                                startDate,
                                endDate
                        )
        );
    }

    // ---------------------------------------------------------
    // DELETE APPOINTMENT
    // DELETE /api/appointments/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteAppointment(
            @PathVariable Long id) {

        appointmentService.deleteAppointment(id);

        return ResponseEntity.ok(
                "Appointment deleted successfully"
        );
    }
}
