package model;
public class CollegeBuilding {
    private String blockId;
    private String name;
    private int totalRooms;

    public CollegeBuilding() {}

    public String getBlockId() { return blockId; }
    public void setBlockId(String blockId) { this.blockId = blockId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int totalRooms) { this.totalRooms = totalRooms; }
}
