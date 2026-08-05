<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Dashboard - Maintenance</title>
  <link rel="stylesheet" href="style.css" />
  <style>
    .info-row {
      display: flex;
      gap: 20px;
      margin-bottom: 20px;
    }
    .logout-btn {
      background-color: #444;
      color: white;
      padding: 8px 20px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      width: auto;
    }
    .button {
      background-color: #894142 !important;
      border-radius: 25px;
      margin-bottom: 10px;
      color: white;
      font-weight: bold;
    }
    .sidebar, .notice-panel {
      background-color: #c85454 !important;
    }
    footer hr {
      margin: 0;
      border: none;
      border-top: 1px solid #ccc;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
      background-color: rgba(137, 65, 66, 0.95);
      color: white;
      border-radius: 10px;
      overflow: hidden;
    }
    th, td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #7a3a3a;
    }
    th {
      background-color: #7a3a3a;
    }
    tr:hover {
      background-color: rgba(122, 58, 58, 0.5);
    }
    .status-complete {
      color: #4CAF50;
    }
    .status-incomplete {
      color: #ffcc00;
    }
    .table-container {
      padding: 20px;
    }
    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      padding: 0 20px;
    }
    .search-container {
      display: flex;
      gap: 10px;
    }
    .search-input {
      padding: 8px 15px;
      border-radius: 20px;
      border: none;
      background-color: #7a3a3a;
      color: white;
      width: 200px;
    }
    .search-input::placeholder {
      color: #ddd;
    }
    .search-button {
      background-color: #894142;
      color: white;
      border: none;
      padding: 8px 15px;
      border-radius: 20px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <header>
    <div class="logo">
      <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" />
    </div>
    <button class="logout-btn" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">Log Out</button>
  </header>
  <div class="dashboard-container">
    <div class="sidebar">
      <div>
        <div class="student-card">
          <img src="${pageContext.request.contextPath}/img/student.png" alt="Profile" class="profile-pic" />
          <h3>${sessionScope.user.name}</h3>
          <p>${sessionScope.user.id}</p>
          <p>${sessionScope.user.role}</p>
        </div>
        <button class="change-links button active" onclick="window.location.href='maintenance.jsp'">VIEW MAINTENANCE</button>
        <button class="change-links button" onclick="window.location.href='staff.jsp'">VIEW STAFF</button>
        <button class="change-links button" onclick="window.location.href='student.jsp'">VIEW STUDENT</button>
        <button class="change-links button" onclick="window.location.href='room.jsp'">VIEW ROOM</button>
        <button class="change-links button" onclick="window.location.href='bills.jsp'">VIEW BILLS</button>
      </div>
    </div>

    <div class="main-dashboard">
      <div class="welcome-box">
        <h1>Maintenance Details</h1>
        <div class="table-header">
          <h2 class="table-title">List of Maintenance</h2>
          <form class="search-container" action="MaintenanceServlet" method="GET">
            <input type="text" name="searchQuery" placeholder="Search..." class="search-input">
            <button type="submit" class="search-button">Search</button>
          </form>
        </div>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Student ID</th>
                <th>MAINTENANCE ID</th>
                <th>ROOM ID</th>
                <th>MAINTENANCE DETAILS</th>
                <th>Staff Name</th>
                <th>Status</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="maintenance" items="${maintenanceList}">
                <tr>
                  <td>${maintenance.studentId}</td>
                  <td>${maintenance.maintenanceId}</td>
                  <td>${maintenance.roomId}</td>
                  <td>${maintenance.details}</td>
                  <td>${maintenance.staffName}</td>
                  <td class="${maintenance.status == 'COMPLETE' ? 'status-complete' : 'status-incomplete'}">
                    ${maintenance.status}
                  </td>
                  <td>
                    <c:if test="${maintenance.status != 'COMPLETE'}">
                      <a href="MaintenanceServlet?action=complete&id=${maintenance.maintenanceId}">Mark Complete</a>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="notice-panel">
      <h2>Notice</h2>
      <ul class="notice-list">
        <li>🎉 Events & Celebrations</li>
        <li>Cultural Day / Fest Notices</li>
        <li>Sports Day / E-Sports Tournament</li>
        <li>Freshers' Orientation Schedule</li>
        <li>Graduation Ceremony Details</li>
        <li>Student Club Recruitment / Open Day</li>
        <li>Photography / Art / Debate Competitions</li>
        <li>Personal Growth & Support</li>
        <li>Mental Health Awareness Events</li>
        <li>Motivational Quotes / "Student of the Week" Spotlight</li>
        <li>Counseling Sessions Schedule</li>
        <li>Time Management or Study Skills Workshops</li>
        <li>Language Exchange or Toastmasters Meetups</li>
      </ul>
    </div>
  </div>
  <footer>
    <hr />
    &copy; 2023 Titan Company
  </footer>
</body>
</html>