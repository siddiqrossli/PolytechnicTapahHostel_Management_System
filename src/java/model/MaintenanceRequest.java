package model;

import java.sql.Date; // Using java.sql.Date for direct compatibility with JDBC

public class MaintenanceRequest {
    private String mainID; // Now String, no mainIDRaw
    private String mainCat;
    private String mainDescription;
    private Date mainDate; // Using java.sql.Date
    private String mainStatus;
    private String staffID; // Reflects your current field name
    private String studentID;
    private String roomID;

    // Fields for staff details
    private String staffName;
    private String staffNumber;

    // MISSING FIELD - ADD THIS ONE
    private String studentName; // <--- ADD THIS FIELD

    public MaintenanceRequest() {
        // Default constructor
    }

    // Constructor with all fields (including studentName now)
    public MaintenanceRequest(String mainID, String mainCat, String mainDescription, Date mainDate, String mainStatus,
                              String staffID, String studentID, String roomID, String staffName, String staffNumber,
                              String studentName) { // <--- ADD studentName to constructor
        this.mainID = mainID;
        this.mainCat = mainCat;
        this.mainDescription = mainDescription;
        this.mainDate = mainDate;
        this.mainStatus = mainStatus;
        this.staffID = staffID;
        this.studentID = studentID;
        this.roomID = roomID;
        this.staffName = staffName;
        this.staffNumber = staffNumber;
        this.studentName = studentName; // <--- Set studentName in constructor
    }

    // --- Getters and Setters ---

    public String getMainID() {
        return mainID;
    }

    public void setMainID(String mainID) {
        this.mainID = mainID;
    }

    public String getMainCat() {
        return mainCat;
    }

    public void setMainCat(String mainCat) {
        this.mainCat = mainCat;
    }

    public String getMainDescription() {
        return mainDescription;
    }

    public void setMainDescription(String mainDescription) {
        this.mainDescription = mainDescription;
    }

    public Date getMainDate() {
        return mainDate;
    }

    public void setMainDate(Date mainDate) {
        this.mainDate = mainDate;
    }

    public String getMainStatus() {
        return mainStatus;
    }

    public void setMainStatus(String mainStatus) {
        this.mainStatus = mainStatus;
    }

    public String getStaffID() {
        return staffID;
    }

    public void setStaffID(String staffID) {
        this.staffID = staffID;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public String getRoomID() {
        return roomID;
    }

    public void setRoomID(String roomID) {
        this.roomID = roomID;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getStaffNumber() {
        return staffNumber;
    }

    public void setStaffNumber(String staffNumber) {
        this.staffNumber = staffNumber;
    }

    // NEW GETTER AND SETTER - ADD THESE ONES
    public String getStudentName() { // <--- ADD THIS METHOD
        return studentName;
    }

    public void setStudentName(String studentName) { // <--- ADD THIS METHOD
        this.studentName = studentName;
    }
}