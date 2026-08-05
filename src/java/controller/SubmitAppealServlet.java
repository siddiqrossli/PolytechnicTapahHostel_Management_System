package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.text.DecimalFormat; // For formatting ID
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.StudentAppeal;

public class SubmitAppealServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // --- Database Connection Details (Now duplicated here) ---
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish"; // Your database username
    private static final String DB_PASSWORD = "kakilangit"; // Your database password

    // Helper method to generate the next appeal ID (moved from DAO)
    private String generateNextAppealID() throws SQLException {
        String lastAppealID = null;
        String sql = "SELECT appealID FROM student_appeal ORDER BY appealID DESC LIMIT 1";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                lastAppealID = rs.getString("appealID");
            }
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found: " + e.getMessage(), e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                // Log this error, but don't rethrow as it's cleanup
                e.printStackTrace();
            }
        }

        if (lastAppealID == null || lastAppealID.isEmpty()) {
            return "APP001"; // First ID
        } else {
            int num = Integer.parseInt(lastAppealID.substring(3)); // Assumes "APP" prefix
            num++;
            DecimalFormat df = new DecimalFormat("000"); // Formats to 3 digits with leading zeros
            return "APP" + df.format(num);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp"); // Redirect to login if not authenticated
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String appealReason = request.getParameter("appealReason");

        if (appealReason == null || appealReason.isEmpty()) {
            request.setAttribute("message", "Appeal reason cannot be empty.");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("submitAppeal.jsp").forward(request, response);
            return;
        }

        // Create a new StudentAppeal object (appealID will be set after generation)
        StudentAppeal newAppeal = new StudentAppeal();
        newAppeal.setStudentID(studentId);
        newAppeal.setAppealReason(appealReason);
        newAppeal.setAppealDate(new Date(System.currentTimeMillis())); // Set current date
        newAppeal.setAppealStatus("Pending"); // Default status for new appeals

        Connection conn = null;
        PreparedStatement pstmt = null;
        String message = "";
        String messageType = "";

        try {
            // Generate the new appeal ID
            String generatedAppealID = generateNextAppealID();
            newAppeal.setAppealID(generatedAppealID); // Set the generated ID to the appeal object

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);

            String sql = "INSERT INTO student_appeal (appealID, studentID, reason, appealDate, appealStatus) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newAppeal.getAppealID());
            pstmt.setString(2, newAppeal.getStudentID());
            pstmt.setString(3, newAppeal.getAppealReason());
            pstmt.setDate(4, newAppeal.getAppealDate());
            pstmt.setString(5, newAppeal.getAppealStatus());

            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                message = "Appeal submitted successfully with ID: " + newAppeal.getAppealID();
                messageType = "success";
            } else {
                message = "Failed to submit appeal. Please try again.";
                messageType = "danger";
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "System Error: JDBC driver not found.";
            messageType = "danger";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database Error: " + e.getMessage();
            messageType = "danger";
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            // Redirect to the appeal list to show the newly submitted appeal
                         request.setAttribute("message", message);
                request.setAttribute("messageType", messageType);
                request.getRequestDispatcher("appealSubmitted.jsp").forward(request, response);

        }
    }
    
    // If you need a doGet for rendering the form, you can add it
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("submitAppeal.jsp").forward(request, response);
    }
}