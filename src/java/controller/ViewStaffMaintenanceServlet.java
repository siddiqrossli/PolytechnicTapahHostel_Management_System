package controller;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.MaintenanceRequest;

@WebServlet("/viewStaffMaintenance")
public class ViewStaffMaintenanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            // Redirect to staff login page if no session or staffID
            response.sendRedirect("staffLogin.jsp");
            return;
        }

        String staffId = (String) session.getAttribute("staffId");

        // Transfer any message from session to request scope (for showing after redirect)
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");
        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }

        List<MaintenanceRequest> maintenanceRequests = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);
                 PreparedStatement pstmt = conn.prepareStatement(
                         "SELECT m.mainID, m.mainCat, m.mainDescription, m.mainDate, m.mainStatus, " +
                         "m.studentID, m.roomID, " +
                         "st.studName, " +
                         "s.staffID, s.staffName, s.staffNumber " +
                         "FROM maintenance m " +
                         "LEFT JOIN student st ON m.studentID = st.studentID " +
                         "LEFT JOIN staff s ON m.staffID = s.staffID " +
                         "WHERE m.staffID = ? " +
                         "ORDER BY m.mainDate DESC"
                 )) {

                pstmt.setString(1, staffId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        MaintenanceRequest req = new MaintenanceRequest();

                        req.setMainID(rs.getString("mainID"));
                        req.setMainCat(rs.getString("mainCat"));
                        req.setMainDescription(rs.getString("mainDescription"));

                        // Convert SQL Date to java.util.Date if needed
                        Date sqlDate = rs.getDate("mainDate");
                        if (sqlDate != null) {
                            req.setMainDate(rs.getDate("mainDate"));
                        } else {
                            req.setMainDate(null);
                        }

                        req.setMainStatus(rs.getString("mainStatus"));
                        req.setStudentID(rs.getString("studentID"));
                        req.setStudentName(rs.getString("studName"));
                        req.setRoomID(rs.getString("roomID"));
                        req.setStaffID(rs.getString("staffID"));
                        req.setStaffName(rs.getString("staffName"));
                        req.setStaffNumber(rs.getString("staffNumber"));

                        maintenanceRequests.add(req);
                    }
                }
            }

            request.setAttribute("maintenanceRequests", maintenanceRequests);
            request.getRequestDispatcher("viewStaffMaintenance.jsp").forward(request, response);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("message", "JDBC Driver not found.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("viewStaffMaintenance.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("viewStaffMaintenance.jsp").forward(request, response);
        }
    }
}
