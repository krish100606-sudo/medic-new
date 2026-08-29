package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReportRepository extends JpaRepository<Report, Long> {

    // Find all reports belonging to a medical record
    List<Report> findByMedicalRecordId(Long medicalRecordId);

    // Find reports by report type
    List<Report> findByReportTypeIgnoreCase(String reportType);

    // Find reports uploaded by a particular person
    List<Report> findByUploadedByIgnoreCase(String uploadedBy);

    // Find reports belonging to a medical record and type
    List<Report> findByMedicalRecordIdAndReportTypeIgnoreCase(
            Long medicalRecordId,
            String reportType
    );
}
