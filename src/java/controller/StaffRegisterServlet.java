/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter; // Not used, can be removed if still not used after refactoring
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types; // Not used, can be removed if staff table doesn't have a similar nullable column
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author siddi
 */
@WebServlet("/staffRegister") // IMPORTANT: Map this servlet to a new URL, e.g., "/staffRegister"
public class StaffRegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L; // Recommended for Servlets

    @Override
    public void init() throws ServletException {
        // The database connection setup should be done only when needed (in doPost)
        // No code needed here for this scenario
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Retrieve form parameters specific to Staff
        String staffID = request.getParameter("staffID");
        String staffPassword = request.getParameter("staffPassword");
        String staffName = request.getParameter("staffName");
        String staffNumber = request.getParameter("staffNumber");
        String staffEmail = request.getParameter("staffEmail");
        String staffPosition = request.getParameter("staffPosition"); // Assuming this is a new field for staff

        // Validate form fields - basic null and empty check for staff fields
        if (staffID == null || staffPassword == null || staffName == null || staffNumber == null ||
            staffEmail == null || staffPosition == null ||
            staffID.isEmpty() || staffPassword.isEmpty() || staffName.isEmpty() || staffNumber.isEmpty() ||
            staffEmail.isEmpty() || staffPosition.isEmpty()) {
            request.setAttribute("error", "All fields are required for staff registration.");
            // Redirect to a staff registration JSP, e.g., "staffRegister.jsp"
            request.getRequestDispatcher("staffRegister.jsp").forward(request, response);
            return;
        }

        // Removed semester and other student-specific conversions
        // If staff have numerical fields that need parsing, add similar try-catch blocks here.

        // SQL query to insert data into the 'staff' table (ASSUMING A 'staff' TABLE EXISTS)
        // You MUST ensure your 'staff' table in 'hostel_management' database has these columns:
        // staffID, staffPassword, staffName, staffNumber, staffEmail, staffPosition
        String sql = "INSERT INTO staff (staffID, staffPassword, staffName, staffNumber, staffEmail, staffPosition) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        // Database connection details
        // **IMPORTANT: Ensure 'hostel_management' matches your exact database name (case-sensitive if on Linux)**
        String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
        String jdbcUsername = "farish"; // Or a specific staff-level database user if you create one
        String jdbcPassword = "kakilangit"; // Password for the 'farish' user

        try {
            // Explicitly load the JDBC driver (recommended for robustness)
            Class.forName("com.mysql.cj.jdbc.Driver"); // Use "com.mysql.cj.jdbc.Driver" for MySQL Connector/J 8.x and later

            // Use try-with-resources to automatically close connection and statement
            try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                // **SECURITY NOTE:**
                // Passwords should NEVER be stored in plain text.
                // Before setting the password, you should hash it using a strong hashing algorithm
                // like BCrypt.
                // Example (requires a library like jbcrypt):
                // String hashedPassword = BCrypt.hashpw(staffPassword, BCrypt.gensalt());
                // pstmt.setString(2, hashedPassword);

                // Prepare the statement with retrieved staff form data
                pstmt.setString(1, staffID);
                pstmt.setString(2, staffPassword); // <--- CHANGE THIS TO HASHED PASSWORD IN REAL APP
                pstmt.setString(3, staffName);
                pstmt.setString(4, staffNumber);
                pstmt.setString(5, staffEmail);
                pstmt.setString(6, staffPosition); // New field for staff

                // Execute the SQL insert
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Registration successful
                    // Redirect to a staff-specific login page or dashboard
                    response.sendRedirect("staffLogin.jsp"); // Assuming a staff login page exists
                } else {
                    // Registration failed (e.g., no rows affected)
                    request.setAttribute("error", "Staff registration failed. Please try again.");
                    request.getRequestDispatcher("staffRegister.jsp").forward(request, response);
                }

            } // Connection and PreparedStatement are automatically closed here
        } catch (ClassNotFoundException e) {
            // This catches errors if the JDBC driver class cannot be found
            e.printStackTrace(); // Print stack trace to server console for debugging
            request.setAttribute("error", "JDBC Driver not found. Please ensure MySQL Connector/J JAR is in your project libraries.");
            request.getRequestDispatcher("staffRegister.jsp").forward(request, response);
        } catch (SQLException e) {
            // This catches any database-related errors (e.g., connection issues, query errors)
            e.printStackTrace(); // Print stack trace to server console for debugging
            request.setAttribute("error", "Database error: " + e.getMessage()); // Provide specific error message to user
            request.getRequestDispatcher("staffRegister.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // If someone tries to access /staffRegister directly via GET, redirect them to the registration form
        response.sendRedirect("staffRegister.jsp"); // Assuming a staff registration JSP exists
    }
}