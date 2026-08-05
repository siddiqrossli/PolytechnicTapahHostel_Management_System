package controller;

import model.Staff;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/staffList")
public class StaffListServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USER = "farish";
    private static final String DB_PASSWORD = "kakilangit";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
            String staffPosition = (String) session.getAttribute("staffPosition");
        ArrayList<Staff> staffList = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT staffID, staffName, staffNumber, staffEmail, staffPosition FROM staff")) {

            while (rs.next()) {
                Staff staff = new Staff();
                staff.setStaffID(rs.getString("staffID"));
                staff.setStaffName(rs.getString("staffName"));
                staff.setStaffNumber(rs.getString("staffNumber"));
                staff.setStaffEmail(rs.getString("staffEmail"));
                staff.setStaffPosition(rs.getString("staffPosition"));
                staffList.add(staff);
            }

            request.setAttribute("staffList", staffList);
            if ("Staff".equalsIgnoreCase(staffPosition)) {
                            request.getRequestDispatcher("staffList.jsp").forward(request, response);
                        } else {
                            request.getRequestDispatcher("otherStaffList.jsp").forward(request, response);

                        }
            

        } catch (SQLException e) {
            throw new ServletException("Database error: " + e.getMessage(), e);
        }
    }
}
