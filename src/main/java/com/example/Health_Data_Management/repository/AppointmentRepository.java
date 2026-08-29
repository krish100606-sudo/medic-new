package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.Appointment;
import com.example.Health_Data_Management.entity.AppointmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository
        extends JpaRepository<Appointment, Long> {

    // Get all appointments of a patient
    List<Appointment> findByPatientId(Long patientId);

    // Get all appointments of a doctor
    List<Appointment> findByDoctorId(Long doctorId);

    // Get appointments by status
    List<Appointment> findByStatus(AppointmentStatus status);

    // Get patient's appointments by status
    List<Appointment> findByPatientIdAndStatus(
            Long patientId,
            AppointmentStatus status
    );

    // Get doctor's appointments by status
    List<Appointment> findByDoctorIdAndStatus(
            Long doctorId,
            AppointmentStatus status
    );

    // Get appointments on/after a particular date
    List<Appointment> findByAppointmentDateGreaterThanEqual(
            LocalDateTime date
    );

    // Get appointments between two dates
    List<Appointment> findByAppointmentDateBetween(
            LocalDateTime startDate,
            LocalDateTime endDate
    );

    // Check whether doctor already has an appointment
    boolean existsByDoctorIdAndAppointmentDate(
            Long doctorId,
            LocalDateTime appointmentDate
    );
}
