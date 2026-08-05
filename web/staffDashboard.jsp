<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Staff Dashboard - Polytechnic Hostel</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        /* Main Content Styles */
        .main-dashboard {
            flex: 1;
            padding: 30px;
            background-color: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(5px);
        }

        .welcome-box h1 {
            font-size: 28px;
            margin-bottom: 20px;
            color: var(--primary);
        }

        .welcome-box h1 span {
            color: var(--dark);
        }

        .dashboard-content-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        @media (max-width: 1200px) {
            .dashboard-content-container {
                grid-template-columns: 1fr;
            }
        }

        .info-box {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border: 1px solid rgba(169, 68, 66, 0.2);
            height: 100%;
        }

        .info-box h2 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--primary);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--grey);
        }

        .profile-details p {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px dashed var(--grey);
        }

        .profile-details p strong {
            color: var(--primary);
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
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
            .main-dashboard {
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
            .main-dashboard {
                padding: 15px;
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
            <form action="staffLogout.jsp" method="post">
                <button type="submit" class="logout-btn">Log Out</button>
            </form>
        </nav>
    </header>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="staff-card">
                <img src="img/staff.png" alt="Staff Photo" class="profile-pic"/>
                <h3><%= session.getAttribute("staffName") %></h3>
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
                <a href="ViewAppealServlet" class="dashboard-button <c:if test="${requestScope.currentPage eq 'ViewAppealServlet'}">active</c:if>">
                    <i class='bx bxs-message-alt-error'></i> Appeal Requests
                </a>
            </div>
            <footer class="sidebar-footer">
                <small>&copy; 2023 Polytechnic Hostel</small>
            </footer>
        </aside>

        <main class="main-dashboard">
            <section class="welcome-box">
                <h1>Welcome Back, <span><%= session.getAttribute("staffName") %></span></h1>
                
                <!-- Dashboard Content Container -->
                <div class="dashboard-content-container">
                    <!-- Profile Information Container -->
                    <div class="info-box">
                        <h2>Profile Information</h2>
                        <div class="profile-details">
                            <p><strong>Staff ID:</strong> <span><%= session.getAttribute("staffId") %></span></p>
                            <p><strong>Full Name:</strong> <span><%= session.getAttribute("staffName") %></span></p>
                            <p><strong>Email:</strong> <span><%= session.getAttribute("staffEmail") != null ? session.getAttribute("staffEmail") : "Not set" %></span></p>
                            <p><strong>Phone Number:</strong> <span><%= session.getAttribute("staffNumber") != null ? session.getAttribute("staffNumber") : "Not set" %></span></p>
                            <p><strong>Position:</strong> <span><%= session.getAttribute("staffPosition") != null ? session.getAttribute("staffPosition") : "Not set" %></span></p>                       
                        </div>
                    </div>
                    
                    <!-- Maintenance Requests Chart Container -->
                    <div class="info-box">
                        <h2>Maintenance Requests</h2>
                        <div class="chart-container">
                            <canvas id="maintenanceChart"></canvas>
                        </div>
                    </div>
                </div>
            </section>
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
        // Maintenance Requests Pie Chart
        const maintenanceCtx = document.getElementById('maintenanceChart').getContext('2d');
        const maintenanceChart = new Chart(maintenanceCtx, {
            type: 'pie',
            data: {
                labels: ['Pending', 'In Progress', 'Completed'],
                datasets: [{
                    data: [
                        ${pendingCount != null ? pendingCount : 0},
                        ${inProgressCount != null ? inProgressCount : 0},
                        ${completedCount != null ? completedCount : 0}
                        
                    ],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(255, 159, 64, 0.7)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw || 0;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = Math.round((value / total) * 100);
                                return `${label}: ${value} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>