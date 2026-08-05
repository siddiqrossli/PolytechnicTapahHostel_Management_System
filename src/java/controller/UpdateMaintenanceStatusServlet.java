package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateMaintenanceStatusServlet")
public class UpdateMaintenanceStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mainIdParam = request.getParameter("mainID");
        String newStatus = request.getParameter("newStatus");
        HttpSession session = request.getSession();

        try {
            int mainID = Integer.parseInt(mainIdParam);

            try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);
                 PreparedStatement pstmt = conn.prepareStatement("UPDATE maintenance SET mainStatus = ? WHERE mainID = ?")) {

                Class.forName("com.mysql.cj.jdbc.Driver");

                pstmt.setString(1, newStatus);
                pstmt.setInt(2, mainID);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    session.setAttribute("message", "Maintenance status updated successfully.");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to update maintenance status or ID not found.");
                    session.setAttribute("messageType", "error");
                }

            }

        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid Maintenance ID format.");
            session.setAttribute("messageType", "error");

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Database error: " + e.getMessage());
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect("viewStaffMaintenance");
    }
}
