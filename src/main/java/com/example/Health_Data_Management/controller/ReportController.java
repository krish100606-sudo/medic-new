package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.Report;
import com.example.Health_Data_Management.service.ReportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reports")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    // ---------------------------------------------------------
    // CREATE REPORT
    // POST /api/reports/medical-record/{medicalRecordId}
    // ---------------------------------------------------------

    @PostMapping("/medical-record/{medicalRecordId}")
    public ResponseEntity<Report> createReport(
            @PathVariable Long medicalRecordId,
            @RequestBody Report report) {

        Report savedReport =
                reportService.createReport(
                        medicalRecordId,
                        report
                );

        return ResponseEntity.ok(savedReport);
    }


    // ---------------------------------------------------------
    // GET ALL REPORTS
    // GET /api/reports
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<Report>> getAllReports() {

        return ResponseEntity.ok(
                reportService.getAllReports()
        );
    }


    // ---------------------------------------------------------
    // GET REPORT BY ID
    // GET /api/reports/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<Report> getReport(
            @PathVariable Long id) {

        return reportService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    // ---------------------------------------------------------
    // GET REPORTS BY MEDICAL RECORD
    // GET /api/reports/medical-record/{medicalRecordId}
    // ---------------------------------------------------------

    @GetMapping("/medical-record/{medicalRecordId}")
    public ResponseEntity<List<Report>> getReportsByMedicalRecord(
            @PathVariable Long medicalRecordId) {

        return ResponseEntity.ok(
                reportService.getReportsByMedicalRecord(
                        medicalRecordId
                )
        );
    }


    // ---------------------------------------------------------
    // GET REPORTS BY TYPE
    // GET /api/reports/type/{reportType}
    // ---------------------------------------------------------

    @GetMapping("/type/{reportType}")
    public ResponseEntity<List<Report>> getReportsByType(
            @PathVariable String reportType) {

        return ResponseEntity.ok(
                reportService.getReportsByType(reportType)
        );
    }


    // ---------------------------------------------------------
    // GET REPORTS BY UPLOADER
    // GET /api/reports/uploader/{uploadedBy}
    // ---------------------------------------------------------

    @GetMapping("/uploader/{uploadedBy}")
    public ResponseEntity<List<Report>> getReportsByUploader(
            @PathVariable String uploadedBy) {

        return ResponseEntity.ok(
                reportService.getReportsByUploader(uploadedBy)
        );
    }


    // ---------------------------------------------------------
    // UPDATE REPORT
    // PUT /api/reports/{id}
    // ---------------------------------------------------------

    @PutMapping("/{id}")
    public ResponseEntity<Report> updateReport(
            @PathVariable Long id,
            @RequestBody Report report) {

        Report updatedReport =
                reportService.updateReport(
                        id,
                        report
                );

        return ResponseEntity.ok(updatedReport);
    }


    // ---------------------------------------------------------
    // DELETE REPORT
    // DELETE /api/reports/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteReport(
            @PathVariable Long id) {

        reportService.deleteReport(id);

        return ResponseEntity.ok(
                "Report deleted successfully"
        );
    }
}
