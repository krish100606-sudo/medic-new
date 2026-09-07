package com.example.Health_Data_Management.service;



import com.example.Health_Data_Management.entity.Doctor;
import com.example.Health_Data_Management.entity.DoctorAvailability;
import com.example.Health_Data_Management.repository.DoctorAvailabilityRepository;
import com.example.Health_Data_Management.repository.DoctorRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class DoctorAvailabilityService {

    private final DoctorAvailabilityRepository availabilityRepository;
    private final DoctorRepository doctorRepository;

    public DoctorAvailabilityService(
            DoctorAvailabilityRepository availabilityRepository,
            DoctorRepository doctorRepository) {

        this.availabilityRepository = availabilityRepository;
        this.doctorRepository = doctorRepository;
    }

    // ---------------------------------------------------------
    // CREATE AVAILABILITY
    // ---------------------------------------------------------

    public DoctorAvailability createAvailability(
            Long doctorId,
            DoctorAvailability availability) {

        Doctor doctor = doctorRepository.findById(doctorId)
                .orElseThrow(() ->
                        new RuntimeException("Doctor not found"));

        if (availability.getAvailableDate() == null) {
            throw new RuntimeException(
                    "Availability date is required");
        }

        if (availability.getStartTime() == null) {
            throw new RuntimeException(
                    "Start time is required");
        }

        if (availability.getEndTime() == null) {
            throw new RuntimeException(
                    "End time is required");
        }

        if (!availability.getStartTime()
                .isBefore(availability.getEndTime())) {

            throw new RuntimeException(
                    "Start time must be before end time");
        }

        boolean alreadyExists =
                availabilityRepository
                        .existsByDoctorIdAndAvailableDateAndStartTimeAndEndTime(
                                doctorId,
                                availability.getAvailableDate(),
                                availability.getStartTime(),
                                availability.getEndTime()
                        );

        if (alreadyExists) {
            throw new RuntimeException(
                    "This availability slot already exists");
        }

        availability.setDoctor(doctor);

        return availabilityRepository.save(availability);
    }

    // ---------------------------------------------------------
    // GET AVAILABILITY BY ID
    // ---------------------------------------------------------

    public Optional<DoctorAvailability> findById(Long id) {

        return availabilityRepository.findById(id);
    }

    // ---------------------------------------------------------
    // GET ALL AVAILABILITY
    // ---------------------------------------------------------

    public List<DoctorAvailability> getAllAvailability() {

        return availabilityRepository.findAll();
    }

    // ---------------------------------------------------------
    // GET DOCTOR AVAILABILITY
    // ---------------------------------------------------------

    public List<DoctorAvailability> getDoctorAvailability(
            Long doctorId) {

        return availabilityRepository
                .findByDoctorId(doctorId);
    }

    // ---------------------------------------------------------
    // GET DOCTOR AVAILABILITY FOR DATE
    // ---------------------------------------------------------

    public List<DoctorAvailability> getDoctorAvailabilityByDate(
            Long doctorId,
            LocalDate date) {

        return availabilityRepository
                .findByDoctorIdAndAvailableDate(
                        doctorId,
                        date
                );
    }

    // ---------------------------------------------------------
    // GET AVAILABLE SLOTS
    // ---------------------------------------------------------

    public List<DoctorAvailability> getAvailableSlots(
            Long doctorId) {

        return availabilityRepository
                .findByDoctorIdAndAvailable(
                        doctorId,
                        true
                );
    }

    // ---------------------------------------------------------
    // GET AVAILABILITY BY DATE
    // ---------------------------------------------------------

    public List<DoctorAvailability> getAvailabilityByDate(
            LocalDate date) {

        return availabilityRepository
                .findByAvailableDate(date);
    }

    // ---------------------------------------------------------
    // UPDATE AVAILABILITY
    // ---------------------------------------------------------

    public DoctorAvailability updateAvailability(
            Long id,
            DoctorAvailability updatedAvailability) {

        DoctorAvailability availability =
                availabilityRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Availability not found"));

        if (updatedAvailability.getStartTime() != null &&
                updatedAvailability.getEndTime() != null) {

            if (!updatedAvailability.getStartTime()
                    .isBefore(
                            updatedAvailability.getEndTime())) {

                throw new RuntimeException(
                        "Start time must be before end time");
            }

            availability.setStartTime(
                    updatedAvailability.getStartTime());

            availability.setEndTime(
                    updatedAvailability.getEndTime());
        }

        if (updatedAvailability.getAvailableDate() != null) {

            availability.setAvailableDate(
                    updatedAvailability.getAvailableDate());
        }

        availability.setAvailable(
                updatedAvailability.isAvailable());

        return availabilityRepository.save(availability);
    }

    // ---------------------------------------------------------
    // ENABLE AVAILABILITY
    // ---------------------------------------------------------

    public DoctorAvailability enableAvailability(Long id) {

        DoctorAvailability availability =
                getAvailabilityOrThrow(id);

        availability.setAvailable(true);

        return availabilityRepository.save(availability);
    }

    // ---------------------------------------------------------
    // DISABLE AVAILABILITY
    // ---------------------------------------------------------

    public DoctorAvailability disableAvailability(Long id) {

        DoctorAvailability availability =
                getAvailabilityOrThrow(id);

        availability.setAvailable(false);

        return availabilityRepository.save(availability);
    }

    // ---------------------------------------------------------
    // DELETE AVAILABILITY
    // ---------------------------------------------------------

    public void deleteAvailability(Long id) {

        if (!availabilityRepository.existsById(id)) {

            throw new RuntimeException(
                    "Availability not found");
        }

        availabilityRepository.deleteById(id);
    }

    // ---------------------------------------------------------
    // HELPER METHOD
    // ---------------------------------------------------------

    private DoctorAvailability getAvailabilityOrThrow(
            Long id) {

        return availabilityRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Availability not found"));
    }
}
