<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Ensure staff is logged in
    if (session.getAttribute("staffId") == null) {
        response.sendRedirect("staffLogin.jsp");
        return;
    }

    String staffId = (String) session.getAttribute("staffId");
    String staffName = "";
    String staffNumber = "";
    String staffEmail = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String JDBC_URL = "jdbc:mysql://localhost:3306/hostel_management?zeroDateTimeBehavior=convertToNull&allowPublicKeyRetrieval=true&useSSL=false";
    String DB_USERNAME = "farish";
    String DB_PASSWORD = "kakilangit";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(JDBC_URL, DB_USERNAME, DB_PASSWORD);

        String sql = "SELECT staffName, staffNumber, staffEmail FROM staff WHERE staffID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, staffId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            staffName = rs.getString("staffName");
            staffNumber = rs.getString("staffNumber");
            staffEmail = rs.getString("staffEmail");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("message", "Database error: " + e.getMessage());
        request.setAttribute("messageType", "error");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        request.setAttribute("message", "System error: JDBC driver not found.");
        request.setAttribute("messageType", "error");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile - Polytechnic Hostel</title>
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

        .form-container {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 10px;
            max-width: 1500px;
            width: 100%;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .form-container h1 {
            background-color: var(--white);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1500px;
            height: 100%;
            max-height: 825px; /* Consider if you need a fixed height or min-height */;
            color: var(--primary);
            font-size: 24px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-weight: 600;
            color: var(--dark);
            display: block;
            margin-bottom: 6px;
        }

        .form-group input[type="text"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid var(--grey);
            font-size: 15px;
            color: var(--dark);
        }

        .form-group input[readonly] {
            background-color: #e9e9e9;
            cursor: not-allowed;
        }

        .form-group input:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: var(--primary);
            color: var(--white);
            font-weight: 600;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-size: 16px;
        }

        .btn-submit:hover {
            background-color: var(--primary-dark);
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
            text-align: center;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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
            .form-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="logo" onclick="window.location.href='otherStaffDashboard.jsp'">
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
                <h3><%= staffName %></h3>
                <p>Staff ID: <%= session.getAttribute("staffId") %></p>
            </div>
            <div class="button-group">
                <a href="updateStaffProfile" class="dashboard-button active <c:if test="${requestScope.currentPage eq 'updateStaffProfile'}">active</c:if>">
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
            </div>
            <footer class="sidebar-footer">
                <small>&copy; 2023 Polytechnic Hostel</small>
            </footer>
        </aside>

        <main class="main-content">
            <div class="form-container">
                <h1>Update Your Profile</h1>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="message <%= request.getAttribute("messageType") %>">
                        <%= request.getAttribute("message") %>
                    </div>
                <% } %>

                <form action="updateStaffProfile" method="post">
                    <div class="form-group">
                        <label for="staffId">Staff ID</label>
                        <input type="text" id="staffId" name="staffId" value="<%= staffId %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="staffName">Full Name</label>
                        <input type="text" id="staffName" name="staffName" value="<%= staffName %>" required>
                    </div>
                    <div class="form-group">
                        <label for="staffNumber">Phone Number</label>
                        <input type="text" id="staffNumber" name="staffNumber" value="<%= staffNumber %>" required>
                    </div>
                    <div class="form-group">
                        <label for="staffEmail">Email</label>
                        <input type="email" id="staffEmail" name="staffEmail" value="<%= staffEmail %>" required>
                    </div>
                    <button type="submit" class="btn-submit">Update Profile</button>
                </form>
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