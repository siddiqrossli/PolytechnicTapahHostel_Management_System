<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Bills - Polytechnic Hostel</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>

        :root {
            --primary: #a94442;
            --primary-dark: #8c3a3a;
            --primary-light: rgba(169, 68, 66, 0.1);
            --secondary: #3C91E6;
            --light: #F9F9F9;
            --grey: #eee;
            --dark-grey: #AAAAAA;
            --dark: #342E37;
            --white: #ffffff;
            --black: #000000;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: var(--light);
            color: var(--dark);
            background-image: url('img/background.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-blend-mode: overlay;
            background-color: rgba(249, 249, 249, 0.9);
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        header {
            background-color: var(--white);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            cursor: pointer;
            transition: transform 0.3s;
        }

        .logo:hover {
            transform: scale(1.05);
        }

        .logo img {
            height: 40px;
        }

        .logout-btn {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .logout-btn:hover {
            background-color: var(--primary-dark);
        }

        .dashboard-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        .sidebar {
            width: 280px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            backdrop-filter: blur(5px);
        }

        .student-card {
            text-align: center;
            padding: 20px 0;
            border-bottom: 1px solid var(--grey);
            margin-bottom: 20px;
        }

        .profile-pic {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 3px solid var(--primary);
        }

        .student-card h3 {
            font-size: 18px;
            margin-bottom: 5px;
            color: var(--primary);
        }

        .student-card p {
            font-size: 14px;
            color: var(--dark-grey);
        }

        .button-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 20px;
        }

        .dashboard-button {
            background-color: rgba(169, 68, 66, 0.1);
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
            transition: all 0.3s;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dashboard-button:hover {
            background-color: var(--primary);
            color: var(--white);
            transform: translateX(5px);
        }

        .dashboard-button i {
            font-size: 20px;
        }

        .dashboard-button.active {
            background-color: var(--primary);
            color: var(--white);
        }

        .sidebar-footer {
            margin-top: auto;
            text-align: center;
            padding-top: 20px;
            font-size: 12px;
            color: var(--dark-grey);
        }

        .main-content {
            flex: 1;
            padding: 30px;
            background-color: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(5px);
        }

        .container {
            background-color: var(--white);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1500px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }

        h2 {
            color: var(--primary);
            font-size: 24px;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            text-align: left;
            padding: 12px 15px;
            border-bottom: 1px solid var(--grey);
            font-size: 14px;
        }

        th {
            background-color: var(--light);
            font-weight: 600;
            color: var(--dark);
        }

        tr:nth-child(even) {
            background-color: var(--light);
        }

        .status-paid {
            color: #28a745;
            font-weight: 600;
        }

        .status-unpaid {
            color: #dc3545;
            font-weight: 600;
        }

        .btn-pay, .btn-action, .btn-receipt {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-pay:hover, .btn-action:hover, .btn-receipt:hover {
            background-color: var(--primary-dark);
        }

        .btn-action:disabled {
            background-color: var(--dark-grey);
            cursor: not-allowed;
        }

        .no-bills {
            text-align: center;
            color: var(--dark-grey);
            margin-top: 30px;
            font-style: italic;
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
            text-align: center;
        }

        .message-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: block;
        }

        .notice-panel {
            width: 280px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            box-shadow: -2px 0 5px rgba(0,0,0,0.1);
            overflow-y: auto;
            backdrop-filter: blur(5px);
        }

        .notice-panel h2 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--primary);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--grey);
        }

        .notice-list {
            list-style-type: none;
        }

        .notice-list li {
            padding: 10px 0;
            border-bottom: 1px solid var(--grey);
            font-size: 14px;
            transition: color 0.3s;
        }

        .notice-list li:hover {
            color: var(--primary);
        }

        /* Payment actions section - separate from table */
        .payment-actions {
            margin-top: 20px;
            padding: 20px;
            background-color: var(--light);
            border-radius: 8px;
            border-left: 4px solid var(--primary);
        }

        .payment-actions h3 {
            color: var(--primary);
            margin-bottom: 15px;
            font-size: 18px;
        }

        .payment-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid var(--grey);
        }

        .payment-item:last-child {
            border-bottom: none;
        }

        .payment-info {
            flex-grow: 1;
        }

        .payment-info strong {
            color: var(--dark);
            display: block;
            margin-bottom: 5px;
        }

        .payment-info span {
            color: var(--dark-grey);
            font-size: 13px;
        }

        /*
        --- PRINT-SPECIFIC STYLES ---
        Key changes:
        - `body` margin and padding adjusted for better print layout.
        - `!important` used judiciously to override screen styles.
        - `display: none` for non-receipt elements applied to their parent containers.
        - `receipt-content` div introduced to wrap all printable content. This allows
          us to hide everything else and only show this div during print.
        */
        @media print {
            body {
                background: white !important;
                font-family: 'Arial', sans-serif !important;
                font-size: 10pt !important; /* Smaller font for typical receipts */
                line-height: 1.2 !important;
                margin: 0 !important;
                padding: 0 !important;
                width: 100%; /* Ensure it takes full width */
            }

            /* Hide everything that is NOT part of the receipt */
            header, .sidebar, .notice-panel, .top-bar,
            .message, .payment-actions, .dashboard-container > *:not(.main-content) {
                display: none !important;
            }

            /* Show only the main content area for the receipt */
            .main-content {
                display: block !important;
                flex: none !important; /* Remove flex properties */
                padding: 20mm !important; /* Standard A4 margins, adjust as needed */
                width: 100% !important;
                max-width: none !important; /* Remove max-width constraints */
                background-color: white !important; /* Ensure white background */
                box-shadow: none !important; /* Remove shadow */
                backdrop-filter: none !important; /* Remove blur */
            }

            /* The container that holds the receipt content */
            .container {
                display: block !important;
                background: white !important;
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                margin: 0 auto !important; /* Center the receipt on the page */
                max-width: 210mm !important; /* A4 width for consistency, or smaller for thermal receipt look */
                width: 100%;
                border-radius: 0 !important;
            }

            /* Show receipt-specific blocks */
            .receipt-header, .receipt-student-info, .receipt-table,
            .receipt-summary, .thank-you, .receipt-footer {
                display: block !important;
            }

            /* Receipt Header */
            .receipt-header {
                text-align: center;
                border-bottom: 1px dashed #ccc; /* Lighter dashed line */
                padding-bottom: 15px;
                margin-bottom: 20px;
            }

            .receipt-logo {
                width: 60px; /* Smaller logo for receipt */
                height: 60px;
                margin: 0 auto 10px;
                border-radius: 50%;
                border: 1px solid #a94442; /* Lighter border */
            }

            .receipt-title {
                font-size: 16pt !important; /* Adjusted font size */
                font-weight: bold;
                color: #333 !important; /* Darker for better contrast */
                margin: 0 0 5px;
                text-transform: uppercase;
            }

            .receipt-subtitle {
                font-size: 10pt !important;
                color: #555 !important;
                margin: 0 0 8px;
            }

            .receipt-date {
                font-size: 8pt !important;
                color: #777 !important;
                font-style: normal; /* Remove italic for cleaner print */
            }

            /* Student Information */
            .receipt-student-info {
                background: none !important; /* No background in print */
                padding: 10px 0 !important; /* Reduced padding */
                margin: 15px 0 !important;
                border: none !important; /* No border in print */
                border-bottom: 1px dashed #ccc !important; /* Add bottom dashed line */
                border-top: 1px dashed #ccc !important; /* Add top dashed line */
                border-radius: 0 !important;
            }

            .receipt-student-info h3 {
                font-size: 12pt !important;
                color: #333 !important;
                margin: 0 0 10px;
                text-align: left; /* Align to left */
                text-transform: capitalize; /* More natural capitalization */
                letter-spacing: normal;
            }

            .student-details {
                display: flex;
                justify-content: space-between;
                margin: 5px 0; /* Smaller margin */
                font-size: 10pt !important;
            }

            .student-details strong {
                color: #333 !important;
            }

            /* Receipt Table */
            /* Add this CSS to your existing @media print section - just for the table container */

/* Receipt Table Container - Make it smaller and centered */
.receipt-table {
    width: 60% !important; /* Make table smaller - 60% instead of 100% */
    max-width: 500px !important; /* Maximum width limit */
    margin: 20px auto !important; /* Center the table with auto margins */
    border-collapse: collapse;
    font-size: 10pt !important;
    border: 1px solid #ccc !important;
}

.receipt-table th {
    background: #f0f0f0 !important;
    color: #333 !important;
    padding: 8px 10px !important;
    text-align: center !important; /* Center align headers */
    font-weight: bold;
    font-size: 9pt !important;
    text-transform: uppercase;
    letter-spacing: 0.3px;
    border-bottom: 1px solid #ccc !important;
    border-top: 1px solid #ccc !important;
}

.receipt-table td {
    padding: 8px 10px !important;
    text-align: center !important; /* Center align data */
    border-bottom: 1px dashed #eee !important;
    vertical-align: middle !important; /* Center vertically */
}

.receipt-table tr:nth-child(even) td {
    background: #fcfcfc !important;
}

.receipt-table tr:last-child td {
    border-bottom: none !important;
}

/* Make sure status badges are also centered */
.print-status-paid, .print-status-unpaid {
    display: inline-block !important;
    padding: 2px 8px !important;
    border-radius: 10px !important;
    font-weight: normal !important;
    font-size: 8pt !important;
    text-transform: capitalize !important;
    letter-spacing: normal !important;
    text-align: center !important;
}

.print-status-paid {
    background: #e6ffe6 !important;
    color: #28a745 !important;
    border: 1px solid #28a745 !important;
}

.print-status-unpaid {
    background: #ffe6e6 !important;
    color: #dc3545 !important;
    border: 1px solid #dc3545 !important;
}

            /* Receipt Summary */
            .receipt-summary {
                margin: 20px 0 !important;
                padding: 15px !important;
                background: #f8f8f8 !important; /* Lighter background */
                border: 1px solid #ccc !important;
                border-radius: 5px;
                text-align: left !important; /* Align summary to left */
            }

            .receipt-summary h3 {
                font-size: 12pt !important;
                color: #333 !important;
                margin: 0 0 10px;
                font-weight: bold;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin: 6px 0;
                font-size: 10pt !important;
            }

            .summary-row.total {
                border-top: 1px solid #ccc !important; /* Lighter border for total */
                padding-top: 10px;
                margin-top: 10px;
                font-weight: bold;
                font-size: 12pt !important;
                color: #333 !important;
            }

            /* Thank you message */
            .thank-you {
                font-size: 11pt !important;
                font-weight: bold;
                color: #28a745 !important;
                text-align: center;
                margin: 15px 0 !important;
                text-transform: none; /* No uppercase for this */
                letter-spacing: normal;
                padding: 8px 15px;
                border: 1px dashed #28a745;
                border-radius: 5px;
                background-color: #e6ffe6;
            }

            /* Receipt Footer */
            .receipt-footer {
                margin-top: 30px !important;
                text-align: center;
                border-top: 1px dashed #ccc !important; /* Lighter dashed line */
                padding-top: 15px;
                font-size: 8pt !important;
                color: #777 !important;
            }

            .receipt-footer p {
                margin: 3px 0;
            }

            .receipt-footer .official-notice {
                font-weight: bold;
                color: #a94442 !important;
                font-size: 9pt !important;
                margin-top: 8px;
            }
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .dashboard-container {
                flex-direction: column;
            }
            .sidebar, .notice-panel {
                width: 100%;
            }
            .sidebar {
                order: 1;
            }
            .main-content {
                order: 2;
            }
            .notice-panel {
                order: 3;
            }
        }

        @media (max-width: 768px) {
            header {
                padding: 10px 15px;
            }
            .main-content {
                padding: 20px;
            }
            .container {
                padding: 20px;
                height: auto;
            }
            .top-bar {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            table {
                display: block;
                overflow-x: auto;
            }
            .payment-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo" onclick="window.location.href='dashboard.jsp'">
            <img src="img/logo.png.png" alt="Polytechnic Hostel Logo">
        </div>
        <nav>
            <button class="logout-btn" onclick="window.location.href='logout'">Log Out</button>
        </nav>
    </header>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="student-card">
                <img src="img/student.png" alt="Student Photo" class="profile-pic"/>
                <h3><c:out value="${sessionScope.studName}" default="Guest Student"/></h3>
                <p>${sessionScope.studentId}<br/>Student</p>
            </div>
            <div class="button-group">
               <a href="updateProfile" class="dashboard-button <c:if test="${requestScope.currentPage eq 'updateProfile'}">active</c:if>">
                    <i class='bx bxs-user'></i> Update Profile
                </a>
                <a href="changePassword" class="dashboard-button <c:if test="${requestScope.currentPage eq 'changePassword'}">active</c:if>">
                    <i class='bx bxs-wrench'></i> Change Password
                </a>
                <a href="ApplyCollegeServlet" class="dashboard-button <c:if test="${requestScope.currentPage eq 'applyCollege'}">active</c:if>">
                    <i class='bx bxs-school'></i> Apply College
                </a>
                <a href="requestMaintenance" class="dashboard-button <c:if test="${requestScope.currentPage eq 'requestMaintenance'}">active</c:if>">
                    <i class='bx bxs-wrench'></i> Request Maintenance
                </a>
                <a href="ViewBillServlet" class="dashboard-button <c:if test="${requestScope.currentPage eq 'bills'}">active</c:if>">
                    <i class='bx bxs-credit-card'></i> Bills
                </a>
            </div>
            <footer class="sidebar-footer">
                <small>&copy; 2023 Polytechnic Hostel</small>
            </footer>
        </aside>

        <main class="main-content">
            <div class="container">
                <div class="top-bar">
                    <h2>Your Bills</h2>
                    
                    <%-- Only show Print button if both bills are paid --%>
                    <c:if test="${requestScope.bill1Paid eq true and requestScope.bill2Paid eq true}">
                        <button class="btn-action" id="printReceiptBtn">
                            <i class="fas fa-print"></i> Print Receipt
                        </button>
                    </c:if>
                </div>

                <%-- Success/Error messages (hidden in print) --%>
                <c:if test="${not empty requestScope.message}">
                    <div class="message message-success">${requestScope.message}</div>
                </c:if>
                <c:if test="${not empty requestScope.error}">
                    <div class="message message-error">${requestScope.error}</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty billList}">
                        <p class="no-bills">You have no bills yet.</p>
                    </c:when>
                    <c:otherwise>
                        <%-- This div wraps ONLY the content that should be printed --%>
                        <div id="receiptContent">
                            <%-- Receipt Header (only visible in print) --%>
                            <div class="receipt-header" style="display: none;">
                                <img src="img/logo.png.png" alt="Polytechnic Logo" class="receipt-logo">
                                <div class="receipt-title">Polytechnic Hostel</div>
                                <div class="receipt-subtitle">Official Payment Receipt</div>
                                <div class="receipt-date">Generated: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMMM yyyy 'at' HH:mm"/></div>
                            </div>

                            <%-- Student Information (only visible in print) --%>
                            <div class="receipt-student-info" style="display: none;">
                                <h3>Student Information</h3>
                                <div class="student-details">
                                    <span><strong>Student ID:</strong></span>
                                    <span>${sessionScope.studentId}</span>
                                </div>
                                <div class="student-details">
                                    <span><strong>Student Name:</strong></span>
                                    <span><c:out value="${sessionScope.studName}" default="Guest Student"/></span>
                                </div>
                                <div class="student-details">
                                    <span><strong>Receipt Date:</strong></span>
                                    <span><fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy"/></span>
                                </div>
                            </div>

                            <%-- Main Bills Table --%>
                            <table class="receipt-table">
                                <thead>
                                    <tr>
                                        <th>Bill #</th>
                                        <th>Description</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="bill" items="${billList}">
                                        <tr>
                                            <td>${bill.billSequencePerStudent}</td>
                                            <td>${bill.billName}</td>
                                            <td>RM<fmt:formatNumber value="${bill.billAmount}" pattern="0.00"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${bill.paymentStatus eq 'Unpaid'}">
                                                        <span class="status-unpaid print-status-unpaid">Unpaid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-paid print-status-paid">Paid</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <%-- Payment Summary (only visible in print) --%>
                            <div class="receipt-summary" style="display: none;">
                                <h3>Payment Summary</h3>
                                <c:set var="totalAmount" value="0" />
                                <c:set var="paidCount" value="0" />
                                <c:set var="unpaidCount" value="0" />
                                <c:forEach var="bill" items="${billList}">
                                    <c:set var="totalAmount" value="${totalAmount + bill.billAmount}" />
                                    <c:choose>
                                        <c:when test="${bill.paymentStatus eq 'Paid'}">
                                            <c:set var="paidCount" value="${paidCount + 1}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="unpaidCount" value="${unpaidCount + 1}" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <div class="summary-row">
                                    <span>Total Bills:</span>
                                    <span><strong>${paidCount + unpaidCount}</strong></span>
                                </div>
                                <div class="summary-row">
                                    <span>Bills Paid:</span>
                                    <span style="color: #28a745;"><strong>${paidCount}</strong></span>
                                </div>
                                <div class="summary-row">
                                    <span>Bills Unpaid:</span>
                                    <span style="color: #dc3545;"><strong>${unpaidCount}</strong></span>
                                </div>
                                <div class="summary-row total">
                                    <span>TOTAL AMOUNT PAID:</span>
                                    <span>RM<fmt:formatNumber value="${totalAmount}" pattern="0.00"/></span>
                                </div>
                            </div>

                            <%-- Thank You Message (only visible in print if all paid) --%>
                            <c:if test="${requestScope.bill1Paid eq true and requestScope.bill2Paid eq true}">
                                <div class="thank-you" style="display: none;">
                                    ✅ Thank You for Your Payment!
                                </div>
                            </c:if>
                        </div> <%-- End of receiptContent --%>

                        <%-- Payment Actions Section (hidden in print) --%>
                        <c:set var="hasUnpaidBills" value="false" />
                        <c:forEach var="bill" items="${billList}">
                            <c:if test="${bill.paymentStatus eq 'Unpaid'}">
                                <c:set var="hasUnpaidBills" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${hasUnpaidBills}">
                            <div class="payment-actions">
                                <h3><i class="fas fa-credit-card"></i> Payment Required</h3>
                                <c:forEach var="bill" items="${billList}">
                                    <c:if test="${bill.paymentStatus eq 'Unpaid'}">
                                        <div class="payment-item">
                                            <div class="payment-info">
                                                <strong>${bill.billName}</strong>
                                                <span>Amount: RM<fmt:formatNumber value="${bill.billAmount}" pattern="0.00"/> | Bill #${bill.billSequencePerStudent}</span>
                                            </div>
                                            <form action="ViewBillServlet" method="post" style="margin: 0;">
                                                <input type="hidden" name="action" value="payBill">
                                                <input type="hidden" name="billNo" value="${bill.billNo}">
                                                <button type="submit" class="btn-pay">
                                                    <i class="fas fa-credit-card"></i> Pay Now
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <aside class="notice-panel">
            <h2>Notices</h2>
            <ul class="notice-list">
                <c:forEach items="${notices}" var="notice">
                    <li>${notice.name} - ${notice.date}</li>
                </c:forEach>
            </ul>
        </aside>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const printButton = document.getElementById('printReceiptBtn');

            if (printButton) {
                printButton.addEventListener('click', function() {
                    // Check if all bills are indeed paid before printing
                    // This is a client-side check, server-side logic is still crucial
                    const allBillsPaid = ${requestScope.bill1Paid eq true and requestScope.bill2Paid eq true};
                    if (allBillsPaid) {
                        window.print();
                    } else {
                        alert("Cannot print receipt. There are still unpaid bills.");
                    }
                });
            }
        });
    </script>
</body>
</html>