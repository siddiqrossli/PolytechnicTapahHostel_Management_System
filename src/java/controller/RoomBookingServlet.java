package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class RoomBookingServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Get gender of logged-in student
            String gender = null;
            if (studentId != null) {
                String genderSql = "SELECT studGender FROM student WHERE studentID = ?";
                try (PreparedStatement genderStmt = conn.prepareStatement(genderSql)) {
                    genderStmt.setString(1, studentId);
                    try (ResultSet genderRs = genderStmt.executeQuery()) {
                        if (genderRs.next()) {
                            gender = genderRs.getString("studGender");
                        }
                    }
                }
            }

            // Load filtered room IDs based on gender and capacity
            List<String> roomIds = new ArrayList<>();
            String roomSql = "";
            if ("Male".equalsIgnoreCase(gender)) {
                roomSql = "SELECT r.roomID FROM rooms r WHERE r.roomID LIKE 'HT%' AND r.roomCapacity > 0";
            } else if ("Female".equalsIgnoreCase(gender)) {
                roomSql = "SELECT r.roomID FROM rooms r WHERE r.roomID LIKE 'TF%' AND r.roomCapacity > 0";
            }
            
            if (!roomSql.isEmpty()) {
                try (PreparedStatement stmt = conn.prepareStatement(roomSql)) {
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            roomIds.add(rs.getString("roomID"));
                        }
                    }
                }
            }

            request.setAttribute("roomList", roomIds);
            request.getRequestDispatcher("roomBooking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedRoomId = request.getParameter("roomID");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn.setAutoCommit(false); // Start transaction

            try {
                // Get student gender
                String gender = null;
                if (studentId != null) {
                    String genderSql = "SELECT studGender FROM student WHERE studentID = ?";
                    try (PreparedStatement genderStmt = conn.prepareStatement(genderSql)) {
                        genderStmt.setString(1, studentId);
                        try (ResultSet genderRs = genderStmt.executeQuery()) {
                            if (genderRs.next()) {
                                gender = genderRs.getString("studGender");
                            }
                        }
                    }
                }

                // Filter room list based on gender and capacity
                List<String> roomIds = new ArrayList<>();
                String roomSql = "";
                if ("Male".equalsIgnoreCase(gender)) {
                    roomSql = "SELECT r.roomID FROM rooms r WHERE r.roomID LIKE 'HT%' AND r.roomCapacity > 0";
                } else if ("Female".equalsIgnoreCase(gender)) {
                    roomSql = "SELECT r.roomID FROM rooms r WHERE r.roomID LIKE 'TF%' AND r.roomCapacity > 0";
                }
                
                if (!roomSql.isEmpty()) {
                    try (PreparedStatement stmt = conn.prepareStatement(roomSql)) {
                        try (ResultSet rs = stmt.executeQuery()) {
                            while (rs.next()) {
                                roomIds.add(rs.getString("roomID"));
                            }
                        }
                    }
                }
                request.setAttribute("roomList", roomIds);
                request.setAttribute("selectedRoomId", selectedRoomId);

                // Get current room capacity and status
                int currentCapacity = 0;
                String currentStatus = "";
                if (selectedRoomId != null) {
                    try (PreparedStatement roomStmt = conn.prepareStatement(
                        "SELECT roomCapacity, roomStatus FROM rooms WHERE roomID = ?")) {
                        roomStmt.setString(1, selectedRoomId);
                        try (ResultSet roomRs = roomStmt.executeQuery()) {
                            if (roomRs.next()) {
                                currentCapacity = roomRs.getInt("roomCapacity");
                                currentStatus = roomRs.getString("roomStatus");
                            }
                        }
                    }
                }

                // Get current occupants
                List<String> occupants = new ArrayList<>();
                if (selectedRoomId != null) {
                    try (PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT studName FROM student WHERE roomID = ?")) {
                        pstmt.setString(1, selectedRoomId);
                        try (ResultSet studentRs = pstmt.executeQuery()) {
                            while (studentRs.next()) {
                                occupants.add(studentRs.getString("studName"));
                            }
                        }
                    }
                    request.setAttribute("occupants", occupants);
                }

                if ("submit".equals(action) && studentId != null && selectedRoomId != null) {
                    // Check if student already has a room
                    String currentRoomId = null;
                    try (PreparedStatement checkExistingRoomStmt = conn.prepareStatement(
                        "SELECT roomID FROM student WHERE studentID = ?")) {
                        checkExistingRoomStmt.setString(1, studentId);
                        try (ResultSet existingRoomRs = checkExistingRoomStmt.executeQuery()) {
                            if (existingRoomRs.next()) {
                                currentRoomId = existingRoomRs.getString("roomID");
                            }
                        }
                    }

                    if (currentRoomId != null && !currentRoomId.trim().isEmpty()) {
                        request.setAttribute("error", "You have already booked a room (Room " + currentRoomId + ").");
                    } else if (currentCapacity <= 0) {
                        request.setAttribute("error", "This room is already full.");
                    } else {
                        // Update student with room ID
                        String updateSql = "UPDATE student SET roomID = ? WHERE studentID = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setString(1, selectedRoomId);
                            updateStmt.setString(2, studentId);
                            int updatedRows = updateStmt.executeUpdate();

                            if (updatedRows > 0) {
                                // Decrease room capacity by 1
                                int newCapacity = currentCapacity - 1;
                                String newStatus = newCapacity + " space" + (newCapacity != 1 ? "s" : "") + " left";
                                
                                String updateRoomSql = "UPDATE rooms SET roomCapacity = ?, roomStatus = ? WHERE roomID = ?";
                                try (PreparedStatement updateRoomStmt = conn.prepareStatement(updateRoomSql)) {
                                    updateRoomStmt.setInt(1, newCapacity);
                                    updateRoomStmt.setString(2, newStatus);
                                    updateRoomStmt.setString(3, selectedRoomId);
                                    updateRoomStmt.executeUpdate();
                                }

                                // Get the next available bill number (auto-increment or max+1)
                                int nextBillNo = 1;
                                try (PreparedStatement getMaxBillNoStmt = conn.prepareStatement(
                                    "SELECT MAX(billNo) AS maxBillNo FROM bills")) {
                                    try (ResultSet rsMaxBillNo = getMaxBillNoStmt.executeQuery()) {
                                        if (rsMaxBillNo.next()) {
                                            nextBillNo = rsMaxBillNo.getInt("maxBillNo") + 1;
                                        }
                                    }
                                }

                                // Insert Room Booking Fee if doesn't exist
                                try (PreparedStatement checkRoomBillStmt = conn.prepareStatement(
                                    "SELECT COUNT(*) FROM bills WHERE studentID = ? AND billName = 'College Fee'")) {
                                    checkRoomBillStmt.setString(1, studentId);
                                    try (ResultSet rs = checkRoomBillStmt.executeQuery()) {
                                        rs.next();
                                        if (rs.getInt(1) == 0) {
                                            String roomBillSql = "INSERT INTO bills (billNo, billName, billAmount, paymentStatus, studentID, billSequencePerStudent) " +
                                                                "VALUES (?, 'College Fee', 520.00, 'Unpaid', ?, 1)";
                                            try (PreparedStatement roomBillStmt = conn.prepareStatement(roomBillSql)) {
                                                roomBillStmt.setInt(1, nextBillNo++);
                                                roomBillStmt.setString(2, studentId);
                                                roomBillStmt.executeUpdate();
                                            }
                                        }
                                    }
                                }

                                // Insert Electric Appliances Fee if doesn't exist
                                try (PreparedStatement checkElectricBillStmt = conn.prepareStatement(
                                    "SELECT COUNT(*) FROM bills WHERE studentID = ? AND billName = 'Electric Appliances Fee'")) {
                                    checkElectricBillStmt.setString(1, studentId);
                                    try (ResultSet rs = checkElectricBillStmt.executeQuery()) {
                                        rs.next();
                                        if (rs.getInt(1) == 0) {
                                            String electricBillSql = "INSERT INTO bills (billNo, billName, billAmount, paymentStatus, studentID, billSequencePerStudent) " +
                                                                   "VALUES (?, 'Electric Appliances Fee', 10.00, 'Unpaid', ?, 2)";
                                            try (PreparedStatement electricBillStmt = conn.prepareStatement(electricBillSql)) {
                                                electricBillStmt.setInt(1, nextBillNo);
                                                electricBillStmt.setString(2, studentId);
                                                electricBillStmt.executeUpdate();
                                            }
                                        }
                                    }
                                }

                                conn.commit(); // Commit transaction if all operations succeed
                                request.setAttribute("message", "Room successfully booked and bills generated!");
                                
                                // Refresh the room list to exclude the now-full room
                                roomIds.remove(selectedRoomId);
                                request.setAttribute("roomList", roomIds);
                            }
                        }
                    }
                }
                
                request.getRequestDispatcher("roomBooking.jsp").forward(request, response);
                
            } catch (Exception e) {
                conn.rollback(); // Rollback transaction if any error occurs
                throw e;
            } finally {
                conn.setAutoCommit(true); // Reset auto-commit mode
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}