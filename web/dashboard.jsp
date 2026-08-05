<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%
    // Debug prints
    HttpSession currentDashboardSession = request.getSession(false);
    System.out.println("--- dashboard.jsp Debug ---");
    if (currentDashboardSession != null) {
        System.out.println("Session ID: " + currentDashboardSession.getId());
        System.out.println("studentId: " + currentDashboardSession.getAttribute("studentId"));
        System.out.println("studentName: " + currentDashboardSession.getAttribute("studName"));
        // Add debug for other session attributes you expect
    } else {
        System.out.println("WARNING: Session is NULL!");
    }
    System.out.println("--------------------------");
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <title>Student Dashboard - Polytechnic Hostel</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        .dashboard-button i {
            font-size: 20px;
        }

        /* Active button styling */
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

        .info-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-box {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border: 1px solid rgba(169, 68, 66, 0.2);
        }

        .info-box h2 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--primary);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--grey);
        }

        .info-box p {
            margin-bottom: 8px;
            font-size: 14px;
        }

        .merit-chart {
            width: 100%;
            height: auto;
            border-radius: 5px;
        }

        .activities-box {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            border: 1px solid rgba(169, 68, 66, 0.2);
        }

        .activities-box h2 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--primary);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--grey);
        }

        .activities-box ul {
            list-style-type: none;
        }

        .activities-box li {
            padding: 10px 0;
            border-bottom: 1px solid var(--grey);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .activities-box li:before {
            content: "•";
            color: var(--primary);
            font-size: 20px;
        }

        .activities-box li:last-child {
            border-bottom: none;
        }

        .room-info-box {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border: 1px solid rgba(169, 68, 66, 0.2);
        }

        .room-info-box h2 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--primary);
            padding-bottom: 10px;
            border-bottom: 1px solid var(--grey);
        }

        .room-info-box p {
            margin-bottom: 8px;
            font-size: 14px;
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
            .info-sections {
                grid-template-columns: 1fr;
            }
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

        <main class="main-dashboard">
            <section class="welcome-box">
                <h1>Welcome Back, <span>${sessionScope.studName}</span></h1>
                <div class="info-sections">
                    <div class="info-box">
                        <h2>Info</h2>
                        <p>Name: ${sessionScope.studName}</p>
                        <p>ID: ${sessionScope.studentId}</p>
                        <c:if test="${not empty sessionScope.studNumber}">
                            <p>Phone Number: ${sessionScope.studNumber}</p>
                        </c:if>
                        <c:if test="${not empty sessionScope.studEmergencyNumber}">
                            <p>Emergency Number: ${sessionScope.studEmergencyNumber}</p>
                        </c:if>
                        <c:if test="${not empty sessionScope.studGender}">
                            <p>Gender: ${sessionScope.studGender}</p>
                        </c:if>
                        <c:if test="${not empty sessionScope.houseIncome}">
                            <p>Household Income: RM${sessionScope.houseIncome}</p>
                        </c:if>
                    </div>
                    <div class="info-box">
                        <h2>Academics</h2>
                        <c:if test="${not empty sessionScope.studCGPA}">
                            <p>CGPA: ${sessionScope.studCGPA}</p>
                        </c:if>
                    </div>
                    <div class="info-box">
                        <h2>Merits</h2>
                        <canvas id="meritChart" width="180" height="180"></canvas>
                        <div style="text-align: center; font-weight: bold;">
                            Total: ${sessionScope.totalMerit}
                        </div>
                    </div>

                </div>
                <div class="activities-box">
                    <h2>Activities Joined</h2>
                    <ul>
                        <c:forEach items="${sessionScope.activities}" var="activity">
                            <li>${activity}</li>
                        </c:forEach>
                    </ul>
                </div>
            </section>

            <section class="room-info-box">
                <h2>Room Info</h2>
                <c:if test="${not empty sessionScope.roomID}">
                    <%
                        String roomID = (String) session.getAttribute("roomID");
                        String Block = "Unknown";
                        if (roomID != null && roomID.length() >= 2) { // Added null check and length check
                            if (roomID.substring(0, 2).equals("TF"))
                                Block = "Tun Fatimah";
                            else if (roomID.substring(0, 2).equals("HT"))
                                Block = "Hang Tuah";
                        }
                    %>
                    <p>Block: <%=Block%> </p>
                </c:if>
                <c:if test="${not empty sessionScope.roomID}">
                    <p>Room Number: ${sessionScope.roomID}</p>
                </c:if>
                <c:if test="${not empty sessionScope.roomType}">
                    <p>Room Type: ${sessionScope.roomType}</p>
                </c:if>
                <c:if test="${not empty sessionScope.roomStatus}">
                    <p>Status: ${sessionScope.roomStatus}</p>
                </c:if>
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
        const labels = [];
        const data = [];

        <c:forEach var="entry" items="${sessionScope.meritMap}">
            labels.push("${entry.key}");
            data.push(${entry.value});
        </c:forEach>

    const ctx = document.getElementById('meritChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                label: 'Merit Points',
                data: data,
                backgroundColor: [
                    '#FFCDD2', // lightest red
                    '#EF9A9A',
                    '#E57373',
                    '#EF5350',
                    '#F44336', // standard red
                    '#D32F2F',
                    '#C62828', // dark red
                    '#B71C1C'  // darkest red
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: false, // <--- TURN OFF RESPONSIVENESS
            maintainAspectRatio: false, // <--- ALLOW CUSTOM SIZE
            cutout: '70%', // Donut-style
            plugins: {
                legend: {
                    display: true,
                    position: 'bottom',
                },
            },
            
        }
    });
</script>

</body>
</html>