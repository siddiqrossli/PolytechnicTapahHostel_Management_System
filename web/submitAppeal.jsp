<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Appeal - Polytechnic Hostel</title>
    <!-- Boxicons -->
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <!-- Google Fonts -->
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
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .container {
            background-color: var(--white);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1500px;
            height: 825px;
        }

        h2 {
            color: var(--primary);
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 600;
        }

        p {
            font-size: 15px;
            color: var(--dark);
            margin-bottom: 8px;
        }

        strong {
            color: var(--black);
        }

        label {
            display: block;
            margin: 20px 0 8px;
            font-weight: 500;
            color: var(--dark);
        }

        textarea {
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid var(--grey);
            font-size: 14px;
            resize: vertical;
            background-color: var(--white);
        }

        textarea:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        .btn {
            background-color: var(--primary);
            color: var(--white);
            border: none;
            padding: 12px 24px;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 20px;
            transition: background-color 0.3s ease;
            font-weight: 600;
        }

        .btn:hover {
            background-color: var(--primary-dark);
        }

        .btn-secondary {
            background-color: var(--light);
            color: var(--primary);
            border: 1px solid var(--primary);
            margin-left: 15px;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 16px;
            display: inline-block;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: var(--primary);
            color: var(--white);
        }

        .btn-group {
            margin-top: 25px;
            display: flex;
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
            }
            .btn-group {
                flex-direction: column;
                gap: 10px;
            }
            .btn-secondary {
                margin-left: 0;
                margin-top: 10px;
                text-align: center;
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
        <!-- Left Sidebar -->
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
                <a href="ApplyCollegeServlet" class="dashboard-button" style="background-color: var(--primary); color: var(--white);">
                    <i class='bx bxs-school'></i> Apply College
                </a>
                <a href="requestMaintenance" class="dashboard-button">
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

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <h2>Merit Not Enough</h2>

                <p><strong>Name:</strong> ${studName}</p>
                <p><strong>ID:</strong> ${studentId}</p>
                <p><strong>Phone Number:</strong> ${studNumber}</p>
                <p><strong>CGPA:</strong> ${studCGPA}</p>
                <p><strong>Total Merit:</strong> ${totalMerit}</p>

                <form action="SubmitAppealServlet" method="post">
                    <label for="appealReason">Reason for Appeal:</label>
                    <textarea name="appealReason" id="appealReason" rows="5" required placeholder="Explain your reason..."></textarea>

                    <div class="btn-group">
                        <button type="submit" class="btn">Submit Appeal</button>
                        
                    </div>
                </form>
            </div>
        </main>

        <!-- Right Notice Panel -->
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