public class Merit {
    private String meritId;
    private String studentId;
    private String activityId;
    private int points;

    public Merit() {}

    public String getMeritId() { return meritId; }
    public void setMeritId(String meritId) { this.meritId = meritId; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getActivityId() { return activityId; }
    public void setActivityId(String activityId) { this.activityId = activityId; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }
}
