package com.example.Health_Data_Management.entity;



import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "reports")
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ---------------------------------------------------------
    // MEDICAL RECORD
    // ---------------------------------------------------------

    @ManyToOne
    @JoinColumn(name = "medical_record_id", nullable = false)
    private MedicalRecord medicalRecord;


    // ---------------------------------------------------------
    // REPORT INFORMATION
    // ---------------------------------------------------------

    @Column(name = "report_name", nullable = false)
    private String reportName;

    @Column(name = "report_type")
    private String reportType;

    @Column(name = "description", length = 3000)
    private String description;

    @Column(name = "file_name")
    private String fileName;

    @Column(name = "file_path")
    private String filePath;


    // ---------------------------------------------------------
    // UPLOADED BY
    // ---------------------------------------------------------

    @Column(name = "uploaded_by")
    private String uploadedBy;


    // ---------------------------------------------------------
    // TIMESTAMP
    // ---------------------------------------------------------

    @Column(name = "uploaded_at", nullable = false)
    private LocalDateTime uploadedAt;


    // ---------------------------------------------------------
    // CONSTRUCTOR
    // ---------------------------------------------------------

    public Report() {
    }


    // ---------------------------------------------------------
    // PRE-PERSIST
    // ---------------------------------------------------------

    @PrePersist
    protected void onCreate() {

        if (uploadedAt == null) {
            uploadedAt = LocalDateTime.now();
        }
    }


    // ---------------------------------------------------------
    // GETTERS AND SETTERS
    // ---------------------------------------------------------

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public MedicalRecord getMedicalRecord() {
        return medicalRecord;
    }

    public void setMedicalRecord(
            MedicalRecord medicalRecord) {

        this.medicalRecord = medicalRecord;
    }


    public String getReportName() {
        return reportName;
    }

    public void setReportName(String reportName) {
        this.reportName = reportName;
    }


    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }


    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }


    public String getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(String uploadedBy) {
        this.uploadedBy = uploadedBy;
    }


    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
