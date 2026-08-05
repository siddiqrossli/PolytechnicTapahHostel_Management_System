package model;
public class Activity {
    private String activityId;
    private String name;
    private String description;
    private String date;

    public Activity() {}

    public String getActivityId() { return activityId; }
    public void setActivityId(String activityId) { this.activityId = activityId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getDate() { return date;}
    public void setDate(String date){this.date=date;}
}
