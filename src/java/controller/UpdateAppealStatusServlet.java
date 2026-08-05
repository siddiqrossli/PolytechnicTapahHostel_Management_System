package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// No import for dao.StudentAppealDAO needed anymore

public class UpdateAppealStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // --- Database Connection Details (Now duplicated here) ---
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish"; // Your database username
    private static final String DB_PASSWORD = "kakilangit"; // Your database password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect("staffLogin.jsp"); // Redirect to staff login if not authenticated
            return;
        }

        String appealID = request.getParameter("appealID");
        String newStatus = request.getParameter("newStatus");

        if (appealID == null || appealID.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            String errorMessage = "Error: Missing appeal ID or new status. Please try again.";
            response.sendRedirect(request.getContextPath() + "/ViewAppealServlet?message=" + 
                                  java.net.URLEncoder.encode(errorMessage, "UTF-8") + 
                                  "&messageType=danger");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        String message = "";
        String messageType = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);

            String sql = "UPDATE student_appeal SET appealStatus = ? WHERE appealID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setString(2, appealID);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                message = "Appeal " + appealID + " status updated to " + newStatus + " successfully.";
                messageType = "success";
            } else {
                message = "Failed to update status for Appeal " + appealID + ". It might not exist or the status is already " + newStatus + ".";
                messageType = "danger";
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "System Error: JDBC driver not found.";
            messageType = "danger";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error updating appeal status: " + e.getMessage();
            messageType = "danger";
        } finally {
            // Close JDBC resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            // Redirect back to the ViewAppealServlet
            response.sendRedirect(request.getContextPath() + "/ViewAppealServlet?message=" + 
                                  java.net.URLEncoder.encode(message, "UTF-8") + 
                                  "&messageType=" + 
                                  java.net.URLEncoder.encode(messageType, "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/ViewAppealServlet");
    }
}