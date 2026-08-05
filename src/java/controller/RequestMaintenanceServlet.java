package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/requestMaintenance")
public class RequestMaintenanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // TODO: For production, externalize these (e.g., JNDI, properties file)
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish"; // Your database username
    private static final String DB_PASSWORD = "kakilangit"; // The password for the 'farish' user

    private static final Map<String, String> CATEGORY_TO_STAFF_POSITION_MAP = new HashMap<>();

    @Override
    public void init() throws ServletException {
        // Initialize the mapping when the servlet starts
        // This map is thread-safe as it's initialized once and not modified afterwards.
        CATEGORY_TO_STAFF_POSITION_MAP.put("Plumbing Issue", "Plumber");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Electrical Issue", "Electrician");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Furniture Damage", "Staff");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Air-Conditioning", "Electrician");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Key-Room Missing", "Staff");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Pest Control", "Cleaner");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Cleaning Services", "Cleaner");
        CATEGORY_TO_STAFF_POSITION_MAP.put("Other", "Staff");

        try {
            // Load the JDBC driver once when the servlet initializes
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Log this as a severe error, as the application cannot function without the driver.
            System.err.println("FATAL: MySQL JDBC Driver not found during servlet initialization!");
            e.printStackTrace();
            throw new ServletException("Cannot initialize servlet: MySQL JDBC Driver not found", e);
        }
    }

    // Helper method for consistent error/message forwarding and data retention
    private void forwardToPage(HttpServletRequest request, HttpServletResponse response,
                               String message, String messageType,
                               String studentId, String studentName, String phoneNumber,
                               String roomNumber, boolean hasRoom, String category, String details)
                               throws ServletException, IOException {
        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        request.setAttribute("studentId", studentId);
        request.setAttribute("studName", studentName);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("roomNumber", roomNumber);
        request.setAttribute("hasRoom", hasRoom);
        request.setAttribute("category", category); // Retain selected category
        request.setAttribute("details", details);   // Retain entered details
        fetchAndSetNotices(request); // Always fetch notices for the JSP sidebar
        request.setAttribute("currentPage", "requestMaintenance"); // Set current page for sidebar highlighting
        request.getRequestDispatcher("requestMaintenance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String studentName = (String) session.getAttribute("studName");

        String phoneNumber = null;
        String roomNumber = null;
        boolean hasRoom = false;

        // Retrieve current form inputs to retain them on error
        String category = request.getParameter("category");
        String details = request.getParameter("details");


        // Fetch student details (studNumber, roomID) from the database
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
            String fetchSql = "SELECT studNumber, roomID FROM student WHERE studentID = ?";
            try (PreparedStatement pstmtFetchStudentDetails = conn.prepareStatement(fetchSql)) {
                pstmtFetchStudentDetails.setString(1, studentId);
                try (ResultSet rsFetchStudentDetails = pstmtFetchStudentDetails.executeQuery()) {
                    if (rsFetchStudentDetails.next()) {
                        phoneNumber = rsFetchStudentDetails.getString("studNumber");
                        roomNumber = rsFetchStudentDetails.getString("roomID");
                        // Determine if the student has a room. A roomID might be NULL or an empty string.
                        hasRoom = (roomNumber != null && !roomNumber.trim().isEmpty());
                    } else {
                        // This case means studentID not found in the 'student' table (should ideally not happen if logged in)
                        System.err.println("Error: Student details not found for ID: " + studentId + " during POST request.");
                        forwardToPage(request, response, "Could not retrieve student details. Please try logging in again.",
                                "error", studentId, studentName, null, null, false, category, details);
                        return;
                    }
                }
            }

            // If student has no room, prevent submission and inform user
            if (!hasRoom) {
                forwardToPage(request, response, "You must book a room before submitting a maintenance request.",
                        "error", studentId, studentName, phoneNumber, roomNumber, false, category, details);
                return;
            }

            // Server-side validation for form fields
            if (category == null || category.trim().isEmpty() || details == null || details.trim().isEmpty()) {
                forwardToPage(request, response, "Please select a category and provide maintenance details.",
                        "error", studentId, studentName, phoneNumber, roomNumber, hasRoom, category, details);
                return;
            }

            String mainDescription = details;
            LocalDate mainDate = LocalDate.now();
            String mainStatus = "Pending"; // Initial status

            String assignedStaffId = null;
            String targetStaffPosition = CATEGORY_TO_STAFF_POSITION_MAP.get(category);

            // Logic to find a suitable staff
            if (targetStaffPosition != null) {
                assignedStaffId = getStaffIdForPosition(conn, targetStaffPosition);
            }

            if (assignedStaffId == null) {
                // Fallback to general "Staff" if no specific staff found for the position or if category not mapped
                System.out.println("No specific staff found for '" + category + "'. Attempting to assign to 'Staff'.");
                assignedStaffId = getStaffIdForPosition(conn, "Staff");
                if (assignedStaffId == null) {
                    System.err.println("Error: No 'Staff' position staff found in the database.");
                    forwardToPage(request, response, "No suitable staff found for this request. Please contact hostel management.",
                            "error", studentId, studentName, phoneNumber, roomNumber, hasRoom, category, details);
                    return;
                }
            }

            String sql = "INSERT INTO maintenance (mainCat, mainDescription, mainDate, mainStatus, staffID, studentID, roomID) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, category);
                pstmt.setString(2, mainDescription);
                pstmt.setDate(3, java.sql.Date.valueOf(mainDate));
                pstmt.setString(4, mainStatus);
                pstmt.setString(5, assignedStaffId);
                pstmt.setString(6, studentId);
                pstmt.setString(7, roomNumber);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                        String generatedMainID = null;
                        if (generatedKeys.next()) {
                            long autoIncId = generatedKeys.getLong(1);
                            generatedMainID = String.format("MAT%03d", autoIncId); // Format as MAT001, MAT002, etc.
                        }
                        request.setAttribute("message", "Maintenance request submitted successfully! Your Request ID is: " + generatedMainID + ". Assigned to Staff ID: " + assignedStaffId);
                        request.setAttribute("messageType", "success");
                        // Clear form fields on successful submission for a fresh form
                        category = "";
                        details = "";
                    }
                } else {
                    request.setAttribute("message", "Failed to submit maintenance request. Please try again.");
                    request.setAttribute("messageType", "error");
                }
            }
            // Forward to JSP with updated info (and cleared form if successful)
            forwardToPage(request, response, (String) request.getAttribute("message"),
                    (String) request.getAttribute("messageType"), studentId, studentName, phoneNumber,
                    roomNumber, hasRoom, category, details);

        } catch (SQLException e) {
            System.err.println("Database error during POST request: " + e.getMessage());
            e.printStackTrace();
            forwardToPage(request, response, "Database error: " + e.getMessage(),
                    "error", studentId, studentName, phoneNumber, roomNumber, hasRoom, category, details);
        }
    }

    private String getStaffIdForPosition(Connection conn, String staffPosition) throws SQLException {
        String staffId = null;
        // This picks the first staff member found. For a real system, you might want more complex logic.
        String sql = "SELECT staffID FROM staff WHERE staffPosition = ? LIMIT 1";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staffPosition);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    staffId = rs.getString("staffID");
                }
            }
        }
        return staffId;
    }

    // Helper method to fetch and set notices for the JSP
    private void fetchAndSetNotices(HttpServletRequest request) {
        List<Map<String, String>> notices = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
            String sql = "SELECT noticeName, noticeDate FROM notices ORDER BY noticeDate DESC LIMIT 5"; // Fetching latest 5 notices
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> notice = new HashMap<>();
                        notice.put("name", rs.getString("noticeName"));
                        notice.put("date", rs.getDate("noticeDate").toString()); // Format as needed
                        notices.add(notice);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching notices: " + e.getMessage());
            e.printStackTrace();
            // In a production app, you might log this and present a user-friendly message,
            // but not necessarily block the main functionality.
        }
        request.setAttribute("notices", notices);
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String studentName = (String) session.getAttribute("studName");

        String phoneNumber = null;
        String roomNumber = null;
        boolean hasRoom = false; // Flag to indicate if the student has a room

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
            String sql = "SELECT studNumber, roomID FROM student WHERE studentID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, studentId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        phoneNumber = rs.getString("studNumber");
                        roomNumber = rs.getString("roomID");
                        // Determine if the student has a room. A roomID might be NULL or an empty string.
                        hasRoom = (roomNumber != null && !roomNumber.trim().isEmpty());
                    } else {
                        System.err.println("Error: Student details not found for ID: " + studentId + " in RequestMaintenanceServlet doGet.");
                        forwardToPage(request, response, "Student details not found. Please log in again.",
                                "error", studentId, studentName, null, null, false, "", "");
                        return;
                    }
                }
            }
            // All necessary attributes are set by forwardToPage now, including the currentPage
            forwardToPage(request, response, (String) request.getAttribute("message"), // Pass existing message if any (from redirection)
                    (String) request.getAttribute("messageType"), studentId, studentName, phoneNumber,
                    roomNumber, hasRoom, "", ""); // Clear category/details on initial GET
        } catch (SQLException e) {
            System.err.println("Database error retrieving student details in doGet: " + e.getMessage());
            e.printStackTrace();
            forwardToPage(request, response, "Database error retrieving student details: " + e.getMessage(),
                    "error", studentId, studentName, null, null, false, "", "");
        }
    }
}