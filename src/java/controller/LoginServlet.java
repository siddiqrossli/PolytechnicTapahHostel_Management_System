package controller;

import model.Student; // Assuming you have this model class
import java.io.*;
import java.sql.*; // Make sure ResultSet is imported from here
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet; // Don't forget this import for @WebServlet annotation
import model.Activity;

@WebServlet("/login") // This maps the URL '/login' to this servlet
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L; // Recommended for Servlets

    @Override
    public void init() throws ServletException {
        // No code needed here for this scenario
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("studentId");
        String pass = request.getParameter("password");

        // Validate input fields - basic null and empty check
        if (id == null || pass == null || id.trim().isEmpty() || pass.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both student ID and password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        List<String> activityList = new ArrayList<>(); //Array list to store the activity joined
        List<Activity> notices = new ArrayList<>();    //Array list to store the list of activity notices
        Map<String, Integer> meritMap = new HashMap<>();
        int totalMerit = 0;
        
        // Database connection details
        String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
        String jdbcUsername = "farish"; // Your user created in phpMyAdmin
        String jdbcPassword = "kakilangit"; // The password for the 'farish' user

        String sql = "SELECT studPassword, studName, studNumber, studEmergencyNumber, studGender, houseIncome, studCGPA, roomID, studSemester FROM student WHERE studentID = ?";
        String actSql = "SELECT a.actName FROM merit m JOIN activity a ON m.activityID = a.activityID WHERE m.studentID = ?";
        String notSql = "SELECT actName, actDate FROM activity";
        String meritSql = "SELECT a.actName, a.actMerit FROM merit m JOIN activity a ON m.activityID = a.activityID WHERE m.studentID = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setString(1, id);

                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String storedPlainPassword = rs.getString("studPassword");
                    String studentName = rs.getString("studName");
                    String studNumber = rs.getString("studNumber");
                    String studEmergencyNumber = rs.getString("studEmergencyNumber");
                    String studGender = rs.getString("studGender");
                    String houseIncome = rs.getString("houseIncome");
                    String studCGPA = rs.getString("studCGPA");
                    String roomID = rs.getString("roomID");
                    String studSemester = rs.getString("studSemester");

                    if (pass.equals(storedPlainPassword)) {
                        HttpSession session = request.getSession();
                        session.setAttribute("studentId", id);
                        session.setAttribute("studName", studentName);
                        session.setAttribute("studNumber", studNumber);
                        session.setAttribute("studEmergencyNumber", studEmergencyNumber);
                        session.setAttribute("studGender", studGender);
                        session.setAttribute("houseIncome", houseIncome);
                        session.setAttribute("studCGPA", studCGPA);
                        session.setAttribute("roomID", roomID);
                        session.setAttribute("studSemester", studSemester);
                        
                        
            PreparedStatement pstmtAct = conn.prepareStatement(actSql);
            pstmtAct.setString(1, id);

            ResultSet rsAct = pstmtAct.executeQuery();
            

            while (rsAct.next()) {
                activityList.add(rsAct.getString("actName"));
            }
            
            session.setAttribute("activities", activityList);
            
            PreparedStatement notStmt = conn.prepareStatement(notSql);
            ResultSet notRs = notStmt.executeQuery();
            
            while (notRs.next()) {
                Activity activity = new Activity();

        // Optional: format the date nicely
                activity.setName(notRs.getString("actName"));
                Date date = notRs.getDate("actDate");
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy"); // e.g., 16 Jun 2025
                activity.setDate(sdf.format(date));
        
                notices.add(activity);
            
            }
            
            session.setAttribute("notices", notices);
            
            PreparedStatement meritStmt = conn.prepareStatement(meritSql);
            meritStmt.setString(1, id);
            ResultSet meritRs = meritStmt.executeQuery();
            
            while (meritRs.next()) {
                String actName = meritRs.getString("actName");
                int point = meritRs.getInt("actMerit");

                // accumulate points per activity
                meritMap.put(actName, meritMap.getOrDefault(actName, 0) + point);
                totalMerit += point;
                }

                session.setAttribute("meritMap", meritMap);
                session.setAttribute("totalMerit", totalMerit);
            

                        // --- CORRECTED PLACEMENT FOR DEBUG PRINTS ---
                        System.out.println("--- LoginServlet Debug ---");
                        System.out.println("Login Successful for Student ID: " + id);
                        System.out.println("Session ID created/retrieved: " + session.getId());
                        System.out.println("Session attribute 'studentId': " + session.getAttribute("studentId"));
                        System.out.println("Session attribute 'studentName': " + session.getAttribute("studentName"));
                        System.out.println("Redirecting to dashboard.jsp");
                        System.out.println("--------------------------");
                        // --- END DEBUG PRINTS ---

                        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
                         // Redirect to student dashboard
                    } else {
                        request.setAttribute("error", "Invalid student ID or password.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid student ID or password.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

            }
          
        }
        
        
                 
        
        catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "JDBC Driver not found. Please ensure MySQL Connector/J JAR is in your project libraries.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}