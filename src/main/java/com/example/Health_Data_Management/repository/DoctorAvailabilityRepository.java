package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.DoctorAvailability;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface DoctorAvailabilityRepository
        extends JpaRepository<DoctorAvailability, Long> {

    // Get all availability records for a doctor
    List<DoctorAvailability> findByDoctorId(Long doctorId);

    // Get availability for a doctor on a particular date
    List<DoctorAvailability> findByDoctorIdAndAvailableDate(
            Long doctorId,
            LocalDate availableDate
    );

    // Get only available slots for a doctor
    List<DoctorAvailability> findByDoctorIdAndAvailable(
            Long doctorId,
            boolean available
    );

    // Get availability for a particular date
    List<DoctorAvailability> findByAvailableDate(
            LocalDate availableDate
    );

    // Check whether a doctor has an availability entry
    boolean existsByDoctorIdAndAvailableDateAndStartTimeAndEndTime(
            Long doctorId,
            LocalDate availableDate,
            LocalTime startTime,
            LocalTime endTime
    );
}
