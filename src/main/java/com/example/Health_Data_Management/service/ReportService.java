package com.example.Health_Data_Management.service;


import com.example.Health_Data_Management.entity.MedicalRecord;
import com.example.Health_Data_Management.entity.Report;
import com.example.Health_Data_Management.repository.MedicalRecordRepository;
import com.example.Health_Data_Management.repository.ReportRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ReportService {

    private final ReportRepository reportRepository;
    private final MedicalRecordRepository medicalRecordRepository;

    public ReportService(
            ReportRepository reportRepository,
            MedicalRecordRepository medicalRecordRepository) {

        this.reportRepository = reportRepository;
        this.medicalRecordRepository = medicalRecordRepository;
    }


    // ---------------------------------------------------------
    // CREATE REPORT
    // ---------------------------------------------------------

    public Report createReport(
            Long medicalRecordId,
            Report report) {

        MedicalRecord medicalRecord =
                medicalRecordRepository.findById(medicalRecordId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Medical record not found"
                                )
                        );

        report.setMedicalRecord(medicalRecord);

        return reportRepository.save(report);
    }


    // ---------------------------------------------------------
    // GET REPORT BY ID
    // ---------------------------------------------------------

    public Optional<Report> findById(Long id) {

        return reportRepository.findById(id);
    }


    // ---------------------------------------------------------
    // GET ALL REPORTS
    // ---------------------------------------------------------

    public List<Report> getAllReports() {

        return reportRepository.findAll();
    }


    // ---------------------------------------------------------
    // GET REPORTS OF A MEDICAL RECORD
    // ---------------------------------------------------------

    public List<Report> getReportsByMedicalRecord(
            Long medicalRecordId) {

        return reportRepository
                .findByMedicalRecordId(medicalRecordId);
    }


    // ---------------------------------------------------------
    // GET REPORTS BY TYPE
    // ---------------------------------------------------------

    public List<Report> getReportsByType(
            String reportType) {

        return reportRepository
                .findByReportTypeIgnoreCase(reportType);
    }


    // ---------------------------------------------------------
    // GET REPORTS BY UPLOADER
    // ---------------------------------------------------------

    public List<Report> getReportsByUploader(
            String uploadedBy) {

        return reportRepository
                .findByUploadedByIgnoreCase(uploadedBy);
    }


    // ---------------------------------------------------------
    // UPDATE REPORT
    // ---------------------------------------------------------

    public Report updateReport(
            Long id,
            Report updatedReport) {

        Report report =
                reportRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Report not found"
                                )
                        );

        report.setReportName(
                updatedReport.getReportName()
        );

        report.setReportType(
                updatedReport.getReportType()
        );

        report.setDescription(
                updatedReport.getDescription()
        );

        report.setFileName(
                updatedReport.getFileName()
        );

        report.setFilePath(
                updatedReport.getFilePath()
        );

        report.setUploadedBy(
                updatedReport.getUploadedBy()
        );

        return reportRepository.save(report);
    }


    // ---------------------------------------------------------
    // DELETE REPORT
    // ---------------------------------------------------------

    public void deleteReport(Long id) {

        if (!reportRepository.existsById(id)) {

            throw new RuntimeException(
                    "Report not found"
            );
        }

        reportRepository.deleteById(id);
    }
}
