package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/roomList")
public class RoomListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final int MAX_CAPACITY = 4; // Maximum beds per room
    private final int ROOMS_PER_PAGE = 10; // Increased to 15 rooms per page

    private final String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private final String jdbcUsername = "farish";
    private final String jdbcPassword = "kakilangit";

    public static class Room {
        private String roomID;
        private int availableSpaces;
        private int maxCapacity;

        public Room(String roomID, int availableSpaces, int maxCapacity) {
            this.roomID = roomID;
            this.availableSpaces = availableSpaces;
            this.maxCapacity = maxCapacity;
        }

        public String getRoomID() { return roomID; }
        public int getAvailableSpaces() { return availableSpaces; }

        public String getStatus() {
            if (availableSpaces <= 0) {
                return "Fully Booked";
            } else {
                return availableSpaces + " space" + (availableSpaces != 1 ? "s" : "") + " left";
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         HttpSession session = request.getSession();
            String staffPosition = (String) session.getAttribute("staffPosition");
        
        String collegePrefix = request.getParameter("college");
        if (collegePrefix == null) {
            collegePrefix = "HT"; // Default to Hang Tuah
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Default to page 1 if invalid page number
        }

        ArrayList<Room> rooms = new ArrayList<>();
        int totalRooms = 0;
        int totalPages = 1;

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            // Get total count of rooms
            String countSql = "SELECT COUNT(*) FROM rooms WHERE roomID LIKE ?";
            try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                countStmt.setString(1, collegePrefix + "%");
                ResultSet countRs = countStmt.executeQuery();
                if (countRs.next()) {
                    totalRooms = countRs.getInt(1);
                    totalPages = (int) Math.ceil((double) totalRooms / ROOMS_PER_PAGE);
                    
                    // Ensure page number is within valid range
                    if (page < 1) page = 1;
                    if (page > totalPages) page = totalPages;
                }
            }

            // Get rooms for current page
            String roomSql = "SELECT roomID, roomCapacity FROM rooms WHERE roomID LIKE ? ORDER BY roomID LIMIT ? OFFSET ?";
            try (PreparedStatement stmt = conn.prepareStatement(roomSql)) {
                stmt.setString(1, collegePrefix + "%");
                stmt.setInt(2, ROOMS_PER_PAGE);
                stmt.setInt(3, (page - 1) * ROOMS_PER_PAGE);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    String roomID = rs.getString("roomID");
                    int availableSpaces = rs.getInt("roomCapacity");
                    rooms.add(new Room(roomID, availableSpaces, MAX_CAPACITY));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("rooms", rooms);
        request.setAttribute("college", collegePrefix);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
            
        if ("Staff".equalsIgnoreCase(staffPosition)) {
                            request.getRequestDispatcher("roomList.jsp").forward(request, response);
                        } else {
                            request.getRequestDispatcher("otherRoomList.jsp").forward(request, response);

                        }
        
    }
}