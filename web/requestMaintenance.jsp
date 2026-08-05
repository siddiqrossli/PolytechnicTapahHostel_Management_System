<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Maintenance - Polytechnic Hostel</title>
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
            display: flex;
            justify-content: left;
            align-items: flex-start;
        }

        .container {
            background-color: var(--white);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 1500px;
            height: 825px; /* Keep consistent with original */
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

        .info-box {
            margin-bottom: 25px;
            background-color: var(--light);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid var(--grey);
        }

        .info-item {
            font-size: 16px;
            margin: 8px 0;
        }

        .info-item span {
            font-weight: bold;
        }

        label {
            display: block;
            margin-top: 20px;
            margin-bottom: 8px;
            font-weight: bold;
            color: var(--dark);
        }

        select,
        textarea {
            width: 100%;
            padding: 10px 12px;
            font-size: 15px;
            border-radius: 6px;
            border: 1px solid var(--grey);
            background-color: var(--white);
            resize: vertical;
        }

        textarea::placeholder {
            color: var(--dark-grey);
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

        /* NEW STYLE: For the "No room" message */
        .no-room-message {
            text-align: center;
            padding: 40px 20px;
            background-color: var(--light);
            border-radius: 8px;
            border: 1px solid var(--grey);
            margin-top: 50px;
        }

        .no-room-message h2 {
            color: var(--primary);
            margin-bottom: 15px;
        }

        .no-room-message p {
            font-size: 16px;
            color: var(--dark-grey);
            line-height: 1.5;
        }

        .no-room-message a {
            display: inline-block;
            margin-top: 20px;
            background-color: var(--secondary);
            color: var(--white);
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .no-room-message a:hover {
            background-color: #307ac3;
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
                <%-- Apply College button, use class for styling --%>
                <a href="ApplyCollegeServlet" class="dashboard-button <c:if test="${requestScope.currentPage eq 'applyCollege'}">current-page-button</c:if>">
                    <i class='bx bxs-school'></i> Apply College
                </a>
                <%-- Request Maintenance button with highlighting logic --%>
                <a href="requestMaintenance" class="dashboard-button <c:if test="${requestScope.currentPage eq 'requestMaintenance'}">current-page-button</c:if>">
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
                    <h1>Request Maintenance</h1>
                    <a href="viewMaintenanceStatus" class="status-btn">View Status</a>
                </div>

                <c:if test="${not empty requestScope.message}">
                    <div class="message ${requestScope.messageType == 'success' ? 'success' : 'error'}">
                        ${requestScope.message}
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${requestScope.hasRoom}">
                        <%-- Display form if student has a room --%>
                        <div class="info-box">
                            <div class="info-item"><span>Name:</span> ${sessionScope.studName}</div>
                            <div class="info-item"><span>ID:</span> ${requestScope.studentId}</div>
                            <div class="info-item"><span>Phone:</span> ${requestScope.phoneNumber}</div>
                            <div class="info-item"><span>Room:</span> ${requestScope.roomNumber}</div>
                        </div>

                        <form action="requestMaintenance" method="post" onsubmit="return validateForm()">
                            <label for="category">Issue Category</label>
                            <select id="category" name="category" required>
                                <option value="">-- Select --</option>
                                <option value="Plumbing Issue" <c:if test="${requestScope.category eq 'Plumbing Issue'}">selected</c:if>>Plumbing Issue</option>
                                <option value="Electrical Issue" <c:if test="${requestScope.category eq 'Electrical Issue'}">selected</c:if>>Electrical Issue</option>
                                <option value="Furniture Damage" <c:if test="${requestScope.category eq 'Furniture Damage'}">selected</c:if>>Furniture Damage</option>
                                <option value="Air-Conditioning" <c:if test="${requestScope.category eq 'Air-Conditioning'}">selected</c:if>>Air-Conditioning</option>
                                <option value="Key-Room Missing" <c:if test="${requestScope.category eq 'Key-Room Missing'}">selected</c:if>>Key-Room Missing</option> <%-- CORRECTED LINE --%>
                                <option value="Pest Control" <c:if test="${requestScope.category eq 'Pest Control'}">selected</c:if>>Pest Control</option>
                                <option value="Cleaning Services" <c:if test="${requestScope.category eq 'Cleaning Services'}">selected</c:if>>Cleaning Services</option>
                                <option value="Other" <c:if test="${requestScope.category eq 'Other'}">selected</c:if>>Other</option>
                            </select>

                            <label for="details">Maintenance Details</label>
                            <textarea id="details" name="details" rows="5" placeholder="Describe the issue..." required>${requestScope.details}</textarea>

                            <div class="btn-group">
                                <button type="submit" class="btn-submit">Submit Report</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <%-- Display message if student does not have a room --%>
                        <div class="no-room-message">
                            <h2>No Room Assigned</h2>
                            <p>You currently do not have a room assigned. To request maintenance services, please apply for a room first.</p>
                            <a href="ApplyCollegeServlet">Apply for a Room</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <aside class="notice-panel">
            <h2>Notices</h2>
            <ul class="notice-list">
                <c:choose>
                    <c:when test="${not empty requestScope.notices}">
                        <c:forEach items="${requestScope.notices}" var="notice">
                            <li>${notice.name} - ${notice.date}</li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li>No notices available.</li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </aside>
    </div>

    <script>
        function validateForm() {
            var category = document.getElementById("category").value;
            var details = document.getElementById("details").value;
            var messageDiv = document.querySelector(".message");

            // Clear previous message
            if (messageDiv) {
                messageDiv.remove();
            }

            if (category === "" || details.trim() === "") {
                var container = document.querySelector(".container");
                var newMessageDiv = document.createElement("div");
                newMessageDiv.classList.add("message", "error");
                newMessageDiv.textContent = "Please select a category and provide maintenance details.";
                container.insertBefore(newMessageDiv, container.firstChild.nextSibling); // Insert after header-row

                // Scroll to the top to show the message
                window.scrollTo(0, 0);
                return false; // Prevent form submission
            }
            return true; // Allow form submission
        }
    </script>
</body>
</html>