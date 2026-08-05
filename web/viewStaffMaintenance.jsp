<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Maintenance Requests - Polytechnic Hostel</title>
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
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 15px;
            margin-bottom: 20px;
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

        .status-form select {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid var(--grey);
            background-color: var(--white);
            color: var(--dark);
            margin-right: 10px;
        }

        .status-form button {
            padding: 8px 15px;
            background-color: var(--primary);
            color: var(--white);
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .status-form button:hover {
            background-color: var(--primary-dark);
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

        .no-records {
            text-align: center;
            color: var(--dark-grey);
            padding: 20px;
            font-size: 16px;
        }

        .btn-back {
            display: inline-block;
            padding: 10px 25px;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }

        .btn-back:hover {
            background-color: var(--primary-dark);
        }

        .status-pending {
            color: #ffc107;
            font-weight: bold;
        }

        .status-in-progress {
            color: #17a2b8;
            font-weight: bold;
        }

        .status-completed {
            color: #28a745;
            font-weight: bold;
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

        @media (max-width: 1200px) {
            .dashboard-container {
                flex-direction: column;
            }
            .sidebar {
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
            }
            .top-bar {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
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
            <button class="logout-btn" onclick="window.location.href='staffLogout'">Log Out</button>
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
                <a href="viewStaffMaintenance" class="dashboard-button active <c:if test="${requestScope.currentPage eq 'viewStaffMaintenance'}">active</c:if>">
                    <i class='bx bxs-wrench'></i> Maintenance
                </a>
                <a href="ViewAppealServlet" class="dashboard-button <c:if test="${requestScope.currentPage eq 'ViewAppealServlet'}">active</c:if>">
                    <i class='bx bxs-message-alt-error'></i> Appeal Requests
                </a>
            </div>
            <footer class="sidebar-footer">
                <small>&copy; 2023 Polytechnic Hostel</small>
            </footer>
        </aside>

        <main class="main-content">
            <div class="container">
                <div class="top-bar">
                    <h2>Assigned Maintenance Requests</h2>
                </div>

                <c:if test="${not empty message}">
                    <div class="message ${messageType == 'error' ? 'error-message' : 'success-message'}">${message}</div>
                </c:if>

                <div class="table-container">
                    <c:choose>
                        <c:when test="${not empty maintenanceRequests}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Request ID</th>
                                        <th>Category</th>
                                        <th>Description</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th>Student</th>
                                        <th>Room</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="req" items="${maintenanceRequests}">
                                        <tr>
                                            <td>${req.mainID}</td>
                                            <td>${req.mainCat}</td>
                                            <td>${req.mainDescription}</td>
                                            <td><fmt:formatDate value="${req.mainDate}" pattern="yyyy-MM-dd"/></td>
                                            <td class="status-${req.mainStatus.toLowerCase().replace(' ', '-')}">
                                                ${req.mainStatus}
                                            </td>
                                            <td>${req.studentName}</td>
                                            <td>${req.roomID}</td>
                                            <td>
                                                <form action="UpdateMaintenanceStatusServlet" method="post" class="status-form">
                                                    <input type="hidden" name="mainID" value="${req.mainID}" />
                                                    <select name="newStatus">
                                                        <option value="Pending" <c:if test="${req.mainStatus == 'Pending'}">selected</c:if>>Pending</option>
                                                        <option value="In Progress" <c:if test="${req.mainStatus == 'In Progress'}">selected</c:if>>In Progress</option>
                                                        <option value="Completed" <c:if test="${req.mainStatus == 'Completed'}">selected</c:if>>Completed</option>
                                                    </select>
                                                    <button type="submit">Update</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="no-records">No maintenance requests assigned to you.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

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