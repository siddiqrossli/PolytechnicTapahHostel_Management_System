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

import model.StudentAppeal;

@WebServlet("/viewAppeals")
public class ViewAppealServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int APPEALS_PER_PAGE = 7; // Number of appeals to show per page

    // Database Connection Details
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("studentId") == null && session.getAttribute("staffId") == null)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = (String) session.getAttribute("studentId");
        String staffId = (String) session.getAttribute("staffId");

        // Get current page number from request, default to 1
        int currentPage = 1;
        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Default to page 1 if invalid page number
        }

        List<StudentAppeal> appealList = new ArrayList<>();
        int totalAppeals = 0;
        int totalPages = 1;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);

            // First, get total count of appeals
            String countSql;
            if (studentId != null) {
                countSql = "SELECT COUNT(*) FROM student_appeal WHERE studentID = ?";
            } else {
                countSql = "SELECT COUNT(*) FROM student_appeal";
            }

            try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                if (studentId != null) {
                    countStmt.setString(1, studentId);
                }
                rs = countStmt.executeQuery();
                if (rs.next()) {
                    totalAppeals = rs.getInt(1);
                    totalPages = (int) Math.ceil((double) totalAppeals / APPEALS_PER_PAGE);
                    
                    // Ensure currentPage is within valid range
                    if (currentPage < 1) currentPage = 1;
                    if (currentPage > totalPages) currentPage = totalPages;
                }
            }

            // Then get appeals for the current page
            String sql;
            if (studentId != null) {
                // SQL for student's view
                sql = "SELECT sa.appealID, sa.reason AS appealReason, sa.appealDate, sa.appealStatus, " +
                      "s.studentID, s.studName, s.studNumber, s.studCGPA, s.houseIncome " +
                      "FROM student_appeal sa " +
                      "LEFT JOIN student s ON sa.studentID = s.studentID " +
                      "WHERE sa.studentID = ? ORDER BY sa.appealDate DESC LIMIT ? OFFSET ?";
            } else {
                // SQL for staff's view
                sql = "SELECT sa.appealID, sa.reason AS appealReason, sa.appealDate, sa.appealStatus, " +
                      "s.studentID, s.studName, s.studNumber, s.studCGPA, s.houseIncome " +
                      "FROM student_appeal sa " +
                      "LEFT JOIN student s ON sa.studentID = s.studentID " +
                      "ORDER BY sa.appealDate DESC LIMIT ? OFFSET ?";
            }

            pstmt = conn.prepareStatement(sql);
            
            int offset = (currentPage - 1) * APPEALS_PER_PAGE;
            
            if (studentId != null) {
                pstmt.setString(1, studentId);
                pstmt.setInt(2, APPEALS_PER_PAGE);
                pstmt.setInt(3, offset);
            } else {
                pstmt.setInt(1, APPEALS_PER_PAGE);
                pstmt.setInt(2, offset);
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                StudentAppeal appeal = new StudentAppeal();
                appeal.setAppealID(rs.getString("appealID"));
                appeal.setStudentID(rs.getString("studentID"));
                appeal.setStudName(rs.getString("studName"));
                appeal.setStudNumber(rs.getString("studNumber"));
                appeal.setStudCGPA(rs.getDouble("studCGPA"));
                appeal.setHouseIncome(rs.getDouble("houseIncome"));
                appeal.setAppealReason(rs.getString("appealReason"));
                appeal.setAppealDate(rs.getDate("appealDate"));
                appeal.setAppealStatus(rs.getString("appealStatus"));

                appealList.add(appeal);
            }

            request.setAttribute("appealList", appealList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            
            String targetJSP = studentId != null ? "appealList.jsp" : "appealList.jsp";
            request.getRequestDispatcher(targetJSP).forward(request, response);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("message", "System Error: JDBC driver not found.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            // Close JDBC resources in reverse order of creation
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}