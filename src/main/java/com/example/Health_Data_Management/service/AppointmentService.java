package com.example.Health_Data_Management.service;



import com.example.Health_Data_Management.entity.Appointment;
import com.example.Health_Data_Management.entity.AppointmentStatus;
import com.example.Health_Data_Management.entity.Doctor;
import com.example.Health_Data_Management.entity.MedicalRecord;
import com.example.Health_Data_Management.entity.Patient;
import com.example.Health_Data_Management.repository.AppointmentRepository;
import com.example.Health_Data_Management.repository.DoctorRepository;
import com.example.Health_Data_Management.repository.MedicalRecordRepository;
import com.example.Health_Data_Management.repository.PatientRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;
    private final MedicalRecordRepository medicalRecordRepository;

    public AppointmentService(
            AppointmentRepository appointmentRepository,
            PatientRepository patientRepository,
            DoctorRepository doctorRepository,
            MedicalRecordRepository medicalRecordRepository) {

        this.appointmentRepository = appointmentRepository;
        this.patientRepository = patientRepository;
        this.doctorRepository = doctorRepository;
        this.medicalRecordRepository = medicalRecordRepository;
    }

    // ---------------------------------------------------------
    // CREATE APPOINTMENT
    // ---------------------------------------------------------

    public Appointment createAppointment(
            Long patientId,
            Long doctorId,
            Appointment appointment) {

        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() ->
                        new RuntimeException("Patient not found"));

        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() ->
                        new RuntimeException("Doctor not found"));

        if (appointment.getAppointmentDate() == null) {
            throw new RuntimeException(
                    "Appointment date is required");
        }

        LocalDateTime appointmentDate =
                appointment.getAppointmentDate();

        // Prevent booking a doctor at the same time
        boolean alreadyBooked =
                appointmentRepository
                        .existsByDoctorIdAndAppointmentDate(
                                doctorId,
                                appointmentDate
                        );

        if (alreadyBooked) {
            throw new RuntimeException(
                    "Doctor already has an appointment at this time"
            );
        }

        appointment.setPatient(patient);
        appointment.setDoctor(doctor);
        appointment.setStatus(
                AppointmentStatus.SCHEDULED
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // GET APPOINTMENT BY ID
    // ---------------------------------------------------------

    public Optional<Appointment> findById(Long id) {

        return appointmentRepository.findById(id);
    }

    // ---------------------------------------------------------
    // GET ALL APPOINTMENTS
    // ---------------------------------------------------------

    public List<Appointment> getAllAppointments() {

        return appointmentRepository.findAll();
    }

    // ---------------------------------------------------------
    // GET PATIENT APPOINTMENTS
    // ---------------------------------------------------------

    public List<Appointment> getPatientAppointments(
            Long patientId) {

        return appointmentRepository
                .findByPatientId(patientId);
    }

    // ---------------------------------------------------------
    // GET DOCTOR APPOINTMENTS
    // ---------------------------------------------------------

    public List<Appointment> getDoctorAppointments(
            Long doctorId) {

        return appointmentRepository
                .findByDoctorId(doctorId);
    }

    // ---------------------------------------------------------
    // GET APPOINTMENTS BY STATUS
    // ---------------------------------------------------------

    public List<Appointment> getAppointmentsByStatus(
            AppointmentStatus status) {

        return appointmentRepository
                .findByStatus(status);
    }

    // ---------------------------------------------------------
    // GET PATIENT APPOINTMENTS BY STATUS
    // ---------------------------------------------------------

    public List<Appointment> getPatientAppointmentsByStatus(
            Long patientId,
            AppointmentStatus status) {

        return appointmentRepository
                .findByPatientIdAndStatus(
                        patientId,
                        status
                );
    }

    // ---------------------------------------------------------
    // GET DOCTOR APPOINTMENTS BY STATUS
    // ---------------------------------------------------------

    public List<Appointment> getDoctorAppointmentsByStatus(
            Long doctorId,
            AppointmentStatus status) {

        return appointmentRepository
                .findByDoctorIdAndStatus(
                        doctorId,
                        status
                );
    }

    // ---------------------------------------------------------
    // CONFIRM APPOINTMENT
    // ---------------------------------------------------------

    public Appointment confirmAppointment(Long id) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        if (appointment.getStatus() ==
                AppointmentStatus.CANCELLED) {

            throw new RuntimeException(
                    "Cancelled appointment cannot be confirmed"
            );
        }

        appointment.setStatus(
                AppointmentStatus.CONFIRMED
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // START APPOINTMENT
    // ---------------------------------------------------------

    public Appointment startAppointment(Long id) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        if (appointment.getStatus() ==
                AppointmentStatus.CANCELLED) {

            throw new RuntimeException(
                    "Cancelled appointment cannot be started"
            );
        }

        appointment.setStatus(
                AppointmentStatus.IN_PROGRESS
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // COMPLETE APPOINTMENT
    // ---------------------------------------------------------

    public Appointment completeAppointment(Long id) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        appointment.setStatus(
                AppointmentStatus.COMPLETED
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // CANCEL APPOINTMENT
    // ---------------------------------------------------------

    public Appointment cancelAppointment(Long id) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        if (appointment.getStatus() ==
                AppointmentStatus.COMPLETED) {

            throw new RuntimeException(
                    "Completed appointment cannot be cancelled"
            );
        }

        appointment.setStatus(
                AppointmentStatus.CANCELLED
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // MARK AS NO-SHOW
    // ---------------------------------------------------------

    public Appointment markAsNoShow(Long id) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        appointment.setStatus(
                AppointmentStatus.NO_SHOW
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // LINK APPOINTMENT TO MEDICAL RECORD
    // ---------------------------------------------------------

    public Appointment linkMedicalRecord(
            Long appointmentId,
            Long medicalRecordId) {

        Appointment appointment =
                getAppointmentOrThrow(appointmentId);

        MedicalRecord medicalRecord =
                medicalRecordRepository
                        .findById(medicalRecordId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Medical record not found"
                                )
                        );

        appointment.setMedicalRecord(
                medicalRecord
        );

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // UPDATE APPOINTMENT NOTES
    // ---------------------------------------------------------

    public Appointment updateNotes(
            Long id,
            String notes) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        appointment.setNotes(notes);

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // UPDATE REASON
    // ---------------------------------------------------------

    public Appointment updateReason(
            Long id,
            String reason) {

        Appointment appointment =
                getAppointmentOrThrow(id);

        appointment.setReason(reason);

        return appointmentRepository.save(appointment);
    }

    // ---------------------------------------------------------
    // GET UPCOMING APPOINTMENTS
    // ---------------------------------------------------------

    public List<Appointment> getUpcomingAppointments() {

        return appointmentRepository
                .findByAppointmentDateGreaterThanEqual(
                        LocalDateTime.now()
                );
    }

    // ---------------------------------------------------------
    // GET APPOINTMENTS BETWEEN DATES
    // ---------------------------------------------------------

    public List<Appointment> getAppointmentsBetween(
            LocalDateTime startDate,
            LocalDateTime endDate) {

        return appointmentRepository
                .findByAppointmentDateBetween(
                        startDate,
                        endDate
                );
    }

    // ---------------------------------------------------------
    // DELETE APPOINTMENT
    // ---------------------------------------------------------

    public void deleteAppointment(Long id) {

        if (!appointmentRepository.existsById(id)) {

            throw new RuntimeException(
                    "Appointment not found"
            );
        }

        appointmentRepository.deleteById(id);
    }

    // ---------------------------------------------------------
    // HELPER METHOD
    // ---------------------------------------------------------

    private Appointment getAppointmentOrThrow(Long id) {

        return appointmentRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Appointment not found"
                        )
                );
    }
}
