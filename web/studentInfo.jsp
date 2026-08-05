<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Student Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />

</head>
<body>
  <header>
    <div class="logo">
      <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" />
    </div>
    <nav>
      <button class="logout-btn" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">Log Out</button>
    </nav>
  </header>

  <div class="dashboard-container">
    <!-- Left Sidebar -->
    <aside class="sidebar">
      <div class="student-card">
        <img src="${pageContext.request.contextPath}/img/student.png" alt="Student Photo" class="profile-pic"/>
        <h3>${student.name}</h3>
        <p>${student.id}<br/>Student</p>
      </div>
      <div class="button-group">
        <a href="applyCollege.jsp" class="dashboard-button">Apply College</a>
        <a href="roomBooking.jsp" class="dashboard-button">Room Booking</a>
        <a href="requestMaintenance.jsp" class="dashboard-button">Request Maintenance</a>
        <a href="updateProfile.jsp" class="dashboard-button">Update Profile</a>
        <a href="bills.jsp" class="dashboard-button">Bills</a>
      </div>
     
      <footer class="sidebar-footer">
        <small>&copy; 2023 Titan Company</small>
      </footer>
    </aside>

    <!-- Main Content -->
    <main class="main-dashboard">
      <section class="welcome-box">
        <h1>Welcome Back, <span>${student.firstName}</span></h1>
        <div class="info-sections">
          <div class="info-box">
            <h2>Info</h2>
            <p>Name: ${student.fullName}</p>
            <p>ID: ${student.id}</p>
            <p>Phone Number: ${student.phone}</p>
            <p>Email: ${student.email}</p>
            <p>Emergency Number: ${student.emergencyContact}</p>
            <p>Gender: ${student.gender}</p>
            <p>Household Income: RM${student.householdIncome}</p>
          </div>
          <div class="info-box">
            <h2>Academics</h2>
            <p>Current Semester: ${student.currentSemester}</p>
            <p>CGPA: ${student.cgpa}</p>
          </div>
          <div class="info-box">
            <h2>Merits</h2>
            <img src="${pageContext.request.contextPath}/img/merit-chart.png" alt="Merit Chart" class="merit-chart"/>
            <p>Total Merits: ${student.totalMerits}</p>
          </div>
        </div>
        <div class="activities-box">
          <h2>Activities Joined</h2>
          <ul>
            <c:forEach var="activity" items="${student.activities}">
              <li>${activity.code} - ${activity.name}</li>
            </c:forEach>
          </ul>
        </div>
      </section>

      <section class="room-info-box">
        <h2>Room Info</h2>
        <c:choose>
          <c:when test="${not empty student.room}">
            <p>Block: ${student.block}</p>
            <p>Room: ${student.room}</p>
          </c:when>
          <c:otherwise>
            <p>No room assigned yet</p>
            <a href="roomBooking.jsp" class="dashboard-button" style="display: inline-block; margin-top: 10px;">Book a Room</a>
          </c:otherwise>
        </c:choose>
      </section>
    </main>

    <!-- Right Notices Panel -->
    <aside class="notice-panel">
      <h2>Notice</h2>
      <ul class="notice-list">
        <c:forEach var="notice" items="${notices}">
          <li>${notice}</li>
        </c:forEach>
      </ul>
    </aside>
  </div>
</body>
</html>