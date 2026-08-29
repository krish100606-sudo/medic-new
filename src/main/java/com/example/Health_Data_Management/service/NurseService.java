package com.example.Health_Data_Management.service;





import com.example.Health_Data_Management.entity.Nurse;
import com.example.Health_Data_Management.entity.User;
import com.example.Health_Data_Management.repository.NurseRepository;
import com.example.Health_Data_Management.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NurseService {

    private final NurseRepository nurseRepository;
    private final UserRepository userRepository;

    public NurseService(NurseRepository nurseRepository,
                        UserRepository userRepository) {

        this.nurseRepository = nurseRepository;
        this.userRepository = userRepository;
    }

    // ---------------------------------------------------------
    // CREATE NURSE PROFILE
    // ---------------------------------------------------------

    public Nurse createNurse(Long userId) {

        if (nurseRepository.existsByUserId(userId)) {
            throw new RuntimeException(
                    "Nurse profile already exists"
            );
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "User not found"
                        )
                );

        Nurse nurse = new Nurse();
        nurse.setUser(user);

        return nurseRepository.save(nurse);
    }


    // ---------------------------------------------------------
    // FIND NURSE BY ID
    // ---------------------------------------------------------

    public Optional<Nurse> findById(Long id) {

        return nurseRepository.findById(id);
    }


    // ---------------------------------------------------------
    // FIND NURSE BY USER ID
    // ---------------------------------------------------------

    public Optional<Nurse> findByUserId(Long userId) {

        return nurseRepository.findByUserId(userId);
    }


    // ---------------------------------------------------------
    // FIND NURSE BY NURSE ID
    // ---------------------------------------------------------

    public Optional<Nurse> findByNurseId(String nurseId) {

        return nurseRepository.findByNurseId(nurseId);
    }


    // ---------------------------------------------------------
    // GET ALL NURSES
    // ---------------------------------------------------------

    public List<Nurse> getAllNurses() {

        return nurseRepository.findAll();
    }


    // ---------------------------------------------------------
    // FIND NURSES BY DEPARTMENT
    // ---------------------------------------------------------

    public List<Nurse> findByDepartment(String department) {

        return nurseRepository
                .findByDepartmentIgnoreCase(department);
    }


    // ---------------------------------------------------------
    // UPDATE NURSE
    // ---------------------------------------------------------

    public Nurse updateNurse(Nurse updatedNurse) {

        Nurse nurse = nurseRepository.findById(
                updatedNurse.getId()
        ).orElseThrow(() ->
                new RuntimeException(
                        "Nurse not found"
                )
        );

        nurse.setNurseId(
                updatedNurse.getNurseId()
        );

        nurse.setQualification(
                updatedNurse.getQualification()
        );

        nurse.setDepartment(
                updatedNurse.getDepartment()
        );

        nurse.setPhone(
                updatedNurse.getPhone()
        );

        nurse.setAddress(
                updatedNurse.getAddress()
        );

        nurse.setYearsOfExperience(
                updatedNurse.getYearsOfExperience()
        );

        return nurseRepository.save(nurse);
    }


    // ---------------------------------------------------------
    // DELETE NURSE
    // ---------------------------------------------------------

    public void deleteNurse(Long id) {

        if (!nurseRepository.existsById(id)) {
            throw new RuntimeException(
                    "Nurse not found"
            );
        }

        nurseRepository.deleteById(id);
    }
}