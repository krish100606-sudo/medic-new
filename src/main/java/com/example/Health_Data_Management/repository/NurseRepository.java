package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.Nurse;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface NurseRepository extends JpaRepository<Nurse, Long> {

    // Find nurse using the linked User ID
    Optional<Nurse> findByUserId(Long userId);

    // Check whether a nurse profile already exists
    boolean existsByUserId(Long userId);

    // Find nurse using nurse ID
    Optional<Nurse> findByNurseId(String nurseId);

    // Find nurses by department
    List<Nurse> findByDepartmentIgnoreCase(String department);
}