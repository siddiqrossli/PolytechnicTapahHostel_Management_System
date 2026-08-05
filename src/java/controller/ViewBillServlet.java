package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import model.Bill; // Make sure your model.Bill class exists and is correctly defined

public class ViewBillServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USERNAME = "farish"; // Replace with your actual DB username
    private static final String DB_PASSWORD = "kakilangit"; // Replace with your actual DB password

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String studentId = (String) session.getAttribute("studentId");

        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("currentPage", "bills");

        List<Bill> billList = new ArrayList<>();
        boolean bill1Paid = false; // For the "Generate Report" button logic
        boolean bill2Paid = false; // For the "Generate Report" button logic

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {

                String sql = "SELECT billNo, billName, billAmount, paymentStatus, billSequencePerStudent " +
                             "FROM bills WHERE studentID = ? ORDER BY billSequencePerStudent ASC";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, studentId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            Bill bill = new Bill(
                                rs.getInt("billNo"),
                                rs.getString("billName"),
                                rs.getDouble("billAmount"),
                                rs.getString("paymentStatus"),
                                studentId,
                                rs.getInt("billSequencePerStudent")
                            );
                            billList.add(bill);

                            // Check status of specific bills (for "Generate Report" button logic)
                            if (bill.getBillSequencePerStudent() == 1 && "Paid".equals(bill.getPaymentStatus())) {
                                bill1Paid = true;
                            }
                            if (bill.getBillSequencePerStudent() == 2 && "Paid".equals(bill.getPaymentStatus())) {
                                bill2Paid = true;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading bills: " + e.getMessage());
        }

        request.setAttribute("billList", billList);
        request.setAttribute("bill1Paid", bill1Paid); // For "Generate Report" button logic
        request.setAttribute("bill2Paid", bill2Paid); // For "Generate Report" button logic

        request.getRequestDispatcher("bill.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        String studentId = (String) session.getAttribute("studentId");

        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("currentPage", "bills");

        if ("payBill".equals(action)) {
            String billNoStr = request.getParameter("billNo");

            if (billNoStr != null && !billNoStr.isEmpty()) {
                try {
                    int billNo = Integer.parseInt(billNoStr);
                    Bill paidBillDetails = null; // To store the details of the just-paid bill

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
                        String updateSql = "UPDATE bills SET paymentStatus = 'Paid' WHERE billNo = ? AND studentID = ?";
                        try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                            pstmt.setInt(1, billNo);
                            pstmt.setString(2, studentId);
                            int rowsAffected = pstmt.executeUpdate();

                            if (rowsAffected > 0) {
                                // Payment successful, now fetch details of this specific bill
                                String selectBillSql = "SELECT billNo, billName, billAmount, paymentStatus, billSequencePerStudent " +
                                                       "FROM bills WHERE billNo = ? AND studentID = ?";
                                try (PreparedStatement selectPstmt = conn.prepareStatement(selectBillSql)) {
                                    selectPstmt.setInt(1, billNo);
                                    selectPstmt.setString(2, studentId);
                                    try (ResultSet rs = selectPstmt.executeQuery()) {
                                        if (rs.next()) {
                                            paidBillDetails = new Bill(
                                                rs.getInt("billNo"),
                                                rs.getString("billName"),
                                                rs.getDouble("billAmount"),
                                                rs.getString("paymentStatus"),
                                                studentId,
                                                rs.getInt("billSequencePerStudent")
                                            );
                                        }
                                    }
                                }

                                if (paidBillDetails != null) {
                                    request.setAttribute("message", "Bill " + paidBillDetails.getBillSequencePerStudent() + " paid successfully!");
                                    // Store the paid bill details in request scope for PDF generation
                                    request.setAttribute("paidBillForReceipt", paidBillDetails);
                                    request.setAttribute("triggerPdfReceipt", true); // Flag to trigger JS PDF
                                } else {
                                    request.setAttribute("error", "Payment successful, but failed to retrieve bill details.");
                                }
                            } else {
                                request.setAttribute("error", "Payment failed. Bill not found or already paid.");
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Payment error: " + e.getMessage());
                }
            } else {
                request.setAttribute("error", "Missing bill information");
            }
        } else if ("generateReport".equals(action)) {
            // Keep existing logic for "Generate Report" button if you still want it
            boolean allBillsPaid = true;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD)) {
                    String sql = "SELECT billSequencePerStudent, paymentStatus FROM bills WHERE studentID = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        pstmt.setString(1, studentId);
                        try (ResultSet rs = pstmt.executeQuery()) {
                            Set<Integer> paidBillSequences = new HashSet<>();
                            while (rs.next()) {
                                if ("Paid".equals(rs.getString("paymentStatus"))) {
                                    paidBillSequences.add(rs.getInt("billSequencePerStudent"));
                                }
                            }
                            if (!paidBillSequences.contains(1) || !paidBillSequences.contains(2)) { // Adjust based on your "report" criteria
                                allBillsPaid = false;
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error checking bill status for report generation: " + e.getMessage());
                allBillsPaid = false;
            }

            if (allBillsPaid) {
                request.setAttribute("message", "All required bills are paid. You can now download your full bill report.");
            } else {
                request.setAttribute("error", "Please pay all required bills to generate the full report.");
            }
        }

        doGet(request, response);
    }
}