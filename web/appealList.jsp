<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.StudentAppeal"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("staffId") == null) {
        response.sendRedirect("staffLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Appeals - Staff View</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            --success: #28a745;
            --warning: #ffc107;
            --danger: #dc3545;
            --info: #17a2b8;
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

        .staff-card {
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

        .staff-card h3 {
            font-size: 18px;
            margin-bottom: 5px;
            color: var(--primary);
        }

        .staff-card p {
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
            text-decoration: none;
        }

        .dashboard-button:hover {
            background-color: var(--primary);
            color: var(--white);
            transform: translateX(5px);
        }

        .dashboard-button.active {
            background-color: var(--primary);
            color: var(--white);
        }

        .dashboard-button i {
            font-size: 20px;
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
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            background-color: var(--white);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1500px;
            height: 825px;
            display: flex;
            flex-direction: column;
        }

        .content-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        h2 {
            color: var(--primary);
            font-size: 24px;
            font-weight: 600;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
            flex: 1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 15px;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--grey);
        }

        th {
            background-color: var(--primary);
            color: var(--white);
            position: sticky;
            top: 0;
        }

        tr:nth-child(even) {
            background-color: var(--light);
        }

        tr:hover {
            background-color: var(--primary-light);
        }

        .status {
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
            display: inline-block;
        }

        .status-pending {
            color: var(--warning);
            background-color: rgba(255, 193, 7, 0.1);
        }

        .status-approved {
            color: var(--success);
            background-color: rgba(40, 167, 69, 0.1);
        }

        .status-rejected {
            color: var(--danger);
            background-color: rgba(220, 53, 69, 0.1);
        }

        .status-under-review {
            color: var(--info);
            background-color: rgba(23, 162, 184, 0.1);
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
            text-align: center;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .info-message {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            margin: 30px 0;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .empty-state p {
            color: var(--dark-grey);
            margin-bottom: 25px;
            font-size: 1.1rem;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            font-size: 14px;
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-secondary {
            background-color: var(--secondary);
            color: white;
        }

        .btn-secondary:hover {
            background-color: #2a7fcc;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }

        .appeal-actions form {
            display: inline-block;
            margin-right: 5px;
        }

        /* Notice Panel Styles */
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

        /* Pagination Styles */
        .pagination-container {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            width: 100%;
        }
        
        .pagination {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .pagination-btn {
            color: var(--primary);
            padding: 8px 12px;
            text-decoration: none;
            border: 1px solid var(--grey);
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .pagination-btn:hover {
            background-color: var(--primary-light);
        }
        
        .pagination-btn.active {
            background-color: var(--primary);
            color: var(--white);
            font-weight: 600;
            border: 1px solid var(--primary);
        }
        
        .pagination-info {
            font-size: 14px;
            color: var(--dark-grey);
            margin-right: 15px;
        }

        @media (max-width: 1200px) {
            .dashboard-container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
            }
            .notice-panel {
                width: 100%;
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
            .action-buttons {
                flex-direction: column;
            }
            .btn {
                width: 100%;
                margin-bottom: 10px;
            }
            .pagination {
                flex-wrap: wrap;
                justify-content: center;
            }
            .pagination-info {
                margin-right: 0;
                margin-bottom: 10px;
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo" onclick="window.location.href='staffDashboard.jsp'">
            <img src="img/logo.png.png" alt="Polytechnic Hostel Logo">
        </div>
        <nav>
            <button class="logout-btn" onclick="window.location.href='logout'">Log Out</button>
        </nav>
    </header>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="staff-card">
                <img src="img/staff.png" alt="Staff Photo" class="profile-pic"/>
                <h3>${sessionScope.staffName}</h3>
                <p>Staff ID: <%= session.getAttribute("staffId") %></p>
            </div>
            <div class="button-group">
                <a href="updateStaffProfile" class="dashboard-button <c:if test="${requestScope.currentPage eq 'updateStaffProfile'}">active</c:if>">
                    <i class='bx bxs-user'></i> Update Profile
                </a>
                <a href="staffChangePassword" class="dashboard-button <c:if test="${requestScope.currentPage eq 'staffChangePassword'}">active</c:if>">
                    <i class='bx bxs-wrench'></i> Change Password
                </a>
                <a href="staffList" class="dashboard-button <c:if test="${requestScope.currentPage eq 'staffList'}">active</c:if>">
                    <i class='bx bxs-group'></i> View Staff
                </a>
                <a href="roomList" class="dashboard-button <c:if test="${requestScope.currentPage eq 'roomList'}">active</c:if>">
                    <i class='bx bxs-building-house'></i> View Rooms
                </a>
                <a href="viewStaffMaintenance" class="dashboard-button <c:if test="${requestScope.currentPage eq 'viewStaffMaintenance'}">active</c:if>">
                    <i class='bx bxs-wrench'></i> Maintenance
                </a>
                <a href="viewAppeals" class="dashboard-button active <c:if test="${requestScope.currentPage eq 'viewAppeals'}">active</c:if>">
                    <i class='bx bxs-message-square-dots'></i> Student Appeals
                </a>
            </div>
            <footer class="sidebar-footer">
                <small>&copy; 2023 Polytechnic Hostel</small>
            </footer>
        </aside>

        <main class="main-content">
            <div class="container">
                <div class="content-wrapper">
                    <div class="top-bar">
                        <h2>Student Appeals Management</h2>
                    </div>

                    <%-- Message Display --%>
                    <%
                        String message = (String) request.getAttribute("message");
                        String messageType = (String) request.getAttribute("messageType");
                        if (message != null && !message.isEmpty()) {
                    %>
                        <div class="message ${messageType == 'error' ? 'error-message' : (messageType == 'success' ? 'success-message' : 'info-message')}">
                            <%= message %>
                        </div>
                    <%
                        }
                    %>

                    <%
                        List<StudentAppeal> appealList = (List<StudentAppeal>) request.getAttribute("appealList");
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                        if (appealList == null || appealList.isEmpty()) {
                    %>
                        <div class="empty-state">
                            <h3>No Appeals Found</h3>
                            <p>There are currently no student appeals to review.</p>
                            <div class="action-buttons">
                                <a href="staffDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                            </div>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Appeal ID</th>
                                        <th>Student ID</th>
                                        <th>Student Name</th>
                                        <th>Student Number</th>
                                        <th>CGPA</th>
                                        <th>Household Income</th>
                                        <th>Reason</th>
                                        <th>Date Submitted</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (StudentAppeal appeal : appealList) {
                                            String statusClass = "";
                                            String currentStatus = appeal.getAppealStatus() != null ? appeal.getAppealStatus().toLowerCase() : "";
                                            
                                            if (currentStatus.equals("pending")) {
                                                statusClass = "status-pending";
                                            } else if (currentStatus.equals("approved")) {
                                                statusClass = "status-approved";
                                            } else if (currentStatus.equals("rejected")) {
                                                statusClass = "status-rejected";
                                            } else if (currentStatus.equals("under review")) {
                                                statusClass = "status-under-review";
                                            } else {
                                                statusClass = "";
                                            }
                                    %>
                                    <tr>
                                        <td><%= appeal.getAppealID() %></td>
                                        <td><%= appeal.getStudentID() != null ? appeal.getStudentID() : "N/A" %></td>
                                        <td><%= appeal.getStudName() != null ? appeal.getStudName() : "N/A" %></td>
                                        <td><%= appeal.getStudNumber() != null ? appeal.getStudNumber() : "N/A" %></td>
                                        <td><%= String.format("%.2f", appeal.getStudCGPA()) %></td>
                                        <td>RM <%= String.format("%,.2f", appeal.getHouseIncome()) %></td>
                                        <td><%= appeal.getAppealReason() != null ? appeal.getAppealReason() : "N/A" %></td>
                                        <td><%= appeal.getAppealDate() != null ? sdf.format(appeal.getAppealDate()) : "N/A" %></td>
                                        <td><span class="status <%= statusClass %>"><%= currentStatus != null ? currentStatus : "N/A" %></span></td>
                                        <td class="appeal-actions">
                                            <% if (currentStatus.equals("pending") || currentStatus.equals("under review")) { %>
                                            <form action="UpdateAppealStatusServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="appealID" value="<%= appeal.getAppealID() %>">
                                                <input type="hidden" name="newStatus" value="approved">
                                                <button type="submit" class="btn btn-success">Accept</button>
                                            </form>
                                            <form action="UpdateAppealStatusServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="appealID" value="<%= appeal.getAppealID() %>">
                                                <input type="hidden" name="newStatus" value="rejected">
                                                <button type="submit" class="btn btn-danger">Reject</button>
                                            </form>
                                            <% } else { %>
                                            No Actions
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    <%
                        }
                    %>
                </div>

                <%-- Pagination at bottom of container --%>
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <div class="pagination">
                            
                            
                            <c:if test="${currentPage > 1}">
                                <a href="viewAppeals?page=${currentPage - 1}" class="pagination-btn">
                                    <i class='bx bx-chevron-left'></i> Previous
                                </a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                <c:choose>
                                    <c:when test="${pageNumber == currentPage}">
                                        <span class="pagination-btn active">${pageNumber}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="viewAppeals?page=${pageNumber}" class="pagination-btn">${pageNumber}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="viewAppeals?page=${currentPage + 1}" class="pagination-btn">
                                    Next <i class='bx bx-chevron-right'></i>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
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
</body>
</html>