<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Admin Dashboard - Rooms</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
  <style>
    /* Your existing CSS styles here */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body, html {
      height: 100%;
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
    }
    
    /* ... (keep all your existing styles) ... */
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
        <button class="change-links button" onclick="window.location.href='maintenance.jsp'">VIEW MAINTENANCE</button>
        <button class="change-links button" onclick="window.location.href='staff.jsp'">VIEW STAFF</button>
        <button class="change-links button" onclick="window.location.href='student.jsp'">VIEW STUDENT</button>
        <button class="change-links button active" onclick="window.location.href='room.jsp'">VIEW ROOM</button>
        <button class="change-links button" onclick="window.location.href='bills.jsp'">VIEW BILLS</button>
      </div>
    </div>

    <div class="main-dashboard">
      <div class="welcome-box">
        <h1>Room Details</h1>
        <div class="table-header">
          <div class="title-container">
            <h2 class="table-title">List of Room</h2>
            <button class="update-room-btn" onclick="window.location.href='updateRoom.jsp'">Update Room</button>
          </div>
          <form class="search-container" action="RoomServlet" method="GET">
            <input type="text" name="searchQuery" placeholder="Search..." class="search-input">
            <button type="submit" class="search-button">Search</button>
          </form>
        </div>
        
        <div class="filter-buttons">
          <button class="filter-btn ${empty param.hostel || param.hostel eq 'Hang Tuah' ? 'active' : ''}" 
                  onclick="window.location.href='room.jsp?hostel=Hang Tuah'">Hang Tuah</button>
          <button class="filter-btn ${param.hostel eq 'Tun Fatimah' ? 'active' : ''}" 
                  onclick="window.location.href='room.jsp?hostel=Tun Fatimah'">Tun Fatimah</button>
        </div>
        
        <div class="table-scroll-container">
          <table>
            <thead>
              <tr>
                <th>Room ID</th>
                <th>Capacity</th>
                <th>Status</th>
                <th>Occupants</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="room" items="${roomList}">
                <tr>
                  <td>${room.roomId}</td>
                  <td>${room.capacity}</td>
                  <td class="${room.status eq 'FULL' ? 'status-booked' : 'status-available'}">
                    ${room.status}
                  </td>
                  <td>${room.currentOccupants}/${room.capacity}</td>
                  <td>
                    <c:if test="${room.status ne 'FULL'}">
                      <a href="RoomServlet?action=assign&id=${room.roomId}">Assign Student</a>
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