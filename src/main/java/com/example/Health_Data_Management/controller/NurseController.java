package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.Nurse;
import com.example.Health_Data_Management.service.NurseService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/nurses")
public class NurseController {

    private final NurseService nurseService;

    public NurseController(NurseService nurseService) {
        this.nurseService = nurseService;
    }

    // ---------------------------------------------------------
    // CREATE NURSE PROFILE
    // POST /api/nurses/user/{userId}
    // ---------------------------------------------------------

    @PostMapping("/user/{userId}")
    public ResponseEntity<Nurse> createNurse(
            @PathVariable Long userId) {

        Nurse nurse = nurseService.createNurse(userId);

        return ResponseEntity.ok(nurse);
    }


    // ---------------------------------------------------------
    // GET ALL NURSES
    // GET /api/nurses
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<Nurse>> getAllNurses() {

        return ResponseEntity.ok(
                nurseService.getAllNurses()
        );
    }


    // ---------------------------------------------------------
    // GET NURSE BY ID
    // GET /api/nurses/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<Nurse> getNurse(
            @PathVariable Long id) {

        return nurseService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // ---------------------------------------------------------
    // GET NURSE BY USER ID
    // GET /api/nurses/user/{userId}
    // ---------------------------------------------------------

    @GetMapping("/user/{userId}")
    public ResponseEntity<Nurse> getNurseByUserId(
            @PathVariable Long userId) {

        return nurseService.findByUserId(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // ---------------------------------------------------------
    // GET NURSE BY NURSE ID
    // GET /api/nurses/nurse-id/{nurseId}
    // ---------------------------------------------------------

    @GetMapping("/nurse-id/{nurseId}")
    public ResponseEntity<Nurse> getNurseByNurseId(
            @PathVariable String nurseId) {

        return nurseService.findByNurseId(nurseId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // ---------------------------------------------------------
    // FIND NURSES BY DEPARTMENT
    // GET /api/nurses/department/{department}
    // ---------------------------------------------------------

    @GetMapping("/department/{department}")
    public ResponseEntity<List<Nurse>> findByDepartment(
            @PathVariable String department) {

        return ResponseEntity.ok(
                nurseService.findByDepartment(department)
        );
    }


    // ---------------------------------------------------------
    // UPDATE NURSE
    // PUT /api/nurses/{id}
    // ---------------------------------------------------------

    @PutMapping("/{id}")
    public ResponseEntity<Nurse> updateNurse(
            @PathVariable Long id,
            @RequestBody Nurse nurse) {

        nurse.setId(id);

        Nurse updatedNurse =
                nurseService.updateNurse(nurse);

        return ResponseEntity.ok(updatedNurse);
    }


    // ---------------------------------------------------------
    // DELETE NURSE
    // DELETE /api/nurses/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteNurse(
            @PathVariable Long id) {

        nurseService.deleteNurse(id);

        return ResponseEntity.ok(
                "Nurse deleted successfully"
        );
    }
}
