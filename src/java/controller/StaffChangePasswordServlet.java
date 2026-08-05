package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/staffChangePassword")
public class StaffChangePasswordServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        

        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("staffId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String staffId = (String) session.getAttribute("staffId");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (oldPassword == null || newPassword == null || confirmNewPassword == null ||
            oldPassword.isEmpty() || newPassword.isEmpty() || confirmNewPassword.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("error", "New password and confirm password do not match.");
            request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String selectSql = "SELECT staffPassword FROM staff WHERE staffID = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setString(1, staffId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                String currentPassword = rs.getString("staffPassword");

                if (oldPassword.equals(currentPassword)) {
                    String updateSql = "UPDATE staff SET staffPassword = ? WHERE staffID = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, newPassword);
                    updateStmt.setString(2, staffId);

                    int rowsAffected = updateStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        request.setAttribute("success", "Password changed successfully!");
                        request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);

                    } else {
                        request.setAttribute("error", "Password update failed.");
                        request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Incorrect old password.");
                    request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Staff profile not found.");
                response.sendRedirect("staffDashboard.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("staffChangePassword.jsp").forward(request, response);
        }
    }
}
