package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.MaintenanceRequest;

@WebServlet("/viewMaintenanceStatus")
public class ViewMaintenanceStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the session exists and user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");

        List<MaintenanceRequest> maintenanceRequests = new ArrayList<>();

        try (
            // Load the JDBC driver and establish connection
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);
            PreparedStatement pstmt = conn.prepareStatement(
                "SELECT m.mainID, m.mainCat, m.mainDescription, m.mainDate, m.mainStatus, " +
                "s.staffName, s.staffNumber " +
                "FROM maintenance m " +
                "LEFT JOIN staff s ON m.staffID = s.staffID " +
                "WHERE m.studentID = ? " +
                "ORDER BY m.mainDate DESC");
        ) {
            Class.forName("com.mysql.cj.jdbc.Driver"); // load driver
            
            pstmt.setString(1, studentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MaintenanceRequest req = new MaintenanceRequest();

                    // Format mainID with prefix "MAT" and 3 digit number
                    req.setMainID(String.format("MAT%03d", rs.getInt("mainID")));
                    req.setMainCat(rs.getString("mainCat"));
                    req.setMainDescription(rs.getString("mainDescription"));

                    // Convert java.sql.Date to java.util.Date for easier JSP handling
                    java.sql.Date sqlDate = rs.getDate("mainDate");
                    if (sqlDate != null) {
                        req.setMainDate(rs.getDate("mainDate"));
                    } else {
                        req.setMainDate(null);
                    }

                    req.setStaffName(rs.getString("staffName"));
                    req.setStaffNumber(rs.getString("staffNumber"));
                    req.setMainStatus(rs.getString("mainStatus"));

                    maintenanceRequests.add(req);
                }
            }

            // Set list in request scope and forward to JSP
            request.setAttribute("maintenanceRequests", maintenanceRequests);
            request.getRequestDispatcher("viewMaintenanceStatus.jsp").forward(request, response);

        } catch (ClassNotFoundException e) {
            // Handle JDBC driver error
            e.printStackTrace();
            request.setAttribute("message", "JDBC Driver not found.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("viewMaintenanceStatus.jsp").forward(request, response);

        } catch (SQLException e) {
            // Handle database errors
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("viewMaintenanceStatus.jsp").forward(request, response);
        }
    }
}
