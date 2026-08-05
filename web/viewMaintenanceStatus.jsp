<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceRequest" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance Status - Polytechnic Hostel</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Base Styles */
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

        /* Header Styles */
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

        /* Dashboard Layout */
        .dashboard-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        /* Sidebar Styles */
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

        /* Style for the current active page button */
        .dashboard-button.current-page-button {
            background-color: var(--primary); /* Highlight color */
            color: var(--white);
            pointer-events: none; /* Make it unclickable */
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

        /* Main Content Styles */
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

        .header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header-row h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: var(--primary);
        }

        .status-btn {
            background-color: var(--primary);
            color: var(--white);
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .status-btn:hover {
            background-color: var(--primary-dark);
            transform: scale(1.03);
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

        .status-pending {
            color: #d09e00;
            font-weight: 600;
        }

        .status-in-progress {
            color: var(--secondary);
            font-weight: 600;
        }

        .status-completed {
            color: #28a745;
            font-weight: 600;
        }

        .status-rejected {
            color: #dc3545;
            font-weight: 600;
        }

        .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            gap: 15px;
        }

        .btn-group a,
        .btn-group button {
            flex: 1;
            padding: 12px;
            border: none;
            text-align: center;
            font-size: 16px;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .btn-back {
            background-color: var(--light);
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-back:hover {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-submit {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-submit:hover {
            background-color: var(--primary-dark);
        }

        .message {
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .error {
            background-color: #ffe5e5;
            color: #a94442;
            border: 1px solid #a94442;
        }

        .success {
            background-color: #e5ffe5;
            color: #3c763d;
            border: 1px solid #3c763d;
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

        .notice-list li:last-child {
             border-bottom: none; /* No border for the last item */
        }

        .notice-list li:hover {
            color: var(--primary);
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
                padding: 15px;
            }
            .header-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .btn-group {
                flex-direction: column;
            }
            table {
                display: block;
                overflow-x: auto;
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
                <h3>${sessionScope.studName}</h3>
                <p>${sessionScope.studentId}<br/>Student</p>
            </div>
            <div class="button-group">
                <a href="updateProfile" class="dashboard-button">
                    <i class='bx bxs-user'></i> Update Profile
                </a>
                <a href="changePassword" class="dashboard-button">
                    <i class='bx bxs-wrench'></i> Change Password
                </a>
                <a href="ApplyCollegeServlet" class="dashboard-button">
                    <i class='bx bxs-school'></i> Apply College
                </a>
                <a href="requestMaintenance" class="dashboard-button current-page-button">
                    <i class='bx bxs-wrench'></i> Request Maintenance
                </a>
                <a href="ViewBillServlet" class="dashboard-button">
                    <i class='bx bxs-credit-card'></i> Bills
                </a>
            </div>
            <footer class="sidebar-footer">
                <small>&copy; 2023 Polytechnic Hostel</small>
            </footer>
        </aside>

        <main class="main-content">
            <div class="container">
                <div class="header-row">
                    <h1>Maintenance Status</h1>
                    <a href="requestMaintenance" class="status-btn">+ New Request</a>
                </div>

                <c:if test="${not empty requestScope.message}">
                    <div class="message ${requestScope.messageType == 'success' ? 'success' : 'error'}">
                        ${requestScope.message}
                    </div>
                </c:if>

                <%
                    List<MaintenanceRequest> maintenanceRequests = (List<MaintenanceRequest>) request.getAttribute("maintenanceRequests");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                %>

                <% if (maintenanceRequests == null || maintenanceRequests.isEmpty()) { %>
                    <p style="color: #555;">No maintenance requests found.</p>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Category</th>
                                <th>Description</th>
                                <th>Date</th>
                                <th>Assigned Staff</th>
                                <th>Staff Number</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (MaintenanceRequest req : maintenanceRequests) { %>
                                <tr>
                                    <td><%= req.getMainID() %></td>
                                    <td><%= req.getMainCat() %></td>
                                    <td><%= req.getMainDescription() %></td>
                                    <td><%= dateFormat.format(req.getMainDate()) %></td>
                                    <td><%= req.getStaffName() != null ? req.getStaffName() : "N/A" %></td>
                                    <td><%= req.getStaffNumber() != null ? req.getStaffNumber() : "N/A" %></td>
                                    <td>
                                        <span class="status-<%= req.getMainStatus().toLowerCase().replace(" ", "-") %>">
                                            <%= req.getMainStatus() %>
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
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