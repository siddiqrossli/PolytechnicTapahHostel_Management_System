// Assuming your Bill.java looks something like this:
package model; // Ensure this matches your actual package

public class Bill {
    private int billNo; // The primary key, auto-incremented by DB (still exists)
    private String billName;
    private double billAmount;
    private String paymentStatus;
    private String studentID;
    private int billSequencePerStudent; // NEW FIELD FOR STUDENT-SPECIFIC BILL NUMBER

    // Constructor (update to include the new field)
    public Bill(int billNo, String billName, double billAmount, String paymentStatus, String studentID, int billSequencePerStudent) {
        this.billNo = billNo;
        this.billName = billName;
        this.billAmount = billAmount;
        this.paymentStatus = paymentStatus;
        this.studentID = studentID;
        this.billSequencePerStudent = billSequencePerStudent; // Initialize new field
    }

    // Getters and Setters for all fields
    public int getBillNo() {
        return billNo;
    }

    public void setBillNo(int billNo) {
        this.billNo = billNo;
    }

    public String getBillName() {
        return billName;
    }

    public void setBillName(String billName) {
        this.billName = billName;
    }

    public double getBillAmount() {
        return billAmount;
    }

    public void setBillAmount(double billAmount) {
        this.billAmount = billAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    // NEW GETTER AND SETTER
    public int getBillSequencePerStudent() {
        return billSequencePerStudent;
    }

    public void setBillSequencePerStudent(int billSequencePerStudent) {
        this.billSequencePerStudent = billSequencePerStudent;
    }
}