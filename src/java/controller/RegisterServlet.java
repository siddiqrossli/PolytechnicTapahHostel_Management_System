package controller;

import model.Student; // Assuming you have this model class
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet; // Don't forget this import for @WebServlet annotation

@WebServlet("/register") // This maps the URL '/register' to this servlet
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L; // Recommended for Servlets

    @Override
    public void init() throws ServletException {
        // The database connection setup should be done only when needed (in doPost)
        // No code needed here for this scenario
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Retrieve form parameters
        String studentId = request.getParameter("studentId");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String emergencyContact = request.getParameter("emergencyContact");
        String semesterStr = request.getParameter("semester");
        String cgpa = request.getParameter("cgpa");
        String houseIncome = request.getParameter("houseIncome");
        String gender = request.getParameter("gender");

        // Validate form fields - basic null check
        if (studentId == null || password == null || name == null || phone == null || emergencyContact == null ||
            semesterStr == null || cgpa == null || houseIncome == null || gender == null ||
            studentId.isEmpty() || password.isEmpty() || name.isEmpty() || phone.isEmpty() || emergencyContact.isEmpty() ||
            semesterStr.isEmpty() || cgpa.isEmpty() || houseIncome.isEmpty() || gender.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Convert semester to integer
        int semester;
        try {
            semester = Integer.parseInt(semesterStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid semester value.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // SQL query to insert data into the student table
        // Ensure 'student' is the correct table name and columns match exactly in your database
        String sql = "INSERT INTO student (studentID, studPassword, studName, studNumber, studEmergencyNumber, studSemester, studCGPA, houseIncome, studGender, roomID) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Database connection details
        // **IMPORTANT: Ensure 'hostel_management' matches your exact database name (case-sensitive if on Linux)**
        String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
        String jdbcUsername = "farish";
        String jdbcPassword = "kakilangit"; // As per your current setup, root has no password

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
                // String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
                // pstmt.setString(2, hashedPassword);

                // Prepare the statement with retrieved form data
                pstmt.setString(1, studentId);
                pstmt.setString(2, password); // <--- CHANGE THIS TO HASHED PASSWORD IN REAL APP
                pstmt.setString(3, name);
                pstmt.setString(4, phone);
                pstmt.setString(5, emergencyContact);
                pstmt.setInt(6, semester);
                pstmt.setString(7, cgpa); // Ensure 'cgpa' column is VARCHAR/TEXT in DB, or parse to double/decimal
                pstmt.setString(8, houseIncome); // Ensure 'houseIncome' column is VARCHAR/TEXT in DB, or parse to double/decimal
                pstmt.setString(9, gender);
                pstmt.setNull(10, Types.VARCHAR); // roomID is automatically set to NULL (assuming it's nullable)

                // Execute the SQL insert
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Registration successful
                    response.sendRedirect("login.jsp"); // Redirect to login page
                } else {
                    // Registration failed (e.g., no rows affected)
                    request.setAttribute("error", "Registration failed. Please try again.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }

            } // Connection and PreparedStatement are automatically closed here
        } catch (ClassNotFoundException e) {
            // This catches errors if the JDBC driver class cannot be found
            e.printStackTrace();
            request.setAttribute("error", "JDBC Driver not found. Please ensure MySQL Connector/J JAR is in your project libraries.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch (SQLException e) {
            // This catches any database-related errors
            e.printStackTrace(); // Print stack trace to server console for debugging
            request.setAttribute("error", "Database error: " + e.getMessage()); // Provide specific error message to user
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // If someone tries to access /register directly via GET, redirect them to the registration form
        response.sendRedirect("register.jsp");
    }
}