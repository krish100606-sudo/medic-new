package com.example.Health_Data_Management.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "admissions")
public class Admission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "room_number")
    private String roomNumber;

    @Column(name = "admission_type", length = 50)
    private String admissionType; // Emergency, Scheduled, Elective

    @Column(name = "reason_for_admission", length = 500)
    private String reasonForAdmission;

    @Column(name = "condition_upon_admission", length = 500)
    private String conditionUponAdmission;

    @Column(name = "dietary_requirements", length = 500)
    private String dietaryRequirements;

    @ManyToOne
    @JoinColumn(name = "attending_doctor_id")
    private Doctor attendingDoctor;

    @Column(name = "admission_date", nullable = false)
    private LocalDateTime admissionDate;

    @Column(name = "discharge_date")
    private LocalDateTime dischargeDate;

    @Column(length = 20)
    private String status; // ADMITTED, DISCHARGED

    public Admission() {
    }

    @PrePersist
    protected void onCreate() {
        if (admissionDate == null) {
            admissionDate = LocalDateTime.now();
        }
        if (status == null) {
            status = "ADMITTED";
        }
    }

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

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getAdmissionType() {
        return admissionType;
    }

    public void setAdmissionType(String admissionType) {
        this.admissionType = admissionType;
    }

    public String getReasonForAdmission() {
        return reasonForAdmission;
    }

    public void setReasonForAdmission(String reasonForAdmission) {
        this.reasonForAdmission = reasonForAdmission;
    }

    public String getConditionUponAdmission() {
        return conditionUponAdmission;
    }

    public void setConditionUponAdmission(String conditionUponAdmission) {
        this.conditionUponAdmission = conditionUponAdmission;
    }

    public String getDietaryRequirements() {
        return dietaryRequirements;
    }

    public void setDietaryRequirements(String dietaryRequirements) {
        this.dietaryRequirements = dietaryRequirements;
    }

    public Doctor getAttendingDoctor() {
        return attendingDoctor;
    }

    public void setAttendingDoctor(Doctor attendingDoctor) {
        this.attendingDoctor = attendingDoctor;
    }

    public LocalDateTime getAdmissionDate() {
        return admissionDate;
    }

    public void setAdmissionDate(LocalDateTime admissionDate) {
        this.admissionDate = admissionDate;
    }

    public LocalDateTime getDischargeDate() {
        return dischargeDate;
    }

    public void setDischargeDate(LocalDateTime dischargeDate) {
        this.dischargeDate = dischargeDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
