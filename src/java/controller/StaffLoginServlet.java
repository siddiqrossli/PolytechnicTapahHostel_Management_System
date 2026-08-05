package controller;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import model.Activity;

@WebServlet("/staffLogin")
public class StaffLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        // No specific initialization needed for this servlet at the moment.
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters for staff login
        String staffId = request.getParameter("staffId");
        String staffPass = request.getParameter("staffPassword");

        // Validate input fields - basic null and empty check
        if (staffId == null || staffPass == null || staffId.trim().isEmpty() || staffPass.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both Staff ID and password.");
            request.getRequestDispatcher("staffLogin.jsp").forward(request, response);
            return;
        }

        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
        String jdbcUsername = "farish";
        String jdbcPassword = "kakilangit";
        
        
        List<Activity> notices = new ArrayList<>();
        // SQL query to retrieve password, name, AND POSITION from the 'staff' table
        String loginSql = "SELECT staffPassword, staffName, staffPosition, staffNumber, staffEmail FROM staff WHERE staffID = ?";        
        String notSql = "SELECT actName, actDate FROM activity";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Explicitly load the JDBC driver

            try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                 PreparedStatement pstmt = conn.prepareStatement(loginSql)) {

                pstmt.setString(1, staffId);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String storedPlainPassword = rs.getString("staffPassword");
                    String staffName = rs.getString("staffName");
                    String staffPosition = rs.getString("staffPosition");
                    String staffNumber = rs.getString("staffNumber");// Retrieve the position
                    String staffEmail = rs.getString("staffEmail");

                    if (staffPass.equals(storedPlainPassword)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("staffId", staffId);
                        session.setAttribute("staffName", staffName);
                        session.setAttribute("staffPosition", staffPosition); // Store position in session
                        session.setAttribute("staffNumber", staffNumber);
                        session.setAttribute("staffEmail", staffEmail);

                        // Get maintenance counts for dashboard
                        String countSql = "SELECT " +
                                       "SUM(CASE WHEN mainStatus = 'Pending' THEN 1 ELSE 0 END) as pendingCount, " +
                                       "SUM(CASE WHEN mainStatus = 'In Progress' THEN 1 ELSE 0 END) as inProgressCount, " +
                                       "SUM(CASE WHEN mainStatus = 'Completed' THEN 1 ELSE 0 END) as completedCount " +
                                       "FROM maintenance " +
                                       "WHERE staffID = ?";
                        
                        try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                            countStmt.setString(1, staffId);
                            ResultSet countRs = countStmt.executeQuery();
                            
                            if (countRs.next()) {
                                session.setAttribute("pendingCount", countRs.getInt("pendingCount"));
                                session.setAttribute("inProgressCount", countRs.getInt("inProgressCount"));
                                session.setAttribute("completedCount", countRs.getInt("completedCount"));
                            }
                        }
                        
                        PreparedStatement notStmt = conn.prepareStatement(notSql);
                        ResultSet notRs = notStmt.executeQuery();
                        
                        while (notRs.next()) {
                        Activity activity = new Activity();
                        activity.setName(notRs.getString("actName"));
                        Date date = notRs.getDate("actDate");
                
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy"); // e.g., 16 Jun 2025
                        activity.setDate(sdf.format(date));
        
                        notices.add(activity);
                        }
                        
                        session.setAttribute("notices", notices);

                        // Role-based redirection based on 'position'
                        if ("Staff".equalsIgnoreCase(staffPosition)) {
                            request.getRequestDispatcher("staffDashboard.jsp").forward(request, response);
                        } else {
                            response.sendRedirect("otherStaffDashboard.jsp");
                        }
                    } else {
                        request.setAttribute("error", "Invalid Staff ID or password.");
                        request.getRequestDispatcher("staffLogin.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid Staff ID or password.");
                    request.getRequestDispatcher("staffLogin.jsp").forward(request, response);
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "JDBC Driver not found. Please ensure MySQL Connector/J JAR is in your project libraries.");
            request.getRequestDispatcher("staffLogin.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("staffLogin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("staffLogin.jsp");
    }
}