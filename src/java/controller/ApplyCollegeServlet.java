package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class ApplyCollegeServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        PreparedStatement roomStmt = null; // Declare outside try for finally block
        ResultSet roomRs = null; // Declare outside try for finally block

        double totalMerit = 0.0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);
            
            // 0. Check if student already has a room
            String checkRoomSql = "SELECT roomID FROM student WHERE studentID = ?";
            roomStmt = conn.prepareStatement(checkRoomSql);
            roomStmt.setString(1, studentId);
            roomRs = roomStmt.executeQuery();

            if (roomRs.next()) {
                String roomId = roomRs.getString("roomID");
                if (roomId != null && !roomId.trim().isEmpty()) {
                    request.setAttribute("assignedRoomId", roomId); 

                    // --- CORRECTED CODE: Fetch Block Name using JOIN ---
                    String blockName = "N/A"; // Default value if not found
                    String roomDetailsSql = "SELECT cb.blockName " +
                                            "FROM rooms r " +
                                            "JOIN collegeblocks cb ON r.blockID = cb.blockID " +
                                            "WHERE r.roomID = ?";
                    
                    PreparedStatement blockStmt = null;
                    ResultSet blockRs = null;
                    try {
                        blockStmt = conn.prepareStatement(roomDetailsSql);
                        blockStmt.setString(1, roomId);
                        blockRs = blockStmt.executeQuery();
                        if (blockRs.next()) {
                            blockName = blockRs.getString("blockName");
                        }
                    } finally {
                        if (blockRs != null) try { blockRs.close(); } catch (SQLException e) { /* log or ignore */ }
                        if (blockStmt != null) try { blockStmt.close(); } catch (SQLException e) { /* log or ignore */ }
                    }
                    request.setAttribute("assignedBlockName", blockName); // Set the block name attribute
                    // --- END CORRECTED CODE ---

                    request.getRequestDispatcher("alreadyAssigned.jsp").forward(request, response);
                    return;
                }
            }

            // Close roomStmt and roomRs here as they are no longer needed
            if (roomRs != null) roomRs.close();
            if (roomStmt != null) roomStmt.close();

            // ... (rest of your doGet method remains the same) ...

            // 1. Check if student has submitted an appeal
            String appealSql = "SELECT appealStatus,appealID FROM student_appeal WHERE studentID = ? ORDER BY appealDate DESC LIMIT 1";
            pstmt = conn.prepareStatement(appealSql);
            pstmt.setString(1, studentId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String status = rs.getString("appealStatus");
                String appealID = rs.getString("appealID");
                session.setAttribute("appealID", appealID);

                if (status.equalsIgnoreCase("approved")) {
                    response.sendRedirect("RoomBookingServlet");
                    return;
                } else if (status.equalsIgnoreCase("rejected")) {
                    request.setAttribute("appealResult", "Your appeal was rejected. Please contact the hostel office for more info.");
                    
                    request.getRequestDispatcher("appealResult.jsp").forward(request, response);
                    return;
                } else if (status.equalsIgnoreCase("pending")) {
                    request.setAttribute("appealResult", "Your appeal is still under review. Please check back later.");
                    request.getRequestDispatcher("appealResult.jsp").forward(request, response);
                    return;
                }
            }

            // 2. No appeal found, proceed to check merit
            rs.close();
            pstmt.close();

            String meritSql = "SELECT SUM(a.actMerit) AS totalMerit " +
                                  "FROM merit m " +
                                  "JOIN activity a ON m.activityID = a.activityID " +
                                  "WHERE m.studentID = ?";
            pstmt = conn.prepareStatement(meritSql);
            pstmt.setString(1, studentId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalMerit = rs.getDouble("totalMerit");
            }

            // 3. Fetch student info for appeal form
            String studentSql = "SELECT studName, studNumber, studCGPA FROM student WHERE studentID = ?";
            PreparedStatement studentStmt = conn.prepareStatement(studentSql);
            studentStmt.setString(1, studentId);
            ResultSet studentRs = studentStmt.executeQuery();

            if (studentRs.next()) {
                request.setAttribute("studName", studentRs.getString("studName"));
                request.setAttribute("studNumber", studentRs.getString("studNumber"));
                request.setAttribute("studCGPA", studentRs.getString("studCGPA"));
            }

            request.setAttribute("studentId", studentId);
            request.setAttribute("totalMerit", totalMerit);

            if (totalMerit >= 5.5) {
                response.sendRedirect("RoomBookingServlet");
            } else {
                request.getRequestDispatcher("submitAppeal.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (roomRs != null) roomRs.close(); } catch (Exception e) {} // Close roomRs here
            try { if (roomStmt != null) roomStmt.close(); } catch (Exception e) {} // Close roomStmt here
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}