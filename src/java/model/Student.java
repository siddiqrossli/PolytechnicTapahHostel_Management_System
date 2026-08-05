package model;

public class Student {
    private String studentId;
    private String password;
    private String name;
    private String phone;
    private String emergencyContact;
    private int semester;
    private String cgpa;
    private String houseIncome;
    private String gender;
    private String roomId;

    // Getters and Setters
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmergencyContact() { return emergencyContact; }
    public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public String getCgpa() { return cgpa; }
    public void setCgpa(String cgpa) { this.cgpa = cgpa; }

    public String getHouseIncome() { return houseIncome; }
    public void setHouseIncome(String houseIncome) { this.houseIncome = houseIncome; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getRoomId() { return roomId; }
    public void setRoomId(String roomId) { this.roomId = roomId; }
}
