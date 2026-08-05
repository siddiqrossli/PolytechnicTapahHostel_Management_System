package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String jdbcURL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private String jdbcUsername = "farish";
    private String jdbcPassword = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // *** ADD THIS LINE FOR ACTIVE NAVIGATION ***
        request.setAttribute("currentPage", "changePassword");
        // *****************************************

        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
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
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // *** ADD THIS LINE FOR ACTIVE NAVIGATION (when forwarding back to JSP on error) ***
        request.setAttribute("currentPage", "changePassword");
        // *****************************************

        // Basic validation
        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmNewPassword == null || confirmNewPassword.trim().isEmpty()) {
            request.setAttribute("error", "All password fields are required.");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("error", "New password and confirm password do not match.");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtSelect = null;
        PreparedStatement pstmtUpdate = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String selectSql = "SELECT studPassword FROM student WHERE studentID = ?";
            pstmtSelect = conn.prepareStatement(selectSql);
            pstmtSelect.setString(1, studentId);
            rs = pstmtSelect.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("studPassword");

                if (oldPassword.equals(storedPassword)) {
                    String updateSql = "UPDATE student SET studPassword = ? WHERE studentID = ?";
                    pstmtUpdate = conn.prepareStatement(updateSql);
                    pstmtUpdate.setString(1, newPassword);
                    pstmtUpdate.setString(2, studentId);

                    int rowsAffected = pstmtUpdate.executeUpdate();

                    if (rowsAffected > 0) {
                        request.setAttribute("success", "Password changed successfully!");
                    } else {
                        request.setAttribute("error", "Password update failed. No records updated.");
                    }

                } else {
                    request.setAttribute("error", "Incorrect old password.");
                }

            } else {
                request.setAttribute("error", "Student profile not found for password change.");
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (pstmtSelect != null) pstmtSelect.close(); } catch (SQLException ignored) {}
            try { if (pstmtUpdate != null) pstmtUpdate.close(); } catch (SQLException ignored) {}
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
        }

        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
}