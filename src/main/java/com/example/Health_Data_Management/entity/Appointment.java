package com.example.Health_Data_Management.entity;



import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    // ---------------------------------------------------------
    // PATIENT
    // ---------------------------------------------------------

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;


    // ---------------------------------------------------------
    // DOCTOR
    // ---------------------------------------------------------

    @ManyToOne
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;


    // ---------------------------------------------------------
    // MEDICAL RECORD - OPTIONAL
    // ---------------------------------------------------------

    @ManyToOne
    @JoinColumn(name = "medical_record_id")
    private MedicalRecord medicalRecord;


    // ---------------------------------------------------------
    // APPOINTMENT DETAILS
    // ---------------------------------------------------------

    @Column(name = "appointment_date", nullable = false)
    private LocalDateTime appointmentDate;

    @Column(name = "reason", length = 2000)
    private String reason;

    @Column(name = "notes", length = 3000)
    private String notes;


    // ---------------------------------------------------------
    // STATUS
    // ---------------------------------------------------------

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AppointmentStatus status = AppointmentStatus.SCHEDULED;


    // ---------------------------------------------------------
    // TIMESTAMPS
    // ---------------------------------------------------------

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;


    // ---------------------------------------------------------
    // CONSTRUCTOR
    // ---------------------------------------------------------

    public Appointment() {
    }


    // ---------------------------------------------------------
    // PRE-PERSIST
    // ---------------------------------------------------------

    @PrePersist
    protected void onCreate() {

        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }

        updatedAt = LocalDateTime.now();
    }


    // ---------------------------------------------------------
    // PRE-UPDATE
    // ---------------------------------------------------------

    @PreUpdate
    protected void onUpdate() {

        updatedAt = LocalDateTime.now();
    }


    // ---------------------------------------------------------
    // GETTERS AND SETTERS
    // ---------------------------------------------------------

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }


    public Doctor getDoctor() {
        return doctor;
    }

    public void setDoctor(Doctor doctor) {
        this.doctor = doctor;
    }


    public MedicalRecord getMedicalRecord() {
        return medicalRecord;
    }

    public void setMedicalRecord(
            MedicalRecord medicalRecord) {

        this.medicalRecord = medicalRecord;
    }


    public LocalDateTime getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(
            LocalDateTime appointmentDate) {

        this.appointmentDate = appointmentDate;
    }


    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }


    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }


    public AppointmentStatus getStatus() {
        return status;
    }

    public void setStatus(AppointmentStatus status) {
        this.status = status;
    }


    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }


    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
