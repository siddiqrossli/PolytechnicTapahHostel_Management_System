package model;

import java.sql.Date;

public class StudentAppeal {
    private String appealID; // Changed to String
    private String studentID;
    private String studName;
    private String studNumber;
    private double studCGPA;
    private double houseIncome;

    private String appealReason;
    private Date appealDate;
    private String appealStatus;

    public StudentAppeal() {
    }

    // Constructor updated to reflect String appealID
    public StudentAppeal(String appealID, String studentID, String studName, String studNumber, double studCGPA, double houseIncome, String appealReason, Date appealDate, String appealStatus) {
        this.appealID = appealID;
        this.studentID = studentID;
        this.studName = studName;
        this.studNumber = studNumber;
        this.studCGPA = studCGPA;
        this.houseIncome = houseIncome;
        this.appealReason = appealReason;
        this.appealDate = appealDate;
        this.appealStatus = appealStatus;
    }

    // --- Getters and Setters ---

    public String getAppealID() { // Getter for appealID
        return appealID;
    }

    public void setAppealID(String appealID) { // Setter for appealID
        this.appealID = appealID;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public String getStudName() {
        return studName;
    }

    public void setStudName(String studName) {
        this.studName = studName;
    }

    public String getStudNumber() {
        return studNumber;
    }

    public void setStudNumber(String studNumber) {
        this.studNumber = studNumber;
    }

    public double getStudCGPA() {
        return studCGPA;
    }

    public void setStudCGPA(double studCGPA) {
        this.studCGPA = studCGPA;
    }

    public double getHouseIncome() {
        return houseIncome;
    }

    public void setHouseIncome(double houseIncome) {
        this.houseIncome = houseIncome;
    }

    public String getAppealReason() {
        return appealReason;
    }

    public void setAppealReason(String appealReason) {
        this.appealReason = appealReason;
    }

    public Date getAppealDate() {
        return appealDate;
    }

    public void setAppealDate(Date appealDate) {
        this.appealDate = appealDate;
    }

    public String getAppealStatus() {
        return appealStatus;
    }

    public void setAppealStatus(String appealStatus) {
        this.appealStatus = appealStatus;
    }
}