package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/updateProfile") // Map this servlet to /updateProfile URL
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Database connection details (consider moving these to a separate utility class for reusability)
    private String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private String jdbcUsername = "farish"; // Your database user
    private String jdbcPassword = "kakilangit"; // Password for 'farish' user

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Do not create a new session if one doesn't exist

        System.out.println("--- UpdateProfileServlet doGet Debug Start ---");
        System.out.println("Session ID: " + (session != null ? session.getId() : "NULL (No active session)"));

        if (session == null || session.getAttribute("studentId") == null) {
            System.out.println("Session is NULL or studentId not found in session. Redirecting to login.jsp.");
            response.sendRedirect("login.jsp"); // If user is not logged in, redirect to login page
            System.out.println("--- UpdateProfileServlet doGet Debug End (Redirected) ---");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        System.out.println("Student ID from session: " + studentId);

        // Always set studentId as a request attribute, even if it's also in session.
        // JSP will pick it up from requestScope first.
        request.setAttribute("studentId", studentId);

        // *** ADD THIS LINE FOR ACTIVE NAVIGATION ***
        request.setAttribute("currentPage", "updateProfile"); // Set this to identify the current page for navigation highlighting
        // *****************************************

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            System.out.println("Database connection established for fetching profile data.");

            // SQL to fetch student details. Columns should match your 'student' table
            String sql = "SELECT studName, studNumber, studEmergencyNumber FROM student WHERE studentID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            System.out.println("Executing SQL query: " + sql + " with studentID = '" + studentId + "'");
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Retrieve data from ResultSet based on your 'student' table columns
                String studName = rs.getString("studName");
                String studNumber = rs.getString("studNumber");
                String studEmergencyNumber = rs.getString("studEmergencyNumber");

                // Set retrieved data as request attributes to pre-fill the form
                request.setAttribute("studName", studName);
                request.setAttribute("studNumber", studNumber);
                request.setAttribute("studEmergencyNumber", studEmergencyNumber);

                System.out.println("Data retrieved from DB:");
                System.out.println("  studName: " + studName);
                System.out.println("  studNumber: " + studNumber);
                System.out.println("  studEmergencyNumber: " + studEmergencyNumber);

                // --- IMPORTANT DEBUG PRINT HERE ---
                System.out.println("Request attributes set before forwarding to JSP:");
                System.out.println("  request.getAttribute(\"studentId\"): " + request.getAttribute("studentId"));
                System.out.println("  request.getAttribute(\"studName\"): " + request.getAttribute("studName"));
                System.out.println("  request.getAttribute(\"studNumber\"): " + request.getAttribute("studNumber"));
                System.out.println("  request.getAttribute(\"studEmergencyNumber\"): " + request.getAttribute("studEmergencyNumber"));
                System.out.println("  request.getAttribute(\"currentPage\"): " + request.getAttribute("currentPage")); // Debug for new attribute
                // --- END IMPORTANT DEBUG PRINT ---

            } else {
                // Should not happen if studentId is from a valid session and DB is consistent
                System.err.println("Error: Student profile NOT FOUND in database for ID: " + studentId + ".");
                request.setAttribute("error", "Student profile not found. Please try again or contact support.");
                // Even if not found, we still forward to JSP to show the ID and the error message
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("JDBC Driver not found error: " + e.getMessage());
            request.setAttribute("error", "JDBC Driver not found. Please ensure MySQL Connector/J JAR is in your project libraries.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Database SQL error: " + e.getMessage());
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            // Close resources in a finally block
            try { if (rs != null) rs.close(); } catch (SQLException e) { System.err.println("Error closing ResultSet: " + e.getMessage()); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { System.err.println("Error closing PreparedStatement: " + e.getMessage()); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { System.err.println("Error closing Connection: " + e.getMessage()); }
        }

        System.out.println("Forwarding request to updateProfile.jsp.");
        request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
        System.out.println("--- UpdateProfileServlet doGet Debug End ---");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("--- UpdateProfileServlet doPost Debug Start ---");
        System.out.println("Session ID: " + (session != null ? session.getId() : "NULL (No active session)"));

        if (session == null || session.getAttribute("studentId") == null) {
            System.out.println("doPost: Session is NULL or studentId not found. Redirecting to login.jsp.");
            response.sendRedirect("login.jsp");
            System.out.println("--- UpdateProfileServlet doPost Debug End (Redirected) ---");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String newStudName = request.getParameter("studName");
        String newStudNumber = request.getParameter("studNumber");
        String newStudEmergencyNumber = request.getParameter("studEmergencyNumber");

        System.out.println("doPost - Student ID from session: " + studentId);
        System.out.println("doPost - Received parameters:");
        System.out.println("  newStudName: " + newStudName);
        System.out.println("  newStudNumber: " + newStudNumber);
        System.out.println("  newStudEmergencyNumber: " + newStudEmergencyNumber);

        // *** ADD THIS LINE FOR ACTIVE NAVIGATION (when forwarding back to JSP on error) ***
        request.setAttribute("currentPage", "updateProfile");
        // *****************************************

        // Basic validation for new data
        if (newStudName == null || newStudName.trim().isEmpty() ||
            newStudNumber == null || newStudNumber.trim().isEmpty() ||
            newStudEmergencyNumber == null || newStudEmergencyNumber.trim().isEmpty()) {
            System.out.println("doPost - Validation failed: All fields are required.");
            request.setAttribute("error", "All fields are required for update.");
            // Forward back to the form, pre-filling with already submitted data
            request.setAttribute("studName", newStudName);
            request.setAttribute("studNumber", newStudNumber);
            request.setAttribute("studEmergencyNumber", newStudEmergencyNumber);
            request.setAttribute("studentId", studentId); // Ensure studentId is also set for the form
            request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
            System.out.println("--- UpdateProfileServlet doPost Debug End (Validation Fail) ---");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            System.out.println("doPost - Database connection established for updating profile.");

            String sql = "UPDATE student SET studName = ?, studNumber = ?, studEmergencyNumber = ? WHERE studentID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStudName);
            pstmt.setString(2, newStudNumber);
            pstmt.setString(3, newStudEmergencyNumber);
            pstmt.setString(4, studentId); // Use the student ID from session for the WHERE clause

            System.out.println("doPost - Executing SQL update query: " + sql);
            System.out.println("doPost - Parameters: Name='" + newStudName + "', Number='" + newStudNumber + "', Emergency='" + newStudEmergencyNumber + "', ID='" + studentId + "'");
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("doPost - Profile updated successfully! Rows affected: " + rowsAffected);
                // Update session attributes with new name (if name was updated)
                session.setAttribute("studName", newStudName); // Changed from studentName to studName as per JSP
                // Set a success message in session to be displayed on the dashboard
                session.setAttribute("successMessage", "Profile updated successfully!");
                response.sendRedirect("dashboard.jsp"); // Redirect back to dashboard
                System.out.println("--- UpdateProfileServlet doPost Debug End (Success Redirect) ---");
            } else {
                System.out.println("doPost - Profile update failed. No records found or updated for ID: " + studentId);
                request.setAttribute("error", "Profile update failed. No records found or updated.");
                // Forward back to the form with current (failed) inputs
                request.setAttribute("studName", newStudName);
                request.setAttribute("studNumber", newStudNumber);
                request.setAttribute("studEmergencyNumber", newStudEmergencyNumber);
                request.setAttribute("studentId", studentId); // Ensure studentId is also set for the form
                request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
                System.out.println("--- UpdateProfileServlet doPost Debug End (Update Fail) ---");
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("doPost - JDBC Driver not found error: " + e.getMessage());
            request.setAttribute("error", "JDBC Driver not found: " + e.getMessage());
            request.setAttribute("studentId", studentId); // Keep ID in form on error
            request.setAttribute("studName", newStudName);
            request.setAttribute("studNumber", newStudNumber);
            request.setAttribute("studEmergencyNumber", newStudEmergencyNumber);
            request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
            System.out.println("--- UpdateProfileServlet doPost Debug End (Driver Error) ---");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("doPost - Database SQL error: " + e.getMessage());
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.setAttribute("studentId", studentId); // Keep ID in form on error
            request.setAttribute("studName", newStudName);
            request.setAttribute("studNumber", newStudNumber);
            request.setAttribute("studEmergencyNumber", newStudEmergencyNumber);
            request.getRequestDispatcher("updateProfile.jsp").forward(request, response);
            System.out.println("--- UpdateProfileServlet doPost Debug End (SQL Error) ---");
        } finally {
            // Close resources
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { System.err.println("Error closing PreparedStatement (doPost): " + e.getMessage()); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { System.err.println("Error closing Connection (doPost): " + e.getMessage()); }
        }
    }
}