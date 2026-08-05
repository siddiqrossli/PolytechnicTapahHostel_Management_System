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

@WebServlet("/updateStaffProfile")
public class UpdateStaffProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish"; // Your database username
    private static final String DB_PASSWORD = "kakilangit"; // The password for the 'farish' user

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect("staffLogin.jsp");
            return;
        }

        String staffId = (String) session.getAttribute("staffId");
        String staffName = request.getParameter("staffName");

// Validate that staffName is not null or empty
    if (staffName == null || staffName.trim().isEmpty()) {
        request.setAttribute("message", "Full Name is required!");
        request.setAttribute("messageType", "error");
        request.getRequestDispatcher("updateStaffProfile.jsp").forward(request, response);
        return; // Stop execution
    }
        
        String staffNumber = request.getParameter("staffNumber");
        String staffEmail = request.getParameter("staffEmail");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);

            String sql = "UPDATE staff SET staffName = ?, staffNumber = ?, staffEmail = ? WHERE staffID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, staffName);
            pstmt.setString(2, staffNumber);
            pstmt.setString(3, staffEmail);
            pstmt.setString(4, staffId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Update session attributes if the update was successful
                session.setAttribute("staffName", staffName);
                request.setAttribute("message", "Profile updated successfully!");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Failed to update profile. Staff ID not found or no changes made.");
                request.setAttribute("messageType", "error");
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("message", "JDBC Driver not found.");
            request.setAttribute("messageType", "error");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        // Always forward back to the JSP to display current data and messages
        request.getRequestDispatcher("updateStaffProfile.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Just forward to doPost, as the JSP handles fetching initial data
        doPost(request, response);
    }
}